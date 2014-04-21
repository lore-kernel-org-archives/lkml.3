Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaDUIHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:07:11 -0400
Received: from [207.46.163.243] ([207.46.163.243]:51117 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751028AbaDUIG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:06:56 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <R64188@freescale.com>, <b40534@freescale.com>, <b35083@freescale.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/3] clocksource: Add Freescale FlexTimer Module (FTM) timer support
Date: Mon, 21 Apr 2014 15:23:00 +0800
Message-ID: <1398064983-440-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(81342001)(50466002)(83072002)(85852003)(79102001)(80976001)(80022001)(99396002)(74502001)(20776003)(6806004)(47776003)(31966008)(62966002)(48376002)(89996001)(74662001)(81542001)(87286001)(92726001)(50226001)(77156001)(77982001)(86362001)(50986999)(77096999)(44976005)(4396001)(83322001)(2201001)(92566001)(19580395003)(36756003)(87936001)(46102001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB469;H:az84smr01.freescale.net;FPR:F8A3CF3C.2C3F9C69.7F616B30.DDCC2A99.2013D;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
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

