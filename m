Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaHDNWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:22:48 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56886 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaHDNWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:22:47 -0400
Date: Mon, 4 Aug 2014 09:22:42 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.17
Message-ID: <20140804092242.020fbbc8@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git tags/locks-v3.17-1

for you to fetch changes up to 73a8f5f7e6350766102fe8fb85048f7f8f0cb5f7:

  locks: purge fl_owner_t from fs/locks.c (2014-07-13 21:39:07 -0400)

----------------------------------------------------------------
(from the branch description for linux-next local branch)

linux-next branch

File locking related changes for v3.17 (pile #1)

Just a couple of changes from Christoph to start us down the road toward
getting rid of the fl_owner_t typedef.

----------------------------------------------------------------
Christoph Hellwig (2):
      locks: typedef fl_owner_t to void *
      locks: purge fl_owner_t from fs/locks.c

 fs/locks.c         | 26 +++++++++++++-------------
 include/linux/fs.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

-- 
Jeff Layton <jlayton@poochiereds.net>
