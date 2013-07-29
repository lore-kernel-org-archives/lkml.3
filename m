Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3G2QNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:13:36 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.7]:61804 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690Ab3G2QNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:13:34 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-16.tower-29.messagelabs.com!1375114411!24957050!2
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-bluetooth@vger.kernel.org>
CC: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>,
        <linux-kernel@vger.kernel.org>, <vikram.kandukuri@atheros.com>,
        <suraj@atheros.com>, <hector.palacios@digi.com>
Subject: [PATCH] bluetooth: remove wrong dependency for BT_ATH3K
Date: Mon, 29 Jul 2013 18:12:05 +0200
Message-ID: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atheros firmware download driver is not dependent on HCI
USB driver. This driver is needed to complement any Atheros
driver like BT_HCIUART_ATH3K.

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
CC: Suraj Sumangala <suraj@atheros.com>
CC: Vikram Kandukuri <vikram.kandukuri@atheros.com>
---
 drivers/bluetooth/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 11a6104..a1d482b 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -222,7 +222,6 @@ config BT_MRVL_SDIO
 
 config BT_ATH3K
 	tristate "Atheros firmware download driver"
-	depends on BT_HCIBTUSB
 	select FW_LOADER
 	help
 	  Bluetooth firmware download driver.
