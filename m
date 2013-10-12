Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3JLSzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 14:55:43 -0400
Received: from imap.thunk.org ([74.207.234.97]:45241 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3JLSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 14:55:42 -0400
Date: Sat, 12 Oct 2013 14:55:39 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.12
Message-ID: <20131012185539.GA18630@thunk.org>
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

The following changes since commit ad4eec613536dc7e5ea0c6e59849e6edca634d8b:

  ext4: allow specifying external journal by pathname mount option (2013-08-28 19:05:07 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 6e4ea8e33b2057b85d75175dd89b93f5e26de3bc:

  ext4: fix memory leak in xattr (2013-10-12 14:39:49 -0400)

----------------------------------------------------------------
A bug fix and performance regression fix for ext4.

----------------------------------------------------------------
Dave Jones (1):
      ext4: fix memory leak in xattr

Jan Kara (1):
      ext4: fix performance regression in writeback of random writes

 fs/ext4/inode.c | 2 +-
 fs/ext4/xattr.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

