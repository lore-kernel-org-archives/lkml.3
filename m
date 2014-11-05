Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaKEN56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:57:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44089 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaKEN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:57:57 -0500
Date: Wed, 5 Nov 2014 13:57:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git
Message-ID: <20141105135754.GQ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another overlayfs fix.  Please, pull from the usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Miklos Szeredi (1):
      ovl: don't poison cursor

Diffstat:
 fs/overlayfs/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
