Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaG3NLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:11:20 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:37820 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaG3NLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:11:19 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH 0/2] dma: imx-sdma: Modify SDMA's remove operation
Date: Wed, 30 Jul 2014 18:41:13 +0530
Message-ID: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 30 Jul 2014 13:11:18.0918 (UTC) FILETIME=[C0563260:01CFABF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set which contains two patches which modify's sdma_remove 
operation and add tasklet_kill in sdma_remove function.

Vignesh Raman (2):
  dma: imx-sdma: use module_platform_driver for SDMA driver
  dma: imx-sdma: Adding tasklet_kill() in sdma_remove function.

 drivers/dma/imx-sdma.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

-- 
1.7.9.5

