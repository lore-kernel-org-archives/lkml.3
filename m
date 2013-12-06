Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3LFRu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:50:58 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20029 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752264Ab3LFRu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:50:57 -0500
Date: Fri, 6 Dec 2013 17:50:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.13
Message-ID: <20131206175032.GA30277@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to db4ed53cfe9f5a00355891a631d47dfa3fd4541f:

  arm64: mm: Fix PMD_SECT_PROT_NONE definition (2013-12-06 17:22:44 +0000)

----------------------------------------------------------------
- Page table fixes (PROT_NONE, shareability attribute, TLB invalidation)
- Secondary CPUs entry endianness fix
- Make NR_CPUS default to 8

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Fix memory shareability attribute for ioremap_wc/cache

Lorenzo Pieralisi (1):
      arm64: kernel: add code to set cpu boot mode to secondary_entry shim

Mark Rutland (1):
      arm64: ensure completion of TLB invalidatation

Rob Herring (1):
      arm64: make default NR_CPUS 8

Steve Capper (1):
      arm64: mm: Fix PMD_SECT_PROT_NONE definition

 arch/arm64/Kconfig                     | 3 +--
 arch/arm64/include/asm/io.h            | 2 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 2 +-
 arch/arm64/kernel/head.S               | 3 ++-
 arch/arm64/mm/proc.S                   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
Catalin
