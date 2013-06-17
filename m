Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3FQPVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:37 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39019 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3FQPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:34 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 03/11] media: davinci: vpif: remove unnecessary braces around defines
Date: Mon, 17 Jun 2013 20:50:43 +0530
Message-Id: <1371482451-18314-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch removes unnecessary braces around defines.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 164c1b7..cd08e52 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -32,10 +32,10 @@
 MODULE_DESCRIPTION("TI DaVinci Video Port Interface driver");
 MODULE_LICENSE("GPL");
 
-#define VPIF_CH0_MAX_MODES	(22)
-#define VPIF_CH1_MAX_MODES	(02)
-#define VPIF_CH2_MAX_MODES	(15)
-#define VPIF_CH3_MAX_MODES	(02)
+#define VPIF_CH0_MAX_MODES	22
+#define VPIF_CH1_MAX_MODES	2
+#define VPIF_CH2_MAX_MODES	15
+#define VPIF_CH3_MAX_MODES	2
 
 spinlock_t vpif_lock;
 
-- 
1.7.9.5

