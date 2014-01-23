Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaAWRuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:50:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaAWRus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:50:48 -0500
Message-ID: <1390493419.7979.47.camel@bling.home>
Subject: [GIT PULL] VFIO update for 3.14-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Thu, 23 Jan 2014 09:10:19 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.14-rc1

for you to fetch changes up to 3be3a074cf5ba641529d8fdae0e05ca642f23e12:

  vfio-pci: Don't use device_lock around AER interrupt setup (2014-01-14 16:12:55 -0700)

----------------------------------------------------------------
- Convert to misc driver to support module auto loading
- Remove unnecessary and dangerous use of device_lock

----------------------------------------------------------------
Alex Williamson (3):
      misc: Reserve minor for VFIO
      vfio: Convert control interface to misc driver
      vfio-pci: Don't use device_lock around AER interrupt setup

 Documentation/devices.txt         |  1 +
 drivers/vfio/pci/vfio_pci.c       |  4 +++
 drivers/vfio/pci/vfio_pci_intrs.c | 17 ----------
 drivers/vfio/vfio.c               | 70 ++++++++++++++++++---------------------
 include/linux/miscdevice.h        |  1 +
 5 files changed, 39 insertions(+), 54 deletions(-)


