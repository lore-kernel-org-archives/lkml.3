Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbAYCjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 21:39:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33654 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbAYCjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 21:39:47 -0500
Date: Sun, 25 Jan 2015 02:39:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fixes
Message-ID: <20150125023945.GG29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of fixes - deadlock in CIFS and build breakage in cris serial
driver (resurfaced f_dentry in there).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      fix deadlock in cifs_ioctl_clone()

David Howells (1):
      VFS: Convert file->f_dentry->d_inode to file_inode()

Diffstat:
 arch/cris/arch-v32/drivers/sync_serial.c |  2 +-
 fs/cifs/ioctl.c                          | 21 +++++----------------
 2 files changed, 6 insertions(+), 17 deletions(-)
