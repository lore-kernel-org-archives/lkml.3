Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaHHGrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:47:25 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:55359
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754080AbaHHGrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:47:24 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 0/2]  refine esai for tdm support
Date: Fri, 8 Aug 2014 14:47:20 +0800
Message-ID: <cover.1407480333.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(44976005)(102836001)(83322001)(6806004)(46102001)(81542001)(106466001)(85306004)(84676001)(107046002)(68736004)(105606002)(229853001)(97736001)(104016003)(33646002)(95666004)(26826002)(50466002)(64706001)(4396001)(50226001)(48376002)(47776003)(20776003)(80022001)(21056001)(77156001)(81342001)(50986999)(36756003)(76482001)(74502001)(104166001)(77982001)(62966002)(87286001)(87936001)(79102001)(89996001)(93916002)(86362001)(88136002)(92726001)(92566001)(2201001)(83072002)(99396002)(74662001)(85852003)(31966008)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0621;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patchs is to refine esai for tdm support.

Changes for V4
- update the comments for patch 2

Changes for V3
- update the comments for patch 2

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

