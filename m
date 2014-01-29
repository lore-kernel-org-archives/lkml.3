Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaA2Va7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 16:30:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaA2Va5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 16:30:57 -0500
Date: Wed, 29 Jan 2014 22:30:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Emilian.Medve@Freescale.com, fbuihuu@gmail.com, gang.chen.5i5j@gmail.com,
        geoff@infradead.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild changes for v3.14-rc1
Message-ID: <20140129213056.GA1335@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these kbuild bits for v3.14-rc1:
- Fix make -s detection with make-4.0
- Fix for scripts/setlocalversion when the kernel repository is a
  submodule
- Do not hardcode ';' in macros that expand to assembler code, as some
  architectures' assemblers use a different character for newline
- Fix passing --gdwarf-2 to the assembler

Thanks,
Michal

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git kbuild

Chen Gang (1):
      arch: use ASM_NL instead of ';' for assembler new line character in the macro

Emil Medve (1):
      kbuild: Fix silent builds with make-4

Franck Bui-Huu (1):
      Fix detectition of kernel git repository in setlocalversion script [take #2]

Geoff Levand (3):
      kbuild: Fix debugging info generation for .S files
      mn10300: Remove redundant debugging info flag
      frv: Remove redundant debugging info flag

 Makefile                       |    8 +++++++-
 arch/arc/include/asm/linkage.h |    2 ++
 arch/frv/Makefile              |    7 -------
 arch/mn10300/Makefile          |    8 --------
 include/linux/linkage.h        |   19 ++++++++++++-------
 scripts/setlocalversion        |    3 ++-
 6 files changed, 23 insertions(+), 24 deletions(-)
