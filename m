Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbaFBA14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:27:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:36429 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaFBA1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:27:55 -0400
Message-ID: <1401668861.14938.125.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jun 2014 10:27:41 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's just one trivial patch to wire up sys_renameat2 which I
seem to have completely missed so far. (My test build scripts fwd me
warnings but miss the ones generated for missing syscalls).

Cheers,
Ben.

The following changes since commit 011e4b02f1da156ac7fea28a9da878f3c23af739:

  powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode (2014-05-28 13:24:26 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 8212f58a9b151d842fa60a70f354e43c61fad839:

  powerpc: Wire renameat2() syscall (2014-06-02 09:24:27 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      powerpc: Wire renameat2() syscall

 arch/powerpc/include/asm/systbl.h      | 1 +
 arch/powerpc/include/asm/unistd.h      | 2 +-
 arch/powerpc/include/uapi/asm/unistd.h | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)


