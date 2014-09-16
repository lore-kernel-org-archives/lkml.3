Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaIPCeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:34:19 -0400
Received: from ozlabs.org ([103.22.144.67]:48897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbaIPCeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:34:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>
Cc: Amos Kong <akong@redhat.com>
Subject: [PULL] virtio fixes
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 16 Sep 2014 10:34:48 +0930
Message-ID: <87sijsfk9b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7ec62d421bdf29cb31101ae2689f7f3a9906289a:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2014-09-10 14:04:17 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to f49819560f53b7f3a596a8ea2e6764dc86695b62:

  virtio-rng: skip reading when we start to remove the device (2014-09-11 22:28:38 +0930)

----------------------------------------------------------------
virtio-rng corner case fixes, with cc:stable.
Survived a few days in linux-next.

----------------------------------------------------------------
Amos Kong (2):
      virtio-rng: fix stuck of hot-unplugging busy device
      virtio-rng: skip reading when we start to remove the device

 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)
