Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaFTXKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 19:10:39 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:33127
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751695AbaFTXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 19:10:36 -0400
From: <tthayer@altera.com>
To: <robherring2@gmail.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <dinguyen@altera.com>,
        <dougthompson@xmission.com>, <grant.likely@linaro.org>, <bp@alien8.de>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tthayer.linux@gmail.com>,
        <tthayer@altera.com>
Subject: Add EDAC support for Altera SDRAM Controller
Date: Fri, 20 Jun 2014 18:16:55 -0500
Message-ID: <1403306219-3903-1-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(93916002)(44976005)(86362001)(62966002)(106466001)(83322001)(68736004)(105596002)(74662001)(74502001)(21056001)(89996001)(85852003)(83072002)(50466002)(77156001)(6806004)(33646001)(87936001)(86152002)(92726001)(88136002)(92566001)(2201001)(87286001)(48376002)(558084003)(84676001)(102836001)(80022001)(47776003)(20776003)(64706001)(85306003)(77096002)(77982001)(4396001)(50226001)(46102001)(42186005)(36756003)(76482001)(104166001)(79102001)(99396002)(16796002)(81542001)(31966008)(97736001)(95666004)(81342001)(50986999)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB022;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=tthayer@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCHv6 1/3] dt: bindings: Addition of the Altera SDRAM controller
[PATCHv6 2/3] dt: bindings: Addition of the Altera SDRAM EDAC 
[PATCHv6 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM
