Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaICDPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:15:08 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:44852
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871AbaICDPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:15:05 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <perex@perex.cz>, <lgirdwood@gmail.com>,
        <tiwai@suse.de>, <moinejf@free.fr>, <andrew@lunn.ch>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv3 0/3] ASoC: simple-card: simplify the code.
Date: Wed, 3 Sep 2014 10:23:38 +0800
Message-ID: <1409711021-19277-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(21056001)(76482001)(46102001)(77982001)(90102001)(102836001)(104166001)(104016003)(77156001)(79102001)(97736001)(26826002)(99396002)(50986999)(50466002)(69596002)(68736004)(50226001)(4396001)(48376002)(62966002)(31966008)(74662001)(74502001)(83322001)(19580395003)(44976005)(6806004)(93916002)(2201001)(86362001)(92566001)(87286001)(92726001)(88136002)(89996001)(87936001)(84676001)(83072002)(85852003)(64706001)(47776003)(20776003)(95666004)(85306004)(81342001)(105606002)(81156004)(106466001)(80022001)(107046002)(36756003)(81542001)(229853001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0621;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comment and advice are welcome.

Change in v3:
- Fix binding from Jean's comment.
- Remove 'ASoC: simple-card: add asoc_simple_card_fmt_master() to simplify the code.'
  and will send it separately later.

Change in v2:
- Maintian compatibility with the old DTs.

Change in v1:
- Add simple-card dts node patches.
- Fix format parsing bug from Jean-Francois's comment.
- Rebase to Kuninori-san's newest changes in next branch.




Xiubo Li (3):
  ASoC: simple-card: Merge single and muti DAI link(s) code.
  ASoC: simple-card: Adjust the comments of simple card.
  ASoC: simple-card: binding: update binding to support the new style.

 .../devicetree/bindings/sound/simple-card.txt      | 183 ++++++++++++++-------
 sound/soc/generic/simple-card.c                    |  70 ++++----
 2 files changed, 161 insertions(+), 92 deletions(-)

-- 
1.8.4

