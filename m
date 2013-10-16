Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3JPS5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:57:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759878Ab3JPS5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:57:02 -0400
Date: Wed, 16 Oct 2013 19:57:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] fix for -rc6
Message-ID: <20131016185701.GP13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fix for double iput() in ->tmpfile() on ext3 and ext4; I'd fucked it up,
Miklos has caught it.  Please, pull from usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Miklos Szeredi (1):
      ext[34]: fix double put in tmpfile

Diffstat:
 fs/ext3/namei.c |    5 ++---
 fs/ext4/namei.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

