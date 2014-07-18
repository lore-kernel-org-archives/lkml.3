Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbaGRLVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:21:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:2822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbaGRLVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,684,1400050800"; 
   d="scan'208";a="575159242"
Message-ID: <1405682471.28207.1.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI fixes for 3.16-rc6
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Jul 2014 14:21:11 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull a couple of UBI fixes.

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.16-rc6

for you to fetch changes up to 44305ebde243a7cce2c592cc89afe5041d8bf884:

  UBI: fastmap: do not miss bit-flips (2014-07-16 08:32:00 +0300)

----------------------------------------------------------------
Two UBI fastmap-related fixes for v3.16:

1. Fix UBI fastmap support which we broke in 3.16-rc1 by reversing the
   volumes RB-tree sorting criteria.
2. Make sure that we scrub all PEBs where we see bit-flips - we were missing
   some of them when the fastmap feature was enabled.

----------------------------------------------------------------
Brian Norris (1):
      UBI: fastmap: do not miss bit-flips

Heiko Schocher (1):
      UBI: fix the volumes tree sorting criteria

 drivers/mtd/ubi/fastmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

