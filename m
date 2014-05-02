Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaEBAJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:09:19 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:37860 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752273AbaEBAJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:09:17 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
Date: Thu,  1 May 2014 17:09:10 -0700
Message-Id: <1398989350-31583-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------
InfiniBand/RDMA updates for 3.15-rc4:

 - cxgb4 hardware driver fixes

----------------------------------------------------------------
Hariprasad S (1):
      RDMA/cxgb4: Update Kconfig to include Chelsio T5 adapter

Steve Wise (3):
      RDMA/cxgb4: Fix endpoint mutex deadlocks
      RDMA/cxgb4: Force T5 connections to use TAHOE congestion control
      RDMA/cxgb4: Only allow kernel db ringing for T4 devs

 drivers/infiniband/hw/cxgb4/Kconfig       |  6 ++---
 drivers/infiniband/hw/cxgb4/cm.c          | 39 ++++++++++++++++++++++---------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |  1 +
 drivers/infiniband/hw/cxgb4/qp.c          | 13 +++++++----
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h | 14 +++++++++++
 5 files changed, 55 insertions(+), 18 deletions(-)
