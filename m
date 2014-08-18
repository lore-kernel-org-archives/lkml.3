Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaHRIjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:39:43 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:6074
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752308AbaHRIj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:39:29 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>,
        <shengjiu.wang@freescale.com>, <xobs@kosagi.com>, <arnd@arndb.de>,
        <sfr@canb.auug.org.au>, <timur@tabi.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH V1 0/3] fix build error/warning in sound/soc/fsl
Date: Mon, 18 Aug 2014 16:38:37 +0800
Message-ID: <cover.1408350626.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(189002)(199003)(83072002)(48376002)(81542001)(77156001)(33646002)(21056001)(46102001)(81342001)(76482001)(47776003)(89996001)(74502001)(93916002)(92726001)(2201001)(74662001)(92566001)(64706001)(20776003)(86362001)(85852003)(31966008)(50466002)(87936001)(80022001)(88136002)(105606002)(36756003)(62966002)(50226001)(68736004)(84676001)(104016003)(87286001)(95666004)(79102001)(77982001)(229853001)(4396001)(6806004)(85306004)(107046002)(50986999)(97736001)(26826002)(44976005)(83322001)(104166001)(102836001)(106466001)(99396002)(921003)(1121002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB244;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series patch is for fixing build error/waring in sound/soc/fsl

Shengjiu Wang (3):
  ASoC: fsl: Kconfig: remove dependence of SND_IMX_SOC for
    SND_SOC_IMX_PCM_DMA
  ASoC: fsl-asoc-card: Fix build warning for maybe-uninitialized
  ASoC: fsl: fsl-asoc-card: Select SND_SOC_IMX_AUDMUX

 sound/soc/fsl/Kconfig         |    9 +++++----
 sound/soc/fsl/fsl-asoc-card.c |    9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

-- 
1.7.9.5

