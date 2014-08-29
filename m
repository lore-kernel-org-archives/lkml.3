Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaH2JYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:24:14 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:8573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbaH2JYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:24:11 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/2] ASoC: simple-card: Fix bug about DT node's refcount
Date: Fri, 29 Aug 2014 17:19:31 +0800
Message-ID: <1409303973-1084-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(189002)(199003)(81542001)(80022001)(92726001)(83322001)(62966002)(69596002)(81156004)(229853001)(77156001)(105606002)(102836001)(74502001)(2201001)(81342001)(68736004)(64706001)(79102001)(50466002)(92566001)(44976005)(50226001)(104016003)(4396001)(87286001)(76482001)(87936001)(106466001)(104166001)(89996001)(50986999)(93916002)(86362001)(6806004)(99396002)(21056001)(95666004)(48376002)(20776003)(47776003)(26826002)(97736001)(31966008)(85306004)(107046002)(36756003)(88136002)(84676001)(74662001)(90102001)(46102001)(77982001)(85852003)(83072002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series hasn't any dependency with the previous one:
   "[RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link code."



Xiubo Li (2):
  ASoC: simple-card: Fix bug of forgetting decrement DT node's refcount
  ASoC: simple-card: Fix bug of wrong decrement DT node's refcount

 sound/soc/generic/simple-card.c | 53 ++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

-- 
1.8.5

