Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaIZBF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:05:27 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:57397 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaIZBFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:05:25 -0400
Message-ID: <5424BBBB.7000402@huawei.com>
Date: Fri, 26 Sep 2014 09:04:59 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: <lwn@lwn.net>
Subject: Linux 3.4.104 (Resend)
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.5424BBC1.005C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9feab1f0483d6f2b0b2699ba0c56ff82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Some copy&paste mistake in my previous email...)

I'm announcing the release of the 3.4.104 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

----------------------------------------------------------------

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Andi Kleen (1):
      slab/mempolicy: always use local policy from interrupt context

Anton Blanchard (1):
      ibmveth: Fix endian issues with rx_no_buffer statistic

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

Fengguang Wu (1):
      unicore32: select generic atomic64_t support

Florian Fainelli (1):
      MIPS: perf: Fix build error caused by unused counters_per_cpu_to_total()

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Guan Xuetao (2):
      UniCore32-bugfix: Remove definitions in asm/bug.h to solve difference between native and cross compiler
      UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer

Hans de Goede (1):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (2):
      isofs: Fix unbounded recursion when processing relocated directories
      ext2: Fix fs corruption in ext2_get_xip_mem()

Jaša Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device

Jiri Kosina (4):
      HID: fix a couple of off-by-ones
      HID: logitech: perform bounds checking on device_id early enough
      HID: magicmouse: sanity check report size in raw_event() callback
      HID: picolcd: sanity check report size in raw_event() callback

Joerg Roedel (1):
      iommu/amd: Fix cleanup_domain for mass device removal

Johan Hovold (3):
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow

Mark Einon (1):
      staging: et131x: Fix errors caused by phydev->addr accesses before initialisation

Mark Rutland (2):
      ARM: 8128/1: abort: don't clear the exclusive monitors
      ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dummy strex

Max Filippov (3):
      xtensa: replace IOCTL code definitions with constants
      xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
      xtensa: fix a6 and a7 handling in fast_syscall_xtensa

Michael Cree (2):
      alpha: Fix fall-out from disintegrating asm/system.h
      alpha: add io{read,write}{16,32}be functions

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

NeilBrown (1):
      md/raid6: avoid data corruption during recovery of double-degraded RAID6

Paul Gortmaker (1):
      8250_pci: fix warnings in backport of Broadcom TruManage support

Pavel Shilovsky (1):
      CIFS: Fix wrong directory attributes after rename

Ralf Baechle (1):
      MIPS: Fix accessing to per-cpu data when flushing the cache

Stefan Kristiansson (1):
      openrisc: add missing header inclusion

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Trond Myklebust (1):
      NFSv4: Fix problems with close in the presence of a delegation

Zefan Li (1):
      Linux 3.4.104

 Documentation/stable_kernel_rules.txt |    3 ++
 Makefile                              |    2 +-
 arch/alpha/include/asm/io.h           |    5 +++
 arch/alpha/oprofile/common.c          |    1 +
 arch/arm/kernel/entry-header.S        |   29 ++++++------
 arch/arm/mm/abort-ev6.S               |    6 ---
 arch/arm/mm/abort-ev7.S               |    6 ---
 arch/mips/cavium-octeon/setup.c       |   18 +++++---
 arch/mips/kernel/perf_event_mipsxx.c  |    5 ---
 arch/mips/mm/c-r4k.c                  |    5 +++
 arch/openrisc/kernel/head.S           |    1 +
 arch/unicore32/Kconfig                |    1 +
 arch/unicore32/include/asm/bug.h      |    5 ---
 arch/unicore32/include/asm/cmpxchg.h  |    2 +-
 arch/unicore32/kernel/setup.h         |    6 +++
 arch/xtensa/include/asm/ioctls.h      |   19 ++++----
 arch/xtensa/include/asm/pgtable.h     |    7 ++-
 arch/xtensa/kernel/entry.S            |   14 +++---
 arch/xtensa/kernel/pci-dma.c          |   12 ++---
 drivers/ata/pata_scc.c                |   15 +++----
 drivers/hid/hid-cherry.c              |    2 +-
 drivers/hid/hid-kye.c                 |    2 +-
 drivers/hid/hid-lg.c                  |    4 +-
 drivers/hid/hid-logitech-dj.c         |   54 +++++++++++++----------
 drivers/hid/hid-logitech-dj.h         |    1 +
 drivers/hid/hid-magicmouse.c          |   10 +++++
 drivers/hid/hid-monterey.c            |    2 +-
 drivers/hid/hid-petalynx.c            |    2 +-
 drivers/hid/hid-picolcd.c             |    6 +++
 drivers/hid/hid-sunplus.c             |    2 +-
 drivers/iommu/amd_iommu.c             |   10 +++--
 drivers/md/raid5.c                    |    2 +
 drivers/net/ethernet/ibm/ibmveth.c    |   18 ++++++--
 drivers/staging/et131x/et131x.c       |   78 ++++++++++++++-------------------
 drivers/tty/serial/8250/8250_pci.c    |    6 +--
 drivers/usb/host/xhci-pci.c           |    4 ++
 drivers/usb/host/xhci-ring.c          |    3 +-
 drivers/usb/misc/sisusbvga/sisusb.c   |    1 +
 drivers/usb/serial/ftdi_sio.c         |    3 ++
 drivers/usb/serial/ftdi_sio_ids.h     |    7 +++
 drivers/usb/serial/option.c           |    5 +++
 drivers/usb/serial/pl2303.c           |    1 +
 drivers/usb/serial/pl2303.h           |    1 +
 drivers/usb/serial/usb-serial.c       |   35 ++++++++++-----
 drivers/usb/serial/whiteheat.c        |    7 ++-
 fs/cifs/inode.c                       |    6 +++
 fs/ext2/inode.c                       |    2 +
 fs/ext2/xip.c                         |    1 +
 fs/isofs/inode.c                      |   15 ++++---
 fs/isofs/isofs.h                      |   23 ++++++++--
 fs/isofs/rock.c                       |   39 ++++++++++++-----
 fs/nfs/nfs4proc.c                     |   17 ++++---
 include/linux/mempolicy.h             |    2 +-
 mm/mempolicy.c                        |    8 +++-
 mm/slab.c                             |    4 +-
 mm/slub.c                             |    2 +-
 sound/pci/hda/patch_realtek.c         |   17 ++++---
 sound/soc/pxa/pxa-ssp.c               |    4 +-
 virt/kvm/iommu.c                      |   19 ++++----
 59 files changed, 365 insertions(+), 222 deletions(-)

