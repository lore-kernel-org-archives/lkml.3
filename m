Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaIZDwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:52:55 -0400
Received: from mail-bn1on0148.outbound.protection.outlook.com ([157.56.110.148]:58135
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753518AbaIZDwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:52:50 -0400
From: Robin Gong <b38343@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <LW@KARO-electronics.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v4 3/3] ARM: configs: imx_v6_v7_defconfig: add power off driver
Date: Fri, 26 Sep 2014 11:59:07 +0800
Message-ID: <1411703947-31956-4-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411703947-31956-1-git-send-email-b38343@freescale.com>
References: <1411703947-31956-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(105606002)(81156004)(50466002)(2201001)(97736003)(85852003)(102836001)(77982003)(68736004)(69596002)(104166001)(87286001)(74502003)(80022003)(107046002)(46102003)(81542003)(36756003)(90102001)(89996001)(50226001)(47776003)(74662003)(33646002)(85306004)(106466001)(76176999)(77156001)(92566001)(83322001)(93916002)(83072002)(4396001)(64706001)(19580395003)(20776003)(31966008)(44976005)(95666004)(81342003)(6806004)(21056001)(84676001)(120916001)(79102003)(87936001)(229853001)(104016003)(10300001)(19580405001)(99396003)(76482002)(62966002)(92726001)(50986999)(48376002)(88136002)(1121002)(921003)(2101003)(42262002)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
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
index 8fca6e2..db886c2 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -162,6 +162,9 @@ CONFIG_SPI_IMX=y
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

