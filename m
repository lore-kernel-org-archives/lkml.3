Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaHFIfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:35:21 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:53238
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754182AbaHFIfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:35:17 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <Guangyu.Chen@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 0/3] refine clock tree for esai in imx6q
Date: Wed, 6 Aug 2014 16:35:12 +0800
Message-ID: <cover.1407313676.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(50226001)(4396001)(79102001)(77982001)(36756003)(62966002)(77156001)(48376002)(20776003)(80022001)(46102001)(81342001)(64706001)(47776003)(33646002)(81542001)(84676001)(83322001)(86362001)(93916002)(21056001)(74502001)(85852003)(229853001)(99396002)(50986999)(97736001)(68736004)(74662001)(31966008)(69596002)(107046002)(105606002)(85306004)(81156004)(106466001)(92566001)(95666004)(2201001)(102836001)(83072002)(76482001)(6806004)(104016003)(50466002)(87286001)(87936001)(26826002)(88136002)(92726001)(44976005)(89996001)(104166001)(32563001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB433;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refine clock tree for esai in imx6q

Changes for V2
- Add pll5_sel And update the comments for patch 2.
- As the bypass mode is not supported in clk tree, so update the 
- comments for patch 3.

Shengjiu Wang (3):
  ARM: clk-imx6q: refine clock tree for ESAI
  ARM: clk-imx6q: Add missing lvds and anaclk clock to the clock tree
  ARM: imx6q: Add the clock route from external OSC to ESAI clock

 arch/arm/mach-imx/clk-imx6q.c             |   24 +++++++++++++++++++-----
 arch/arm/mach-imx/mach-imx6q.c            |   28 ++++++++++++++++++++++++++++
 include/dt-bindings/clock/imx6qdl-clock.h |   13 ++++++++++---
 3 files changed, 57 insertions(+), 8 deletions(-)

-- 
1.7.9.5

