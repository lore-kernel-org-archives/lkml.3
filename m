Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbbAJTkO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:40:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbbAJTkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:40:13 -0500
Message-ID: <1420918811.25367.126.camel@redhat.com>
Subject: [GIT PULL] VFIO fixes for 3.19-rc4
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Sat, 10 Jan 2015 12:40:11 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b1940cd21c0f4abdce101253e860feff547291b0:

  Linux 3.19-rc3 (2015-01-05 17:05:20 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.19-rc4

for you to fetch changes up to 7c2e211f3c95b91912a92a8c6736343690042e2e:

  vfio-pci: Fix the check on pci device type in vfio_pci_probe() (2015-01-07 10:29:11 -0700)

----------------------------------------------------------------
VFIO fixes for v3.19-rc4
 - Fix PCI header check in vfio_pci_probe() (Wei Yang)

----------------------------------------------------------------
Wei Yang (1):
      vfio-pci: Fix the check on pci device type in vfio_pci_probe()

 drivers/vfio/pci/vfio_pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


