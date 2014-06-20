Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbaFTXLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:11:10 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:28417
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755925AbaFTXLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:11:06 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: [PATCHv6 0/3] Addition of Altera SDRAM EDAC
Date: Fri, 20 Jun 2014 18:16:56 -0500
Message-ID: <1403306219-3903-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403306219-3903-1-git-send-email-tthayer@altera.com>
References: <1403306219-3903-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(31966008)(16796002)(95666004)(85306003)(81342001)(6806004)(74662001)(105596002)(74502001)(50466002)(106466001)(36756003)(79102001)(47776003)(20776003)(64706001)(80022001)(102836001)(76176999)(50986999)(97736001)(99396002)(86362001)(19580395003)(77156001)(87936001)(48376002)(2201001)(92566001)(86152002)(92726001)(87286001)(68736004)(81542001)(44976005)(19580405001)(83322001)(77096002)(50226001)(104166001)(4396001)(77982001)(76482001)(46102001)(85852003)(84676001)(83072002)(89996001)(21056001)(88136002)(33646001)(42186005)(93916002)(62966002)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB020;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

Addition of the Altera SDRAM controller to the EDAC driver.

Thor Thayer (3):
  Addition of the Altera SDRAM controller bindings and device     tree
    changes to the Altera SoC project.
  Addition of the Altera SDRAM EDAC bindings and device     tree
    changes to the Altera SoC project.
  edac: altera: Add EDAC support for Altera SoC SDRAM Controller.    
    This patch adds support for the CycloneV and ArriaV SDRAM    
    controllers.     Correction and reporting of SBEs, Panic on DBEs.

 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +
 .../bindings/arm/altera/socfpga-sdram.txt          |   11 +
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +
 drivers/edac/Kconfig                               |    9 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/altera_edac.c                         |  448 ++++++++++++++++++++
 6 files changed, 496 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
 create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
 create mode 100644 drivers/edac/altera_edac.c

-- 
1.7.9.5

