Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaIAC0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:26:50 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:26059
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000AbaIAC0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:26:49 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <moinejf@free.fr>, <kuninori.morimoto.gx@renesas.com>,
        <jsarha@ti.com>, <alsa-devel@alsa-project.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/2] ASoC: simple-card: Fix bug about DT node's refcount
Date: Mon, 1 Sep 2014 09:35:25 +0800
Message-ID: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(77156001)(68736004)(69596002)(99396002)(44976005)(2201001)(92726001)(6806004)(83322001)(31966008)(92566001)(93916002)(104016003)(97736001)(50986999)(74502001)(74662001)(88136002)(50226001)(4396001)(87936001)(81342001)(62966002)(86362001)(89996001)(90102001)(84676001)(87286001)(21056001)(64706001)(85306004)(80022001)(79102001)(26826002)(36756003)(106466001)(81156004)(81542001)(47776003)(20776003)(83072002)(105606002)(229853001)(77982001)(76482001)(95666004)(102836001)(85852003)(50466002)(104166001)(107046002)(48376002)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0611;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change for v2:
- Just rebased to the next branch newest head.


Xiubo Li (2):
  ASoC: simple-card: Fix bug of forgetting decrement DT node's refcount
  ASoC: simple-card: Fix bug of wrong decrement DT node's refcount

 sound/soc/generic/simple-card.c | 53 ++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

-- 
1.8.4

