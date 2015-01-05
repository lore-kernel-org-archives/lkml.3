Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbbAEUq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:46:58 -0500
Received: from nbfkord-smmo02.seg.att.com ([209.65.160.78]:16776 "EHLO
	nbfkord-smmo02.seg.att.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbbAEUq4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:46:56 -0500
X-MXL-Hash: 54aaf8406817305a-49926c9d35415c4e4451dc0524a6885d93390f3e
X-MXL-Hash: 54aaf83e30e579bb-f2ec863643e1cd4e7614e045517776d41a6d7823
From: "Peterson, David" <David.Peterson@cel.com>
To: "johan@kernel.org" <johan@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Added virtual com port VID/PID entries for CEL USB sticks
 and MeshWorks devices Signed-off-by: David Peterson <david.peterson@cel.com>
Thread-Topic: [PATCH] Added virtual com port VID/PID entries for CEL USB
 sticks and MeshWorks devices Signed-off-by: David Peterson
 <david.peterson@cel.com>
Thread-Index: AQHQKSgHLNk39yqhEkaywDruVkF4M5yx/vLA
Date: Mon, 5 Jan 2015 20:46:52 +0000
Message-ID: <641A0889272F104D8B07278675C0C484010B1DC3@hq27>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.27.72.70]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-AnalysisOut: [v=2.0 cv=VsWU9ZKn c=1 sm=1 a=y9+QFOo4fg1+r3pHMCm0Pg==:17 a]
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

