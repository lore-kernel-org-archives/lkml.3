Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaJWD2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:28:09 -0400
Received: from [157.56.111.111] ([157.56.111.111]:1669 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932513AbaJWD2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:28:07 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v5 0/3] dma: imx-sdma: add support for sdma memory copy
Date: Thu, 23 Oct 2014 10:19:53 +0800
Message-ID: <1414030797-15442-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(44976005)(107046002)(19580395003)(84676001)(68736004)(31966008)(104016003)(76482002)(33646002)(46102003)(20776003)(80022003)(95666004)(47776003)(106466001)(64706001)(88136002)(120916001)(229853001)(105606002)(97736003)(26826002)(102836001)(50986999)(50466002)(48376002)(93916002)(92726001)(92566001)(2201001)(15188555004)(85852003)(87936001)(4396001)(87286001)(99396003)(6806004)(15975445006)(89996001)(104166001)(21056001)(15202345003)(85306004)(62966002)(77156001)(36756003)(50226001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB043;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:3;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB043;
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

