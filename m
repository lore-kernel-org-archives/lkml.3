Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaGKSP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:15:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44103 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752396AbaGKSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:15:28 -0400
Date: Fri, 11 Jul 2014 19:15:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 fixes for 3.16
Message-ID: <20140711181452.GA20619@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.


The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to fa2ec3ea10bd377f9d55772b1dab65178425a1a2:

  arm64: implement TASK_SIZE_OF (2014-07-08 17:30:59 +0100)

----------------------------------------------------------------
ARM64 implementation of TASK_SIZE_OF and exporting two functions to
modules.

----------------------------------------------------------------
Colin Cross (1):
      arm64: implement TASK_SIZE_OF

Mark Salter (1):
      arm64: export __cpu_{clear,copy}_user_page functions

 arch/arm64/include/asm/memory.h | 2 ++
 arch/arm64/mm/copypage.c        | 2 ++
 2 files changed, 4 insertions(+)

-- 
Catalin
