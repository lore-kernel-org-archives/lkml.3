Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3HQNFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 09:05:46 -0400
Received: from imap.thunk.org ([74.207.234.97]:44952 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab3HQNFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 09:05:45 -0400
Date: Sat, 17 Aug 2013 09:05:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] jbd2 bug fixes for v3.11-rc6
Message-ID: <20130817130542.GA32430@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cde2d7a796f7e895e25b43471ed658079345636d:

  ext4: flush the extent status cache during EXT4_IOC_SWAP_BOOT (2013-08-12 09:29:30 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to a361293f5fedea0016a10599f409631a15d47ee7:

  jbd2: Fix oops in jbd2_journal_file_inode() (2013-08-16 21:19:41 -0400)

----------------------------------------------------------------
Two jbd2 bug fixes, one of which is a regression fix.

----------------------------------------------------------------
Jan Kara (2):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
      jbd2: Fix oops in jbd2_journal_file_inode()

 fs/ext4/ext4.h      |  1 +
 fs/ext4/ext4_jbd2.c |  8 ++++----
 fs/ext4/file.c      | 21 ++++-----------------
 fs/ext4/inode.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 21 deletions(-)
