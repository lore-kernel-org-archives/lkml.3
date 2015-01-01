Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbbAAM0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 07:26:43 -0500
Received: from mail.kernel.org ([198.145.29.136]:60650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbbAAM0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 07:26:41 -0500
Date: Thu, 1 Jan 2015 14:26:34 +0200
From: "Michael S. Tsirkin" <mst@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        rusty@rustcorp.com.au
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20150101122634.GA2670@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b7392d2247cfe6771f95d256374f1a8e6a6f48d6:

  Linux 3.19-rc2 (2014-12-28 16:49:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 5d9a07b0de512b77bf28d2401e5fe3351f00a240:

  vhost: relax used address alignment (2014-12-29 10:55:06 +0200)

----------------------------------------------------------------
vhost: virtio 1.0 bugfix

There's a single change here, fixing a vhost bug where vhost initialization
fails due to used ring alignment check being too strict.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (2):
      virtio_ring: document alignment requirements
      vhost: relax used address alignment

 include/uapi/linux/virtio_ring.h |  7 +++++++
 drivers/vhost/vhost.c            | 10 +++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)
