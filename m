Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3AQRNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:13:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:36361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab3AQRMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:12:40 -0500
Date: Thu, 17 Jan 2013 09:12:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.26
Message-ID: <20130117171234.GA27297@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.26 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-bus-rbd              |    6=20
 Makefile                                             |    2=20
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h          |    3=20
 arch/arm/mach-pxa/pxa27x.c                           |    4=20
 arch/mips/kernel/process.c                           |    4=20
 arch/powerpc/kernel/head_64.S                        |    2=20
 arch/powerpc/kernel/time.c                           |    5=20
 arch/powerpc/kvm/44x_emulate.c                       |    2=20
 arch/powerpc/platforms/40x/ppc40x_simple.c           |    3=20
 arch/x86/kernel/cpu/amd.c                            |   14=20
 drivers/acpi/scan.c                                  |    7=20
 drivers/ata/libata-core.c                            |    1=20
 drivers/ata/libata-eh.c                              |    1=20
 drivers/ata/libata-scsi.c                            |    6=20
 drivers/ata/sata_promise.c                           |   15=20
 drivers/base/regmap/regmap-debugfs.c                 |    2=20
 drivers/bcma/driver_mips.c                           |    2=20
 drivers/block/aoe/aoe.h                              |    2=20
 drivers/block/aoe/aoeblk.c                           |    5=20
 drivers/block/rbd.c                                  |  293 ++++++--------=
-----
 drivers/firewire/net.c                               |   13=20
 drivers/gpu/drm/drm_edid.c                           |   22 +
 drivers/gpu/drm/i915/i915_drv.c                      |   10=20
 drivers/gpu/drm/i915/i915_drv.h                      |   11=20
 drivers/gpu/drm/i915/i915_gem.c                      |    4=20
 drivers/gpu/drm/i915/i915_irq.c                      |   44 +-
 drivers/gpu/drm/i915/i915_reg.h                      |   23 +
 drivers/gpu/drm/i915/intel_bios.c                    |   36 ++
 drivers/gpu/drm/i915/intel_display.c                 |  190 +++++++-----
 drivers/gpu/drm/i915/intel_hdmi.c                    |   11=20
 drivers/gpu/drm/i915/intel_lvds.c                    |    8=20
 drivers/gpu/drm/i915/intel_ringbuffer.c              |   22 +
 drivers/gpu/drm/i915/intel_sdvo.c                    |   30 +
 drivers/gpu/drm/nouveau/nv04_dfp.c                   |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c               |    6=20
 drivers/gpu/drm/radeon/atombios_encoders.c           |    2=20
 drivers/gpu/drm/radeon/evergreen_cs.c                |    1=20
 drivers/gpu/drm/radeon/radeon_connectors.c           |   10=20
 drivers/gpu/drm/radeon/radeon_display.c              |   13=20
 drivers/gpu/drm/radeon/radeon_i2c.c                  |   10=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c      |    8=20
 drivers/gpu/drm/radeon/radeon_mode.h                 |    2=20
 drivers/gpu/drm/udl/udl_connector.c                  |   17 -
 drivers/hid/hid-ids.h                                |    3=20
 drivers/hid/usbhid/hid-quirks.c                      |    1=20
 drivers/hwmon/lm73.c                                 |   16 -
 drivers/infiniband/hw/nes/nes.h                      |    1=20
 drivers/infiniband/hw/nes/nes_hw.c                   |    9=20
 drivers/infiniband/hw/nes/nes_verbs.c                |    9=20
 drivers/iommu/intel-iommu.c                          |   11=20
 drivers/md/dm-ioctl.c                                |    8=20
 drivers/md/persistent-data/dm-btree-internal.h       |   16 -
 drivers/md/persistent-data/dm-btree-remove.c         |   50 +--
 drivers/md/persistent-data/dm-btree-spine.c          |    6=20
 drivers/md/persistent-data/dm-btree.c                |   22 -
 drivers/mfd/mfd-core.c                               |   15=20
 drivers/mfd/wm8994-core.c                            |    1=20
 drivers/mtd/nand/cs553x_nand.c                       |    3=20
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c                |    9=20
 drivers/net/wimax/i2400m/i2400m-usb.h                |    3=20
 drivers/net/wimax/i2400m/usb.c                       |    6=20
 drivers/net/wireless/ath/ath5k/base.c                |    4=20
 drivers/net/wireless/ath/ath5k/mac80211-ops.c        |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h |  172 +++++------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h       |    6=20
 drivers/net/wireless/ath/ath9k/calib.c               |    1=20
 drivers/net/wireless/ath/ath9k/calib.h               |    3=20
 drivers/net/wireless/b43/b43.h                       |    5=20
 drivers/net/wireless/b43/main.c                      |   54 ++-
 drivers/net/wireless/b43/main.h                      |    5=20
 drivers/net/wireless/mwifiex/sta_ioctl.c             |   21 -
 drivers/platform/x86/samsung-laptop.c                |   10=20
 drivers/regulator/wm831x-dcdc.c                      |    2=20
 drivers/s390/cio/device_pgid.c                       |   10=20
 drivers/scsi/mvsas/mv_94xx.h                         |   14=20
 drivers/scsi/mvsas/mv_sas.c                          |    2=20
 drivers/scsi/mvsas/mv_sas.h                          |    2=20
 drivers/scsi/qla2xxx/qla_os.c                        |    4=20
 drivers/scsi/scsi_sysfs.c                            |   11=20
 drivers/staging/comedi/Kconfig                       |    1=20
 drivers/staging/comedi/comedi_fops.c                 |   21 +
 drivers/staging/comedi/comedidev.h                   |    1=20
 drivers/staging/comedi/drivers.c                     |   34 --
 drivers/staging/comedi/drivers/comedi_test.c         |    2=20
 drivers/staging/comedi/drivers/ni_pcimio.c           |   16 -
 drivers/staging/comedi/internal.h                    |    1=20
 drivers/staging/rtl8712/usb_intf.c                   |    2=20
 drivers/staging/speakup/synth.c                      |    4=20
 drivers/staging/vt6656/dpc.c                         |    4=20
 drivers/staging/vt6656/key.c                         |   53 ++-
 drivers/staging/vt6656/key.h                         |    8=20
 drivers/staging/vt6656/mac.c                         |    6=20
 drivers/staging/vt6656/rf.c                          |    3=20
 drivers/staging/vt6656/rxtx.c                        |   18 -
 drivers/staging/vt6656/ttype.h                       |   16 -
 drivers/staging/vt6656/wcmd.c                        |   20 -
 drivers/staging/vt6656/wpa2.h                        |    4=20
 drivers/target/iscsi/iscsi_target.c                  |    2=20
 drivers/target/tcm_fc/tfc_sess.c                     |    2=20
 drivers/usb/class/cdc-acm.c                          |    3=20
 drivers/usb/core/hub.c                               |  120 ++++++-
 drivers/usb/core/message.c                           |   53 ++-
 drivers/usb/gadget/dummy_hcd.c                       |    9=20
 drivers/usb/host/xhci-hub.c                          |   38 ++
 drivers/usb/host/xhci-mem.c                          |    2=20
 drivers/usb/host/xhci-ring.c                         |    9=20
 drivers/usb/host/xhci.c                              |   10=20
 drivers/usb/musb/musb_core.c                         |    5=20
 drivers/usb/serial/ftdi_sio.c                        |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                    |    6=20
 drivers/usb/serial/option.c                          |   18 +
 drivers/video/mxsfb.c                                |    3=20
 fs/ceph/addr.c                                       |   17 -
 fs/ceph/caps.c                                       |   16 -
 fs/ceph/file.c                                       |    4=20
 fs/ceph/inode.c                                      |   30 +
 fs/ceph/mds_client.c                                 |   10=20
 fs/ceph/super.c                                      |    2=20
 fs/eventpoll.c                                       |   22 +
 fs/ext4/acl.c                                        |    6=20
 fs/ext4/extents.c                                    |   22 +
 fs/ext4/ialloc.c                                     |    2=20
 fs/ext4/super.c                                      |   26 -
 fs/gfs2/lops.c                                       |   18 -
 fs/gfs2/trans.c                                      |    8=20
 fs/jbd2/transaction.c                                |    3=20
 fs/jffs2/nodemgmt.c                                  |    6=20
 fs/udf/inode.c                                       |   11=20
 include/linux/ceph/libceph.h                         |    2=20
 kernel/trace/ring_buffer.c                           |    7=20
 mm/compaction.c                                      |    6=20
 mm/huge_memory.c                                     |    3=20
 mm/memory.c                                          |   18 -
 mm/page_alloc.c                                      |    2=20
 net/ceph/ceph_common.c                               |    3=20
 net/ceph/messenger.c                                 |   72 ++--
 net/ceph/osd_client.c                                |  108 ++-----
 net/ceph/osdmap.c                                    |   31 +-
 net/mac80211/ibss.c                                  |    9=20
 net/mac80211/ieee80211_i.h                           |    6=20
 net/mac80211/scan.c                                  |   34 +-
 net/mac80211/sta_info.c                              |    2=20
 net/sunrpc/clnt.c                                    |    2=20
 net/sunrpc/rpc_pipe.c                                |    7=20
 net/sunrpc/sched.c                                   |   30 +
 net/sunrpc/xprt.c                                    |   12=20
 sound/arm/pxa2xx-ac97-lib.c                          |   26 +
 sound/soc/codecs/sigmadsp.c                          |    2=20
 sound/soc/codecs/wm2000.c                            |    4=20
 sound/soc/codecs/wm2200.c                            |    8=20
 sound/soc/codecs/wm5100.c                            |    6=20
 virt/kvm/kvm_main.c                                  |   13=20
 152 files changed, 1519 insertions(+), 984 deletions(-)

Aaron Lu (1):
      libata: set dma_mode to 0xff in reset

Adam Jackson (1):
      drm/edid/quirks: ViewSonic VA2026w

Alan Stern (1):
      USB: fix endpoint-disabling for failed config changes

Alasdair G Kergon (1):
      dm ioctl: prevent unsafe change to dm_ioctl data_size

Alex Deucher (4):
      drm/radeon: fix eDP clk and lane setup for scaled modes
      drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list
      drm/radeon: fix up pll selection on DCE5/6
      drm/radeon: fix ordering in pll picking on dce4+

Alex Elder (18):
      rbd: drop dev reference on error in rbd_open()
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
      rbd: kill create_snap sysfs entry
      rbd: add read_only rbd map option
      rbd: kill notify_timeout option
      ceph: don't reference req after put
      rbd: remove linger unconditionally
      rbd: fix bug in rbd_dev_id_put()
      rbd: do not allow remove of mounted-on image

Alex Williamson (1):
      KVM: Fix user memslot overlap check

Alexander Graf (1):
      KVM: PPC: 44x: fix DCR read/write

Alexey Khoroshilov (1):
      jffs2: hold erase_completion_lock on exit

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Anton Blanchard (1):
      powerpc: Fix CONFIG_RELOCATABLE=3Dy CONFIG_CRASH_DUMP=3Dn build

Axel Lin (1):
      ASoC: wm2200: Fix setting dai format in wm2200_set_fmt

Ben Widawsky (1):
      drm/i915: Fix GT_MODE default value

Benjamin Marzinski (1):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Bing Zhao (1):
      mwifiex: check wait_event_interruptible return value

Bj=C3=B8rn Mork (2):
      USB: option: blacklist network interface on ZTE MF880
      USB: option: add Telekom Speedstick LTE II

Charles Keepax (1):
      mfd: Only unregister platform devices allocated by the mfd core

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Chris Wilson (5):
      drm/i915: Unpin the flip target if we fail to queue the flip
      drm/i915: Wait for all pending operations to the fb before disabling =
the pipe
      drm/i915: SDVO hotplug have different interrupt status bits for i915/=
i965/g4x
      drm/i915: Reduce a pin-leak BUG into a WARN
      drm/i915: Flush the pending flips on the CRTC before modification

Dan Williams (1):
      i2400m: add Intel 6150 device IDs

Daniel Vetter (6):
      drm/i915: disable cpt phase pointer fdi rx workaround
      drm/i915: fix up ivb plane 3 pageflips
      drm/i915: hold forcewake around ring hw init
      drm/i915: don't pwrite tiled objects through the gtt
      drm/i915: call drm_handle_vblank before finish_page_flip
      Revert "drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13"

David Jeffery (1):
      SCSI: qla2xxx: Test and clear FCPORT_UPDATE_NEEDED atomically.

David Rientjes (1):
      thp, memcg: split hugepage for memcg oom on cow

David Zafman (1):
      libceph: Unlock unprocessed pages in start_read() error path

Denis N Ladin (1):
      USB: cdc-acm: Add support for "PSC Scanning, Magellan 800i"

Dzianis Kahanovich (1):
      USB: option: add Nexpring NP10T terminal id

Ed L. Cashin (1):
      aoe: do not call bdi_init after blk_alloc_queue

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD

Eugene Shatokhin (1):
      ext4: fix memory leak in ext4_xattr_set_acl()'s error path

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Felix Fietkau (3):
      ath5k: fix tx path skb leaks
      Revert "ath9k_hw: Update AR9003 high_power tx gain table"
      ath9k_hw: Fix signal strength / channel noise reporting

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch

Gabor Juhos (2):
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x
      ath9k: ar9003: fix OTP register offsets for AR9340

Greg Kroah-Hartman (1):
      Linux 3.4.26

Hans de Goede (3):
      udldrmfb: Fix EDID not working with monitors with EDID extension bloc=
ks
      udldrmfb: udl_get_edid: usb_control_msg buffer must not be on the sta=
ck
      udldrmfb: udl_get_edid: drop unneeded i--

Huacai Chen (1):
      MIPS: Fix poweroff failure when HOTPLUG_CPU configured.

Ian Abbott (4):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: comedi_test: fix race when cancelling command
      staging: comedi: don't hijack hardware device private data
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC

Jan Kara (2):
      ext4: check dioread_nolock on remount
      jbd2: fix assertion failure in jbd2_journal_flush()

Jani Nikula (1):
      drm/i915: only enable sdvo hotplug irq if needed

Jason Liu (1):
      mm: compaction: fix echo 1 > compact_memory return error issue

Jerome Glisse (1):
      radeon/kms: force rn50 chip to always report connected on analog outp=
ut

Jesse Barnes (1):
      drm/i915: move NEEDS_FORCE_WAKE to i915_drv.c

Jianpeng Ma (1):
      SCSI: mvsas: Fix oops when ata commond timeout.

Johannes Berg (1):
      mac80211: use del_timer_sync for final sta cleanup timer deletion

Josh Durgin (6):
      rbd: return errors for mapped but deleted snapshot
      rbd: only reset capacity when pointing to head
      rbd: expose the correct size of the device in sysfs
      rbd: set image size when header is updated
      rbd: use reference counting for the snap context
      rbd: send header version when notifying

Larry Finger (2):
      staging: r8712u: Add new device ID
      b43: Fix firmware loading when driver is built into the kernel

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Fix endianness conversion issue

Laura Abbott (1):
      mm: use aligned zone start for pfn_to_bitidx calculation

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

Marcin Slusarz (1):
      drm/nouveau: fix blank LVDS screen regression on pre-nv50 cards

Marek Vasut (1):
      HID: add quirk for Freescale i.MX23 ROM recovery

Mark Brown (6):
      regulator: wm831x: Set the new rather than old value for DVS VSEL
      mfd: wm8994: Add support for WM1811 rev E
      regmap: debugfs: Avoid overflows for very small reads
      ASoC: wm2000: Fix sense of speech clarity enable
      ASoC: wm2200: Remove DSP B and left justified AIF modes
      ASoC: wm5100: Remove DSP B and left justified formats

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal

Mikael Pettersson (1):
      sata_promise: fix hardreset lockdep error

Mike Dunn (2):
      ALSA: pxa27x: fix ac97 cold reset
      ALSA: pxa27x: fix ac97 warm reset

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

Oliver Neukum (1):
      USB: hub: handle claim of enabled remote wakeup after reset

Paulo Zanoni (2):
      drm/i915: make the panel fitter work on pipes B and C on IVB
      drm/i915: add some barriers when changing DIPs

Quentin.Li (1):
      USB: option: Add new MEDIATEK PID support

Rafa=C5=82 Mi=C5=82ecki (1):
      bcma: mips: fix clearing device IRQ

Sage Weil (7):
      ceph: close old con before reopening on mds reconnect
      ceph: tolerate (and warn on) extraneous dentry from mds
      ceph: propagate layout error on osd request creation
      libceph: fix protocol feature mismatch failure path
      libceph: fix osdmap decode error paths
      libceph: remove 'osdtimeout' option
      rbd: BUG on invalid layout

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

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

Sean Paul (1):
      drm/i915: Add wait_for in init_ring_common

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy: fix enumeration with g_multi

Sebastian Ott (1):
      s390/cio: fix pgid reserved check

Sergei Shtylyov (1):
      usb: musb: core: print new line in the driver banner again

Seth Forshee (1):
      samsung-laptop: Add quirk for broken acpi_video backlight on N250P

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()

Stanislav Kinsbursky (1):
      SUNRPC: continue run over clients list on PipeFS event instead of bre=
ak

Stanislaw Gruszka (1):
      mac80211: fix ibss scanning

Stephan Gatzka (1):
      firewire: net: Fix handling of fragmented multicast/broadcast packets.

Steven Rostedt (1):
      ring-buffer: Fix race between integrity check and readers

Takashi Iwai (1):
      drm/i915: Check VBIOS value for determining LVDS dual channel mode, t=
oo

Tatyana Nikolova (2):
      RDMA/nes: Fix for crash when registering zero length MR for CQ
      RDMA/nes: Fix for terminate timer crash

Theodore Ts'o (2):
      ext4: fix possible use after free with metadata csum
      ext4: lock i_mutex when truncating orphan inodes

Tomasz Mloduchowski (1):
      usb: ftdi_sio: Crucible Technologies COMET Caller ID - pid added

Trond Myklebust (3):
      SUNRPC: Ensure that we free the rpc_task after cleanups are done
      SUNRPC: Ensure we release the socket write lock if the rpc_task exits=
 early
      SUNRPC: Fix validity issues with rpc_pipefs sb->s_fs_info

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


--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+DECAAoJEDjbvchgkmk+1xAP/RSPikf+f/UAB4AdEWuz+SL0
1OaDJuk6On/CcLwr4dCz1qeLbK3GOCNEvCIvDIZaROkA4Sdr7iiyRSUHvMxrbY/l
mm+WocmeMO37voOGvGOvhXP0HGX1svm3T92P6lWGJO9+BgXi1AHijxQm2JDEiOtC
qxmwepz4M3dj+W8Ze5mAdNtf+jm184E+K6eAPqDVdVTv793puOTghTnXNrksTKpG
G4oIpQv5Qe1bYKJb72Oab2pN8+XXeLtOzwK0tA+T42IWSFSoXolYkmqKYCz6aDyk
Jz8hoIE54D6md24XoNNr13r6gnVjxyMDoxjn5J/KXpJ31k8KOlWq+WNZP+sDi9GW
yFqIem95C4J4LtHRpEo1Jv8IGhnrz6rwxhg6sebn+ajeZtPNZJBXeyLL83n2eWvR
fuwXtTQ83EXDgASK1ZYk2DUbdR82oAMJWh9j4GK5xbMG1tAE82HDIRO9sfHZRwjj
QJEIPJ3xtLDc6QqPRRoabT2tPtDBW1zF0wJCeOafxgBa/nUKgsHWlEkjEy324TwR
jdsAeHsbxo+mHB0SA/uf1y3HR4PNkVseVamBo56RGbdspeEU1MoMi7tyOE7zP7KN
Uy1M/OlIrIPa9nJZ9I5M6idd/Z3wizCJKK5Vq+QvqqG3mRtOIRtUb22FxUisRKYM
lOFD/nT3KPHLU3lGkSGn
=rrvm
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
