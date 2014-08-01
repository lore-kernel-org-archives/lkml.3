Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaHAQp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbaHAQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:45:58 -0400
Date: Fri, 1 Aug 2014 12:45:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Greg Thelen <gthelen@google.com>, Anssi Hannula <anssi.hannula@iki.fi>
Subject: [git pull] device mapper fixes for 3.16 final
Message-ID: <20140801164541.GA21696@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.16-fixes-3

for you to fetch changes up to 44fa816bb778edbab6b6ddaaf24908dd6295937e:

  dm cache: fix race affecting dirty block count (2014-08-01 12:25:22 -0400)

----------------------------------------------------------------
Fix dm bufio shrinker to properly zero-fill all fields.

Fix race in dm cache that caused improper reporting of the number of
dirty blocks in the cache.

----------------------------------------------------------------
Anssi Hannula (1):
      dm cache: fix race affecting dirty block count

Greg Thelen (1):
      dm bufio: fully initialize shrinker

 drivers/md/dm-bufio.c        |  2 +-
 drivers/md/dm-cache-target.c | 13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)
