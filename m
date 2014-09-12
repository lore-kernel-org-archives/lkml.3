Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaILVK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:10:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaILVK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:10:58 -0400
Date: Fri, 12 Sep 2014 17:10:46 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>,
        Anssi Hannula <anssi.hannula@iki.fi>, Joe Thornber <ejt@redhat.com>
Subject: [git pull] device mapper fix for 3.17-rc5
Message-ID: <20140912211046.GA10673@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed:

  dm crypt: fix access beyond the end of allocated space (2014-08-28 14:24:09 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.17-fix2

for you to fetch changes up to 40aa978eccec61347cd47b97c598df49acde8be5:

  dm cache: fix race causing dirty blocks to be marked as clean (2014-09-10 11:20:47 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Fix a race in the DM cache target that caused dirty blocks to be marked
as clean.  This could cause no writeback to occur or spurious dirty
block counts.

----------------------------------------------------------------
Anssi Hannula (1):
      dm cache: fix race causing dirty blocks to be marked as clean

 drivers/md/dm-cache-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
