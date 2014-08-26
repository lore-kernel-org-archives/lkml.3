Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaHZFuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:50:20 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:26141
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754354AbaHZFuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:50:18 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/5] Clocksource: Flextimer: Merged to LS1
Date: Tue, 26 Aug 2014 13:45:46 +0800
Message-ID: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81156004)(6806004)(105606002)(20776003)(90102001)(87286001)(97736001)(85852003)(64706001)(81542001)(84676001)(92726001)(44976005)(62966002)(89996001)(76482001)(102836001)(106466001)(77156001)(85306004)(46102001)(229853001)(26826002)(21056001)(80022001)(68736004)(83072002)(69596002)(4396001)(83322001)(92566001)(99396002)(77982001)(50986999)(88136002)(74502001)(104016003)(95666004)(81342001)(36756003)(48376002)(50466002)(79102001)(93916002)(104166001)(47776003)(107046002)(74662001)(87936001)(31966008)(50226001)(86362001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0611;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Xiubo Li (5):
  Clocksource: Flextimer: Set cpumask to cpu_possible_mask
  Clocksource: Flextimer: Use internal clocksource read API.
  Clocksource: Flextimer: Remove the useless code.
  Clocksource: Flextimer: Fix counter clock prescaler calculation.
  Clocksource: Flextimer: Use Macro for clock source selection.

 drivers/clocksource/fsl_ftm_timer.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

-- 
1.8.5

