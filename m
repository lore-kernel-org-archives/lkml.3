Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbaD3F2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:28:46 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:40562
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754820AbaD3F2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:28:43 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <mark.rutland@arm.com>, <broonie@kernel.org>
CC: <gregkh@linuxfoundation.org>, <mpa@pengutronix.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 0/2] add DT endianness binding support
Date: Wed, 30 Apr 2014 12:43:47 +0800
Message-ID: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(77982001)(46102001)(87936001)(50986999)(48376002)(99396002)(6806004)(83072002)(77096999)(101416001)(50226001)(77156001)(79102001)(89996001)(4396001)(20776003)(92566001)(50466002)(19580395003)(81342001)(81542001)(92726001)(85852003)(74662001)(76482001)(80022001)(36756003)(83322001)(93916002)(47776003)(86362001)(80976001)(87286001)(44976005)(62966002)(31966008)(88136002)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:tx30smr01.am.freescale.net;FPR:3C1EDB13.1C1BD810.73650FC3.48C732F2.20104;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V3:
- Follow Mark Rutland's advice.
- Document common case of the endianess usage.

Changes in V2:
- Namespace the properties using the prefix sring.
- Add one binding ducomentation off regmap.

Xiubo Li (2):
  dt/bindings: Add the DT binding documentation for endianness
  regmap: add DT endianness binding support.

 .../devicetree/bindings/endianness/endianness.txt  |  47 +++++++
 drivers/base/regmap/regmap-i2c.c                   |   2 +
 drivers/base/regmap/regmap-spi.c                   |   2 +
 drivers/base/regmap/regmap.c                       | 147 +++++++++++++++++++--
 4 files changed, 187 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/endianness/endianness.txt

-- 
1.8.4

