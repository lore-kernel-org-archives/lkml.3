Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaB1R5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:57:54 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14211 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753342AbaB1R5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:57:43 -0500
Date: Fri, 28 Feb 2014 17:57:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@arm.com
Subject: [GIT PULL] arm64 fixes for 3.14
Message-ID: <20140228175725.GA28200@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.


The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to b57fc9e80692043e2a3a74e1d2c047eb700dcd0c:

  arm64: Fix !CONFIG_SMP kernel build (2014-02-28 16:12:25 +0000)

----------------------------------------------------------------
- !CONFIG_SMP build fix
- pte bit testing macros conversion fix (int truncates top bits of long)
- stack unwinding PC calculation fix

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Fix !CONFIG_SMP kernel build

Olof Johansson (1):
      ARM64: unwind: Fix PC calculation

Steve Capper (1):
      arm64: mm: Add double logical invert to pte accessors

 arch/arm64/include/asm/percpu.h  |  8 ++++++++
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/kernel/stacktrace.c   |  6 +++++-
 3 files changed, 18 insertions(+), 6 deletions(-)

-- 
Catalin
