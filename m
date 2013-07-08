Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3GHQMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3GHQMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:12:52 -0400
Message-ID: <1373299964.2602.20.camel@ul30vt.home>
Subject: [GIT PULL] VFIO for v3.11
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Mon, 08 Jul 2013 10:12:44 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.11

for you to fetch changes up to 8d38ef1948bd415a5cb653a5c0ec16f3402aaca1:

  vfio/type1: Fix leak on error path (2013-07-01 08:28:58 -0600)

----------------------------------------------------------------
vfio Updates for v3.11

Largely hugepage support for vfio/type1 iommu and surrounding cleanups and fixes.

----------------------------------------------------------------
Alex Williamson (6):
      vfio: Convert type1 iommu to use rbtree
      vfio: hugepage support for vfio_iommu_type1
      vfio: Provide module option to disable vfio_iommu_type1 hugepage support
      vfio/type1: Fix missed frees and zero sized removes
      vfio: Limit group opens
      vfio/type1: Fix leak on error path

Alexey Kardashevskiy (1):
      vfio: fix documentation

 Documentation/vfio.txt          |   6 +-
 drivers/vfio/vfio.c             |  14 +++
 drivers/vfio/vfio_iommu_type1.c | 626 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 include/uapi/linux/vfio.h       |   8 +-
 4 files changed, 424 insertions(+), 230 deletions(-)


