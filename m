Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbaGOMYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:24:41 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53722 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbaGOMYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:24:37 -0400
Date: Tue, 15 Jul 2014 14:24:29 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse fixes for 3.16
Message-ID: <20140715122429.GA15016@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contains miscellaneous fixes.

Thanks,
Miklos

----
Anand Avati (1):
      fuse: ignore entry-timeout on LOOKUP_REVAL

Fabian Frederick (1):
      fuse: replace count*size kzalloc by kcalloc

Himangi Saraogi (1):
      fuse: inode: drop cast

Maxim Patlasov (1):
      fuse: release temporary page if fuse_writepage_locked() failed

Miklos Szeredi (4):
      fuse: timeout comparison fix
      fuse: handle large user and group ID
      fuse: avoid scheduling while atomic
      fuse: restructure ->rename2()

---
 fs/fuse/dev.c   | 51 +++++++++++++++++++++++----------------------------
 fs/fuse/dir.c   | 41 ++++++++++++++++++++++++-----------------
 fs/fuse/file.c  |  8 +++++---
 fs/fuse/inode.c | 22 +++++++++++++++++-----
 4 files changed, 69 insertions(+), 53 deletions(-)
