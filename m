Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbaGXNkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:40:47 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53526 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXNkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:40:46 -0400
Date: Thu, 24 Jul 2014 15:40:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] more fuse fixes for 3.16
Message-ID: <20140724134037.GB15016@tucsk.piliscsaba.szeredi.hu>
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

These two pathes fix issues with the kernel-userspace protocol changes in v3.15.

Thanks,
Miklos

---
Andrew Gallagher (1):
      fuse: add FUSE_NO_OPEN_SUPPORT flag to INIT

Miklos Szeredi (1):
      fuse: s_time_gran fix

---
 fs/fuse/inode.c           | 5 +----
 include/uapi/linux/fuse.h | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)
