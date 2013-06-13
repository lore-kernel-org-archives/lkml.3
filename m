Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3FMJAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:7589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758420Ab3FMJAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,857,1363158000"; 
   d="scan'208";a="349193626"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 0/3] some optimization & code cleanup
Date: Thu, 13 Jun 2013 16:59:26 +0800
Message-Id: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some issues found by code review.

Haicheng Li (3):
  f2fs: remove unnecessary parameter "offset" from __add_sum_entry()
  f2fs: make locate_dirty_segment() as static
  f2fs: optimize do_write_data_page()

 fs/f2fs/data.c    |    5 +++--
 fs/f2fs/f2fs.h    |    1 -
 fs/f2fs/segment.c |   12 ++++++------
 3 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.7.9.5

