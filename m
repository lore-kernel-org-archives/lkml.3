Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaIAFVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:21:10 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:27980
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751078AbaIAFVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:21:08 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <andrew@lunn.ch>, <jsarha@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <shawn.guo@freescale.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv1 0/7] simple-card: simplify the code.
Date: Mon, 1 Sep 2014 12:29:34 +0800
Message-ID: <1409545781-20530-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(104016003)(85306004)(81342001)(68736004)(19580395003)(26826002)(102836001)(76482001)(36756003)(31966008)(83322001)(88136002)(104166001)(81542001)(44976005)(80022001)(229853001)(4396001)(64706001)(47776003)(20776003)(50226001)(87286001)(107046002)(95666004)(62966002)(99396002)(85852003)(48376002)(77156001)(50986999)(90102001)(74502001)(92566001)(106466001)(50466002)(6806004)(21056001)(77982001)(89996001)(79102001)(69596002)(2201001)(84676001)(105606002)(87936001)(74662001)(83072002)(46102001)(86362001)(93916002)(92726001)(97736001)(81156004)(921003)(1121002)(83996005)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB340;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change in v1:
- Add simple-card dts node patches.
- Fix format parsing bug from Jean-Francois's comment.
- Rebase to Kuninori-san's newest changes in next branch.


Xiubo Li (7):
  ASoC: simple-card: Merge single and muti DAI link code.
  ASoC: simple-card: Adjust the comments of simple card.
  ASoC: dts: vf610-twr: To support simple card newest style.
  ASoC: dts: kirkwood-t5325: To support simple card newest style.
  ASoC: dts: r8a7740-armadillo800eva-reference: To support simple card
    newest style.
  ASoC: dts: sh73a0-kzm9g-reference: To support simple card newest
    style.
  ASoC: dts: kirkwood-openrd-client: To support simple card newest
    style.

 .../devicetree/bindings/sound/simple-card.txt      | 101 ++++++------
 arch/arm/boot/dts/kirkwood-openrd-client.dts       |  15 +-
 arch/arm/boot/dts/kirkwood-t5325.dts               |  15 +-
 .../boot/dts/r8a7740-armadillo800eva-reference.dts |  21 +--
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |  18 ++-
 arch/arm/boot/dts/vf610-twr.dts                    |  17 +-
 sound/soc/generic/simple-card.c                    | 176 ++++++++-------------
 7 files changed, 160 insertions(+), 203 deletions(-)

-- 
1.8.4

