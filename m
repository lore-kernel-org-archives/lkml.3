Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3GAQw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:52:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:16908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab3GAQw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:52:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="325294162"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fix thermal power-limit code
Date: Mon, 01 Jul 2013 09:47:14 -0700
Message-Id: <51d1b29216999ee12@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-mce-therm

for you to fetch changes up to 6bb2ff846f24fa6efee756e5e2a2b8433d65671e:

  x86 thermal: Disable power limit notification interrupt by default (2013-06-14 14:49:00 -0700)

----------------------------------------------------------------
Thermal limit warnings are too scary and cause unnecessary concern

----------------------------------------------------------------
Fenghua Yu (2):
      x86 thermal: Delete power-limit-notification console messages
      x86 thermal: Disable power limit notification interrupt by default

 Documentation/kernel-parameters.txt      |  2 ++
 arch/x86/kernel/cpu/mcheck/therm_throt.c | 43 +++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 17 deletions(-)
