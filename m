Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbaEICul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 22:50:41 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:50613
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754859AbaEICuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 22:50:35 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <gregkh@linuxfoundation.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <linux@arm.linux.org.uk>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Xiubo Li" <Li.Xiubo@freescale.com>
Subject: [PATCHv4 0/2] add DT endianness binding support.
Date: Fri, 9 May 2014 10:04:31 +0800
Message-ID: <1399601073-19278-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(979002)(6009001)(189002)(199002)(97736001)(62966002)(2009001)(87286001)(81156002)(99396002)(77156001)(50226001)(88136002)(81542001)(87936001)(21056001)(80022001)(47776003)(6806004)(68736004)(69596002)(44976005)(19580395003)(83322001)(20776003)(79102001)(64706001)(84676001)(86362001)(4396001)(76482001)(89996001)(77982001)(50466002)(93916002)(81342001)(48376002)(50986999)(31966008)(77096999)(74502001)(74662001)(46102001)(92726001)(2201001)(92566001)(83072002)(85852003)(36756003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 02065A9E77
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V4:
- Fix one comment from Markus Pargmann.
- Fix some comments.

Changes in V3:
- Follow Mark Rutland's advice.
- Document common case of the endianess usage.

Changes in V2:
- Namespace the properties using the prefix sring.
- Add one binding ducomentation off regmap.




Xiubo Li (2):
  dt/bindings: Add the DT binding documentation for endianness
  regmap: add DT endianness binding support.

 .../devicetree/bindings/endianness/endianness.txt  |  48 +++++++
 drivers/base/regmap/regmap-i2c.c                   |   2 +
 drivers/base/regmap/regmap-spi.c                   |   2 +
 drivers/base/regmap/regmap.c                       | 147 +++++++++++++++++++--
 4 files changed, 188 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt

-- 
1.8.4

