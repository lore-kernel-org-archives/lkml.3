Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaJMNrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:47:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:20096 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbaJMNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,710,1406617200"; 
   d="scan'208";a="613638835"
Message-ID: <1413208012.7906.23.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI/UBIFS fixes for 3.18-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2014 16:46:52 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBI/UBIFS changes.

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.18-rc1

for you to fetch changes up to fda322a1b3b9e8ee231913c500f73c6988b1aff5:

  UBI: Dispatch update notification if the volume is updated (2014-09-16 19:02:05 +0300)

----------------------------------------------------------------
* Fix for a theoretical race condition which could lead to a situation when
  UBIFS is unable to mount a file-system (Hujianyang)
* Few fixes for the ubiblock sybsystem and an error path fix
* The ubiblock subsystem has had the volume size change handling improved

----------------------------------------------------------------
Artem Bityutskiy (2):
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Colin Ian King (1):
      UBI: block: fix dereference on uninitialized dev

Ezequiel Garcia (3):
      UBI: block: Fix block device size setting
      UBI: block: Add support for the UBI_VOLUME_UPDATED notification
      UBI: Dispatch update notification if the volume is updated

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

 drivers/mtd/ubi/block.c   | 36 +++++++++++++++++++++++++-----------
 drivers/mtd/ubi/cdev.c    |  4 +++-
 drivers/mtd/ubi/fastmap.c |  1 +
 fs/ubifs/commit.c         |  8 +++-----
 fs/ubifs/log.c            | 19 ++++++++++++++-----
 5 files changed, 46 insertions(+), 22 deletions(-)

--
Artem

