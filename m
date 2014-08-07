Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbaHGJda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:33:30 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:24429
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754057AbaHGJd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:33:29 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 0/2] refine esai for tdm support
Date: Thu, 7 Aug 2014 17:33:23 +0800
Message-ID: <cover.1407403727.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(76482001)(2201001)(36756003)(92566001)(87936001)(95666004)(64706001)(87286001)(105606002)(99396002)(92726001)(102836001)(20776003)(89996001)(88136002)(21056001)(85306004)(46102001)(86362001)(77156001)(47776003)(104016003)(26826002)(68736004)(85852003)(74502001)(74662001)(81542001)(79102001)(83072002)(77982001)(229853001)(44976005)(6806004)(107046002)(84676001)(50986999)(104166001)(106466001)(93916002)(97736001)(62966002)(81342001)(31966008)(33646002)(83322001)(80022001)(4396001)(50226001)(48376002)(50466002)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB252;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patchs is to refine esai for tdm support.

Changes for V2
- update the comments according the reviewer's suggestion
- add init value for slots and change pin to pins.

Shengjiu Wang (2):
  ASoC: fsl_esai: refine esai for TDM support
  Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."

 sound/soc/fsl/Kconfig    |    1 -
 sound/soc/fsl/fsl_esai.c |   16 +++++++++++-----
 sound/soc/fsl/fsl_esai.h |    8 ++++----
 3 files changed, 15 insertions(+), 10 deletions(-)

-- 
1.7.9.5

