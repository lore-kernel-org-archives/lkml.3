Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaLWQde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:33:34 -0500
Received: from tex.lwn.net ([70.33.254.29]:51380 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbaLWQcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:20 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/7] Docs: SubmittingPatches: update follow-through instructions
Date: Tue, 23 Dec 2014 09:32:04 -0700
Message-Id: <1419352327-4517-5-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419352327-4517-1-git-send-email-corbet@lwn.net>
References: <1419352327-4517-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SubmittingPatches was written in the "keep sending to Linus until something
shows up in a release" era.  Given that we don't do things that way anymore
and the system is far less lossy, update this information and add some
hints on responding to reviewer comments.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/SubmittingPatches | 50 ++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index e169c6ca5243..a8308401a048 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -354,40 +354,34 @@ server, and provide instead a URL (link) pointing to your patch.
 
 
 
-8) Name your kernel version.
-
-It is important to note, either in the subject line or in the patch
-description, the kernel version to which this patch applies.
-
-If the patch does not apply cleanly to the latest kernel version,
-Linus will not apply it.
-
-
+8) Respond to review comments.
+------------------------------
 
-9) Don't get discouraged.  Re-submit.
+Your patch will almost certainly get comments from reviewers on ways in
+which the patch can be improved.  You must respond to those comments;
+ignoring reviewers is a good way to get ignored in return.  Review comments
+or questions that do not lead to a code change should almost certainly
+bring about a comment or changelog entry so that the next reviewer better
+understands what is going on.
 
-After you have submitted your change, be patient and wait.  If Linus
-likes your change and applies it, it will appear in the next version
-of the kernel that he releases.
+Be sure to tell the reviewers what changes you are making and to thank them
+for their time.  Code review is a tiring and time-consuming process, and
+reviewers sometimes get grumpy.  Even in that case, though, respond
+politely and address the problems they have pointed out.
 
-However, if your change doesn't appear in the next version of the
-kernel, there could be any number of reasons.  It's YOUR job to
-narrow down those reasons, correct what was wrong, and submit your
-updated change.
 
-It is quite common for Linus to "drop" your patch without comment.
-That's the nature of the system.  If he drops your patch, it could be
-due to
-* Your patch did not apply cleanly to the latest kernel version.
-* Your patch was not sufficiently discussed on linux-kernel.
-* A style issue (see section 2).
-* An e-mail formatting issue (re-read this section).
-* A technical problem with your change.
-* He gets tons of e-mail, and yours got lost in the shuffle.
-* You are being annoying.
+9) Don't get discouraged - or impatient.
+----------------------------------------
 
-When in doubt, solicit comments on linux-kernel mailing list.
+After you have submitted your change, be patient and wait.  Reviewers are
+busy people and may not get to your patch right away.
 
+Once upon a time, patches used to disappear into the void without comment,
+but the development process works more smoothly than that now.  You should
+receive comments within a week or so; if that does not happen, make sure
+that you have sent your patches to the right place.  Wait for a minimum of
+one week before resubmitting or pinging reviewers - possibly longer during
+busy times like merge windows.
 
 
 10) Include PATCH in the subject
-- 
2.1.0

