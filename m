Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaFPQws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:52:48 -0400
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:37370 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbaFPQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:52:45 -0400
X-RRZE-Submit-IP: 131.188.42.190
From: Stephan Gabert <stephan.gabert@fau.de>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com
Cc: linux-bluetooth@vger.kernel.or, linux-kernel@vger.kernel.org,
        nicolas.pfeiffer@fau.de, linux-kernel@i4.cs.fau.de,
        Stephan Gabert <stephan.gabert@fau.de>
Subject: [PATCH] bluetooth/Kconfig: checkpatch: removed trailing whitespaces
Date: Mon, 16 Jun 2014 18:52:25 +0200
Message-Id: <1402937545-2362-1-git-send-email-stephan.gabert@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue. Removed trailing whitespaces in
bluetooth/Kconfig.

This patch applies to v2.6.12-rc2 and above.

Signed-off-by: Stephan Gabert <stephan.gabert@fau.de>
Signed-off-by: Nicolas Pfeiffer <nicolas.pfeiffer@fau.de>
---
 drivers/bluetooth/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index f5ce64e..fa7fd62 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -30,8 +30,8 @@ config BT_HCIUART
 	help
 	  Bluetooth HCI UART driver.
 	  This driver is required if you want to use Bluetooth devices with
-	  serial port interface. You will also need this driver if you have 
-	  UART based Bluetooth PCMCIA and CF devices like Xircom Credit Card 
+	  serial port interface. You will also need this driver if you have
+	  UART based Bluetooth PCMCIA and CF devices like Xircom Credit Card
 	  adapter and BrainBoxes Bluetooth PC Card.
 
 	  Say Y here to compile support for Bluetooth UART devices into the
@@ -41,9 +41,9 @@ config BT_HCIUART_H4
 	bool "UART (H4) protocol support"
 	depends on BT_HCIUART
 	help
-	  UART (H4) is serial protocol for communication between Bluetooth 
-	  device and host. This protocol is required for most Bluetooth devices 
-	  with UART interface, including PCMCIA and CF cards. 
+	  UART (H4) is serial protocol for communication between Bluetooth
+	  device and host. This protocol is required for most Bluetooth devices
+	  with UART interface, including PCMCIA and CF cards.
 
 	  Say Y here to compile support for HCI UART (H4) protocol.
 
@@ -52,7 +52,7 @@ config BT_HCIUART_BCSP
 	depends on BT_HCIUART
 	select BITREVERSE
 	help
-	  BCSP (BlueCore Serial Protocol) is serial protocol for communication 
+	  BCSP (BlueCore Serial Protocol) is serial protocol for communication
 	  between Bluetooth device and host. This protocol is required for non
 	  USB Bluetooth devices based on CSR BlueCore chip, including PCMCIA and
 	  CF cards.
-- 
1.9.1

