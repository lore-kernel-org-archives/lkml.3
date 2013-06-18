Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab3FSAVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:21:52 -0400
Received: from 100.204.216.81.static.g-hkn.siw.siwnet.net ([81.216.204.100]:43547
	"EHLO iko.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933453Ab3FSAVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:21:51 -0400
Message-Id: <201306190021.r5J0LkvQ032449@eskarina.iko.pp.se>
From: Anders Hammarquist <iko@iko.pp.se>
Date: Wed, 19 Jun 2013 01:58:49 +0200
Subject: [PATCH 2/2] Be explicit about the Abbott product ids being product
 ids.
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (iko.pp.se [127.0.0.1]); Wed, 19 Jun 2013 02:21:47 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anders Hammarquist <iko@iko.pp.se>
---
 drivers/usb/serial/ti_usb_3410_5052.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index 4a2423e..ea8b273 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -52,9 +52,9 @@
 
 /* Abbott Diabetics vendor and product ids */
 #define ABBOTT_VENDOR_ID		0x1a61
-#define ABBOTT_STEREO_PLUG_ID		0x3410
+#define ABBOTT_STEREO_PLUG_PRODUCT_ID	0x3410
 #define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID
-#define ABBOTT_STRIP_PORT_ID		0x3420
+#define ABBOTT_STRIP_PORT_PRODUCT_ID	0x3420
 
 /* Commands */
 #define TI_GET_VERSION			0x01
-- 
1.7.10.4

