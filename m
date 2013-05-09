Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3EIQja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:39:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:65054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab3EIQj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:39:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,641,1363158000"; 
   d="scan'208";a="335029229"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Couple of trivial pstore cleanups
Date: Thu, 09 May 2013 09:39:27 -0700
Message-Id: <518bd13f2850563eae@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to 47110b88912a997f25d42373e339804d51da98de:

  pstore/ram: fix error return code in ramoops_probe() (2013-05-08 10:24:48 -0700)

----------------------------------------------------------------
Couple of pstore cleanups

----------------------------------------------------------------
Alexandru Gheorghiu (1):
      fs: pstore: Replaced calls to kmalloc and memcpy with kmemdup

Wei Yongjun (1):
      pstore/ram: fix error return code in ramoops_probe()

 fs/pstore/ram.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
