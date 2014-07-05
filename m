Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaGEFeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:34:31 -0400
Received: from seketeli.net ([94.23.218.202]:45870 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaGEFe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:34:29 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Ralf Baechle <ralf@linux-mips.org>, Lars-Peter Clausen <lars@metafoo.de>,
        John Crispin <blogic@openwrt.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Rename NOP transceiver in JZ4740 platform data
Date: Sat,  5 Jul 2014 07:34:56 +0200
Message-Id: <1404538497-8381-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The name of the NOP transceiver driver was changed during v3.16
release cycle from usb_phy_gen_xceiv to usb_phy_generic.

The patch that comes as a follow up of this message renames
accordingly the NOP transceiver driver in JZ4740 platform data to fix
a subsequent kernel panic.

Please consider for merge in 3.16 if possible since it fixes an issue
that makes the Ben Nanonote unable to boot.

Changes were rebased on top of the linux-mips master branch, built and
tested successfully.

The following changes since commit bc0b9d9:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux-mips.git rename-jz4740-xceiv

Apelete Seketeli (1):
  mips: jz4740: rename usb_nop_xceiv to usb_phy_generic

 arch/mips/jz4740/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.7.10.4

