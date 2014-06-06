Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaFFU2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaFFU2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:28:07 -0400
Message-ID: <1402086485.14174.26.camel@ul30vt.home>
Subject: [GIT PULL] VFIO updates for 3.16-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Fri, 06 Jun 2014 14:28:05 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.16-rc1

for you to fetch changes up to fd49c81f080a997aad4b0e73541cd42772b6a772:

  drivers/vfio/pci: Fix wrong MSI interrupt count (2014-05-30 11:35:54 -0600)

----------------------------------------------------------------
A handful of VFIO bug fixes for v3.16

----------------------------------------------------------------
Alex Williamson (3):
      vfio/pci: Fix sizing of DPA and THP express capabilities
      vfio/pci: Fix unchecked return value
      vfio/iommu_type1: Avoid overflow

Gavin Shan (2):
      drivers/vfio: Rework offsetofend()
      drivers/vfio/pci: Fix wrong MSI interrupt count

 drivers/vfio/pci/vfio_pci.c        |  6 ++---
 drivers/vfio/pci/vfio_pci_config.c |  7 +++---
 drivers/vfio/vfio_iommu_type1.c    | 45 +++++++++++++++-----------------------
 include/linux/vfio.h               |  5 ++---
 4 files changed, 26 insertions(+), 37 deletions(-)


