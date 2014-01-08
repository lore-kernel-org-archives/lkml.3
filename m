Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaAHWqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:46:44 -0500
Received: from mout.gmx.net ([212.227.17.21]:52262 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167AbaAHWqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:46:40 -0500
Date: Wed, 8 Jan 2014 23:46:36 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc fix for v3.13
Message-ID: <20140108224636.GA19216@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:phlkWstGjrPkflljYblwY+cqt4Ehzk4saVrRlbsQtWWz/99Mbj+
 N+054OlkLBVBlVxodPcnTHTcoxi3oCDMZgg4uWYfQ+MRAnqmPUfwzbYdsp+PsYzabss08Qw
 Q/Mo/SnIWLeyVEWwa2Y34kAmVB5ui9365l5moI3DrTpOXWcqfOTpm8p9IzfLmOMczgvWhw1
 Li0Mix5JwHLb3Cshiaw/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull one late fix for Linux v3.13 for the parisc architecture from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.13

This patch fixes the kmap/kunmap implementation on parisc and finally makes AIO work on parisc.

Thanks,
Helge

----------------------------------------------------------------
John David Anglin (1):
      parisc: Ensure full cache coherency for kmap/kunmap

 arch/parisc/include/asm/cacheflush.h | 12 ++++--------
 arch/parisc/include/asm/page.h       |  5 ++---
 arch/parisc/kernel/cache.c           | 35 -----------------------------------
 3 files changed, 6 insertions(+), 46 deletions(-)
