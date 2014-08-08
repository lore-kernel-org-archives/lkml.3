Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaHHHDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:03:34 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:42230
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755976AbaHHHDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:03:32 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <Guangyu.Chen@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/3] refine clock tree for esai in imx6q
Date: Fri, 8 Aug 2014 15:02:46 +0800
Message-ID: <cover.1407481023.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(64706001)(68736004)(20776003)(47776003)(81342001)(74502001)(31966008)(107046002)(80022001)(74662001)(77982001)(83322001)(44976005)(6806004)(33646002)(79102001)(229853001)(50466002)(48376002)(36756003)(85306004)(46102001)(4396001)(83072002)(85852003)(50226001)(95666004)(105606002)(93916002)(86362001)(77156001)(106466001)(2201001)(92566001)(92726001)(89996001)(87936001)(76482001)(84676001)(88136002)(21056001)(81542001)(99396002)(104016003)(104166001)(102836001)(26826002)(97736001)(87286001)(62966002)(50986999)(32563001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB435;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refine clock tree for esai in imx6q

Changes for V3
- Drop patch3, for waiting bypass mode implementation.
- As Lucas Stach suggestion, add new API for exclusive clock.

Changes for V2
- Add pll5_sel And update the comments for patch 2.
- As the bypass mode is not supported in clk tree, so update the 
- comments for patch 3.


Shengjiu Wang (3):
  ARM: clk-imx6q: refine clock tree for ESAI
  ARM: clk-gate2: Add API imx_clk_gate2_exclusive for clk_gate2
  ARM: clk-imx6q: Add missing lvds and anaclk clock to the clock tree

 arch/arm/mach-imx/clk-gate2.c             |   18 +++++++++++++++++-
 arch/arm/mach-imx/clk-imx6q.c             |   25 ++++++++++++++++++-------
 arch/arm/mach-imx/clk.h                   |    2 ++
 include/dt-bindings/clock/imx6qdl-clock.h |   13 ++++++++++---
 4 files changed, 47 insertions(+), 11 deletions(-)

-- 
1.7.9.5

