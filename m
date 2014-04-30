Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbaD3Jgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:36:46 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:41019
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758569AbaD3Jgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:36:44 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <mark.rutland@arm.com>, <broonie@kernel.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <richardcochran@gmail.com>
CC: <gregkh@linuxfoundation.org>, <mpa@pengutronix.de>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 resend 0/2] add DT endianness binding support.
Date: Wed, 30 Apr 2014 16:51:59 +0800
Message-ID: <1398847921-9322-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(80976001)(6806004)(48376002)(62966002)(19580395003)(81542001)(83322001)(36756003)(101416001)(77156001)(44976005)(50226001)(50986999)(88136002)(77982001)(99396002)(92726001)(46102001)(47776003)(50466002)(20776003)(87286001)(79102001)(87936001)(77096999)(80022001)(74502001)(2201001)(74662001)(76482001)(81342001)(92566001)(31966008)(93916002)(83072002)(89996001)(86362001)(85852003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB497;H:tx30smr01.am.freescale.net;FPR:3C1EDB13.9C1BD810.73E50FC3.784432BA.2012E;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0197AFBD92
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in V3 resend:
- Add arm list and rmk for review.
- Fix one comment from Markus Pargmann.

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

