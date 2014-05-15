Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaEOP6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:58:54 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:3406
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751764AbaEOP6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:58:52 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Add EDAC support for Altera SoC SDRAM Controller
Date: Thu, 15 May 2014 11:04:48 -0500
Message-ID: <1400169891-29546-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(80022001)(88136002)(46102001)(50226001)(79102001)(48376002)(99396002)(20776003)(42186004)(87286001)(84676001)(83322001)(81542001)(31966008)(86152002)(77982001)(102836001)(6806004)(47776003)(4396001)(97736001)(558084003)(62966002)(44976005)(50986999)(33646001)(93916002)(87936001)(50466002)(86362001)(92726001)(2201001)(74502001)(92566001)(74662001)(77156001)(83072002)(36756003)(81342001)(76482001)(16796002)(89996001)(85852003)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB028;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv5 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
[PATCHv5 2/3] dts: socfpga: Add bindings for Altera SoC SDRAM EDAC
[PATCHv5 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM
