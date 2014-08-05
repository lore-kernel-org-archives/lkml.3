Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaHENJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:09:56 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44870 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaHENJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:09:54 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH v2 0/2] dma: imx-sdma: Modify SDMA's remove operation 
Date: Tue, 5 Aug 2014 18:39:40 +0530
Message-ID: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 05 Aug 2014 13:09:53.0365 (UTC) FILETIME=[8BD25850:01CFB0AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set which contains two patches which modify's sdma_remove 
operation and add tasklet_kill in sdma_remove function.

Vignesh Raman (2):
  dma: imx-sdma: use module_platform_driver for SDMA driver
  dma: imx-sdma: Adding tasklet_kill() in sdma_remove function.

 drivers/dma/imx-sdma.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
1.7.9.5

