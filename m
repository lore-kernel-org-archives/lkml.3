Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3IFUmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:42:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:40388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3IFUmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,857,1371106800"; 
   d="scan'208";a="399581766"
Date: Fri, 6 Sep 2013 16:41:58 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] NVM Express updates
Message-ID: <20130906204158.GB4668@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the NVMe tree.

The following changes since commit a2648ebb7ed69ef209d9c8a76fadeb3252d9a023:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs (2013-06-13 22:34:14 -0700)

are available in the git repository at:


  git://git.infradead.org/users/willy/linux-nvme.git master

for you to fetch changes up to d82e8bfdef9afae83b894be49af4644d9ac3c359:
  NVMe: Merge issue on character device bring-up (2013-09-06 16:26:58 -0400)

----------------------------------------------------------------
Keith Busch (12):
      NVMe: Disk IO statistics
      NVMe: Update nvme_id_power_state with latest spec
      NVMe: Fix checkpatch issues
      NVMe: Bring up cdev on set feature failure
      NVMe: Disk stats for read/write commands only
      NVMe: Group pci related actions in functions
      NVMe: Separate queue alloc/free from create/delete
      NVMe: Separate controller init from disk discovery
      NVMe: Use normal shutdown
      NVMe: Add pci suspend/resume driver callbacks
      NVMe: Handle ioremap failure
      NVMe: Merge issue on character device bring-up

Matthew Wilcox (6):
      NVMe: Restructure MSI / MSI-X setup
      NVMe: Return correct value from interrupt handler
      NVMe: Remove "process_cq did something" message
      NVMe: Call nvme_process_cq from submission path
      NVMe: Split header file into user-visible and kernel-visible pieces
      NVMe: Namespace IDs are unsigned

Tushar Behera (1):
      NVMe: Use kzalloc instead of kmalloc+memset

 drivers/block/nvme-core.c | 585 +++++++++++++++++++++++++++++++---------------
 drivers/block/nvme-scsi.c |  24 +-
 include/linux/nvme.h      | 466 +-----------------------------------
 include/uapi/linux/Kbuild |   1 +
 include/uapi/linux/nvme.h | 477 +++++++++++++++++++++++++++++++++++++
 5 files changed, 895 insertions(+), 658 deletions(-)
 create mode 100644 include/uapi/linux/nvme.h


