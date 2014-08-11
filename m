Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaHKCos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:44:48 -0400
Received: from ozlabs.org ([103.22.144.67]:54160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaHKCoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:44:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Amos Kong <akong@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benoit Taine <benoit.taine@lip6.fr>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: virtualization@lists.linux-foundation.org
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 11 Aug 2014 11:58:50 +0930
Message-ID: <87vbpzahel.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 15ba2236f3556fc01b9ca91394465152b5ea74b6:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-07-21 22:46:01 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to eeec626366ffe558fc3d5685bd2b49a962acf57d:

  Revert "hwrng: virtio - ensure reads happen after successful probe" (2014-07-27 21:07:20 +0930)

----------------------------------------------------------------
Cheers,
Rusty.

----------------------------------------------------------------
Amit Shah (4):
      virtio: rng: remove unused struct element
      virtio: rng: re-arrange struct elements for better packing
      virtio: rng: delay hwrng_register() till driver is ready
      Revert "hwrng: virtio - ensure reads happen after successful probe"

Benoit Taine (1):
      virtio: Replace DEFINE_PCI_DEVICE_TABLE macro use

Fabian Frederick (1):
      virtio: console: remove unnecessary null test before debugfs_remove_recursive

 drivers/char/hw_random/core.c       |  6 ------
 drivers/char/hw_random/virtio-rng.c | 39 ++++++++++++++++---------------------
 drivers/char/virtio_console.c       |  6 ++----
 drivers/virtio/virtio_pci.c         |  2 +-
 4 files changed, 20 insertions(+), 33 deletions(-)
