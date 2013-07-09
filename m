Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3GIJNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:13:53 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:5337
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab3GIJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:13:50 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz936eIzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz17326ah8275dhz2dh87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@kernel.org>
To: <torvalds@linux-foundation.org>, <sfr@canb.auug.org.au>
CC: <uclinux-dist-devel@blackfin.uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.11
Date: Tue, 9 Jul 2013 17:15:30 +0800
Message-ID: <1373361330-3946-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus and Stephen,

I've signed up for an kernel.org account and moved the blackfin tree to kernel.org for convenience as some developers' suggestion. Pls update the url to:
http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git

Hi Linus,

please pull blackfin updates for Linux 3.11, some minor changes for performance and bug fixes.

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to 150382a53d11256e5666c86525c8bf8d23684532:

  smp: refine bf561 smpboot code (2013-07-09 15:50:38 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.11

----------------------------------------------------------------
Scott Jiang (1):
      bf609: rename bfin6xx_spi to bfin_spi3

Sonic Zhang (2):
      kgdb: blackfin: include irq_regs.h in kgdb.c
      bf609: add cpu revision 0.1

Steven Miao (2):
      bf609: stmmac: fix build after stmmac_mdio_bus_data changed
      smp: refine bf561 smpboot code

 arch/blackfin/Kconfig                              |    2 +-
 .../include/asm/{bfin6xx_spi.h => bfin_spi3.h}     |    4 ++--
 arch/blackfin/kernel/kgdb.c                        |    1 +
 arch/blackfin/mach-bf561/smp.c                     |    7 +++----
 arch/blackfin/mach-bf609/boards/ezkit.c            |   19 +++++++++----------
 arch/blackfin/mach-common/smp.c                    |   18 ++++++++----------
 6 files changed, 24 insertions(+), 27 deletions(-)
 rename arch/blackfin/include/asm/{bfin6xx_spi.h => bfin_spi3.h} (99%)

