Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbaICUXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:23:35 -0400
Received: from syn.loicp.eu ([176.31.96.212]:56919 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbaICUXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:23:30 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/6] staging: goldfish: document spinlock usage
Date: Wed,  3 Sep 2014 22:23:12 +0200
Message-Id: <1409775795-12521-4-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409775795-12521-1-git-send-email-loic@loicp.eu>
References: <1409775795-12521-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: document spinlock usage

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_audio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/goldfish/goldfish_audio.c b/drivers/staging/goldfish/goldfish_audio.c
index 23a206d..b360d07 100644
--- a/drivers/staging/goldfish/goldfish_audio.c
+++ b/drivers/staging/goldfish/goldfish_audio.c
@@ -36,6 +36,7 @@ MODULE_VERSION("1.0");
 struct goldfish_audio {
 	char __iomem *reg_base;
 	int irq;
+	/* lock protects access to buffer_status and to device registers */
 	spinlock_t lock;
 	wait_queue_head_t wait;
 
-- 
2.0.4

