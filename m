Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaEEWq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:46:29 -0400
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:53972
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756800AbaEEWq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:46:27 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: edac: altera: Add EDAC support for Altera SDRAM Controller
Date: Mon, 5 May 2014 17:52:14 -0500
Message-ID: <1399330337-16748-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(20776003)(4396001)(87286001)(88136002)(50226001)(47776003)(86362001)(46102001)(86152002)(81542001)(2009001)(83072002)(80022001)(89996001)(44976005)(84676001)(36756003)(81342001)(77982001)(79102001)(83322001)(33646001)(97736001)(50466002)(87936001)(50986999)(74502001)(77156001)(48376002)(85852003)(558084003)(92726001)(74662001)(16796002)(31966008)(76482001)(99396002)(6806004)(62966002)(92566001)(93916002)(2201001)(921003)(1121002)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB031;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:29D3D6EF.A6D6B007.BD3996A.D4DC2CF7.20070;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0202D21D2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EDAC support for the Altera CycloneV and ArriaV
SoC SDRAM Controller.

[PATCHv3 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
[PATCHv3 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
[PATCHv3 3/3] edac: altera: Add EDAC support for Altera SDRAM
