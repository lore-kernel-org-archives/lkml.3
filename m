Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3FELBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:01:10 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:34970 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab3FELBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:01:08 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2013 07:01:08 EDT
From: Matthias Schid <aircrach115@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, sjakub@gmail.com, jonbrett.dev@gmail.com,
        cruz@massive-dynamics.biz, joe@perches.com, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, steffhip@googlemail.com,
        simon.puels@gmail.com, Matthias Schid <aircrach115@gmail.com>
Subject: [PATCH 1/2] staging/asus_oled fixed alignment in defines
Date: Wed,  5 Jun 2013 12:50:44 +0200
Message-Id: <1370429445-17185-2-git-send-email-aircrach115@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370429445-17185-1-git-send-email-aircrach115@gmail.com>
References: <1370429445-17185-1-git-send-email-aircrach115@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replaced spaces in incorrect alignment in defines with tabs

Signed-off-by: Matthias Schid <aircrach115@gmail.com>
Signed-off-by: Stefan Huber <steffhip@googlemail.com>
Signed-off-by: Simon Puels <simon.puels@gmail.com>
---
 drivers/staging/asus_oled/asus_oled.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 4598a2f..173fb9a 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -50,9 +50,9 @@
 #define ASUS_OLED_DISP_HEIGHT		32
 #define ASUS_OLED_PACKET_BUF_SIZE	256
 
-#define USB_VENDOR_ID_ASUS      0x0b05
-#define USB_DEVICE_ID_ASUS_LCM      0x1726
-#define USB_DEVICE_ID_ASUS_LCM2     0x175b
+#define USB_VENDOR_ID_ASUS		0x0b05
+#define USB_DEVICE_ID_ASUS_LCM		0x1726
+#define USB_DEVICE_ID_ASUS_LCM2		0x175b
 
 MODULE_AUTHOR("Jakub Schmidtke, sjakub@gmail.com");
 MODULE_DESCRIPTION("Asus OLED Driver");
-- 
1.7.10.4

