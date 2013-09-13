Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3IMFKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:10:20 -0400
Received: from [216.32.181.182] ([216.32.181.182]:10182 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab3IMFKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:10:17 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz936eIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz17326ah1de097h186068h8275dhz2dh87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@kernel.org>
To: <torvalds@linux-foundation.org>
CC: <adi-buildroot-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.12
Date: Fri, 13 Sep 2013 13:12:25 +0800
Message-ID: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin updates for Linux 3.12, some minor bug fixes.

The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to 08b67faa23fdd4df3f3f7bb06f0ad67b7366d11c:

  blackfin: Ignore generated uImages (2013-09-13 10:42:39 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.12

----------------------------------------------------------------
Mark Brown (1):
      blackfin: Ignore generated uImages

Scott Jiang (2):
      bf609: add adv7343 video encoder support
      bf609: adv7343: add S-Video and Component output support

Sonic Zhang (2):
      blackfin: scb: Add SCB1 to SCB9 config options and data.
      blackfin: Add STMMAC platform data to enable dwmac1000 driver on BF60x.

Steven Miao (2):
      blackfin: scb: Add system crossbar init code.
      clock: add stmmac clock for ethernet driver

 arch/blackfin/boot/.gitignore                      |    1 +
 arch/blackfin/include/asm/scb.h                    |   21 +
 arch/blackfin/kernel/setup.c                       |    6 +
 arch/blackfin/mach-bf609/Kconfig                   | 1655 ++++++++++++++++++++
 arch/blackfin/mach-bf609/Makefile                  |    1 +
 arch/blackfin/mach-bf609/boards/ezkit.c            |   91 ++
 arch/blackfin/mach-bf609/clock.c                   |   17 +
 .../mach-bf609/include/mach/defBF60x_base.h        |   10 +
 arch/blackfin/mach-bf609/scb.c                     |  363 +++++
 arch/blackfin/mach-common/Makefile                 |    1 +
 arch/blackfin/mach-common/scb-init.c               |   53 +
 11 files changed, 2219 insertions(+)
 create mode 100644 arch/blackfin/include/asm/scb.h
 create mode 100644 arch/blackfin/mach-bf609/scb.c
 create mode 100644 arch/blackfin/mach-common/scb-init.c

