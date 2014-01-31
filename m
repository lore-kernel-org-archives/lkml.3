Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaAaKfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:35:30 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:37429 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbaAaKf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:35:27 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, florian.vaussard@epfl.ch
Subject: [PATCH v2 1/6] can: sja1000: remove unused defines
Date: Fri, 31 Jan 2014 11:35:08 +0100
Message-Id: <1391164513-11529-2-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch>
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused defines for the OF platform.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/net/can/sja1000/sja1000_of_platform.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index 047accd..2f29eb9 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -55,9 +55,6 @@ MODULE_LICENSE("GPL v2");
 
 #define SJA1000_OFP_CAN_CLOCK  (16000000 / 2)
 
-#define SJA1000_OFP_OCR        OCR_TX0_PULLDOWN
-#define SJA1000_OFP_CDR        (CDR_CBP | CDR_CLK_OFF)
-
 static u8 sja1000_ofp_read_reg(const struct sja1000_priv *priv, int reg)
 {
 	return ioread8(priv->reg_base + reg);
-- 
1.8.1.2

