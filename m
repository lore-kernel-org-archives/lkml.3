Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaGOEWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:22:20 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:49509
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbaGOEWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:22:18 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv5 0/2] add DT endianness binding support for regmap
Date: Tue, 15 Jul 2014 12:18:22 +0800
Message-ID: <1405397904-31202-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77156001)(31966008)(89996001)(68736004)(4396001)(86362001)(76482001)(102836001)(80022001)(93916002)(81542001)(95666004)(85852003)(50466002)(79102001)(84676001)(20776003)(81342001)(87936001)(6806004)(69596002)(104016003)(105606002)(36756003)(83072002)(50986999)(88136002)(44976005)(77982001)(92566001)(74502001)(92726001)(26826002)(19580395003)(97736001)(21056001)(87286001)(81156004)(50226001)(104166001)(229853001)(47776003)(46102001)(99396002)(106466001)(74662001)(64706001)(62966002)(48376002)(83322001)(85306003)(107046002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0615;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V5:
- remove the register's dt endianness support for it will always be BE
  for now.
- only support the register values buffers dt endianness support.



Xiubo Li (2):
  regmap: add DT endianness binding support.
  dt/bindings: Add the DT binding documentation for endianness

 .../devicetree/bindings/regmap/regmap.txt          |  48 +++++++++
 drivers/base/regmap/regmap-i2c.c                   |   2 +
 drivers/base/regmap/regmap-spi.c                   |   2 +
 drivers/base/regmap/regmap.c                       | 117 +++++++++++++++++++--
 4 files changed, 158 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt

-- 
1.8.5

