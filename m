Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3IMAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:04:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54075 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab3IMAE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:04:29 -0400
X-Sasl-enc: ji2d/qU+JIkS0ijfGGCJ7uh69uBZUeKp7qzVNdYIFKe7 1379030665
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, tao.peng@emc.com, andreas.dilger@intel.com,
        jencce.kernel@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: fix a brace coding style issue in fsfilt.c
Date: Thu, 12 Sep 2013 20:04:22 -0400
Message-Id: <1379030662-58789-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the fsfilt.c file that fixes up a brace warning found by the
checkpatch.pl tool.

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/lvfs/fsfilt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/fsfilt.c b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
index e86df73..efc1e52 100644
--- a/drivers/staging/lustre/lustre/lvfs/fsfilt.c
+++ b/drivers/staging/lustre/lustre/lvfs/fsfilt.c
@@ -50,9 +50,8 @@ static struct fsfilt_operations *fsfilt_search_type(const char *type)
 
 	list_for_each(p, &fsfilt_types) {
 		found = list_entry(p, struct fsfilt_operations, fs_list);
-		if (!strcmp(found->fs_type, type)) {
+		if (!strcmp(found->fs_type, type))
 			return found;
-		}
 	}
 	return NULL;
 }
-- 
1.8.4

