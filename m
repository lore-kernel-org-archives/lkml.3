Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618Ab3FTRDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:03:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37345 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3FTRBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:01:33 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] deprecate usage of pci_scan_bus_parented()
Date: Fri, 21 Jun 2013 01:01:02 +0800
Message-Id: <1371747665-12768-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This patch tries to deprecate usage of pci_scan_bus_parented().
It applies to
https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next

Jiang Liu (3):
  PCI: export three functions to support modular host bridge driver
  PCI, xen-pcifront: use new PCI interfaces to simplify implementation
  PCI: mark pci_scan_bus_parented() as __deprecated

 arch/tile/kernel/pci.c     |  3 --
 drivers/pci/host-bridge.c  |  1 +
 drivers/pci/probe.c        |  1 +
 drivers/pci/remove.c       |  7 +++++
 drivers/pci/xen-pcifront.c | 70 ++++++++++++++++++++--------------------------
 include/linux/pci.h        |  5 ++--
 6 files changed, 42 insertions(+), 45 deletions(-)

-- 
1.8.1.2

