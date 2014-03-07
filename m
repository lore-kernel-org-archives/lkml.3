Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaCGVFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:05:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:45670 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbaCGVFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:05:08 -0500
Message-ID: <1394226295.14642.28.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 08:04:55 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of powerpc fixes for 3.14. One is (another !) nasty TM
problem, we can crash the kernel by forking inside a transaction. The
other one is a simple fix for an alignment issue which can hurt in LE
mode.

Cheers,
Ben.

The following changes since commit e0cf957614976896111e676e5134ac98ee227d3d:

  powerpc/powernv: Fix indirect XSCOM unmangling (2014-02-28 19:15:49 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67:

  powerpc: Align p_dyn, p_rela and p_st symbols (2014-03-07 13:50:19 +1100)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: Align p_dyn, p_rela and p_st symbols

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

 arch/powerpc/kernel/process.c  | 9 +++++++++
 arch/powerpc/kernel/reloc_64.S | 1 +
 2 files changed, 10 insertions(+)


