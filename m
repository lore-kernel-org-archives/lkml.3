Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaKXJdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:33:25 -0500
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:52672
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbaKXJdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:33:23 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <shawn.guo@linaro.org>, <jingchang.lu@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ARM: ls1021a: dtsi: add 'big-endian' property for scfg node
Date: Mon, 24 Nov 2014 17:17:24 +0800
Message-ID: <1416820644-10968-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(48376002)(31966008)(84676001)(99396003)(120916001)(87936001)(85426001)(104166001)(88136002)(104016003)(19580405001)(4396001)(19580395003)(6806004)(50226001)(44976005)(68736004)(97736003)(50466002)(50986999)(92566001)(107046002)(86362001)(87286001)(92726001)(93916002)(229853001)(106466001)(95666004)(62966003)(102836001)(36756003)(89996001)(47776003)(20776003)(105606002)(21056001)(64706001)(46102003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1235;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-Forefront-PRVS: 040513D301
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0833;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On LS1021A SoC, the scfg device is in BE mode.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 arch/arm/boot/dts/ls1021a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/ls1021a.dtsi b/arch/arm/boot/dts/ls1021a.dtsi
index 53c652a..28c37f1 100644
--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -142,6 +142,7 @@
 		scfg: scfg@1570000 {
 			compatible = "fsl,ls1021a-scfg", "syscon";
 			reg = <0x0 0x1570000 0x0 0x10000>;
+			big-endian;
 		};
 
 		clockgen: clocking@1ee1000 {
-- 
2.1.0.27.g96db324

