Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaEFVWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:22:21 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9239 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEFVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:22:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 May 2014 14:16:35 -0700
From: Christopher Freeman <cfreeman@nvidia.com>
To: <ldewangan@nvidia.com>, <swarren@nvidia.com>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christopher Freeman <cfreeman@nvidia.com>
Subject: [PATCH v1 0/3] Tegra DMA residue improvements
Date: Tue, 6 May 2014 14:22:20 -0700
Message-ID: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A collection of patches to improve Tegra's DMA residual reporting

Christopher Freeman (3):
  dma: tegra: finer granularity residual for tx_status
  dma: tegra: change interrupt-related log levels
  dma: tegra: avoid int overflow for transferred count

 drivers/dma/tegra20-apb-dma.c |   74 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 65 insertions(+), 9 deletions(-)

-- 
1.7.9.5

