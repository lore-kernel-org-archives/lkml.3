Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaLJItK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:10 -0500
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:52841
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbaLJItG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:06 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 06/15] ARM: dts: imx6q: Add MIPI DSI remote end points for IPU2 DI0/1 end points
Date: Wed, 10 Dec 2014 16:37:19 +0800
Message-ID: <1418200648-32656-7-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(48376002)(68736005)(77096005)(50466002)(31966008)(92566001)(46102003)(36756003)(104016003)(4396001)(50226001)(110136001)(50986999)(106466001)(97736003)(99396003)(19580395003)(19580405001)(87936001)(84676001)(76176999)(105606002)(21056001)(107046002)(20776003)(64706001)(47776003)(89996001)(62966003)(86362001)(2351001)(77156002)(229853001)(6806004)(120916001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0640;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB0640;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0640;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MIPI DSI remote end points for IPU2 DI0/1 end points.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6q.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e6a6d90..82507e7 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -185,6 +185,7 @@
 				};
 
 				ipu2_di0_mipi: endpoint@2 {
+					remote-endpoint = <&mipi_mux_2>;
 				};
 
 				ipu2_di0_lvds0: endpoint@3 {
@@ -206,6 +207,7 @@
 				};
 
 				ipu2_di1_mipi: endpoint@2 {
+					remote-endpoint = <&mipi_mux_3>;
 				};
 
 				ipu2_di1_lvds0: endpoint@3 {
-- 
2.1.0

