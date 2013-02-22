Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3BVRic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:38:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:17528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab3BVRi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:38:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,717,1355126400"; 
   d="scan'208";a="290666016"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        Clark Williams <clark.williams@gmail.com>
Subject: [GIT PULL] Fix ia64 build breakage
Date: Fri, 22 Feb 2013 09:38:26 -0800
Message-Id: <5127ad1219167029@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2ef14f465b9e096531343f5b734cffc5f759f4a6:

  Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-02-21 18:06:55 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-fix-ia64-build

for you to fetch changes up to bc681593b588786e6326b3e5f78ccc1683e2269c:

  sched: move RR_TIMESLICE from sysctl.h to rt.h (2013-02-22 09:20:11 -0800)

----------------------------------------------------------------
Fix ia64 build

----------------------------------------------------------------
Clark Williams (1):
      sched: move RR_TIMESLICE from sysctl.h to rt.h

 include/linux/sched/rt.h     | 6 ++++++
 include/linux/sched/sysctl.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)
