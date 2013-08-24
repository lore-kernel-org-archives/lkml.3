Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3HXSaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:30:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40716 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab3HXSax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:30:53 -0400
Date: Sat, 24 Aug 2013 19:30:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs and filesystem fixes
Message-ID: <20130824183052.GV27005@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully linux.org.uk mail setup got fixed and this one won't bounce...
Assorted fixes from the last week or so; please pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      cope with potentially long ->d_dname() output for shmem/hugetlb

Dan Carpenter (3):
      efs: iget_locked() doesn't return an ERR_PTR()
      bfs: iget_locked() doesn't return an ERR_PTR
      VFS: collect_mounts() should return an ERR_PTR

Oleg Nesterov (1):
      proc: kill the extra proc_readfd_common()->dir_emit_dots()

Diffstat:
 fs/bfs/inode.c         |    2 +-
 fs/dcache.c            |   11 +++++++++++
 fs/efs/inode.c         |    2 +-
 fs/hugetlbfs/inode.c   |    8 +-------
 fs/namespace.c         |    2 +-
 fs/proc/fd.c           |    2 --
 include/linux/dcache.h |    1 +
 mm/shmem.c             |    8 +-------
 8 files changed, 17 insertions(+), 19 deletions(-)
