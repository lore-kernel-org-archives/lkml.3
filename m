Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954Ab3APJnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:43:45 -0500
Received: from linux-sh.org ([111.68.239.195]:57560 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab3APJnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:43:43 -0500
Date: Wed, 16 Jan 2013 18:43:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.8-rc4
Message-ID: <20130116094337.GB30208@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 254adaa465c40151df11fc1f88f93e6e86eb61d4:

  seq_file: fix new kernel-doc warnings (2013-01-10 14:35:24 -0800)

are available in the git repository at:

  git://github.com/pmundt/linux-sh.git tags/sh-for-linus

for you to fetch changes up to 035688d9c64c61957dd272a1e773f27b0143704d:

  sh: ecovec: add sample amixer settings (2013-01-16 18:30:44 +0900)

----------------------------------------------------------------
SuperH fixes for 3.8-rc4

----------------------------------------------------------------
Kuninori Morimoto (3):
      sh: define TASK_UNMAPPED_BASE as a page aligned constant
      sh: clkfwk: bugfix: sh_clk_div_enable() care sh_clk_div_set_rate() if div6
      sh: ecovec: add sample amixer settings

Paul Mundt (2):
      sh: wire up finit_module syscall.
      sh: Fix up stack debugging build.

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

 arch/sh/boards/mach-ecovec24/setup.c |   10 ++++++++++
 arch/sh/include/asm/elf.h            |    4 ++--
 arch/sh/include/asm/processor_32.h   |    2 +-
 arch/sh/include/asm/processor_64.h   |    2 +-
 arch/sh/include/uapi/asm/unistd_32.h |    3 ++-
 arch/sh/include/uapi/asm/unistd_64.h |    3 ++-
 arch/sh/kernel/syscalls_32.S         |    1 +
 arch/sh/kernel/syscalls_64.S         |    1 +
 arch/sh/lib/mcount.S                 |    2 ++
 drivers/sh/clk/cpg.c                 |    6 ++++++
 10 files changed, 28 insertions(+), 6 deletions(-)
