Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLTS3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:29:37 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64048 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaLTS3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:29:33 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 1/2] drivers: char: mem: Replace usage of asm include
Date: Sat, 20 Dec 2014 18:28:35 +0000
Message-Id: <1419100116-29819-2-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419100116-29819-1-git-send-email-robert.ward114@googlemail.com>
References: <1419100116-29819-1-git-send-email-robert.ward114@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Replaces the use of asm/uaccess.h with linux/uaccess.h.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 4c58333..a04ce78 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -28,7 +28,7 @@
 #include <linux/io.h>
 #include <linux/aio.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_IA64
 # include <linux/efi.h>
-- 
2.0.2

