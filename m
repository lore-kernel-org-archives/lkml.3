Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIAFdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:33:38 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:30292
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751405AbaIAFdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:33:37 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ARM: Kconfig: Open force maximum zone order for all SoCs
Date: Mon, 1 Sep 2014 12:42:21 +0800
Message-ID: <1409546541-4129-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(6029001)(189002)(199003)(87936001)(26826002)(74502001)(74662001)(31966008)(76482001)(81156004)(104016003)(107046002)(102836001)(19580395003)(19580405001)(83322001)(84676001)(81542001)(68736004)(69596002)(44976005)(6806004)(92566001)(83072002)(85852003)(92726001)(89996001)(88136002)(77156001)(77982001)(105606002)(36756003)(229853001)(46102001)(79102001)(95666004)(106466001)(81342001)(48376002)(104166001)(85306004)(50226001)(4396001)(90102001)(99396002)(50466002)(47776003)(50986999)(64706001)(62966002)(80022001)(97736001)(87286001)(20776003)(21056001)(93916002)(86362001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c49a775..bf8445c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1687,7 +1687,7 @@ config ARCH_WANT_GENERAL_HUGETLB
 source "mm/Kconfig"
 
 config FORCE_MAX_ZONEORDER
-	int "Maximum zone order" if ARCH_SHMOBILE_LEGACY
+	int "Maximum zone order"
 	range 11 64 if ARCH_SHMOBILE_LEGACY
 	default "12" if SOC_AM33XX
 	default "9" if SA1111 || ARCH_EFM32
-- 
1.8.4

