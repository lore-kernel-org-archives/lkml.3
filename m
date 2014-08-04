Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaHDLME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:12:04 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:3949
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752600AbaHDLMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:12:01 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <Guangyu.Chen@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 0/3] refine clock tree for esai in imx6q
Date: Mon, 4 Aug 2014 19:11:12 +0800
Message-ID: <cover.1407148853.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(92566001)(79102001)(88136002)(104016003)(229853001)(21056001)(33646002)(86362001)(77982001)(64706001)(106466001)(93916002)(81156004)(48376002)(107046002)(36756003)(84676001)(87286001)(89996001)(81342001)(20776003)(87936001)(99396002)(95666004)(2201001)(50466002)(62966002)(83072002)(47776003)(31966008)(97736001)(83322001)(102836001)(50226001)(69596002)(46102001)(80022001)(6806004)(85852003)(74502001)(44976005)(26826002)(105606002)(74662001)(76482001)(92726001)(77156001)(81542001)(50986999)(85306004)(4396001)(68736004)(104166001)(32563001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB335;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series refine the clock tree for esai in imx6q

Shengjiu Wang (3):
  ARM: clk-imx6q: refine clock tree for ESAI
  ARM: clk-imx6q: Add missing lvds2 clock to the clock tree
  ARM: imx6q: Add the clock route from external OSC to ESAI clock

 arch/arm/mach-imx/clk-imx6q.c             |   21 +++++++++++++++++----
 arch/arm/mach-imx/mach-imx6q.c            |   28 ++++++++++++++++++++++++++++
 include/dt-bindings/clock/imx6qdl-clock.h |   12 +++++++++---
 3 files changed, 54 insertions(+), 7 deletions(-)

-- 
1.7.9.5

