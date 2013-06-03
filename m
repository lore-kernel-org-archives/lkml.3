Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3FCIDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:03:39 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58493 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754096Ab3FCIDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:03:21 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <wangxfdu@gmail.com>, <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH 0/2] dma: mmp_pdma: Fix phy channels not protected issue
Date: Mon, 3 Jun 2013 16:02:07 +0800
Message-ID: <1370246529-17155-1-git-send-email-wangxfdu@gmail.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiang Wang <wangx@marvell.com>

This patch set deals with the issues that 1) phy channels are not protected
in mmp_pdma. 2) dma request<->channel mapping is not cleared when a phy chan
is freed.

Xiang Wang (2):
  dma: mmp_pdma: add protect when alloc/free phy channels
  dma: mmp_pdma: clear DRCMR when free a phy channel

 drivers/dma/mmp_pdma.c |   47 +++++++++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 16 deletions(-)

-- 
1.7.5.4

