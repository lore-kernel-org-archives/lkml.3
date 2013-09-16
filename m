Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3IPHaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:30:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:61631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab3IPHaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:30:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="378727931"
Message-ID: <1379316610.17490.58.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.12-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 10:30:10 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

very few changes. I'll start using a single UBI/UBIFS tree instead
of 2 trees from now on. So in the future you'll get 1 small pull
request instead of 2 tiny ones.

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.12-rc1

for you to fetch changes up to 8930fa500f55215f0211db9b78255e727ac3f282:

  UBI: Fix invalidate_fastmap() (2013-08-20 17:53:25 +0300)

----------------------------------------------------------------
Just a single fastmap fix plus a regression fix.

----------------------------------------------------------------
Richard Weinberger (2):
      UBI: Fix PEB leak in wear_leveling_worker()
      UBI: Fix invalidate_fastmap()

 drivers/mtd/ubi/fastmap.c | 5 +----
 drivers/mtd/ubi/wl.c      | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

