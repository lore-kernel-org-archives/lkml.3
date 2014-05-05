Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaEEHzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:55:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:24809 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaEEHzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:55:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="534721736"
Message-ID: <1399276474.15290.18.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.15-rc5
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 05 May 2014 10:54:34 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.15-rc5

for you to fetch changes up to bebfef150e0b8fa68704cddacf05b8c26462d565:

  UBI: avoid workqueue format string leak (2014-05-05 09:31:33 +0300)

----------------------------------------------------------------
This pull request includes the following fixes:

* 2 real bug-fixes from Tanya for the still "experimental" UBI fastmap feature
* a one-liner from Kees which hardens kernel security
* a small error-path fix, where we forget to free various resources in case of
  failure - spotted by the "smatch" tool

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBIFS: fix remount error path

Kees Cook (1):
      UBI: avoid workqueue format string leak

Tanya Brokhman (2):
      UBI: fix error path in __wl_get_peb
      UBI: fix ubi free PEBs count calculation

 drivers/mtd/ubi/block.c | 2 +-
 drivers/mtd/ubi/wl.c    | 6 ++++++
 fs/ubifs/super.c        | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

