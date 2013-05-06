Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3EFPQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:16:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:31012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3EFPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:16:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="298322392"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH V2 0/4] f2fs: various optimization & bugfixing for node management
Date: Mon,  6 May 2013 23:15:40 +0800
Message-Id: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found several issues during my code-review of f2fs/node.c, but my orignial
patches are based on Kim's linux-f2fs master branch, and they cannot be smoothly
applied to latest dev branch.

So rebased and combined these patches into this patchset.

V1->V2: rebase the patches against Kim's linux-f2fs dev branch.

Haicheng Li (4):
  f2fs: bugfix for alloc_nid_failed()
  f2fs: code cleanup for scan_nat_page() and build_free_nids()
  f2fs: optimize scan_nat_page()
  f2fs: optimize build_free_nids()

 fs/f2fs/node.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

-- 
1.7.9.5

