Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaIQJvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:51:54 -0400
Received: from mail-bn1on0143.outbound.protection.outlook.com ([157.56.110.143]:19123
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753854AbaIQJvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:51:51 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <sre@kernel.org>,
        <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 3/3] ARM: configs: imx_v6_v7_defconfig: add power off driver
Date: Wed, 17 Sep 2014 17:58:00 +0800
Message-ID: <1410947881-7345-4-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410947881-7345-1-git-send-email-b38343@freescale.com>
References: <1410947881-7345-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(44976005)(68736004)(19580405001)(31966008)(97736003)(83322001)(6806004)(85306004)(33646002)(84676001)(19580395003)(26826002)(77156001)(50986999)(102836001)(62966002)(105606002)(81342003)(85852003)(90102001)(47776003)(46102003)(76176999)(87286001)(87936001)(80022003)(88136002)(50226001)(21056001)(83072002)(64706001)(93916002)(92566001)(104016003)(20776003)(74662003)(99396002)(77982003)(2201001)(76482002)(89996001)(229853001)(48376002)(92726001)(74502003)(95666004)(106466001)(4396001)(107046002)(79102003)(104166001)(50466002)(81542003)(36756003)(1121002)(921003)(2101003)(42262002)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB344;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB344;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
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

