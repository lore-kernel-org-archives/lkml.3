Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3FYHxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:53:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:58919 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab3FYHxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:53:42 -0400
Message-ID: <1372146812.3944.198.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 25 Jun 2013 17:53:32 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This is a fix for a regression causing a freescale "83xx" based platforms
to crash on boot due to some PCI breakage. Please apply.

Cheers,
Ben.

The following changes since commit 17858ca65eef148d335ffd4cfc09228a1c1cbfb5:

  Merge tag 'please-pull-fixia64' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux (2013-06-18 06:29:19 -1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to b37e161388ac3980d5dfb73050e85874b84253eb:

  powerpc/pci: Fix boot panic on mpc83xx (regression) (2013-06-24 16:54:09 -0500)

----------------------------------------------------------------
Rojhalat Ibrahim (1):
      powerpc/pci: Fix boot panic on mpc83xx (regression)

 arch/powerpc/sysdev/fsl_pci.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)


