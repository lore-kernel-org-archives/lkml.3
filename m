Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaBZM0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:26:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:63694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaBZM0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:26:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,547,1389772800"; 
   d="scan'208";a="488375678"
Message-ID: <1393417609.3412.156.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.14-rc5
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 14:26:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.14-rc5

for you to fetch changes up to 5547fec74a566e1f5e00a937b9a367f7c6a94a8b:

  UBI: fix some use after free bugs (2014-02-04 09:44:30 +0200)

----------------------------------------------------------------
Just a single fix for the UBI module unload path which makes sure we do not
touch freed memory.

----------------------------------------------------------------
Dan Carpenter (1):
      UBI: fix some use after free bugs

 drivers/mtd/ubi/fastmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

