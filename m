Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaGQNT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:19:26 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:50769
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932498AbaGQNTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:19:22 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: [PATCH 0/2] ASoC: fsl_sai: Two bug fixes for fsl_sai driver
Date: Thu, 17 Jul 2014 21:21:36 +0800
Message-ID: <cover.1405603108.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130500767595639847;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(69596002)(92726001)(77982001)(73972005)(81156004)(68736004)(44976005)(74502001)(73392001)(92566001)(106466001)(74662001)(93916002)(97736001)(6806004)(31966008)(87572001)(558084003)(87286001)(26826002)(50466002)(104016003)(110136001)(89996001)(36756003)(48376002)(46102001)(88136002)(81442001)(20776003)(87936001)(102836001)(81342001)(62966002)(99396002)(77156001)(21056001)(81542001)(55446002)(84676001)(50986999)(95666004)(4396001)(105596002)(107046002)(83072002)(64706001)(33646002)(47776003)(79102001)(82202001)(104166001)(85852003)(50226001)(86362001)(2351001)(85306003)(61266001)(80022001)(229853001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB368;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolin Chen (2):
  ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
  ASoC: fsl_sai: Fix incorrect register writing in fsl_sai_isr()

 sound/soc/fsl/fsl_sai.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

-- 
1.8.4

