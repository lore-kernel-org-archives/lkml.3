Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3ELGga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 02:36:30 -0400
Received: from ozlabs.org ([203.10.76.45]:35372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab3ELGg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 02:36:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PULL] virtio/lguest fixes
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 12 May 2013 15:59:40 +0930
Message-ID: <87wqr43e3v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit de9c9f86be0dc3495de98dc65c80abe6e7c7d643:

  Merge tag 'remoteproc-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc (2013-05-07 14:04:56 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to f616fe4feee4000c2995d2d1e1981513bf9ab0d4:

  lguest: clear cached last cpu when guest_set_pgd() called. (2013-05-08 10:49:18 +0930)

----------------------------------------------------------------
Missing license tag and some fallout from the lguest pagetable rework.

Thanks,
Rusty.

----------------------------------------------------------------
Dave Jones (1):
      Add missing module license tag to vring helpers.

Rusty Russell (1):
      lguest: clear cached last cpu when guest_set_pgd() called.

 drivers/lguest/page_tables.c | 1 +
 drivers/vhost/vringh.c       | 3 +++
 2 files changed, 4 insertions(+)
