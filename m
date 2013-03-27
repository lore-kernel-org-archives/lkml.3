Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3C0Agq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:36:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3C0Agp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:36:45 -0400
Date: Wed, 27 Mar 2013 00:36:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20130327003643.GX21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable fodder; assorted deadlock fixes.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (3):
      Don't bother with redoing rw_verify_area() from default_file_splice_from()
      Nest rename_lock inside vfsmount_lock
      vt: synchronize_rcu() under spinlock is not nice...

Diffstat:
 drivers/tty/vt/vc_screen.c |    6 ++++--
 fs/dcache.c                |   16 +++++++++++-----
 fs/internal.h              |    5 +++++
 fs/read_write.c            |   25 +++++++++++++++++++++++++
 fs/splice.c                |    4 +++-
 5 files changed, 48 insertions(+), 8 deletions(-)

