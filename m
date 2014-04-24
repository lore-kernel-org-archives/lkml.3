Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaDXKqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:46:32 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:19348
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754359AbaDXKq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:46:29 -0400
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v2 6/6] ARM: dts: axxia: Add reset controller
Date: Thu, 24 Apr 2014 12:44:09 +0200
Message-ID: <a90c7c7bb7a922e71bd1ca503306ef2fdf81485e.1398335771.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1398335771.git.anders.berg@lsi.com>
References: <cover.1398335771.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA040.namprd07.prod.outlook.com (10.141.251.15) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(80976001)(83322001)(19580405001)(50226001)(53416003)(31966008)(74662001)(19580395003)(99396002)(85852003)(77982001)(89996001)(47776003)(46102001)(83072002)(42186004)(79102001)(76482001)(20776003)(80022001)(66066001)(4396001)(74502001)(86362001)(93916002)(87286001)(88136002)(36756003)(50466002)(33646001)(87976001)(76176999)(77156001)(50986999)(81542001)(81342001)(62966002)(48376002)(92726001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:swsaberg01.lsi.com;FPR:DA36E570.4F2E9605.A7D5EBA6.94E57E71.200D6;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the reset controller to the AXM5xx device tree.

Signed-off-by: Anders Berg <anders.berg@lsi.com>
---
 arch/arm/boot/dts/axm55xx.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/axm55xx.dtsi b/arch/arm/boot/dts/axm55xx.dtsi
index 5d63887..bd1e07d 100644
--- a/arch/arm/boot/dts/axm55xx.dtsi
+++ b/arch/arm/boot/dts/axm55xx.dtsi
@@ -208,6 +208,11 @@
 			reg = <0x20 0x10030000 0 0x2000>;
 		};
 
+		reset: reset@2010031000 {
+			compatible = "lsi,axm55xx-reset";
+			syscon = <&syscon>;
+		};
+
 		amba {
 			compatible = "arm,amba-bus";
 			#address-cells = <2>;
-- 
1.8.3.2

