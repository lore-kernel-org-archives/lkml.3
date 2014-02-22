Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBVWJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:09:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaBVWJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:09:35 -0500
Date: Sat, 22 Feb 2014 14:12:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.5
Message-ID: <20140222221218.GA664@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.5 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/mach-pxa/am300epd.c                      |    1=20
 arch/arm/mach-pxa/include/mach/balloon3.h         |    2=20
 arch/arm/mach-pxa/include/mach/corgi.h            |    1=20
 arch/arm/mach-pxa/include/mach/csb726.h           |    2=20
 arch/arm/mach-pxa/include/mach/gumstix.h          |    1=20
 arch/arm/mach-pxa/include/mach/idp.h              |    1=20
 arch/arm/mach-pxa/include/mach/palmld.h           |    2=20
 arch/arm/mach-pxa/include/mach/palmt5.h           |    2=20
 arch/arm/mach-pxa/include/mach/palmtc.h           |    2=20
 arch/arm/mach-pxa/include/mach/palmtx.h           |    2=20
 arch/arm/mach-pxa/include/mach/pcm027.h           |    2=20
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h |    1=20
 arch/arm/mach-pxa/include/mach/poodle.h           |    2=20
 arch/arm/mach-pxa/include/mach/spitz.h            |    2=20
 arch/arm/mach-pxa/include/mach/tosa.h             |    2=20
 arch/arm/mach-pxa/include/mach/trizeps4.h         |    2=20
 arch/powerpc/kernel/machine_kexec.c               |   14 ++-
 arch/powerpc/kernel/machine_kexec_64.c            |    6 -
 arch/s390/kernel/head64.S                         |    7 +
 arch/s390/mm/page-states.c                        |   10 ++
 arch/x86/include/asm/pgtable.h                    |   14 ++-
 arch/x86/kernel/cpu/common.c                      |    7 +
 arch/x86/kernel/ftrace.c                          |   83 +++++++++++------=
---
 arch/x86/mm/fault.c                               |   14 ++-
 arch/x86/xen/mmu.c                                |    4=20
 block/blk-lib.c                                   |    8 +
 block/blk.h                                       |    2=20
 drivers/block/xen-blkfront.c                      |    5 -
 drivers/char/raw.c                                |    2=20
 drivers/edac/edac_mc.c                            |   13 +--
 drivers/edac/edac_mc_sysfs.c                      |   10 +-
 drivers/edac/edac_module.h                        |    2=20
 drivers/gpu/drm/i915/i915_gpu_error.c             |    5 -
 drivers/gpu/drm/i915/i915_irq.c                   |    3=20
 drivers/gpu/drm/i915/intel_dp.c                   |   10 +-
 drivers/gpu/drm/radeon/cik_sdma.c                 |   43 +++++++---
 drivers/gpu/drm/radeon/r600.c                     |    4=20
 drivers/gpu/drm/radeon/si.c                       |    4=20
 drivers/hv/connection.c                           |   13 ---
 drivers/hwmon/ntc_thermistor.c                    |    6 -
 drivers/i2c/busses/i2c-mv64xxx.c                  |   33 +++-----
 drivers/iio/adc/max1363.c                         |    2=20
 drivers/iio/imu/adis16400.h                       |    1=20
 drivers/iio/imu/adis16400_core.c                  |   10 +-
 drivers/iio/magnetometer/ak8975.c                 |   16 ++-
 drivers/infiniband/hw/qib/qib_iba7322.c           |    5 +
 drivers/md/raid1.c                                |   13 ++-
 drivers/md/raid5.c                                |   90 ++++++++++-------=
-----
 drivers/misc/mei/client.c                         |   11 ++
 drivers/misc/mic/host/mic_virtio.c                |    3=20
 drivers/net/wireless/ath/ar5523/ar5523.c          |    2=20
 drivers/net/wireless/ath/ath9k/htc_drv_init.c     |    8 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c     |   25 +++---
 drivers/net/wireless/ath/ath9k/init.c             |    8 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c      |    5 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |    2=20
 drivers/net/wireless/iwlwifi/mvm/scan.c           |    3=20
 drivers/net/wireless/iwlwifi/mvm/utils.c          |    2=20
 drivers/net/wireless/iwlwifi/pcie/drv.c           |    7 +
 drivers/of/address.c                              |    5 -
 drivers/pci/hotplug/acpiphp_glue.c                |   15 +++
 drivers/power/max17040_battery.c                  |    5 -
 drivers/spi/spi-nuc900.c                          |    2=20
 drivers/spi/spi.c                                 |    4=20
 drivers/staging/comedi/drivers/adv_pci1710.c      |   17 ++--
 drivers/staging/iio/adc/ad799x_core.c             |    5 -
 drivers/staging/iio/impedance-analyzer/ad5933.c   |    2=20
 drivers/staging/lustre/lustre/llite/dir.c         |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c       |    2=20
 drivers/target/target_core_pr.c                   |   11 +-
 drivers/tty/n_gsm.c                               |   11 ++
 drivers/tty/n_tty.c                               |   12 +-
 drivers/tty/serial/omap-serial.c                  |    6 -
 drivers/tty/serial/sirfsoc_uart.c                 |    4=20
 drivers/tty/vt/vt.c                               |    2=20
 drivers/usb/core/hcd.c                            |    1=20
 drivers/usb/core/hub.c                            |    7 -
 drivers/usb/core/usb.h                            |    1=20
 drivers/usb/host/xhci-ring.c                      |   54 -------------
 drivers/usb/host/xhci.c                           |   18 +++-
 drivers/usb/host/xhci.h                           |    2=20
 drivers/usb/serial/ftdi_sio.c                     |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                 |    7 +
 drivers/usb/serial/option.c                       |    3=20
 drivers/usb/serial/qcserial.c                     |    3=20
 drivers/usb/serial/usb-serial-simple.c            |    3=20
 drivers/usb/storage/Kconfig                       |    4=20
 drivers/usb/storage/scsiglue.c                    |    6 +
 drivers/usb/storage/unusual_cypress.h             |    2=20
 drivers/usb/storage/unusual_devs.h                |    7 +
 drivers/vme/bridges/vme_ca91cx42.c                |    4=20
 drivers/vme/bridges/vme_tsi148.c                  |    4=20
 fs/bio-integrity.c                                |   10 ++
 fs/cifs/cifsacl.c                                 |   28 +++++-
 fs/cifs/cifsglob.h                                |   10 ++
 fs/cifs/inode.c                                   |   13 ++-
 fs/cifs/smb1ops.c                                 |    8 +
 fs/cifs/xattr.c                                   |   64 ++++++++++-----
 fs/file.c                                         |    2=20
 fs/lockd/svclock.c                                |    8 +
 fs/nfs/dir.c                                      |    5 +
 include/linux/compiler-gcc4.h                     |    6 -
 include/linux/hyperv.h                            |    2=20
 include/linux/usb.h                               |    2=20
 include/uapi/linux/mic_ioctl.h                    |    2=20
 kernel/irq/irqdesc.c                              |    1=20
 kernel/time/jiffies.c                             |    6 +
 kernel/time/tick-broadcast.c                      |    1=20
 kernel/trace/ring_buffer.c                        |    7 +
 mm/memory-failure.c                               |    6 -
 net/mac80211/cfg.c                                |   41 +++++-----
 net/mac80211/ibss.c                               |    5 -
 net/mac80211/tx.c                                 |    2=20
 net/wireless/nl80211.c                            |    3=20
 scripts/mod/file2alias.c                          |    4=20
 sound/pci/hda/patch_realtek.c                     |    2=20
 virt/kvm/coalesced_mmio.c                         |    8 -
 118 files changed, 658 insertions(+), 386 deletions(-)

Alan Stern (3):
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: enable multi-LUN scanning when needed

Alex Deucher (3):
      drm/radeon: fix UVD IRQ support on 7xx
      drm/radeon: consolidate sdma hdp flushing code for CIK
      drm/radeon/cik: use POLL_REG_MEM special op for sDMA HDP flush

Alexander Usyskin (2):
      mei: clear write cb from waiting list on reset
      mei: don't unset read cb ptr on reset

Anton Blanchard (1):
      powerpc: Fix endian issues in kexec and crash dump code

Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->ls=
b is true

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss=
 unit

Bj=C3=B8rn Mork (2):
      usb: qcserial: add Netgear Aircard 340U
      usb: ftdi_sio: add Mindstorms EV3 console adapter

Borislav Petkov (2):
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

Christian K=C3=B6nig (1):
      drm/radeon: fix UVD IRQ support on SI

C=C3=A9dric Dufour (1):
      staging: lustre: fix quotactl permission denied (LU-4530)

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

Daniel Vetter (1):
      drm/i915: Fix intel_pipe_to_cpu_transcoder for UMS

David Henningsson (1):
      ALSA: hda - Add a headset quirk for Dell XPS 13

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Doug Anderson (1):
      hwmon: (ntc_thermistor) Avoid math overflow

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (4):
      mac80211: release the channel in error path in start_ap
      iwlwifi: mvm: don't allow A band if SKU forbids it
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Geert Uytterhoeven (1):
      spi: Fix crash with double message finalisation on error handling

Greg Kroah-Hartman (1):
      Linux 3.13.5

Guenter Roeck (1):
      iio: max1363: Use devm_regulator_get_optional for optional regulator

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

Hartmut Knaack (2):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that m=
ay not have been requested
      staging:iio:ad799x fix typo in ad799x_events[]

Imre Deak (1):
      drm/i915: vlv: fix DP PHY lockup due to invalid PP sequencer setup

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard l=
oop

Johannes Berg (2):
      mac80211: fix fragmentation code, particularly for encryption
      iwlwifi: mvm: disable scheduled scan

Julia Lawall (1):
      staging:iio:impedance:ad5933: correct error check

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Specify the target CPU that should receive notifi=
cation
      Drivers: hv: vmbus: Don't timeout during the initial connection with =
host

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Krist=C3=B3f Ralovich (1):
      USB: simple: add Dynastream ANT USB-m Stick device support

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platfo=
rm_data

Larry Finger (1):
      staging: r8188eu: Fix typo in USB_DEVICE list

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Linus Walleij (2):
      ARM: pxa: fix various compilation problems
      ARM: pxa: fix compilation problem on AM300EPD board

Marcus Folkesson (1):
      iio: adis16400: Set timestamp as the last element in chan_spec

Markus Pargmann (1):
      serial: omap-serial: Move info message to probe function

Martin K. Petersen (1):
      block: Fix nr_vecs for inline integrity vectors

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Mel Gorman (1):
      xen: properly account for _PAGE_NUMA during xen pte translations

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mika Kuoppala (1):
      drm/i915: Pair va_copy with va_end in i915_error_vprintf

Mika Westerberg (1):
      ACPI / hotplug / PCI: Relax the checking of _STA return values

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Naoya Horiguchi (1):
      mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

NeilBrown (2):
      lockd: send correct lock when granting a delayed lock.
      md/raid1: restore ability for check and repair to fix read errors.

Nicholas Bellinger (1):
      target: Fix free-after-use regression in PR unregister

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (2):
      ath9k_htc: Do not support PowerSave by default
      ar5523: fix usb id for Gigaset.

Oren Givon (1):
      iwlwifi: add more 7265 HW IDs

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul Gortmaker (1):
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=3Dn

Peter Hurley (1):
      n_tty: Fix stale echo output

Petr P=C3=ADsa=C5=99 (1):
      vt: Fix secure clear screen

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Prarit Bhargava (1):
      drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Qipan Li (1):
      serial: sirf: fix kernel panic caused by unpaired spinlock

Rafael Aquini (1):
      mm: fix page leak at nfs_symlink()

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Sarah Sharp (5):
      xhci 1.0: Limit arbitrarily-aligned scatter gather.
      Revert "xhci: Set scatter-gather limit to avoid failed block writes."
      Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
      Revert "usb: xhci: Link TRB must not occur within a USB payload burst"
      Revert "usbcore: set lpm_capable field for LPM capable root hubs"

Stanislaw Gruszka (1):
      ath9k_htc: make ->sta_rc_update atomic for most calls

Steve French (3):
      CIFS: Fix SMB2 mounts so they don't try to set or get xattrs via cifs
      Add protocol specific operation for CIFS xattrs
      retrieving CIFS ACLs when mounted with SMB2 fails dropping session

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (Red Hat) (2):
      ftrace/x86: Use breakpoints for converting function graph caller
      ring-buffer: Fix first commit on sub-buffer having non-zero delta

Sudeep Dutt (1):
      misc: mic: fix possible signed underflow (undefined behavior) in user=
space API

Sujith Manoharan (2):
      mac80211: Fix IBSS disconnect
      ath9k: Do not support PowerSave by default

Takashi Iwai (1):
      ALSA: hda - Fix mic capture on Sony VAIO Pro 11

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypas=
sing

Thomas Gleixner (1):
      tick: Clear broadcast pending bit when switching to oneshot

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Wolfram Sang (1):
      i2c: mv64xxx: refactor message start to ensure proper initialization


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCSDCAAoJEDjbvchgkmk+lVcP/2t4zOIAyqYRF9JYZTCA/bY6
ES37nBp5tT6SkIr9HGENRNJ/azv5RtqT04XlaBwOvale+ppO+qNSg/UAM9CqfpQ4
6B8ja+0DW3mpHsHowSTbm7tA33Qml6Hr/O3GbuRmoOVvtNpGd07UZfMvrZK4GLNc
W/xtalFwlY7sRXi0v3kbv3BTSbmt8xt99KlMVyeidFxIv9uvu/gaY0ySu5VCs3ld
ijelMuw//cork1QqG4uo6MMi3Gb+ku8z3O6FWqAPQb+dFZx5aqyf/rt2aC/Y9wNB
tiCrNIsbTdulzg4RwYFgawhaa+yDAkVMMv8DgT8iUchEkldi3sONW596+WdHxN4q
6dtrbwTgCQucUZhgr3cO5MG0eH6vnG7W+eeTcjP5kIYg1m6HmgOpyiihGtGS7XQ+
L6dSoWww9CjL9DZq+dCg6CGM963Qc8A3USY2QUmg/D/shLjILhCNlNSjfzx5fF5O
O7IQLtVfXy95OaCUuJfcuGHe6bwk1JriHOs+3mOMM9dyw9boMGyKgumn+qz9TJ1y
EaxyJ46xRtXgJPiHnNoREUs1m0WZB9JQk3oT+6RFcq2FCnRpE8rDovW2mQfLW573
z6WRYF/AbIxnCfc3Q6T0zrVCuvsZtAwr+vdSQnJArAOSEZoqQd1aIiKKNme3jok5
Ahpp8AJbVLad22JjQNzY
=+JF2
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
