Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaBISxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:53:53 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62418 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaBISse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:34 -0500
From: Richard Weinberger <richard@nod.at>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM
	SUB-ARCHITECT...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/SAMSUNG ARM A...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 13/28] Remove S3C24XX_GPIO_EXTRA64
Date: Sun,  9 Feb 2014 19:47:51 +0100
Message-Id: <1391971686-9517-14-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/mach-s3c24xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index d876431..1c67f04 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -521,7 +521,6 @@ config MACH_ANUBIS
 	select HAVE_PATA_PLATFORM
 	select S3C2440_XTAL_12000000
 	select S3C24XX_DCLK
-	select S3C24XX_GPIO_EXTRA64
 	select S3C24XX_SIMTEC_PM if PM
 	select S3C_DEV_USB_HOST
 	help
-- 
1.8.4.2

