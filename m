Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaDAQKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:10:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38578 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaDAQKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:10:38 -0400
From: Felipe Balbi <balbi@ti.com>
To: <rob@landley.net>
CC: <clm@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] Documentation: SubmittingPatches: mention our new Facebook group
Date: Tue, 1 Apr 2014 11:08:35 -0500
Message-ID: <1396368515-8547-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <533AD000.307@fb.com>
References: <533AD000.307@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a Facebook group thanks to Chris Mason,
it's best to mention it in our Documentation so people
know where to go.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/SubmittingPatches | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31..a3ce332 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -155,7 +155,22 @@ be able to justify all violations that remain in your patch.
 
 
 
-5) Select e-mail destination.
+5) Post your changes to our Facebook Group.
+
+We have a Facebook group at [1] where you *must* post your patches
+to prior to getting them accepted by any maintainer. In the near
+future, Facebook will become our only tool for patch reviewing
+since the Kernel community has decided to embrace Web 2.0.
+
+Make sure to join the group and start posting your patches there,
+instead of spamming everybody's inbox with countless patches each
+day.
+
+[1] https://www.facebook.com/groups/linuxpatches/
+
+
+
+6) Select e-mail destination.
 
 Look through the MAINTAINERS file and the source code, and determine
 if your change applies to a specific subsystem of the kernel, with
@@ -184,7 +199,7 @@ discussed should the patch then be submitted to Linus.
 
 
 
-6) Select your CC (e-mail carbon copy) list.
+7) Select your CC (e-mail carbon copy) list.
 
 Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
 
@@ -225,7 +240,7 @@ Trivial patches must qualify for one of the following rules:
 
 
 
-7) No MIME, no links, no compression, no attachments.  Just plain text.
+8) No MIME, no links, no compression, no attachments.  Just plain text.
 
 Linus and other kernel developers need to be able to read and comment
 on the changes you are submitting.  It is important for a kernel
@@ -248,7 +263,7 @@ you to re-send them using MIME.
 See Documentation/email-clients.txt for hints about configuring
 your e-mail client so that it sends your patches untouched.
 
-8) E-mail size.
+9) E-mail size.
 
 When sending patches to Linus, always follow step #7.
 
@@ -259,7 +274,7 @@ server, and provide instead a URL (link) pointing to your patch.
 
 
 
-9) Name your kernel version.
+10) Name your kernel version.
 
 It is important to note, either in the subject line or in the patch
 description, the kernel version to which this patch applies.
@@ -269,7 +284,7 @@ Linus will not apply it.
 
 
 
-10) Don't get discouraged.  Re-submit.
+11) Don't get discouraged.  Re-submit.
 
 After you have submitted your change, be patient and wait.  If Linus
 likes your change and applies it, it will appear in the next version
@@ -295,7 +310,7 @@ When in doubt, solicit comments on linux-kernel mailing list.
 
 
 
-11) Include PATCH in the subject
+12) Include PATCH in the subject
 
 Due to high e-mail traffic to Linus, and to linux-kernel, it is common
 convention to prefix your subject line with [PATCH].  This lets Linus
@@ -304,7 +319,7 @@ e-mail discussions.
 
 
 
-12) Sign your work
+13) Sign your work
 
 To improve tracking of who did what, especially with patches that can
 percolate to their final resting place in the kernel through several
@@ -399,7 +414,7 @@ tracking your trees, and to people trying to trouble-shoot bugs in your
 tree.
 
 
-13) When to use Acked-by: and Cc:
+14) When to use Acked-by: and Cc:
 
 The Signed-off-by: tag indicates that the signer was involved in the
 development of the patch, or that he/she was in the patch's delivery path.
@@ -430,7 +445,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
+15) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -486,7 +501,7 @@ idea reporters, they will, hopefully, be inspired to help us again in the
 future.
 
 
-15) The canonical patch format
+16) The canonical patch format
 
 The canonical patch subject line is:
 
@@ -600,7 +615,7 @@ See more details on the proper patch format in the following
 references.
 
 
-16) Sending "git pull" requests  (from Linus emails)
+17) Sending "git pull" requests  (from Linus emails)
 
 Please write the git repo address and branch name alone on the same line
 so that I can't even by mistake pull from the wrong branch, and so
-- 
1.9.1.286.g5172cb3

