Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3LDTxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:53:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab3LDTwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:52:55 -0500
Date: Wed, 4 Dec 2013 11:52:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.22
Message-ID: <20131204195254.GA28772@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.22 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
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
 arch/arm/mach-sa1100/assabet.c                |    3=20
 arch/arm/mm/extable.c                         |    7 -
 arch/avr32/boot/u-boot/head.S                 |   35 ++++-
 arch/avr32/kernel/entry-avr32b.S              |    3=20
 arch/avr32/kernel/head.S                      |   20 ---
 arch/parisc/include/asm/socket.h              |   11 +
 arch/parisc/include/uapi/asm/socket.h         |   11 -
 arch/powerpc/kernel/signal_32.c               |   16 +-
 arch/powerpc/kernel/signal_64.c               |    6=20
 arch/s390/lib/uaccess_pt.c                    |    3=20
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
 drivers/clk/mvebu/clk-core.c                  |    4=20
 drivers/cpufreq/highbank-cpufreq.c            |    3=20
 drivers/dma/ioat/dma_v3.c                     |   46 ++-----
 drivers/edac/highbank_l2_edac.c               |   18 +-
 drivers/edac/highbank_mc_edac.c               |   18 +-
 drivers/gpio/gpio-mvebu.c                     |    2=20
 drivers/gpio/gpio-pl061.c                     |   10 -
 drivers/gpio/gpio-rcar.c                      |    2=20
 drivers/gpio/gpio-twl4030.c                   |    5=20
 drivers/gpu/drm/i915/intel_display.c          |    4=20
 drivers/gpu/drm/nouveau/nouveau_gem.c         |    3=20
 drivers/gpu/drm/qxl/qxl_fb.c                  |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c        |    2=20
 drivers/gpu/drm/radeon/evergreen_hdmi.c       |    3=20
 drivers/gpu/drm/radeon/r600_hdmi.c            |   21 ++-
 drivers/gpu/drm/radeon/radeon_gart.c          |    2=20
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |   28 ++++
 drivers/gpu/drm/radeon/radeon_uvd.c           |    2=20
 drivers/gpu/drm/radeon/sid.h                  |    2=20
 drivers/gpu/drm/ttm/ttm_bo.c                  |   32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |   30 ++--
 drivers/hid/Kconfig                           |   10 +
 drivers/hid/hid-apple.c                       |   22 +++
 drivers/hid/hid-axff.c                        |    3=20
 drivers/hid/hid-core.c                        |   17 +-
 drivers/hid/hid-ids.h                         |   13 ++
 drivers/hid/hid-lg.c                          |   80 ++++++++++++
 drivers/hid/hid-lg2ff.c                       |    2=20
 drivers/hid/hid-lg4ff.c                       |   62 +++++++--
 drivers/hid/hid-multitouch.c                  |   33 ++++-
 drivers/hid/hid-roccat-common.c               |   12 -
 drivers/hid/hid-roccat-kovaplus.c             |    4=20
 drivers/hid/hid-sensor-hub.c                  |   13 +-
 drivers/hid/uhid.c                            |    2=20
 drivers/hid/usbhid/hid-quirks.c               |    2=20
 drivers/i2c/muxes/i2c-mux-gpio.c              |    8 -
 drivers/iio/accel/kxsd9.c                     |    7 -
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    7 -
 drivers/infiniband/hw/qib/qib_iba7322.c       |   11 -
 drivers/infiniband/ulp/srp/ib_srp.c           |    9 -
 drivers/input/evdev.c                         |   16 +-
 drivers/input/mouse/cypress_ps2.c             |   19 --
 drivers/input/serio/i8042-x86ia64io.h         |    2=20
 drivers/input/touchscreen/usbtouchscreen.c    |    4=20
 drivers/md/dm-cache-target.c                  |   54 ++++++--
 drivers/md/dm-mpath.c                         |   18 ++
 drivers/md/dm-table.c                         |   18 ++
 drivers/md/md.c                               |    1=20
 drivers/md/persistent-data/dm-array.c         |    5=20
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
 drivers/media/pci/cx23885/cx23885-dvb.c       |    4=20
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
 drivers/mmc/host/atmel-mci.c                  |   21 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |    4=20
 drivers/mtd/nand/nand_base.c                  |   15 ++
 drivers/net/can/flexcan.c                     |   12 -
 drivers/net/wireless/iwlegacy/3945.c          |   31 ++--
 drivers/net/wireless/iwlegacy/4965-mac.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    6=20
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
 drivers/net/xen-netback/interface.c           |   10 -
 drivers/pci/pcie/portdrv_pci.c                |    1=20
 drivers/pinctrl/mvebu/pinctrl-dove.c          |    2=20
 drivers/s390/net/qeth_core_main.c             |    6=20
 drivers/staging/media/lirc/lirc_zilog.c       |   12 +
 drivers/staging/tidspbridge/Kconfig           |    2=20
 drivers/staging/vt6656/baseband.c             |   11 +
 drivers/staging/vt6656/rndis.h                |    2=20
 drivers/staging/zsmalloc/zsmalloc-main.c      |   17 ++
 drivers/target/iscsi/iscsi_target_auth.c      |    5=20
 drivers/target/iscsi/iscsi_target_configfs.c  |    5=20
 drivers/target/iscsi/iscsi_target_device.c    |    6=20
 drivers/target/iscsi/iscsi_target_nego.c      |    2=20
 drivers/video/backlight/atmel-pwm-bl.c        |   10 -
 drivers/video/console/sticore.c               |  166 ++++++++++++++++-----=
-----
 drivers/video/sticore.h                       |   62 +++++++--
 drivers/video/stifb.c                         |   10 -
 fs/cifs/cifssmb.c                             |    8 -
 fs/devpts/inode.c                             |    1=20
 fs/ext4/xattr.c                               |    1=20
 fs/namei.c                                    |    1=20
 include/acpi/acpi_bus.h                       |    1=20
 include/linux/audit.h                         |   26 +++-
 include/linux/ipc_namespace.h                 |    6=20
 include/linux/msg.h                           |    6=20
 include/linux/mtd/map.h                       |    4=20
 include/net/netfilter/nf_conntrack_extend.h   |    2=20
 include/trace/ftrace.h                        |    5=20
 ipc/ipc_sysctl.c                              |   20 +--
 ipc/mqueue.c                                  |    2=20
 ipc/msgutil.c                                 |   20 +--
 ipc/sem.c                                     |   42 ++++--
 ipc/util.c                                    |   27 +++-
 ipc/util.h                                    |    4=20
 kernel/audit.c                                |   27 +++-
 kernel/audit.h                                |    1=20
 kernel/auditsc.c                              |   12 +
 kernel/cgroup.c                               |   28 ++++
 kernel/cpuset.c                               |    8 -
 kernel/power/snapshot.c                       |    6=20
 kernel/time/alarmtimer.c                      |    4=20
 kernel/trace/ftrace.c                         |   64 +++++-----
 kernel/workqueue.c                            |   24 +++
 lib/vsprintf.c                                |   33 ++++-
 mm/mmap.c                                     |   10 -
 net/9p/trans_virtio.c                         |    5=20
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
 sound/soc/fsl/imx-pcm-fiq.c                   |   29 ++--
 tools/perf/ui/hist.c                          |    2=20
 tools/perf/util/color.c                       |   11 +
 tools/perf/util/color.h                       |    2=20
 205 files changed, 2128 insertions(+), 770 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_a=
ddr

Alex Deucher (7):
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
      drm/radeon: don't share PPLLs on DCE4.1
      drm/radeon/vm: don't attempt to update ptes if ib allocation fails
      drm/radeon: use 64-bit math to calculate CTS values for audio (v2)
      drm/radeon: fix N/CTS clock matching for audio
      drm/radeon: use hw generated CTS/N values for audio
      drm/radeon: re-enable sw ACR support on pre-DCE4

Andreas Bie=DFmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Bart Van Assche (1):
      IB/srp: Report receive errors correctly

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previ=
ous fence

Brian Austin (1):
      ASoC: cs42l52: Correct MIC CTL mask

Brian Norris (1):
      mtd: nand: hack ONFI for non-power-of-2 dimensions

Charles Keepax (1):
      ASoC: wm5110: Add post SYSCLK register patch for rev D chip

Christian K=F6nig (1):
      drm/radeon: activate UVD clocks before sending the destroy msg

Dan Carpenter (2):
      gpio: mvebu: make mvchip->irqbase signed for error handling
      gpio: rcar: NULL dereference on error in probe()

Dan Williams (3):
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      prism54: set netdev type to "wlan"

Daniel Stone (1):
      Input: evdev - fall back to vmalloc for client event buffer

Daniel Vetter (1):
      drm/i915: flush cursors harder

Dave Airlie (1):
      qxl: avoid an oops in the deferred io code.

David Herrmann (1):
      HID: uhid: fix leak for 64/32 UHID_CREATE

David Howells (1):
      X.509: Remove certificate date checks

Davidlohr Bueso (1):
      ipc: update locking scheme comments

Doug Anderson (1):
      ARM: dts: Add max77686 RTC interrupt to cros5250-common

Elias Vanderstuyft (1):
      HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel

Emmanuel Grumbach (1):
      iwlwifi: don't WARN on host commands sent when firmware is dead

Eric Dumazet (1):
      iwl3945: better skb management in rx path

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Forest Bond (3):
      HID: don't ignore eGalax/D-Wav/EETI HIDs
      Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs
      HID: hid-multitouch: add support for SiS panels

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Greg Kroah-Hartman (2):
      Staging: tidspbridge: disable driver
      Linux 3.10.22

Gwendal Grignou (1):
      libata: Fix display of sata speed

Heiko Carstens (1):
      s390/uaccess: add missing page table walk range check

Helge Deller (2):
      parisc: sticon - unbreak on 64bit kernel
      parisc: break out SOCK_NONBLOCK define to own asm header file

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Ionut Nicu (2):
      i2c: mux: gpio: use reg value for i2c_add_mux_adapter
      i2c: mux: gpio: use gpio_set_value_cansleep()

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP

Jan Kara (1):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_f=
ast()

Jeff Layton (3):
      audit: fix mq_open and mq_unlink to add the MQ root as a hidden paren=
t audit_names record
      audit: add child record before the create to handle case where create=
 fails
      audit: log the audit_names record type

Jerome Glisse (1):
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

Johannes Koch (1):
      media: cx23885: Fix TeVii S471 regression since introduction of ts2020

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Joseph Salisbury (1):
      Input: cypress_ps2 - do not consider data bad if palm is detected

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

KaiChung Cheng (1):
      HID: multicouh: add PID VID to support 1 new Wistron optical touch de=
vice

Kailang Yang (2):
      ALSA: hda/realtek - Set pcbeep amp for ALC668
      ALSA: hda/realtek - Add support of ALC231 codec

Larry Finger (5):
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

Manfred Spraul (1):
      ipc/sem.c: synchronize semop and semctl with IPC_RMID

Marc Kleine-Budde (1):
      can: flexcan: fix flexcan_chip_start() on imx6

Marc Zyngier (1):
      ARM: 7876/1: clear Thumb-2 IT state on exception handling

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Mark Langsdorf (1):
      cpufreq: highbank-cpufreq: Enable Midway/ECX-2000

Markus Pargmann (1):
      ARM: OMAP2+: irq, AM33XX add missing register check

Mathias Krause (4):
      ipc, msg: fix message length check for negative values
      ipc, msg: forbid negative values for "msg{max,mnb,mni}"
      audit: use nlmsg_len() to get message payload length
      audit: fix info leak in AUDIT_GET requests

Mauro Carvalho Chehab (18):
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

Michael Marineau (1):
      9p: send uevent after adding/removing mount_tag attribute

Michael Neuling (1):
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Michal Kubecek (1):
      netfilter: nf_conntrack: use RCU safe kfree for conntrack extensions

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

NeilBrown (1):
      md: fix calculation of stacking limits on level change.

Nicholas Bellinger (1):
      iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn

Nicolin Chen (1):
      ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced =
situations

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Rafael J. Wysocki (1):
      PM / runtime: Use pm_runtime_put_sync() in __device_release_driver()

Richard Fitzgerald (1):
      ASoC: arizona: Set FLL to free-run before disabling

Robert Richter (1):
      edac, highbank: Fix interrupt setup of mem and l2 controller

Rodolfo Giometti (1):
      mmc: atmel-mci: fix oops in atmci_tasklet_func

Roel Kluin (1):
      pinctrl: dove: unset twsi option3 for gconfig as well

Russell King (1):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH dr=
ive

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Simon Guinot (1):
      clk: armada-370: fix tclk frequencies

Simon Wood (4):
      HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
      HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
      HID:hid-lg4ff: Initialize device properties before we touch autocente=
ring.
      HID: lg: fix ReportDescriptor for Logitech Formula Vibration

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: fix report size

Stanislaw Gruszka (2):
      rt2400pci: fix RSSI read
      iwl4965: better skb management in rx path

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

Takashi Iwai (5):
      ASoC: blackfin: Fix missing break
      ALSA: hda - Fix hp-mic mode without VREF bits
      ALSA: hda - Create Headhpone Mic Jack Mode when really needed
      ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
      ALSA: hda - Check leaf nodes to find aamix amps

Tejun Heo (2):
      workqueue: fix ordered workqueues in NUMA setups
      cgroup: use a dedicated workqueue for cgroup destruction

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (2):
      drm/ttm: Fix memory type compatibility check
      drm/ttm: Fix ttm_bo_move_memcpy

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

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wei Liu (1):
      xen-netback: fix refcnt unbalance for 3.10

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSn4gWAAoJEDjbvchgkmk+zPkP/3dlHHf2hgITh1NB8oJiC+Dp
Lvm4jODJLBD2PtEP5il/4Lsqa1OvGpNsk06X/+4+TVWuhBL3xlpUhpZzEyVplsPK
eS8lNT5bvORm4d2pojgITSW/aBDDv+gqXlIuQiGfdWxjArbRnSReaSMSRhirM9Gv
OGFZBzVdV7uSX0VbLqUweWrfvsxUw4xJ14tJTQ662VAX+y+XrWCvNq01x8SRpxeA
PwJBrvXkASDsFiO5nadAOJDZZs8vvIRNULUECUDMpBy6m9gE7XcLv0WiFqw4OMke
a9gIG63XJyCanF4ShkdYClznXsSY93xzgWh/9OZ1PLQzPjBZDEOu8wHMH5P+7eqS
p2oVC00W9+jZUG2hKUV8HAfaXXtvnUt2urRXS8rbhGn58CNUxsk3xlL0DjVg7rgz
AEul98DrVUM/Bz1C7L0XK42FdRs/0ye+eQzrG5+vEwzs+k5mHjWHPnaJuI+YEeCE
tOSekcTqtTZ/Xk+4Kt6yOAJyTrCK+bWq2QJULHnRtERIIoGgpF8Aw0UegTWWfwbU
LvMSkYVf+osu5EPeUrbqfm7UyOOSLt43BB3qrYXpFj++/RAp/7iJ2ks8BRnYgaTo
s1hLX3btUvCDv1SAJmUPCULA3swbpYGidtRsSTaTttZDEvT1pbS8TR/oGl8ySczZ
M+oipxqOGZ/QXgLHebUn
=7WMm
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
