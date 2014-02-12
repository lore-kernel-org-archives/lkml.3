Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBLJlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:41:13 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62429 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbaBLJlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:41:11 -0500
Message-ID: <1392198068.23759.7.camel@x220>
Subject: [PATCH] ARM: S3C24XX: Fix typo "CONFIG_CPUS_3C2443"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 10:41:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2014 09:41:09.0307 (UTC) FILETIME=[8F0640B0:01CF27D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. This needs testing by people with access to knowledge,
compilers, and/or hardware related to CPU_S3C2443. I'm not one of them. 

 arch/arm/mach-s3c24xx/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index 4adaa4b..1d77d70 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -484,7 +484,7 @@ struct platform_device s3c2440_device_dma = {
 };
 #endif
 
-#if defined(CONFIG_CPUS_3C2443) || defined(CONFIG_CPU_S3C2416)
+#if defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
 static struct resource s3c2443_dma_resource[] = {
 	[0] = DEFINE_RES_MEM(S3C24XX_PA_DMA, S3C24XX_SZ_DMA),
 	[1] = DEFINE_RES_IRQ(IRQ_S3C2443_DMA0),
-- 
1.8.5.3

