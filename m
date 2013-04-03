Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371Ab3DCUqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:46:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:13482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357Ab3DCUqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:46:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,403,1363158000"; 
   d="scan'208";a="313218980"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: [GIT PULL] x86/mce - clean up cmci_rediscover()
Date: Wed, 03 Apr 2013 13:46:50 -0700
Message-Id: <515c953a828839e37@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-cmci_rediscover

for you to fetch changes up to 7a0c819d28f5c91955854e048766d6afef7c8a3d:

  x86/mce: Rework cmci_rediscover() to play well with CPU hotplug (2013-04-02 14:04:01 -0700)

----------------------------------------------------------------
Clean up cmci_rediscover code to fix problems found by Dave Jones

----------------------------------------------------------------
Srivatsa S. Bhat (1):
      x86/mce: Rework cmci_rediscover() to play well with CPU hotplug

 arch/x86/include/asm/mce.h             |  4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c       |  2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 25 +++++--------------------
 3 files changed, 8 insertions(+), 23 deletions(-)
