Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaDUIEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:04:08 -0400
Received: from [207.46.163.139] ([207.46.163.139]:41111 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbaDUIEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:04:04 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <R64188@freescale.com>, <b40534@freescale.com>, <b35083@freescale.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/3] clocksource: Add Freescale FlexTimer Module (FTM) timer support
Date: Mon, 21 Apr 2014 15:19:57 +0800
Message-ID: <1398064800-27250-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(80022001)(79102001)(19580395003)(83322001)(47776003)(87936001)(44976005)(46102001)(50986999)(77156001)(2201001)(81342001)(87286001)(77982001)(89996001)(80976001)(92566001)(6806004)(20776003)(31966008)(86362001)(50466002)(62966002)(74502001)(83072002)(76482001)(74662001)(85852003)(81542001)(48376002)(99396002)(92726001)(77096999)(36756003)(4396001)(50226001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB473;H:az84smr01.freescale.net;FPR:F8A3CF3C.2C3F9C69.7F616B30.DDCC2A99.2013D;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0188D66E61
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes in V2:
- Add big-endian support.
- Add using pr_err instead of BUG_ON.
- Add more detail comment message of FTM.
- Add DT binding documentation.
- Remove some header files and macros not useful.



Xiubo Li (3):
  clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree
    Documentation
  ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
  clocksource: Add Freescale FlexTimer Module (FTM) timer support

 .../devicetree/bindings/timer/fsl,ftm-timer.txt    |  31 ++
 arch/arm/boot/dts/vf610.dtsi                       |  12 +
 drivers/clocksource/Kconfig                        |   5 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/fsl_ftm_timer.c                | 344 +++++++++++++++++++++
 5 files changed, 393 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
 create mode 100644 drivers/clocksource/fsl_ftm_timer.c

-- 
1.8.4

