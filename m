Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946006Ab3BHIBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:01:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53087 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3BHIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:01:54 -0500
Date: Fri, 8 Feb 2013 08:01:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux F2FS DEV, Mailing List" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux FS DEV, Mailing List" <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] f2fs fixes for v3.8-rc7
Message-ID: <20130208080148.GG4503@ZenIV.linux.org.uk>
References: <1360196464.26950.65.camel@kjgkr>
 <CA+55aFzygotc-rGOBwHmdXU6KrpCE7srqWYs6j-iP5c5Ef3UnA@mail.gmail.com>
 <20130208031021.GF4503@ZenIV.linux.org.uk>
 <1360297231.8037.8.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360297231.8037.8.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 01:20:31PM +0900, Jaegeuk Kim wrote:

> Hi Al,
> 
> Could you send the patches to me?
> I'll merge them in my tree and submit them in the next merge window.
> Is it OK?

Feel free to fetch/cherry-pick or simply pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git f2fs

- that branchlet grows directly off the mainline and it's not going to
be rebased...

Shortlog:
Al Viro (4):
      f2fs: init_dent_inode() should take qstr
      f2fs: switch new_inode_page() from dentry to qstr
      f2fs: switch init_inode_metadata() to passing parent and name separately
      f2fs: get rid of fake on-stack dentries

Diffstat:
 fs/f2fs/dir.c      |   29 +++++++++++++----------------
 fs/f2fs/f2fs.h     |   12 +++++++++---
 fs/f2fs/node.c     |    4 ++--
 fs/f2fs/recovery.c |   12 +++++-------
 4 files changed, 29 insertions(+), 28 deletions(-)

