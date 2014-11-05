Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaKEKV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:21:59 -0500
Received: from mail-am1on0134.outbound.protection.outlook.com ([157.56.112.134]:40864
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbaKEKV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:21:57 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <shawn.guo@freescale.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH V2 2/2] ARM: dts: vf-colibri-eval-v3.dts: Enable ST-M41T0M6 RTC
Date: Wed, 5 Nov 2014 15:35:08 +0530
Message-ID: <b360a079a8a2acfc92a607105fb88bdd731155f7.1415181422.git.bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415181422.git.bhuvanchandra.dv@toradex.com>
References: <cover.1415181422.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA0022.apcprd03.prod.outlook.com (10.141.129.12) To
 DB3PR05MB266.eurprd05.prod.outlook.com (10.141.4.23)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB266;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(88136002)(2371004)(93916002)(86362001)(230783001)(575784001)(118296001)(97736003)(19580405001)(69596002)(19580395003)(50226001)(4396001)(31966008)(122386002)(50466002)(48376002)(21056001)(92566001)(46102003)(36756003)(107046002)(40100003)(62966003)(77096003)(77156002)(42186005)(102836001)(105586002)(104166001)(95666004)(81156004)(229853001)(53416004)(106356001)(101416001)(92726001)(89996001)(87286001)(2351001)(50986999)(87976001)(64706001)(47776003)(66066001)(120916001)(110136001)(99396003)(20776003)(76176999)(33646002)(7059028);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB266;H:trdx.toradex.int;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST-M41T0M6 is available on Colibri carrier boards.
Hence enable M41T0M6 RTC.

Acked-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 arch/arm/boot/dts/vf-colibri-eval-v3.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
index 7324bdc..20251a3 100644
--- a/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
+++ b/arch/arm/boot/dts/vf-colibri-eval-v3.dtsi
@@ -35,6 +35,12 @@
 
 &i2c0 {
 	status = "okay";
+
+	/* M41T0M6 real time clock on carrier board */
+	rtc: m41t0m6@68 {
+		compatible = "st,m41t00";
+		reg = <0x68>;
+	};
 };
 
 &pwm0 {
-- 
1.7.9.5

