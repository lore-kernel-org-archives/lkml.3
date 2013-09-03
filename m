Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3ICOvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:51:23 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42975 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab3ICOvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:51:21 -0400
Date: Tue, 3 Sep 2013 16:51:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu changes for v3.12
Message-ID: <20130903145118.GA29006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpu-for-linus

   HEAD: 237d1548543312fcc8c99d302ab68fbf8ef6f97f x86: Fix override new_cpu_data.x86 with 486

Two small cpufeature support updates.

[ NOTE: diffstat was created manually. ]

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, cpufeature: Use new CC_HAVE_ASM_GOTO

H. Peter Anvin (1):
      Merge remote-tracking branch 'origin/x86/fpu' into queue/x86/cpu

Wang YanQing (1):
      x86: Fix override new_cpu_data.x86 with 486

Merge made by the 'recursive' strategy.
 arch/x86/include/asm/cpufeature.h | 17 +++++++++++------
 arch/x86/kernel/head_32.S         |  2 +-
 2 files changed, 12 insertions(+), 7 deletions(-)

