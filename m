Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3IPH3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 03:29:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:5924 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab3IPH3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 03:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="396207509"
Message-ID: <1379316587.17490.56.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.12-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Sep 2013 10:29:47 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

very few changes. I'll start using a single UBI/UBIFS tree instead
of 2 trees from now on. So in the future you'll get 1 small pull
request instead of 2 tiny ones.

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.12-rc1

for you to fetch changes up to c23e9b75ccd0edba81a506c7d97e0af626489256:

  UBIFS: remove invalid warn msg with tst_recovery enabled (2013-08-16 16:42:08 +0300)

----------------------------------------------------------------
Just one patch which fixes the power-cut recovery testing mode.

----------------------------------------------------------------
Mats Kärrman (1):
      UBIFS: remove invalid warn msg with tst_recovery enabled

 fs/ubifs/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

