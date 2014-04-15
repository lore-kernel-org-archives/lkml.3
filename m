Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDOMPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:15:04 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:57359
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbaDOMPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:15:03 -0400
From: Anders Berg <anders.berg@lsi.com>
To: <arnd@arndb.de>, <olof@lixom.net>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <dbaryshkov@gmail.com>
CC: <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH 5/5] ARM: dts: axxia: Add reset controller
Date: Tue, 15 Apr 2014 14:06:14 +0200
Message-ID: <b61990ec230e1a4f922689aff46c9d6e1578be3a.1397552154.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1397552154.git.anders.berg@lsi.com>
References: <cover.1397552154.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA048.namprd07.prod.outlook.com (10.141.251.23) To
 BLUPR07MB370.namprd07.prod.outlook.com (10.141.26.147)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(19580395003)(89996001)(80976001)(81542001)(2201001)(87976001)(62966002)(87286001)(36756003)(76176999)(80022001)(20776003)(66066001)(47776003)(79102001)(50986999)(46102001)(77982001)(99396002)(53416003)(92726001)(74502001)(81342001)(76482001)(48376002)(83072002)(33646001)(4396001)(85852003)(83322001)(19580405001)(50466002)(86362001)(77156001)(93916002)(88136002)(50226001)(42186004)(74662001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB370;H:swsaberg01.lsi.com;FPR:DA36E570.4F2E9606.67D5EB76.94E56E71.200D6;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
index 25fc174..9e33a8e 100644
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

