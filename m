Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3AQRL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:11:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:36310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab3AQRLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:11:55 -0500
Date: Thu, 17 Jan 2013 09:11:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.3
Message-ID: <20130117171150.GA23284@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.3 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/power/runtime_pm.txt                     |    9=20
 Makefile                                               |   10=20
 arch/arm/mach-omap2/board-3430sdp.c                    |    1=20
 arch/arm/mach-omap2/board-am3517evm.c                  |    1=20
 arch/arm/mach-omap2/board-cm-t35.c                     |    1=20
 arch/arm/mach-omap2/board-devkit8000.c                 |    1=20
 arch/arm/mach-omap2/board-omap3evm.c                   |    1=20
 arch/arm/mach-omap2/board-omap3stalker.c               |    1=20
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h            |    3=20
 arch/arm/mach-pxa/pxa27x.c                             |    4=20
 arch/mips/kernel/process.c                             |    4=20
 arch/mips/mm/tlbex.c                                   |   16 -
 arch/powerpc/kernel/head_64.S                          |    2=20
 arch/powerpc/kernel/time.c                             |    5=20
 arch/powerpc/kvm/44x_emulate.c                         |    2=20
 arch/powerpc/kvm/e500_tlb.c                            |    2=20
 arch/powerpc/platforms/40x/ppc40x_simple.c             |    3=20
 arch/s390/kernel/entry64.S                             |   25 +-
 arch/s390/kvm/kvm-s390.c                               |    2=20
 drivers/acpi/scan.c                                    |    7=20
 drivers/ata/libata-core.c                              |    1=20
 drivers/ata/libata-eh.c                                |    1=20
 drivers/ata/libata-scsi.c                              |    6=20
 drivers/ata/sata_promise.c                             |   15 +
 drivers/base/power/main.c                              |    9=20
 drivers/base/regmap/regmap-debugfs.c                   |    2=20
 drivers/bcma/driver_mips.c                             |    2=20
 drivers/block/aoe/aoeblk.c                             |   17 -
 drivers/block/rbd.c                                    |   63 ++++--
 drivers/block/rbd_types.h                              |    2=20
 drivers/cpuidle/coupled.c                              |    2=20
 drivers/edac/edac_mc_sysfs.c                           |    2=20
 drivers/firewire/net.c                                 |   13 -
 drivers/gpu/drm/drm_mm.c                               |   45 +---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c             |    5=20
 drivers/gpu/drm/i915/i915_debugfs.c                    |    4=20
 drivers/gpu/drm/i915/i915_drv.c                        |    2=20
 drivers/gpu/drm/i915/i915_drv.h                        |    3=20
 drivers/gpu/drm/i915/i915_gem.c                        |   25 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c                 |    7=20
 drivers/gpu/drm/i915/i915_irq.c                        |    4=20
 drivers/gpu/drm/i915/i915_reg.h                        |    2=20
 drivers/gpu/drm/i915/intel_display.c                   |  136 ++++++++-----
 drivers/gpu/drm/i915/intel_drv.h                       |    9=20
 drivers/gpu/drm/i915/intel_lvds.c                      |   10=20
 drivers/gpu/drm/i915/intel_pm.c                        |   23 +-
 drivers/gpu/drm/nouveau/core/include/subdev/bios/pll.h |    2=20
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c       |    2=20
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c          |    6=20
 drivers/gpu/drm/nouveau/core/subdev/instmem/base.c     |   35 ++-
 drivers/gpu/drm/nouveau/nouveau_bo.c                   |    2=20
 drivers/gpu/drm/nouveau/nouveau_fence.h                |    1=20
 drivers/gpu/drm/nouveau/nouveau_prime.c                |    1=20
 drivers/gpu/drm/nouveau/nv04_dfp.c                     |    2=20
 drivers/gpu/drm/nouveau/nv10_fence.c                   |    8=20
 drivers/gpu/drm/nouveau/nv50_fence.c                   |    1=20
 drivers/gpu/drm/radeon/atombios_crtc.c                 |    2=20
 drivers/gpu/drm/radeon/atombios_encoders.c             |    2=20
 drivers/gpu/drm/radeon/evergreen.c                     |   18 +
 drivers/gpu/drm/radeon/evergreen_cs.c                  |    1=20
 drivers/gpu/drm/radeon/evergreend.h                    |    5=20
 drivers/gpu/drm/radeon/ni.c                            |   16 +
 drivers/gpu/drm/radeon/nid.h                           |   11 +
 drivers/gpu/drm/radeon/radeon.h                        |    3=20
 drivers/gpu/drm/radeon/radeon_combios.c                |   51 +++++
 drivers/gpu/drm/radeon/radeon_connectors.c             |   10=20
 drivers/gpu/drm/radeon/radeon_device.c                 |   17 +
 drivers/gpu/drm/radeon/radeon_display.c                |   13 -
 drivers/gpu/drm/radeon/radeon_fence.c                  |   49 +++-
 drivers/gpu/drm/radeon/radeon_i2c.c                    |   10=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c        |    8=20
 drivers/gpu/drm/radeon/radeon_mode.h                   |    5=20
 drivers/gpu/drm/radeon/radeon_pm.c                     |   15 +
 drivers/gpu/drm/radeon/radeon_prime.c                  |    1=20
 drivers/gpu/drm/radeon/si.c                            |   25 ++
 drivers/gpu/drm/radeon/sid.h                           |   14 +
 drivers/gpu/drm/udl/udl_connector.c                    |   17 +
 drivers/hid/hid-ids.h                                  |    3=20
 drivers/hid/usbhid/hid-quirks.c                        |    1=20
 drivers/hwmon/lm73.c                                   |   16 +
 drivers/infiniband/hw/mlx4/cm.c                        |    4=20
 drivers/infiniband/hw/nes/nes.h                        |    1=20
 drivers/infiniband/hw/nes/nes_hw.c                     |    9=20
 drivers/infiniband/hw/nes/nes_verbs.c                  |    9=20
 drivers/iommu/intel-iommu.c                            |   11 -
 drivers/md/dm-bio-prison.c                             |   25 --
 drivers/md/dm-bio-prison.h                             |    1=20
 drivers/md/dm-ioctl.c                                  |    8=20
 drivers/md/dm-table.c                                  |    2=20
 drivers/md/dm-thin.c                                   |  101 ++++++---
 drivers/md/persistent-data/dm-btree-internal.h         |   16 -
 drivers/md/persistent-data/dm-btree-remove.c           |   50 ++--
 drivers/md/persistent-data/dm-btree-spine.c            |    6=20
 drivers/md/persistent-data/dm-btree.c                  |   22 +-
 drivers/mfd/mfd-core.c                                 |   15 +
 drivers/mfd/wm8994-core.c                              |    1=20
 drivers/mtd/nand/cs553x_nand.c                         |    3=20
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c                  |    9=20
 drivers/net/ethernet/mellanox/mlx4/cmd.c               |    9=20
 drivers/net/ethernet/mellanox/mlx4/eq.c                |   10=20
 drivers/net/wimax/i2400m/i2400m-usb.h                  |    3=20
 drivers/net/wimax/i2400m/usb.c                         |    6=20
 drivers/net/wireless/ath/ath5k/base.c                  |    4=20
 drivers/net/wireless/ath/ath5k/mac80211-ops.c          |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  172 ++++++++----=
-----
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h         |    6=20
 drivers/net/wireless/ath/ath9k/ar9003_hw.c             |    6=20
 drivers/net/wireless/ath/ath9k/calib.c                 |    1=20
 drivers/net/wireless/ath/ath9k/calib.h                 |    3=20
 drivers/net/wireless/ath/carl9170/fw.c                 |    6=20
 drivers/net/wireless/b43/b43.h                         |    5=20
 drivers/net/wireless/b43/main.c                        |   54 ++++-
 drivers/net/wireless/b43/main.h                        |    5=20
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    5=20
 drivers/net/wireless/iwlwifi/dvm/tx.c                  |   71 +++----
 drivers/net/wireless/iwlwifi/pcie/rx.c                 |   13 +
 drivers/net/wireless/mwifiex/sta_ioctl.c               |   21 --
 drivers/net/wireless/rt2x00/rt2800lib.c                |    3=20
 drivers/net/wireless/rt2x00/rt2x00dev.c                |   10=20
 drivers/net/xen-netfront.c                             |   27 --
 drivers/platform/x86/samsung-laptop.c                  |   10=20
 drivers/platform/x86/sony-laptop.c                     |   15 -
 drivers/regulator/max8997.c                            |   36 +--
 drivers/regulator/max8998.c                            |   44 ++--
 drivers/regulator/s2mps11.c                            |   10=20
 drivers/regulator/wm831x-dcdc.c                        |    2=20
 drivers/s390/cio/device_pgid.c                         |   10=20
 drivers/scsi/mvsas/mv_94xx.h                           |   14 -
 drivers/scsi/mvsas/mv_sas.h                            |    2=20
 drivers/scsi/qla2xxx/qla_attr.c                        |    3=20
 drivers/scsi/qla2xxx/qla_bsg.c                         |   72 ++-----
 drivers/scsi/qla2xxx/qla_os.c                          |    7=20
 drivers/scsi/qla2xxx/qla_target.c                      |   21 +-
 drivers/scsi/scsi_sysfs.c                              |   11 -
 drivers/staging/comedi/Kconfig                         |    1=20
 drivers/staging/comedi/comedi_fops.c                   |    3=20
 drivers/staging/comedi/drivers/comedi_test.c           |    2=20
 drivers/staging/comedi/drivers/ni_pcimio.c             |   16 -
 drivers/staging/omapdrm/omap_gem_dmabuf.c              |    5=20
 drivers/staging/rtl8712/usb_intf.c                     |    2=20
 drivers/staging/speakup/synth.c                        |    4=20
 drivers/staging/vt6656/dpc.c                           |    4=20
 drivers/staging/vt6656/key.c                           |   53 +++--
 drivers/staging/vt6656/key.h                           |    8=20
 drivers/staging/vt6656/mac.c                           |    6=20
 drivers/staging/vt6656/rf.c                            |    3=20
 drivers/staging/vt6656/rxtx.c                          |   18 +
 drivers/staging/vt6656/ttype.h                         |   16 -
 drivers/staging/vt6656/wcmd.c                          |   20 +
 drivers/staging/vt6656/wpa2.h                          |    4=20
 drivers/staging/zram/zram_drv.c                        |  152 +++++++-----=
---
 drivers/target/iscsi/iscsi_target.c                    |    4=20
 drivers/target/iscsi/iscsi_target_erl2.c               |    2=20
 drivers/target/iscsi/iscsi_target_login.c              |    8=20
 drivers/target/iscsi/iscsi_target_nego.c               |   10=20
 drivers/target/iscsi/iscsi_target_tmr.c                |    4=20
 drivers/target/sbp/sbp_target.c                        |   17 -
 drivers/target/target_core_file.c                      |    9=20
 drivers/target/tcm_fc/tfc_sess.c                       |    2=20
 drivers/usb/class/cdc-acm.c                            |    3=20
 drivers/usb/core/hub.c                                 |  120 +++++++++--
 drivers/usb/core/quirks.c                              |    3=20
 drivers/usb/gadget/dummy_hcd.c                         |    9=20
 drivers/usb/host/ehci-pci.c                            |   39 +--
 drivers/usb/host/xhci-hub.c                            |   38 +++
 drivers/usb/host/xhci-mem.c                            |    2=20
 drivers/usb/host/xhci-ring.c                           |    9=20
 drivers/usb/host/xhci.c                                |   10=20
 drivers/usb/musb/musb_core.c                           |    5=20
 drivers/usb/serial/ftdi_sio.c                          |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                      |    6=20
 drivers/usb/serial/option.c                            |   18 +
 drivers/video/mxsfb.c                                  |    3=20
 fs/buffer.c                                            |    1=20
 fs/ceph/addr.c                                         |    9=20
 fs/ceph/caps.c                                         |   16 -
 fs/ceph/inode.c                                        |   15 -
 fs/ceph/mds_client.c                                   |    9=20
 fs/ceph/super.c                                        |    2=20
 fs/eventpoll.c                                         |   22 ++
 fs/ext4/acl.c                                          |    6=20
 fs/ext4/extents.c                                      |   22 +-
 fs/ext4/ialloc.c                                       |    2=20
 fs/ext4/namei.c                                        |    5=20
 fs/ext4/super.c                                        |   26 +-
 fs/jbd2/transaction.c                                  |    3=20
 fs/jffs2/nodemgmt.c                                    |    6=20
 fs/pstore/ram.c                                        |   12 -
 fs/udf/inode.c                                         |   11 -
 include/drm/drm_mm.h                                   |    2=20
 include/linux/audit.h                                  |    3=20
 include/linux/ceph/libceph.h                           |    2=20
 include/linux/compaction.h                             |    4=20
 include/linux/mfd/da9055/core.h                        |    2=20
 include/linux/mfd/da9055/pdata.h                       |    2=20
 include/linux/mfd/da9055/reg.h                         |    2=20
 include/linux/mm.h                                     |    1=20
 include/linux/sunrpc/cache.h                           |    6=20
 include/net/mac80211.h                                 |    5=20
 include/uapi/linux/audit.h                             |    1=20
 include/video/omap-panel-tfp410.h                      |    2=20
 kernel/auditsc.c                                       |   14 +
 kernel/watchdog.c                                      |   11 -
 mm/bootmem.c                                           |   24 +-
 mm/compaction.c                                        |   98 +--------
 mm/internal.h                                          |    1=20
 mm/page_alloc.c                                        |   37 ---
 net/ceph/ceph_common.c                                 |    3=20
 net/ceph/messenger.c                                   |   72 +++----
 net/ceph/osd_client.c                                  |   93 +++------
 net/ceph/osdmap.c                                      |   31 +--
 net/mac80211/ibss.c                                    |    9=20
 net/mac80211/ieee80211_i.h                             |   10=20
 net/mac80211/iface.c                                   |   28 +-
 net/mac80211/scan.c                                    |   34 ++-
 net/mac80211/sta_info.c                                |   46 ++++
 net/mac80211/sta_info.h                                |    3=20
 net/mac80211/status.c                                  |    6=20
 net/sunrpc/clnt.c                                      |    2=20
 net/sunrpc/rpc_pipe.c                                  |    7=20
 net/sunrpc/sched.c                                     |   30 ++
 net/sunrpc/xprt.c                                      |   12 -
 sound/arm/pxa2xx-ac97-lib.c                            |   26 ++
 sound/pci/hda/hda_intel.c                              |   13 -
 sound/pci/hda/patch_conexant.c                         |   16 -
 sound/soc/codecs/arizona.c                             |    9=20
 sound/soc/codecs/arizona.h                             |   18 -
 sound/soc/codecs/sigmadsp.c                            |    2=20
 sound/soc/codecs/sta529.c                              |    9=20
 sound/soc/codecs/wm2000.c                              |    4=20
 sound/soc/codecs/wm2200.c                              |    8=20
 sound/soc/codecs/wm5100.c                              |    6=20
 sound/soc/codecs/wm8994.c                              |   16 -
 sound/soc/soc-pcm.c                                    |    1=20
 virt/kvm/kvm_main.c                                    |   13 -
 235 files changed, 2062 insertions(+), 1364 deletions(-)

Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Aleksi Torhamo (2):
      drm/nouveau/clock: fix support for more than 2 monitors on nve0
      drm/nvc0/fb: fix crash when different mutex is used to protect same l=
ist

Alex Deucher (4):
      drm/radeon/dce32+: use fractional fb dividers for high clocks
      drm/radeon: fix eDP clk and lane setup for scaled modes
      drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list
      drm/radeon: add connector table for Mac G4 Silver

Alex Elder (19):
      libceph: socket can close in any connection state
      libceph: report connection fault with warning
      libceph: init osd->o_node in create_osd()
      libceph: init event->node in ceph_osdc_create_event()
      libceph: don't use rb_init_node() in ceph_osdc_alloc_request()
      libceph: register request before unregister linger
      libceph: move linger requests sooner in kick_requests()
      libceph: always reset osds when kicking
      libceph: WARN, don't BUG on unexpected connection states
      libceph: avoid using freed osd in __kick_osd_requests()
      ceph: don't reference req after put
      rbd: fix bug in rbd_dev_id_put()
      rbd: zero return code in rbd_dev_image_id()
      rbd: fix read-only option name
      rbd: increase maximum snapshot name length
      rbd: remove snapshots on error in rbd_add()
      rbd: do not allow remove of mounted-on image
      rbd: get rid of RBD_MAX_SEG_NAME_LEN
      rbd: remove linger unconditionally

Alex Williamson (1):
      KVM: Fix user memslot overlap check

Alexander Graf (1):
      KVM: PPC: 44x: fix DCR read/write

Alexey Khoroshilov (1):
      jffs2: hold erase_completion_lock on exit

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=3Dy CONFIG_CRASH_DUMP=3Dn build

Armen Baloyan (1):
      SCSI: qla2xxx: Properly set result field of bsg_job reply structure f=
or success and failure.

Axel Lin (6):
      ASoC: arizona: Do proper shift for setting AIF rate
      ASoC: wm2200: Fix setting dai format in wm2200_set_fmt
      ASoC: sta529: Fix update register bits in sta529_set_dai_fmt
      regulator: max8997: Use uV in voltage_map_desc
      regulator: max8998: Use uV in voltage_map_desc
      regulator: max8998: Ensure enough delay time for max8998_set_voltage_=
buck_time_sel

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value

Bj=C3=B8rn Mork (3):
      watchdog: Fix disable/enable regression
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core

Chris Boot (1):
      sbp-target: fix error path in sbp_make_tpg()

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Chris Wilson (5):
      drm/i915: Close race between processing unpin task and queueing the f=
lip
      drm/i915: Flush outstanding unpin tasks before pageflipping
      drm: Only evict the blocks required to create the requested hole
      drm/i915; Only increment the user-pin-count after successfully pinnin=
g the bo
      drm/i915: Treat crtc->mode.clock =3D=3D 0 as disabled

Christian Borntraeger (2):
      s390/kvm: dont announce RRBM support
      s390/kvm: Fix address space mixup

Christian K=C3=B6nig (1):
      drm/radeon: stop page faults from hanging the system (v2)

Christian Lamparter (1):
      carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH

Dan Williams (1):
      i2400m: add Intel 6150 device IDs

Daniel Vetter (5):
      drm/i915: don't disable disconnected outputs
      drm/i915: Revert shrinker changes from "Track unbound pages"
      drm/i915: disable cpt phase pointer fdi rx workaround
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"
      drm/i915: force restore on lid open

Dave Airlie (1):
      drm/i915: fix flags in dma buf exporting

David Henningsson (1):
      Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat c=
odecs"

David Jeffery (1):
      SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

David Zafman (1):
      libceph: Unlock unprocessed pages in start_read() error path

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Ed L. Cashin (1):
      aoe: remove vestigial request queue allocation

Emmanuel Grumbach (3):
      iwlwifi: don't handle masked interrupt
      iwlwifi: silently ignore fw flaws in Tx path
      iwlwifi: fix the reclaimed packet tracking upon flush queue

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Felix Fietkau (3):
      ath5k: fix tx path skb leaks
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
      ath9k_hw: Fix signal strength / channel noise reporting

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Gabor Juhos (2):
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x
      ath9k: ar9003: fix OTP register offsets for AR9340

Geert Uytterhoeven (1):
      mfd: Remove Unicode Byte Order Marks from da9055

Giridhar Malavali (1):
      SCSI: qla2xxx: Change in setting UNLOADING flag and FC vports logout =
sequence while unloading qla2xxx driver.

Greg Kroah-Hartman (1):
      Linux 3.7.3

Guo Chao (1):
      ext4: release buffer in failed path in dx_probe()

Hans de Goede (3):
      udldrmfb: Fix EDID not working with monitors with EDID extension bloc=
ks
      udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the sta=
ck
      udldrmfb: udl_get_edid: drop unneeded i--

Hante Meuleman (1):
      brcmfmac: fix parsing rsn ie for ap mode.

Helmut Schaa (1):
      rt2x00: Only specify interface combinations if more then one interfac=
e is possible

Huacai Chen (1):
      MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

Ian Abbott (3):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
      staging: comedi: comedi_test: fix race when cancelling command

Ian Campbell (1):
      xen/netfront: improve truesize tracking

J. Bruce Fields (1):
      svcrpc: Revert "sunrpc/cache.h: replace simple_strtoul"

Jack Morgenstein (2):
      IB/mlx4: Fix spinlock order to avoid lockdep warnings
      mlx4_core: Fix potential deadlock in mlx4_eq_int()

Jan Beulich (1):
      USB: ehci: make debug port in-use detection functional again

Jan Kara (2):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jerome Glisse (5):
      drm/radeon: fix amd afusion gpu setup aka sumo v2
      drm/radeon: restore modeset late in GPU reset path
      drm/radeon: don't leave fence blocked process on failed GPU reset
      drm/radeon: avoid deadlock in pm path when waiting for fence
      radeon/kms: force rn50 chip to always report connected on analog outp=
ut

Joe Thornber (2):
      dm thin: replace dm_cell_release_singleton with cell_defer_except
      dm thin: fix race between simultaneous io and discards to same block

Johannes Berg (3):
      iwlwifi: fix PCIe interrupt handle return value
      mac80211: fix station destruction in AP/mesh modes
      mac80211: use del_timer_sync for final sta cleanup timer deletion

Kees Cook (1):
      audit: create explicit AUDIT_SECCOMP event type

Konstantin Khlebnikov (1):
      EDAC: Fix kernel panic on module unloading

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled

Larry Finger (2):
      staging: r8712u: Add new device ID
      b43: Fix firmware loading when driver is built into the kernel

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Fix endianness conversion issue

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

Linus Torvalds (1):
      vfs: add missing virtual cache flush after editing partial pages

Lothar Wa=C3=9Fmann (1):
      video: mxsfb: fix crash when unblanking the display

Malcolm Priestley (6):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
      staging: vt6656: 64 bit fixes : correct all type sizes
      staging: vt6656: 64 bit fixes: fix long warning messages.
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of=
 timer.

Marcin Slusarz (3):
      drm/nv17-50: restore fence buffer on resume
      drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards
      drm/nouveau: add locking around instobj list operations

Marek Vasut (1):
      HID: add quirk for Freescale i.MX23 ROM recovery

Mark Brown (9):
      regulator: wm831x: Set the new rather than old value for DVS VSEL
      ASoC: wm8994: Use the same DCS codes for all WM1811 variants
      mfd: wm8994: Add support for WM1811 rev E
      regmap: debugfs: Avoid overflows for very small reads
      ASoC: arizona: Correct FLL source definitions
      ASoC: arizona: Remove DSP B and left justified AIF modes
      ASoC: wm2000: Fix sense of speech clarity enable
      ASoC: wm2200: Remove DSP B and left justified AIF modes
      ASoC: wm5100: Remove DSP B and left justified formats

Mattia Dongili (1):
      sony-laptop: fix SNC buffer calls when SN06 returns Integers

Max Filippov (1):
      mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment

Maxime Bizon (1):
      pstore/ram: Fix undefined usage of rounddown_pow_of_two(0)

Mel Gorman (1):
      mm: compaction: partially revert capture of suitable high-order page

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
      ALSA: pxa27x: fix ac97 warm reset

Mike Snitzer (1):
      dm: disable WRITE SAME

Mikulas Patocka (1):
      dm persistent data: rename node to btree_node

Namjae Jeon (2):
      udf: fix memory leak while allocating blocks during write
      udf: don't increment lenExtents while writing to a hole

Nathan Williams (1):
      mtd cs553x_nand: Initialise ecc.strength before nand_scan()

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()

Niels Ole Salscheider (1):
      drm/radeon: Properly handle DDC probe for DP bridges

Nitin Gupta (1):
      staging: zram: fix invalid memory references during disk write

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Patrick Lai (1):
      ASoC: pcm: allow backend hardware to be freed in pause state

Paulo Zanoni (1):
      drm/i915: make the panel fitter work on pipes B and C on IVB

Pawel Moll (1):
      kbuild: Do not remove vmlinux when cleaning external module

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Rafael J. Wysocki (1):
      PM: Move disabling/enabling runtime PM to late suspend/early resume

Rafa=C5=82 Mi=C5=82ecki (1):
      bcma: mips: fix clearing device IRQ

Rajkumar Manoharan (1):
      ath9k_hw: Enable hw PLL power save for AR9462

Ralf Baechle (1):
      Revert "MIPS: Optimise TLB handlers for MIPS32/64 R2 cores."

Roland Dreier (2):
      iscsi-target: Always send a response before terminating iSCSI connect=
ion
      iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->s=
tat_sn)

Sage Weil (3):
      libceph: fix protocol feature mismatch failure path
      libceph: fix osdmap decode error paths
      libceph: remove 'osdtimeout' option

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Sangbeom Kim (1):
      regulator: s2mps11: Fix ramp delay value shift operation

Sarah Sharp (8):
      USB: Handle auto-transition from hot to warm reset.
      USB: Ignore xHCI Reset Device status.
      USB: Allow USB 3.0 ports to be disabled.
      USB: Increase reset timeout.
      USB: Ignore port state until reset completes.
      USB: Handle warm reset failure on empty port.
      xhci: Avoid "dead ports", add roothub port polling.
      xhci: Handle HS bulk/ctrl endpoints that don't NAK.

Sasha Levin (1):
      SCSI: prevent stack buffer overflow in host_reset

Scott Wood (1):
      KVM: PPC: e500: fix allocation size error on g2h_tlb1_map

Sebastian Andrzej Siewior (2):
      target/file: Fix 32-bit highmem breakage for SGL -> iovec mapping
      usb: gadget: dummy: fix enumeration with g_multi

Sebastian Ott (1):
      s390/cio: fix pgid reserved check

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Sergey Senozhatsky (1):
      staging: zram: factor-out zram_decompress_page() function

Seth Forshee (1):
      samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Seung-Woo Kim (1):
      drm/prime: drop reference on imported dma-buf come from gem

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Sivaram Nair (1):
      cpuidle / coupled: fix ready counter decrement

Stanislav Kinsbursky (1):
      SUNRPC: continue run over clients list on PipeFS event instead of bre=
ak

Stanislaw Gruszka (3):
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      mac80211: fix ibss scanning
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe=
 fails"

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.

Steve Hodgson (3):
      SCSI: qla2xxx: Free rsp_data even on error in qla2x00_process_loopbac=
k()
      iscsi-target: Fix bug in handling of ExpStatSN ACK during u32 wrap-ar=
ound
      qla2xxx: Look up LUN for abort requests

Sujith Manoharan (1):
      ath9k_hw: Fix RX gain initvals for AR9485

Takashi Iwai (1):
      ALSA: hda - Disable runtime D3 for Intel CPT & co

Tatyana Nikolova (2):
      RDMA/nes: Fix for crash when registering zero length MR for CQ
      RDMA/nes: Fix for terminate timer crash

Theodore Ts'o (3):
      ext4: fix possible use after free with metadata csum
      ext4: lock i_mutex when truncating orphan inodes
      ext4: avoid hang when mounting non-journal filesystems with orphan li=
st

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Tomi Valkeinen (1):
      OMAP: board-files: fix i2c_bus for tfp410

Trond Myklebust (3):
      SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info
      SUNRPC: Ensure that we free the rpc_task after cleanups are done
      SUNRPC: Ensure we release the socket write lock if the rpc_task exits=
 early

Wei Yongjun (1):
      iscsit: use GFP_ATOMIC under spin lock

Wolfram Sang (1):
      mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup proble=
ms

Woodhouse, David (1):
      intel-iommu: Free old page tables before creating superpage

Xi Wang (1):
      SCSI: mvsas: fix undefined bit shift

Xiaotian Feng (1):
      libata: fix Null pointer dereference on disk error

Yan, Zheng (5):
      ceph: Don't update i_max_size when handling non-auth cap
      ceph: Fix infinite loop in __wake_requests
      ceph: Don't add dirty inode to dirty list if caps is in migration
      ceph: Fix __ceph_do_pending_vmtruncate
      ceph: call handle_cap_grant() for cap import message

Yi Zou (1):
      target/tcm_fc: fix the lockdep warning due to inconsistent lock state

Zhang Rui (1):
      ACPI : do not use Lid and Sleep button for S5 wakeup

=C3=89ric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+DDWAAoJEDjbvchgkmk+I0IP/1pkoDk6+Jo3gz4zm/9JKBci
/QmfFtZoydqjXwHLOMp5Dc+KcAs1wnYRpQdRO+3uDjM8IRHmS3pS6iche/XJZEuK
7eNEcdSQ0a+IWKuo8jGkdYQGjfHSiZ7+iKOcK0nq+0qHA/podrFQYXEJvjYB9ghA
MYGJZX+rup/Pi2jdMy2xQyXi9UUe4pQkDk+Yy5z+wBK6eAFWiLfa2YcPMlI2igNO
JrHRVwB5ZK1E+/pimsp22+M2mg0PYw2kFjyete11YHQZt49/z8XFKM54T03xxzvB
vBxFEyXfF4tYUlB/3EmwYcfZ4xoHBwXL8Mc/YcxDWmW6/xsOp1CRaLhlLQADxiTt
2hHRv7CHzobmTW8hKkCmndkgout5Hk+enzIYHylLGVH9RqfE8gjW6U1z2BjAgMYU
aE/HVKBGc40Zc2DpQfJONiUf5vxqR177w3zXScZK7XBnbeLIzqiGEDkDxMzpYiPC
AulGqiGCrKKCRyWswENZgZ/R+njXKfEq4X9UiI6ePpBPpIA24UPfsTYJBfX4qiWX
5+fokl4Lk0lc5LfXCTZDDuDzIH0SfydBATEOyelVbvfb4A610CmfJ/YZAs5FGQUx
QIVRQwZqaWAw7/lp6mHgIYjbyoEKI5cBJhatBBCBI0iWtC7ny+crfuRp08OlmYCa
ECz9GMypn/NcdmXxX669
=2tNU
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
