Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3FKVEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:04:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:10044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab3FKVEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:04:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,847,1363158000"; 
   d="scan'208";a="253668697"
Date: Tue, 11 Jun 2013 17:04:14 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] NVMe driver fixes
Message-ID: <20130611210414.GN8211@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

The following bugfixes have been accumulating for the last few weeks, and
it would be nice if they could be in 3.10.

The following changes since commit ec50f2a97a4a7098a81b40030e0bfe28bdc43740:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2013-05-16 19:01:46 -0700)

are available in the git repository at:


  git://git.infradead.org/users/willy/linux-nvme.git fixes-3.10

for you to fetch changes up to fa08a396647767abd24a9e7015cb177121d0cf15:

  NVMe: Add MSI support (2013-05-31 11:45:52 -0400)

----------------------------------------------------------------
Chayan Biswas (1):
      Return the result from user admin command IOCTL even in case of failure

Dan Carpenter (2):
      MAINTAINERS: update NVM EXPRESS DRIVER file list
      NVMe: check for integer overflow in nvme_map_user_pages()

Keith Busch (1):
      NVMe: Do not cancel command multiple times

Matthew Wilcox (1):
      NVMe: Use dma_set_mask() correctly

Ramachandra Rao Gajula (1):
      NVMe: Add MSI support

Sachin Kamat (1):
      NVMe: Remove redundant version.h header include

Vishal Verma (1):
      NVMe: Fix a signedness bug in nvme_trans_modesel_get_mp

Wei Yongjun (1):
      NVMe: fix error return code in nvme_submit_bio_queue()

 MAINTAINERS               |    2 +-
 drivers/block/nvme-core.c |   62 +++++++++++++++++++++++++++++++++++----------
 drivers/block/nvme-scsi.c |    3 +--
 3 files changed, 50 insertions(+), 17 deletions(-)


