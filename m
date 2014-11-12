Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaKLJ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:28:47 -0500
Received: from mail-bn1on0139.outbound.protection.outlook.com ([157.56.110.139]:61248
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbaKLJ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:28:43 -0500
From: Robin Gong <b38343@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <smoch@web.de>
Subject: [PATCH 3/3] ARM: configs: imx_v6_v7_defconfig: add power off driver
Date: Wed, 12 Nov 2014 16:20:39 +0800
Message-ID: <1415780439-29728-4-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415780439-29728-1-git-send-email-b38343@freescale.com>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(95666004)(6806004)(105606002)(47776003)(20776003)(64706001)(102836001)(104166001)(62966003)(77156002)(50986999)(19580405001)(19580395003)(4396001)(68736004)(106466001)(48376002)(36756003)(33646002)(104016003)(229853001)(50226001)(44976005)(120916001)(99396003)(87936001)(87286001)(50466002)(89996001)(93916002)(107046002)(88136002)(76176999)(31966008)(92726001)(2201001)(92566001)(46102003)(21056001)(84676001)(97736003)(921003)(1121002)(42262002)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0633;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add power off driver in config file.

Signed-off-by: Robin Gong <b38343@freescale.com>
---
 arch/arm/configs/imx_v6_v7_defconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 16cfec4..a310e61 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -165,6 +165,9 @@ CONFIG_SPI_IMX=y
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_MC9S08DZ60=y
 CONFIG_GPIO_STMPE=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_IMX=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_IMX2_WDT=y
-- 
1.7.9.5

