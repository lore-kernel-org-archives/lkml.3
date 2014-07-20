Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaGTMBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 08:01:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63147 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaGTMBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 08:01:07 -0400
Date: Sun, 20 Jul 2014 15:01:03 +0300
From: Bivolaru Catalin <bivolaru.catalin@gmail.com>
To: kernel-janitors@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paul.gortmaker@windriver.com
Subject: [PATCH] staging: input: sunkbd.c: Fix coding style
Message-ID: <20140720120103.GA5294@kalio-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style with regard to missing spaces after , and the column limit
that was violated after the first change.

Signed-off-by: Bivolaru Catalin <bivolaru.catalin@gmail.com>
---

The change was tested only by compilation.

diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index dc6bb9d..25ba6b6 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -42,14 +42,15 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 static unsigned char sunkbd_keycode[128] = {
-	  0,128,114,129,115, 59, 60, 68, 61, 87, 62, 88, 63,100, 64,112,
-	 65, 66, 67, 56,103,119, 99, 70,105,130,131,108,106,  1,  2,  3,
-	  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 41, 14,110,113, 98, 55,
-	116,132, 83,133,102, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
-	 26, 27,111,127, 71, 72, 73, 74,134,135,107,  0, 29, 30, 31, 32,
-	 33, 34, 35, 36, 37, 38, 39, 40, 43, 28, 96, 75, 76, 77, 82,136,
-	104,137, 69, 42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,101,
-	 79, 80, 81,  0,  0,  0,138, 58,125, 57,126,109, 86, 78
+	  0, 128, 114, 129, 115,  59,  60,  68,  61,  87,  62,  88,  63, 100,
+	 64, 112,  65,  66,  67,  56, 103, 119,  99,  70, 105, 130, 131, 108,
+	106,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,
+	 41,  14, 110, 113,  98,  55, 116, 132,  83, 133, 102,  15,  16,  17,
+	 18,  19,  20,  21,  22,  23,  24,  25,  26,  27, 111, 127,  71,  72,
+	 73,  74, 134, 135, 107,   0,  29,  30,  31,  32,  33,  34,  35,  36,
+	 37,  38,  39,  40,  43,  28,  96,  75,  76,  77,  82, 136, 104, 137,
+	 69,  42,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54, 101,
+	 79,  80,  81,   0,   0,   0, 138,  58, 125,  57, 126, 109,  86,  78
 };
 
 #define SUNKBD_CMD_RESET	0x1
