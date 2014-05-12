Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbaELXbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 19:31:33 -0400
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:59109
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752416AbaELXb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 19:31:27 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Addition of EDAC for Altera SoC SDRAM Controller
Date: Mon, 12 May 2014 18:36:54 -0500
Message-ID: <1399937817-2202-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(20776003)(47776003)(2009001)(558084003)(36756003)(76482001)(42186004)(77156001)(93916002)(86362001)(99396002)(83072002)(89996001)(48376002)(50986999)(87286001)(84676001)(92726001)(87936001)(88136002)(33646001)(97736001)(79102001)(77982001)(85852003)(50466002)(102836001)(92566001)(86152002)(2201001)(6806004)(80022001)(62966002)(46102001)(83322001)(44976005)(16796002)(74502001)(31966008)(81542001)(4396001)(50226001)(74662001)(81342001)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB055;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv4 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
[PATCHv4 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
[PATCHv4 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM Controller 
