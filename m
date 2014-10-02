Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaJBWLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:11:18 -0400
Received: from mail-bn1on0080.outbound.protection.outlook.com ([157.56.110.80]:61056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752286AbaJBWLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:11:17 -0400
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2014 18:11:17 EDT
Message-ID: <542DC5C9.8020301@silabs.com>
Date: Thu, 2 Oct 2014 17:38:17 -0400
From: Nathaniel Ting <nathaniel.ting@silabs.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: serial: cp210x: Add Silicon Labs 358x VID and PID.
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.236.254.7]
X-ClientProxiedBy: BY2PR04CA022.namprd04.prod.outlook.com (10.141.249.140) To
 CO1PR07MB911.namprd07.prod.outlook.com (10.242.166.27)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR07MB911;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(189002)(199003)(54356999)(50986999)(87266999)(77096002)(64126003)(87976001)(85306004)(19580405001)(80316001)(106356001)(110136001)(107046002)(83506001)(19580395003)(36756003)(92566001)(95666004)(92726001)(86362001)(66066001)(105586002)(42186005)(76482002)(85852003)(65956001)(50466002)(4396001)(33656002)(102836001)(101416001)(97736003)(47776003)(20776003)(64706001)(46102003)(80022003)(10300001)(31966008)(99396003)(120916001)(229853001)(23676002)(59896002)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR07MB911;H:[10.4.148.23];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
-- 1.9.1


