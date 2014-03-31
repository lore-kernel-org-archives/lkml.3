Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaCaXjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:39:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:56905 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaCaXjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:39:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,768,1389772800"; 
   d="scan'208";a="511426250"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] RAS - fix CMCI storm code
Date: Mon, 31 Mar 2014 16:39:40 -0700
Message-Id: <5339fcbc25587e4b8d@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b098d6726bbfb94c06d6e1097466187afddae61f:

  Linux 3.14-rc8 (2014-03-24 19:31:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-cmci-storm

for you to fetch changes up to 27f6c573e0f77f7d1cc907c1494c99a61e48b7d8:

  x86, CMCI: Add proper detection of end of CMCI storms (2014-03-28 13:40:16 -0700)

----------------------------------------------------------------
Fix the code to tell when a CMCI storm ends by actually
looking at the machine check banks when we poll while
interrupts are disabled.

----------------------------------------------------------------
Chen, Gong (1):
      x86, CMCI: Add proper detection of end of CMCI storms

 arch/x86/kernel/cpu/mcheck/mce.c       | 18 +++++++++++++++++-
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 19 ++++++++++++++++++-
 2 files changed, 35 insertions(+), 2 deletions(-)
