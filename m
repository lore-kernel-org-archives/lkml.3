Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaA1GTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:19:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61492 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaA1GTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:19:45 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: corbet@lwn.net, rob@landley.net, enselic@gmail.com, jkosina@suse.cz
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Documentation/development-process: update release history to 3.x
Date: Tue, 28 Jan 2014 15:19:30 +0900
Message-Id: <1390889970-7866-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just update release history examples from 2.6.x to 3.x

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/development-process/2.Process | 74 ++++++++++++++---------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 2e06179..5e85037 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -14,16 +14,16 @@ The kernel developers use a loosely time-based release process, with a new
 major kernel release happening every two or three months.  The recent
 release history looks like this:
 
-	2.6.38	March 14, 2011
-	2.6.37	January 4, 2011
-	2.6.36	October 20, 2010
-	2.6.35	August 1, 2010
-	2.6.34	May 15, 2010
-	2.6.33	February 24, 2010
-
-Every 2.6.x release is a major kernel release with new features, internal
-API changes, and more.  A typical 2.6 release can contain nearly 10,000
-changesets with changes to several hundred thousand lines of code.  2.6 is
+	3.13	January 20, 2014
+	3.12	November 4, 2013
+	3.11	September 2, 2013
+	3.10	July 1, 2013
+	3.9	April 29, 2013
+	3.8	February 19, 2013
+
+Every 3.x release is a major kernel release with new features, internal
+API changes, and more.  A typical 3.x release can contain nearly 10,000
+changesets with changes to several hundred thousand lines of code.  3.x is
 thus the leading edge of Linux kernel development; the kernel uses a
 rolling development model which is continually integrating major changes.
 
@@ -43,9 +43,9 @@ detail later on).
 
 The merge window lasts for approximately two weeks.  At the end of this
 time, Linus Torvalds will declare that the window is closed and release the
-first of the "rc" kernels.  For the kernel which is destined to be 2.6.40,
+first of the "rc" kernels.  For the kernel which is destined to be 3.14,
 for example, the release which happens at the end of the merge window will
-be called 2.6.40-rc1.  The -rc1 release is the signal that the time to
+be called 3.14-rc1.  The -rc1 release is the signal that the time to
 merge new features has passed, and that the time to stabilize the next
 kernel has begun.
 
@@ -62,22 +62,21 @@ add at any time).
 As fixes make their way into the mainline, the patch rate will slow over
 time.  Linus releases new -rc kernels about once a week; a normal series
 will get up to somewhere between -rc6 and -rc9 before the kernel is
-considered to be sufficiently stable and the final 2.6.x release is made.
+considered to be sufficiently stable and the final 3.x release is made.
 At that point the whole process starts over again.
 
-As an example, here is how the 2.6.38 development cycle went (all dates in
-2011):
+As an example, here is how the 3.13 development cycle went:
 
-	January 4	2.6.37 stable release
-	January 18	2.6.38-rc1, merge window closes
-	January 21	2.6.38-rc2
-	February 1	2.6.38-rc3
-	February 7	2.6.38-rc4
-	February 15	2.6.38-rc5
-	February 21	2.6.38-rc6
-	March 1		2.6.38-rc7
-	March 7		2.6.38-rc8
-	March 14	2.6.38 stable release
+	November 4, 2013	3.12 stable release
+	November 22, 2013	3.13-rc1, merge window closes
+	November 29, 2013	3.13-rc2
+	December 6, 2013	3.13-rc3
+	December 15, 2013	3.13-rc4
+	December 22, 2013	3.13-rc5
+	December 30, 2013	3.13-rc6
+	January 5, 2014		3.13-rc7
+	January 12, 2014	3.13-rc8
+	January 20, 2014	3.13 stable release
 
 How do the developers decide when to close the development cycle and create
 the stable release?  The most significant metric used is the list of
@@ -92,34 +91,35 @@ release is made.  In the real world, this kind of perfection is hard to
 achieve; there are just too many variables in a project of this size.
 There comes a point where delaying the final release just makes the problem
 worse; the pile of changes waiting for the next merge window will grow
-larger, creating even more regressions the next time around.  So most 2.6.x
+larger, creating even more regressions the next time around.  So most 3.x
 kernels go out with a handful of known regressions though, hopefully, none
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
 "stable team," currently consisting of Greg Kroah-Hartman.  The stable team
-will release occasional updates to the stable release using the 2.6.x.y
+will release occasional updates to the stable release using the 3.x.y
 numbering scheme.  To be considered for an update release, a patch must (1)
 fix a significant bug, and (2) already be merged into the mainline for the
 next development kernel.  Kernels will typically receive stable updates for
 a little more than one development cycle past their initial release.  So,
-for example, the 2.6.36 kernel's history looked like:
+for example, the 3.10 kernel's history looked like(all dates in 2013):
 
-	October 10	2.6.36 stable release
-	November 22	2.6.36.1
-	December 9	2.6.36.2
-	January 7	2.6.36.3
-	February 17	2.6.36.4
+	September 2	3.11 stable release
+	September 14	3.11.1
+	September 27	3.11.2
+	October 1	3.11.3
+	October 5	3.11.4
 
-2.6.36.4 was the final stable update for the 2.6.36 release.
+3.11.10 was released on November 29 and it was the final stable update for
+the 3.11 release.
 
 Some kernels are designated "long term" kernels; they will receive support
 for a longer period.  As of this writing, the current long term kernels
 and their maintainers are:
 
-	2.6.27	Willy Tarreau		(Deep-frozen stable kernel)
-	2.6.32	Greg Kroah-Hartman
-	2.6.35	Andi Kleen		(Embedded flag kernel)
+	3.10	Greg Kroah-Hartman
+	3.4	Greg Kroah-Hartman
+	3.2	Ben Hutchings
 
 The selection of a kernel for long-term support is purely a matter of a
 maintainer having the need and the time to maintain that release.  There
-- 
1.8.1.2

