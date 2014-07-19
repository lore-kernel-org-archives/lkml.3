Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaGSFy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:54:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:44767 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaGSFyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:54:55 -0400
Date: Sat, 19 Jul 2014 01:54:50 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] /dev/random fixes for 3.16
Message-ID: <20140719055450.GA15304@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
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

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus_stable

for you to fetch changes up to 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc:

  random: check for increase of entropy_count because of signed conversion (2014-07-19 01:42:13 -0400)

----------------------------------------------------------------
Fix a BUG splat found by trinity.

----------------------------------------------------------------
Hannes Frederic Sowa (1):
      random: check for increase of entropy_count because of signed conversion

 drivers/char/random.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)
