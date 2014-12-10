Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaLJIse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:48:34 -0500
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:11572
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753067AbaLJIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:48:31 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 05/15] ARM: dts: imx6qdl: Add input-port property to MIPI DSI node's CTRC child nodes
Date: Wed, 10 Dec 2014 16:37:18 +0800
Message-ID: <1418200648-32656-6-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(87936001)(84676001)(107046002)(19580405001)(19580395003)(229853001)(2351001)(6806004)(89996001)(105606002)(99396003)(97736003)(47776003)(76176999)(20776003)(64706001)(50986999)(120916001)(106466001)(50466002)(92566001)(77156002)(62966003)(68736005)(77096005)(86362001)(31966008)(48376002)(36756003)(110136001)(104016003)(46102003)(50226001)(21056001)(4396001)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0631;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BY2PR0301MB0631;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To phase out the MIPI DSI's child nodes which present DRM CRTCs from the
child nodes which represent MIPI DSI peripherals, we need to add input-port
property to the child nodes to be phased out.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6q.dtsi   | 2 ++
 arch/arm/boot/dts/imx6qdl.dtsi | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
index e9f3646..e6a6d90 100644
--- a/arch/arm/boot/dts/imx6q.dtsi
+++ b/arch/arm/boot/dts/imx6q.dtsi
@@ -294,6 +294,7 @@
 &mipi_dsi {
 	port@2 {
 		reg = <2>;
+		input-port;
 
 		mipi_mux_2: endpoint {
 			remote-endpoint = <&ipu2_di0_mipi>;
@@ -302,6 +303,7 @@
 
 	port@3 {
 		reg = <3>;
+		input-port;
 
 		mipi_mux_3: endpoint {
 			remote-endpoint = <&ipu2_di1_mipi>;
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index 9596ed5..5d92ad7 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1011,6 +1011,7 @@
 
 				port@0 {
 					reg = <0>;
+					input-port;
 
 					mipi_mux_0: endpoint {
 						remote-endpoint = <&ipu1_di0_mipi>;
@@ -1019,6 +1020,7 @@
 
 				port@1 {
 					reg = <1>;
+					input-port;
 
 					mipi_mux_1: endpoint {
 						remote-endpoint = <&ipu1_di1_mipi>;
-- 
2.1.0

