Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3KNP6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:58:47 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52598 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3KNP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:58:38 -0500
X-AuditID: cbfec372-b7fcc6d0000068fc-44-5284f32c21bb
Date: Thu, 14 Nov 2013 13:58:31 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.13-rc1] media updates
Message-id: <20131114135831.743db137@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e9woK7O55Ygg3lbjC3mrF/DZnF51xw2
	i54NW1ktHvW9ZXdg8Tgx4zeLx+dNcgFMUVw2Kak5mWWpRfp2CVwZdxd/ZS+4NYWp4suq2ewN
	jGd6mboYOTgkBEwkfh2w6mLkBDLFJC7cW88GYgsJLGGUmLVXtIuRC8juZpI4M3kqM0g9i4Cq
	ROeXTJAaNgEjiVeNLawgtgiQ/fnFFVaQemaBxYwSH5+vZwdJCAvoS7xeCJLg4OAVMJQ499MU
	Yq2TxO4DUiAVvAKCEj8m32MBsZkF1CUmzVvEDGErSkxb1MA4gZFvFpKyWUjKZiEpW8DIvIpR
	tLQ4uaA4KT3XUK84Mbe4NC9dLzk/dxMjJOyKdjA+22B1iFGAg1GJh7dgZ3OQEGtiWXFl7iFG
	CQ5mJRHe//dbgoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwsqxuDDA5HbngZsNV2fMOf43svCqi
	LXom7nBavfJGoMeOH8JLpjbtv1id0M79Smq21sXmU84vXxTI2z99ENnINnG3it1t+YDzehJL
	GC5qBS9Z9LvN91nzZQfZJA5OZ54GGyePq1u3b7vrrf/Zm3tWTMba85/WFfG7PN+hKrLJN67B
	99nWieHxSizFGYmGWsxFxYkAFyFZ9xkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAEFwsg0008098

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for the patches for kernel 3.13.

This series include:
	- a new Remote Controller driver for ST SoC with the 
corresponding DT bindings;
	- a new frontend (cx24117);
	- a new I2C camera flash driver (lm3560);
	- a new mem2mem driver for TI SoC (ti-vpe);
	- support for Raphael r828d added to r820t driver;
	- some improvements on buffer allocation at VB2 core;
	- usual driver fixes and improvements.

Thanks!
Mauro

- -

PS.: this time, we have a smaller number of patches. While it is hard to
pinpoint to the reasons, I believe that it is mainly due to:

1) there are several patch series ready, but depending on DT review.
I decided to grant some extra time for DT maintainers to look on it, as
they're expecting to have more time with the changes agreed during ARM
mini-summit and KS. If they can't review in time for 3.14, I'll review
myself and apply for the next merge window.

2) I suspect that having both LinuxCon EU and LinuxCon NA happening during
the same merge window affected the development productivity, as several
core media developers participated on both events.



Latest commit at the branch: 
80f93c7b0f4599ffbdac8d964ecd1162b8b618b9 [media] media: st-rc: Add ST remote control driver
The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:

  [media] media: st-rc: Add ST remote control driver (2013-10-31 08:20:08 -0200)

- ----------------------------------------------------------------
Alexandru Juncu (1):
      [media] dm1105: remove unneeded not-null test

Alexey Khoroshilov (2):
      [media] dvb-usb: fix error handling in ttusb_dec_probe()
      [media] cx231xx: fix double free and leaks on failure path in cx231xx_usb_probe()

Anca Emanuel (1):
      [media] cx23885: Add Leadtek Winfast PxPVR2200

Andreas Matthies (1):
      [media] tda10071: change firmware download condition

Andy Shevchenko (1):
      [media] gspca: print small buffers via %*ph

Antti Palosaari (7):
      [media] em28xx: MaxMedia UB425-TC offer firmware for demodulator
      [media] em28xx: MaxMedia UB425-TC switch RF tuner driver to another
      [media] em28xx: MaxMedia UB425-TC change demod settings
      [media] r820t: add support for R828D
      [media] rtl2832: add new tuner R828D
      [media] rtl28xxu: add RTL2832P + R828D support
      [media] rtl28xxu: add 15f4:0131 Astrometa DVB-T2

Archit Taneja (4):
      [media] v4l: ti-vpe: Create a vpdma helper library
      [media] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
      [media] v4l: ti-vpe: Add VPE mem to mem driver
      [media] v4l: ti-vpe: Add de-interlacer support in VPE

Arun Kumar K (1):
      [media] s5p-mfc: Adjust the default values of some encoder params

Ben Hutchings (4):
      [media] lirc_bt829: Fix physical address type
      [media] lirc_bt829: Fix iomap and PCI device leaks
      [media] lirc_bt829: Enable and disable device
      [media] lirc_bt829: Note in TODO why it can't be a normal PCI driver yet

Chanho Min (1):
      [media] uvcvideo: Fix data type for pan/tilt control

Chen Gang (1):
      [media] drivers: media: usb: b2c2: use usb_*_coherent() instead of pci_*_consistent() in flexcop-usb.c

Christoph Jaeger (1):
      [media] drxd_hard: remove unused SIZEOF_ARRAY

Dan Carpenter (1):
      [media] snd_tea575x: precedence bug in fmr2_tea575x_get_pins()

Daniel Jeong (1):
      [media] media: i2c: add driver for dual LED Flash, lm3560

Fabio Estevam (1):
      [media] platform: Kconfig: Select SRAM for VIDEO_CODA

Frank Schaefer (3):
      [media] v4l2-ctrls: fix typo in header file media/v4l2-ctrls.h
      [media] em28xx: fix and unify the coding style of the GPIO register write sequences
      [media] em28xx: fix error path in em28xx_start_analog_streaming()

Geert Uytterhoeven (1):
      [media] media/v4l2: VIDEO_RENESAS_VSP1 should depend on HAS_DMA

Gregor Jasny (1):
      [media] Add HCL T12Rg-H to STK webcam upside-down table

Guennadi Liakhovetski (9):
      [media] V4L2: (cosmetic) remove redundant use of unlikely()
      [media] imx074: fix error handling for failed async subdevice registration
      [media] V4L2: add a common V4L2 subdevice platform data type
      [media] soc-camera: switch to using the new struct v4l2_subdev_platform_data
      [media] V4L2: add v4l2-clock helpers to register and unregister a fixed-rate clock
      [media] V4L2: add a v4l2-clk helper macro to produce an I2C device ID
      [media] V4L2: em28xx: register a V4L2 clock source
      [media] V4L2: soc-camera: work around unbalanced calls to .s_power()
      [media] V4L2: em28xx: tell the ov2640 driver to balance clock enabling internally

Hans Verkuil (14):
      [media] hdpvr: fix sparse warnings
      [media] pvrusb2: fix sparse warning
      [media] timblogiw: fix two sparse warnings
      [media] tuner-xs2028.c: fix sparse warnings
      [media] fmdrv_common: fix sparse warning
      [media] radio-keene: fix sparse warning
      [media] cx231xx: fix sparse warnings
      [media] tlg2300: fix sparse warning
      [media] cxd2820r_core: fix sparse warnings
      [media] drxd_hard: fix sparse warnings
      [media] drxk_hard: fix sparse warnings
      [media] az6027: fix sparse warnings
      [media] siano: fix sparse warnings
      [media] cx25821: fix sparse warnings

Jean-Francois Thibert (1):
      [media] Add support for KWorld UB435-Q V2

Jingoo Han (6):
      [media] saa7146: remove unnecessary pci_set_drvdata()
      [media] s5p-g2d: Remove casting the return value which is a void pointer
      [media] m2m-deinterlace: Remove casting the return value which is a void pointer
      [media] mem2mem_testdev: Remove casting the return value which is a void pointer
      [media] ngene: Remove casting the return value which is a void pointer
      [media] ddbridge: Remove casting the return value which is a void pointer

Joe Perches (1):
      [media] media: Remove unnecessary semicolons

John Horan (1):
      [media] media: dvb-frontends: ts2020: Added in a option for frequency divider value for s600 devices

Kees Cook (1):
      [media] dib9000: fix potential format string leak

Krzysztof Ha≈Çasa (5):
      [media] SOLO6x10: don't do DMA from stack in solo_dma_vin_region()
      [media] SOLO6x10: Remove unused #define SOLO_DEFAULT_GOP
      [media] SOLO6x10: Fix video encoding on big-endian systems
      [media] SOLO6x10: Fix video headers on certain hardware
      [media] SOLO6x10: Fix video frame type (I/P/B)

Lad, Prabhakar (1):
      [media] v4l: tuner-core: fix typo

Laurent Pinchart (3):
      [media] v4l2-fh: Include linux/fs.h for struct file definition
      [media] v4l2-fh: Include linux/videodev2.h for enum v4l2_priority definition
      [media] v4l: Fix typo in v4l2_subdev_get_try_crop()

Luis Alves (4):
      [media] dvb: add cx24117 frontend
      [media] cx23885: add support for cx24117 with tbs6980 or tbs6981
      [media] cx24117: use hybrid_tuner_request/release_state to share state between multiple instances
      [media] cx24117: prevent mutex to be stuck on locked state if FE init fails

Mauro Carvalho Chehab (7):
      Merge tag 'v3.12-rc2' into patchwork
      [media] stk1135: fix two warnings added by changeset 76e0598
      [media] ts2020: keep 1.06 MHz as default value for frequency_div
      [media] siano: Don't show debug messages as errors
      [media] siano: Improve debug/info messages
      [media] siano: Fix initialization for Stellar models
      [media] siano: Use the default firmware for Stellar

Michael Krufky (1):
      [media] dib9000: fix typo in spelling the word empty

Michael Opdenacker (11):
      [media] davinci: remove deprecated IRQF_DISABLED
      [media] radio-si4713: remove deprecated IRQF_DISABLED
      [media] saa7146: remove deprecated IRQF_DISABLED
      [media] cx18: remove deprecated IRQF_DISABLED
      [media] misc drivers: remove deprecated IRQF_DISABLED
      [media] zoran: remove deprecated IRQF_DISABLED
      [media] ivtv: remove deprecated IRQF_DISABLED
      [media] ir-rx51: remove deprecated IRQF_DISABLED
      [media] winbond-cir: remove deprecated IRQF_DISABLED
      [media] s5p-mfc: remove deprecated IRQF_DISABLED
      [media] sh_mobile_ceu_camera: remove deprecated IRQF_DISABLED

Ming Lei (1):
      [media] media: dvb-core: prepare for enabling irq in complete()

Ondrej Zary (3):
      [media] gspca: store current mode instead of individual parameters
      [media] gspca: Support variable resolution
      [media] gspca-stk1135: Add variable resolution support

Peter Senna Tschudin (2):
      [media] fc001[23]: Change variable type to bool
      [media] media: Change variable type to bool

Philipp Zabel (13):
      [media] videobuf2-core: call __setup_offsets only for mmap memory type
      [media] v4l2-mem2mem: fix context removal from job queue in v4l2_m2m_streamoff
      [media] v4l2-mem2mem: clear m2m queue ready counter in v4l2_m2m_streamoff
      [media] coda: allow more than four instances on CODA7541
      [media] coda: only set buffered input queue for decoder
      [media] coda: add compressed flag to format enumeration output
      [media] coda: fix FMO value setting for CodaDx6
      [media] coda: move coda_product_name above vidioc_querycap
      [media] coda: use picture type returned from hardware
      [media] coda: prefix v4l2_ioctl_ops with coda_ instead of vidioc_
      [media] coda: v4l2-compliance fix: overwrite invalid pixel formats with the current setting
      [media] coda: v4l2-compliance fix: implement try_decoder_cmd
      [media] coda: v4l2-compliance fix: zero pixel format priv field

Prathyush K (1):
      [media] s5p-mfc: call wake_up_dev if in suspend mode

Randy Dunlap (1):
      [media] staging/media: fix msi3101 build errors

Ricardo Ribalda (3):
      [media] videobuf2: Fix vb2_write prototype
      [media] videobuf2-dma-sg: Allocate pages as contiguous as possible
      [media] videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table

Russell King - ARM Linux (1):
      [media] media/i2c: ths8200: fix build failure with gcc 4.5.4

Sachin Kamat (18):
      [media] radio-sf16fmr2: Remove redundant dev_set_drvdata
      [media] pci: cx88-alsa: Use module_pci_driver
      [media] pci: cx88-mpeg: Use module_pci_driver
      [media] pci: cx88-video: Use module_pci_driver
      [media] pci: flexcop: Remove redundant pci_set_drvdata
      [media] pci: cx88: Remove redundant pci_set_drvdata
      [media] pci: dm1105: Remove redundant pci_set_drvdata
      [media] pci: mantis: Remove redundant pci_set_drvdata
      [media] pci: pluto2: Remove redundant pci_set_drvdata
      [media] pci: pt1: Remove redundant pci_set_drvdata
      [media] pci: saa7164: Remove redundant pci_set_drvdata
      [media] pci: bt878: Remove redundant pci_set_drvdata
      [media] pci: ngene: Remove redundant pci_set_drvdata
      [media] adv7343: Include linux/of.h header
      [media] ths8200: Include linux/of.h header
      [media] tvp514x: Include linux/of.h header
      [media] tvp7002: Include linux/of.h header
      [media] gpio-ir-recv: Include linux/of.h header

Seung-Woo Kim (1):
      [media] videobuf2: Add log for size checking error in __qbuf_userptr

Shaik Ameer Basha (2):
      [media] exynos-gsc: Handle ctx job finish when aborted
      [media] v4l2-mem2mem: Don't schedule the context if abort job is called

Srinivas Kandagatla (1):
      [media] media: st-rc: Add ST remote control driver

Sylwester Nawrocki (2):
      [media] videobuf2: Add debug print for the output buffer plane lengths checks
      [media] v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function's return type

Valentine Barshak (1):
      [media] media: rcar_vin: Add preliminary r8a7790 support

Vladik Aranov (1):
      [media] gscpa_ov534_9: Add support for ov3610 sensor

Wei Yongjun (3):
      [media] davinci: vpif_capture: fix error return code in vpif_probe()
      [media] adv7511: fix error return code in adv7511_probe()
      [media] marvell-ccic: drop free_irq for devm_request_irq allocated irq

 Documentation/devicetree/bindings/media/st-rc.txt  |   29 +
 drivers/media/common/b2c2/flexcop-sram.c           |    6 +-
 drivers/media/common/saa7146/saa7146_core.c        |    4 +-
 drivers/media/common/siano/smscoreapi.c            |    8 +-
 drivers/media/common/siano/smsdvb-main.c           |    8 +-
 drivers/media/dvb-core/dvb_demux.c                 |   17 +-
 drivers/media/dvb-frontends/Kconfig                |    7 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/cx24110.c              |    2 +-
 drivers/media/dvb-frontends/cx24117.c              | 1650 +++++++++++++++
 drivers/media/dvb-frontends/cx24117.h              |   47 +
 drivers/media/dvb-frontends/cx24123.c              |    2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |    4 +-
 drivers/media/dvb-frontends/dib9000.c              |    4 +-
 drivers/media/dvb-frontends/drxd_hard.c            |   12 +-
 drivers/media/dvb-frontends/drxk_hard.c            |    4 +-
 drivers/media/dvb-frontends/rtl2832.c              |    1 +
 drivers/media/dvb-frontends/rtl2832.h              |    1 +
 drivers/media/dvb-frontends/tda10071.c             |    9 +-
 drivers/media/dvb-frontends/tda8083.c              |    4 +-
 drivers/media/dvb-frontends/ts2020.c               |    7 +-
 drivers/media/dvb-frontends/ts2020.h               |    1 +
 drivers/media/i2c/Kconfig                          |    9 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/adv7343.c                        |    1 +
 drivers/media/i2c/adv7511.c                        |    2 +
 drivers/media/i2c/lm3560.c                         |  488 +++++
 drivers/media/i2c/soc_camera/imx074.c              |    4 +-
 drivers/media/i2c/soc_camera/ov9640.c              |    2 +-
 drivers/media/i2c/ths8200.c                        |   19 +-
 drivers/media/i2c/tvp514x.c                        |    1 +
 drivers/media/i2c/tvp7002.c                        |    1 +
 drivers/media/pci/b2c2/flexcop-pci.c               |    2 -
 drivers/media/pci/bt8xx/bt878.c                    |    4 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    2 +-
 drivers/media/pci/cx18/cx18-driver.c               |    3 +-
 drivers/media/pci/cx23885/Kconfig                  |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c          |  108 +
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   24 +
 drivers/media/pci/cx23885/cx23885-input.c          |   12 +
 drivers/media/pci/cx23885/cx23885-video.c          |    3 +-
 drivers/media/pci/cx23885/cx23885.h                |    3 +
 drivers/media/pci/cx25821/cx25821-cards.c          |    2 -
 drivers/media/pci/cx25821/cx25821-medusa-video.c   |   18 +-
 drivers/media/pci/cx25821/cx25821-medusa-video.h   |    6 -
 drivers/media/pci/cx25821/cx25821-video-upstream.c |    8 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |   29 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |   17 +-
 drivers/media/pci/cx88/cx88-video.c                |   18 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |    2 +-
 drivers/media/pci/dm1105/dm1105.c                  |    5 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    2 +-
 drivers/media/pci/mantis/mantis_pci.c              |    2 -
 drivers/media/pci/meye/meye.c                      |    2 +-
 drivers/media/pci/ngene/ngene-core.c               |    4 +-
 drivers/media/pci/pluto2/pluto2.c                  |    2 -
 drivers/media/pci/pt1/pt1.c                        |    2 -
 drivers/media/pci/saa7134/saa7134-alsa.c           |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/saa7164/saa7164-core.c           |    3 +-
 drivers/media/pci/zoran/zoran_card.c               |    2 +-
 drivers/media/platform/Kconfig                     |   19 +-
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/coda.c                      |  278 ++-
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    4 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   29 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   14 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c   |    1 -
 drivers/media/platform/mem2mem_testdev.c           |    3 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_grp_layer.c    |    2 +-
 drivers/media/platform/s5p-tv/mixer_vp_layer.c     |    2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    5 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   46 +-
 drivers/media/platform/ti-vpe/Makefile             |    5 +
 drivers/media/platform/ti-vpe/vpdma.c              |  846 ++++++++
 drivers/media/platform/ti-vpe/vpdma.h              |  203 ++
 drivers/media/platform/ti-vpe/vpdma_priv.h         |  641 ++++++
 drivers/media/platform/ti-vpe/vpe.c                | 2099 ++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpe_regs.h           |  496 +++++
 drivers/media/platform/timblogiw.c                 |    4 +-
 drivers/media/radio/radio-keene.c                  |    2 +-
 drivers/media/radio/radio-sf16fmr2.c               |    5 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    2 +-
 drivers/media/radio/si4713-i2c.c                   |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    2 +-
 drivers/media/rc/Kconfig                           |   10 +
 drivers/media/rc/Makefile                          |    1 +
 drivers/media/rc/gpio-ir-recv.c                    |    1 +
 drivers/media/rc/ir-rx51.c                         |    3 +-
 drivers/media/rc/st_rc.c                           |  395 ++++
 drivers/media/rc/winbond-cir.c                     |    2 +-
 drivers/media/tuners/fc0012.c                      |    2 +-
 drivers/media/tuners/fc0013.c                      |    2 +-
 drivers/media/tuners/r820t.c                       |   22 +-
 drivers/media/tuners/tuner-xc2028.c                |    4 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |    6 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |    2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  110 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c        |    4 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   42 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h            |    1 +
 drivers/media/usb/dvb-usb/az6027.c                 |    4 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |   13 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   42 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  121 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   63 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    7 +-
 drivers/media/usb/em28xx/em28xx.h                  |    2 +
 drivers/media/usb/gspca/conex.c                    |    3 +-
 drivers/media/usb/gspca/cpia1.c                    |    4 +-
 drivers/media/usb/gspca/gspca.c                    |   48 +-
 drivers/media/usb/gspca/gspca.h                    |   10 +-
 drivers/media/usb/gspca/jeilinj.c                  |    5 +-
 drivers/media/usb/gspca/jl2005bcd.c                |    2 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |    2 +-
 drivers/media/usb/gspca/mars.c                     |    7 +-
 drivers/media/usb/gspca/mr97310a.c                 |    6 +-
 drivers/media/usb/gspca/nw80x.c                    |   11 +-
 drivers/media/usb/gspca/ov519.c                    |   52 +-
 drivers/media/usb/gspca/ov534.c                    |    5 +-
 drivers/media/usb/gspca/ov534_9.c                  |  334 +++-
 drivers/media/usb/gspca/pac207.c                   |    4 +-
 drivers/media/usb/gspca/pac7311.c                  |    6 +-
 drivers/media/usb/gspca/se401.c                    |    6 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    6 +-
 drivers/media/usb/gspca/sonixb.c                   |    7 +-
 drivers/media/usb/gspca/sonixj.c                   |    3 +-
 drivers/media/usb/gspca/spca1528.c                 |    3 +-
 drivers/media/usb/gspca/spca500.c                  |    3 +-
 drivers/media/usb/gspca/sq905c.c                   |    2 +-
 drivers/media/usb/gspca/sq930x.c                   |    3 +-
 drivers/media/usb/gspca/stk014.c                   |    5 +-
 drivers/media/usb/gspca/stk1135.c                  |   76 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |    2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |    2 +-
 drivers/media/usb/gspca/sunplus.c                  |    3 +-
 drivers/media/usb/gspca/topro.c                    |   13 +-
 drivers/media/usb/gspca/tv8532.c                   |    7 +-
 drivers/media/usb/gspca/vicam.c                    |    8 +-
 drivers/media/usb/gspca/w996Xcf.c                  |   28 +-
 drivers/media/usb/gspca/xirlink_cit.c              |   46 +-
 drivers/media/usb/gspca/zc3xx.c                    |    3 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   11 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    2 +-
 drivers/media/usb/siano/smsusb.c                   |   43 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    7 +
 drivers/media/usb/tlg2300/pd-main.c                |    2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  152 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    4 +-
 drivers/media/v4l2-core/tuner-core.c               |    2 +-
 drivers/media/v4l2-core/v4l2-clk.c                 |   39 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |    8 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   16 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   19 +-
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |  149 +-
 drivers/staging/media/lirc/TODO                    |    5 +
 drivers/staging/media/lirc/lirc_bt829.c            |   33 +-
 drivers/staging/media/msi3101/Kconfig              |    2 +
 drivers/staging/media/solo6x10/solo6x10-disp.c     |   25 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |  170 +-
 drivers/staging/media/solo6x10/solo6x10.h          |    1 -
 include/media/lm3560.h                             |   97 +
 include/media/soc_camera.h                         |   27 +-
 include/media/v4l2-clk.h                           |   17 +
 include/media/v4l2-common.h                        |    2 +-
 include/media/v4l2-ctrls.h                         |    2 +-
 include/media/v4l2-fh.h                            |    2 +
 include/media/v4l2-subdev.h                        |   19 +-
 include/media/videobuf2-core.h                     |    4 +-
 include/media/videobuf2-dma-sg.h                   |   10 +-
 include/uapi/linux/v4l2-controls.h                 |    4 +
 184 files changed, 8893 insertions(+), 965 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/st-rc.txt
 create mode 100644 drivers/media/dvb-frontends/cx24117.c
 create mode 100644 drivers/media/dvb-frontends/cx24117.h
 create mode 100644 drivers/media/i2c/lm3560.c
 create mode 100644 drivers/media/platform/ti-vpe/Makefile
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
 create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
 create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
 create mode 100644 drivers/media/platform/ti-vpe/vpe.c
 create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
 create mode 100644 drivers/media/rc/st_rc.c
 create mode 100644 include/media/lm3560.h

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJShPMnAAoJEAhfPr2O5OEVCjYP/2J5gILVD+F5CWkcjEBslD2m
NQSKGDFVjfEVmsRzfBzLSxr35Wd1mYyb3zVVXNKNONsvIc/xgL1nnVC/YapexgXl
YkwNMjaRslxJQn+msdMd3btTcuK8hWkp2N2KjwgqKx5asFgEL/+imGc2u6PVF79D
rdRa+lNWi31XG6oJeiZkXhbCykEVy38jlubQD+pEE1H35fJ3wUtp2pfVf+VIuRd/
8RXx7WQAW/Yop+/N5GD97zIsQbc7BiB6FWR1hHwpe5gJABWCffnxT6eKVRrPONSX
kQ9i1EnH3G+Ox+IomCYR4IT66+px5/swruY5V0RUjoD0nEAt4W11R77AN+SC/D6g
1vosRdH3nOfEPetaGyFefHT5NMPQLTGa5yFxztK+UQZDv59FYOgBHBIWabfBeCDu
csfqo+mQ2Kz7QEH72/yYVv1pMiAa1eDL2EZJkHxr/ZQ7PMok1S1Qi3H+uItcCGaj
QJAqE6h0Qvt6SbzALisrDavhdvF8+/nKb+W2aWkG2fho4Ohu+AKFL2rGMglNCNqG
7S78wRQPFCnQ9VhOr+41wDOJ3HqJKWA9h+AvnCdPgZmmAyO7d3DMYSLUWlNu0ziS
A93Xf/rsCHNT/+fBlz6bD4IvHhS+b/Fjz1izQVtS6wnRrrLBLJUNsW6cWOyYRO/c
OmBZwly9JsSWJmeUYHir
=UFNc
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
