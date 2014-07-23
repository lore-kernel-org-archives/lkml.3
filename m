Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaGWLVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:21:20 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:15652
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753068AbaGWLVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:21:19 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b42378@freescale.com>,
        <b02247@freescale.com>
Subject: [PATCH 0/3] ASoC: fsl_sai: Fix some issues in fsl_sai_trigger()
Date: Wed, 23 Jul 2014 19:23:37 +0800
Message-ID: <cover.1406113865.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130505880767496397;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(31966008)(87286001)(85852003)(93916002)(64706001)(92726001)(68736004)(88136002)(82202001)(104016003)(2351001)(55446002)(107046002)(81442001)(92566001)(81156004)(47776003)(36756003)(50226001)(102836001)(106466001)(46102001)(73972005)(20776003)(105596002)(81342001)(80022001)(61266001)(97736001)(95666004)(86362001)(79102001)(104166001)(50466002)(87572001)(62966002)(44976005)(99396002)(69596002)(110136001)(229853001)(6806004)(81542001)(48376002)(21056001)(26826002)(77156001)(4396001)(83072002)(74662001)(33646002)(87936001)(73392001)(74502001)(77982001)(84676001)(50986999)(85306003)(89996001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB362;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches focus on issue fix inside fsl_sai_trigger().

Nicolin Chen (3):
  ASoC: fsl_sai: Reduce race condition during TE/RE enabling
  ASoC: fsl_sai: Don't reset FIFO until TE/RE bit is unset
  ASoC: fsl_sai: Improve enable flow in fsl_sai_trigger()

 sound/soc/fsl/fsl_sai.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

-- 
1.8.4

