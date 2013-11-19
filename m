Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3KSWwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:52:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:32226 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab3KSWwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:52:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438111440"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: [GIT PULL] Unbreak the ia64 build
Date: Tue, 19 Nov 2013 14:52:07 -0800
Message-Id: <528beb972986965d4@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dec8e46178bad9f1717a948572d76e0f804be801:

  Merge tag 'arc-v3.13-rc1-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc (2013-11-19 11:44:15 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-fixia64

for you to fetch changes up to 24b9fdc59ac365e7e313e5af44c7bfe31c15c774:

  kernel/bounds: avoid circular dependencies in generated headers (2013-11-19 14:20:12 -0800)

----------------------------------------------------------------
Unbreak ia64 build by avoiding circular dependency

----------------------------------------------------------------
Kirill A. Shutemov (1):
      kernel/bounds: avoid circular dependencies in generated headers

 kernel/bounds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
