Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3GOXfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:35:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:34523 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3GOXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:35:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Rob Landley <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>, Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Documentation: update references to v2.6.x in development-process
Date: Mon, 15 Jul 2013 19:34:44 -0400
Message-ID: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last mainline release of a v2.6.x kernel was back in May 2011.
Here we update references to be 3.x based, which also means updating
some dates and statistics.

Also update information pertaining to longterm releases.  Here I have
intentionally left out any mention of the v2.6.34.x longterm, since I
will EOL it before this patch makes it in the v3.12 kernel anyway.

Finally, update the links to mmotm and linux-next trees, as neither of
them worked and pre-dated the kernel.org server rebuilds.

Cc: Rob Landley <rob@landley.net>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 4823577..0c943a1 100644
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
+	3.10	June 30, 2013
+	3.9	April 28, 2013
+	3.8	February 18, 2013
+	3.7	December 10, 2012
+	3.6	September 30, 2012
+	3.5	July 21, 2012
+
+Every 3.x release is a major kernel release with new features, internal
+API changes, and more.  A typical 3.x release can contain over 10,000
+changesets with changes to several hundred thousand lines of code.  3.x is
 thus the leading edge of Linux kernel development; the kernel uses a
 rolling development model which is continually integrating major changes.
 
@@ -43,9 +43,9 @@ detail later on).
 
 The merge window lasts for approximately two weeks.  At the end of this
 time, Linus Torvalds will declare that the window is closed and release the
-first of the "rc" kernels.  For the kernel which is destined to be 2.6.40,
+first of the "rc" kernels.  For the kernel which is destined to be 3.12,
 for example, the release which happens at the end of the merge window will
-be called 2.6.40-rc1.  The -rc1 release is the signal that the time to
+be tagged v3.12-rc1.  The -rc1 release is the signal that the time to
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
+As an example, here is how the 3.10 development cycle went (all dates in
+2013):
 
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
+	April 28	3.9 stable release
+	May 11		3.10-rc1, merge window closes
+	May 20		3.10-rc2
+	May 26		3.10-rc3
+	June 2		3.10-rc4
+	June 8		3.10-rc5
+	June 15		3.10-rc6
+	June 22		3.10-rc7
+	June 30		3.10 stable release
 
 How do the developers decide when to close the development cycle and create
 the stable release?  The most significant metric used is the list of
@@ -92,34 +91,41 @@ release is made.  In the real world, this kind of perfection is hard to
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
-
-	October 10	2.6.36 stable release
-	November 22	2.6.36.1
-	December 9	2.6.36.2
-	January 7	2.6.36.3
-	February 17	2.6.36.4
-
-2.6.36.4 was the final stable update for the 2.6.36 release.
+for example, the 3.7 kernel's history (2012/2013) looked like:
+
+	December 10	v3.7 stable release
+	December 17	v3.7.1
+	January  11	v3.7.2
+	January  17	v3.7.3
+	January  21	v3.7.4
+	January  27	v3.7.5
+	February 3	v3.7.6
+	February 11	v3.7.7
+	February 14	v3.7.8
+	February 17	v3.7.9
+	February 27	v3.7.10
+
+3.7.10 was the final stable update for the 3.7 release.
 
 Some kernels are designated "long term" kernels; they will receive support
 for a longer period.  As of this writing, the current long term kernels
 and their maintainers are:
 
-	2.6.27	Willy Tarreau		(Deep-frozen stable kernel)
-	2.6.32	Greg Kroah-Hartman
-	2.6.35	Andi Kleen		(Embedded flag kernel)
+	2.6.32	Willy Tarreau
+	3.0	Greg Kroah-Hartman
+	3.2	Ben Hutchings
+	3.4	Greg Kroah-Hartman
 
 The selection of a kernel for long-term support is purely a matter of a
 maintainer having the need and the time to maintain that release.  There
@@ -199,8 +205,8 @@ involved.
 2.3: HOW PATCHES GET INTO THE KERNEL
 
 There is exactly one person who can merge patches into the mainline kernel
-repository: Linus Torvalds.  But, of the over 9,500 patches which went
-into the 2.6.38 kernel, only 112 (around 1.3%) were directly chosen by Linus
+repository: Linus Torvalds.  But, of the over 13,500 patches which went
+into the 3.10 kernel, only 70 (around 0.5%) were directly chosen by Linus
 himself.  The kernel project has long since grown to a size where no single
 developer could possibly inspect and select every patch unassisted.  The
 way the kernel developers have addressed this growth is through the use of
@@ -276,7 +282,7 @@ mainline get there via -mm.
 The current -mm patch is available in the "mmotm" (-mm of the moment)
 directory at:
 
-	http://userweb.kernel.org/~akpm/mmotm/
+	http://www.ozlabs.org/~akpm/mmotm/
 
 Use of the MMOTM tree is likely to be a frustrating experience, though;
 there is a definite chance that it will not even compile.
@@ -287,7 +293,7 @@ the mainline is expected to look like after the next merge window closes.
 Linux-next trees are announced on the linux-kernel and linux-next mailing
 lists when they are assembled; they can be downloaded from:
 
-	http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/
+	https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
 
 Some information about linux-next has been gathered at:
 
-- 
1.8.1.2

