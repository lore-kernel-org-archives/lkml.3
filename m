Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaI3FEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:04:00 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:65056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751306AbaI3FDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:03:53 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <tglx@linutronix.de>, <daniel.lezcano@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <john.stultz@linaro.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3 0/2] clocksource: Add BE APIs support.
Date: Tue, 30 Sep 2014 13:03:26 +0800
Message-ID: <1412053408-21751-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(85306004)(107046002)(120916001)(87936001)(20776003)(47776003)(84676001)(62966002)(89996001)(64706001)(92566001)(92726001)(104166001)(26826002)(88136002)(104016003)(105606002)(99396003)(86362001)(93916002)(10300001)(31966008)(87286001)(102836001)(81156004)(76482002)(69596002)(48376002)(6806004)(21056001)(50986999)(106466001)(80022003)(85852003)(95666004)(50226001)(50466002)(46102003)(97736003)(68736004)(36756003)(44976005)(4396001)(77156001)(229853001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0617;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0617;
X-Forefront-PRVS: 0350D7A55D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change in V3:
- Provide a separate patch for using newer memory accessors.

Change in V2:
- Using ioread{16,32}[be]() instead of readl_relaxed().
- Add clocksource_mmio_readX_Y_be() supports only.


Xiubo Li (2):
  clocksource: Update to the newer memory functions.
  clocksource: Add BE APIs support for clocksource counter reading.

 drivers/clocksource/mmio.c  | 28 ++++++++++++++++++++++++----
 include/linux/clocksource.h |  4 ++++
 2 files changed, 28 insertions(+), 4 deletions(-)

-- 
2.1.0.27.g96db324

