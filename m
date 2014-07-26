Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaGZPCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:02:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:02:21 -0400
Date: Sat, 26 Jul 2014 08:02:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] VFS fixes for 3.16
Message-ID: <20140726150218.GA8770@infradead.org>
References: <20140716114136.GA25237@infradead.org>
 <20140722162455.GA15053@infradead.org>
 <20140724153057.GA1584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724153057.GA1584@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here's a userspace triggered vfsmount leak fix, and a compile warning
fix for 3.16:


The following changes since commit 82e13c71bc655b6dc7110da4e164079dadb44892:

  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux (2014-07-23 17:55:11 -0700)

are available in the git repository at:


  git://git.infradead.org/users/hch/vfs.git vfs-for-3.16

for you to fetch changes up to 295dc39d941dc2ae53d5c170365af4c9d5c16212:

  fs: umount on symlink leaks mnt count (2014-07-24 06:18:12 -0400)

----------------------------------------------------------------
Boaz Harrosh (1):
      direct-io: fix uninitialized warning in do_direct_IO()

Vasily Averin (1):
      fs: umount on symlink leaks mnt count

 fs/direct-io.c | 14 +++++++-------
 fs/namei.c     |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)
