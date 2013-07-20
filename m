Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3GTBPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 21:15:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55784 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3GTBPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 21:15:13 -0400
Date: Sat, 20 Jul 2013 02:15:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes for -rc2
Message-ID: <20130720011510.GI4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	sget() one is a long-standing bug and will need to go into
-stable (in fact, it had been originally caught in RHEL6), the
other two are 3.11-only.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      allow O_TMPFILE to work with O_WRONLY
      livelock avoidance in sget()

Peng Tao (1):
      vfs: constify dentry parameter in d_count()

Diffstat:
 fs/open.c                        |    2 ++
 fs/super.c                       |   25 ++++++++++---------------
 include/linux/dcache.h           |    2 +-
 include/uapi/asm-generic/fcntl.h |    4 ++--
 4 files changed, 15 insertions(+), 18 deletions(-)
