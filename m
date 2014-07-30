Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaG3IfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53525 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307AbaG3IfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:35:03 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/3] dmaengine: sun6i: Misc fixes for the dma driver
Date: Wed, 30 Jul 2014 10:30:20 +0200
Message-Id: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan, Vinod,

Here are the patches that you requested previously, plus an additional
fix for a memory leak was spotted by Dan Carpenter.

Thanks,
Maxime

Maxime Ripard (3):
  dmaengine: sun6i: Remove switch statement from buswidth convertion
    routine
  dmaengine: sun6i: Free the interrupt before killing the tasklet
  dmaengine: sun6i: Fix memory leaks

 drivers/dma/sun6i-dma.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

-- 
2.0.2

