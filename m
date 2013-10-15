Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3JOC4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 22:56:11 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:52085 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3JOC4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 22:56:10 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] drivers: media: usb: Fix typo on variable name
Date: Mon, 14 Oct 2013 23:56:37 -0300
Message-Id: <1381805797-4781-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable txlen was used instead of rxlen in a bound checking. (copy-paste error)

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/media/usb/dvb-usb/technisat-usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 40832a1..98d24ae 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -102,7 +102,7 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 	if (rxlen > 62) {
 		err("i2c RX buffer can't exceed 62 bytes (dev 0x%02x)",
 				device_addr);
-		txlen = 62;
+		rxlen = 62;
 	}

 	b[0] = I2C_SPEED_100KHZ_BIT;
--
1.7.10.4

