Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3GYKIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:08:15 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57538 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3GYKIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:08:12 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Documentation/SubmittingPatches: Request summaries for commit references
Date: Thu, 25 Jul 2013 12:08:06 +0200
Message-Id: <1374746886-22961-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request inclusion of oneline summaries when referring to other commits

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 Documentation/SubmittingPatches |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 6e97e73..26b1e31 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -109,6 +109,16 @@ probably didn't even receive earlier versions of the patch.
 If the patch fixes a logged bug entry, refer to that bug entry by
 number and URL.
 
+If you want to refer to a specific commit, don't just refer to the
+SHA-1 ID of the commit. Please also include the oneline summary of
+the commit, to make it easier for reviewers to know what it is about.
+Example:
+
+	Commit e21d2170f36602ae2708 ("video: remove unnecessary
+	platform_set_drvdata()") removed the unnecessary
+	platform_set_drvdata(), but left the variable "dev" unused,
+	delete it.
+
 
 3) Separate your changes.
 
-- 
1.7.9.5

