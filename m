Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaL3Jwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:52:40 -0500
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:30560
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbaL3Jwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:52:39 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/2] dmaengine: fsl-edma: add dma memcpy and suspend/resume support
Date: Tue, 30 Dec 2014 16:41:45 +0800
Message-ID: <1419928907-18053-1-git-send-email-jingchang.lu@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=jingchang.lu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(106466001)(4396001)(48376002)(229853001)(68736005)(21056001)(89996001)(92566001)(46102003)(36756003)(110136001)(2351001)(33646002)(120916001)(105606002)(97736003)(50986999)(99396003)(84676001)(31966008)(87936001)(6806004)(50466002)(104016003)(77096005)(62966003)(85426001)(77156002)(107046002)(47776003)(20776003)(86362001)(64706001)(50226001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 04410E544A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 09:37:36.0921
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0628
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This two patches add the dma memory copy and PM suspend/resume support
for the Freescale eDMA engine.

----------------------------------------------------------------
Jingchang Lu (2):
	dmaengine: fsl-edma: add dma memcpy support
	dmaengine: fsl-edma: add PM suspend/resume support

 drivers/dma/fsl-edma.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 99 insertions(+), 2 deletions(-)

