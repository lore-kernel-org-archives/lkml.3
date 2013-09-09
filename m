Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3IIPUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:20:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38165 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3IIPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:20:42 -0400
Date: Mon, 9 Sep 2013 17:21:03 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [GIT PULL] fuse bugfixes for 3.12-rc1
Message-ID: <20130909152103.GA12401@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Just a bunch of bugfixes.

Thanks,
Miklos

---
Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Dong Fang (1):
      fuse: use list_for_each_entry() for list traversing

Maxim Patlasov (2):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
      fuse: hotfix truncate_pagecache() issue

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

---
 fs/fuse/dev.c    |  6 ++----
 fs/fuse/dir.c    | 15 ++++++++++++++-
 fs/fuse/file.c   | 11 +++++++++--
 fs/fuse/fuse_i.h |  2 ++
 fs/fuse/inode.c  |  3 ++-
 5 files changed, 29 insertions(+), 8 deletions(-)
