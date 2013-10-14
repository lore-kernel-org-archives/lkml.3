Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3JNT2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3JNT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:28:40 -0400
Message-ID: <1381778916.2796.144.camel@ul30vt.home>
Subject: [GIT PULL] VFIO fix for 3.12-rc6
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Mon, 14 Oct 2013 13:28:36 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.12-rc5

for you to fetch changes up to d93b3ac0edb85b1c1e8fe0a065c1e5045783e2f6:

  VFIO: vfio_iommu_type1: fix bug caused by break in nested loop (2013-10-11 10:40:46 -0600)

----------------------------------------------------------------
vfio: Fix an incorrect break out of nested loop in iommu mapping code.

----------------------------------------------------------------
Antonios Motakis (1):
      VFIO: vfio_iommu_type1: fix bug caused by break in nested loop

 drivers/vfio/vfio_iommu_type1.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)


