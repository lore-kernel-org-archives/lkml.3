Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3D2XSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:18:10 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62010 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833Ab3D2XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:18:09 -0400
Date: Mon, 29 Apr 2013 16:18:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] async changes for v3.10-rc1
Message-ID: <20130429231804.GI2395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains three cleanup patches for async from Lai.
All three patches are essentially cosmetic.

Thanks.

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-async

for you to fetch changes up to 362f2b098b188ede9c4350cc20e58040dbfa515e:

  async: rename and redefine async_func_ptr (2013-03-12 13:59:14 -0700)

----------------------------------------------------------------
Lai Jiangshan (3):
      async: simplify lowest_in_progress()
      async: remove unused @node from struct async_domain
      async: rename and redefine async_func_ptr

 arch/sh/drivers/pci/pcie-sh7786.c |  2 +-
 include/linux/async.h             | 13 +++++--------
 kernel/async.c                    | 40 ++++++++++++++++++---------------------
 3 files changed, 24 insertions(+), 31 deletions(-)

--
tejun
