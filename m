Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaILREP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:04:15 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38224 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaILREO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:04:14 -0400
Message-ID: <1410541450.66768.1.camel@leira.trondhjem.org>
Subject: [GIT PULL] Please pull NFS client fixes
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2014 13:04:10 -0400
Organization: Primary Data, Inc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.17-4

for you to fetch changes up to 224ecbf5a674ec7da3a3b3ea21ca62e2853653fa:

  pnfs: fix filelayout_retry_commit when idx > 0 (2014-09-10 12:43:45 -0700)

----------------------------------------------------------------
NFS client fixes for 3.17

Highlights:
- Fix a kernel warning when removing /proc/net/nfsfs
- Revert commit 49a4bda22e18 due to Oopses
- Fix a typo in the pNFS file layout commit code

----------------------------------------------------------------
Cong Wang (1):
      nfs: fix kernel warning when removing proc entry

Jeff Layton (1):
      nfs: revert "nfs4: queue free_lock_state job submission to nfsiod"

Weston Andros Adamson (1):
      pnfs: fix filelayout_retry_commit when idx > 0

 fs/nfs/client.c                | 12 +++---------
 fs/nfs/filelayout/filelayout.c |  5 +++--
 fs/nfs/nfs4_fs.h               | 13 ++++++-------
 fs/nfs/nfs4state.c             | 24 ++++++------------------
 4 files changed, 18 insertions(+), 36 deletions(-)


