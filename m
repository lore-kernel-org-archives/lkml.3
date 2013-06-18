Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3FRG5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:57:19 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:59723 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab3FRG5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:57:17 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <wangxfdu@gmail.com>, <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH V3 0/2] dma: mmp_pdma: Fix phy channels not protected issue
Date: Tue, 18 Jun 2013 14:55:57 +0800
Message-ID: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
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

 drivers/dma/mmp_pdma.c |   48 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 32 insertions(+), 16 deletions(-)

-- 
1.7.5.4

