Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaDNSzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:55:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaDNSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:55:07 -0400
Date: Mon, 14 Apr 2014 11:58:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.87
Message-ID: <20140414185803.GA24816@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.87 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt |    8=20
 Documentation/hwmon/coretemp                            |   12 +
 Makefile                                                |    2=20
 arch/arm/Kconfig                                        |    1=20
 arch/arm/boot/compressed/Makefile                       |    1=20
 arch/arm/boot/compressed/head-sa1100.S                  |    1=20
 arch/arm/boot/compressed/head-shark.S                   |    1=20
 arch/arm/boot/compressed/head.S                         |    1=20
 arch/arm/boot/dts/imx51-babbage.dts                     |    4=20
 arch/arm/include/asm/a.out-core.h                       |   45 ----
 arch/arm/include/asm/a.out.h                            |   34 ---
 arch/arm/include/asm/processor.h                        |    4=20
 arch/arm/kernel/head.S                                  |    3=20
 arch/arm/kernel/topology.c                              |    2=20
 arch/arm/mach-dove/common.c                             |    2=20
 arch/arm/mach-footbridge/common.c                       |    3=20
 arch/arm/mach-footbridge/dc21285.c                      |    2=20
 arch/arm/mach-kirkwood/common.c                         |    4=20
 arch/arm/mach-mv78xx0/common.c                          |    6=20
 arch/arm/mach-orion5x/common.c                          |    3=20
 arch/arm/mach-pxa/reset.c                               |    8=20
 arch/arm/mach-u300/include/mach/u300-regs.h             |    2=20
 arch/arm/mach-w90x900/include/mach/entry-macro.S        |    4=20
 arch/arm/plat-orion/common.c                            |    8=20
 arch/arm/plat-orion/include/plat/common.h               |    6=20
 arch/mips/include/asm/jump_label.h                      |    2=20
 arch/powerpc/include/asm/jump_label.h                   |    2=20
 arch/s390/include/asm/jump_label.h                      |    2=20
 arch/sparc/include/asm/jump_label.h                     |    2=20
 arch/x86/include/asm/cpufeature.h                       |    2=20
 arch/x86/include/asm/jump_label.h                       |    2=20
 drivers/ata/ahci.c                                      |   13 +
 drivers/cpufreq/powernow-k6.c                           |  147 +++++++++++=
+---
 drivers/edac/sb_edac.c                                  |    7=20
 drivers/hid/hid-apple.c                                 |    3=20
 drivers/hid/hid-core.c                                  |   26 +-
 drivers/hid/hid-ids.h                                   |   10 +
 drivers/hid/hid-input.c                                 |   12 +
 drivers/hid/hid-multitouch.c                            |    4=20
 drivers/hid/hid-sony.c                                  |   18 +
 drivers/hid/hidraw.c                                    |   98 +++++-----
 drivers/hid/usbhid/hid-quirks.c                         |    3=20
 drivers/hwmon/applesmc.c                                |   13 +
 drivers/hwmon/coretemp.c                                |   34 +++
 drivers/hwmon/lm78.c                                    |    2=20
 drivers/hwmon/sis5595.c                                 |    2=20
 drivers/hwmon/vt8231.c                                  |    2=20
 drivers/idle/intel_idle.c                               |    3=20
 drivers/media/dvb/dvb-core/dmxdev.c                     |    8=20
 drivers/media/video/gspca/kinect.c                      |    1=20
 drivers/media/video/hdpvr/hdpvr-core.c                  |   22 +-
 drivers/media/video/omap/omap_vout.c                    |   12 -
 drivers/media/video/saa7164/saa7164-core.c              |    4=20
 drivers/media/video/v4l2-device.c                       |   30 +--
 drivers/mmc/host/mxs-mmc.c                              |    8=20
 drivers/net/ethernet/broadcom/tg3.c                     |   74 +++++++
 drivers/net/ethernet/broadcom/tg3.h                     |    8=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c          |    8=20
 drivers/net/wireless/ath/ath9k/ar9003_hw.c              |   15 -
 drivers/net/wireless/ath/ath9k/ar9003_phy.c             |   27 --
 drivers/net/wireless/ath/ath9k/ar9003_phy.h             |    2=20
 drivers/net/wireless/ath/ath9k/calib.c                  |    1=20
 drivers/net/wireless/ath/ath9k/htc.h                    |    1=20
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c           |   18 +
 drivers/net/wireless/ath/ath9k/hw.c                     |    3=20
 drivers/net/wireless/ath/ath9k/hw.h                     |    1=20
 drivers/net/wireless/ath/ath9k/main.c                   |    7=20
 drivers/pps/clients/pps-ldisc.c                         |   10 -
 drivers/pps/pps.c                                       |   47 ++++
 drivers/usb/core/driver.c                               |   38 ++--
 drivers/usb/core/hub.c                                  |   21 +-
 drivers/usb/core/quirks.c                               |  152 +++++++++--=
-----
 drivers/usb/core/usb.h                                  |    4=20
 drivers/usb/dwc3/dwc3-pci.c                             |    4=20
 drivers/usb/dwc3/gadget.c                               |   15 +
 drivers/usb/host/ehci-pci.c                             |    2=20
 drivers/usb/host/ehci-q.c                               |   16 -
 drivers/usb/host/ehci-sched.c                           |    4=20
 drivers/usb/host/ohci-pci.c                             |    2=20
 drivers/usb/host/uhci-pci.c                             |    2=20
 drivers/usb/host/xhci-hub.c                             |   28 --
 drivers/usb/host/xhci-pci.c                             |   32 +++
 drivers/usb/host/xhci.c                                 |   14 +
 drivers/usb/host/xhci.h                                 |    2=20
 drivers/usb/misc/adutux.c                               |    2=20
 drivers/usb/serial/ark3116.c                            |   10 -
 drivers/usb/serial/ch341.c                              |   11 -
 drivers/usb/serial/cypress_m8.c                         |   14 -
 drivers/usb/serial/ftdi_sio.c                           |   68 ++++---
 drivers/usb/serial/io_edgeport.c                        |   12 -
 drivers/usb/serial/io_ti.c                              |   12 -
 drivers/usb/serial/keyspan.c                            |    2=20
 drivers/usb/serial/mct_u232.c                           |   13 -
 drivers/usb/serial/mos7840.c                            |   60 ++++--
 drivers/usb/serial/oti6858.c                            |   10 -
 drivers/usb/serial/pl2303.c                             |   21 +-
 drivers/usb/serial/qcserial.c                           |    1=20
 drivers/usb/serial/spcp8x5.c                            |   19 --
 drivers/usb/serial/ssu100.c                             |   12 -
 drivers/usb/serial/ti_usb_3410_5052.c                   |   19 +-
 drivers/usb/serial/usb-serial.c                         |    1=20
 drivers/usb/wusbcore/wa-rpipe.c                         |    5=20
 drivers/usb/wusbcore/wa-xfer.c                          |    5=20
 drivers/video/omap2/omapfb/omapfb-main.c                |    2=20
 fs/proc/array.c                                         |    2=20
 include/linux/compiler-gcc.h                            |    3=20
 include/linux/compiler-gcc4.h                           |   16 +
 include/linux/hid.h                                     |    2=20
 include/linux/hidraw.h                                  |    4=20
 include/linux/idr.h                                     |   11 +
 include/linux/msg.h                                     |    6=20
 include/linux/mv643xx_eth.h                             |    2=20
 include/linux/pps_kernel.h                              |   17 +
 include/linux/usb/hcd.h                                 |    2=20
 include/linux/usb/serial.h                              |    2=20
 ipc/msgutil.c                                           |   12 -
 ipc/util.h                                              |    4=20
 kernel/audit.c                                          |    2=20
 kernel/printk.c                                         |    2=20
 kernel/workqueue.c                                      |    9=20
 lib/idr.c                                               |   36 ++-
 security/selinux/hooks.c                                |   36 ++-
 sound/drivers/aloop.c                                   |    5=20
 sound/drivers/pcsp/pcsp.c                               |    2=20
 sound/i2c/other/ak4xxx-adda.c                           |    2=20
 sound/pci/hda/hda_intel.c                               |   40 ++--
 sound/pci/hda/patch_conexant.c                          |  114 ++++++++----
 sound/pci/hda/patch_hdmi.c                              |   35 ++-
 sound/pci/hda/patch_realtek.c                           |    1=20
 sound/usb/6fire/comm.c                                  |   38 +++-
 sound/usb/6fire/comm.h                                  |    2=20
 sound/usb/6fire/midi.c                                  |   16 +
 sound/usb/6fire/midi.h                                  |    6=20
 sound/usb/6fire/pcm.c                                   |   41 ++++
 sound/usb/6fire/pcm.h                                   |    2=20
 sound/usb/card.h                                        |    1=20
 sound/usb/endpoint.c                                    |    3=20
 sound/usb/mixer.c                                       |   16 +
 sound/usb/quirks.c                                      |    1=20
 139 files changed, 1333 insertions(+), 678 deletions(-)

Aaron Plattner (2):
      ALSA: hda - Add new GPU codec ID to snd-hda
      ALSA: hda - Add another GPU codec ID to snd-hda

Adrian Thomasset (1):
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Al Viro (1):
      media: omap_vout: find_vma() needs ->mmap_sem held

Alan Stern (4):
      USB: EHCI: bugfix: urb->hcpriv should not be NULL
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alexey Kaminsky (1):
      HID: apple: Add Apple wireless keyboard 2011 ANSI PID

Alexey Khoroshilov (2):
      HID: hidraw: improve error handling in hidraw_init()
      media: hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andreas Fleig (1):
      USB: Add device quirk for Microsoft VX700 webcam

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Arnaud Patard (1):
      ARM: Orion: Set eth packet size csum offload limit

Arnd Bergmann (3):
      ARM: w90x900: fix legacy assembly syntax
      ARM: 7742/1: topology: export cpu_topology
      ARM: 7743/1: compressed/head.S: work around new binutils warning

Artem Bityutskiy (1):
      proc: pid/status: show all supplementary groups

Benjamin Tissoires (2):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Colin Leitner (1):
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting

Dan Carpenter (2):
      ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
      hwmon: Prevent some divide by zeros in FAN_TO_REG()

Daniel Santos (1):
      compiler-gcc.h: Add gcc-recommended GCC_VERSION macro

David Cohen (1):
      usb: dwc3: add support for Merrifield

David Henningsson (2):
      Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat c=
odecs"
      ALSA: hda - Fix internal mic for Lenovo Ideapad U300s

Eldad Zack (1):
      ALSA: usb-audio: skip UAC2 EFFECT_UNIT

Felix Fietkau (2):
      ath9k_htc: fix signal strength handling issues
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5

Fernando Luis Vazquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
      HID: clean up quirk for Sony RF receivers

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

George Spelvin (3):
      pps: Add pps_lookup_dev() function
      pps: Use pps_lookup_dev to reduce ldisc coupling
      pps: Fix a use-after free bug when unregistering a source.

Grazvydas Ignotas (1):
      OMAPFB: fix framebuffer console colors

Greg Kroah-Hartman (1):
      Linux 3.4.87

Guenter Roeck (3):
      hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU mod=
els
      hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Hans Verkuil (1):
      media: hdpvr: register the video node at the end of probe

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Jacob Schloss (1):
      media: gspca_kinect: add Kinect for Windows USB id

James Ralston (2):
      ahci: Add Device IDs for Intel Wellsburg PCH
      ahci: Add Device IDs for Intel Wildcat Point-LP

Jean Delvare (1):
      hwmon: (coretemp) Improve support of recent Atom CPU models

Jiri Kosina (3):
      HID: hidraw: add proper error handling to raw event reporting
      HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW
      HID: usbhid: fix build problem

Johan Hovold (22):
      USB: serial: add modem-status-change wait queue
      USB: ark3116: fix use-after-free in TIOCMIWAIT
      USB: ch341: fix use-after-free in TIOCMIWAIT
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
      USB: io_ti: fix use-after-free in TIOCMIWAIT
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
      USB: mos7840: fix broken TIOCMIWAIT
      USB: mos7840: fix use-after-free in TIOCMIWAIT
      USB: oti6858: fix use-after-free in TIOCMIWAIT
      USB: pl2303: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
      USB: ssu100: fix use-after-free in TIOCMIWAIT
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
      USB: spcp8x5: fix device initialisation at open
      USB: pl2303: fix device initialisation at open
      USB: mos7840: fix memory leak in open
      USB: mos7840: fix race in register handling
      USB: adutux: fix big-endian device-type reporting
      USB: ti_usb_3410_5052: fix big-endian firmware handling
      USB: keyspan: fix null-deref at disconnect and release

Josh Boyer (1):
      HID: usbhid: quirk for MSI GX680R led panel

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Jussi Kivilinna (1):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC231 codec

Konrad Rzeszutek Wilk (1):
      intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing=
 it.

Laurent Pinchart (3):
      usb: Add quirk detection based on interface information
      usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams
      media: v4l: Reset subdev v4l2_dev field to NULL if registration fails

Lauri Hintsala (1):
      mmc: mxs-mmc: fix deadlock caused by recursion loop

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Marek Vasut (1):
      HID: add quirk for Freescale i.MX28 ROM recovery

Mathias Krause (1):
      ipc, msg: fix message length check for negative values

Matthieu CASTET (1):
      HID: hidraw: fix list->buffer memleak

Mauro Carvalho Chehab (1):
      sb_edac: Avoid overflow errors at memory size calculation

Michael Chan (1):
      tg3: Add New 5719 Read DMA workaround

Mikulas Patocka (3):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Ming Lei (1):
      USB: serial: fix hang when opening port

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

Nicolas Pitre (1):
      ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Nithin Sujir (3):
      tg3: Wait for boot code to finish after power on
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Add read dma workaround for 5720

Oleg Nesterov (1):
      audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Oliver Neukum (1):
      xhci: quirk for extra long delay for S4

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loa=
ded

Philipp Reisner (1):
      idr: idr_for_each_entry() macro

Rajkumar Manoharan (2):
      ath9k: fill channel mode in caldata
      ath9k_hw: Enable hw PLL power save for AR9462

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Russell King (1):
      ARM: footbridge: fix VGA initialisation

Sarah Sharp (2):
      usb: Disable USB 2.0 Link PM before device reset.
      xhci: Don't enable/disable RWE on bus suspend/resume.

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Seth Heasley (1):
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shawn Guo (1):
      ARM: dts: imx51-babbage: fix esdhc cd/wp properties

Soeren Moch (1):
      media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Sujith Manoharan (3):
      ath9k: Fix noisefloor calibration
      ath9k_hw: Assign default xlna config for AR9485
      ath9k_hw: Fix RX gain initvals for AR9485

Takashi Iwai (8):
      ALSA: aloop: Fix Oops while PM resume
      ALSA: hda - Fix non-snoop page handling
      ALSA: hda - Add Conexant CX20751/2/3/4 codec support
      ALSA: hda - Always turn on pins for HDMI/DP
      xhci: Fix spurious wakeups after S5 on Haswell
      xhci: Limit the spurious wakeup fix only to HP machines
      ALSA: hda - Cache the MUX selection for generic HDMI
      ALSA: pcsp: Fix the order of input device unregistration

Tejun Heo (2):
      idr: fix top layer handling
      workqueue: cond_resched() after processing each work item

Thomas Pugliese (2):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (pcm)
      ALSA: 6fire: make buffers DMA-able (midi)

Wei Yongjun (1):
      media: saa7164: fix return value check in saa7164_initdev()

Will Deacon (1):
      ARM: 7791/1: a.out: remove partial a.out support


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTC+7AAoJEDjbvchgkmk+Fj0P+wXvQhgOVX9MSD8DSfrzmyA6
9MywwgcaxnnTZQ1IHDubAWd8Fq9WtywL5yFHTcdvd8LVkCuJPj514YFOST7D7sTs
XLxGGCUowbhNfdUcG/usD+SaQqRN8KaytMAfG3jFwDFtV42yh9MoNXqZmo1a0NFA
c7u1PljPiaYi8qmSYu5P/5PhnP4ZXQfQJV0yASwQigwev3Wcczrnd3rCI1pn+CSw
DDRnfF0xIUXhMZmxXMKy4vjIJTfPGtdZT6EhLmapV+5VgOKg5TM6DDmBuAkfFT0z
PAz0Pc7WBvcpETskhRaI55+PGeEjYTKB0wBSMyZHNMW6r6sirIynyXWSBvQa892Z
z82itPHsqYPM7PcvIaHphNHeMZlVfKcg+UY+uj5RCHIGDT69+Lux1M3rfRM8OCOr
rurmPS4/5uIrQSDmSLESQWZouXrnNf8Xamqitio2d5JlVBT6imR4iUdiJewZAcOW
LQS2hRqpCR2ZwW0vQSFfq8tob9iwKFFJJhBFs8zA/r3L9CwlioytCmAiuzwSCtIE
5UdsKull5NqJgt3Ep4jcUl8pdxHRmTSe4b/Z6vSBm178Ssw+6+2jwnisKC+WRvww
YaKvjFjDy9dNyYCNDzIU5MPVxDqn97kGtOGqVdurvuRxIke6ErwBtJApkdqHNbeD
yPtPvFmbff+Y4bt1ko2O
=YKe6
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
