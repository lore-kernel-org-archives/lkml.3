Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbaJWD2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:28:39 -0400
Received: from [157.56.111.111] ([157.56.111.111]:24752 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933059AbaJWD2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:28:34 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v5 0/3] dma: imx-sdma: add support for sdma memory copy
Date: Thu, 23 Oct 2014 10:22:17 +0800
Message-ID: <1414030940-15516-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(33646002)(50226001)(4396001)(15202345003)(62966002)(104016003)(85306004)(99396003)(120916001)(84676001)(97736003)(50986999)(46102003)(6806004)(80022003)(15975445006)(44976005)(26826002)(102836001)(19580395003)(68736004)(77156001)(104166001)(106466001)(85852003)(36756003)(92726001)(64706001)(229853001)(87286001)(105606002)(20776003)(87936001)(95666004)(76482002)(47776003)(89996001)(31966008)(15188555004)(2201001)(50466002)(92566001)(88136002)(48376002)(107046002)(21056001)(93916002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB040;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB040;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0373D94D15
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory copy interface to sdma driver, the patch set is based on
v3:
http://www.spinics.net/lists/dmaengine/msg00850.html.

change from v4:
1.address comments from Andy Shevchenko.
change from v3:
1.split two patches from v3 patch for Vinod's comments.

change from v2:
1.remove redundant check for bus width.

change from v1:
1. correct some printk format, such as %pad for dma_addr_t
2. split duplicated code in prep_dma_memcpy and prep_dma_sg to make code clean


Robin Gong (3):
  dma: imx-sdma: add support for sdma memory copy
  dma: imx-sdma: correct print format
  dma: imx-sdma: reorg code to make code clean

 drivers/dma/imx-sdma.c | 247 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 190 insertions(+), 57 deletions(-)

-- 
1.9.1

