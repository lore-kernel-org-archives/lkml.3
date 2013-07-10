Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3GJD7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:59:14 -0400
Received: from ozlabs.org ([203.10.76.45]:60924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab3GJD7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:59:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PULL] virtio-next
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 10 Jul 2013 13:09:33 +0930
Message-ID: <87bo6bcccq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b3087e48ce20be784fae1dbabc2e42e2ad0f21bc:

  virtio: remove virtqueue_add_buf(). (2013-05-20 12:16:01 +0930)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/virtio-next-for-linus

for you to fetch changes up to c893c8d763d8a8a757028a48ace7d1bb2dd8373f:

  MAINTAINERS: add tools/virtio/ under virtio (2013-07-09 10:47:54 +0930)

----------------------------------------------------------------
No real surprises.

Thanks,
Rusty.

----------------------------------------------------------------
Andrew Vagin (1):
      virtio-pci: fix leaks of msix_affinity_masks

Jason Wang (1):
      virtio-net: fix the race between channels setting and refill

Luiz Capitulino (1):
      virtio_balloon: leak_balloon(): only tell host if we got pages deflated

Michael S. Tsirkin (3):
      virtio: include asm/barrier explicitly
      tools/virtio: move module license stub to module.h
      MAINTAINERS: add tools/virtio/ under virtio

Paul Bolle (1):
      Fix comment typo "CONFIG_PAE"

Rusty Russell (4):
      tools/lguest: fix missing rmb().
      tools/lguest: real barriers.
      lguest: fix example launcher compilation for broken glibc headers.
      virtio: VIRTIO_F_ANY_LAYOUT feature

 MAINTAINERS                        |  1 +
 drivers/lguest/page_tables.c       |  2 +-
 drivers/net/virtio_net.c           |  5 +----
 drivers/virtio/virtio_balloon.c    |  3 ++-
 drivers/virtio/virtio_pci.c        |  5 +++--
 include/linux/virtio_ring.h        |  1 +
 include/uapi/linux/virtio_config.h |  3 +++
 tools/lguest/Makefile              |  1 -
 tools/lguest/lguest.c              | 32 +++++++++++++++++++++++---------
 tools/virtio/linux/module.h        |  5 +++++
 tools/virtio/linux/virtio.h        |  3 ---
 11 files changed, 40 insertions(+), 21 deletions(-)
