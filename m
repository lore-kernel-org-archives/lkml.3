Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbaFCNmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:42:21 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:36101 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaFCNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:42:19 -0400
Date: Tue, 3 Jun 2014 15:42:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.16
Message-ID: <20140603134214.GA31721@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: c81c8a1eeede61e92a15103748c23d100880cc8a x86, ioremap: Speed up check for RAM pages

 - speed up 256 GB PCI BAR ioremap()s

 - speed up PTE swapout page reclaim case

Thanks,

	Ingo


---------------------{ shortlog+diffstat manually created }---------->

Ingo Molnar (1):
      Merge commit 'b13b1d2d8692' into x86/mm

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Shaohua Li (1):
      x86/mm: In the PTE swapout page reclaim case clear the accessed bit instead of flushing the TLB


 arch/x86/mm/ioremap.c | 26 +++++++++++++++++++-------
 arch/x86/mm/pgtable.c | 21 ++++++++++++++-------
 2 files changed, 33 insertions(+), 14 deletions(-)

