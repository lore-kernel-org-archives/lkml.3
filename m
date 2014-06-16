Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaFPO7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:59:03 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:41616 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaFPO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:58:57 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 2/5] staging/wlags49_h2: checkpatch: added spaces around equal sign
Date: Mon, 16 Jun 2014 16:50:50 +0200
Message-Id: <1402930253-32537-3-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hereby the checkpatch message
  ERROR: spaces required around that '=' (ctx:VxV)
gets resolved
and the neighboring equal signs are positioned in the same column.

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/staging/wlags49_h2/wl_cs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 5c6e18c..c79f1ed 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -131,11 +131,11 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 		return -ENOMEM;
 	}
 
-	link->resource[0]->end  = HCF_NUM_IO_PORTS;
-	link->resource[0]->flags= IO_DATA_PATH_WIDTH_16;
-	link->config_flags     |= CONF_ENABLE_IRQ;
-	link->config_index      = 5;
-	link->config_regs       = PRESENT_OPTION;
+	link->resource[0]->end   = HCF_NUM_IO_PORTS;
+	link->resource[0]->flags = IO_DATA_PATH_WIDTH_16;
+	link->config_flags      |= CONF_ENABLE_IRQ;
+	link->config_index       = 5;
+	link->config_regs        = PRESENT_OPTION;
 
 	link->priv = dev;
 	lp = wl_priv(dev);
-- 
1.9.1

