Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3CARQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:16:32 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42132 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab3CARQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:16:30 -0500
MIME-Version: 1.0
Date: Fri, 1 Mar 2013 11:16:29 -0600
Message-ID: <CAH2r5muxOAG8q1pcoJi9tPo7zpKkc8=WjS9Zbw=3+bonSyRbbQ@mail.gmail.com>
Subject: [GIT] CIFS Fixes
From: Steve French <smfrench@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four cifs fixes (including for kernel bug #53221 and samba bug #9519)

The following changes since commit 309667e53fcfd8e0b423280b6ea5a648fd92166c:

  Merge branch 'kconfig' of
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
(2013-02-27 12:28:30 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Martijn de Gouw (1):
      cifs: set MAY_SIGN when sec=krb5

Ouyang Maochun (1):
      cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()

Steve French (1):
      POSIX extensions disabled on client due to illegal O_EXCL flag
sent to Samba

 fs/cifs/cifsfs.c  |    5 +++++
 fs/cifs/cifssmb.c |    5 ++++-
 fs/cifs/connect.c |    2 +-
 fs/cifs/file.c    |   12 +++++++++---
 4 files changed, 19 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
