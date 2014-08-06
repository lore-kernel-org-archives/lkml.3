Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaHFKXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:23:16 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:47121
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755224AbaHFKXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:23:14 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V1 0/2] refine esai for tdm support
Date: Wed, 6 Aug 2014 18:23:02 +0800
Message-ID: <cover.1407320232.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(6806004)(77156001)(36756003)(44976005)(76482001)(68736004)(83322001)(46102001)(84676001)(74662001)(74502001)(107046002)(229853001)(86362001)(93916002)(31966008)(102836001)(104166001)(50986999)(26826002)(62966002)(50466002)(48376002)(81542001)(81342001)(80022001)(64706001)(47776003)(20776003)(85852003)(83072002)(89996001)(99396002)(92726001)(92566001)(2201001)(85306004)(87936001)(88136002)(87286001)(79102001)(4396001)(50226001)(33646002)(104016003)(77982001)(97736001)(106466001)(95666004)(105606002)(21056001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB249;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

refine esai for tdm support.

Shengjiu Wang (2):
  ASoC: fsl: esai: refine esai for tdm support
  Revert "ASoC: fsl-esai: Add .xlate_tdm_slot_mask() support."

 sound/soc/fsl/Kconfig    |    1 -
 sound/soc/fsl/fsl_esai.c |   12 +++++++-----
 sound/soc/fsl/fsl_esai.h |    8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
1.7.9.5

