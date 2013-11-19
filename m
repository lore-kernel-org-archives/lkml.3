Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3KSWTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:19:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3KSWTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:19:00 -0500
Date: Tue, 19 Nov 2013 17:18:58 -0500 (EST)
Message-Id: <20131119.171858.625621283989173777.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Nov 2013 14:19:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two merge window fallout build fixes, please pull, thanks a lot!

The following changes since commit 2d3c627502f2a9b0a7de06a5a2df2365542a72c9:

  Revert "init/Kconfig: add option to disable kernel compression" (2013-11-17 11:17:36 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 6a328f3fe042396c6525d7bf84cfd941440cc045:

  sparc64: merge fix (2013-11-18 15:08:52 -0800)

----------------------------------------------------------------
Kirill A. Shutemov (1):
      sparc64: fix build regession

Stephen Rothwell (1):
      sparc64: merge fix

 arch/sparc/include/asm/tlbflush_64.h | 1 -
 arch/sparc/mm/init_64.c              | 2 --
 2 files changed, 3 deletions(-)
