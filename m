Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3FEJBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:01:10 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33565 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753392Ab3FEJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:01:07 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2013 05:01:07 EDT
From: Johannes Schilling <of82ecuq@cip.cs.fau.de>
To: linux-kernel@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de, Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: [PATCH 4/6] keucr: make error messages less aggressive
Date: Wed,  5 Jun 2013 10:50:04 +0200
Message-Id: <1370422206-14961-5-git-send-email-of82ecuq@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here's a flower: ⚘. have a very happy day ☺

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/smilsub.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/keucr/smilsub.c b/drivers/staging/keucr/smilsub.c
index d5e289b..c5f034d 100644
--- a/drivers/staging/keucr/smilsub.c
+++ b/drivers/staging/keucr/smilsub.c
@@ -214,7 +214,7 @@ int Ssfdc_D_ReadSect(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -266,7 +266,7 @@ int Ssfdc_D_ReadBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -319,7 +319,7 @@ int Ssfdc_D_CopyBlock(struct us_data *us, WORD count, BYTE *buf,
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -365,7 +365,7 @@ int Ssfdc_D_WriteSectForCopy(struct us_data *us, BYTE *buf, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -403,7 +403,7 @@ int Ssfdc_D_EraseBlock(struct us_data *us)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -438,7 +438,7 @@ int Ssfdc_D_ReadRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
@@ -477,7 +477,7 @@ int Ssfdc_D_WriteRedtData(struct us_data *us, BYTE *redundant)
 
 	result = ENE_LoadBinCode(us, SM_RW_PATTERN);
 	if (result != USB_STOR_XFER_GOOD) {
-		dev_err("Load SM RW Code Fail !!\n");
+		dev_err("Failed to load SM RW code\n");
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-- 
1.7.10.4

