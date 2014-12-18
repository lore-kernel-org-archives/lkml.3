Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaLRBOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:14:01 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:59494 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaLRBN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:13:59 -0500
From: Stefan Beller <sbeller@google.com>
To: corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Cc: Stefan Beller <sbeller@google.com>
Subject: [PATCH] Documentation/SubmittingPatches: unify whitespace/tabs for the DCO
Date: Wed, 17 Dec 2014 17:13:56 -0800
Message-Id: <1418865236-19218-1-git-send-email-sbeller@google.com>
X-Mailer: git-send-email 2.2.0.31.gad78000.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Developers Certificate of Origin has a mixture of tabs and white
spaces which is annoying to view if your editor explicitly views white
space characters.

Also remove any trailing white spaces found in the file.

Signed-off-by: Stefan Beller <sbeller@google.com>
---

Hi,

I found this issue when being asked to patch 
Documentation/SubmittingPatches in git.git, so I'll
send the fix to linux as well where the DCO originally 
comes from.

Thanks,
Stefan

 Documentation/SubmittingPatches | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 1fa1caa..1671ce3 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -223,9 +223,9 @@ Do not send more than 15 patches at once to the vger mailing lists!!!
 
 
 Linus Torvalds is the final arbiter of all changes accepted into the
-Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>. 
+Linux kernel.  His e-mail address is <torvalds@linux-foundation.org>.
 He gets a lot of e-mail, so typically you should do your best to -avoid-
-sending him e-mail. 
+sending him e-mail.
 
 Patches which are bug fixes, are "obvious" changes, or similarly
 require little discussion should be sent or CC'd to Linus.  Patches
@@ -387,11 +387,11 @@ can certify the below:
             person who certified (a), (b) or (c) and I have not modified
             it.
 
-	(d) I understand and agree that this project and the contribution
-	    are public and that a record of the contribution (including all
-	    personal information I submit with it, including my sign-off) is
-	    maintained indefinitely and may be redistributed consistent with
-	    this project or the open source license(s) involved.
+        (d) I understand and agree that this project and the contribution
+            are public and that a record of the contribution (including all
+            personal information I submit with it, including my sign-off) is
+            maintained indefinitely and may be redistributed consistent with
+            this project or the open source license(s) involved.
 
 then you just add a line saying
 
@@ -401,7 +401,7 @@ using your real name (sorry, no pseudonyms or anonymous contributions.)
 
 Some people also put extra tags at the end.  They'll just be ignored for
 now, but you can do this to mark internal company procedures or just
-point out some special detail about the sign-off. 
+point out some special detail about the sign-off.
 
 If you are a subsystem or branch maintainer, sometimes you need to slightly
 modify patches you receive in order to merge them, because the code is not
-- 
2.2.0.31.gad78000.dirty

