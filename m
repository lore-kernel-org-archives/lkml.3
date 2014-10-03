Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaJCPHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:07:01 -0400
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:61664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773AbaJCPG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:06:58 -0400
From: Nathaniel Ting <nathaniel.ting@silabs.com>
To: <johan@kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nathaniel Ting" <nathaniel.ting@silabs.com>
Subject: [PATCH] USB: serial: cp210x: Add Silicon Labs 358x VID and PID.
Date: Fri, 3 Oct 2014 11:06:33 -0400
Message-ID: <1412348793-4558-1-git-send-email-nathaniel.ting@silabs.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [216.236.254.7]
X-ClientProxiedBy: BY2PR06CA033.namprd06.prod.outlook.com (10.141.250.151) To
 BY2PR07MB908.namprd07.prod.outlook.com (10.242.45.156)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR07MB908;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(53416004)(93916002)(86362001)(80022003)(106356001)(21056001)(104166001)(99396003)(102836001)(4396001)(88136002)(50466002)(48376002)(95666004)(31966008)(77156001)(36756003)(107046002)(2351001)(105586002)(77096002)(81156004)(122386001)(89996001)(46102003)(76482002)(47776003)(20776003)(85306004)(64706001)(92726001)(92566001)(87976001)(97736003)(10300001)(42186005)(69596002)(85852003)(62966002)(50986999)(120916001)(101416001)(229853001)(66066001)(33646002)(87286001)(19580405001)(110136001)(40100001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB908;H:lab-nate-ubuntu.silabs.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
index e4bb622..ce81fa8 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -154,6 +154,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+        { USB_DEVICE(0x1BA4, 0x0002) }, /* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
-- 
1.9.1

