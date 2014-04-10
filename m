Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbaDJDVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:21:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbaDJDVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 000/134] 3.4.87-stable review
Date: Wed,  9 Apr 2014 20:21:56 -0700
Message-Id: <20140410032259.587501440@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.87 release.
There are 134 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Apr 12 03:22:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.87-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.87-rc1

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: reorder frequencies

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: correctly initialize default parameters

Mikulas Patocka <mpatocka@redhat.com>
    powernow-k6: disable cache when changing frequency

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    media: saa7164: fix return value check in saa7164_initdev()

Alexey Khoroshilov <khoroshilov@ispras.ru>
    media: hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Hans Verkuil <hans.verkuil@cisco.com>
    media: hdpvr: register the video node at the end of probe

Soeren Moch <smoch@web.de>
    media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Al Viro <viro@ZenIV.linux.org.uk>
    media: omap_vout: find_vma() needs ->mmap_sem held

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l: Reset subdev v4l2_dev field to NULL if registration fails

Jacob Schloss <jacob.schloss@unlimitedautomata.com>
    media: gspca_kinect: add Kinect for Windows USB id

Nithin Sujir <nsujir@broadcom.com>
    tg3: Add read dma workaround for 5720

Nithin Sujir <nsujir@broadcom.com>
    tg3: Skip powering down function 0 on certain serdes devices

Mauro Carvalho Chehab <mchehab@redhat.com>
    sb_edac: Avoid overflow errors at memory size calculation

Lauri Hintsala <lauri.hintsala@bluegiga.com>
    mmc: mxs-mmc: fix deadlock caused by recursion loop

Grazvydas Ignotas <notasas@gmail.com>
    OMAPFB: fix framebuffer console colors

Nithin Sujir <nsujir@broadcom.com>
    tg3: Wait for boot code to finish after power on

Michael Chan <mchan@broadcom.com>
    tg3: Add New 5719 Read DMA workaround

Dan Carpenter <dan.carpenter@oracle.com>
    hwmon: Prevent some divide by zeros in FAN_TO_REG()

Henrik Rydberg <rydberg@euromail.se>
    hwmon: (applesmc) Always read until end of data

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Improve support for TjMax detection on Atom CPUs

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU models

Jean Delvare <khali@linux-fr.org>
    hwmon: (coretemp) Improve support of recent Atom CPU models

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support of ALC231 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: pcsp: Fix the order of input device unregistration

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Torsten Schenk <torsten.schenk@zoho.com>
    ALSA: 6fire: make buffers DMA-able (midi)

Torsten Schenk <torsten.schenk@zoho.com>
    ALSA: 6fire: make buffers DMA-able (pcm)

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    ALSA: 6fire: fix DMA issues with URB transfer_buffer usage

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()

Torstein Hegge <hegge@resisty.net>
    ALSA: usb: Parse UAC2 extension unit like for UAC1

Eldad Zack <eldad@fogrefinery.com>
    ALSA: usb-audio: skip UAC2 EFFECT_UNIT

Aaron Plattner <aplattner@nvidia.com>
    ALSA: hda - Add another GPU codec ID to snd-hda

Aaron Plattner <aplattner@nvidia.com>
    ALSA: hda - Add new GPU codec ID to snd-hda

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Cache the MUX selection for generic HDMI

Takashi Iwai <tiwai@suse.de>
    xhci: Limit the spurious wakeup fix only to HP machines

Takashi Iwai <tiwai@suse.de>
    xhci: Fix spurious wakeups after S5 on Haswell

Oliver Neukum <oneukum@suse.de>
    xhci: quirk for extra long delay for S4

Julius Werner <jwerner@chromium.org>
    usb: hub: Clear Port Reset Change during init/resume

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Wildcat Point-LP

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Don't enable/disable RWE on bus suspend/resume.

Seth Heasley <seth.heasley@intel.com>
    ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Wellsburg PCH

Colin Leitner <colin.leitner@googlemail.com>
    USB: ftdi_sio: fixed handling of unsupported CSIZE setting

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: wusbcore: change WA_SEGS_MAX to a legal value

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: wusbcore: set the RPIPE wMaxPacketSize value correctly

David Cohen <david.a.cohen@linux.intel.com>
    usb: dwc3: add support for Merrifield

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for BayTrail

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Disable USB 2.0 Link PM before device reset.

Alan Stern <stern@rowland.harvard.edu>
    USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd

Alan Stern <stern@rowland.harvard.edu>
    USB: fix build error when CONFIG_PM_SLEEP isn't enabled

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: Allow runtime PM without system sleep

Johan Hovold <jhovold@gmail.com>
    USB: keyspan: fix null-deref at disconnect and release

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix big-endian firmware handling

Johan Hovold <jhovold@gmail.com>
    USB: adutux: fix big-endian device-type reporting

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix race in register handling

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix memory leak in open

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix device initialisation at open

Johan Hovold <jhovold@gmail.com>
    USB: spcp8x5: fix device initialisation at open

Richard Weinberger <richard@nod.at>
    USB: serial: Add Option GTM681W to qcserial device table.

George Cherian <george.cherian@ti.com>
    usb: dwc3: gadget: free trb pool only from epnum 2

Adrian Thomasset <adrian.thomasset@st.com>
    USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Ming Lei <tom.leiming@gmail.com>
    USB: serial: fix hang when opening port

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ssu100: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: spcp8x5: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: oti6858: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix broken TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: mct_u232: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: io_edgeport: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ftdi_sio: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: cypress_m8: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ch341: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: ark3116: fix use-after-free in TIOCMIWAIT

Johan Hovold <jhovold@gmail.com>
    USB: serial: add modem-status-change wait queue

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix internal mic for Lenovo Ideapad U300s

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Always turn on pins for HDMI/DP

David Henningsson <david.henningsson@canonical.com>
    Revert "ALSA: hda - Shut up pins at power-saving mode with Conexnat codecs"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add Conexant CX20751/2/3/4 codec support

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix non-snoop page handling

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Fix Oops while PM resume

Calvin Owens <jcalvinowens@gmail.com>
    ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: Add USB_QUIRK_RESET_RESUME for all Logitech UVC webcams

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: Add quirk detection based on interface information

Andreas Fleig <andreasfleig@gmail.com>
    USB: Add device quirk for Microsoft VX700 webcam

Alan Stern <stern@rowland.harvard.edu>
    USB: EHCI: bugfix: urb->hcpriv should not be NULL

Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
    ath9k_hw: Enable hw PLL power save for AR9462

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_hw: Fix RX gain initvals for AR9485

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix chain swap setting when setting rx chainmask to 5

Felix Fietkau <nbd@openwrt.org>
    ath9k_htc: fix signal strength handling issues

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_hw: Assign default xlna config for AR9485

Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
    ath9k: fill channel mode in caldata

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix noisefloor calibration

Will Deacon <will.deacon@arm.com>
    ARM: 7791/1: a.out: remove partial a.out support

Nicolas Pitre <nicolas.pitre@linaro.org>
    ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Arnaud Patard <arnaud.patard@rtp-net.org>
    ARM: Orion: Set eth packet size csum offload limit

Sergei Ianovich <ynvich@gmail.com>
    ARM: pxa: prevent PXA270 occasional reboot freezes

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: footbridge: fix VGA initialisation

Arnd Bergmann <arnd@arndb.de>
    ARM: 7743/1: compressed/head.S: work around new binutils warning

Arnd Bergmann <arnd@arndb.de>
    ARM: 7742/1: topology: export cpu_topology

Linus Walleij <linus.walleij@linaro.org>
    ARM: u300: fix ages old copy/paste bug

Arnd Bergmann <arnd@arndb.de>
    ARM: w90x900: fix legacy assembly syntax

Shawn Guo <shawn.guo@linaro.org>
    ARM: dts: imx51-babbage: fix esdhc cd/wp properties

Manoj Chourasia <mchourasia@nvidia.com>
    HID: hidraw: correctly deallocate memory on device disconnect

Jiri Kosina <jkosina@suse.cz>
    HID: usbhid: fix build problem

Josh Boyer <jwboyer@redhat.com>
    HID: usbhid: quirk for MSI GX680R led panel

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    HID: clean up quirk for Sony RF receivers

Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
    HID: add support for Sony RF receiver with USB product id 0x0374

Alexey Kaminsky <me@akaminsky.net>
    HID: apple: Add Apple wireless keyboard 2011 ANSI PID

Alexey Khoroshilov <khoroshilov@ispras.ru>
    HID: hidraw: improve error handling in hidraw_init()

Matthieu CASTET <matthieu.castet@parrot.com>
    HID: hidraw: fix list->buffer memleak

Jiri Kosina <jkosina@suse.cz>
    HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW

Jiri Kosina <jkosina@suse.cz>
    HID: hidraw: add proper error handling to raw event reporting

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: multitouch: validate indexes details

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: validate feature and input report details

Nicholas Santos <nicholas.santos@gmail.com>
    HID: usbhid: quirk for Formosa IR receiver

Marek Vasut <marex@denx.de>
    HID: add quirk for Freescale i.MX28 ROM recovery

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    intel_idle: Check cpu_idle_get_driver() for NULL before dereferencing it.

Paul Moore <pmoore@redhat.com>
    selinux: correctly label /proc inodes in use before the policy is loaded

George Spelvin <linux@horizon.com>
    pps: Fix a use-after free bug when unregistering a source.

George Spelvin <linux@horizon.com>
    pps: Use pps_lookup_dev to reduce ldisc coupling

George Spelvin <linux@horizon.com>
    pps: Add pps_lookup_dev() function

Philipp Reisner <philipp.reisner@linbit.com>
    idr: idr_for_each_entry() macro

Mathias Krause <minipli@googlemail.com>
    ipc, msg: fix message length check for negative values

Ingo Molnar <mingo@kernel.org>
    compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Daniel Santos <daniel.santos@pobox.com>
    compiler-gcc.h: Add gcc-recommended GCC_VERSION macro

Tejun Heo <tj@kernel.org>
    workqueue: cond_resched() after processing each work item

Bu, Yitian <ybu@qti.qualcomm.com>
    printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Oleg Nesterov <oleg@redhat.com>
    audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE

Tejun Heo <tj@kernel.org>
    idr: fix top layer handling

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    proc: pid/status: show all supplementary groups


-------------

Diffstat:

 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |   8 +-
 Documentation/hwmon/coretemp                       |  12 +-
 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   1 -
 arch/arm/boot/compressed/Makefile                  |   1 -
 arch/arm/boot/compressed/head-sa1100.S             |   1 +
 arch/arm/boot/compressed/head-shark.S              |   1 +
 arch/arm/boot/compressed/head.S                    |   1 +
 arch/arm/boot/dts/imx51-babbage.dts                |   4 +-
 arch/arm/include/asm/a.out-core.h                  |  45 ------
 arch/arm/include/asm/a.out.h                       |  34 -----
 arch/arm/include/asm/processor.h                   |   4 -
 arch/arm/kernel/head.S                             |   3 +
 arch/arm/kernel/topology.c                         |   2 +
 arch/arm/mach-dove/common.c                        |   2 +-
 arch/arm/mach-footbridge/common.c                  |   3 +
 arch/arm/mach-footbridge/dc21285.c                 |   2 -
 arch/arm/mach-kirkwood/common.c                    |   4 +-
 arch/arm/mach-mv78xx0/common.c                     |   6 +-
 arch/arm/mach-orion5x/common.c                     |   3 +-
 arch/arm/mach-pxa/reset.c                          |   8 +-
 arch/arm/mach-u300/include/mach/u300-regs.h        |   2 +-
 arch/arm/mach-w90x900/include/mach/entry-macro.S   |   4 +-
 arch/arm/plat-orion/common.c                       |   8 +-
 arch/arm/plat-orion/include/plat/common.h          |   6 +-
 arch/mips/include/asm/jump_label.h                 |   2 +-
 arch/powerpc/include/asm/jump_label.h              |   2 +-
 arch/s390/include/asm/jump_label.h                 |   2 +-
 arch/sparc/include/asm/jump_label.h                |   2 +-
 arch/x86/include/asm/cpufeature.h                  |   2 +-
 arch/x86/include/asm/jump_label.h                  |   2 +-
 drivers/ata/ahci.c                                 |  13 ++
 drivers/cpufreq/powernow-k6.c                      | 147 ++++++++++++++++----
 drivers/edac/sb_edac.c                             |   7 +-
 drivers/hid/hid-apple.c                            |   3 +
 drivers/hid/hid-core.c                             |  26 ++--
 drivers/hid/hid-ids.h                              |  10 ++
 drivers/hid/hid-input.c                            |  12 +-
 drivers/hid/hid-multitouch.c                       |   4 +-
 drivers/hid/hid-sony.c                             |  18 ++-
 drivers/hid/hidraw.c                               |  98 +++++++------
 drivers/hid/usbhid/hid-quirks.c                    |   3 +
 drivers/hwmon/applesmc.c                           |  13 ++
 drivers/hwmon/coretemp.c                           |  34 ++++-
 drivers/hwmon/lm78.c                               |   2 +
 drivers/hwmon/sis5595.c                            |   2 +
 drivers/hwmon/vt8231.c                             |   2 +-
 drivers/idle/intel_idle.c                          |   3 +-
 drivers/media/dvb/dvb-core/dmxdev.c                |   8 +-
 drivers/media/video/gspca/kinect.c                 |   1 +
 drivers/media/video/hdpvr/hdpvr-core.c             |  22 +--
 drivers/media/video/omap/omap_vout.c               |  12 +-
 drivers/media/video/saa7164/saa7164-core.c         |   4 +-
 drivers/media/video/v4l2-device.c                  |  30 ++--
 drivers/mmc/host/mxs-mmc.c                         |   8 +-
 drivers/net/ethernet/broadcom/tg3.c                |  74 +++++++++-
 drivers/net/ethernet/broadcom/tg3.h                |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  15 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  27 +---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +
 drivers/net/wireless/ath/ath9k/calib.c             |   1 +
 drivers/net/wireless/ath/ath9k/htc.h               |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  18 ++-
 drivers/net/wireless/ath/ath9k/hw.c                |   3 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   1 +
 drivers/net/wireless/ath/ath9k/main.c              |   7 -
 drivers/pps/clients/pps-ldisc.c                    |  10 +-
 drivers/pps/pps.c                                  |  47 ++++++-
 drivers/usb/core/driver.c                          |  38 ++++--
 drivers/usb/core/hub.c                             |  21 ++-
 drivers/usb/core/quirks.c                          | 152 ++++++++++++---------
 drivers/usb/core/usb.h                             |   4 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/dwc3/gadget.c                          |  15 +-
 drivers/usb/host/ehci-pci.c                        |   2 +-
 drivers/usb/host/ehci-q.c                          |  16 +--
 drivers/usb/host/ehci-sched.c                      |   4 +-
 drivers/usb/host/ohci-pci.c                        |   2 +-
 drivers/usb/host/uhci-pci.c                        |   2 +-
 drivers/usb/host/xhci-hub.c                        |  28 ----
 drivers/usb/host/xhci-pci.c                        |  32 ++++-
 drivers/usb/host/xhci.c                            |  14 +-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/misc/adutux.c                          |   2 +-
 drivers/usb/serial/ark3116.c                       |  10 +-
 drivers/usb/serial/ch341.c                         |  11 +-
 drivers/usb/serial/cypress_m8.c                    |  14 +-
 drivers/usb/serial/ftdi_sio.c                      |  68 +++++----
 drivers/usb/serial/io_edgeport.c                   |  12 +-
 drivers/usb/serial/io_ti.c                         |  12 +-
 drivers/usb/serial/keyspan.c                       |   2 +-
 drivers/usb/serial/mct_u232.c                      |  13 +-
 drivers/usb/serial/mos7840.c                       |  60 +++++---
 drivers/usb/serial/oti6858.c                       |  10 +-
 drivers/usb/serial/pl2303.c                        |  21 +--
 drivers/usb/serial/qcserial.c                      |   1 +
 drivers/usb/serial/spcp8x5.c                       |  19 ++-
 drivers/usb/serial/ssu100.c                        |  12 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |  19 +--
 drivers/usb/serial/usb-serial.c                    |   1 +
 drivers/usb/wusbcore/wa-rpipe.c                    |   5 +-
 drivers/usb/wusbcore/wa-xfer.c                     |   5 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |   2 +-
 fs/proc/array.c                                    |   2 +-
 include/linux/compiler-gcc.h                       |   3 +
 include/linux/compiler-gcc4.h                      |  16 +++
 include/linux/hid.h                                |   2 +-
 include/linux/hidraw.h                             |   4 +-
 include/linux/idr.h                                |  11 ++
 include/linux/msg.h                                |   6 +-
 include/linux/mv643xx_eth.h                        |   2 +
 include/linux/pps_kernel.h                         |  17 ++-
 include/linux/usb/hcd.h                            |   2 +-
 include/linux/usb/serial.h                         |   2 +
 ipc/msgutil.c                                      |  12 +-
 ipc/util.h                                         |   4 +-
 kernel/audit.c                                     |   2 +-
 kernel/printk.c                                    |   2 +-
 kernel/workqueue.c                                 |   9 ++
 lib/idr.c                                          |  36 +++--
 security/selinux/hooks.c                           |  36 +++--
 sound/drivers/aloop.c                              |   5 +-
 sound/drivers/pcsp/pcsp.c                          |   2 +-
 sound/i2c/other/ak4xxx-adda.c                      |   2 +-
 sound/pci/hda/hda_intel.c                          |  40 ++++--
 sound/pci/hda/patch_conexant.c                     | 114 +++++++++++-----
 sound/pci/hda/patch_hdmi.c                         |  35 +++--
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/usb/6fire/comm.c                             |  38 +++++-
 sound/usb/6fire/comm.h                             |   2 +-
 sound/usb/6fire/midi.c                             |  16 ++-
 sound/usb/6fire/midi.h                             |   6 +-
 sound/usb/6fire/pcm.c                              |  41 +++++-
 sound/usb/6fire/pcm.h                              |   2 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |   3 +-
 sound/usb/mixer.c                                  |  16 ++-
 sound/usb/quirks.c                                 |   1 +
 139 files changed, 1334 insertions(+), 679 deletions(-)


