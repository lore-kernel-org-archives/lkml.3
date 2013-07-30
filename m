Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3G3Plc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:41:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:14748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab3G3Pla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,778,1367996400"; 
   d="scan'208";a="373512852"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Fix a regression in mce-severity.c
Date: Tue, 30 Jul 2013 08:41:29 -0700
Message-Id: <51f7dea9675680097@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sent this as a patch last Thursday - seems to have been lost
  in all the general noise, or is in a queue and I'm just too
  impatient: http://marc.info/?l=linux-kernel&m=137478705715276&w=2 ]

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-fix-mce-regression

for you to fetch changes up to 1a7f0e3c4fff449f6dd08787beb98a8e57d8cdc7:

  x86/mce: Fix mce regression from recent cleanup (2013-07-29 11:23:27 -0700)

----------------------------------------------------------------
Fix a regression in mce-severity.c

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Fix mce regression from recent cleanup

 arch/x86/kernel/cpu/mcheck/mce-severity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
