Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaKZVmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:42:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51016 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaKZVmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:42:50 -0500
Date: Wed, 26 Nov 2014 16:42:47 -0500 (EST)
Message-Id: <20141126.164247.2147782917285716161.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Nov 2014 13:42:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc fix to add dma_cache_sync(), even if a
nop it should be provided if dma_{alloc,free}_noncoherent() is
provided too, thanks!

The following changes since commit b914c5b2130239fd378d1a719ab3c53f0c782be9:

  Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux (2014-11-25 19:05:41 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 0d1d9092b536859a333ee96cff4df0ee24b55190:

  sparc: Add NOP dma_cache_sync() implementation. (2014-11-26 13:36:41 -0800)

----------------------------------------------------------------
David S. Miller (1):
      sparc: Add NOP dma_cache_sync() implementation.

 arch/sparc/include/asm/dma-mapping.h | 8 ++++++++
 1 file changed, 8 insertions(+)
