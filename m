Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3FYVC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:02:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:35820 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3FYVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,939,1363158000"; 
   d="scan'208";a="322500907"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de
Subject: [GIT PULL] for tip x86/ras branch - queue for 3.11
Date: Tue, 25 Jun 2013 14:01:39 -0700
Message-Id: <51ca05338342dea09@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-bitmap-comment

for you to fetch changes up to 0644414e62561f0ba1bea7c5ba6a94cc50dac3e3:

  mce: acpi/apei: Add comments to clarify usage of the various bitfields in the MCA subsystem (2013-06-25 13:53:27 -0700)

----------------------------------------------------------------
Better comments so we understand our existing machine check
bank bitmaps - prelude to adding another bitmap soon.

----------------------------------------------------------------
Naveen N. Rao (1):
      mce: acpi/apei: Add comments to clarify usage of the various bitfields in the MCA subsystem

 arch/x86/kernel/cpu/mcheck/mce.c       |  5 ++++-
 arch/x86/kernel/cpu/mcheck/mce_intel.c | 12 ++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
