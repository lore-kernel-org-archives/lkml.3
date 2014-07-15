Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaGOE0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:26:50 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:41382
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862AbaGOE0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:26:45 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <mark.rutland@arm.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv6 0/2] add DT endianness binding support for regmap
Date: Tue, 15 Jul 2014 12:23:01 +0800
Message-ID: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(189002)(199002)(97736001)(87936001)(74662001)(4396001)(31966008)(81542001)(107046002)(79102001)(81342001)(77156001)(104166001)(36756003)(95666004)(81156004)(74502001)(50466002)(77982001)(6806004)(106466001)(85852003)(99396002)(50986999)(104016003)(21056001)(48376002)(84676001)(19580395003)(88136002)(83072002)(92726001)(229853001)(62966002)(93916002)(87286001)(102836001)(89996001)(44976005)(20776003)(105606002)(26826002)(83322001)(80022001)(86362001)(92566001)(46102001)(69596002)(50226001)(85306003)(47776003)(68736004)(64706001)(76482001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0613;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

Changes in V6:
- there is some mistake for V5 patch series, resend it.

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

