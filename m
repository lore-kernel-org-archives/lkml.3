Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaJPQyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:54:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:15317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaJPQyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:54:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,733,1406617200"; 
   d="scan'208";a="615622936"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] ensure unique filenames in pstore
Date: Thu, 16 Oct 2014 09:53:42 -0700
Message-Id: <543ff816133701aa2f@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9:

  Linux 3.17 (2014-10-05 12:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore

for you to fetch changes up to d4bf205da618bbd0b038e404d646f14e76915718:

  pstore: Fix duplicate {console,ftrace}-efi entries (2014-10-15 13:51:33 -0700)

----------------------------------------------------------------
ensure unique filenames in pstore

----------------------------------------------------------------
Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

 fs/pstore/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
