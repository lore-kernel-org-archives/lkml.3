Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbbAPOfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:35:09 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62770 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbbAPOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:35:07 -0500
Message-ID: <1421418902.4123.1.camel@primarydata.com>
Subject: [GIT PULL] Please pull NFS client bugfixes
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Date: Fri, 16 Jan 2015 09:35:02 -0500
Organization: Primary Data, Inc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b1940cd21c0f4abdce101253e860feff547291b0:

  Linux 3.19-rc3 (2015-01-05 17:05:20 -0800)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.19-2

for you to fetch changes up to 4e379d36c050b0117b5d10048be63a44f5036115:

  NFSv4: Remove incorrect check in can_open_delegated() (2015-01-05 19:40:54 -0800)

----------------------------------------------------------------
NFS client bugfixes for Linux 3.19

Highlights include:

- Stable fix for a NFSv3/lockd race
- Fixes for several NFSv4.1 client id trunking bugs
- Remove an incorrect test when checking for delegated opens

----------------------------------------------------------------
Chuck Lever (1):
      NFS: Ignore transport protocol when detecting server trunking

Trond Myklebust (5):
      LOCKD: Fix a race when initialising nlmsvc_timeout
      NFSv4.1: Fix client id trunking on Linux
      NFSv4: Cache the NFSv4/v4.1 client owner_id in the struct nfs_client
      NFSv4/v4.1: Verify the client owner id during trunking detection
      NFSv4: Remove incorrect check in can_open_delegated()

 fs/lockd/svc.c            |  8 ++++----
 fs/nfs/nfs4client.c       | 42 +++++++++++++++++++++++++++---------------
 fs/nfs/nfs4proc.c         | 21 +++++++++++++++------
 include/linux/nfs_fs_sb.h |  3 +++
 4 files changed, 49 insertions(+), 25 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer, PrimaryData
trond.myklebust@primarydata.com




