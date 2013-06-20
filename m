Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3FTHBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:01:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:58601 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3FTHBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:01:50 -0400
Message-ID: <1371711696.3944.13.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 20 Jun 2013 17:01:36 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Please pull this regression fix into 3.10. We accidentally broke
hugetlbfs on Freescale embedded processors which use a slightly
different page table layout than our server processors.

Cheers,
Ben.

The following changes since commit c0691143dfe1d42ec9bd89de5921ccb6a27ea1b3:

  mn10300: Fix include dependency in irqflags.h et al. (2013-06-19 06:29:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 8bbd9f04b7d982d1c6aeb5c08f5983b3d0b9e2fe:

  powerpc: Fix bad pmd error with book3E config (2013-06-20 15:25:21 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc: Fix bad pmd error with book3E config

 arch/powerpc/mm/hugetlbpage.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


