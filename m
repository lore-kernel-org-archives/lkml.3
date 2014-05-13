Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761255AbaEMKgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:36:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323AbaEMKKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:10:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/182] usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210
Date: Tue, 13 May 2014 11:27:33 +0200
Message-Id: <1602acc079266e8b2842492d9020f0f8c10555c9.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ead5178bf442dbae4008ee54bf4f66a1f6a317c9 upstream.

Add new ulpi IDs which are available on Xilinx Zynq boards.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/phy/phy-ulpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
index 217339dd7a90..17ea3f271bd8 100644
--- a/drivers/usb/phy/phy-ulpi.c
+++ b/drivers/usb/phy/phy-ulpi.c
@@ -47,6 +47,8 @@ struct ulpi_info {
 static struct ulpi_info ulpi_ids[] = {
 	ULPI_INFO(ULPI_ID(0x04cc, 0x1504), "NXP ISP1504"),
 	ULPI_INFO(ULPI_ID(0x0424, 0x0006), "SMSC USB331x"),
+	ULPI_INFO(ULPI_ID(0x0424, 0x0007), "SMSC USB3320"),
+	ULPI_INFO(ULPI_ID(0x0451, 0x1507), "TI TUSB1210"),
 };
 
 static int ulpi_set_otg_flags(struct usb_phy *phy)
-- 
1.9.3

