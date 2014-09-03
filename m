Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaICLUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:20:32 -0400
Received: from syn.loicp.eu ([176.31.96.212]:44668 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbaICLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:20:29 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: goldfish: document spinlock usage
Date: Wed,  3 Sep 2014 13:13:44 +0200
Message-Id: <1409742827-6048-4-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409742827-6048-1-git-send-email-loic@loicp.eu>
References: <1409742827-6048-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: document spinlock usage

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_audio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index 23a206d..ab723ab 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -36,7 +36,7 @@ MODULE_VERSION("1.0");
 struct goldfish_audio {
 	char __iomem *reg_base;
 	int irq;
-	spinlock_t lock;
+	spinlock_t lock;                /* Serialize access to device */
 	wait_queue_head_t wait;
 
 	char __iomem *buffer_virt;      /* combined buffer virtual address */
-- 
2.0.4

