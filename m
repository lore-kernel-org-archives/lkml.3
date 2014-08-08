Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaHHFWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:22:00 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:8194
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755152AbaHHFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:21:52 -0400
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>
CC: <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 0/2] refine esai for tdm support
Date: Fri, 8 Aug 2014 13:21:22 +0800
Message-ID: <cover.1407475184.git.shengjiu.wang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(44976005)(83322001)(102836001)(6806004)(46102001)(26826002)(81542001)(85306004)(106466001)(84676001)(107046002)(68736004)(105606002)(229853001)(97736001)(104016003)(33646002)(95666004)(50466002)(64706001)(4396001)(50226001)(48376002)(47776003)(20776003)(80022001)(21056001)(77156001)(81342001)(50986999)(36756003)(76482001)(74502001)(104166001)(77982001)(62966002)(87286001)(87936001)(79102001)(89996001)(93916002)(86362001)(88136002)(92566001)(92726001)(2201001)(83072002)(99396002)(74662001)(85852003)(31966008)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0621;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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

