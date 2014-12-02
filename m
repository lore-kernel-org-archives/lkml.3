Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaLBDnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:43:24 -0500
Received: from imap.thunk.org ([74.207.234.97]:33462 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbaLBDnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:43:23 -0500
Date: Mon, 1 Dec 2014 22:43:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 bug fixes for 3.18
Message-ID: <20141202034318.GA13101@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_urgent

for you to fetch changes up to 32f3869184d498850d36b7e6aa3b9f5260ea648a:

  jbd2: fix regression where we fail to initialize checksum seed when loading (2014-12-01 21:57:06 -0500)

----------------------------------------------------------------
Fix an ext4 metadata checksum regression introduced in v3.18-rc3.

----------------------------------------------------------------
Darrick J. Wong (1):
      jbd2: fix regression where we fail to initialize checksum seed when loading

 fs/jbd2/journal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)
