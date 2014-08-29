Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaH2Tft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:35:49 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49871 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaH2Tfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:35:47 -0400
Message-ID: <1409340947.18172.4.camel@leira.trondhjem.org>
Subject: [GIT PULL] Please pull NFS client fixes
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Date: Fri, 29 Aug 2014 15:35:47 -0400
Organization: Primary Data, Inc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.17-3

for you to fetch changes up to f87d928f6d98644d39809a013a22f981d39017cf:

  NFSv3: Fix another acl regression (2014-08-26 16:17:48 -0400)

----------------------------------------------------------------
NFS client fixes for 3.17

Highlights:
- NFSv3 stable fix for another POSIX ACL regression
- NFSv4 stable fix for a regression with OPEN_DOWNGRADE
- NFSv4 stable fix for bad close() behaviour when holding a delegation

----------------------------------------------------------------
Trond Myklebust (3):
      NFSv4: Fix problems with close in the presence of a delegation
      NFSv4: Don't clear the open state when we just did an OPEN_DOWNGRADE
      NFSv3: Fix another acl regression

 fs/nfs/nfs3acl.c  |  5 ++++-
 fs/nfs/nfs4proc.c | 26 +++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)


