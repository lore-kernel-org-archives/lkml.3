Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbaISTdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:33:00 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34129 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626AbaISTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:32:58 -0400
Message-ID: <1411155174.8463.0.camel@leira.trondhjem.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Date: Fri, 19 Sep 2014 15:32:54 -0400
Organization: Primary Data, Inc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 224ecbf5a674ec7da3a3b3ea21ca62e2853653fa:

  pnfs: fix filelayout_retry_commit when idx > 0 (2014-09-10 12:43:45 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.17-5

for you to fetch changes up to cd9288ffaea4359d5cfe2b8d264911506aed26a4:

  NFSv4: Fix another bug in the close/open_downgrade code (2014-09-18 13:04:22 -0400)

----------------------------------------------------------------
NFS client fixes for 3.17

Highligts:
- Fix an Oops in nfs4_open_and_get_state
- Fix an Oops in the nfs4_state_manager
- Fix another bug in the close/open_downgrade code

----------------------------------------------------------------
NeilBrown (1):
      NFS: remove BUG possibility in nfs4_open_and_get_state

Steve Dickson (1):
      NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code

 fs/nfs/nfs4client.c | 38 ++++++++++++++++++++------------------
 fs/nfs/nfs4proc.c   | 40 ++++++++++++++++++++++------------------
 2 files changed, 42 insertions(+), 36 deletions(-)


