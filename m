Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3EMUsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:48:50 -0400
Received: from mout.gmx.net ([212.227.17.20]:61966 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3EMUst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:48:49 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18yXdlhmmwybdFpk7kMuOSEfk+y9I2Jp1eMLQCpR7
	GXAyw+YtfgU0eL
Date: Mon, 13 May 2013 22:48:43 +0200
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] parisc updates for v3.10
Message-ID: <20130513204843.GA1858@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the parisc-for-3.10 branch of 

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.10

to get the latest bug and build fixes for the parisc architecture.

Thanks,
Helge

---------------------------------------

The second round of parisc updates for 3.10 includes build fixes and
enhancements to utilize irq stacks, fixes SMP races when updating PTE
and TLB entries by proper locking and makes the search for the correct
cross compiler more robust on Debian and Gentoo.

----------------------------------------------------------------
Helge Deller (2):
      parisc: implement irq stacks - part 2 (v2)
      parisc: make default cross compiler search more robust (v3)

John David Anglin (1):
      parisc: fix SMP races when updating PTE and TLB entries in entry.S

 arch/parisc/Kconfig                 |   2 +-
 arch/parisc/Makefile                |  21 +++--
 arch/parisc/include/asm/hardirq.h   |   9 +++
 arch/parisc/include/asm/processor.h |   3 +
 arch/parisc/kernel/entry.S          | 155 +++++++++++++++++++-----------------
 arch/parisc/kernel/irq.c            | 101 +++++++++++++++++++----
 arch/parisc/mm/init.c               |   4 +-
 7 files changed, 194 insertions(+), 101 deletions(-)
