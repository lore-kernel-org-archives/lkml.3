Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaG1BdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:33:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33028 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaG1BdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:33:02 -0400
From: Rahul Garg <rahul.lnmiit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rahul Garg <rahul.lnmiit@gmail.com>
Subject: [PATCH] staging: vt6655: coding style: Fixed commenting style
Date: Mon, 28 Jul 2014 07:02:32 +0530
Message-Id: <1406511152-8065-1-git-send-email-rahul.lnmiit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix coding style: use C89 comments, not C99

Signed-off-by: Rahul Garg <rahul.lnmiit@gmail.com>
---
 drivers/staging/vt6655/tcrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/tcrc.c b/drivers/staging/vt6655/tcrc.c
index ed6868a..ddc5efd 100644
--- a/drivers/staging/vt6655/tcrc.c
+++ b/drivers/staging/vt6655/tcrc.c
@@ -41,7 +41,7 @@
 
 /*---------------------  Static Variables  --------------------------*/
 
-// 32-bit CRC table
+/* 32-bit CRC table */
 static const unsigned long s_adwCrc32Table[256] = {
 	0x00000000L, 0x77073096L, 0xEE0E612CL, 0x990951BAL,
 	0x076DC419L, 0x706AF48FL, 0xE963A535L, 0x9E6495A3L,
-- 
1.7.9.5

