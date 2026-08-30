-- ===========================================================================
-- Copy a whole business.
--
-- **The button that was missing.** Adding a fourth variant meant writing SQL by
-- hand, every time, and it sat on this demo’s not-done list with the same
-- one-line explanation: the copy has to walk every table in dependency order
-- and remap the ids.
--
-- ---------------------------------------------------------------------------
-- **Why it is a database function and not application code.**
--
-- It is one transaction. A copy done in six round trips from the application
-- leaves half a business behind the first time a connection drops -- a variant
-- row with no content, which looks finished and is not. Half is worse than
-- none.
--
-- ---------------------------------------------------------------------------
-- **What it deliberately does not copy: enquiries, messages and share links.**
--
-- Those belong to the business that received them. A new variant opening with
-- somebody else’s enquiries in its panel is alarming rather than convenient,
-- and a copied share link would hand a second prospect a URL we thought we had
-- given to one person.
--
-- **The copy arrives switched off and link-only.** A new business appearing
-- live the instant somebody presses copy is the wrong default: it carries the
-- original’s name and words until it is edited, which is exactly when nobody
-- should be able to find it.
-- ===========================================================================

create or replace function demo_school.clone_variant(
  p_source uuid,
  p_slug   text,
  p_name   text
)
returns uuid
language plpgsql security definer
set search_path = demo_school, public
as $$
declare
  new_id uuid;
begin
  if not demo_school.is_super_admin() then
    raise exception 'Only a super admin may copy a business.';
  end if;

  if exists (select 1 from demo_school.variants where slug = p_slug) then
    raise exception 'That address is already taken.';
  end if;

  /* The business itself. Everything about it except its identity, its default
     flag and its visibility, none of which may be copied. */
  insert into demo_school.variants (
    slug, name, industry_label, business_name, tagline, description,
    logo_light_id, logo_dark_id, og_image_id,
    theme, contact, features,
    default_mode, allow_mode_toggle,
    visibility, is_default, is_active, sort_order
  )
  select
    p_slug, p_name, v.industry_label, p_name, v.tagline, v.description,
    v.logo_light_id, v.logo_dark_id, v.og_image_id,
    v.theme, v.contact, v.features,
    v.default_mode, v.allow_mode_toggle,
    'link_only', false, false, v.sort_order + 1
  from demo_school.variants v
  where v.id = p_source
  returning id into new_id;

  if new_id is null then
    raise exception 'There is no business to copy.';
  end if;

  insert into demo_school.nav_items (variant_id, label, href, sort_order, is_active)
  select new_id, label, href, sort_order, is_active
  from demo_school.nav_items where variant_id = p_source;

  insert into demo_school.courses (
    variant_id, slug, name, summary, description, icon, image_id,
    price_label, meta_label, status, sort_order
  )
  select new_id, slug, name, summary, description, icon, image_id,
         price_label, meta_label, status, sort_order
  from demo_school.courses where variant_id = p_source;

  insert into demo_school.faculty (
    variant_id, slug, full_name, role_label, qualification, bio,
    photo_id, years_experience, availability, status, sort_order
  )
  select new_id, slug, full_name, role_label, qualification, bio,
         photo_id, years_experience, availability, status, sort_order
  from demo_school.faculty where variant_id = p_source;

  insert into demo_school.testimonials
    (variant_id, author, role_label, quote, rating, photo_id, status, sort_order)
  select new_id, author, role_label, quote, rating, photo_id, status, sort_order
  from demo_school.testimonials where variant_id = p_source;

  insert into demo_school.faqs (variant_id, question, answer, status, sort_order)
  select new_id, question, answer, status, sort_order
  from demo_school.faqs where variant_id = p_source;

  return new_id;
end;
$$;

grant execute on function demo_school.clone_variant(uuid, text, text) to authenticated;

comment on function demo_school.clone_variant(uuid, text, text) is
  'Copy a business and all its content. Enquiries, messages and share links stay with the original.';
