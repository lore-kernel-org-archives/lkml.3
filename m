Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaHWGhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 02:37:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51485 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaHWGhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 02:37:17 -0400
Date: Sat, 23 Aug 2014 08:37:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] microcode cleanups
Message-ID: <20140823063702.GA1724@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

please pull a bunch of cleanups to the microcode loader machinery, from
Henrique de Moraes Holschuh.

Thanks.

--
The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_cleanups

for you to fetch changes up to ebc14ddcc9454c02439b67f6536628289faaa26e:

  x86, microcode, intel: Fix total_size computation (2014-07-28 16:08:02 +0200)

----------------------------------------------------------------
A bunch of cleanups from Henrique.

----------------------------------------------------------------
Henrique de Moraes Holschuh (5):
      x86, microcode, amd: Fix missing static declaration
      x86, microcode, intel: Add missing static declarations
      x86, microcode, intel: Fix typos
      x86, microcode, intel: Rename apply_microcode and declare it static
      x86, microcode, intel: Fix total_size computation

 arch/x86/include/asm/microcode_intel.h      |  2 +-
 arch/x86/kernel/cpu/microcode/amd_early.c   |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c       |  4 ++--
 arch/x86/kernel/cpu/microcode/intel_early.c | 10 +++++-----
 4 files changed, 9 insertions(+), 9 deletions(-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
