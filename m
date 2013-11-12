Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3KLMd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:33:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:29849 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab3KLMdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:33:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407426763"
Message-ID: <1384259599.15824.137.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBIFS changes for 3.13-rc1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 14:33:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-ubifs.git tags/upstream-3.13-rc1

for you to fetch changes up to 58a4e23703b22c331b01fbd0c12161aadaa6d50b:

  UBIFS: correct data corruption range (2013-10-26 11:33:38 +0100)

----------------------------------------------------------------
Mostly fixes for the power cut emulation UBIFS mode, and only one functional
change which fixes a return error code.

----------------------------------------------------------------
Mats Kärrman (2):
      UBIFS: remove invalid warn msg with tst_recovery enabled
      UBIFS: correct data corruption range

Wei Yongjun (1):
      UBIFS: fix return code

wang.bo116@zte.com.cn (1):
      UBIFS: remove unnecessary code in ubifs_garbage_collect

 fs/ubifs/debug.c | 13 +++++++------
 fs/ubifs/gc.c    |  3 +--
 fs/ubifs/super.c |  8 ++++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
Best Regards,
Artem Bityutskiy

