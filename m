Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaEDQ0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:26:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaEDPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH 3.14 127/158] usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210
Date: Sun,  4 May 2014 11:40:36 -0400
Message-Id: <20140504154047.258368237@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@xilinx.com>

commit ead5178bf442dbae4008ee54bf4f66a1f6a317c9 upstream.

Add new ulpi IDs which are available on Xilinx Zynq boards.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/phy/phy-ulpi.c |    2 ++
 1 file changed, 2 insertions(+)

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


