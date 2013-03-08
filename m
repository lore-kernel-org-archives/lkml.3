Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3CHUOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:14:12 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:49046 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3CHUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:14:11 -0500
MIME-Version: 1.0
Date: Fri, 8 Mar 2013 14:14:09 -0600
Message-ID: <CAH2r5mtSkS6LkjU9Lbzfa-U3VdmSmwphLafSwhhMVDeYib-vVg@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small set of cifs fixes which includes one for a recent regression
in the write path (pointed out by Anton), some fixes for rename
problems and as promised for 3.9 removing the obsolete sockopt mount
option (and the accompanying deprecation warning).

The following changes since commit 9f225788cc047fb7c2ef2326eb4f86dee890e2ef:

  Merge branch 'merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-03-05
18:56:22 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (2):
      cifs: remove the sockopt= mount option
      cifs: don't try to unlock pagecache page after releasing it

Pavel Shilovsky (1):
      CIFS: Fix missing of oplock_read value in smb30_values structure

Sachin Prabhu (2):
      cifs: Fix bug when checking error condition in
cifs_rename_pending_delete()
      cifs: Check server capability before attempting silly rename

 fs/cifs/cifssmb.c |    2 +-
 fs/cifs/connect.c |   16 +---------------
 fs/cifs/inode.c   |   11 ++++++++++-
 fs/cifs/smb2ops.c |    1 +
 4 files changed, 13 insertions(+), 17 deletions(-)

-- 
Thanks,

Steve
