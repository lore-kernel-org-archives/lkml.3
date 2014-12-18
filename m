Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaLRL3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:29:07 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:34690 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLRL3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:29:05 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [GIT PULL] ARC Updates for 3.19-rc1
Thread-Topic: [GIT PULL] ARC Updates for 3.19-rc1
Thread-Index: AdAatdGV9g2wMOGuTXiQmb61sz7YOA==
Date: Thu, 18 Dec 2014 11:29:00 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BC8B4C@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull.

Thx,
-Vineet

------------->
he following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/ tags/arc-3.19-rc1

for you to fetch changes up to 7a70bf797a587205991b8e3153d764561de867de:

  ARC: rename default defconfig (2014-12-17 15:23:56 +0530)

----------------------------------------------------------------
Minor updates for ARC for 3.19

----------------------------------------------------------------
Alexey Brodkin (1):
      ARC: add power management options

Vineet Gupta (4):
      ARC: R-M-W assist locks only needed for !LLSC
      ARC: document memory clobber in irq control macros
      ARC: [nsimosci] move peripherals to match model to FPGA
      ARC: rename default defconfig

 arch/arc/Kconfig                                   |  1 +
 arch/arc/Makefile                                  |  2 +-
 arch/arc/boot/dts/nsimosci.dts                     | 18 +++----
 arch/arc/configs/fpga_noramfs_defconfig            | 63 ----------------------
 .../configs/{fpga_defconfig => nsim_700_defconfig} |  0
 arch/arc/include/asm/irqflags.h                    |  9 ++++
 arch/arc/kernel/smp.c                              |  2 +
 7 files changed, 22 insertions(+), 73 deletions(-)
 delete mode 100644 arch/arc/configs/fpga_noramfs_defconfig
 rename arch/arc/configs/{fpga_defconfig => nsim_700_defconfig} (100%)
