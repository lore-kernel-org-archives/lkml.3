Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762456Ab3DDPay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:30:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:9667 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762362Ab3DDPax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:30:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,409,1363158000"; 
   d="scan'208";a="313646382"
Message-ID: <1365089540.626.16.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.9-rc6
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 04 Apr 2013 18:32:20 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please, pull a single UBIFS fix for v3.9.

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.9-rc6

for you to fetch changes up to 67e753ca41782913d805ff4a8a2b0f60b26b7915:

  UBIFS: make space fixup work in the remount case (2013-03-14 11:20:22 +0200)

----------------------------------------------------------------
Make the space fixup feature work in the case when the file-system is first
mounted R/O and then remounted R/W.

----------------------------------------------------------------
Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

 fs/ubifs/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

