Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3KCB6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 21:58:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40139 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3KCB6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 21:58:05 -0400
Date: Sun, 3 Nov 2013 01:58:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] fixes for 3.12-final
Message-ID: <20131103015803.GK13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Exportfs fix from bfields.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
J. Bruce Fields (2):
      vfs: split out vfs_getattr_nosec
      exportfs: fix 32-bit nfsd handling of 64-bit inode numbers

Diffstat:
 fs/exportfs/expfs.c |   18 ++++++++++++++++--
 fs/stat.c           |   31 +++++++++++++++++++++++++------
 include/linux/fs.h  |    1 +
 3 files changed, 42 insertions(+), 8 deletions(-)
