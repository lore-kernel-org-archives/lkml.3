Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab3CMCzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 22:55:18 -0400
Received: from ozlabs.org ([203.10.76.45]:53477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3CMCzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 22:55:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Peter Krempa <pkrempa@redhat.com>
Cc: <yunzheng@redhat.com>
Subject: [PULL] virtio rng fix
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 13 Mar 2013 13:23:11 +1030
Message-ID: <877glcui20.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f7f154f1246ccc5a0a7e9ce50932627d60a0c878:

  hw_random: make buffer usable in scatterlist. (2013-03-05 10:11:41 +1030)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to e84e7a56a3aa2963db506299e29a5f3f09377f9b:

  virtio: rng: disallow multiple device registrations, fixes crashes (2013-03-08 11:30:43 +1100)

----------------------------------------------------------------
Simple virtio-rng fix.

Thanks,
Rusty.

----------------------------------------------------------------
Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

 drivers/char/hw_random/virtio-rng.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)
