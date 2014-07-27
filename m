Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaG0LWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:22:39 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41437 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaG0LWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:22:38 -0400
From: Rahul Garg <rahul.lnmiit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rahul Garg <rahul.lnmiit@gmail.com>
Subject: [PATCH] staging: vt6655: coding style: Fixed commenting style Few lines were crossing 80 characters limit
Date: Sun, 27 Jul 2014 16:51:43 +0530
Message-Id: <1406460103-28069-1-git-send-email-rahul.lnmiit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rahul Garg <rahul.lnmiit@gmail.com>
---
 drivers/staging/vt6655/tcrc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/tcrc.c b/drivers/staging/vt6655/tcrc.c
index ed6868a..bf8d4c3 100644
--- a/drivers/staging/vt6655/tcrc.c
+++ b/drivers/staging/vt6655/tcrc.c
@@ -41,7 +41,7 @@
 
 /*---------------------  Static Variables  --------------------------*/
 
-// 32-bit CRC table
+/* 32-bit CRC table */
 static const unsigned long s_adwCrc32Table[256] = {
 	0x00000000L, 0x77073096L, 0xEE0E612CL, 0x990951BAL,
 	0x076DC419L, 0x706AF48FL, 0xE963A535L, 0x9E6495A3L,
@@ -129,13 +129,15 @@ static const unsigned long s_adwCrc32Table[256] = {
  * Return Value: CRC-32
  *
  -*/
-unsigned long CRCdwCrc32(unsigned char *pbyData, unsigned int cbByte, unsigned long dwCrcSeed)
+unsigned long CRCdwCrc32(unsigned char *pbyData, unsigned int cbByte,
+			unsigned long dwCrcSeed)
 {
 	unsigned long dwCrc;
 
 	dwCrc = dwCrcSeed;
 	while (cbByte--) {
-		dwCrc = s_adwCrc32Table[(unsigned char)((dwCrc ^ (*pbyData)) & 0xFF)] ^ (dwCrc >> 8);
+		dwCrc = s_adwCrc32Table[(unsigned char)((dwCrc ^ (*pbyData))
+					& 0xFF)] ^ (dwCrc >> 8);
 		pbyData++;
 	}
 
@@ -185,7 +187,8 @@ unsigned long CRCdwGetCrc32(unsigned char *pbyData, unsigned int cbByte)
  * Return Value: CRC-32
  *
  -*/
-unsigned long CRCdwGetCrc32Ex(unsigned char *pbyData, unsigned int cbByte, unsigned long dwPreCRC)
+unsigned long CRCdwGetCrc32Ex(unsigned char *pbyData,
+			unsigned int cbByte, unsigned long dwPreCRC)
 {
 	return CRCdwCrc32(pbyData, cbByte, dwPreCRC);
 }
-- 
1.7.9.5

