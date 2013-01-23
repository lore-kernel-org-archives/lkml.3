Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3AWR1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:27:12 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52289 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754864Ab3AWR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:27:11 -0500
Date: Wed, 23 Jan 2013 17:27:04 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 fixes for 3.8
Message-ID: <20130123172703.GJ27474@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to f1b99392caf120d7533da260318fae0eb5053737:

  arm64: makefile: fix uname munging when setting ARCH on native machine (2013-01-22 17:51:00 +0000)

----------------------------------------------------------------
- ELF coredump fix (more registers dumped than what user space expects)
- SUBARCH name generation (s/aarch64/arm64/)

----------------------------------------------------------------
Will Deacon (2):
      arm64: elf: fix core dumping to match what glibc expects
      arm64: makefile: fix uname munging when setting ARCH on native machine

 Makefile                     | 2 +-
 arch/arm64/include/asm/elf.h | 5 ++++-
 tools/perf/Makefile          | 2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)
