Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3KLMdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:33:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:37983 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab3KLMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:33:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="320204697"
Message-ID: <1384259597.15824.136.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.13-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 14:33:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.13-rc1

for you to fetch changes up to ae0d146955665411a6d4cea5e0893429cfc52807:

  UBI: Add some asserts to ubi_attach_fastmap() (2013-10-03 19:42:51 +0300)

----------------------------------------------------------------
A bunch of fixes for the fastmap feature, which is still new and rather
experimental. It looks like it starts getting more users. No significant
changes for the "classical" non-fastmap UBI.

----------------------------------------------------------------
Richard Genoud (2):
      UBI: fastmap: fix backward compatibility with image_seq
      UBI: simplify image sequence test

Richard Weinberger (7):
      UBI: Fix PEB leak in wear_leveling_worker()
      UBI: Fix invalidate_fastmap()
      UBI: fix refill_wl_user_pool()
      UBI: Fix error path in scan_pool()
      UBI: Call scan_all() with correct offset in error case
      UBI: Fix memory leak in ubi_attach_fastmap() error path
      UBI: Add some asserts to ubi_attach_fastmap()

 drivers/mtd/ubi/attach.c  | 11 ++++++-----
 drivers/mtd/ubi/fastmap.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 drivers/mtd/ubi/wl.c      |  7 +++----
 3 files changed, 47 insertions(+), 17 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

