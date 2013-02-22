Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab3BVClV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:41:21 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33015
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736Ab3BVClT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:41:19 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zz936eIzz1f42h1ee6h1ce5h1202h1e76h1d1ah1cabh1d2ahzz8275dhz2ei87h2a8h668h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5hff4m129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <sonic.zhang@analog.com>, <vapier@gentoo.org>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] Blackfin updates for 3.9
Date: Fri, 22 Feb 2013 10:40:01 +0800
Message-ID: <1361500801-17793-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

  Linux 3.8 (2013-02-18 15:58:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lliubbo/blackfin.git for-linus

for you to fetch changes up to f656c240ae07c48ddf8552e83b64692121044c42:

  blackfin: time-ts: Remove duplicate assignment (2013-02-20 15:21:23 +0800)

----------------------------------------------------------------
Akinobu Mita (1):
      blackfin: use bitmap library functions

Bob Liu (1):
      blackfin: mem_init: update dmc config register

Sonic Zhang (1):
      blackfin: sync data in blackfin write buffer

Stephen Boyd (1):
      blackfin: time-ts: Remove duplicate assignment

Steven Miao (1):
      blackfin: pm: fix build error

 arch/blackfin/include/asm/mem_init.h      |    2 +-
 arch/blackfin/include/asm/uaccess.h       |    1 +
 arch/blackfin/kernel/dma-mapping.c        |   23 +++++++----------------
 arch/blackfin/kernel/time-ts.c            |    6 ------
 arch/blackfin/mach-common/ints-priority.c |    4 ++++
 5 files changed, 13 insertions(+), 23 deletions(-)

