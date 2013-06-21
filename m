Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556Ab3FUQNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:13:04 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51977 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423177Ab3FUQNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:13:02 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] deprecate usage of pci_scan_bus_parented()
Date: Sat, 22 Jun 2013 00:12:45 +0800
Message-Id: <1371831169-17291-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

This patch tries to deprecate usage of pci_scan_bus_parented().
It applies to
https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next

V2:
  Kill pci_scan_bus_parented() instead of marking it as deprecated


Jiang Liu (3):
  PCI: export three functions to support modular host bridge driver
  PCI, xen-pcifront: use new PCI interfaces to simplify implementation
  PCI: kill pci_scan_bus_parented()

 arch/tile/kernel/pci.c     |  3 --
 drivers/pci/host-bridge.c  |  1 +
 drivers/pci/probe.c        | 20 +-----------
 drivers/pci/remove.c       |  7 +++++
 drivers/pci/xen-pcifront.c | 76 +++++++++++++++++++++-------------------------
 include/linux/pci.h        |  3 +-
 6 files changed, 44 insertions(+), 66 deletions(-)

-- 
1.8.1.2

