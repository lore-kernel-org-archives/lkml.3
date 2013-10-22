Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3JVKO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:14:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:52867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3JVKO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:14:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org
Subject: cppi41: pending patches
Date: Tue, 22 Oct 2013 12:14:02 +0200
Message-Id: <1382436846-9057-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

this series contains patches which are floating on the mainling list so
I hope it is easier to collect them. It contains two of Daniel's which
were not yet applied and two of mine.
The patch "redo descriptor collection in abort case" was posted earlier
and tested by Daniel, in this version here I removed an unused variable.

The patches are also available in a git tree based on your next tree prior
the the "dma_complete" merge because DMA_COMPLETE & DMA_SUCCESS contain a
diferent value.

The following changes since commit cc94dac27e15df9211394467e13fdfa2366e3593:

  Merge branch 'for-linus' into next (2013-10-21 12:57:31 +0530)

are available in the git repository at:


  git://breakpoint.cc/bigeasy/linux tags/cppi41-next

for you to fetch changes up to e389973c52dbea967a9254798600c35c8f94b2c3:

  dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error (2013-10-22 12:00:45 +0200)

----------------------------------------------------------------
A handfull of cppi41 patches including pm support by Daniel Mack.

----------------------------------------------------------------
Daniel Mack (2):
      dma: cppi41: restore more registers
      dma: cppi41: use cppi41_pop_desc() where possible

Sebastian Andrzej Siewior (2):
      dma: cppi41: redo descriptor collection in abort case
      dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error

 drivers/dma/cppi41.c | 82 +++++++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 39 deletions(-)

Sebastian
