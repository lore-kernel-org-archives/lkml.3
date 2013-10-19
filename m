Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3JSU2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 16:28:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:59447 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3JSU2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 16:28:05 -0400
Date: Sat, 19 Oct 2013 22:27:59 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] parisc fixes for v3.12
Message-ID: <20131019202759.GA3700@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:6mh5f1oNrf+sZ3h3z9KqaAqg7pJ/FaMzdB9OlpRf30d+y1zLXNI
 qlJ3PeDxY+IzE0L1p1uRWkvLcJvdYoq1az5dgGjr235UYXEmfmR6JZTupZ5a1xH5c1Md1Jr
 M+ZfxOGaoELSIC2+yt6n+TTASdTNdfYxvIc7Jvwpodszm9WgcWgo3SbFQhQaA2wOfMQMvp7
 qPJ9+o8dSZknlZlsuTxbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest parisc fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.12

There are just two small fixes in here:
- Revert a commit which exported the flush_cache_page function. This was
  noticed by Christoph Hellwig. 
- Enable the DEVTMPFS, DEVTMPFS_MOUNT and BLK_DEV_INITRD config options in the
  parisc defconfigs so that latest udev/initrd finds the root disk at boot.

Thanks,
Helge

----------------------------------------------------------------
Helge Deller (2):
      Revert "parisc: Export flush_cache_page() (needed by lustre)"
      parisc: enable DEVTMPFS, DEVTMPFS_MOUNT and BLK_DEV_INITRD in defconfigs

 arch/parisc/configs/712_defconfig     | 2 ++
 arch/parisc/configs/a500_defconfig    | 2 ++
 arch/parisc/configs/b180_defconfig    | 3 +++
 arch/parisc/configs/c3000_defconfig   | 3 +++
 arch/parisc/configs/c8000_defconfig   | 2 ++
 arch/parisc/configs/default_defconfig | 2 ++
 arch/parisc/kernel/cache.c            | 1 -
 7 files changed, 14 insertions(+), 1 deletion(-)
