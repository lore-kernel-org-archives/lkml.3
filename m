Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3KMDLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:11:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab3KMDKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:10:53 -0500
Date: Wed, 13 Nov 2013 12:13:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.8
Message-ID: <20131113031343.GA8004@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.8 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                     |    2=20
 arch/arc/mm/fault.c                          |    6=20
 arch/parisc/kernel/head.S                    |    4=20
 arch/um/kernel/exitcode.c                    |    4=20
 arch/x86/kernel/apic/x2apic_uv_x.c           |    2=20
 arch/xtensa/kernel/signal.c                  |    2=20
 drivers/ata/libata-eh.c                      |    6=20
 drivers/clk/clk-nomadik.c                    |   21 ++
 drivers/clk/versatile/clk-icst.c             |    2=20
 drivers/cpufreq/intel_pstate.c               |    7=20
 drivers/cpufreq/s3c64xx-cpufreq.c            |    2=20
 drivers/gpu/drm/drm_drv.c                    |    9 +
 drivers/gpu/drm/i915/intel_crt.c             |   30 +++
 drivers/gpu/drm/i915/intel_ddi.c             |   21 ++
 drivers/gpu/drm/i915/intel_display.c         |  131 ++++++++++------
 drivers/gpu/drm/i915/intel_dp.c              |  132 +++++++++-------
 drivers/gpu/drm/i915/intel_drv.h             |    2=20
 drivers/gpu/drm/i915/intel_lvds.c            |   16 ++
 drivers/gpu/drm/radeon/atombios_encoders.c   |    2=20
 drivers/gpu/drm/radeon/ni.c                  |    1=20
 drivers/gpu/drm/radeon/r600.c                |    1=20
 drivers/gpu/drm/radeon/si.c                  |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |   17 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |    2=20
 drivers/hid/hid-core.c                       |    1=20
 drivers/hid/hid-ids.h                        |    1=20
 drivers/hid/hid-wiimote-core.c               |    5=20
 drivers/md/bcache/request.c                  |    2=20
 drivers/md/md.c                              |    5=20
 drivers/md/raid1.c                           |    1=20
 drivers/md/raid10.c                          |    1=20
 drivers/md/raid5.c                           |   20 ++
 drivers/net/can/at91_can.c                   |    4=20
 drivers/net/can/flexcan.c                    |   14 +
 drivers/net/wireless/ath/ath9k/main.c        |   23 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    6=20
 drivers/net/wireless/iwlwifi/iwl-config.h    |    1=20
 drivers/net/wireless/iwlwifi/mvm/scan.c      |   12 +
 drivers/net/wireless/iwlwifi/pcie/drv.c      |   10 +
 drivers/net/wireless/mwifiex/main.c          |    6=20
 drivers/net/wireless/rt2x00/rt2x00pci.c      |    9 -
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    3=20
 drivers/ntb/ntb_hw.c                         |   41 ++++-
 drivers/ntb/ntb_hw.h                         |   16 ++
 drivers/ntb/ntb_regs.h                       |    4=20
 drivers/ntb/ntb_transport.c                  |   17 --
 drivers/scsi/BusLogic.c                      |   16 +-
 drivers/scsi/aacraid/linit.c                 |    2=20
 drivers/scsi/sd.c                            |    2=20
 drivers/staging/bcm/Bcmchar.c                |    1=20
 drivers/staging/ozwpan/ozcdev.c              |    3=20
 drivers/staging/sb105x/sb_pci_mp.c           |    2=20
 drivers/staging/wlags49_h2/wl_priv.c         |    9 -
 drivers/target/target_core_pscsi.c           |    8 -
 drivers/uio/uio.c                            |   41 +++--
 drivers/usb/core/quirks.c                    |    6=20
 drivers/usb/host/xhci-hub.c                  |   26 ---
 drivers/usb/musb/musb_core.c                 |   46 +++++
 drivers/usb/musb/musb_core.h                 |    1=20
 drivers/usb/musb/musb_gadget.c               |    2=20
 drivers/usb/musb/musb_virthub.c              |   46 -----
 drivers/usb/serial/ftdi_sio.c                |    1=20
 drivers/usb/serial/ftdi_sio_ids.h            |    6=20
 drivers/usb/serial/option.c                  |  216 ++++++++++++++++++++++=
+++++
 drivers/usb/storage/scsiglue.c               |    5=20
 drivers/usb/storage/unusual_devs.h           |    7=20
 drivers/vhost/scsi.c                         |    2=20
 drivers/video/au1100fb.c                     |   26 ---
 drivers/video/au1200fb.c                     |   23 --
 fs/cifs/cifsfs.c                             |    6=20
 fs/ecryptfs/crypto.c                         |    2=20
 fs/ecryptfs/keystore.c                       |    3=20
 fs/eventpoll.c                               |    4=20
 fs/jfs/jfs_inode.c                           |    3=20
 fs/proc/task_mmu.c                           |    4=20
 fs/select.c                                  |    3=20
 fs/seq_file.c                                |    2=20
 include/linux/usb_usual.h                    |    4=20
 include/trace/events/target.h                |    4=20
 include/uapi/drm/drm_mode.h                  |    2=20
 kernel/cgroup.c                              |    6=20
 kernel/mutex.c                               |   32 ++--
 kernel/time/clockevents.c                    |   65 ++++++--
 lib/scatterlist.c                            |    3=20
 mm/huge_memory.c                             |   70 ++++++--
 mm/memory.c                                  |   54 ++----
 mm/migrate.c                                 |   19 +-
 mm/mprotect.c                                |    2=20
 mm/pagewalk.c                                |    2=20
 net/mac80211/cfg.c                           |    2=20
 net/mac80211/ieee80211_i.h                   |    3=20
 net/mac80211/rx.c                            |    3=20
 net/mac80211/scan.c                          |   19 ++
 net/mac80211/status.c                        |    3=20
 net/mac80211/tx.c                            |    3=20
 net/mac80211/util.c                          |    4=20
 net/wireless/ibss.c                          |    3=20
 net/wireless/nl80211.c                       |    4=20
 scripts/kallsyms.c                           |   12 +
 scripts/link-vmlinux.sh                      |    2=20
 sound/core/pcm.c                             |    4=20
 sound/pci/hda/hda_codec.c                    |    4=20
 sound/pci/hda/hda_generic.c                  |    4=20
 sound/pci/hda/patch_realtek.c                |    1=20
 sound/soc/codecs/wm_hubs.c                   |    1=20
 sound/soc/soc-dapm.c                         |    2=20
 106 files changed, 1028 insertions(+), 458 deletions(-)

Aaron Lu (1):
      SCSI: sd: call blk_pm_runtime_init before add_disk

Alex Deucher (2):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780
      drm/radeon: make missing smc ucode non-fatal (r7xx-SI)

Amitkumar Karwar (1):
      mwifiex: fix SDIO interrupt lost issue

Anjana V Kumar (1):
      cgroup: fix to break the while loop in cgroup_attach_task() correctly

Baruch Siach (1):
      xtensa: don't use alternate signal stack on threads

Bian Yu (1):
      md: avoid deadlock when md_set_badblocks.

Bruno Randolf (1):
      cfg80211: fix warning when using WEXT for IBSS

Charles Keepax (1):
      cpufreq: s3c64xx: Rename index to driver_data

Chen LinX (1):
      mm/pagewalk.c: fix walk_page_range() access of wrong PTEs

Chris Wilson (3):
      drm/i915: Retry DP aux_ch communications with a different clock after=
 failure
      drm: Prevent overwriting from userspace underallocating core ioctl st=
ructs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Colin Ian King (1):
      eCryptfs: fix 32 bit corruption issue

Cyrill Gorcunov (1):
      mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages

Dan Carpenter (6):
      staging: ozwpan: prevent overflow in oz_cdev_write()
      Staging: bcm: info leak in ioctl
      Staging: sb105x: info leak in mp_get_count()
      staging: wlags49_h2: buffer overflow setting station name
      uml: check length in exitcode_proc_write()
      aacraid: missing capable() check in compat ioctl

Daniel Vetter (1):
      drm/i915: Fix the PPT fdi lane bifurcate state handling on ivb

Dave Kleikamp (1):
      jfs: fix error path in ialloc

David Herrmann (1):
      HID: wiimote: add LEGO-wiimote VID

Dirk Brandewie (1):
      cpufreq / intel_pstate: Fix max_perf_pct on resume

Emmanuel Grumbach (3):
      mac80211: correctly close cancelled scans
      iwlwifi: mvm: call ieee80211_scan_completed when needed
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series

Fangxiaozhi (Franko) (1):
      USB: support new huawei devices in option.c

Felix Fietkau (4):
      mac80211: drop spoofed packets in ad-hoc mode
      mac80211: use sta_info_get_bss() for nl80211 tx and client probing
      mac80211: update sta->last_rx on acked tx frames
      ath9k: fix tx queue scheduling after channel changes

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Greg Kroah-Hartman (1):
      Linux 3.11.8

Gu Zheng (1):
      seq_file: always update file->f_pos in seq_lseek()

Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Helge Deller (1):
      parisc: Do not crash 64bit SMP kernels on machines with >=3D 4GB RAM

Jan Klos (1):
      cifs: Fix inability to write files >2GB to SMB2/3 shares

Johannes Berg (1):
      mac80211: fix crash if bitrate calculation goes wrong

Jon Mason (4):
      NTB: Add Error Handling in ntb_device_setup
      NTB: Correct Number of Scratch Pad Registers
      NTB: Correct USD/DSD Identification
      NTB: Correct debugfs to work with more than 1 NTB Device

Jonathan Austin (1):
      clk: fixup argument order when setting VCO parameters

Kent Overstreet (1):
      bcache: Fixed incorrect order of arguments to bio_alloc_bioset()

Khalid Aziz (1):
      SCSI: BusLogic: Fix an oops when intializing multimaster adapter

Linus Torvalds (1):
      Fix a few incorrectly checked [io_]remap_pfn_range() calls

Linus Walleij (1):
      clk: nomadik: set all timers to use 2.4 MHz TIMCLK

Luciano Coelho (1):
      cfg80211: use the correct macro to check for active monitor support

Lukasz Dorau (1):
      md: Fix skipping recovery for read-only arrays.

Marc Kleine-Budde (3):
      can: at91-can: fix device to driver data mapping for platform devices
      can: flexcan: fix mx28 detection by rearanging OF match table
      can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX =
and abort pending TX

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Mel Gorman (6):
      mm: numa: Do not account for a hinting fault if we raced
      mm: Wait for THP migrations to complete during NUMA hinting faults
      mm: Prevent parallel splits during THP migration
      mm: numa: Sanitize task_numa_fault() callsites
      mm: Close races between THP migration and PMD numa clearing
      mm: Account for a THP NUMA hinting update as one PTE update

Ming Lei (2):
      scripts/kallsyms: filter symbols not in kernel address space
      lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Nicholas Bellinger (1):
      vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter

Oliver Neukum (3):
      usb-storage: add quirk for mandatory READ_CAPACITY_16
      USB: quirks.c: add one device that cannot deal with suspension
      USB: quirks: add touchscreen that is dazzeled by remote wakeup

Rafael J. Wysocki (2):
      Revert "epoll: use freezable blocking call"
      Revert "select: use freezable blocking call"

Rob Pearce (1):
      drm/i915: No LVDS hardware on Intel D410PT and D425KT

Rodrigo Vivi (1):
      drm/i915: split aux_clock_divider logic in a separated function for r=
euse.

Roland Dreier (1):
      target: Fix assignment of LUN in tracepoints

Russ Anderson (1):
      x86: Update UV3 hub revision ID

Russell King (1):
      ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Sarah Sharp (1):
      xhci: Don't enable/disable RWE on bus suspend/resume.

Sebastian Andrzej Siewior (1):
      usb: musb: start musb on the udc side, too

Shaohua Li (2):
      raid5: set bio bi_vcnt 0 for discard request
      raid5: avoid finding "discard" stripe

Stanislaw Gruszka (1):
      Revert "rt2x00pci: Use PCI MSIs whenever possible"

Takashi Iwai (5):
      ALSA: hda - Add missing initial vmaster hook at build_controls callba=
ck
      ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4
      ALSA: hda - Add a fixup for ASUS N76VZ
      ASoC: wm_hubs: Add missing break in hp_supply_event()
      ASoC: dapm: Fix source list debugfs outputs

Tetsuo Handa (1):
      mutex: Avoid gcc version dependent __builtin_constant_p() usage

Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion

Thomas Hellstrom (2):
      drm/vmwgfx: Don't put resources with invalid id's on lru list
      drm/vmwgfx: Don't kill clients on VT switch

Uwe Kleine-K=C3=B6nig (2):
      mm: make generic_access_phys available for modules
      uio: provide vm access to UIO_MEM_PHYS maps

Ville Syrj=C3=A4l=C3=A4 (2):
      drm/i915: Add HSW CRT output readout support
      drm/i915: Add support for pipe_bpp readout

Vineet Gupta (1):
      ARC: Incorrect mm reference used in vmalloc fault handler

Wei Yongjun (1):
      target/pscsi: fix return value check

=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=9A=D1=80=D0=B0=D0=BC=D0=B0=
=D1=80=D0=B5=D0=BD=D0=BA=D0=BE (1):
      USB: serial: ftdi_sio: add id for Z3X Box device


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSgu5nAAoJEDjbvchgkmk+fmsQAL4d2mqdqG6CAsABQ0dzY63l
LZX14pKHU+JOXtpJW40oFwnkoAA7Ga9rFGDWaXT9a/N10cU6CDRV7R/fDL2BkGXJ
k1y9yU27ET2EZ8h4buk2EXMcfjKKOwfjCaGBS3Pchqe9BukNjJsbi5EO/kv4Yjet
6Tq9fc2atHocKNsyOfBQGvqDj8Y8AqBum46tLQqcKikLAGOErooxOHzHOe2/5sZ6
t2g8PSIOSpRvgUcYnit3B4j8Ny7CeWOWxcy5I2u2CuXxWJ1rtQwuDBRBIHYM6AEg
CIp8wc6EyQ9oR8d5JlacOtm4j3IAiGDjHxLUebvTuXFFW5+zft7iQAhbHDDo8ig4
HFNkzPyXSnqGNrzclndGGBUorzrbZdcPABGM8+Ptebr/dsomH7tJIb4CaDZRRWCT
tQvu87CYux3BNHUo/PHqBZmIhTkRGVuCXKD7ChVDF84KNEupvewFDCkEDpB7jJeB
IaU1L1be1frS1EiAvjHExdps/UuaeEHAZTvoCwPPCj/HePUq0nuEEkXckstOKV1m
zcROH7GbxFOfSFQnZ4XeLyPG+fSwH2QRVuxbb1FLHPsf/NhFloAAD6emANcnAcko
Vo76kLo2jXY32DxdQ6H/lQ5ssBfLc7OrcUAp2M2w8M9Rzcv8XbckeJq3cJmDBk80
5fVAKiFrrMevFtdtVl44
=Awxe
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
