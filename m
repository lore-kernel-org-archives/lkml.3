Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaJCT4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:56:39 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:37550 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJCT4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:56:36 -0400
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Oct 2014 14:56:15 -0500
Message-ID: <CAH2r5mvYGmtFa8Cb=r3pXDCGJdOm+wvtdSCZW0WC2G2y+Mj1pw@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for CIFS/SMB3 oops on reconnect during readpages (3.17 regression)
and for incorrectly closing file handle in symlink error cases

Please pull the following changes since commit
50dddff3cb9af328dd42bafe3437c7f47e8b38a9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2014-10-01 21:29:06 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 1209bbdff2f6bbffa6eb5823033bbd7b8799a5e2:

  CIFS: Fix readpages retrying on reconnects (2014-10-02 14:17:41 -0500)

----------------------------------------------------------------
Pavel Shilovsky (1):
      CIFS: Fix readpages retrying on reconnects

Steve French (1):
      Fix problem recognizing symlinks

 fs/cifs/file.c         | 8 +-------
 fs/cifs/smb1ops.c      | 2 +-
 fs/cifs/smb2maperror.c | 2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
