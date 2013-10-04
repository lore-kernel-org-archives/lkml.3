Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3JDP6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:58:20 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50201 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754694Ab3JDP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:58:18 -0400
Date: Fri, 4 Oct 2013 16:57:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 updates for 3.12
Message-ID: <20131004155725.GA11953@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes/updates below. Thanks.

The following changes since commit 25804e6a96681d5d2142058948e218999e4f547c:

  arm64: Widen hwcap to be 64 bit (2013-09-20 09:56:07 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to 09d3ce74d7d60f37d1b030886ec659bbfe2e73bf:

  arm64: Remove duplicate DEBUG_STACK_USAGE config (2013-10-02 18:03:26 +0100)

----------------------------------------------------------------
- Bug-fixes (get_user/put_user, incorrect register width for ASID,
  FPSIMD initialisation)
- Kconfig clean-up
- defconfig update

----------------------------------------------------------------
AKASHI Takahiro (1):
      arm64: avoid multiple evaluation of ptr in get_user/put_user()

Jiang Liu (1):
      arm64: fix possible invalid FPSIMD initialization state

Matthew Leach (1):
      arm64: use correct register width when retrieving ASID

Ramkumar Ramachandra (2):
      arm64: include EXT4 in defconfig
      arm64: include VIRTIO_{MMIO,BLK} in defconfig

Stephen Boyd (1):
      arm64: Remove duplicate DEBUG_STACK_USAGE config

 arch/arm64/Kconfig.debug         |  7 -------
 arch/arm64/configs/defconfig     |  5 ++++-
 arch/arm64/include/asm/uaccess.h | 10 ++++++----
 arch/arm64/kernel/fpsimd.c       |  2 ++
 arch/arm64/mm/tlb.S              |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

-- 
Catalin
