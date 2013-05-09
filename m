Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3EIQqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:46:43 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:50905 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3EIQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:46:40 -0400
Date: Thu, 9 May 2013 10:46:37 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL] PCI updates for v3.10
Message-ID: <20130509164637.GA12508@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some fixes for v3.10.  They're fairly minor but do fix
user-visible issues.

Bjorn


The following changes since commit ab86e974f04b1cd827a9c7c35273834ebcd9ab38:

  Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-04-30 08:15:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.10-fixes-1

for you to fetch changes up to e253aaf0af51c1e4dc7dd3b26ea8e666bf9a2d8d:

  PCI: Delay final fixups until resources are assigned (2013-05-07 14:35:44 -0600)

----------------------------------------------------------------
PCI updates for v3.10:

  MSI
      PCI: Set ->mask_pos correctly
  Hotplug
      PCI: Delay final fixups until resources are assigned
  Moorestown
      x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0

----------------------------------------------------------------
Bin Gao (1):
      x86/pci/mrst: Use configuration mechanism 1 for 00:00.0, 00:02.0, 00:03.0

Dan Carpenter (1):
      PCI: Set ->mask_pos correctly

Yinghai Lu (1):
      PCI: Delay final fixups until resources are assigned

 arch/x86/pci/mrst.c | 10 ++++++----
 drivers/pci/bus.c   |  1 +
 drivers/pci/msi.c   |  6 ++++--
 drivers/pci/probe.c |  1 -
 4 files changed, 11 insertions(+), 7 deletions(-)
