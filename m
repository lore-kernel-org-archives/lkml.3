Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3C1H2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:28:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59651 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab3C1H2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:28:37 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <joe@perches.com>
CC: <apw@canonical.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCHv2 1/1] checkpatch: adding Suggested-by as standard signature
Date: Thu, 28 Mar 2013 12:58:22 +0530
Message-ID: <1364455702-13900-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As people started using Suggested-by as standard signature, adding
"Suggested-by" to the standard signature so that checkpatch won't
generate warning when Suggested-by is used in patch signature

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
Changes from Initial version
* Updated Documentation/SubmittingPatches explaining when to use
  Suggested-by tag.

 Documentation/SubmittingPatches |    9 ++++++++-
 scripts/checkpatch.pl           |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index aa0c1e6..6e97e73 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -420,7 +420,7 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by: and Reviewed-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -468,6 +468,13 @@ done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
 understand the subject area and to perform thorough reviews, will normally
 increase the likelihood of your patch getting into the kernel.
 
+A Suggested-by: tag indicates that the patch idea is suggested by the person
+named and ensures credit to the person for the idea. Please note that this
+tag should not be added without the reporter's permission, especially if the
+idea was not posted in a public forum. That said, if we diligently credit our
+idea reporters, they will, hopefully, be inspired to help us again in the
+future.
+
 
 15) The canonical patch format
 
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..6be4d27 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -281,6 +281,7 @@ our $signature_tags = qr{(?xi:
 	Tested-by:|
 	Reviewed-by:|
 	Reported-by:|
+	Suggested-by:|
 	To:|
 	Cc:
 )};
-- 
1.7.9.5

