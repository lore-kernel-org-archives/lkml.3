Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbaGRUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:47:16 -0400
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:48220 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756658AbaGRUrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:47:15 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2014 16:47:15 EDT
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Fri, 18 Jul 2014 13:40:06 -0700
Message-Id: <1405716006-19437-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA fixes for 3.16

 - cxgb4 hardware driver regression fixes
 - mlx5 hardware driver regression fixes

----------------------------------------------------------------
Hariprasad S (2):
      RDMA/cxgb4: Fix skb_leak in reject_cr()
      RDMA/cxgb4: Clean up connection on ARP error

Or Gerlitz (1):
      IB/mlx5: Enable "block multicast loopback" for kernel consumers

Roland Dreier (1):
      Merge branches 'cxgb4' and 'mlx5' into for-next

Sagi Grimberg (1):
      mlx5_core: Fix possible race between mr tree insert/delete

Steve Wise (2):
      RDMA/cxgb4: Initialize the device status page
      RDMA/cxgb4: Call iwpm_init() only once

 drivers/infiniband/hw/cxgb4/cm.c             | 14 +++++++++++---
 drivers/infiniband/hw/cxgb4/device.c         | 18 +++++++++++-------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |  2 +-
 drivers/infiniband/hw/mlx5/qp.c              |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 19 +++++++++++++++----
 5 files changed, 39 insertions(+), 16 deletions(-)
