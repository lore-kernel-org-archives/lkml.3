Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaLCJRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:17:41 -0500
Received: from mail-bn1bn0102.outbound.protection.outlook.com ([157.56.110.102]:35552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbaLCJRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:17:38 -0500
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>
CC: <alexander.stein@systec-electronic.com>, <shawn.guo@linaro.org>,
        <linux-fbdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
Date: Wed, 3 Dec 2014 17:15:58 +0800
Message-ID: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(77096005)(4396001)(47776003)(77156002)(99396003)(68736005)(20776003)(87286001)(87936001)(50226001)(104016003)(120916001)(19580395003)(36756003)(93916002)(50986999)(6806004)(92726001)(102836001)(92566001)(84676001)(44976005)(86362001)(31966008)(46102003)(95666004)(105606002)(229853001)(107046002)(104166001)(97736003)(48376002)(89996001)(50466002)(62966003)(64706001)(106466001)(88136002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0677;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Framebuffer driver for the Freescale SoC Display Controller.


Change in V2:
- Use the native-mode timing as default.
- Add to_fsl_private().


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
 drivers/video/fbdev/fsl-dcfb.c                     | 814 +++++++++++++++++++++
 6 files changed, 922 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fsl,dcfb.txt
 create mode 100644 drivers/video/fbdev/fsl-dcfb.c

-- 
2.1.0.27.g96db324

