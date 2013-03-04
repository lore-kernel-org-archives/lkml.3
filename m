Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab3CDXzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:55:11 -0500
Received: from ozlabs.org ([203.10.76.45]:33322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758341Ab3CDXzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:55:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>, Ben Hutchings <ben@decadent.org.uk>,
        ian@mnementh.co.uk
Subject: [PULL] virtio randomness fix
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 05 Mar 2013 10:22:38 +1030
Message-ID: <87ip56d8op.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to f7f154f1246ccc5a0a7e9ce50932627d60a0c878:

  hw_random: make buffer usable in scatterlist. (2013-03-05 10:11:41 +1030)

----------------------------------------------------------------
Nasty side-effect of vmalloc'ing modules: their static vars cannot be put
into scatterlists.  Jens has a check queued for this, so it shouldn't happen
again.

Thanks,
Rusty.

----------------------------------------------------------------
Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

 drivers/char/hw_random/core.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)
