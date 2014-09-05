Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaIEFxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 01:53:49 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:63240
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbaIEFxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 01:53:48 -0400
X-Greylist: delayed 818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 01:53:48 EDT
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/4] Clocksource: Flextimer: add LS1 support
Date: Fri, 5 Sep 2014 13:02:16 +0800
Message-ID: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(189002)(199003)(4396001)(50226001)(87936001)(80022001)(36756003)(6806004)(89996001)(64706001)(47776003)(83322001)(44976005)(74502001)(74662001)(84676001)(31966008)(88136002)(87286001)(68736004)(81342001)(97736001)(48376002)(99396002)(50986999)(50466002)(105606002)(81542001)(106466001)(95666004)(85306004)(90102001)(76482001)(21056001)(46102001)(104016003)(20776003)(26826002)(77982001)(79102001)(62966002)(104166001)(86362001)(93916002)(77156001)(229853001)(92726001)(102836001)(107046002)(83072002)(85852003)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change in v2:
- Follows Thomas Gleixner advice.


Xiubo Li (4):
  Clocksource: Flextimer: Use internal clocksource read API.
  Clocksource: Flextimer: Remove the useless code.
  Clocksource: Flextimer: Set cpumask to cpu_possible_mask
  Clocksource: Flextimer: Fix counter clock prescaler calculation.

 drivers/clocksource/fsl_ftm_timer.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

-- 
2.1.0.27.g96db324

