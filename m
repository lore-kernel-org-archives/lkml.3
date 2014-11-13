Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbaKMVWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934104AbaKMVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:22:49 -0500
Date: Thu, 13 Nov 2014 23:22:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cornelia.huck@de.ibm.com, mst@redhat.com, tgraf@suug.ch,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20141113212210.GA15309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 65eca3a20264a8999570c269406196bd1ae23be7:

  virtio_console: move early VQ enablement (2014-11-13 09:53:26 +0200)

It seems like a good idea to merge this bugfix now, as it's clearly
a regression and several people complained.

----------------------------------------------------------------
virtio: bugfix for 3.18

This fixes a crash in virtio console
multi-channel mode that got introduced in -rc1.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Cornelia Huck (1):
      virtio_console: move early VQ enablement

 drivers/char/virtio_console.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
