Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaETRHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:07:45 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:39938 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaETRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:07:44 -0400
Date: Tue, 20 May 2014 11:07:40 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Marcel Apfelbaum <marcel.a@redhat.com>,
        en Hutchings <ben@decadent.org.uk>
Subject: [GIT PULL] PCI updates for v3.15
Message-ID: <20140520170740.GA15835@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are fixes for an SHPCHP hotplug regression, a "wait for pending
transaction" problem (used in device reset paths), and an email address
update.

Bjorn


The following changes since commit f5d3352b2751f8de7e06e23a04ac0b4c474075e9:

  PCI: tegra: Use new OF interrupt mapping when possible (2014-04-16 10:24:32 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-v3.15-fixes-2

for you to fetch changes up to d0b4cc4e32705ff00d90d32da7783c266c702c04:

  PCI: Wrong register used to check pending traffic (2014-05-19 12:51:48 -0600)

----------------------------------------------------------------
PCI updates for v3.15:

  PCI device hotplug
    - Fix SHPCHP bus speed mismatch issue (Marcel Apfelbaum)

  Miscellaneous
    - Fix pci_wait_for_pending_transaction() (Gavin Shan)
    - Update email address (Ben Hutchings)

----------------------------------------------------------------
Ben Hutchings (1):
      PCI: Update my email address

Gavin Shan (1):
      PCI: Wrong register used to check pending traffic

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

 Documentation/ABI/testing/sysfs-bus-pci | 2 +-
 drivers/pci/hotplug/shpchp_ctrl.c       | 4 ++--
 drivers/pci/pci.c                       | 5 +++--
 3 files changed, 6 insertions(+), 5 deletions(-)
