Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaIIJ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:28:48 -0400
Received: from mail-by2on0139.outbound.protection.outlook.com ([207.46.100.139]:15360
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753366AbaIIJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:28:47 -0400
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 05:28:46 EDT
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>
CC: <shengjiu.wang@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 0/3] refine the ssi clock for imx6sl, and update dts file.
Date: Tue, 9 Sep 2014 17:13:24 +0800
Message-ID: <cover.1410253534.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(189002)(199003)(107046002)(92566001)(76482001)(50986999)(86362001)(81542001)(2201001)(93916002)(92726001)(87286001)(77982001)(79102001)(48376002)(50466002)(74662001)(95666004)(106466001)(31966008)(74502001)(105606002)(99396002)(6806004)(44976005)(83322001)(68736004)(19580395003)(89996001)(47776003)(81342001)(84676001)(46102001)(64706001)(229853001)(85852003)(83072002)(20776003)(97736003)(88136002)(80022001)(36756003)(87936001)(21056001)(85306004)(90102001)(102836001)(62966002)(26826002)(33646002)(104016003)(4396001)(50226001)(104166001)(77156001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB341;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial patch is for refining the ssi clock tree for imx6sl,
and update imx6qdl and imx6sl dts file.

Shengjiu Wang (3):
  ARM: clk-imx6sl: refine clock tree for SSI
  ARM: dts: imx6qdl: add baud clock and clock-names for ssi
  ARM: dts: imx6sl: add baud clock and clock-names for ssi

 arch/arm/boot/dts/imx6qdl.dtsi           |   12 +++++++++---
 arch/arm/boot/dts/imx6sl.dtsi            |   12 +++++++++---
 arch/arm/mach-imx/clk-imx6sl.c           |   13 ++++++++++---
 include/dt-bindings/clock/imx6sl-clock.h |    5 ++++-
 4 files changed, 32 insertions(+), 10 deletions(-)

-- 
1.7.9.5

