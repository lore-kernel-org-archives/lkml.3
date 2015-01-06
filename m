Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbbAFPBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:01:03 -0500
Received: from nbfkord-smmo04.seg.att.com ([209.65.160.86]:32054 "EHLO
	nbfkord-smmo04.seg.att.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbbAFPBB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:01:01 -0500
X-MXL-Hash: 54abf8ac7e17da6a-20ec97665f3c9642d5c4a4029a12b82ce6de01a6
X-MXL-Hash: 54abf8a7266a345f-bbee812db9c26a45d13393a1a568a68ce644919f
From: "Peterson, David" <David.Peterson@cel.com>
To: "johan@kernel.org" <johan@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: cp210x: add IDs for CEL USB sticks and MeshWorks
 devices
Thread-Topic: [PATCH] USB: cp210x: add IDs for CEL USB sticks and MeshWorks
 devices
Thread-Index: AQHQKcGQpsvHsTQSzEWrsql9iZvfbw==
Date: Tue, 6 Jan 2015 15:00:52 +0000
Message-ID: <641A0889272F104D8B07278675C0C484010BF621@hq27>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.27.72.70]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-AnalysisOut: [v=2.0 cv=HrvB7TvS c=1 sm=1 a=y9+QFOo4fg1+r3pHMCm0Pg==:17 a]
X-AnalysisOut: [=W4m72nRF2goA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=ofO]
X-AnalysisOut: [VIf7FAAAA:8 a=YNv0rlydsVwA:10 a=3Ul4oGXcMAlspX2yJhwA:9 a=C]
X-AnalysisOut: [juIK1q_8ugA:10]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2014051901)]
X-MAIL-FROM: <david.peterson@cel.com>
X-SOURCE-IP: [12.199.204.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Peterson <david.peterson@cel.com>

Added virtual com port VID/PID entries for CEL USB sticks and MeshWorks devices

Signed-off-by: David Peterson <david.peterson@cel.com>
---
 drivers/usb/serial/cp210x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c index 6c4eb3c..a6db2fc 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -120,6 +120,9 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x8856) }, /* CEL EM357 ZigBee USB Stick - LR */
+	{ USB_DEVICE(0x10C4, 0x8857) }, /* CEL EM357 ZigBee USB Stick */
+	{ USB_DEVICE(0x10C4, 0x8977) }, /* CEL MeshWorks DevKit Device */
 	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
--
2.1.0

