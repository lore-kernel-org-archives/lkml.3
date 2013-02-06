Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3BFO1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:27:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab3BFO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:27:50 -0500
Message-ID: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.38
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 06 Feb 2013 14:27:43 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9oaTnvjkeyBkCP1JXvAn"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9oaTnvjkeyBkCP1JXvAn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.38 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                           |    2 +-
 arch/arm/kernel/head.S                             |    3 +
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h        |    3 +
 arch/arm/mach-pxa/pxa27x.c                         |    4 +-
 arch/arm/mm/dma-mapping.c                          |   18 +--
 arch/arm/vfp/entry.S                               |    6 +-
 arch/arm/vfp/vfphw.S                               |    4 +-
 arch/powerpc/kvm/emulate.c                         |    2 +
 arch/s390/include/asm/timex.h                      |   28 +++++
 arch/s390/kernel/time.c                            |    2 +-
 arch/s390/kvm/interrupt.c                          |    2 +-
 arch/sh/include/asm/elf.h                          |    4 +-
 arch/x86/include/asm/efi.h                         |    1 +
 arch/x86/include/asm/traps.h                       |   25 ++++
 arch/x86/kernel/entry_32.S                         |    1 -
 arch/x86/kernel/irqinit.c                          |    2 +-
 arch/x86/kernel/msr.c                              |    3 +
 arch/x86/kernel/reboot.c                           |    2 +-
 arch/x86/kernel/setup.c                            |  103 +++++++++++++++-=
-
 arch/x86/kernel/traps.c                            |  120 +++++++++++-----=
----
 arch/x86/platform/efi/efi.c                        |   38 ++++++-
 arch/x86/platform/efi/efi_64.c                     |   22 +++-
 drivers/acpi/osl.c                                 |    2 +-
 drivers/acpi/processor_idle.c                      |    4 +
 drivers/ata/ahci.c                                 |    5 +-
 drivers/block/drbd/drbd_req.c                      |    1 +
 drivers/block/virtio_blk.c                         |    7 +-
 drivers/dma/ioat/dma_v3.c                          |    2 +-
 drivers/edac/edac_pci_sysfs.c                      |    2 +-
 drivers/firmware/dmi_scan.c                        |   80 ++++++++++---
 drivers/firmware/efivars.c                         |    4 +-
 drivers/firmware/iscsi_ibft_find.c                 |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +
 drivers/gpu/drm/i915/i915_gem.c                    |    7 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c         |   21 ++++
 drivers/gpu/drm/i915/i915_reg.h                    |    6 +-
 drivers/gpu/drm/i915/intel_display.c               |    4 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    8 --
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   23 +++-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    2 +
 drivers/gpu/drm/radeon/radeon_device.c             |    3 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c    |    8 ++
 drivers/idle/intel_idle.c                          |    7 +-
 drivers/iommu/amd_iommu_init.c                     |   34 ++++++
 drivers/iommu/intel-iommu.c                        |   52 ++++++++-
 drivers/net/can/c_can/c_can.c                      |    4 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/ti_hecc.c                          |    4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   22 +++-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   29 ++---
 drivers/net/wireless/ath/ath9k/beacon.c            |    1 +
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 +
 drivers/net/wireless/ath/ath9k/hw.h                |    1 +
 drivers/net/wireless/ath/ath9k/recv.c              |   10 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 +-
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   29 +++--
 drivers/pci/hotplug/pciehp.h                       |    3 +-
 drivers/pci/hotplug/pciehp_core.c                  |   20 +---
 drivers/pci/hotplug/pciehp_ctrl.c                  |    8 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   12 +-
 drivers/pci/hotplug/shpchp.h                       |    3 +-
 drivers/pci/hotplug/shpchp_core.c                  |   36 +++---
 drivers/pci/hotplug/shpchp_ctrl.c                  |    6 +-
 drivers/pci/pcie/aer/aerdrv_core.c                 |    1 +
 drivers/pci/pcie/aspm.c                            |    3 +
 drivers/platform/x86/ibm_rtl.c                     |    2 +-
 drivers/platform/x86/samsung-laptop.c              |    4 +
 drivers/regulator/max8997.c                        |   36 +++---
 drivers/regulator/max8998.c                        |    2 +-
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/scsi/sd.c                                  |   13 ++-
 drivers/staging/comedi/Kconfig                     |    1 +
 drivers/staging/comedi/comedi_fops.c               |   18 +++
 drivers/staging/comedi/comedidev.h                 |    1 +
 drivers/staging/comedi/drivers.c                   |   34 ++----
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   14 +--
 drivers/staging/comedi/internal.h                  |    1 +
 drivers/staging/rtl8712/usb_intf.c                 |    2 +
 drivers/staging/speakup/synth.c                    |    4 +-
 drivers/staging/usbip/usbip_common.c               |   11 +-
 drivers/staging/usbip/usbip_common.h               |    2 +-
 drivers/staging/usbip/vhci_rx.c                    |    3 +-
 drivers/staging/vt6656/bssdb.h                     |    1 -
 drivers/staging/vt6656/int.h                       |    1 -
 drivers/staging/vt6656/iocmd.h                     |   33 +++---
 drivers/staging/vt6656/iowpa.h                     |    8 +-
 drivers/target/target_core_transport.c             |    2 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   12 +-
 drivers/tty/serial/8250.c                          |   11 ++
 drivers/tty/serial/8250.h                          |    1 +
 drivers/tty/serial/8250_dw.c                       |    2 +-
 drivers/tty/serial/8250_pci.c                      |   38 +++++++
 drivers/tty/serial/ifx6x60.c                       |    1 +
 drivers/usb/class/cdc-acm.c                        |    3 +
 drivers/usb/core/hub.c                             |  120 ++++++++++++++++=
----
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/gadget.c                          |    1 +
 drivers/usb/gadget/dummy_hcd.c                     |    9 +-
 drivers/usb/host/uhci-hcd.c                        |   15 ++-
 drivers/usb/host/xhci-hub.c                        |   38 ++++++-
 drivers/usb/host/xhci-mem.c                        |    2 +
 drivers/usb/host/xhci-ring.c                       |    9 ++
 drivers/usb/host/xhci.c                            |   10 ++
 drivers/usb/musb/musb_core.c                       |    5 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    6 +
 drivers/usb/serial/io_ti.c                         |    3 +
 drivers/usb/serial/option.c                        |   27 ++++-
 fs/cifs/cifs_dfs_ref.c                             |    2 +
 fs/nfs/namespace.c                                 |   20 ++++
 fs/nfs/nfs4state.c                                 |   14 ++-
 fs/xfs/xfs_aops.c                                  |    2 +-
 include/linux/efi.h                                |   23 +++-
 include/linux/serial_core.h                        |    3 +-
 include/linux/syslog.h                             |    6 +
 init/main.c                                        |    2 +-
 kernel/printk.c                                    |   13 ++-
 kernel/smp.c                                       |   13 ++-
 kernel/trace/ftrace.c                              |    2 +-
 mm/compaction.c                                    |    6 +-
 mm/page_alloc.c                                    |    2 +-
 net/bluetooth/hidp/core.c                          |    2 +-
 net/mac80211/sta_info.c                            |    2 +-
 net/sunrpc/sched.c                                 |    3 +-
 net/sunrpc/xprt.c                                  |   12 +-
 security/integrity/evm/evm_crypto.c                |    4 +-
 sound/arm/pxa2xx-ac97-lib.c                        |   26 ++++-
 sound/pci/hda/hda_intel.c                          |   40 ++++---
 sound/pci/hda/patch_conexant.c                     |   34 +++---
 sound/soc/codecs/wm2000.c                          |    4 +-
 sound/soc/codecs/wm5100.c                          |    6 -
 sound/usb/endpoint.c                               |    6 +-
 sound/usb/mixer.c                                  |   17 ++-
 sound/usb/quirks.c                                 |    8 +-
 137 files changed, 1195 insertions(+), 480 deletions(-)

Alan Cox (2):
      x86/msr: Add capabilities check
      ahci: Add identifiers for ASM106x devices

Alan Stern (1):
      USB: UHCI: fix IRQ race during initialization

Alexander Graf (2):
      virtio-blk: Don't free ida when disk is in use
      KVM: PPC: Emulate dcbf

Alexandre SIMON (1):
      printk: fix buffer overflow when calling log_prefix function from cal=
l_console_drivers

Amitkumar Karwar (1):
      mwifiex: handle association failure case correctly

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Andrew Cooper (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS gu=
ests.

Avinash Patil (1):
      mwifiex: fix typo in PCIe adapter NULL check

Axel Lin (2):
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_=
buck_time_sel

Bart Westgeest (1):
      staging: usbip: changed function return type to void

Ben Hutchings (2):
      staging: vt6656: Fix inconsistent structure packing
      Linux 3.2.38

Betty Dall (1):
      PCI/AER: pci_get_domain_bus_and_slot() call missing required pci_dev_=
put()

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value

Bjorn Helgaas (2):
      PCI: shpchp: Handle push button event asynchronously
      PCI: shpchp: Use per-slot workqueues to avoid deadlock

Bj=C3=B8rn Mork (4):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II
      USB: option: blacklist network interface on ONDA MT8205 4G LTE
      USB: option: add TP-LINK HSUPA Modem MA180

Chris Wilson (4):
      drm/i915; Only increment the user-pin-count after successfully pinnin=
g the bo
      drm/i915: Invalidate the relocation presumed_offsets along the slow p=
ath
      drm/i915: Disable AsyncFlip performance optimisations
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline=
 waits

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 dev=
ices

Colin Ian King (1):
      PCI: Allow pcie_aspm=3Dforce even when FADT indicates it is unsupport=
ed

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function

Daniel Vetter (4):
      iommu/intel: disable DMAR for g4x integrated gfx
      drm/i915: dump UTS_RELEASE into the error_state
      drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

David Henningsson (2):
      Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat c=
odecs"
      ALSA: usb - fix race in creation of M-Audio Fast track pro driver

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dmitry Kasatkin (1):
      evm: checking if removexattr is not a NULL

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Eric Anholt (2):
      drm/i915: Remove the MI_FLUSH_ENABLE setting.
      drm/i915: Correct the bit number for the MI_FLUSH_ENABLE.

Felix Fietkau (4):
      ath9k: do not link receive buffers during flush
      ath9k: fix double-free bug on beacon generate failure
      ath9k_hw: fix calibration issues on chainmask that don't include chai=
n 0
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5

H. Peter Anvin (2):
      x86/Sandy Bridge: mark arrays in __init functions as __initconst
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Hannes Reinecke (1):
      target: use correct sense code for LUN communication failure

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Ian Abbott (3):
      staging: comedi: comedi_test: fix race when cancelling command
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
      staging: comedi: don't hijack hardware device private data

Ilija Hadzic (1):
      drm/radeon: fix a rare case of double kfree

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jerome Glisse (1):
      radeon/kms: force rn50 chip to always report connected on analog outp=
ut

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Joel D. Diaz (1):
      sd: Reshuffle init_sd to avoid crash

Johannes Berg (1):
      mac80211: use del_timer_sync for final sta cleanup timer deletion

Kees Cook (1):
      x86: Use enum instead of literals for trap values

Kenji Kaneshige (2):
      PCI: pciehp: Fix wrong workqueue cleanup
      PCI: pciehp: Handle push button event asynchronously

Konrad Rzeszutek Wilk (2):
      intel_idle: Don't register CPU notifier if we are not running.
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Larry Finger (1):
      staging: r8712u: Add new device ID

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

Mark Brown (2):
      ASoC: wm5100: Remove DSP B and left justified formats
      ASoC: wm2000: Fix sense of speech clarity enable

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Matt Fleming (3):
      efi: Make 'efi_enabled' a function to query EFI facilities
      samsung-laptop: Disable on EFI hardware
      x86, efi: Set runtime_version to the EFI spec revision

Maxime Ripard (1):
      tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
      ALSA: pxa27x: fix ac97 warm reset

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()

Nicolas Pitre (1):
      ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Philipp Reisner (1):
      drbd: add missing part_round_stats to _drbd_start_io_acct

Piotr Haber (1):
      brcmsmac: increase timer reference count for new timers only

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with =
sparsemem

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Sarah Sharp (8):
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.
      USB: Handle auto-transition from hot to warm reset.
      USB: Ignore xHCI Reset Device status.
      USB: Allow USB 3.0 ports to be disabled.
      USB: Increase reset timeout.
      USB: Ignore port state until reset completes.
      USB: Handle warm reset failure on empty port.
      xhci: Avoid "dead ports", add roothub port polling.

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Shuah Khan (1):
      ioat: Fix DMA memory sync direction correct flag

Stefan Assmann (1):
      igb: release already assigned MSI-X interrupts if setup fails

Stephen Boyd (1):
      ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alon=
e

Stephen Hurd (1):
      8250/16?50: Add support for Broadcom TruManage redirected serial port

Steven Rostedt (1):
      ftrace: Be first to run code modification on modules

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

Takashi Iwai (5):
      ALSA: hda - Add Conexant CX20751/2/3/4 codec support
      ALSA: hda/conexant - Correct vendor IDs for new codecs
      ALSA: hda - Add Conexant CX20755/20756/20757 codec IDs
      ALSA: hda - Fix non-snoop page handling
      ALSA: usb-audio: Fix regression by disconnection-race-fix patch

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Dom=
ain

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Trond Myklebust (3):
      SUNRPC: Ensure we release the socket write lock if the rpc_task exits=
 early
      NFS: Don't silently fail setattr() requests on mountpoints
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race

Wolfgang Frisch (1):
      USB: io_ti: Fix NULL dereference in chase_port()

Yijing Wang (1):
      PCI: pciehp: Use per-slot workqueues to avoid deadlock

Zhenzhong Duan (2):
      drivers/firmware/dmi_scan.c: check dmi version when get system uuid
      drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exis=
ts

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port

=C3=89ric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x



--=-9oaTnvjkeyBkCP1JXvAn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURJoX+e/yOyVhhEJAQoFYRAAxtx7TMQhJzYqEcO262D9xwn97NM8HIsK
NRetF+erQ1Xp+2Rv/KFycHPfEwCtuGDuF1B4Guz8znN1bzxk8MZW0taxpceiUJkt
2URi+p86YOQ/tjLMpo9V7BrfNmgx0+4sGUawJnXnqluZU9O8tIrccZlu//wi19RB
p6IgKDfvyNrj9S6lHD1s+xGWQY/W1PMratozDj/pxLxVib5A1SN6oYVLSqNzcG7V
55eMhrSt0783so12RiWuI94NobYARSar9O/vrCfjEjEz0MxtsPXEF4O08eflkud5
C7n2Ru+sE0RohTD9vfNT9DeCRNE+1aitLz16jg2ecHZBvmtKQQn45NxAVuqXwu1k
rIWqQFIgSq9m6JH6rpXpOTwgaYj5pEWhtkLVsVHjkLXcDoSeoqz2bTtqXQlpopb1
9GRHLNS+c9BlGH/Y6D59WMt0ObX5ouu1yop/3C6KHDWB9WWTo5WPf4SdWfx4ICpr
9+yH/aZE5jKItPE4NfHSpoE/9/Z67vEUjuo6Z/2edbk2k3nkNalI8Cpq6RpRq4O9
owBCplopU3ziTT/jJ5K1kMYIHsGPjgzpxw0Fswi2aZ90RC0mQ/25vRx2TQTWxI3N
kKLbYQ5nkpTUB3+cDdZDvebI2MduZr/zvZtmjPzGj+Ue2UEF/ame5hSbAudcFtJY
0tx8Vxk21wg=
=AHiH
-----END PGP SIGNATURE-----

--=-9oaTnvjkeyBkCP1JXvAn--
