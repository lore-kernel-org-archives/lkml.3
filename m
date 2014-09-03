Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaICUYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:24:45 -0400
Received: from syn.loicp.eu ([176.31.96.212]:56928 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbaICUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:23:31 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] staging: goldfish: document mutex usage
Date: Wed,  3 Sep 2014 22:23:14 +0200
Message-Id: <1409775795-12521-6-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409775795-12521-1-git-send-email-loic@loicp.eu>
References: <1409775795-12521-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: document mutex usage

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_nand.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index 3f13ef0..c6c85d3 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -31,6 +31,7 @@
 #include "goldfish_nand_reg.h"
 
 struct goldfish_nand {
+	/* lock protects access to the device registers */
 	struct mutex            lock;
 	unsigned char __iomem  *base;
 	struct cmd_params       *cmd_params;
-- 
2.0.4

