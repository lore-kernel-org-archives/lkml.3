Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaJVJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:48:59 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:57913 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaJVJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:48:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH/TRIVIAL 4/5] [SCSI] isci: Spelling s/stucture/structure/
Date: Wed, 22 Oct 2014 11:49:02 +0200
Message-Id: <1413971343-27554-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
References: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
---
 drivers/scsi/isci/task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 5d6fda72d659770d..c086c075e8c498bd 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -595,7 +595,7 @@ int isci_task_abort_task(struct sas_task *task)
 
 		ret = TMF_RESP_FUNC_COMPLETE;
 	} else {
-		/* Fill in the tmf stucture */
+		/* Fill in the tmf structure */
 		isci_task_build_abort_task_tmf(&tmf, isci_tmf_ssp_task_abort,
 					       old_request);
 
-- 
1.9.1

