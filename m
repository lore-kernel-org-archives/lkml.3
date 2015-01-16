Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbbAPSjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:39:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbAPSjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:39:05 -0500
Date: Fri, 16 Jan 2015 10:39:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.18.3
Message-ID: <20150116183905.GA15290@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.18.3 kernel.

All users of the 3.18 kernel series must upgrade.

The updated 3.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.18.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/i2c/i2c-designware.txt |    4=20
 Documentation/ramoops.txt                                |   13 +-
 Makefile                                                 |    2=20
 arch/arm/boot/dts/am437x-sk-evm.dts                      |   15 +-
 arch/arm/boot/dts/dra7.dtsi                              |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts                   |    4=20
 arch/arm/boot/dts/s3c64xx.dtsi                           |    1=20
 arch/arm/configs/multi_v7_defconfig                      |    3=20
 arch/arm/configs/shmobile_defconfig                      |    2=20
 arch/arm/kernel/setup.c                                  |    9 +
 arch/arm/kernel/smp.c                                    |   13 +-
 arch/arm/mach-omap2/pm44xx.c                             |   29 +---
 arch/arm64/kernel/efi.c                                  |    2=20
 arch/arm64/kernel/setup.c                                |    1=20
 arch/arm64/kernel/sleep.S                                |   36 +-----
 arch/arm64/kernel/suspend.c                              |   18 ++-
 arch/powerpc/include/asm/reg.h                           |    2=20
 arch/powerpc/include/asm/syscall.h                       |    6 -
 arch/powerpc/kernel/idle_power7.S                        |   18 ++-
 arch/powerpc/kernel/mce_power.c                          |    4=20
 arch/powerpc/kernel/udbg_16550.c                         |    6 -
 arch/powerpc/perf/hv-24x7.c                              |   21 +--
 arch/s390/kvm/gaccess.c                                  |   20 ++-
 arch/s390/kvm/interrupt.c                                |    2=20
 arch/s390/kvm/priv.c                                     |    4=20
 arch/x86/crypto/Makefile                                 |    2=20
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S                  |   46 +++++--
 arch/x86/include/asm/vsyscall.h                          |    2=20
 arch/x86/kernel/cpu/perf_event_intel_uncore.c            |   22 +++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h            |    2=20
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c      |   17 ++
 arch/x86/kernel/xsave.c                                  |    1=20
 arch/x86/kvm/cpuid.c                                     |   11 +
 arch/x86/kvm/emulate.c                                   |    2=20
 arch/x86/kvm/mmu.c                                       |    2=20
 arch/x86/kvm/x86.c                                       |   90 ++++++++++=
+++--
 arch/x86/vdso/vma.c                                      |   45 ++++---
 arch/xtensa/include/asm/highmem.h                        |    2=20
 block/blk-core.c                                         |    3=20
 block/blk-mq-cpumap.c                                    |    2=20
 block/blk-mq-sysfs.c                                     |    9 -
 block/blk-mq-tag.c                                       |   17 +-
 block/blk-sysfs.c                                        |   12 --
 block/genhd.c                                            |   11 +
 drivers/acpi/device_pm.c                                 |    2=20
 drivers/acpi/scan.c                                      |   13 +-
 drivers/acpi/video.c                                     |   27 ++++
 drivers/base/bus.c                                       |    8 -
 drivers/block/drbd/drbd_req.c                            |    3=20
 drivers/bluetooth/ath3k.c                                |    2=20
 drivers/bluetooth/btusb.c                                |    1=20
 drivers/char/i8k.c                                       |    8 +
 drivers/gpu/drm/nouveau/core/core/event.c                |    4=20
 drivers/gpu/drm/nouveau/core/core/notify.c               |    2=20
 drivers/gpu/drm/nouveau/nouveau_ttm.c                    |    3=20
 drivers/hid/hid-core.c                                   |    1=20
 drivers/hid/hid-ids.h                                    |    2=20
 drivers/hid/hid-input.c                                  |    3=20
 drivers/hid/hid-kye.c                                    |    4=20
 drivers/hid/hid-roccat-pyra.c                            |    8 +
 drivers/hid/i2c-hid/i2c-hid.c                            |   19 +--
 drivers/hid/usbhid/hid-quirks.c                          |    2=20
 drivers/hid/wacom_sys.c                                  |    9 -
 drivers/hid/wacom_wac.c                                  |    1=20
 drivers/hv/channel_mgmt.c                                |   11 +
 drivers/input/mouse/alps.c                               |   56 +++++++--
 drivers/iommu/intel-iommu.c                              |   12 +-
 drivers/md/raid5.c                                       |    7 -
 drivers/misc/genwqe/card_utils.c                         |    2=20
 drivers/mmc/host/sdhci.c                                 |    8 +
 drivers/mtd/devices/m25p80.c                             |    6 -
 drivers/mtd/nand/omap2.c                                 |    7 -
 drivers/mtd/tests/torturetest.c                          |    4=20
 drivers/mtd/ubi/upd.c                                    |   10 +
 drivers/mtd/ubi/wl.c                                     |   10 -
 drivers/net/can/usb/peak_usb/pcan_usb_core.c             |   17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c              |    3=20
 drivers/net/wireless/ath/ath5k/qcu.c                     |    8 -
 drivers/net/wireless/ath/ath9k/hw.h                      |    4=20
 drivers/net/wireless/ath/ath9k/mac.c                     |    9 -
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c         |    9 +
 drivers/net/wireless/iwlwifi/dvm/commands.h              |   31 +++--
 drivers/net/wireless/iwlwifi/dvm/lib.c                   |   47 ++++---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                |    2=20
 drivers/net/wireless/iwlwifi/pcie/drv.c                  |    4=20
 drivers/pci/probe.c                                      |    3=20
 drivers/regulator/s2mps11.c                              |   19 ++-
 drivers/rtc/rtc-isl12057.c                               |    4=20
 drivers/rtc/rtc-omap.c                                   |   11 +
 drivers/rtc/rtc-sirfsoc.c                                |   16 +-
 drivers/spi/spi-sh-msiof.c                               |    5=20
 drivers/tty/n_tty.c                                      |    3=20
 drivers/tty/serial/men_z135_uart.c                       |    1=20
 drivers/tty/serial/samsung.c                             |    4=20
 drivers/usb/class/cdc-acm.c                              |   10 +
 drivers/usb/core/quirks.c                                |    3=20
 drivers/usb/gadget/udc/at91_udc.c                        |   44 +++++--
 drivers/usb/renesas_usbhs/mod_gadget.c                   |    3=20
 drivers/usb/serial/qcserial.c                            |   33 +++++
 drivers/xen/swiotlb-xen.c                                |   10 -
 fs/btrfs/delayed-inode.c                                 |    8 +
 fs/ceph/addr.c                                           |    2=20
 fs/fs-writeback.c                                        |   29 +++-
 fs/nfsd/nfs4state.c                                      |   17 +-
 fs/nfsd/nfs4xdr.c                                        |    5=20
 fs/nilfs2/inode.c                                        |   32 ++++-
 fs/nilfs2/namei.c                                        |   15 ++
 fs/ocfs2/aops.c                                          |   16 ++
 fs/ocfs2/namei.c                                         |   43 +++++--
 fs/pstore/ram.c                                          |   13 +-
 fs/pstore/ram_core.c                                     |   31 +++--
 fs/reiserfs/super.c                                      |    3=20
 include/linux/mm.h                                       |    2=20
 include/linux/pstore_ram.h                               |    4=20
 include/linux/writeback.h                                |    1=20
 include/net/mac80211.h                                   |    7 -
 include/trace/events/sched.h                             |    2=20
 include/uapi/linux/audit.h                               |    2=20
 include/uapi/linux/hyperv.h                              |    1=20
 kernel/events/core.c                                     |    4=20
 kernel/exit.c                                            |   12 +-
 kernel/sched/core.c                                      |    9 +
 kernel/sched/deadline.c                                  |   25 ----
 mm/memory.c                                              |   31 +++--
 mm/mmap.c                                                |    7 -
 mm/page-writeback.c                                      |   43 ++-----
 mm/vmscan.c                                              |   24 ++--
 net/bluetooth/6lowpan.c                                  |    8 -
 net/bluetooth/hci_conn.c                                 |    4=20
 net/bluetooth/hci_event.c                                |   18 ++-
 net/mac80211/key.c                                       |   12 +-
 net/sunrpc/xdr.c                                         |    6 -
 scripts/kernel-doc                                       |    2=20
 sound/firewire/fireworks/fireworks_transaction.c         |    2=20
 sound/pci/hda/hda_codec.c                                |    4=20
 sound/pci/hda/patch_hdmi.c                               |    2=20
 sound/pci/hda/patch_realtek.c                            |   15 ++
 sound/pci/hda/patch_sigmatel.c                           |    4=20
 sound/soc/codecs/max98090.c                              |    4=20
 sound/soc/codecs/pcm512x-i2c.c                           |    7 +
 sound/soc/codecs/sigmadsp.c                              |    7 +
 sound/soc/codecs/tlv320aic31xx.c                         |   13 +-
 sound/soc/dwc/designware_i2s.c                           |   14 ++
 sound/soc/fsl/eukrea-tlv320.c                            |    2=20
 sound/usb/caiaq/audio.c                                  |    2=20
 sound/usb/mixer_maps.c                                   |   15 ++
 tools/perf/util/event.h                                  |    1=20
 tools/perf/util/session.c                                |   11 -
 tools/testing/ktest/ktest.pl                             |    4=20
 149 files changed, 1094 insertions(+), 544 deletions(-)

Aaron Lu (2):
      ACPI / video: update the skip case for acpi_video_device_in_dod()
      ACPI / video: Add some Samsung models to disable_native_backlight list

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda

Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Alexander Aring (1):
      Bluetooth: 6lowpan: fix skb_unshare behaviour

Alison Chaiken (1):
      MTD: m25p80: fix inconsistency in m25p_ids compared to spi_nor_ids

Andi Kleen (1):
      perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

Andrew Jackson (1):
      ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Andy Lutomirski (3):
      x86_64, vdso: Fix the vdso address randomization algorithm
      x86, vdso: Use asm volatile in __getcpu
      sched: Add missing rcu protection to wake_up_all_idle_cpus

Anton Blanchard (1):
      powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Ard Biesheuvel (1):
      arm64/efi: add missing call to early_ioremap_reset()

Arnaud Ebalard (1):
      drivers/rtc/rtc-isl12057.c: fix masking of register values

Axel Lin (1):
      tty: serial: men_z135_uart: Add terminating entry for men_z135_ids

Bart Van Assche (3):
      blk-mq: Fix a use-after-free
      blk-mq: Avoid that __bt_get_word() wraps multiple times
      blk-mq: Fix a race between bt_clear_tag() and bt_get()

Benjamin Coddington (2):
      nfsd4: fix xdr4 inclusion of escaped char
      nfsd4: fix xdr4 count of server in fs_location4

Benjamin Tissoires (2):
      HID: wacom: re-add accidentally dropped Lenovo PID
      HID: wacom: fix freeze on open when autosuspend is on

Brian Norris (1):
      mtd: tests: abort torturetest on erase errors

Bruno Pr=C3=A9mont (1):
      drm/nouveau/nouveau: Do not BUG_ON(!spin_is_locked()) on UP

Chris Mason (1):
      Btrfs: don't delay inode ref updates during log replay

Christian Borntraeger (2):
      KVM: s390: flush CPU on load control
      KVM: s390: Fix ipte locking

Christian Riesch (1):
      n_tty: Fix read_buf race condition, increment read_head after pushing=
 data

Dan Carpenter (3):
      HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
      ALSA: hda - using uninitialized data
      ceph: do_sync is never initialized

Daniel Mack (1):
      ALSA: snd-usb-caiaq: fix stream count check

Dave Airlie (1):
      nouveau: bring back legacy mmap handler

Dmitry Tunin (1):
      Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Doug Anderson (1):
      i2c: designware: Fix falling time bindings doc

Emmanuel Grumbach (3):
      iwlwifi: dvm: fix flush support for old firmware
      iwlwifi: mvm: update values for Smart Fifo
      iwlwifi: add new device IDs for 3165

Felipe Balbi (1):
      ARM: dts: am437x-sk: fix lcd enable pin mux data

Felix Fietkau (3):
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment

Giedrius Statkevi=C4=8Dius (1):
      HID: Add a new id 0x501a for Genius MousePen i608X

Greg Kroah-Hartman (2):
      USB: cdc-acm: check for valid interfaces
      Linux 3.18.3

Guo Zeng (1):
      drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in pro=
be

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Hans de Goede (3):
      Input: alps - v7: ignore new packets
      Input: alps - v7: sometimes a single touch is reported in mt[1]
      Input: alps - v7: fix finger counting for > 2 fingers on clickpads

Hante Meuleman (1):
      brcmfmac: Fix ifidx for rx data by msgbuf.

Hisashi Nakamura (1):
      spi: sh-msiof: Add runtime PM lock in initializing

Ian Abbott (1):
      misc: genwqe: check for error from get_user_pages_fast()

J. Bruce Fields (1):
      rpc: fix xdr_truncate_encode to handle buffer ending on page boundary

Jarkko Nikula (1):
      ASoC: max98090: Fix ill-defined sidetone route

Jean-Baptiste Maneyrol (1):
      HID: i2c-hid: fix race condition reading reports

Jeff Layton (1):
      nfsd: fix fi_delegees leak when fi_had_conflict returns true

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

Jiri Slaby (1):
      reiserfs: destroy allocated commit workqueue

Joerg Roedel (1):
      iommu/vt-d: Fix dmar_domain leak in iommu_attach_device

Johan Hedberg (3):
      Bluetooth: Fix LE connection timeout deadlock
      Bluetooth: Fix check for direct advertising
      Bluetooth: Fix accepting connections when not using mgmt

Johan Hovold (2):
      rtc: omap: fix clock-source configuration
      rtc: omap: fix missing wakealarm attribute

Johannes Berg (2):
      scripts/kernel-doc: don't eat struct members with __aligned
      Revert "mac80211: Fix accounting of the tailroom-needed counter"

Johannes Weiner (1):
      mm: protect set_page_dirty() from ongoing truncation

Junxiao Bi (1):
      ocfs2: fix journal commit deadlock

Jyri Sarha (1):
      ASoC: tlv320aic31xx: Fix off by one error in the loop stucture.

Kailang Yang (3):
      ALSA: hda/realtek - New codec support for ALC298
      ALSA: hda/realtek - New codec support for ALC256
      ALSA: hda/realtek - Add new Dell desktop for ALC3234 headset mode

Karl Relton (1):
      HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO =
keyboard

Kazuya Mizuguchi (1):
      usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disabl=
e()

Krzysztof Kozlowski (2):
      regulator: s2mps11: Fix dw_mmc failure on Gear 2
      mmc: sdhci: Fix sleep in atomic after inserting SD card

Lars Ellenberg (1):
      drbd: merge_bvec_fn: properly remap bvm->bi_bdev

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

Lorenzo Pieralisi (1):
      arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Luca Abeni (2):
      sched/deadline: Fix migration of SCHED_DEADLINE tasks
      sched/deadline: Avoid double-accounting in case of missed deadlines

Mahesh Salgaonkar (1):
      powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Marcel Holtmann (2):
      Bluetooth: Clear LE white list when resetting controller
      Bluetooth: Fix controller configuration with HCI_QUIRK_INVALID_BDADDR

Martin Hauke (1):
      USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      crypto: aesni - fix "by8" variant for 128 bit keys

Max Filippov (1):
      xtensa: fix kmap_prot definition

Mika Westerberg (1):
      HID: i2c-hid: Do not free buffers in i2c_hid_stop()

Myron Stowe (1):
      PCI: Restore detection of read-only BARs

Nadav Amit (1):
      KVM: x86: em_ret_far overrides cpl

NeilBrown (1):
      md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtyin=
g wants.

Nishanth Menon (1):
      ARM: OMAP4: PM: Only do static dependency configuration in omap4_init=
_static_deps

Oleg Nesterov (1):
      exit: fix race between wait_consider_task() and wait_task_zombie()

Oliver Neukum (2):
      HID: yet another buggy ELAN touchscreen
      cdc-acm: memory leak in error case

Pali Roh=C3=A1r (1):
      i8k: Add support for Dell Latitude E6440

Paolo Bonzini (4):
      x86: export get_xsave_addr
      KVM: x86: support XSAVES usage in the host
      kvm: x86: mask out XSAVES
      kvm: x86: drop severity of "generation wraparound" message

Paul Mackerras (1):
      powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mo=
de

Pavel Machek (1):
      Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/=
cpuinfo"

Peter Rosin (1):
      ASoC: pcm512x: Trigger auto-increment of register addresses on i2c

Philipp Reisner (1):
      drbd: Fix state change in case of connection timeout

Rafael J. Wysocki (1):
      ACPI / PM: Fix PM initialization for devices that are not present

Rasmus Villemoes (1):
      fs: nfsd: Fix signedness bug in compare_blob

Richard Guy Briggs (1):
      powerpc: add little endian flag to syscall_get_arch()

Richard Weinberger (2):
      UBI: Fix invalid vfree()
      UBI: Fix double free after do_sync_erase()

Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
      serial: samsung: wait for transfer completion before clock disable

Roger Quadros (1):
      mtd: nand: omap: Fix NAND enumeration on 3430 LDP

Ronald Wahl (1):
      usb: gadget: at91_udc: move prepare clk into process context

Ryusuke Konishi (1):
      nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Steev Klimaszewski (1):
      Add USB_EHCI_EXYNOS to multi_v7_defconfig

Stefano Stabellini (4):
      swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_sin=
gle_for_cpu
      swiotlb-xen: remove BUG_ON in xen_bus_to_phys
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean (2):
      can: peak_usb: fix cleanup sequence order in case of error during init
      can: peak_usb: fix memset() usage

Steven Rostedt (Red Hat) (2):
      ktest: Fix make_min_config to handle new assign_configs call
      tracing/sched: Check preempt_count() for current when reading task->s=
tate

Takashi Iwai (3):
      ASoC: eukrea-tlv320: Fix of_node_put() call with uninitialized object
      blk-mq: Fix uninitialized kobject at CPU hotplugging
      ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC c=
odecs

Takashi Sakamoto (1):
      ALSA: fireworks: fix an endianness bug for transaction length

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

Thomas Huth (1):
      KVM: s390: Fix size of monitor-class number field

Tomasz Figa (1):
      ARM: dts: Enable PWM node by default for s3c64xx

Tomi Valkeinen (1):
      ARM: dts: am437x-sk-evm.dts: fix LCD timings

Tony Lindgren (1):
      pstore-ram: Allow optional mapping with pgprot_noncached

Vinson Lee (1):
      crypto: sha-mb - Add avx2_supported check.

Viresh Kumar (1):
      ARM: defconfigs: use CONFIG_CPUFREQ_DT

Vitaly Kuznetsov (2):
      Drivers: hv: vmbus: Fix a race condition when unregistering a device
      Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages

Vlastimil Babka (1):
      mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled proce=
ss being killed

Xue jiufei (1):
      ocfs2: fix the wrong directory passed to ocfs2_lookup_ino_from_name()=
 when link file

sukadev@linux.vnet.ibm.com (1):
      powerpc/perf/hv-24x7: Use per-cpu page buffer


--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuVrIAAoJEDjbvchgkmk+T70P/0juc6uFmJjGFJ9g8RVPOSWB
Lb0KAKHAE4mMN7shbuKQOLH5ZR4ear82L3kzPumcvenPwTjiGj1B95QpLF5LzEzU
VkhsxGfdJE9pmW1c8Aufo8vM+7qWroUXe1r26/FzBjMsGdHq8umCZuvT19TTi7Cg
+n6juOHKWFMaJ/pZK/g1P4sGPT3fnGGkne+ULSQGq7rPb65Ek3mcGRtFSP6iS4iE
kJsSAuZgEBwtSOtZ0oduv0bycJwx61VEfvTYmJatXvDpZUaP4P5rBSvqbcfUNiAh
Csjn0BXg9S3c3i4vkNSNcZjM6sI3UI0+F+m4za2Urkn5qi6VfnGxeUqbTeRGM648
DAp0xlW38svTGRnKx+EJR9wXKl4NnFsDbdo1/q8/Kj7yQuNOZdT0xl3Fss6hRyRu
FP93LW/zGgiH13Om2WT52j9M9ZWp6xKXZXoKx9My0bwWhZCyD2TxLQ05h+8gBhm+
+UuhGw56PAecqstvpF1Yhhs4KWHNTxlIzAnpI1smiy5q9innzKDEdQckTxDuG/35
Y3/YGZSE4CznqzRMM55crTmx+rxzUqyiYBRhvLYsRTWH4fIQh6569Eks6N4Vo3d1
4XhWy4/IQJh8HkfvLZNoLp7jqdo+dl8uGT/bGhMcVupVPY/RAO+RbhsXNPPsUk6a
Z7iKER537bTaspM/ymka
=1tUH
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
