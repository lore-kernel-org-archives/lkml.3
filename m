Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3ANC3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:29:31 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52761 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3ANC32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:29:28 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: gregkh@linuxfoundation.org, greg@kroah.com
Cc: Cruz Julian Bishop <cruzjbishop@gmail.com>, liodot@gmail.com,
        charrer@alacritech.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging: slicoss: Stop swearing in slicoss.c
Date: Mon, 14 Jan 2013 12:29:07 +1000
Message-Id: <1358130549-10969-2-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
References: <1358130549-10969-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm assuming that "CRC shit reg" is referencing the CRC register/registry.
Please ignore this patch if "shit" is actually in context

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/slicoss/slicoss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 78578ee..5aa03ee 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -209,7 +209,7 @@ static u32 slic_crc_init;	/* Is table initialized */
  */
 static void slic_mcast_init_crc32(void)
 {
-	u32 c;		/*  CRC shit reg                 */
+	u32 c;			/*  CRC reg                      */
 	u32 e = 0;		/*  Poly X-or pattern            */
 	int i;			/*  counter                      */
 	int k;			/*  byte being shifted into crc  */
@@ -3437,7 +3437,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 					       (eecodesize - 2));
 			/*
 			    if the ucdoe chksum flag bit worked,
-			    we wouldn't need this shit
+			    we wouldn't need this
 			*/
 			if (ee_chksum == calc_chksum)
 				card->config.EepromValid = true;
-- 
1.7.10.4

