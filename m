Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaFYLFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaFYLF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:05:29 -0400
Date: Wed, 25 Jun 2014 14:05:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        nab@linux-iscsi.org, romain@orebokech.com
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20140625110539.GA7386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 68404441557d8db5ac853379a4fb9c1adedea4fd:

  vhost-scsi: don't open-code kvfree (2014-06-23 09:22:48 +0300)

----------------------------------------------------------------
vhost: infrastructure fixes for 3.16

Two cleanup patches removing code duplication that got introduced by changes in
rc1.  Not fixing crashes, but I'd rather not carry the duplicate code until the
next merge window.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      vhost-scsi: don't open-code kvfree

Romain Francoise (1):
      vhost-net: don't open-code kvfree

 drivers/vhost/net.c  | 12 ++----------
 drivers/vhost/scsi.c | 12 ++----------
 2 files changed, 4 insertions(+), 20 deletions(-)
