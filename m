Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3BYAtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 19:49:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3BYAtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 19:49:45 -0500
Message-ID: <1361753381.2532.13.camel@bling.home>
Subject: [GIT PULL] VFIO updates for v3.9-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        keescook@chromium.org
Date: Sun, 24 Feb 2013 17:49:41 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull for v3.9-rc1.  Thanks,

Alex

The following changes since commit 323a72d83c9b2963bd1e46c8e6963e468d4658d7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-02-13 12:21:07 -0800)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.9-rc1

for you to fetch changes up to d65530fbc799e4036d4d3da4ab6e9fa6d8c4a447:

  drivers/vfio: remove depends on CONFIG_EXPERIMENTAL (2013-02-24 09:59:44 -0700)

----------------------------------------------------------------
VFIO for 3.9-rc1

- Fixes PCIe v1 extended capability support
- Cleans up read/write access functions
- Fix Removal test to properly wait until devices are unused
- Enable pcieport driver usage for non-accessible devices w/in groups
- Extensions for PCI VGA support

----------------------------------------------------------------
Alex Williamson (7):
      vfio-pci: Enable PCIe extended capabilities on v1
      vfio-pci: Cleanup read/write functions
      vfio-pci: Cleanup BAR access
      vfio: Protect vfio_dev_present against device_del
      vfio: whitelist pcieport
      vfio-pci: Manage user power state transitions
      vfio-pci: Add support for VGA region access

Kees Cook (1):
      drivers/vfio: remove depends on CONFIG_EXPERIMENTAL

 drivers/vfio/pci/Kconfig            |  10 ++
 drivers/vfio/pci/vfio_pci.c         |  75 ++++++----
 drivers/vfio/pci/vfio_pci_config.c  |  52 +++++--
 drivers/vfio/pci/vfio_pci_private.h |  19 +--
 drivers/vfio/pci/vfio_pci_rdwr.c    | 281 ++++++++++++++++--------------------
 drivers/vfio/vfio.c                 |  35 ++---
 include/uapi/linux/vfio.h           |   9 ++
 7 files changed, 254 insertions(+), 227 deletions(-)


