Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbbAONuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:50:16 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50142 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbbAONuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:50:13 -0500
Date: Thu, 15 Jan 2015 14:51:01 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Marc Dionne <marc.c.dionne@gmail.com>
Subject: [GIT PULL] fuse bugfix for 3.19
Message-ID: <20150115135101.GA3388@tucsk.suse.de>
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

This fixes a regression in the latest fuse update plus a fix for a rather
theoretical memory ordering issue.

Thanks,
Miklos

---
Miklos Szeredi (2):
      fuse: fix LOOKUP vs INIT compat handling
      fuse: add memory barrier to INIT

---
 fs/fuse/dev.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/dir.c    | 31 +++++++------------------------
 fs/fuse/fuse_i.h |  2 ++
 fs/fuse/inode.c  |  5 ++---
 4 files changed, 60 insertions(+), 29 deletions(-)
