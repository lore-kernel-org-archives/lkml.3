Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3GJFgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:36:13 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:37062 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3GJFgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:36:11 -0400
Message-ID: <51DCF2BD.6080506@synopsys.com>
Date: Wed, 10 Jul 2013 11:05:57 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: [GIT PULL] arch/arc updates #2 for 3.11-rc1
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull.

Thx,
-Vineet

------------------>
The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-v3.11-rc1-part2

for you to fetch changes up to 723e2b801d803035ec7a7c0fe162a6c9fc118164:

  ARC: [TB10x] Updates for irqchip driver (2013-06-28 15:07:42 +0530)

----------------------------------------------------------------
Couple of Platform updates (Device Tree files primarily) given that the
corresponding drivers (net/ethernet/arc/*, irqctl/irq-tb10x.c) have now
been merged into your tree.

Ideally these shd have been part of same submissions, oh well...

----------------------------------------------------------------
Alexey Brodkin (1):
      ARC: [plat-arcfpga] Enable arc_emac for ARCAngle4 Board

Christian Ruppert (1):
      ARC: [TB10x] Updates for irqchip driver

 arch/arc/boot/dts/abilis_tb100.dtsi         | 32 +++++++++++++----------------
 arch/arc/boot/dts/abilis_tb101.dtsi         | 32 +++++++++++++----------------
 arch/arc/boot/dts/abilis_tb10x.dtsi         | 32 +++++++++++++----------------
 arch/arc/boot/dts/angel4.dts                | 16 +++++++++++++++
 arch/arc/configs/fpga_defconfig             |  3 +++
 arch/arc/plat-arcfpga/include/plat/irq.h    |  2 --
 arch/arc/plat-arcfpga/include/plat/memmap.h |  2 --
 arch/arc/plat-tb10x/Kconfig                 |  1 +
 8 files changed, 62 insertions(+), 58 deletions(-)
