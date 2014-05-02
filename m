Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaEBQCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:02:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaEBPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/151] usb: phy: Add ulpi IDs for SMSC USB3320 and TI TUSB1210
Date: Fri,  2 May 2014 08:37:22 -0700
Message-Id: <1399045139-4531-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@xilinx.com>

commit ead5178bf442dbae4008ee54bf4f66a1f6a317c9 upstream.

Add new ulpi IDs which are available on Xilinx Zynq boards.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/phy/phy-ulpi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/phy-ulpi.c b/drivers/usb/phy/phy-ulpi.c
index 217339d..17ea3f2 100644
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
1.9.1

