Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaBIXgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 18:36:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33327 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaBIXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 18:36:46 -0500
Date: Sun, 9 Feb 2014 23:36:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fixes for -rc2
Message-ID: <20140209233643.GB18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A couple of fixes, both -stable fodder.  O_SYNC bug is
fairly old...  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      fix O_SYNC|O_APPEND syncing the wrong range on write()
      fix a kmap leak in virtio_console

Diffstat:
 drivers/char/virtio_console.c |    9 +++------
 fs/cifs/file.c                |    4 ++--
 fs/ext4/file.c                |    2 +-
 fs/ntfs/file.c                |    2 +-
 fs/sync.c                     |   17 -----------------
 fs/xfs/xfs_file.c             |    2 +-
 include/linux/fs.h            |    8 +++++++-
 mm/filemap.c                  |    4 ++--
 8 files changed, 17 insertions(+), 31 deletions(-)

