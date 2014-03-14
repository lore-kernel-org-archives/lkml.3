Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaCNPqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:46:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbaCNPqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:46:38 -0400
Date: Fri, 14 Mar 2014 11:46:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: [git pull] device mapper fixes to include in 3.14
Message-ID: <20140314154635.GA23793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cebc2de44d3bce53e46476e774126c298ca2c8a9:

  dm space map metadata: fix refcount decrement below 0 which caused corruption (2014-03-07 12:02:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/dm-3.14-fixes-4

for you to fetch changes up to e893fba90c09f9b57fb97daae204ea9cc2c52fa5:

  dm cache: fix access beyond end of origin device (2014-03-12 13:52:00 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
Two small fixes for the DM cache target:
- fix corruption with >2TB fast device due to truncation bug
- fix access beyond end of origin device due to a partial block

----------------------------------------------------------------
Heinz Mauelshagen (2):
      dm cache: fix truncation bug when copying a block to/from >2TB fast device
      dm cache: fix access beyond end of origin device

 drivers/md/dm-cache-target.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)
