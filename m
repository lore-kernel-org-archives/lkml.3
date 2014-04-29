Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaD2DDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:03:31 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:12555
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514AbaD2DD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:03:28 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 0/3] clocksource: Add Freescale FlexTimer Module (FTM) timer support
Date: Tue, 29 Apr 2014 10:18:56 +0800
Message-ID: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(77982001)(74502001)(79102001)(4396001)(46102001)(31966008)(81542001)(36756003)(62966002)(81342001)(76482001)(80022001)(47776003)(20776003)(77156001)(50226001)(92566001)(83072002)(50466002)(86362001)(88136002)(101416001)(80976001)(44976005)(92726001)(6806004)(83322001)(48376002)(89996001)(77096999)(19580395003)(87936001)(99396002)(87286001)(85852003)(93916002)(50986999);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB502;H:tx30smr01.am.freescale.net;FPR:F8AFCF3C.2C3F9CE9.7F616B30.DCCC2A99.20151;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes in V3:
- Fix the ftm_irq_disable.

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

