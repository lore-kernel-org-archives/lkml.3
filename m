Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3EILZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:25:44 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:37291
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037Ab3EILZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:25:43 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zz936eIzz1f42h1ee6h1ce5h1fdah1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz8275bhz2ei87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fhff4m129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: "Steven Miao (Steven Miao)" <realmz6@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.10
Date: Thu, 9 May 2013 19:28:29 +0800
Message-ID: <1368098909-919-1-git-send-email-realmz6@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin updates for Linux 3.10, some minor changes for performance and bug fixes.

The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:

  https://github.com/realmz/blackfin-linux.git tags/for-linus

for you to fetch changes up to 5ae89ee043ce96e3790e6c75f3807c8e37d98634:

  bfin cache: dcplb map: add 16M dcplb map for BF60x (2013-05-09 18:22:45 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.10

----------------------------------------------------------------
Aaron Wu (1):
      Platform Nand: Set the GPIO for NAND read as input

Geert Uytterhoeven (1):
      blackfin: twi: Remove bogus #endif

James Cosin (1):
      blackfin: fix bootup core clock and system clock display

Sonic Zhang (3):
      blackfin: dmc: Improve DDR2 write through in DMC effict controller.
      bf609: rsi: Add bf609 rsi MMR macro and board platform data.
      blackfin: rename vmImage to uImage after we move to buildroot

Steven Miao (2):
      blackfin: smp: fix smp build after drop asm/system.h
      bfin cache: dcplb map: add 16M dcplb map for BF60x

 arch/blackfin/Makefile                             |    6 ++--
 arch/blackfin/boot/Makefile                        |   16 +++++-----
 arch/blackfin/include/asm/atomic.h                 |    2 ++
 arch/blackfin/include/asm/bfin_sdh.h               |   31 ++++++++++++++++++--
 arch/blackfin/include/asm/bitops.h                 |    1 +
 arch/blackfin/include/asm/def_LPBlackfin.h         |    2 ++
 arch/blackfin/include/asm/mem_init.h               |    9 ++++++
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |   16 ++++++++--
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c          |   27 ++++++++++++++---
 arch/blackfin/kernel/cplbinfo.c                    |    9 ++++--
 arch/blackfin/kernel/setup.c                       |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |    1 +
 arch/blackfin/mach-bf538/boards/ezkit.c            |    1 -
 .../mach-bf609/include/mach/cdefBF60x_base.h       |    2 ++
 14 files changed, 101 insertions(+), 24 deletions(-)

