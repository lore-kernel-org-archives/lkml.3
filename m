Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaF0PU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:20:29 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:35327
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754150AbaF0PUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:20:23 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv8 0/3] Addition of Altera SDRAM Controller
Date: Fri, 27 Jun 2014 10:26:56 -0500
Message-ID: <1403882819-24929-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(81342001)(76482001)(95666004)(74502001)(79102001)(50986999)(46102001)(21056001)(31966008)(81542001)(50226001)(4396001)(85306003)(74662001)(105596002)(104166001)(42186005)(50466002)(77096002)(33646001)(48376002)(97736001)(106466001)(62966002)(20776003)(85852003)(6806004)(92726001)(47776003)(84676001)(19580405001)(87286001)(44976005)(64706001)(77156001)(83072002)(88136002)(107046002)(80022001)(2201001)(77982001)(99396002)(102836001)(83322001)(93916002)(89996001)(68736004)(19580395003)(86152002)(87936001)(36756003)(86362001)(92566001)(921003)(1121002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB141;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Thor Thayer (3):
  devicetree: Addition of the Altera SDRAM Controller.     Add the
    Altera SDRAM controller bindings and device     tree changes to the
    Altera SoC project.
  devicetree: Addition of the Altera SDRAM EDAC.     Add the Altera
    SDRAM EDAC bindings and device tree     changes to the Altera SoC
    project.
  edac: altera: Add EDAC support for Altera SoC SDRAM Controller.    
    This patch adds support for the CycloneV and ArriaV SDRAM    
    controllers.     Correction and reporting of SBEs, Panic on DBEs.

 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +
 .../bindings/arm/altera/socfpga-sdram.txt          |   11 +
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +
 drivers/edac/Kconfig                               |    9 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/altera_edac.c                         |  449 ++++++++++++++++++++
 6 files changed, 497 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
 create mode 100644 drivers/edac/altera_edac.c

-- 
1.7.9.5

