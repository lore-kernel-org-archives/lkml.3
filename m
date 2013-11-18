Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3KRNcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:32:47 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:35953 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3KRNci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:32:38 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>
Subject: [GIT PULL] ARC changes part2 for 3.13-rc1
Thread-Topic: [GIT PULL] ARC changes part2 for 3.13-rc1
Thread-Index: Ac7kYp7iGN/nPSpGTyq7Hi1JDL+E2A==
Date: Mon, 18 Nov 2013 13:32:30 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751566DE@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
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

------------------------------>
The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-v3.13-rc1-part2

for you to fetch changes up to cd5dfd0e1685530cb3159dec2d2a95421104093d:

  ARC: [plat-arcfpga] Add defconfig without initramfs location (2013-11-15
10:53:22 +0530)

----------------------------------------------------------------
Final set of ARC changes for 3.13-rc1

* Support for Perf from Mischa
* Enabling GPIO/Pinctrl drivers for Abilis TB10x platform
* New defconfig for buildroot

----------------------------------------------------------------
Christian Ruppert (1):
      ARC: [TB10x] Updates for GPIO and pinctrl

Mischa Jonker (4):
      ARC: Add perf support for ARC700 cores
      ARC: Add documentation on DT binding for ARC700 PMU
      ARC: perf: ARC 700 PMU doesn't support sampling events
      ARC: [plat-arcfpga] Add defconfig without initramfs location

 Documentation/devicetree/bindings/arc/pmu.txt |  24 ++
 arch/arc/boot/dts/abilis_tb100.dtsi           | 172 +++++++-------
 arch/arc/boot/dts/abilis_tb100_dvk.dts        |  24 +-
 arch/arc/boot/dts/abilis_tb101.dtsi           | 178 +++++++-------
 arch/arc/boot/dts/abilis_tb101_dvk.dts        |  24 +-
 arch/arc/boot/dts/abilis_tb10x.dtsi           |   3 +-
 arch/arc/boot/dts/angel4.dts                  |   4 +
 arch/arc/configs/fpga_noramfs_defconfig       |  64 +++++
 arch/arc/include/asm/perf_event.h             | 204 +++++++++++++++-
 arch/arc/kernel/Makefile                      |   1 +
 arch/arc/kernel/perf_event.c                  | 326 ++++++++++++++++++++++++++
 arch/arc/plat-tb10x/Kconfig                   |   2 +
 12 files changed, 838 insertions(+), 188 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arc/pmu.txt
 create mode 100644 arch/arc/configs/fpga_noramfs_defconfig
 create mode 100644 arch/arc/kernel/perf_event.c
