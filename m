Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaA3MqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:46:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:42780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaA3MqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:46:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,749,1384329600"; 
   d="scan'208";a="407267059"
Message-ID: <1391085977.28238.32.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.14-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 30 Jan 2014 14:46:17 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.14-rc1

for you to fetch changes up to 2c7ca5cc3624e05a5235f70039adce30725972d6:

  UBI: avoid program operation on NOR flash after erasure interrupted (2014-01-09 18:25:38 +0200)

----------------------------------------------------------------
* Improve the NOR erasure quirk - now it tries to do as little writes as
  possible, because the eraseblock may be in an "unstable" state and write
  operation sometimes causes NOR chip lock-ups.
* Both UBI and UBIFS changes are now maintainer in one single tree, because the
  amount of changes dropped significantly.

----------------------------------------------------------------
Artem Bityutskiy (1):
      MAINTAINERS: keep UBI and UBIFS stuff in the same tree

Julia Lawall (1):
      UBI: fix error return code

Qi Wang 王起 (qiwang) (1):
      UBI: avoid program operation on NOR flash after erasure interrupted

 MAINTAINERS              |  2 +-
 drivers/mtd/ubi/attach.c |  4 +++-
 drivers/mtd/ubi/build.c  |  4 +++-
 drivers/mtd/ubi/io.c     | 54 ++++++++++++++++++++++--------------------------------
 4 files changed, 29 insertions(+), 35 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

