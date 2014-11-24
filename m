Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaKXKWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:22:21 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:38073
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750765AbaKXKWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:22:20 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <shawn.guo@linaro.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/4] LS1021A: Add dcfb framebuffer driver support.
Date: Mon, 24 Nov 2014 18:20:50 +0800
Message-ID: <1416824454-28156-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(92566001)(36756003)(93916002)(92726001)(46102003)(31966008)(86362001)(4396001)(50226001)(88136002)(104166001)(68736004)(44976005)(19580395003)(102836001)(6806004)(21056001)(50986999)(89996001)(87286001)(87936001)(48376002)(84676001)(50466002)(107046002)(229853001)(95666004)(106466001)(105606002)(20776003)(120916001)(47776003)(99396003)(64706001)(104016003)(97736003)(62966003)(77156002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0645;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Framebuffer driver for the Freescale SoC Display Controller.

Xiubo Li (4):
  video: fsl-dcfb: Add dcfb framebuffer driver for LS1021A platform
  video: fsl-dcfb: Add devicetree binding support
  ARM: ls1021a: dtsi: Add dt node support for dcfb.
  ARM: ls1021a: dts: Add and enable dt node for dcfb.

 .../devicetree/bindings/video/fsl,dcfb.txt         |  52 ++
 arch/arm/boot/dts/ls1021a-twr.dts                  |  26 +
 arch/arm/boot/dts/ls1021a.dtsi                     |  10 +
 drivers/video/fbdev/Kconfig                        |  19 +
 drivers/video/fbdev/Makefile                       |   1 +
 drivers/video/fbdev/fsl-dcfb.c                     | 811 +++++++++++++++++++++
 6 files changed, 919 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fsl,dcfb.txt
 create mode 100644 drivers/video/fbdev/fsl-dcfb.c

-- 
2.1.0.27.g96db324

