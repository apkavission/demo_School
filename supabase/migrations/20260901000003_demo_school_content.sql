-- ===========================================================================
-- Three places to learn, from one codebase.
--
-- A K-12 school, a competitive-exam coaching institute and a degree college.
-- Same code, three different institutions — different names, palettes, courses,
-- teachers, fees and answers.
--
-- Every name, fee and person is **invented**, and reviews are labelled as
-- examples on the page. A fabricated parent testimonial presented as genuine is
-- the one thing a demonstration must not do — and in education it is also the
-- claim people check.
--
-- Fees are written the way institutions actually write them — per year, per
-- term, "on assessment" — because a single number is a promise none of them make.
-- ===========================================================================

insert into demo_school.variants
  (slug, name, industry_label, business_name, tagline, description,
   theme, contact, features, default_mode, visibility, is_default, is_active, sort_order)
values
(
  'k12', 'K-12 School', 'School',
  'Northfield Public School',
  'Small classes, and somebody who knows your child',
  'A CBSE school from nursery to class twelve, capped at thirty to a class, with the same class teacher through each stage.',
  jsonb_build_object(
    'light', jsonb_build_object(
      'accent', '#1d4ed8', 'accentFg', '#ffffff', 'accentSoft', '#e6edfd',
      'bg', '#f4f6fb', 'surface', '#ffffff', 'text', '#0b1020', 'muted', '#4a5578'),
    'dark', jsonb_build_object(
      'accent', '#93c5fd', 'accentFg', '#0a1330', 'accentSoft', '#111a33',
      'bg', '#06080f', 'surface', '#101422', 'text', '#e9edf8', 'muted', '#98a3c0'),
    'headingFont', 'Sora', 'bodyFont', 'Inter', 'radius', 'lg'
  ),
  jsonb_build_object(
    'phone', '+91 90000 33001', 'whatsapp', '+919000033001',
    'email', 'admissions@northfield.example', 'address', 'Danapur Road, Patna 801503',
    'hours', jsonb_build_object('weekdays', '8:00 am – 3:30 pm', 'saturday', '8:00 am – 12:30 pm', 'sunday', 'Closed'),
    'mapQuery', 'Danapur Patna'
  ),
  jsonb_build_object('bookingLabel', 'Book a campus visit', 'showEmergency', false),
  'light', 'public', true, true, 10
),
(
  'coaching', 'Coaching Institute', 'Competitive exams',
  'Axiom Classes',
  'Twenty in a batch, and the same teacher every day',
  'JEE and NEET preparation in batches of twenty, with weekly tests that are actually discussed rather than only ranked.',
  jsonb_build_object(
    'light', jsonb_build_object(
      'accent', '#b45309', 'accentFg', '#ffffff', 'accentSoft', '#fbf0e0',
      'bg', '#faf7f2', 'surface', '#ffffff', 'text', '#1a1206', 'muted', '#6d5a3f'),
    'dark', jsonb_build_object(
      'accent', '#fbbf24', 'accentFg', '#2a1d05', 'accentSoft', '#2b2110',
      'bg', '#0b0805', 'surface', '#16110b', 'text', '#f6efe2', 'muted', '#b3a389'),
    'headingFont', 'Sora', 'bodyFont', 'Inter', 'radius', 'md'
  ),
  jsonb_build_object(
    'phone', '+91 90000 33002', 'whatsapp', '+919000033002',
    'email', 'join@axiomclasses.example', 'address', 'Bhikhna Pahari, Patna 800004',
    'hours', jsonb_build_object('weekdays', '7:00 am – 8:00 pm', 'saturday', '7:00 am – 8:00 pm', 'sunday', '9:00 am – 1:00 pm'),
    'mapQuery', 'Bhikhna Pahari Patna'
  ),
  jsonb_build_object('bookingLabel', 'Book a trial class', 'showEmergency', false),
  'light', 'public', false, true, 20
),
(
  'college', 'Degree College', 'Higher education',
  'Meridian Institute of Commerce',
  'A degree, and the internship that makes it count',
  'Three-year degrees in commerce and management, with a placement cell that starts working in the second year rather than the last month.',
  jsonb_build_object(
    'light', jsonb_build_object(
      'accent', '#0f766e', 'accentFg', '#ffffff', 'accentSoft', '#e2f2f0',
      'bg', '#f4f8f7', 'surface', '#ffffff', 'text', '#0a1614', 'muted', '#4a635f'),
    'dark', jsonb_build_object(
      'accent', '#5eead4', 'accentFg', '#032622', 'accentSoft', '#0c2724',
      'bg', '#050a09', 'surface', '#101715', 'text', '#e6f2f0', 'muted', '#8fa8a3'),
    'headingFont', 'Sora', 'bodyFont', 'Inter', 'radius', 'sm'
  ),
  jsonb_build_object(
    'phone', '+91 90000 33003', 'whatsapp', '+919000033003',
    'email', 'admissions@meridian.example', 'address', 'Ashok Rajpath, Patna 800005',
    'hours', jsonb_build_object('weekdays', '9:30 am – 5:00 pm', 'saturday', '9:30 am – 1:00 pm', 'sunday', 'Closed'),
    'mapQuery', 'Ashok Rajpath Patna'
  ),
  jsonb_build_object('bookingLabel', 'Apply for admission', 'showEmergency', false),
  'light', 'public', false, true, 30
)
on conflict (slug) do nothing;

insert into demo_school.nav_items (variant_id, label, href, sort_order)
select v.id, item.label, item.href, item.sort_order
from demo_school.variants v
cross join (values
  ('Courses', '/courses', 10),
  ('Faculty', '/people', 20),
  ('Reviews', '/reviews', 30),
  ('Questions', '/questions', 40),
  ('Contact', '/contact', 50)
) as item(label, href, sort_order)
on conflict (variant_id, label) do nothing;

insert into demo_school.courses (variant_id, slug, name, summary, description, price_label, meta_label, icon, sort_order)
select v.id, c.slug, c.name, c.summary, c.description, c.price_label, c.meta_label, c.icon, c.sort_order
from demo_school.variants v
join (values
  ('k12', 'pre-primary', 'Pre-primary', 'Nursery to UKG.', 'Three years of play-based learning with two adults in every room, and no homework. Parents are shown the term''s plan rather than told about it afterwards.', '₹48,000 a year', 'Nursery – UKG', 'baby', 10),
  ('k12', 'primary', 'Primary school', 'Classes one to five.', 'Thirty to a class with one class teacher throughout the year. Reading is tested every term and anybody falling behind gets extra time before it becomes a problem.', '₹62,000 a year', 'Classes 1–5', 'book-open', 20),
  ('k12', 'middle', 'Middle school', 'Classes six to eight.', 'Subject teachers begin here, with a form tutor who stays the same for all three years — which is the person a parent actually rings.', '₹74,000 a year', 'Classes 6–8', 'users', 30),
  ('k12', 'senior', 'Senior school', 'Classes nine and ten.', 'Board preparation with fortnightly tests, and a written subject-choice conversation in class nine rather than a form filled in a hurry.', '₹86,000 a year', 'Classes 9–10', 'graduation-cap', 40),
  ('k12', 'senior-secondary', 'Senior secondary', 'Classes eleven and twelve.', 'Science, commerce and humanities streams. Class sizes drop to twenty-four, and every student gets a named teacher for board-year guidance.', '₹98,000 a year', 'Classes 11–12', 'award', 50),

  ('coaching', 'jee-two-year', 'JEE — two year', 'Starts in class eleven.', 'Physics, chemistry and mathematics across two years, in batches of twenty. Weekly tests are discussed the next day rather than handed back with a rank.', '₹1,45,000', 'Two years', 'atom', 10),
  ('coaching', 'jee-one-year', 'JEE — one year', 'For class twelve and droppers.', 'The same syllabus compressed, with a diagnostic test first so nobody joins a batch moving faster than they can follow.', '₹95,000', 'One year', 'zap', 20),
  ('coaching', 'neet-two-year', 'NEET — two year', 'Biology-heavy, from class eleven.', 'Biology daily, physics and chemistry on alternate days, and a monthly full-length paper under real timing.', '₹1,38,000', 'Two years', 'stethoscope', 30),
  ('coaching', 'foundation', 'Foundation — classes 9 and 10', 'Before the pressure starts.', 'Three days a week alongside school, built to make class eleven survivable rather than to start the exam two years early.', '₹52,000 a year', 'Classes 9–10', 'seedling', 40),
  ('coaching', 'test-series', 'Test series only', 'For students coached elsewhere.', 'Twenty full-length papers with the same discussion sessions our own batches get. No teaching, no pressure to join.', '₹18,000', '20 papers', 'file-text', 50),

  ('college', 'bcom', 'B.Com (Honours)', 'Three years, commerce.', 'Accounting, taxation and corporate law, with a compulsory eight-week internship after the second year that the placement cell arranges.', '₹68,000 a year', 'Three years', 'calculator', 10),
  ('college', 'bba', 'BBA', 'Three years, management.', 'Marketing, operations and finance, taught with cases rather than only notes, and a live project with a local business in the final year.', '₹74,000 a year', 'Three years', 'briefcase', 20),
  ('college', 'bca', 'BCA', 'Three years, computing.', 'Programming from the first week, databases in year two, and a final-year project supervised by somebody who has shipped software.', '₹78,000 a year', 'Three years', 'code', 30),
  ('college', 'mcom', 'M.Com', 'Two years, evenings available.', 'Advanced accounting and research methods, with an evening batch for students already working.', '₹56,000 a year', 'Two years', 'library', 40),
  ('college', 'certificate', 'Certificate in Tally and GST', 'Twelve weeks, evenings.', 'The short course our own students take before an internship. Open to anybody, and priced so it is worth doing on its own.', '₹9,500', '12 weeks', 'receipt', 50)
) as c(variant, slug, name, summary, description, price_label, meta_label, icon, sort_order)
  on c.variant = v.slug
on conflict (variant_id, slug) do nothing;

insert into demo_school.faculty (variant_id, slug, full_name, role_label, qualification, bio, years_experience, sort_order)
select v.id, f.slug, f.full_name, f.role_label, f.qualification, f.bio, f.years, f.sort_order
from demo_school.variants v
join (values
  ('k12', 'radha-krishnan', 'Radha Krishnan', 'Principal', 'M.Ed, twenty-two years teaching', 'Teaches one class herself every week, which is how she knows what the timetable is actually like.', 22, 10),
  ('k12', 'samir-bose', 'Samir Bose', 'Head of senior school', 'M.Sc Physics, B.Ed', 'Runs the subject-choice conversations in class nine, and is honest when a stream is the wrong fit.', 16, 20),
  ('k12', 'anjali-verma', 'Anjali Verma', 'Head of primary', 'M.A, B.Ed', 'Built the reading programme that catches the children who are quietly falling behind.', 14, 30),

  ('coaching', 'nitin-agarwal', 'Nitin Agarwal', 'Physics', 'B.Tech, IIT Kanpur', 'Teaches every batch himself rather than recording once and playing it back, which is why batch sizes are twenty.', 15, 10),
  ('coaching', 'shalini-rao', 'Shalini Rao', 'Chemistry', 'M.Sc, PhD Organic Chemistry', 'Runs the discussion sessions the day after each test, which is where the marks actually come from.', 12, 20),
  ('coaching', 'imran-ali', 'Imran Ali', 'Mathematics', 'M.Sc Mathematics', 'Keeps a list of every question a student got wrong twice, and builds the revision from it.', 10, 30),

  ('college', 'p-mukherjee', 'P. Mukherjee', 'Head of commerce', 'M.Com, PhD, CA (inter)', 'Twenty years in practice before teaching, and marks papers the way an auditor reads accounts.', 20, 10),
  ('college', 'divya-shah', 'Divya Shah', 'Placement cell', 'MBA', 'Starts working with students in the second year, not the last month — which is the whole difference.', 9, 20),
  ('college', 'arun-pillai', 'Arun Pillai', 'Computing', 'M.Tech', 'Supervises final-year projects and refuses to accept one that only runs on the student''s own laptop.', 11, 30)
) as f(variant, slug, full_name, role_label, qualification, bio, years, sort_order)
  on f.variant = v.slug
on conflict (variant_id, slug) do nothing;

insert into demo_school.testimonials (variant_id, author, role_label, quote, rating, sort_order)
select v.id, t.author, t.role_label, t.quote, t.rating, t.sort_order
from demo_school.variants v
join (values
  ('k12', 'Sample review', 'Parent, class 4', 'The class teacher rang me before I rang her. That has never happened at any school we have been to.', 5, 10),
  ('k12', 'Sample review', 'Parent, class 9', 'The subject-choice meeting was an hour long and nobody tried to push him towards science.', 5, 20),
  ('k12', 'Sample review', 'Parent, pre-primary', 'No homework in nursery, and they explained why. I stopped worrying about it after a term.', 4, 30),

  ('coaching', 'Sample review', 'Student, JEE two-year', 'Twenty in a batch means the teacher notices when you have stopped following. That is the whole thing.', 5, 10),
  ('coaching', 'Sample review', 'Parent', 'They gave a diagnostic test before taking the fee and told us honestly which batch he belonged in.', 5, 20),
  ('coaching', 'Sample review', 'Student, test series', 'I was coached elsewhere and only took the papers. The discussion sessions were better than my own classes.', 4, 30),

  ('college', 'Sample review', 'Student, B.Com', 'The internship after second year turned into the job offer in third. That was not luck.', 5, 10),
  ('college', 'Sample review', 'Parent', 'Fees are published per year with nothing added later. Every other college we visited had a list of extras.', 5, 20),
  ('college', 'Sample review', 'Student, BCA', 'My project supervisor made me deploy it somewhere real. Painful, and the reason I got interviews.', 5, 30)
) as t(variant, author, role_label, quote, rating, sort_order)
  on t.variant = v.slug;

insert into demo_school.faqs (variant_id, question, answer, sort_order)
select v.id, f.question, f.answer, f.sort_order
from demo_school.variants v
join (values
  ('k12', 'When do admissions open?', 'Forms for the next session open in November and close in January. Later applications are taken only where a seat has come free.', 10),
  ('k12', 'Is there an entrance test?', 'From class two upwards, and it is a placement check rather than a filter — it tells the class teacher where to start.', 20),
  ('k12', 'What is included in the fee?', 'Tuition, books, and the annual day. Transport and meals are separate and priced on the fee sheet.', 30),
  ('k12', 'How big are the classes?', 'Thirty to a class up to class ten, twenty-four in eleven and twelve. That is the cap, not the average.', 40),

  ('coaching', 'Can I attend a class before joining?', 'Yes — one full class, in the batch you would actually join, not a demonstration lecture.', 10),
  ('coaching', 'Are the batches recorded?', 'No. Every batch is taught live, which is why they are capped at twenty and why the fee is what it is.', 20),
  ('coaching', 'What happens if I miss a class?', 'A doubt session on Sunday covers what was missed. It is not a recording, so come with questions.', 30),
  ('coaching', 'Is the fee refundable?', 'Within two weeks of joining, in full, minus the material cost. After that it is not, and we say so before you pay.', 40),

  ('college', 'Is the degree recognised?', 'Affiliated to the state university, and the certificate is issued by them rather than by us.', 10),
  ('college', 'How do placements work?', 'The cell starts in the second year with internships, and the same companies do the final-year hiring. Last year''s figures are on the notice board, not on a banner.', 20),
  ('college', 'Are evening classes available?', 'For M.Com and the certificate course. The degree programmes are daytime only.', 30),
  ('college', 'Is there a hostel?', 'No. We keep a list of vetted accommodation nearby and will share it with parents on request.', 40)
) as f(variant, question, answer, sort_order)
  on f.variant = v.slug;
