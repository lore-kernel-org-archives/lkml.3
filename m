Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbbAPSim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:38:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbbAPSik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:38:40 -0500
Date: Fri, 16 Jan 2015 10:38:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.29
Message-ID: <20150116183839.GA15210@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.29 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/ramoops.txt                     |   13 +++-
 Makefile                                      |    2=20
 arch/arm/boot/dts/dra7.dtsi                   |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts        |    4 -
 arch/arm/boot/dts/s3c64xx.dtsi                |    1=20
 arch/arm/configs/multi_v7_defconfig           |    1=20
 arch/arm/kernel/setup.c                       |    9 ++
 arch/arm/kernel/smp.c                         |   13 +++-
 arch/arm/mach-mvebu/coherency.c               |   26 ++++++++
 arch/arm/mach-omap2/pm44xx.c                  |   29 ++-------
 arch/arm64/include/asm/suspend.h              |    1=20
 arch/arm64/kernel/sleep.S                     |   83 ++++++++++++---------=
-----
 arch/arm64/kernel/suspend.c                   |   68 ++++++++++++++-------
 arch/powerpc/kernel/mce_power.c               |    4 -
 arch/powerpc/kernel/udbg_16550.c              |    6 +
 arch/x86/include/asm/vsyscall.h               |    2=20
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   22 +++++-
 arch/x86/kvm/mmu.c                            |    2=20
 arch/x86/vdso/vma.c                           |   43 +++++++++----
 block/blk-mq-cpumap.c                         |    2=20
 block/genhd.c                                 |   11 ++-
 drivers/acpi/device_pm.c                      |    2=20
 drivers/acpi/scan.c                           |   13 ++--
 drivers/base/bus.c                            |    8 +-
 drivers/hid/hid-core.c                        |    1=20
 drivers/hid/hid-ids.h                         |    1=20
 drivers/hid/hid-input.c                       |    3=20
 drivers/hid/hid-kye.c                         |    4 +
 drivers/hid/hid-roccat-pyra.c                 |    8 +-
 drivers/hid/i2c-hid/i2c-hid.c                 |   14 ++--
 drivers/hid/usbhid/hid-quirks.c               |    1=20
 drivers/hv/channel_mgmt.c                     |   11 ++-
 drivers/iommu/intel-iommu.c                   |    8 --
 drivers/misc/genwqe/card_utils.c              |    2=20
 drivers/mmc/host/sdhci.c                      |    8 +-
 drivers/mtd/tests/torturetest.c               |    4 -
 drivers/mtd/ubi/upd.c                         |   10 +--
 drivers/mtd/ubi/wl.c                          |   10 ---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  |   17 +++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   |    3=20
 drivers/net/wireless/ath/ath5k/qcu.c          |    8 --
 drivers/net/wireless/ath/ath9k/hw.h           |    4 -
 drivers/net/wireless/ath/ath9k/mac.c          |    9 --
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |    2=20
 drivers/pci/probe.c                           |    3=20
 drivers/rtc/rtc-isl12057.c                    |    4 -
 drivers/rtc/rtc-sirfsoc.c                     |   16 ++---
 drivers/spi/spi-fsl-spi.c                     |   20 ++++--
 drivers/tty/n_tty.c                           |    3=20
 drivers/tty/serial/samsung.c                  |    4 +
 drivers/usb/class/cdc-acm.c                   |   10 +--
 drivers/xen/swiotlb-xen.c                     |   10 +--
 fs/btrfs/delayed-inode.c                      |    8 ++
 fs/ceph/addr.c                                |    2=20
 fs/ceph/mds_client.c                          |   21 +++---
 fs/fs-writeback.c                             |   29 ++++++---
 fs/nfsd/nfs4state.c                           |   15 ++--
 fs/nfsd/nfs4xdr.c                             |    3=20
 fs/nilfs2/inode.c                             |   32 +++++++---
 fs/nilfs2/namei.c                             |   15 +++-
 fs/ocfs2/aops.c                               |   16 ++++-
 fs/ocfs2/namei.c                              |   43 ++++++++++---
 fs/pstore/ram.c                               |   13 +++-
 fs/pstore/ram_core.c                          |   31 ++++++---
 include/linux/mm.h                            |    2=20
 include/linux/pstore_ram.h                    |    4 -
 include/trace/events/sched.h                  |    2=20
 kernel/events/core.c                          |    4 -
 kernel/sched/deadline.c                       |   25 +------
 mm/memory.c                                   |    4 -
 mm/mmap.c                                     |    7 +-
 mm/vmscan.c                                   |   24 ++++---
 scripts/kernel-doc                            |    2=20
 sound/pci/hda/hda_codec.c                     |    4 -
 sound/pci/hda/patch_sigmatel.c                |    4 -
 sound/soc/codecs/max98090.c                   |    4 -
 sound/soc/codecs/sigmadsp.c                   |    7 ++
 sound/soc/dwc/designware_i2s.c                |   14 ++++
 sound/usb/mixer_maps.c                        |   15 +++-
 tools/perf/util/hist.h                        |    1=20
 tools/perf/util/session.c                     |    5 -
 81 files changed, 600 insertions(+), 321 deletions(-)

Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Andrew Jackson (1):
      ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Andy Lutomirski (2):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu

Anton Blanchard (1):
      powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Arnaud Ebalard (1):
      drivers/rtc/rtc-isl12057.c: fix masking of register values

Benjamin Coddington (1):
      nfsd4: fix xdr4 inclusion of escaped char

Brian Norris (1):
      mtd: tests: abort torturetest on erase errors

Chris Mason (1):
      Btrfs: don't delay inode ref updates during log replay

Christian Riesch (1):
      n_tty: Fix read_buf race condition, increment read_head after pushing=
 data

Dan Carpenter (3):
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
      ALSA: hda - using uninitialized data
      ceph: do_sync is never initialized

Emmanuel Grumbach (1):
      iwlwifi: mvm: update values for Smart Fifo

Felix Fietkau (3):
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment

Giedrius Statkevi=C4=8Dius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Greg Kroah-Hartman (2):
      USB: cdc-acm: check for valid interfaces
      Linux 3.14.29

Guo Zeng (1):
      drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in pro=
be

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Ian Abbott (1):
      misc: genwqe: check for error from get_user_pages_fast()

Jarkko Nikula (1):
      ASoC: max98090: Fix ill-defined sidetone route

Jean-Baptiste Maneyrol (1):
      HID: i2c-hid: fix race condition reading reports

Jens Axboe (2):
      blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map
      genhd: check for int overflow in disk_expand_part_tbl()

Jiang Liu (1):
      iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Jiri Jaburek (1):
      ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Jiri Olsa (3):
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group
      perf session: Do not fail on processing out of order event

Johannes Berg (1):
      scripts/kernel-doc: don't eat struct members with __aligned

Junxiao Bi (1):
      ocfs2: fix journal commit deadlock

Karl Relton (1):
      HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO =
keyboard

Krzysztof Kozlowski (1):
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Refuse to load firmware files with a non-supported ve=
rsion

Laura Abbott (1):
      arm64: Move cpu_resume into the text section

Linus Torvalds (2):
      mm: propagate error from stack expansion even for guard page
      mm: Don't count the stack guard page towards RLIMIT_STACK

Lokesh Vutla (1):
      ARM: dts: DRA7: wdt: Fix compatible property for watchdog node

Lorenzo Pieralisi (3):
      arm64: kernel: add missing __init section marker to cpu_suspend_init
      arm64: kernel: refactor the CPU suspend API for retention states
      arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Luca Abeni (2):
      sched/deadline: Fix migration of SCHED_DEADLINE tasks
      sched/deadline: Avoid double-accounting in case of missed deadlines

Mahesh Salgaonkar (1):
      powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Myron Stowe (1):
      PCI: Restore detection of read-only BARs

Nishanth Menon (1):
      ARM: OMAP4: PM: Only do static dependency configuration in omap4_init=
_static_deps

Oliver Neukum (1):
      cdc-acm: memory leak in error case

Paolo Bonzini (1):
      kvm: x86: drop severity of "generation wraparound" message

Pavel Machek (1):
      Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/=
cpuinfo"

Rafael J. Wysocki (1):
      ACPI / PM: Fix PM initialization for devices that are not present

Rasmus Villemoes (1):
      fs: nfsd: Fix signedness bug in compare_blob

Richard Weinberger (2):
      UBI: Fix invalid vfree()
      UBI: Fix double free after do_sync_erase()

Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
      serial: samsung: wait for transfer completion before clock disable

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Steev Klimaszewski (1):
      Add USB_EHCI_EXYNOS to multi_v7_defconfig

Stefan Roese (1):
      spi: fsl: Fix problem with multi message transfers

Stefano Stabellini (4):
      swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_sin=
gle_for_cpu
      swiotlb-xen: remove BUG_ON in xen_bus_to_phys
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean (2):
      can: peak_usb: fix cleanup sequence order in case of error during init
      can: peak_usb: fix memset() usage

Steven Rostedt (Red Hat) (1):
      tracing/sched: Check preempt_count() for current when reading task->s=
tate

Takashi Iwai (1):
      ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC c=
odecs

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

Thomas Petazzoni (1):
      ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370=
/375/38x/XP

Tomasz Figa (1):
      ARM: dts: Enable PWM node by default for s3c64xx

Tony Lindgren (1):
      pstore-ram: Allow optional mapping with pgprot_noncached

Vitaly Kuznetsov (1):
      Drivers: hv: vmbus: Fix a race condition when unregistering a device

Vlastimil Babka (1):
      mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled proce=
ss being killed

Xue jiufei (1):
      ocfs2: fix the wrong directory passed to ocfs2_lookup_ino_from_name()=
 when link file

Yan, Zheng (1):
      ceph: fix null pointer dereference in discard_cap_releases()


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuVqvAAoJEDjbvchgkmk+w7sP/0FiVLUssCVjYopOaCHpJICG
xnZhP/jlxrZ5RJo5Pp9EY1kyCAssqYpkzeJcDVWlQAyuErhUKgSputQMLVVx4KHq
y/95y5mzer9sL3gyu47bo+KFw51k6tQWonod0gFBb54f8Xz3HpSFl9c2ZOY8fmhE
zr/l8nGjLNvUkjoivv4ubOJ0pXCg7gPhibikRGAETepv4OzKtpxpgj+G93wIJwvU
R2MQx/PyAK1ktBwUAnQR0tYHE09qo8bzB7RPmZCW9dYkAu7YoFZ7OPGRt2UUqpcP
TQxoWZW62HVquki0IY0rPEIqWJVSk2f1ooXwKf3+TyGHPeXR2wg+xr4Nw7ZPAcEQ
27IKYnpS+gaC2s5ZEfntZxx+iEkK+Rpc7wWjnqdSrdO7eSWC72olynZ1KATCVWUo
YQH4IdONd0wTgTrmsRtFdYhVzQxv/0s8mloGRr9y+hMT2J6pfAfQdQgDQa+2EoFF
e6q1uAOynODikozbgw1NyvYFgpepb5q16X50b4Z8Ee4rDgDPuckeqSEFKdxmPJ1U
0/MJGCI1eBAwk0Um7zo8OT0AdG2KNAIL9uU6uSuzZqUICXsXraxOuNJd4HvJSsfb
2mweIhlueUwsKrADOsSrZa0kwenuWxVXpjxCOqptBbD4+qsBf4qEnbxHlMKd8fO1
wbmqEg4TnovNFMF2Z0TG
=Gv2a
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
