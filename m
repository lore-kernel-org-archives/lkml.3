Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3IRJsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 05:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3IRJsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 05:48:41 -0400
Date: Wed, 18 Sep 2013 12:49:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alonid@stratoscale.com, mst@redhat.com, qinchuanyu@huawei.com
Subject: [PULL] vhost: minor changes on top of 3.12-rc1
Message-ID: <20130918094944.GA1053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to d3d665a654a35c47463d2aa6353bac3ce293f4f5:

  vhost-scsi: whitespace tweak (2013-09-17 22:56:09 +0300)

----------------------------------------------------------------
vhost: minor changes on top of 3.12-rc1

This fixes module loading for vhost-scsi, and tweaks locking in vhost core
a bit. Both of these are not exactly release blockers but it's early
in the cycle so I think it's a good idea to apply them now.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (2):
      vhost/scsi: use vmalloc for order-10 allocation
      vhost-scsi: whitespace tweak

Qin Chuanyu (1):
      vhost: wake up worker outside spin_lock

 drivers/vhost/scsi.c  | 43 ++++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.c |  4 +++-
 2 files changed, 31 insertions(+), 16 deletions(-)
