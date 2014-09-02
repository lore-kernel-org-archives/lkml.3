Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaIBKR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:17:57 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:44647
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751180AbaIBKRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:17:53 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/4]  simple-card: simplify the code.
Date: Tue, 2 Sep 2014 17:26:05 +0800
Message-ID: <1409649969-15759-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(62966002)(104016003)(102836001)(90102001)(84676001)(92726001)(85306004)(79102001)(69596002)(47776003)(48376002)(46102001)(97736001)(21056001)(36756003)(83072002)(104166001)(31966008)(95666004)(86362001)(106466001)(85852003)(26826002)(76482001)(2201001)(77982001)(80022001)(19580395003)(81156004)(44976005)(105606002)(229853001)(64706001)(50466002)(92566001)(87286001)(88136002)(81342001)(50986999)(83322001)(93916002)(89996001)(50226001)(20776003)(99396002)(77156001)(81542001)(74662001)(74502001)(6806004)(4396001)(107046002)(87936001)(68736004)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0617;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And comment and advice are welcome.


Change in v2:
- Maintian compatibility with the old DTs.

Change in v1:
- Add simple-card dts node patches.
- Fix format parsing bug from Jean-Francois's comment.
- Rebase to Kuninori-san's newest changes in next branch.

Xiubo Li (4):
  ASoC: simple-card: add asoc_simple_card_fmt_master() to simplify the
    code.
  ASoC: simple-card: Merge single and muti DAI link(s) code.
  ASoC: simple-card: Adjust the comments of simple card.
  ASoC: simple-card: binding: update binding to support the new style.

 .../devicetree/bindings/sound/simple-card.txt      | 184 ++++++++++++++-------
 sound/soc/generic/simple-card.c                    | 131 ++++++++-------
 2 files changed, 191 insertions(+), 124 deletions(-)

-- 
1.8.4

