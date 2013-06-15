Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3FODer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 23:34:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3FODep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 23:34:45 -0400
Date: Sat, 15 Jun 2013 04:34:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20130615033440.GN4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Several fixes + obvious cleanup (you've missed a couple of
open-coded can_lookup() back then).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      use can_lookup() instead of direct checks of ->i_op->lookup
      snd_pcm_link(): fix a leak...

Dave Chiluk (1):
      ncpfs: fix rmdir returns Device or resource busy

Oleg Nesterov (2):
      fput: task_work_add() can fail if the caller has passed exit_task_work()
      move exit_task_namespaces() outside of exit_notify()

Diffstat:
 fs/file_table.c         |   19 ++++++++++---------
 fs/namei.c              |    4 ++--
 fs/ncpfs/dir.c          |    9 ---------
 kernel/exit.c           |    2 +-
 sound/core/pcm_native.c |    4 ++--
 5 files changed, 15 insertions(+), 23 deletions(-)
