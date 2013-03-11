Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3CKAdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:33:09 -0400
Received: from nskntmtas03p.mx.bigpond.com ([61.9.168.143]:28720 "EHLO
	nskntmtas03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab3CKAdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:33:05 -0400
X-Authority-Analysis: v=2.0 cv=IccFqBWa c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=4QTP58DfdrcA:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=H5rnqBSDAAAA:8 a=YvqQfTbJdaQA:10 a=VwQbUJbxAAAA:8
 a=IYYmUH7pqeQlaqUY3QIA:9 a=tpHzvNDyw14p4wpd1xf5Bw==:117
Date: Mon, 11 Mar 2013 10:32:26 +1000
From: Greg Ungerer <gerg@uclinux.org>
Message-Id: <201303110032.r2B0WQXC024689@goober.accelcon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-m68k@vger.kernel.org>,
        <uclinux-dev@uclinux.org>, <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.9
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.

It contains a few small fixes for the non-MMU m68k platforms. Fixes some
compilation problems, some broken header definitions, removes an unused
config option and adds a name for the old 68000 CPU support.

Regards
Greg



The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

for you to fetch changes up to ef9240f482e691e13a2d27208f60d1f1f5503545:

  m68k: drop "select EMAC_INC" (2013-03-06 16:08:26 +1000)

----------------------------------------------------------------
Greg Ungerer (1):
      m68knommu: fix misnamed GPIO pin definition for ColdFire 528x CPU

Luis Alves (2):
      m68knommu: add CPU_NAME for 68000
      m68knommu: fix MC68328.h defines

Paul Bolle (1):
      m68k: drop "select EMAC_INC"

Thadeu Lima de Souza Cascardo (1):
      m68knommu: fix build when CPU is not coldfire

 arch/m68k/Kconfig.machine           |  1 -
 arch/m68k/include/asm/MC68328.h     | 10 +++++-----
 arch/m68k/kernel/setup_no.c         |  3 +++
 arch/m68k/mm/init.c                 |  2 +-
 arch/m68k/platform/coldfire/m528x.c |  2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)
