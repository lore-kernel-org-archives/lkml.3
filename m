Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3BZFlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:41:45 -0500
Received: from ozlabs.org ([203.10.76.45]:49241 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3BZFln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:41:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Ryota Ozaki <ozaki.ryota@gmail.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PULL] virtio
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 26 Feb 2013 16:03:53 +1030
Message-ID: <874ngzfxku.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 226364766f936d249e408de03821468c1bf11dda:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2013-01-20 16:44:28 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to 8078db789a92b10ff6e2d713231b5367e014c53b:

  virtio_console: Initialize guest_connected=true for rproc_serial (2013-02-13 20:57:45 +1030)

----------------------------------------------------------------
All trivial, thanks to the stuff which didn't quite make it time.

Cheers,
Rusty.

----------------------------------------------------------------
Rusty Russell (1):
      virtio: use module_virtio_driver.

Ryota Ozaki (1):
      virtio-mmio: fix wrong comment about register offset

Sjur Brændeland (4):
      virtio_console: Let unconnected rproc device receive data.
      virtio_console: Use virtio device index to generate port name
      virtio: Add module driver macro for virtio drivers.
      virtio_console: Initialize guest_connected=true for rproc_serial

Stephen Hemminger (2):
      virtio: make config_ops const
      virtio: make pci_device_id const

 drivers/char/hw_random/virtio-rng.c    |   13 +------------
 drivers/char/virtio_console.c          |   18 ++++--------------
 drivers/lguest/lguest_device.c         |    2 +-
 drivers/net/virtio_net.c               |   12 +-----------
 drivers/remoteproc/remoteproc_virtio.c |    2 +-
 drivers/s390/kvm/kvm_virtio.c          |    2 +-
 drivers/virtio/virtio_balloon.c        |   13 +------------
 drivers/virtio/virtio_mmio.c           |    4 ++--
 drivers/virtio/virtio_pci.c            |    8 ++++----
 include/linux/virtio.h                 |   11 ++++++++++-
