Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951Ab3DCSTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 14:19:25 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59008 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758971Ab3DCSTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 14:19:23 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] ext4 updates for 3.9-rc6
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 14:19:20 -0400
Message-ID: <nsxd2ub79zr.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 8cde7ad17e4f4ff8d12ff60dd09c0a291cb0b61c:

  ext4: fix big-endian bugs which could cause fs corruptions (2013-04-03 12:37:17 -0400)

----------------------------------------------------------------
Unfortunately, we introduced some big-endian bugs during the last
merge window.  Fortunately, Cai and Christian noticed before 3.9
shipped.

----------------------------------------------------------------
Zheng Liu (1):
      ext4: fix big-endian bugs which could cause fs corruptions

 fs/ext4/extents.c  | 11 +++++++----
 fs/ext4/indirect.c |  4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

