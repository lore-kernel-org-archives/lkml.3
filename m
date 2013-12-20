Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3LTQFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3LTQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:05:39 -0500
Date: Fri, 20 Dec 2013 08:05:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.6
Message-ID: <20131220160548.GA13740@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.6 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arm/boot/dts/sun6i-a31.dtsi                   |   27 +--
 arch/arm/kernel/process.c                          |    7=20
 arch/arm/kernel/stacktrace.c                       |    2=20
 arch/arm/kernel/traps.c                            |    3=20
 arch/arm/mach-highbank/highbank.c                  |   23 ++
 arch/arm/mach-omap2/omap_hwmod.c                   |   43 ++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   13 -
 arch/arm/mach-pxa/reset.c                          |    8=20
 arch/arm/mach-pxa/tosa.c                           |  102 +++++------
 arch/arm64/include/asm/pgtable-hwdef.h             |    2=20
 arch/powerpc/include/asm/pgalloc-32.h              |    6=20
 arch/powerpc/include/asm/pgalloc-64.h              |    6=20
 arch/x86/Makefile                                  |    8=20
 arch/x86/boot/Makefile                             |    6=20
 arch/x86/boot/compressed/Makefile                  |    1=20
 arch/x86/kvm/lapic.c                               |   35 ++--
 arch/x86/kvm/lapic.h                               |    4=20
 arch/x86/kvm/x86.c                                 |   40 ----
 arch/x86/platform/efi/efi.c                        |    7=20
 arch/x86/platform/uv/tlb_uv.c                      |    5=20
 arch/x86/realmode/rm/Makefile                      |    3=20
 crypto/algif_hash.c                                |    3=20
 crypto/algif_skcipher.c                            |    3=20
 drivers/gpu/drm/i915/intel_display.c               |   64 ++++++-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   15 +
 drivers/gpu/drm/radeon/r600_hdmi.c                 |    8=20
 drivers/gpu/drm/radeon/radeon_atombios.c           |    2=20
 drivers/gpu/drm/radeon/si.c                        |   11 +
 drivers/gpu/drm/udl/udl_gem.c                      |    6=20
 drivers/hid/hid-core.c                             |    1=20
 drivers/hid/hid-ids.h                              |    1=20
 drivers/hid/hid-kye.c                              |    6=20
 drivers/hwmon/hih6130.c                            |   16 +
 drivers/hwmon/lm78.c                               |    2=20
 drivers/hwmon/sis5595.c                            |    2=20
 drivers/hwmon/vt8231.c                             |    2=20
 drivers/hwmon/w83l786ng.c                          |   13 -
 drivers/input/mouse/elantech.c                     |    1=20
 drivers/input/touchscreen/usbtouchscreen.c         |   22 ++
 drivers/iommu/arm-smmu.c                           |   62 +++----
 drivers/md/dm-bufio.c                              |    5=20
 drivers/md/dm-delay.c                              |   23 +-
 drivers/md/dm-snap.c                               |   71 +++++++-
 drivers/md/dm-stats.c                              |    1=20
 drivers/md/dm-table.c                              |    5=20
 drivers/md/dm-thin-metadata.c                      |    8=20
 drivers/md/dm-thin-metadata.h                      |    1=20
 drivers/md/dm-thin.c                               |   66 ++++---
 drivers/md/persistent-data/dm-array.c              |   10 +
 drivers/md/persistent-data/dm-block-manager.c      |    6=20
 drivers/md/persistent-data/dm-block-manager.h      |    7=20
 drivers/md/persistent-data/dm-space-map-common.c   |   32 ++-
 drivers/md/persistent-data/dm-space-map-metadata.c |    8=20
 drivers/media/dvb-frontends/af9033.c               |   12 -
 drivers/media/dvb-frontends/cxd2820r_core.c        |    4=20
 drivers/media/i2c/wm8775.c                         |    4=20
 drivers/media/pci/bt8xx/bttv-driver.c              |    3=20
 drivers/media/pci/saa7164/saa7164-core.c           |    4=20
 drivers/media/radio/radio-tea5764.c                |    2=20
 drivers/media/radio/tef6862.c                      |    2=20
 drivers/media/usb/dvb-usb-v2/af9035.c              |   17 +
 drivers/mtd/nand/pxa3xx_nand.c                     |    4=20
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    5=20
 drivers/net/ethernet/intel/igb/e1000_phy.c         |    5=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   22 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    4=20
 drivers/net/wireless/iwlwifi/iwl-7000.c            |    7=20
 drivers/net/wireless/iwlwifi/iwl-config.h          |    3=20
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    5=20
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |    4=20
 drivers/net/wireless/iwlwifi/pcie/rx.c             |    4=20
 drivers/net/wireless/iwlwifi/pcie/trans.c          |    3=20
 drivers/net/wireless/mwifiex/sta_ioctl.c           |    4=20
 drivers/pci/pci-driver.c                           |   12 +
 drivers/regulator/pfuze100-regulator.c             |    2=20
 drivers/rtc/rtc-at91rm9200.c                       |    2=20
 drivers/staging/comedi/drivers/amplc_pc263.c       |    3=20
 drivers/staging/comedi/drivers/amplc_pci263.c      |    3=20
 drivers/staging/comedi/drivers/ssv_dnp.c           |    6=20
 drivers/usb/core/hub.c                             |    5=20
 drivers/usb/dwc3/ep0.c                             |    2=20
 drivers/usb/dwc3/gadget.c                          |    5=20
 drivers/usb/gadget/composite.c                     |    1=20
 drivers/usb/host/xhci-ring.c                       |   54 ++++++
 drivers/usb/musb/musb_cppi41.c                     |  164 ++++++++++++++++=
---
 drivers/usb/serial/option.c                        |   27 +++
 drivers/watchdog/sc1200wdt.c                       |    3=20
 fs/btrfs/acl.c                                     |    2=20
 fs/btrfs/backref.c                                 |    3=20
 fs/btrfs/ctree.c                                   |    8=20
 fs/btrfs/inode.c                                   |   47 +++--
 fs/btrfs/ioctl.c                                   |    3=20
 fs/btrfs/ordered-data.c                            |    2=20
 fs/btrfs/send.c                                    |  179 ++++++++--------=
-----
 fs/btrfs/transaction.c                             |    6=20
 fs/btrfs/tree-log.c                                |    2=20
 fs/btrfs/volumes.c                                 |    2=20
 fs/exportfs/expfs.c                                |   18 +-
 fs/nfs/blocklayout/extents.c                       |    2=20
 fs/nfs/nfs4proc.c                                  |    3=20
 fs/nfsd/nfscache.c                                 |    9 -
 fs/stat.c                                          |   31 ++-
 fs/xfs/xfs_fsops.c                                 |    6=20
 fs/xfs/xfs_ioctl.c                                 |    3=20
 fs/xfs/xfs_ioctl32.c                               |    3=20
 include/linux/compiler-intel.h                     |    2=20
 include/linux/fs.h                                 |    1=20
 include/linux/kexec.h                              |    3=20
 include/linux/usb.h                                |    2=20
 include/sound/memalloc.h                           |    2=20
 include/uapi/sound/compress_offload.h              |    6=20
 kernel/futex.c                                     |    2=20
 kernel/kexec.c                                     |    4=20
 kernel/sched/debug.c                               |    8=20
 kernel/sched/fair.c                                |    2=20
 mm/memcontrol.c                                    |   41 ++++
 net/ipv4/udp.c                                     |    3=20
 net/mac80211/cfg.c                                 |    3=20
 net/mac80211/main.c                                |    1=20
 net/mac80211/rx.c                                  |    3=20
 net/mac80211/scan.c                                |    2=20
 net/wireless/core.c                                |    3=20
 security/selinux/hooks.c                           |   93 ++++++++--
 sound/pci/hda/hda_generic.c                        |   47 +++++
 sound/pci/hda/hda_generic.h                        |    3=20
 sound/pci/hda/patch_analog.c                       |   10 +
 sound/pci/hda/patch_hdmi.c                         |    5=20
 virt/kvm/kvm_main.c                                |    3=20
 129 files changed, 1255 insertions(+), 566 deletions(-)

Alan (1):
      sc1200_wdt: Fix oops

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (4):
      drm/radeon: fix typo in fetching mpll params
      drm/radeon: program DCE2 audio dto just like DCE3
      drm/radeon: fixup bad vram size on SI
      drm/radeon/atom: fix bus probes when hw_i2c is set (v2)

Andy Adamson (1):
      NFSv4 wait on recovery for async session errors

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-201=
3-6368)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Antti Palosaari (3):
      media: af9035: fix broken I2C and USB I/O
      media: af9033: fix broken I2C
      media: af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual

Axel Lin (1):
      regulator: pfuze100: Fix address of FABID

Ben Hutchings (1):
      HID: kye: Fix missing break in kye_report_fixup()

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Benjamin Tissoires (1):
      HID: kye: Add report fixup for Genius Manticore Keyboard

Bob Copeland (1):
      Revert "mac80211: allow disable power save in mesh"

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

Carolyn Wyborny (1):
      igb: Fix for issue where values could be too high for udelay function.

Chris Wilson (1):
      drm/i915/vlv: fix up broken precision in vlv_crtc_clock_get

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size hand=
ling

Dan Carpenter (4):
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      xfs: underflow bug in xfs_attrlist_by_handle()
      media: af9035: unlock on error in af9035_i2c_master_xfer()
      Btrfs: fix access_ok() check in btrfs_ioctl_send()

Dave Chinner (1):
      xfs: growfs overruns AGFL buffer on V4 filesystems

David Laight (1):
      usb: xhci: Link TRB must not occur within a USB payload burst

David Sterba (1):
      btrfs: call mnt_drop_write after interrupted subvol deletion

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Emmanuel Grumbach (1):
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160

Ezequiel Garcia (1):
      Partially revert "mtd: nand: pxa3xx: Introduce 'marvell,armada370-nan=
d' compatible string"

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felix Fietkau (1):
      ath9k: fix duration calculation for non-aggregated packets

Filipe David Borba Manana (1):
      Btrfs: fix incorrect inode acl reset

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Greg Kroah-Hartman (2):
      Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_N=
OTLAST"
      Linux 3.12.6

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H Hartley Sweeten (2):
      staging: comedi: drivers: use comedi_dio_update_state() for simple ca=
ses
      staging: comedi: ssv_dnp: use comedi_dio_update_state()

H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hans Verkuil (4):
      media: tef6862/radio-tea5764: actually assign clamp result
      media: bttv: don't setup the controls if there are no video devices
      media: wm8775: fix broken audio routing
      cxd2820r_core: fix sparse warnings

Helge Deller (1):
      nfs: fix do_div() warning by instead using sector_div()

Hong H. Pham (1):
      powerpc: Fix PTE page address mismatch in pgtable ctor/dtor

J. Bruce Fields (2):
      vfs: split out vfs_getattr_nosec
      exportfs: fix 32-bit nfsd handling of 64-bit inode numbers

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jeff Layton (1):
      nfsd: when reusing an existing repcache entry, unhash it first

Jesse Barnes (2):
      i915/vlv: untangle integrated clock source handling v4
      drm/i915/vlv: add VLV specific clock_get function v3

Joe Thornber (6):
      dm array: fix a reference counting bug in shadow_ablock
      dm space map: disallow decrementing a reference count below zero
      dm thin: switch to read only mode if a mapping insert fails
      dm thin: always fallback the pool mode if commit fails
      dm thin: re-establish read-only state when switching to fail mode
      dm thin: allow pool in read-only mode to transition to read-write mode

Johannes Berg (4):
      cfg80211: disable 5/10 MHz support for all drivers
      mac80211: fix scheduled scan rtnl deadlock
      mac80211: don't attempt to reorder multicast frames
      iwlwifi: mvm: check sta_id/drain values in debugfs

Johannes Weiner (3):
      mm: memcg: do not declare OOM from __GFP_NOFAIL allocations
      mm: memcg: do not allow task about to OOM kill to bypass the limit
      mm: memcg: fix race condition between memcg teardown and swapin

Jon Medhurst (1):
      ARM: 7917/1: cacheflush: correctly limit range of memory region being=
 flushed

Josef Bacik (5):
      Btrfs: do a full search everytime in btrfs_search_old_slot
      Btrfs: reset intwrite on transaction abort
      Btrfs: fix hole check in log_one_extent
      Btrfs: stop using vfs_read in send
      Btrfs: take ordered root lock when removing ordered operations inode

Jos=E9 Miguel Gon=E7alves (1):
      hwmon: HIH-6130: Support I2C bus drivers without I2C_FUNC_SMBUS_QUICK

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTAC=
HED

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (1):
      futex: fix handling of read-only-mapped hugepages

Liu Bo (4):
      Btrfs: fix memory leak of chunks' extent map
      Btrfs: do not run snapshot-aware defragment on error
      Btrfs: fix a crash when running balance and defrag concurrently
      Btrfs: fix lockdep error in async commit

Matt Walker (1):
      Input: elantech - add support for newer (August 2013) devices

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Maxime Ripard (2):
      ARM: sun6i: dt: Fix interrupt trigger types
      net: allwinner: emac: Add missing free_irq

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Mike Snitzer (2):
      dm space map metadata: return on failure in sm_metadata_new_block
      dm thin: switch to read-only mode if metadata space is exhausted

Mikulas Patocka (5):
      dm bufio: initialize read-only module parameters
      dm snapshot: avoid snapshot space leak on crash
      dm stats: initialize read-only module parameter
      dm delay: fix a possible deadlock due to shared workqueue
      dm table: fail dm_table_create on dm_round_up overflow

Paul Moore (2):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute=
()

Paulo Zanoni (1):
      drm/i915: use the correct force_wake function at the PC8 code

Rob Clark (1):
      udl: fix issue with imported prime buffers

Rob Herring (1):
      ARM: highbank: handle soft poweroff and reset key events

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic

Sebastian Andrzej Siewior (2):
      usb: musb: musb_cppi41: factor most of cppi41_dma_callback() into cpp=
i41_trans_done()
      usb: musb: musb_cppi41: handle pre-mature TX complete interrupt

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Steve Capper (1):
      arm64: mm: Fix PMD_SECT_PROT_NONE definition

Sujith Manoharan (2):
      ath9k: Fix QuickDrop usage
      ath9k: Fix XLNA bias strength

Takashi Iwai (3):
      ALSA: compress: Fix 64bit ABI incompatibility
      ALSA: hda - Add static DAC/pin mapping for AD1986A codec
      ALSA: hda - Mute all aamix inputs as default

Ujjal Roy (1):
      mwifiex: fix memory leak issue for ibss join

Ville Syrj=E4l=E4 (1):
      drm/i915: Fix pipe CSC post offset calculation

Wei Yongjun (1):
      media: saa7164: fix return value check in saa7164_initdev()

Will Deacon (1):
      iommu/arm-smmu: use mutex instead of spinlock for locking page tables

cpw (1):
      x86/UV: Fix NULL pointer dereference in uv_flush_tlb_others() if the =
'nobau' boot option is used


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStGrbAAoJEDjbvchgkmk+I2YP/0byVugjzCX4wOIaOv14tqrz
h/D3qcHbk2GSNKC8LN+Oc66l680raAYrc8IIBj4MwQbOvrH/ue9XhyrRgYim1yQi
p7dbxW25pyVaUuuCX5MhW4QsTKxVAikKeApvuokPQ99HO2pI4yZtkijvge8I18Qo
1llHi4/bJm3iOq6iOXORN/DiPqQOLhj7EiP59I3MY/5aeh3aP3fcUrJGy+uhMo8T
REMEuWkmlrjONJHX7rqcjf3yZ7bIbgQZnh7w0bNvYXSlfg1fJfP7ZoIuipeSc/2e
nIA9ZNTxhDwMxL++Tk6KSOhlDu2yNYXF+NmpADhoDC8oRTFUGLm5P2v2BdOpt4uR
QgNgn/3K4oThkHvgEdTSEaMkL7b/eKupWWSEquC9uK9F95Zh2LZB9Quj8Rob7s5a
/tvBj4SWk72dwNqbWn7ftSzE8RkYf/8bgeVo6aFAcR7TRScXOeUJgho1ZT9HIb+B
oNpAUqb5xZzZebx5BVexMDLRSN5eImH4Ub84cw9zAE2N6olL+yvzlSQSWNnRNrI2
bbkoRlC3+2ZJeUScIYT68n4fs4MzmNlGaaFItAldl5iMt0H5O2wl7h/zsXi6v+fE
BAPEdju5my0YrL87JZlF2ub2fEf4N0nY3EPtg2UtVI5KCGtkqkE2xpm8Ix14e4Uv
UoTUzCjBOCQUMyazaBqi
=BYNo
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
