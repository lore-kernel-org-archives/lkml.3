Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaETMix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:38:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4560 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaETMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:38:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 0/6] trivial cleanup for iommu/vt-d
Date: Tue, 20 May 2014 20:37:46 +0800
Message-ID: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cleanup patches for iommu/vt-d.

Yijing Wang (6):
  iommu/vt-d: Use list_for_each_safe() to simplify code
  iommu/vt-d: move up no_iommu and dmar_disabled check
  iommu/vt-d: clear the redundant assignment in dmar_enable_qi
  iommu/vt-d: clear the redundant assignment for domain->nid
  iommu/vt-d: use inline function dma_pte_superpage instead of macros
  iommu/vt-d: fix reference count in iommu_prepare_isa

 drivers/iommu/dmar.c        |    3 ---
 drivers/iommu/intel-iommu.c |   18 ++++++++----------
 2 files changed, 8 insertions(+), 13 deletions(-)


