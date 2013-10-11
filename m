Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab3JKKvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:51:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab3JKKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Raphael Kubo da Costa <rakuco@FreeBSD.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 079/100] Bluetooth: Add support for BCM20702A0 [0b05, 17cb]
Date: Fri, 11 Oct 2013 11:41:49 +0100
Message-Id: <1381488130-30235-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Kubo da Costa <rakuco@FreeBSD.org>

commit 38a172bef8c93ecbfd69715fd88396988e4073fd upstream.

Yet another vendor specific ID for this chipset; this one for the ASUS
USB-BT400 Bluetooth 4.0 adapter.

T:  Bus=03 Lev=02 Prnt=02 Port=01 Cnt=01 Dev#=  6 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0b05 ProdID=17cb Rev=01.12
S:  Manufacturer=Broadcom Corp
S:  Product=BCM20702A0
S:  SerialNumber=000272C64400
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

Signed-off-by: Raphael Kubo da Costa <rakuco@FreeBSD.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b29109e..a5eef4e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,6 +108,7 @@ static struct usb_device_id btusb_table[] = {
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0b05, 0x17b5) },
+	{ USB_DEVICE(0x0b05, 0x17cb) },
 	{ USB_DEVICE(0x04ca, 0x2003) },
 	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },
-- 
1.8.3.2

