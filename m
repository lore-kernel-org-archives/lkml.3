Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3CFWeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:34:02 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51888 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab3CFWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:34:01 -0500
Message-ID: <1362609234.28137.2.camel@x61.thuisdomein>
Subject: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 23:33:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2013 22:33:54.0774 (UTC) FILETIME=[AF4ECF60:01CE1ABA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unused Kconfig symbol MACH_N35 was removed in commit
85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
mach-s3c2410/* into mach-s3c24xx/"). But there is still one (pointless)
select statement for that symbol. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/arm/mach-s3c24xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 37f513d..7361b9d 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -320,7 +320,6 @@ config PM_H1940
 
 config MACH_N30
 	bool "Acer N30 family"
-	select MACH_N35
 	select S3C_DEV_NAND
 	select S3C_DEV_USB_HOST
 	help
-- 
1.7.11.7

