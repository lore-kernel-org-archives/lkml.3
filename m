Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3LOU7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:59:36 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56979 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab3LOU7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:59:35 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 15 Dec 2013 12:59:26 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Subject: [PATCH 1/3] SubmittingPatches: Add style recommendation to use
 imperative descriptions
Message-ID: <20131215205925.GA11106@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most commit messages use this style, and the recommendation frequently
comes up in discussions (especially in response to patches that don't
use it), but that recommendation doesn't actually appear anywhere in
Documentation.  Add this style guideline to SubmittingPatches, using the
description from git's SubmittingPatches.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/SubmittingPatches | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31..c74e73c 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -106,6 +106,11 @@ I.e., the patch (series) and its description should be self-contained.
 This benefits both the patch merger(s) and reviewers.  Some reviewers
 probably didn't even receive earlier versions of the patch.
 
+Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
+instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
+to do frotz", as if you are giving orders to the codebase to change
+its behaviour.
+
 If the patch fixes a logged bug entry, refer to that bug entry by
 number and URL.
 
-- 
1.8.5.1

