Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHQSlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:41:00 -0400
Received: from mo-online.de ([89.238.66.174]:52744 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaHQSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:24 -0400
Date: Sun, 17 Aug 2014 20:30:58 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 9/9] [typo] spelling, punctuation in Documentation/...
Message-ID: <20140817183058.GJ4077@mo-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... being
- HOWTO
- ManagementStyle
- SecurityBugs
- SubmittingpAtches

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 Documentation/HOWTO             | 22 +++++++++++-----------
 Documentation/ManagementStyle   | 16 ++++++++--------
 Documentation/SecurityBugs      |  2 +-
 Documentation/SubmittingPatches |  4 ++--
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 57cf5ef..7b6a938 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -41,7 +41,7 @@ divisions and floating point are not allowed.  It can sometimes be
 difficult to understand the assumptions the kernel has on the toolchain
 and the extensions that it uses, and unfortunately there is no
 definitive reference for them.  Please check the gcc info pages (`info
-gcc`) for some information on them.
+gcc') for some information on them.
 
 Please remember that you are trying to learn how to work with the
 existing development community.  It is a diverse group of people, with
@@ -105,7 +105,7 @@ required reading:
     and send a patch, including (but not limited to):
        - Email contents
        - Email format
-       - Who to send it to
+       - Whom to send it to
     Following these rules will not guarantee success (as all patches are
     subject to scrutiny for content and style), but not following them
     will almost always prevent it.
@@ -234,9 +234,9 @@ process is as follows:
     Linus, usually the patches that have already been included in the
     -next kernel for a few weeks.  The preferred way to submit big changes
     is using git (the kernel's source management tool, more information
-    can be found at http://git-scm.com/) but plain patches are also just
+    can be found at http://git-scm.com/), but plain patches are also just
     fine.
-  - After two weeks a -rc1 kernel is released it is now possible to push
+  - After two weeks an -rc1 kernel is released; it is now possible to push
     only patches that do not include new features that could affect the
     stability of the whole kernel.  Please note that a whole new driver
     (or filesystem) might be accepted after -rc1 because there is no
@@ -248,15 +248,15 @@ process is as follows:
   - A new -rc is released whenever Linus deems the current git tree to
     be in a reasonably sane state adequate for testing.  The goal is to
     release a new -rc kernel every week.
-  - Process continues until the kernel is considered "ready", the
+  - This process continues until the kernel is considered "ready", the
     process should last around 6 weeks.
   - Known regressions in each release are periodically posted to the 
     linux-kernel mailing list.  The goal is to reduce the length of 
     that list to zero before declaring the kernel to be "ready," but, in
-    the real world, a small number of regressions often remain at 
+    the real world, a small number of regressions often remains at 
     release time.
 
-It is worth mentioning what Andrew Morton wrote on the linux-kernel
+It is worth mentioning what Andrew Morton wrote on the Linux-kernel
 mailing list about kernel releases:
 	"Nobody knows when a kernel will be released, because it's
 	released according to perceived bug status, not according to a
@@ -293,10 +293,10 @@ daily and represent the current state of Linus' tree.  They are more
 experimental than -rc kernels since they are generated automatically
 without even a cursory glance to see if they are sane.
 
-Subsystem Specific kernel trees and patches
+Subsystem specific kernel trees and patches
 -------------------------------------------
-The maintainers of the various kernel subsystems --- and also many
-kernel subsystem developers --- expose their current state of
+The maintainers of the various kernel subsystems -- and also many
+kernel subsystem developers -- expose their current state of
 development in source repositories.  That way, others can see what is
 happening in the different areas of the kernel.  In areas where
 development is rapid, a developer may be asked to base his submissions
@@ -355,7 +355,7 @@ your skills, and other developers will be aware of your presence. Fixing
 bugs is one of the best ways to get merits among other developers, because
 not many people like wasting time fixing other people's bugs.
 
-To work in the already reported bug reports, go to http://bugzilla.kernel.org.
+To work on the already reported bug reports, go to http://bugzilla.kernel.org.
 If you want to be advised of the future bug reports, you can subscribe to the
 bugme-new mailing list (only new bug reports are mailed here) or to the
 bugme-janitor mailing list (every change in the bugzilla is mailed here)
diff --git a/Documentation/ManagementStyle b/Documentation/ManagementStyle
index a211ee8..b68f726 100644
--- a/Documentation/ManagementStyle
+++ b/Documentation/ManagementStyle
@@ -2,7 +2,7 @@
                 Linux kernel management style
 
 This is a short document describing the preferred (or made up, depending
-on who you ask) management style for the linux kernel.  It's meant to
+on who you ask) management style for the Linux kernel.  It's meant to
 mirror the CodingStyle document to some degree, and mainly written to
 avoid answering (*) the same (or similar) questions over and over again. 
 
@@ -11,7 +11,7 @@ simple coding style rules, so this document may or may not have anything
 to do with reality.  It started as a lark, but that doesn't mean that it
 might not actually be true. You'll have to decide for yourself.
 
-Btw, when talking about "kernel manager", it's all about the technical
+Btw., when talking about "kernel manager", it's all about the technical
 lead persons, not the people who do traditional management inside
 companies.  If you sign purchase orders or you have any clue about the
 budget of your group, you're almost certainly not a kernel manager. 
@@ -37,11 +37,11 @@ actually true.
 The name of the game is to _avoid_ having to make a decision.  In
 particular, if somebody tells you "choose (a) or (b), we really need you
 to decide on this", you're in trouble as a manager.  The people you
-manage had better know the details better than you, so if they come to
+manage had better known the details better than you, so if they come to
 you for a technical decision, you're screwed.  You're clearly not
 competent to make that decision for them. 
 
-(Corollary:if the people you manage don't know the details better than
+(Corollary: if the people you manage don't know the details better than
 you, you're also screwed, although for a totally different reason. 
 Namely that you are in the wrong job, and that _they_ should be managing
 your brilliance instead). 
@@ -80,10 +80,10 @@ easily undone.
 
 It turns out that some people have trouble with this approach, for two
 reasons:
- - admitting you were an idiot is harder than it looks.  We all like to
+ - Admitting you were an idiot is harder than it looks.  We all like to
    maintain appearances, and coming out in public to say that you were
    wrong is sometimes very hard indeed. 
- - having somebody tell you that what you worked on for the last year
+ - Having somebody tell you that what you worked on for the last year
    wasn't worthwhile after all can be hard on the poor lowly engineers
    too, and while the actual _work_ was easy enough to undo by just
    deleting it, you may have irrevocably lost the trust of that
@@ -109,12 +109,12 @@ sure as hell shouldn't encourage them by promising them that what they
 work on will be included.  Make them at least think twice before they
 embark on a big endeavor. 
 
-Remember: they'd better know more about the details than you do, and
+Remember: they'd better known more about the details than you do, and
 they usually already think they have the answer to everything.  The best
 thing you can do as a manager is not to instill confidence, but rather a
 healthy dose of critical thinking on what they do. 
 
-Btw, another way to avoid a decision is to plaintively just whine "can't
+Btw., another way to avoid a decision is to plaintively just whine "can't
 we just do both?" and look pitiful.  Trust me, it works.  If it's not
 clear which approach is better, they'll eventually figure it out.  The
 answer may end up being that both teams get so frustrated by the
diff --git a/Documentation/SecurityBugs b/Documentation/SecurityBugs
index a660d49..5c8e0eb 100644
--- a/Documentation/SecurityBugs
+++ b/Documentation/SecurityBugs
@@ -7,7 +7,7 @@ Linux kernel security team.
 
 The Linux kernel security team can be contacted by email at
 <security@kernel.org>.  This is a private list of security officers
-who will help verify the bug report and develop and release a fix.
+who will help to verify the bug report and develop and release a fix.
 It is possible that the security team will bring in extra help from
 area maintainers to understand and fix the security vulnerability.
 
diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 0a523c9..a358031 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -227,8 +227,8 @@ Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
 He gets a lot of e-mail, so typically you should do your best to -avoid-
 sending him e-mail. 
 
-Patches which are bug fixes, are "obvious" changes, or similarly
-require little discussion should be sent or CC'd to Linus.  Patches
+Patches, which are bug fixes, are "obvious" changes, or similarly
+require little discussion, should be sent or CC'd to Linus.  Patches
 which require discussion or do not have a clear advantage should
 usually be sent first to linux-kernel.  Only after the patch is
 discussed should the patch then be submitted to Linus.
-- 
1.8.5.5

