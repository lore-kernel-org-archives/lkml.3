Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3LDHGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 02:06:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9477 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765Ab3LDHF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 02:05:59 -0500
From: Qiao Zhou <zhouqiao@marvell.com>
To: <eric.y.miao@gmail.com>, <haojian.zhuang@gmail.com>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        <chao.xie@marvell.com>
CC: Qiao Zhou <zhouqiao@marvell.com>
Subject: [PATCH 2/2] dma: mmp-tdma: select sram driver
Date: Wed, 4 Dec 2013 15:05:47 +0800
Message-ID: <1386140747-16043-2-git-send-email-zhouqiao@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1386140747-16043-1-git-send-email-zhouqiao@marvell.com>
References: <1386140747-16043-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-04_03:2013-12-03,2013-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312030286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
---
 drivers/dma/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index dd2874e..4e41b69 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -288,6 +288,7 @@ config MMP_TDMA
 	bool "MMP Two-Channel DMA support"
 	depends on ARCH_MMP
 	select DMA_ENGINE
+	select MMP_SRAM
 	help
 	  Support the MMP Two-Channel DMA engine.
 	  This engine used for MMP Audio DMA and pxa910 SQU.
-- 
1.7.0.4

