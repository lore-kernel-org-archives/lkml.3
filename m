Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaJCQBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:01:42 -0400
Received: from mail-bn1on0094.outbound.protection.outlook.com ([157.56.110.94]:34112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753929AbaJCQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:01:39 -0400
From: Nathaniel Ting <nathaniel.ting@silabs.com>
To: <johan@kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nathaniel Ting" <nathaniel.ting@silabs.com>
Subject: [PATCH] USB: serial: cp210x: Add Silicon Labs 358x VID and PID.
Date: Fri, 3 Oct 2014 12:01:20 -0400
Message-ID: <1412352080-4711-1-git-send-email-nathaniel.ting@silabs.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [216.236.254.7]
X-ClientProxiedBy: BN1PR08CA0035.namprd08.prod.outlook.com (10.242.217.163) To
 BN1PR07MB904.namprd07.prod.outlook.com (10.242.215.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR07MB904;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(53416004)(66066001)(107046002)(2351001)(85306004)(48376002)(50226001)(69596002)(19580395003)(4396001)(20776003)(47776003)(110136001)(229853001)(33646002)(95666004)(50986999)(50466002)(105586002)(77096002)(40100001)(81156004)(106356001)(76482002)(122386001)(99396003)(101416001)(19580405001)(46102003)(10300001)(120916001)(92566001)(86362001)(80022003)(97736003)(92726001)(42186005)(64706001)(93916002)(21056001)(31966008)(104166001)(89996001)(87976001)(85852003)(87286001)(102836001)(88136002)(77156001)(36756003)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR07MB904;H:lab-nate-ubuntu.silabs.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: silabs.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathaniel Ting <nathaniel.ting@silabs.com>

Enable Silicon Labs Ember VID chips to enumerate with the cp210x usb serial
driver. EM358x devices operating with the Ember Z-Net 5.1.2 stack may now
connect to host PCs over a USB serial link.

Signed-off-by: Nathaniel Ting <nathaniel.ting@silabs.com>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index e4bb622..ab1eb9b 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -154,6 +154,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1BA4, 0x0002) }, /* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
-- 
1.9.1

