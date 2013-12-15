Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3LOVAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 16:00:08 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:43182 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3LOU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:59:45 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 15 Dec 2013 12:59:40 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Subject: [PATCH 2/3] SubmittingPatches: Add recommendation for mailing list
 references
Message-ID: <20131215205939.GA11125@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SubmittingPatches already mentions referencing bugs fixed by a commit,
but doesn't mention citing relevant mailing list discussions.  Add a
note to that effect, along with a recommendation to use the
https://lkml.kernel.org/ redirector.

Portions based on text from git's SubmittingPatches.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/SubmittingPatches | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index c74e73c..53e6590 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -112,7 +112,15 @@ to do frotz", as if you are giving orders to the codebase to change
 its behaviour.
 
 If the patch fixes a logged bug entry, refer to that bug entry by
-number and URL.
+number and URL.  If the patch follows from a mailing list discussion,
+give a URL to the mailing list archive; use the https://lkml.kernel.org/
+redirector with a Message-Id, to ensure that the links cannot become
+stale.
+
+However, try to make your explanation understandable without external
+resources.  In addition to giving a URL to a mailing list archive or
+bug, summarize the relevant points of the discussion that led to the
+patch as submitted.
 
 If you want to refer to a specific commit, don't just refer to the
 SHA-1 ID of the commit. Please also include the oneline summary of
-- 
1.8.5.1

