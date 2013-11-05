Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3KEPxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:53:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3KEPxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:53:30 -0500
Message-ID: <1383666806.11574.54.camel@deneb.redhat.com>
Subject: [GIT PULL]  Kconfig cleanups for v3.13
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 05 Nov 2013 10:53:26 -0500
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to b2c32b32a21291107c3797448e0bd36716c8e445:

  c6x: remove unused COMMON_CLKDEV Kconfig parameter (2013-10-29 23:31:46 -0400)

----------------------------------------------------------------
Kconfig cleanups for v3.13

Remove some unused config options from C6X and clean up PC_PARPORT
dependencies. The latter was discussed here:

 https://lkml.org/lkml/2013/10/8/12

----------------------------------------------------------------
Mark Salter (13):
      alpha: select ARCH_MIGHT_HAVE_PC_PARPORT
      arm: select ARCH_MIGHT_HAVE_PC_PARPORT
      ia64: select ARCH_MIGHT_HAVE_PC_PARPORT
      m68k: select ARCH_MIGHT_HAVE_PC_PARPORT
      microblaze: select ARCH_MIGHT_HAVE_PC_PARPORT
      mips: select ARCH_MIGHT_HAVE_PC_PARPORT
      parisc: select ARCH_MIGHT_HAVE_PC_PARPORT
      powerpc: select ARCH_MIGHT_HAVE_PC_PARPORT
      sh: select ARCH_MIGHT_HAVE_PC_PARPORT
      sparc: select ARCH_MIGHT_HAVE_PC_PARPORT
      unicore32: select ARCH_MIGHT_HAVE_PC_PARPORT
      x86: select ARCH_MIGHT_HAVE_PC_PARPORT
      Kconfig cleanup (PARPORT_PC dependencies)

Michael Opdenacker (2):
      c6x: remove unused parameter in Kconfig
      c6x: remove unused COMMON_CLKDEV Kconfig parameter

 arch/alpha/Kconfig      |  1 +
 arch/arm/Kconfig        |  1 +
 arch/c6x/Kconfig        |  7 -------
 arch/ia64/Kconfig       |  1 +
 arch/m68k/Kconfig       |  1 +
 arch/microblaze/Kconfig |  1 +
 arch/mips/Kconfig       |  1 +
 arch/parisc/Kconfig     |  1 +
 arch/powerpc/Kconfig    |  1 +
 arch/sh/Kconfig         |  1 +
 arch/sparc/Kconfig      |  1 +
 arch/unicore32/Kconfig  |  1 +
 arch/x86/Kconfig        |  1 +
 drivers/parport/Kconfig | 10 +++++++---
 14 files changed, 19 insertions(+), 10 deletions(-)


