Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab3LDTxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:53:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab3LDTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:53:28 -0500
Date: Wed, 4 Dec 2013 11:53:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.3
Message-ID: <20131204195326.GA28826@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.3 kernel.

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

 Documentation/sysctl/kernel.txt               |   25 ++-
 Makefile                                      |    2=20
 arch/arm/boot/dts/bcm2835.dtsi                |    4=20
 arch/arm/boot/dts/cros5250-common.dtsi        |   12 +
 arch/arm/kernel/entry-armv.S                  |    1=20
 arch/arm/mach-at91/Makefile                   |    2=20
 arch/arm/mach-at91/at91sam9260.c              |    2=20
 arch/arm/mach-at91/at91sam9261.c              |    2=20
 arch/arm/mach-at91/at91sam9263.c              |    3=20
 arch/arm/mach-at91/at91sam9g45.c              |    3=20
 arch/arm/mach-at91/at91sam9n12.c              |    6=20
 arch/arm/mach-at91/at91sam9rl.c               |    3=20
 arch/arm/mach-at91/at91sam9x5.c               |    6=20
 arch/arm/mach-at91/generic.h                  |    2=20
 arch/arm/mach-at91/include/mach/at91sam9n12.h |    5=20
 arch/arm/mach-at91/include/mach/at91sam9x5.h  |    5=20
 arch/arm/mach-at91/include/mach/sama5d3.h     |    5=20
 arch/arm/mach-at91/sama5d3.c                  |    6=20
 arch/arm/mach-at91/sysirq_mask.c              |   71 +++++++++++
 arch/arm/mach-imx/clk-imx6q.c                 |    2=20
 arch/arm/mach-integrator/integrator_cp.c      |    3=20
 arch/arm/mach-omap2/irq.c                     |    2=20
 arch/arm/mach-omap2/omap_device.c             |   13 +-
 arch/arm/mach-sa1100/assabet.c                |    3=20
 arch/arm/mm/extable.c                         |    7 -
 arch/arm64/include/asm/pgtable.h              |   31 ++--
 arch/avr32/boot/u-boot/head.S                 |   35 ++++-
 arch/avr32/kernel/entry-avr32b.S              |    3=20
 arch/avr32/kernel/head.S                      |   20 ---
 arch/parisc/include/asm/socket.h              |   11 +
 arch/parisc/include/uapi/asm/socket.h         |   11 -
 arch/powerpc/kernel/signal_32.c               |   16 +-
 arch/powerpc/kernel/signal_64.c               |    6=20
 arch/s390/lib/uaccess_pt.c                    |    3=20
 arch/sh/boards/mach-ecovec24/setup.c          |    1=20
 block/blk-core.c                              |    4=20
 crypto/asymmetric_keys/x509_public_key.c      |   38 -----
 drivers/acpi/pci_root.c                       |    3=20
 drivers/acpi/scan.c                           |    2=20
 drivers/ata/ahci.c                            |    6=20
 drivers/ata/libahci.c                         |   16 ++
 drivers/ata/libata-core.c                     |    1=20
 drivers/ata/libata-transport.c                |   16 +-
 drivers/base/dd.c                             |    2=20
 drivers/block/loop.c                          |   19 +-
 drivers/block/xen-blkback/blkback.c           |    3=20
 drivers/cpufreq/highbank-cpufreq.c            |    3=20
 drivers/dma/ioat/dma_v3.c                     |   48 ++-----
 drivers/edac/highbank_l2_edac.c               |   18 +-
 drivers/edac/highbank_mc_edac.c               |   18 +-
 drivers/gpio/gpio-msm-v2.c                    |    2=20
 drivers/gpio/gpio-mvebu.c                     |    2=20
 drivers/gpio/gpio-pl061.c                     |   10 -
 drivers/gpio/gpio-rcar.c                      |    2=20
 drivers/gpio/gpio-twl4030.c                   |    5=20
 drivers/gpu/drm/i915/intel_ddi.c              |   20 +++
 drivers/gpu/drm/i915/intel_display.c          |    4=20
 drivers/gpu/drm/i915/intel_dvo.c              |   16 +-
 drivers/gpu/drm/i915/intel_uncore.c           |   26 ++--
 drivers/gpu/drm/nouveau/nouveau_gem.c         |    3=20
 drivers/gpu/drm/qxl/qxl_fb.c                  |    2=20
 drivers/gpu/drm/qxl/qxl_release.c             |    1=20
 drivers/gpu/drm/radeon/atombios_crtc.c        |    2=20
 drivers/gpu/drm/radeon/atombios_i2c.c         |    6=20
 drivers/gpu/drm/radeon/radeon_asic.c          |    4=20
 drivers/gpu/drm/radeon/radeon_gart.c          |    2=20
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |   28 ++++
 drivers/gpu/drm/radeon/radeon_uvd.c           |    4=20
 drivers/gpu/drm/radeon/sid.h                  |    2=20
 drivers/gpu/drm/radeon/trinity_dpm.c          |    6=20
 drivers/gpu/drm/ttm/ttm_bo.c                  |   32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |   30 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c      |   42 +++++-
 drivers/hid/Kconfig                           |   11 +
 drivers/hid/hid-apple.c                       |   22 +++
 drivers/hid/hid-axff.c                        |    3=20
 drivers/hid/hid-core.c                        |   18 +-
 drivers/hid/hid-holtek-mouse.c                |    4=20
 drivers/hid/hid-ids.h                         |   16 ++
 drivers/hid/hid-lg.c                          |   80 ++++++++++++
 drivers/hid/hid-lg2ff.c                       |    2=20
 drivers/hid/hid-lg4ff.c                       |   40 +++++-
 drivers/hid/hid-multitouch.c                  |   33 ++++-
 drivers/hid/hid-roccat-common.c               |   12 -
 drivers/hid/hid-roccat-kovaplus.c             |    4=20
 drivers/hid/hid-sensor-hub.c                  |   13 +-
 drivers/hid/hid-wiimote-modules.c             |    4=20
 drivers/hid/uhid.c                            |    2=20
 drivers/hid/usbhid/hid-quirks.c               |    2=20
 drivers/i2c/busses/i2c-wmt.c                  |    1=20
 drivers/i2c/muxes/i2c-mux-gpio.c              |    8 -
 drivers/iio/accel/kxsd9.c                     |    7 -
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    7 -
 drivers/infiniband/hw/qib/qib_iba7322.c       |   11 -
 drivers/infiniband/hw/qib/qib_user_sdma.c     |    6=20
 drivers/infiniband/ulp/isert/ib_isert.c       |   36 +++--
 drivers/infiniband/ulp/srp/ib_srp.c           |   20 +--
 drivers/input/evdev.c                         |   16 +-
 drivers/input/mouse/alps.c                    |    1=20
 drivers/input/mouse/cypress_ps2.c             |   19 --
 drivers/input/serio/i8042-x86ia64io.h         |    2=20
 drivers/input/touchscreen/usbtouchscreen.c    |    4=20
 drivers/md/bcache/btree.c                     |   11 +
 drivers/md/dm-cache-target.c                  |   54 ++++++--
 drivers/md/dm-mpath.c                         |   18 ++
 drivers/md/dm-table.c                         |   18 ++
 drivers/md/md.c                               |    3=20
 drivers/md/persistent-data/dm-array.c         |    5=20
 drivers/md/raid5.c                            |    6=20
 drivers/media/dvb-frontends/af9013.c          |   14 +-
 drivers/media/dvb-frontends/af9033.c          |   23 +++
 drivers/media/dvb-frontends/bcm3510.c         |   15 ++
 drivers/media/dvb-frontends/cxd2820r_core.c   |   21 ++-
 drivers/media/dvb-frontends/itd1000.c         |   13 +-
 drivers/media/dvb-frontends/mt312.c           |   10 +
 drivers/media/dvb-frontends/nxt200x.c         |   11 +
 drivers/media/dvb-frontends/rtl2830.c         |   14 +-
 drivers/media/dvb-frontends/rtl2832.c         |   14 +-
 drivers/media/dvb-frontends/s5h1420.c         |   11 +
 drivers/media/dvb-frontends/stb0899_drv.c     |   12 +
 drivers/media/dvb-frontends/stb6100.c         |   11 +
 drivers/media/dvb-frontends/stv0367.c         |   13 +-
 drivers/media/dvb-frontends/stv090x.c         |   12 +
 drivers/media/dvb-frontends/stv6110.c         |   12 +
 drivers/media/dvb-frontends/stv6110x.c        |   13 +-
 drivers/media/dvb-frontends/tda10071.c        |   25 +++
 drivers/media/dvb-frontends/tda18271c2dd.c    |   14 +-
 drivers/media/dvb-frontends/zl10039.c         |   12 +
 drivers/media/pci/cx18/cx18-driver.c          |   20 +--
 drivers/media/pci/cx23885/cimax2.c            |   13 +-
 drivers/media/pci/ttpci/av7110_hw.c           |   19 ++
 drivers/media/tuners/e4000.c                  |   25 +++
 drivers/media/tuners/fc2580.c                 |   25 +++
 drivers/media/tuners/tda18212.c               |   25 +++
 drivers/media/tuners/tda18218.c               |   23 +++
 drivers/media/tuners/tuner-xc2028.c           |    8 +
 drivers/media/usb/dvb-usb-v2/af9015.c         |    3=20
 drivers/media/usb/dvb-usb-v2/af9035.c         |   29 ++++
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |   10 +
 drivers/media/usb/dvb-usb/cxusb.c             |   41 +++++-
 drivers/media/usb/dvb-usb/dibusb-common.c     |   10 +
 drivers/media/usb/dvb-usb/dw2102.c            |   90 ++++++++++++--
 drivers/media/v4l2-core/v4l2-async.c          |   30 ++++
 drivers/mfd/lpc_ich.c                         |   13 ++
 drivers/mfd/rts5249.c                         |   48 +++++++
 drivers/mmc/host/atmel-mci.c                  |   21 ++-
 drivers/mtd/devices/m25p80.c                  |   20 +--
 drivers/mtd/nand/atmel_nand.c                 |    1=20
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   18 +-
 drivers/mtd/nand/nand_base.c                  |   15 ++
 drivers/net/wireless/ath/ath5k/base.c         |    6=20
 drivers/net/wireless/mwifiex/sdio.c           |    3=20
 drivers/net/wireless/mwifiex/uap_txrx.c       |   29 ++++
 drivers/net/wireless/prism54/islpci_dev.c     |    7 -
 drivers/net/wireless/rt2x00/rt2400pci.c       |    2=20
 drivers/net/wireless/rtlwifi/base.c           |   93 ++++++--------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c   |    1=20
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |    6=20
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |    8 -
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |    2=20
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |    2=20
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |    2=20
 drivers/net/wireless/rtlwifi/wifi.h           |    6=20
 drivers/pci/pcie/portdrv_pci.c                |    1=20
 drivers/pinctrl/mvebu/pinctrl-dove.c          |    2=20
 drivers/platform/x86/sony-laptop.c            |   27 ----
 drivers/regulator/pfuze100-regulator.c        |   12 +
 drivers/regulator/ti-abb-regulator.c          |    2=20
 drivers/s390/net/qeth_core_main.c             |    6=20
 drivers/staging/lustre/lustre/ptlrpc/pinger.c |    4=20
 drivers/staging/media/lirc/lirc_zilog.c       |   12 +
 drivers/staging/rtl8188eu/core/rtw_ap.c       |    3=20
 drivers/staging/tidspbridge/Kconfig           |    2=20
 drivers/staging/vt6656/baseband.c             |   11 +
 drivers/staging/vt6656/rndis.h                |    2=20
 drivers/staging/zram/zram_drv.c               |   19 ++
 drivers/staging/zsmalloc/zsmalloc-main.c      |   17 ++
 drivers/target/iscsi/iscsi_target_auth.c      |    5=20
 drivers/target/iscsi/iscsi_target_configfs.c  |    5=20
 drivers/target/iscsi/iscsi_target_device.c    |    6=20
 drivers/target/iscsi/iscsi_target_nego.c      |    2=20
 drivers/target/target_core_transport.c        |    2=20
 drivers/tty/n_tty.c                           |   14 +-
 drivers/tty/tty_io.c                          |    1=20
 drivers/video/backlight/atmel-pwm-bl.c        |   10 -
 drivers/video/console/sticore.c               |  166 ++++++++++++++++-----=
-----
 drivers/video/sticore.h                       |   62 +++++++--
 drivers/video/stifb.c                         |   10 -
 fs/cifs/cifsglob.h                            |    2=20
 fs/cifs/cifssmb.c                             |    8 -
 fs/cifs/inode.c                               |   23 ++-
 fs/cifs/readdir.c                             |   40 +-----
 fs/cifs/smb1ops.c                             |   21 +++
 fs/cifs/smb2inode.c                           |   16 +-
 fs/cifs/smb2proto.h                           |    2=20
 fs/devpts/inode.c                             |    1=20
 fs/ext4/xattr.c                               |    1=20
 fs/gfs2/inode.c                               |    5=20
 fs/namei.c                                    |    1=20
 include/acpi/acpi_bus.h                       |    1=20
 include/linux/mfd/rtsx_pci.h                  |   53 ++++++++
 include/linux/msg.h                           |    6=20
 include/linux/mtd/map.h                       |    4=20
 include/linux/rbtree.h                        |   16 +-
 include/trace/ftrace.h                        |    5=20
 ipc/msgutil.c                                 |   20 +--
 ipc/util.h                                    |    4=20
 kernel/audit.c                                |   27 +++-
 kernel/cgroup.c                               |   35 ++++-
 kernel/cpuset.c                               |    8 -
 kernel/irq/manage.c                           |    2=20
 kernel/power/snapshot.c                       |    9 +
 kernel/power/user.c                           |    1=20
 kernel/time/alarmtimer.c                      |    4=20
 kernel/trace/ftrace.c                         |   64 +++++-----
 kernel/workqueue.c                            |   24 +++
 lib/vsprintf.c                                |   33 ++++-
 mm/mmap.c                                     |   10 -
 mm/zswap.c                                    |   22 ++-
 net/wireless/scan.c                           |    4=20
 security/selinux/netlabel.c                   |    6=20
 sound/pci/hda/hda_generic.c                   |   79 +++++++++---
 sound/pci/hda/patch_realtek.c                 |   11 +
 sound/soc/blackfin/bf5xx-i2s.c                |    1=20
 sound/soc/codecs/ak4642.c                     |    2=20
 sound/soc/codecs/arizona.c                    |    4=20
 sound/soc/codecs/cs42l52.h                    |    2=20
 sound/soc/codecs/wm5110.c                     |   43 ++++++
 sound/soc/codecs/wm8962.c                     |    2=20
 sound/soc/codecs/wm_adsp.c                    |    5=20
 sound/soc/fsl/imx-pcm-fiq.c                   |   29 ++--
 tools/perf/ui/hist.c                          |    2=20
 tools/perf/util/color.c                       |   11 +
 tools/perf/util/color.h                       |    2=20
 tools/perf/util/event.c                       |    6=20
 235 files changed, 2425 insertions(+), 898 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_a=
ddr

Alex Deucher (4):
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
      drm/radeon: don't share PPLLs on DCE4.1
      drm/radeon: adjust TN dpm parameters for stability (v2)
      drm/radeon/vm: don't attempt to update ptes if ib allocation fails

Anders F. U. Ki=E6r (1):
      HID: add support for LEETGION Hellion Gaming Mouse

Andreas Bie=DFmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Bart Van Assche (2):
      IB/srp: Avoid offlining operational SCSI devices
      IB/srp: Report receive errors correctly

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previ=
ous fence

Brian Austin (1):
      ASoC: cs42l52: Correct MIC CTL mask

Brian Norris (2):
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size

Catalin Marinas (1):
      arm64: Move PTE_PROT_NONE higher up

Charles Keepax (1):
      ASoC: wm5110: Add post SYSCLK register patch for rev D chip

Christian K=F6nig (2):
      drm/radeon: activate UVD clocks before sending the destroy msg
      drm/radeon: fix UVD destroy IB size

Dan Carpenter (3):
      gpio: mvebu: make mvchip->irqbase signed for error handling
      gpio: msm: make msm_gpio.summary_irq signed for error handling
      gpio: rcar: NULL dereference on error in probe()

Dan Williams (3):
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      prism54: set netdev type to "wlan"

Daniel Stone (1):
      Input: evdev - fall back to vmalloc for client event buffer

Daniel Vetter (4):
      drm/i915/dvo: call ->mode_set callback only when the port is running
      drm/i915: flush cursors harder
      drm/i915: restore the early forcewake cleanup
      drm/i915: Replicate BIOS eDP bpp clamping hack for hsw

Dave Airlie (2):
      qxl: avoid an oops in the deferred io code.
      drm/qxl: fix memory leak in release list handling

Dave Jiang (1):
      ioatdma: Fix bug in selftest after removal of DMA_MEMSET.

David Herrmann (2):
      HID: wiimote: fix inverted pro-controller axes
      HID: uhid: fix leak for 64/32 UHID_CREATE

David Howells (1):
      X.509: Remove certificate date checks

Dmitry Torokhov (1):
      Revert "Input: ALPS - add support for model found on Dell XT2"

Don Zickus (1):
      perf tools: Synthesize anon MMAP records again

Doug Anderson (1):
      ARM: dts: Add max77686 RTC interrupt to cros5250-common

Elias Vanderstuyft (1):
      HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Felix Fietkau (1):
      ath5k: fix regression in tx status processing

Forest Bond (3):
      HID: don't ignore eGalax/D-Wav/EETI HIDs
      Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs
      HID: hid-multitouch: add support for SiS panels

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Greg Kroah-Hartman (2):
      Staging: tidspbridge: disable driver
      Linux 3.12.3

Gwendal Grignou (1):
      libata: Fix display of sata speed

Heiko Carstens (1):
      s390/uaccess: add missing page table walk range check

Helge Deller (2):
      parisc: sticon - unbreak on 64bit kernel
      parisc: break out SOCK_NONBLOCK define to own asm header file

Huang Shijie (2):
      mtd: gpmi: fix kernel BUG due to racing DMA operations
      mtd: gpmi: fix the NULL pointer

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Ionut Nicu (2):
      i2c: mux: gpio: use reg value for i2c_add_mux_adapter
      i2c: mux: gpio: use gpio_set_value_cansleep()

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

James Ralston (2):
      ahci: Add Device IDs for Intel Wildcat Point-LP
      mfd: lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH

Jan Kara (3):
      rbtree: fix rbtree_postorder_for_each_entry_safe() iterator
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_f=
ast()
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()

Jeff Layton (2):
      audit: add child record before the create to handle case where create=
 fails
      audit: log the audit_names record type

Jerome Glisse (2):
      radeon/i2c: do not count reg index in number of i2c byte we are writi=
ng.
      radeon: workaround pinning failure on low ram gpu

Jiada Wang (1):
      ARM: i.MX6q: fix the wrong parent of can_root clock

Joe Thornber (2):
      dm array: fix bug in growing array
      dm cache: fix a race condition between queuing new migrations and qui=
escing for a shutdown

Johan Hovold (4):
      ARM: at91: fix hanged boot due to early rtc-interrupt
      ARM: at91: fix hanged boot due to early rtt-interrupt
      backlight: atmel-pwm-bl: fix gpio polarity in remove
      backlight: atmel-pwm-bl: fix reported brightness

Johannes Berg (1):
      cfg80211: fix scheduled scan pointer access

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Joseph Salisbury (1):
      Input: cypress_ps2 - do not consider data bad if palm is detected

Josh Wu (1):
      mtd: atmel_nand: fix bug driver will in a dead lock if no nand detect=
ed

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

KaiChung Cheng (1):
      HID: multicouh: add PID VID to support 1 new Wistron optical touch de=
vice

Kailang Yang (2):
      ALSA: hda/realtek - Set pcbeep amp for ALC668
      ALSA: hda/realtek - Add support of ALC231 codec

Kent Overstreet (1):
      bcache: Fix dirty_data accounting

Kuninori Morimoto (1):
      sh: ecovec: fixup compile error on sdhi

Larry Finger (6):
      staging: r8188eu: Fix AP mode
      rtlwifi: rtl8188ee: Fix smatch warning in rtl8188ee/hw.c
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP

Linus Walleij (1):
      gpio: pl061: move irqdomain initialization

Ludovic Desroches (1):
      mmc: atmel-mci: abort transfer on timeout error

Luosong (1):
      HID: multitouch: Fix GeneralTouch products and add more PIDs

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Marc Zyngier (1):
      ARM: 7876/1: clear Thumb-2 IT state on exception handling

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Mark Langsdorf (1):
      cpufreq: highbank-cpufreq: Enable Midway/ECX-2000

Markus Pargmann (1):
      ARM: OMAP2+: irq, AM33XX add missing register check

Mathias Krause (3):
      ipc, msg: fix message length check for negative values
      audit: use nlmsg_len() to get message payload length
      audit: fix info leak in AUDIT_GET requests

Mattia Dongili (1):
      sony-laptop: do not scribble keyboard backlight registers on resume

Mauro Carvalho Chehab (19):
      media: mxl111sf: Don't use dynamic static allocation
      media: af9035: Don't use dynamic static allocation
      media: af9015: Don't use dynamic static allocation
      media: dw2102: Don't use dynamic static allocation
      media: dibusb-common: Don't use dynamic static allocation
      media: cxusb: Don't use dynamic static allocation
      media: av7110_hw: Don't use dynamic static allocation
      media: cimax2: Don't use dynamic static allocation
      media: cx18: struct i2c_client is too big for stack
      media: lirc_zilog: Don't use dynamic static allocation
      media: v4l2-async: Don't use dynamic static allocation
      media: tuner-xc2028: Don't use dynamic static allocation
      media: tuners: Don't use dynamic static allocation
      media: stv090x: Don't use dynamic static allocation
      media: stv0367: Don't use dynamic static allocation
      media: stb0899_drv: Don't use dynamic static allocation
      media: dvb-frontends: Don't use dynamic static allocation
      media: dvb-frontends: Don't use dynamic static allocation
      media: s5h1420: Don't use dynamic static allocation

Michael Hudson-Doyle (1):
      perf tools: Remove cast of non-variadic function to variadic

Michael Neuling (1):
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Mike Marciniszyn (1):
      IB/qib: Fix txselect regression

Mikulas Patocka (4):
      loop: fix crash if blk_alloc_queue fails
      loop: fix crash when using unassigned loop device
      dm: allocate buffer for messages with small number of arguments using=
 GFP_NOIO
      blk-core: Fix memory corruption if blkcg_init_queue fails

Nanno Langstraat (1):
      HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag"=
) keys.

Nariman Poushin (1):
      ASoC: wm_adsp: Interpret ADSP memory region lengths as 32 bit words

NeilBrown (2):
      md: fix calculation of stacking limits on level change.
      md: test mddev->flags more safely in md_check_recovery.

Nicholas Bellinger (3):
      iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
      target: Fix delayed Task Aborted Status (TAS) handling bug
      ib_isert: Avoid duplicate iscsit_increment_maxcmdsn call

Nicolin Chen (1):
      ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Nishanth Menon (2):
      ARM: OMAP2+: omap_device: maintain sane runtime pm status around susp=
end/resume
      regulator: ti-abb: Fix operator precedence typo

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced =
situations

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Pavel Shilovsky (1):
      CIFS: Fix symbolic links usage

Peng Tao (1):
      staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic

Peter Hurley (4):
      n_tty: Fix 4096-byte canonical reads
      n_tty: Fix echo overrun tail computation
      tty: Reset hupped state on open
      n_tty: Ensure reader restarts worker for next reader

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Rafael J. Wysocki (2):
      PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()
      PM / Hibernate: Do not crash kernel in free_basic_memory_bitmaps()

Rashika Kheria (1):
      Staging: zram: Fix memory leak by refcount mismatch

Richard Fitzgerald (1):
      ASoC: arizona: Set FLL to free-run before disabling

Robert Richter (1):
      edac, highbank: Fix interrupt setup of mem and l2 controller

Rodolfo Giometti (1):
      mmc: atmel-mci: fix oops in atmci_tasklet_func

Roel Kluin (2):
      pinctrl: dove: unset twsi option3 for gconfig as well
      tty: incorrect test of echo_buf() result for ECHO_OP_START

Russell King (1):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Samuel Li (1):
      drm/radeon: hook up backlight functions for CI and KV family.

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH dr=
ive

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Simon Wood (3):
      HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
      HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
      HID: lg: fix ReportDescriptor for Logitech Formula Vibration

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: fix report size

Stanislaw Gruszka (1):
      rt2400pci: fix RSSI read

Stefan Achatz (3):
      HID: roccat: add new device return value
      HID: roccat: fix Coverity CID 141438
      HID: roccat: add missing special driver declarations

Stephen Warren (1):
      ARM: bcm2835: add missing #xxx-cells to I2C nodes

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (Red Hat) (2):
      ftrace: Fix function graph with loading of modules
      tracing: Allow events to have NULL strings

Steven Whitehouse (1):
      GFS2: Fix ref count bug relating to atomic_open

Takashi Iwai (5):
      ASoC: blackfin: Fix missing break
      ALSA: hda - Fix hp-mic mode without VREF bits
      ALSA: hda - Create Headhpone Mic Jack Mode when really needed
      ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
      ALSA: hda - Check leaf nodes to find aamix amps

Tejun Heo (3):
      workqueue: fix ordered workqueues in NUMA setups
      cgroup: use a dedicated workqueue for cgroup destruction
      cgroup: fix cgroup_subsys_state leak for seq_files

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (3):
      drm/vmwgfx: Resource evict fixes
      drm/ttm: Fix memory type compatibility check
      drm/ttm: Fix ttm_bo_move_memcpy

Thomas Pfaff (1):
      genirq: Set the irq thread policy without checking CAP_SYS_NICE

Tim Harvey (1):
      regulator: pfuze100: allow misprogrammed ID

Tom Gundersen (1):
      Input: i8042 - add PNP modaliases

Tony Lindgren (1):
      gpio: twl4030: Fix regression for twl gpio output

Toshi Kani (1):
      ACPI / hotplug: Fix conflicted PCI bridge notify handlers

Tristan Rice (1):
      HID: enable Mayflash USB Gamecube Adapter

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Ujjal Roy (1):
      mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Vegard Nossum (1):
      xen/blkback: fix reference counting

Vu Pham (2):
      IB/srp: Remove target from list before freeing Scsi_Host structure
      iser-target: Avoid using FRMR for single dma entry requests

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wei WANG (1):
      mfd: rtsx: Modify rts5249_optimize_phy

Wei Yongjun (1):
      i2c: wmt: add missing clk_disable_unprepare() on error

Weijie Yang (1):
      mm/zswap: bugfix: memory leak when invalidate and reclaim occur concu=
rrently

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

majianpeng (2):
      raid5: Use slow_path to release stripe when mddev->thread is null
      md/raid5: Before freeing old multi-thread worker, it should flush the=
m.

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSn4g2AAoJEDjbvchgkmk+qu0QALhFW0NGATmLk57oIOg5HHRn
QOgDYx8/enWpJ5W+1Gv1UBG27Db5MXWXwj02PYAPPQsnmQL7SsT4W0FNP9M5iQtw
pafY37XikeVjusELOsfhX8DLYpylag7Esz3coXuHDQ30FOuR7AazhD/c8KzhtXaP
Fl13bF3iI5SoWInx8GKwVCFfjqRJK2JsPWFq9SIJbzeo189kxo0dwdwDnDK14UMW
VKZrKMfjMmRuGywrSPNaHbYmjgC4qe9b+SEf4MkcjjVQyYYQ96/iAgIiarnkdOAU
EMxihthNvEnRhEYtoRqweltJPyfphCIwuIv8xcei3/5GRtzy4hW1fDAPZVUJLKdM
jM5WmuEe+scDkq4QjcoFYR8KuFwx70xzaKXsJrzp66OWy9ocUpWdKVzJ/KHprsMD
6GRCY8QUkUsO9fk/3XdiWIUZsLW//90VlJiiXVcHOW75oBwqYC321XKJ4Vg9bfL/
7q5wretBTkXdXzxPYg7xy+0i2W0E6ml4+8eGz4VOV5tjBPpVH7c5pUt2RLJ1VlU9
231MKuTY4Nt6QCwIg77dYNqWyynfP+dwf2o7Hp2yxpPZGPREVWf9T302B70+GEa7
ELXoi4+04MJhy0AFn7BRFwmpA+5BuCOhjmMRJ0ucxXeyiE9qUl3oCAcL1f3iN4sQ
4TbD+5cO4op/XnZq30nJ
=uVqb
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
