Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab3BYJbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:31:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:57943 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab3BYJbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,733,1355126400"; 
   d="scan'208";a="290062951"
Message-ID: <1361784714.2974.3.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.9-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Feb 2013 11:31:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes for 3.9-rc1.

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.9-rc1

for you to fetch changes up to 8afd500cb52a5d00bab4525dd5a560d199f979b9:

  UBIFS: fix double free of ubifs_orphan objects (2013-02-04 12:31:48 +0200)

----------------------------------------------------------------
I's been quite silent and we have only a couple of bug-fixes for the orphans
handling code plus one cosmetic change.

----------------------------------------------------------------
Adam Thomas (2):
      UBIFS: fix use of freed ubifs_orphan objects
      UBIFS: fix double free of ubifs_orphan objects

Akinobu Mita (1):
      UBIFS: rename random32() to prandom_u32()

 fs/ubifs/debug.c      |    8 ++++----
 fs/ubifs/lpt_commit.c |   14 +++++++-------
 fs/ubifs/orphan.c     |   12 ++++++++++--
 fs/ubifs/tnc_commit.c |    2 +-
 fs/ubifs/ubifs.h      |    6 +++++-
 5 files changed, 27 insertions(+), 15 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

