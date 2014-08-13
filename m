Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaHMPja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:39:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaHMPj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:39:29 -0400
Message-ID: <1407944367.9800.167.camel@ul30vt.home>
Subject: [GIT PULL] VFIO updates for 3.17-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Wed, 13 Aug 2014 09:39:27 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 7f0d32e0c1a7a23216a0f2694ec841f60e9dddfd:

  Merge tag 'microblaze-3.17-rc1' of git://git.monstr.eu/linux-2.6-microblaze (2014-08-07 09:02:26 -0700)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-v3.17-rc1

for you to fetch changes up to 9b936c960f22954bfb89f2fefd8f96916bb42908:

  drivers/vfio: Enable VFIO if EEH is not supported (2014-08-08 10:39:16 -0600)

----------------------------------------------------------------
VFIO updates for v3.17-rc1
 - Enable support for bus reset on device release
 - Fixes for EEH support

----------------------------------------------------------------
Alex Williamson (3):
      vfio-pci: Release devices with BusMaster disabled
      vfio-pci: Use mutex around open, release, and remove
      vfio-pci: Attempt bus/slot reset on release

Alexey Kardashevskiy (2):
      drivers/vfio: Allow EEH to be built as module
      drivers/vfio: Enable VFIO if EEH is not supported

Gavin Shan (1):
      drivers/vfio: Fix EEH build error

 drivers/vfio/Kconfig                |   6 ++
 drivers/vfio/Makefile               |   2 +-
 drivers/vfio/pci/vfio_pci.c         | 161 ++++++++++++++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_private.h |   3 +-
 drivers/vfio/vfio_spapr_eeh.c       |  17 +++-
 include/linux/vfio.h                |   6 +-
 6 files changed, 170 insertions(+), 25 deletions(-)

