Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155AbaHDERU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:17:20 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:9194
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbaHDERT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:17:19 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>
Subject: [PATCH 0/2] ASoC: fsl_asrc: Fix two dereferenced variable before check
Date: Mon, 4 Aug 2014 12:19:47 +0800
Message-ID: <cover.1407125653.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130515994357724463;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(189002)(199002)(64706001)(47776003)(6806004)(21056001)(77156001)(19580405001)(44976005)(36756003)(62966002)(50226001)(95666004)(73972005)(20776003)(82202001)(105596002)(19580395003)(80022001)(79102001)(81342001)(46102001)(61266001)(74502001)(97736001)(81156004)(55446002)(77982001)(48376002)(110136001)(69596002)(104166001)(87286001)(84676001)(87936001)(86362001)(99396002)(50986999)(2351001)(87572001)(107046002)(92566001)(81442001)(50466002)(88136002)(93916002)(81542001)(92726001)(74662001)(31966008)(102836001)(83072002)(4396001)(106466001)(85306004)(68736004)(229853001)(33646002)(89996001)(73392001)(104016003)(85852003)(26826002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB619;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fixes two warning of dereferenced variable reported by
Dan Carpenter <dan.carpenter@oracle.com>

Nicolin Chen (2):
  ASoC: fsl_sarc_dma: Check pair before using it
  ASoC: fsl_asrc: Don't access members of config before checking it

 sound/soc/fsl/fsl_asrc.c     | 9 ++++++---
 sound/soc/fsl/fsl_asrc_dma.c | 9 +++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.8.4

