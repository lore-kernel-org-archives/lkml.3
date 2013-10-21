Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3JUIvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39636 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab3JUIvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Gustavo Padovan" <gustavo.padovan@collabora.co.uk>,
        "Raphael Kubo da Costa" <rakuco@FreeBSD.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.385579965@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 077/149] Bluetooth: Add support for BCM20702A0 [0b05,
 17cb]
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,6 +108,7 @@ static struct usb_device_id btusb_table[
 
 	/* Broadcom BCM20702A0 */
 	{ USB_DEVICE(0x0b05, 0x17b5) },
+	{ USB_DEVICE(0x0b05, 0x17cb) },
 	{ USB_DEVICE(0x04ca, 0x2003) },
 	{ USB_DEVICE(0x0489, 0xe042) },
 	{ USB_DEVICE(0x413c, 0x8197) },

