Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaJUCMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:12:10 -0400
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:65344
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754199AbaJUCMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:12:06 -0400
From: Robin Gong <b38343@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <andriy.shevchenko@linux.intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <b38343@freescale.com>
Subject: [PATCH v4 0/3] dma: imx-sdma: add support for sdma memory copy
Date: Tue, 21 Oct 2014 09:06:17 +0800
Message-ID: <1413853584-18325-4-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413853584-18325-1-git-send-email-b38343@freescale.com>
References: <1413853584-18325-1-git-send-email-b38343@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(31966008)(76176999)(50986999)(77156001)(36756003)(20776003)(47776003)(64706001)(21056001)(92566001)(92726001)(15188555004)(89996001)(85852003)(87936001)(93916002)(87286001)(88136002)(104166001)(2201001)(97736003)(106466001)(50466002)(48376002)(105606002)(104016003)(68736004)(44976005)(229853001)(19580395003)(107046002)(6806004)(15202345003)(50226001)(4396001)(80022003)(76482002)(99396003)(120916001)(46102003)(62966002)(84676001)(102836001)(26826002)(33646002)(95666004)(15975445006)(85306004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB033;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB033;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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

