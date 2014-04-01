Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaDAXgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:36:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:32233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaDAXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,776,1389772800"; 
   d="scan'208";a="512718911"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liu ShuoX <shuox.liu@intel.com>
Subject: [GIT PULL] pstore fixes for 3.15
Date: Tue, 01 Apr 2014 16:36:22 -0700
Message-Id: <533b4d76301489fdd4@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to e32634f5d57f1dce88624b70a6d625915f6ea09e:

  pstore: Fix memory leak when decompress using big_oops_buf (2014-03-17 14:14:03 -0700)

----------------------------------------------------------------
Series of small bug fixes for pstore.

----------------------------------------------------------------
Liu ShuoX (6):
      pstore: clarify clearing of _read_cnt in ramoops_context
      pstore: skip zero size persistent ram buffer in traverse
      pstore: Fix NULL pointer fault if get NULL prz in ramoops_get_next_prz
      pstore: Correct the max_dump_cnt clearing of ramoops
      pstore: Fix buffer overflow while write offset equal to buffer size
      pstore: Fix memory leak when decompress using big_oops_buf

 fs/pstore/platform.c |  1 +
 fs/pstore/ram.c      | 19 +++++++++++--------
 fs/pstore/ram_core.c |  4 ++--
 3 files changed, 14 insertions(+), 10 deletions(-)
