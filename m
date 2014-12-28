Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaL1O05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:26:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38753 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaL1O04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:26:56 -0500
Date: Sun, 28 Dec 2014 14:26:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fix
Message-ID: <20141228142654.GH22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An embarrassing bug in lustre patches from this cycle ;-/  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      [regression] braino in "lustre: use is_root_inode()"

Diffstat:
 drivers/staging/lustre/lustre/llite/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
