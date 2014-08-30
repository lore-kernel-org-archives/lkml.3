Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaH3SnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 14:43:10 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62237 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3SnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 14:43:08 -0400
From: Andrew Plummer <plummer574@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Plummer <plummer574@gmail.com>
Subject: [PATCH] Staging: emxx_udc: emxx_udc: remove spaces before semicolons
Date: Sat, 30 Aug 2014 19:43:02 +0100
Message-Id: <1409424182-8903-1-git-send-email-plummer574@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove spaces before semicolons to remove checkpatch warnings.

Signed-off-by: Andrew Plummer <plummer574@gmail.com>
---
 drivers/staging/emxx_udc/emxx_udc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index b2eaf01..adc24a9 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -77,14 +77,14 @@ struct nbu2ss_udc udc_controller;
 /* Read */
 static inline u32 _nbu2ss_readl(void *address)
 {
-	return __raw_readl(address) ;
+	return __raw_readl(address);
 }
 
 /*-------------------------------------------------------------------------*/
 /* Write */
 static inline void _nbu2ss_writel(void *address, u32 udata)
 {
-	__raw_writel(udata, address) ;
+	__raw_writel(udata, address);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -92,7 +92,7 @@ static inline void _nbu2ss_writel(void *address, u32 udata)
 static inline void _nbu2ss_bitset(void *address, u32 udata)
 {
 	u32	reg_dt = __raw_readl(address) | (udata);
-	__raw_writel(reg_dt, address) ;
+	__raw_writel(reg_dt, address);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -100,7 +100,7 @@ static inline void _nbu2ss_bitset(void *address, u32 udata)
 static inline void _nbu2ss_bitclr(void *address, u32 udata)
 {
 	u32	reg_dt = __raw_readl(address) & ~(udata);
-	__raw_writel(reg_dt, address) ;
+	__raw_writel(reg_dt, address);
 }
 
 #ifdef UDC_DEBUG_DUMP
-- 
1.9.1

