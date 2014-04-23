Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaDWHan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:30:43 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:1341
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756528AbaDWHak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:30:40 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <rob@landley.net>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/3] add DT endianness binding support
Date: Wed, 23 Apr 2014 14:46:32 +0800
Message-ID: <1398235595-13370-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(86362001)(87936001)(92726001)(92566001)(88136002)(99396002)(48376002)(77096999)(87286001)(81542001)(50466002)(77982001)(50986999)(77156001)(76482001)(81342001)(80022001)(31966008)(74662001)(80976001)(46102001)(20776003)(79102001)(74502001)(47776003)(4396001)(44976005)(83322001)(19580395003)(89996001)(83072002)(85852003)(62966002)(50226001)(6806004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB500;H:az84smr01.freescale.net;FPR:BF26EF07.1C1CEC1B.73654FF3.4CC7E276.200D6;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 01901B3451
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change in V2:
- Namespace the properties using the prefix sring.
- Add one binding ducomentation off regmap.

Xiubo Li (3):
  dt/bindings: Add the DT binding documentation for endianness
  regmap: Add the DT binding documentation for endianness
  regmap: add DT endianness binding support.

 .../devicetree/bindings/endianness/endianness.txt  | 55 +++++++++++++
 .../bindings/regmap/regmap-endianness.txt          | 48 +++++++++++
 drivers/base/regmap/regmap.c                       | 96 +++++++++++++++++++---
 3 files changed, 188 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap-endianness.txt

-- 
1.8.4

