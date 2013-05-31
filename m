Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3EaUYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:24:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39105 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaUYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:24:23 -0400
Date: Fri, 31 May 2013 21:24:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] assorted fixes
Message-ID: <20130531202422.GJ25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes...  There'll be more - I'm trying to dig out from under
the pile of mail (a couple of weeks of something flu-like ;-/) and there's
several more things waiting for review; this is just the obvious stuff.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (4):
      qnx6: qnx6_readdir() has a braino in pos calculation
      hpfs: deadlock and race in directory lseek()
      befs_readdir(): do not increment ->f_pos if filldir tells us to stop
      zoran: racy refcount handling in vm_ops ->open()/->close()

Jan Beulich (1):
      fix buffer leak after "scsi: saner replacements for ->proc_info()"

Takashi Iwai (1):
      vfs: Fix invalid ida_remove() call

Diffstat:
 drivers/media/pci/zoran/zoran.h        |    2 +-
 drivers/media/pci/zoran/zoran_driver.c |   15 ++++++++-------
 drivers/scsi/scsi_proc.c               |    1 +
 fs/befs/linuxvfs.c                     |    4 ++--
 fs/hpfs/dir.c                          |   10 ++++++----
 fs/pnode.c                             |    3 ++-
 fs/qnx6/dir.c                          |    2 +-
 7 files changed, 21 insertions(+), 16 deletions(-)
