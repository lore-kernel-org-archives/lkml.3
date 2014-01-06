Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaAFUHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:07:55 -0500
Received: from imap.thunk.org ([74.207.234.97]:46356 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbaAFUHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:07:54 -0500
Date: Mon, 6 Jan 2014 15:07:52 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [GIT PULL] ext4 fixes for 3.13
Message-ID: <20140106200752.GA31360@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
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

The following changes since commit f5a44db5d2d677dfbf12deee461f85e9ec633961:

  ext4: add explicit casts when masking cluster sizes (2013-12-20 09:29:35 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to d0abafac8c9162f39c4f6b2f8141b772a09b3770:

  ext4: fix bigalloc regression (2014-01-06 14:00:23 -0500)

----------------------------------------------------------------
Fix a regression introduced in v3.13-rc6

----------------------------------------------------------------
Eric Whitney (1):
      ext4: fix bigalloc regression

 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
