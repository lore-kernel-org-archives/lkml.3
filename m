Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaJUCPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:15:15 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:17343
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753161AbaJUCPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:15:14 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v4 0/3] dma: imx-sdma: add support for sdma memory copy
Date: Tue, 21 Oct 2014 09:09:38 +0800
Message-ID: <1413853781-18384-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(31966008)(50986999)(15975445006)(102836001)(2201001)(69596002)(68736004)(6806004)(104016003)(15202345003)(97736003)(80022003)(88136002)(48376002)(21056001)(46102003)(26826002)(92726001)(93916002)(92566001)(44976005)(85306004)(15188555004)(62966002)(19580395003)(87936001)(33646002)(104166001)(85852003)(50466002)(89996001)(84676001)(99396003)(95666004)(50226001)(87286001)(36756003)(77156001)(105606002)(120916001)(4396001)(20776003)(47776003)(229853001)(81156004)(106466001)(107046002)(76482002)(64706001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB034;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB034;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory copy interface to sdma driver, the patch set is based on
v3:
http://www.spinics.net/lists/dmaengine/msg00850.html.

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

