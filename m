Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaFPO7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:59:52 -0400
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:36312 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932130AbaFPO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:59:49 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: pe1dnn@amsat.org, gregkh@linuxfoundation.org
Cc: nicolas.pfeiffer@fau.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH 5/5] staging/wlags49_h2: checkpatch: line over 80 characters
Date: Mon, 16 Jun 2014 16:50:53 +0200
Message-Id: <1402930253-32537-6-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/staging/wlags49_h2/wl_cs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index e658000..4239f0c 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -340,8 +340,9 @@ static const struct pcmcia_device_id wl_adapter_ids[] = {
 				0x33103a9b, 0xe175b0dd),
 #else
 	PCMCIA_DEVICE_MANF_CARD(0x0156, 0x0004),
-	PCMCIA_DEVICE_PROD_ID12("Linksys", "WCF54G_Wireless-G_CompactFlash_Card",
-				0x0733cc81, 0x98a599e1),
+	PCMCIA_DEVICE_PROD_ID12("Linksys",
+			"WCF54G_Wireless-G_CompactFlash_Card", 0x0733cc81,
+			0x98a599e1),
 #endif  /* (HCF_TYPE) & HCF_TYPE_HII5 */
 	PCMCIA_DEVICE_NULL,
 };
-- 
1.9.1

