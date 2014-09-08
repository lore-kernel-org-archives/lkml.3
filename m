Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaIHWnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:43:05 -0400
Received: from imap.thunk.org ([74.207.234.97]:44651 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaIHWnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:43:03 -0400
Date: Mon, 8 Sep 2014 18:42:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] an ext4 bug fix for 3.17
Message-ID: <20140908224257.GA25719@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
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

The following changes since commit d4f03186c8986ffde34d06fe74a99aab08f7ee0b:

  Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2014-08-29 11:52:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus_urgent

for you to fetch changes up to a9cfcd63e8d206ce4235c355d857c4fbdf0f4587:

  ext4: avoid trying to kfree an ERR_PTR pointer (2014-09-03 09:37:30 -0400)

----------------------------------------------------------------
Theodore Ts'o (1):
      ext4: avoid trying to kfree an ERR_PTR pointer

 fs/ext4/namei.c  | 2 ++
 fs/ext4/resize.c | 2 ++
 2 files changed, 4 insertions(+)
