Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3INAmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:42:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:17663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab3INAmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:42:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,901,1371106800"; 
   d="scan'208";a="395552335"
Date: Sat, 14 Sep 2013 08:42:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] writeback fix for v3.12
Message-ID: <20130914004218.GA14726@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit a8855990e382fc81c04187c5fdb48743307baf32:

  writeback: Do not sort b_io list only because of block device inode (2013-07-09 22:36:45 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback-fixes

for you to fetch changes up to a8855990e382fc81c04187c5fdb48743307baf32:

  writeback: Do not sort b_io list only because of block device inode (2013-07-09 22:36:45 +0800)

----------------------------------------------------------------
a trivial writeback fix

----------------------------------------------------------------

Thanks,
Fengguang
