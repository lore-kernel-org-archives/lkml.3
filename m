Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaLQQ40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaLQQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:56:24 -0500
Message-ID: <1418835381.1095.329.camel@bling.home>
Subject: [GIT PULL] VFIO updates for 3.19-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Wed, 17 Dec 2014 09:56:21 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.19-rc1

for you to fetch changes up to 5e9f36c59a4883c6d8db4a3c097e4fc2234742de:

  drivers/vfio: allow type-1 IOMMU instantiation on top of an ARM SMMU (2014-11-14 09:10:59 -0700)

----------------------------------------------------------------
VFIO updates for v3.19-rc1
 - s390 support (Frank Blaschka)
 - Enable iommu-type1 for ARM SMMU (Will Deacon)

----------------------------------------------------------------
Frank Blaschka (1):
      vfio: make vfio run on s390

Will Deacon (1):
      drivers/vfio: allow type-1 IOMMU instantiation on top of an ARM SMMU

 drivers/vfio/Kconfig               | 2 +-
 drivers/vfio/pci/Kconfig           | 8 ++++++++
 drivers/vfio/pci/vfio_pci.c        | 5 +++--
 drivers/vfio/pci/vfio_pci_config.c | 7 +++++++
 4 files changed, 19 insertions(+), 3 deletions(-)


