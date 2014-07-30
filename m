Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaG3DIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:08:09 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:55784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753918AbaG3DIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:08:07 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>, <tiwai@suse.de>,
        <perex@perex.cz>, <linux-kernel@vger.kernel.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH 0/4] ASoC: fsl: Add stream names to CPU DAI drivers for DPCM
Date: Wed, 30 Jul 2014 11:10:25 +0800
Message-ID: <cover.1406688048.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130511632856225163;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(19580395003)(55446002)(104166001)(33646002)(89996001)(47776003)(61266001)(229853001)(2351001)(105596002)(82202001)(73392001)(104016003)(74502001)(99396002)(93916002)(36756003)(86362001)(6806004)(87572001)(77156001)(50466002)(110136001)(46102001)(84676001)(95666004)(92566001)(83072002)(92726001)(81342001)(88136002)(20776003)(80022001)(31966008)(81442001)(73972005)(87286001)(87936001)(62966002)(106466001)(48376002)(4396001)(50226001)(102836001)(68736004)(77982001)(107046002)(50986999)(64706001)(81542001)(74662001)(44976005)(85852003)(26826002)(97736001)(79102001)(21056001)(85306003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB354;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0288CD37D9
Authentication-Results: spf=softfail (sender IP is 192.88.168.50)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DPCM needs extra dapm routes in the machine driver to route audio
between Front-End and Back-End. In order to differ the stream names
in the route map from CODECs, we here add specific stream names to
all Freescale ASoC CPU DAI drivers so that we can implement ASRC via
DPCM to each of them.

Document for DPCM: ./Documentation/sound/alsa/soc/DPCM.txt

Nicolin Chen (4):
  ASoC: fsl_esai: Add stream names for DPCM usage
  ASoC: fsl_sai: Add stream names for DPCM usage
  ASoC: fsl_spdif: Add stream names for DPCM usage
  ASoC: fsl_ssi: Add stream names for DPCM usage

 sound/soc/fsl/fsl_esai.c  | 2 ++
 sound/soc/fsl/fsl_sai.c   | 2 ++
 sound/soc/fsl/fsl_spdif.c | 2 ++
 sound/soc/fsl/fsl_ssi.c   | 2 ++
 4 files changed, 8 insertions(+)

-- 
1.8.4

