Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaFDSWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:22:48 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:36416 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaFDSWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:22:46 -0400
X-AuditID: cbfec373-b7fd56d0000060dc-20-538f63f4d031
Date: Wed, 04 Jun 2014 15:22:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.16-rc1] media updates for next
Message-id: <20140604152238.2f7fa815.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e9wiO6X5P5gg85NHBZz1q9hs7i8aw6b
	Rc+GrawWj/resjuweJyY8ZvF4/MmuQCmKC6blNSczLLUIn27BK6Mvyc72Ao27mCquND+hrGB
	8c9Txi5GDg4JAROJHTsEuxg5gUwxiQv31rN1MXJxCAksYZRY13GaEcJpZpI4NWUeM0gVi4Cq
	xNaf7WA2m4CRxKvGFlYQWwTI/vziCitIA7PAYkaJj8/Xs4MkhAUsJE4f/cUIYvMKWEn8+LiS
	BWKds8SF5uUsEHFBiR+T74HZzALqEpPmLWKGsLUlnry7wDqBkW8WkrJZSMpmISlbwMi8ilG0
	tDi5oDgpPddIrzgxt7g0L10vOT93EyMk/Ip3ML7YYHWIUYCDUYmHd0Fcf7AQa2JZcWXuIUYJ
	DmYlEV4zFaAQb0piZVVqUX58UWlOavEhRiYOTqkGxlmVyhvZ5yac9Jf0bzk0+XKFkYNq7hch
	27D3y6/2Ge7oCOVZbV8iGDSD9dLzw71dd9Ze0/0b9HXhhpILuns+dZ5jm/vQXC7JKvR/nllf
	ac57UZdE70MvvCa/3/tqV/aBfYf7pS5fMl3htEWF2SvUwahUi/n39OdBNx9xHsuaVVRyMilQ
	dvWVo0osxRmJhlrMRcWJAAPmhIIdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the media updates for the next kernel version. It contains:
	- a new frontend/tuner driver set for si2168 and sa2157;
	- Videobuf 2 core now supports DVB too;
	- A new gspca sub-driver (dtcs033);
	- saa7134 is now converted to use videobuf2;
	- add support for 4K timings;
	- several other driver fixes and improvements.

Thanks!
Mauro

PS.: This pull request is shorter than usual, partly because I have some
other patches on topic branches that I'll be sending you latter this
week.

-

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to a2668e10d7246e782f7708dc47c00f035da23a81:

  [media] au0828-dvb: restore its permission to 644 (2014-06-04 15:19:36 -0300)

----------------------------------------------------------------
Alessandro Miceli (2):
      [media] rtl28xxu: add [1b80:d39d] Sveon STV20
      [media] rtl28xxu: add [1b80:d3af] Sveon STV27

Alexander Shiyan (3):
      [media] media: coda: Use full device name for request_irq()
      [media] media: mx2-emmaprp: Cleanup internal structure
      [media] media: mx2-emmaprp: Add missing mutex_destroy()

Anton Leontiev (1):
      [media] uvcvideo: Fix marking buffer erroneous in case of FID toggling

Antti Palosaari (12):
      [media] si2157: Silicon Labs Si2157 silicon tuner driver
      [media] si2168: Silicon Labs Si2168 DVB-T/T2/C demod driver
      [media] em28xx: add [2013:025f] PCTV tripleStick (292e)
      [media] si2168: add support for DVB-T2
      [media] si2157: extend frequency range for DVB-C
      [media] si2168: add support for DVB-C (annex A version)
      [media] si2157: add copyright and license
      [media] si2168: add copyright and license
      [media] MAINTAINERS: add si2168 driver
      [media] MAINTAINERS: add si2157 driver
      [media] si2168: relax demod lock checks a little
      [media] em28xx: PCTV tripleStick (292e) LNA support

Archit Taneja (5):
      [media] v4l: ti-vpe: register video device only when firmware is loaded
      [media] v4l: ti-vpe: Allow DMABUF buffer type support
      [media] v4l: ti-vpe: Fix some params in VPE data descriptors
      [media] v4l: ti-vpe: Add selection API in VPE driver
      [media] v4l: ti-vpe: Rename csc memory resource name

Arun Kumar K (4):
      [media] s5p-mfc: Update scratch buffer size for MPEG4
      [media] s5p-mfc: Move INIT_BUFFER_OPTIONS from v7 to v6
      [media] s5p-mfc: Rename IS_MFCV7 macro
      [media] v4l: Add source change event

Bartlomiej Zolnierkiewicz (1):
      [media] v4l: ti-vpe: fix devm_ioremap_resource() return value checking

Brian Healy (1):
      [media] rtl28xxu: add 1b80:d395 Peak DVB-T USB

Changbing Xiong (1):
      [media] au0828: Cancel stream-restart operation if frontend is disconnected

Daeseok Youn (1):
      [media] s2255drv: fix memory leak s2255_probe()

Dan Carpenter (2):
      [media] av7110: fix confusing indenting
      [media] Staging: dt3155v4l: set error code on failure

Daniel Glöckner (1):
      [media] bttv: Add support for PCI-8604PW

Ezequiel Garcia (1):
      [media] media: stk1160: Avoid stack-allocated buffer for control URBs

Frank Schaefer (24):
      [media] em28xx: fix indenting in em28xx_usb_probe()
      [media] em28xx: remove some unused fields from struct em28xx
      [media] em28xx: remove function em28xx_compression_disable() and its call
      [media] em28xx: move norm_maxw() and norm_maxh() from em28xx.h to em28xx-video.c
      [media] em28xx: remove the i2c_set_adapdata() call in em28xx_i2c_register()
      [media] em28xx: move sub-module data structs to a common place in the main struct
      [media] em28xx-video: simplify usage of the pointer to struct v4l2_ctrl_handler in em28xx_v4l2_init()
      [media] em28xx: start moving em28xx-v4l specific data to its own struct
      [media] em28xx: move struct v4l2_ctrl_handler ctrl_handler from struct em28xx to struct v4l2
      [media] em28xx: move struct v4l2_clk *clk from struct em28xx to struct v4l2
      [media] em28xx: move video_device structs from struct em28xx to struct v4l2
      [media] em28xx: move videobuf2 related data from struct em28xx to struct v4l2
      [media] em28xx: move v4l2 frame resolutions and scale data from struct em28xx to struct v4l2
      [media] em28xx: move vinmode and vinctrl data from struct em28xx to struct v4l2
      [media] em28xx: move TV norm from struct em28xx to struct v4l2
      [media] em28xx: move struct em28xx_fmt *format from struct em28xx to struct v4l2
      [media] em28xx: move progressive/interlaced fields from struct em28xx to struct v4l2
      [media] em28xx: move sensor parameter fields from struct em28xx to struct v4l2
      [media] em28xx: move capture state tracking fields from struct em28xx to struct v4l2
      [media] em28xx: move v4l2 user counting fields from struct em28xx to struct v4l2
      [media] em28xx: move tuner frequency field from struct em28xx to struct v4l2
      [media] em28xx: remove field tda9887_conf from struct em28xx
      [media] em28xx: remove field tuner_addr from struct em28xx
      [media] em28xx: move fields wq_trigger and streaming_started from struct em28xx to struct em28xx_audio

Guennadi Liakhovetski (2):
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Hans Verkuil (40):
      [media] v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
      [media] videobuf2-core: fix sparse errors
      [media] v4l2-common.h: remove __user annotation in struct v4l2_edid
      [media] v4l2-ioctl.c: fix sparse __user-related warnings
      [media] v4l2-dv-timings.h: add CEA-861-F 4K timings
      [media] v4l2-dv-timings.c: add the new 4K timings to the list
      [media] vb2: fix handling of data_offset and v4l2_plane.reserved[]
      [media] vb2: if bytesused is 0, then fill with output buffer length
      [media] vb2: use correct prefix
      [media] vb2: move __qbuf_mmap before __qbuf_userptr
      [media] vb2: set timestamp when using write()
      [media] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
      [media] vb2: simplify a confusing condition
      [media] vb2: add vb2_fileio_is_active and check it more often
      [media] vb2: allow read/write as long as the format is single planar
      [media] vb2: start messages with a lower-case for consistency
      [media] DocBook media: update bytesused field description
      [media] v4l2-pci-skeleton.c: fix alternate field handling
      [media] vb2: add thread support
      [media] vb2: Add videobuf2-dvb support
      [media] vb2: stop_streaming should return void
      [media] bfin_capture: drop unnecessary vb2_is_streaming check
      [media] vb2: fix compiler warning
      [media] saa7134: fix regression with tvtime
      [media] saa7134: coding style cleanups
      [media] saa7134: drop abuse of low-level videobuf functions
      [media] saa7134: swap ts_init_encoder and ts_reset_encoder
      [media] saa7134: store VBI hlen/vlen globally
      [media] saa7134: remove fmt from saa7134_buf
      [media] saa7134: rename empress_tsq to empress_vbq
      [media] v4l2-subdev.h: add g_tvnorms video op
      [media] tw9910: add g_tvnorms video op
      [media] soc_camera: disable STD ioctls if no tvnorms are set
      [media] v4l2-pci-skeleton: fix typo
      [media] v4l2-ioctl: drop spurious newline in string
      [media] saa7134: rename vbi/cap to vbi_vbq/cap_vbq
      [media] saa7134: move saa7134_pgtable to saa7134_dmaqueue
      [media] saa7134: convert to vb2
      [media] saa7134: add saa7134_userptr module option to enable USERPTR
      [media] DocBook media: fix typo

Himangi Saraogi (1):
      [media] timblogiw: Introduce the use of the managed version of kzalloc

Ismael Luceno (3):
      [media] gspca_gl860: Clean up idxdata structs
      [media] solo6x10: Reduce OSD writes to the minimum necessary
      [media] solo6x10: Kconfig: Add supported card list to the SOLO6X10 knob

Jacek Anaszewski (8):
      [media] s5p-jpeg: Add fmt_ver_flag field to the s5p_jpeg_variant structure
      [media] s5p-jpeg: Perform fourcc downgrade only for Exynos4x12 SoCs
      [media] s5p-jpeg: Add m2m_ops field to the s5p_jpeg_variant structure
      [media] s5p-jpeg: g_selection callback should always succeed
      [media] s5p-jpeg: Fix sysmmu page fault
      [media] s5p-jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0 decompression
      [media] s5p-jpeg: Fix build break when CONFIG_OF is undefined
      [media] s5p-jpeg: Fix NV12 format entry related to S5C2120 SoC

Jinqiang Zeng (1):
      [media] fix the code style errors in sn9c102

John Sheu (1):
      [media] s5p-mfc: fix encoder crash after VIDIOC_STREAMOFF

Kamil Debski (3):
      [media] v4l: s5p-mfc: Fix default pixel format selection for decoder
      [media] v4l: s5p-mfc: Limit enum_fmt to output formats of current version
      [media] v4l: Fix documentation of V4L2_PIX_FMT_H264_MVC and VP8 pixel formats

Kiran AVND (4):
      [media] s5p-mfc: Update scratch buffer size for VP8 encoder
      [media] s5p-mfc: Add variants to access mfc registers
      [media] s5p-mfc: Core support to add v8 decoder
      [media] s5p-mfc: Core support for v8 encoder

Kirill Tkhai (1):
      [media] s2255: Do not free fw_data until timer handler has actually stopped using it

Lad, Prabhakar (53):
      [media] media: davinci: vpbe: use v4l2_fh for priority handling
      [media] media: davinci: vpfe: use v4l2_fh for priority handling
      [media] staging: media: davinci: vpfe: use v4l2_fh for priority handling
      [media] staging: media: davinci: vpfe: release buffers in case start_streaming call back fails
      [media] media: davinci: vpbe: release buffers in case start_streaming call back fails
      [media] media: davinci: vpif_display: initialize vb2 queue and DMA context during probe
      [media] media: davinci: vpif_display: drop buf_init() callback
      [media] media: davinci: vpif_display: use vb2_ops_wait_prepare/finish helper functions
      [media] media: davinci: vpif_display: release buffers in case start_streaming() call back fails
      [media] media: davinci: vpif_display: drop buf_cleanup() callback
      [media] media: davinci: vpif_display: improve vpif_buffer_prepare() callback
      [media] media: davinci: vpif_display: improve vpif_buffer_queue_setup() function
      [media] media: davinci: vpif_display: improve start/stop_streaming callbacks
      [media] media: davinci: vpif_display: use vb2_fop_mmap/poll
      [media] media: davinci: vpif_display: use v4l2_fh_open and vb2_fop_release
      [media] media: davinci: vpif_display: use vb2_ioctl_* helpers
      [media] media: davinci: vpif_display: drop unused member fbuffers
      [media] media: davinci: vpif_display: drop reserving memory for device
      [media] media: davinci: vpif_display: drop unnecessary field memory
      [media] media: davinci: vpif_display: drop numbuffers field from common_obj
      [media] media: davinic: vpif_display: drop started member from struct common_obj
      [media] media: davinci: vpif_display: initialize the video device in single place
      [media] media: davinci: vpif_display: drop unneeded module params
      [media] media: davinci: vpif_display: drop cropcap
      [media] media: davinci: vpif_display: group v4l2_ioctl_ops
      [media] media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
      [media] media: davinci: vpif_display: return -ENODATA for *dv_timings calls
      [media] media: davinci: vpif_display: return -ENODATA for *std calls
      [media] media: davinci; vpif_display: fix checkpatch error
      [media] media: davinci: vpif_display: fix v4l-compliance issues
      [media] media: davinci: vpif_capture: initalize vb2 queue and DMA context during probe
      [media] media: davinci: vpif_capture: drop buf_init() callback
      [media] media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper functions
      [media] media: davinci: vpif_capture: release buffers in case start_streaming() call back fails
      [media] media: davinci: vpif_capture: drop buf_cleanup() callback
      [media] media: davinci: vpif_capture: improve vpif_buffer_prepare() callback
      [media] media: davinci: vpif_capture: improve vpif_buffer_queue_setup() function
      [media] media: davinci: vpif_capture: improve start/stop_streaming callbacks
      [media] media: davinci: vpif_capture: use vb2_fop_mmap/poll
      [media] media: davinci: vpif_capture: use v4l2_fh_open and vb2_fop_release
      [media] media: davinci: vpif_capture: use vb2_ioctl_* helpers
      [media] media: davinci: vpif_capture: drop reserving memory for device
      [media] media: davinci: vpif_capture: drop unnecessary field memory
      [media] media: davinic: vpif_capture: drop started member from struct common_obj
      [media] media: davinci: vpif_capture: initialize the video device in single place
      [media] media: davinci: vpif_capture: drop unneeded module params
      [media] media: davinci: vpif_capture: drop cropcap
      [media] media: davinci: vpif_capture: group v4l2_ioctl_ops
      [media] media: davinci: vpif_capture: use SIMPLE_DEV_PM_OPS
      [media] media: davinci: vpif_capture: return -ENODATA for *dv_timings calls
      [media] media: davinci: vpif_capture: return -ENODATA for *std calls
      [media] media: davinci: vpif_capture: drop check __KERNEL__
      [media] media: davinci: vpif: add Copyright message

Lars-Peter Clausen (1):
      [media] adv7604: Add missing include to linux/types.h

Laurent Pinchart (37):
      [media] v4l: Add UYVY10_2X10 and VYUY10_2X10 media bus pixel codes
      [media] v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
      [media] v4l: Add 12-bit YUV 4:2:0 media bus pixel codes
      [media] v4l: Add 12-bit YUV 4:2:2 media bus pixel codes
      [media] omap4iss: Don't check for DEBUG when printing IRQ debugging messages
      [media] omap4iss: Add missing white space
      [media] omap4iss: Use a common macro for all sleep-based poll loops
      [media] omap4iss: Relax usleep ranges
      [media] v4l: vb2: Avoid double WARN_ON when stopping streaming
      [media] mt9p031: Really disable Black Level Calibration in test pattern mode
      [media] mt9p031: Fix BLC configuration restore when disabling test pattern
      [media] Documentation: media: Remove double 'struct'
      [media] tvp5150: Replace container_of() with to_tvp5150()
      [media] v4l: subdev: Move [gs]_std operation to video ops
      [media] v4l: Add pad-level DV timings subdev operations
      [media] ad9389b: Add pad-level DV timings operations
      [media] adv7511: Add pad-level DV timings operations
      [media] adv7842: Add pad-level DV timings operations
      [media] s5p-tv: hdmi: Add pad-level DV timings operations
      [media] s5p-tv: hdmiphy: Add pad-level DV timings operations
      [media] ths8200: Add pad-level DV timings operations
      [media] tvp7002: Add pad-level DV timings operations
      [media] media: bfin_capture: Switch to pad-level DV operations
      [media] media: davinci: vpif: Switch to pad-level DV operations
      [media] media: staging: davinci: vpfe: Switch to pad-level DV operations
      [media] s5p-tv: mixer: Switch to pad-level DV operations
      [media] ad9389b: Remove deprecated video-level DV timings operations
      [media] adv7511: Remove deprecated video-level DV timings operations
      [media] adv7842: Remove deprecated video-level DV timings operations
      [media] s5p-tv: hdmi: Remove deprecated video-level DV timings operations
      [media] s5p-tv: hdmiphy: Remove deprecated video-level DV timings operation
      [media] ths8200: Remove deprecated video-level DV timings operations
      [media] tvp7002: Remove deprecated video-level DV timings operations
      [media] v4l: Improve readability by not wrapping ioctl number #define's
      [media] v4l: Add support for DV timings ioctls on subdev nodes
      [media] v4l: Validate fields in the core code for subdev EDID ioctls
      [media] m5mols: Replace missing header

Luis R. Rodriguez (2):
      [media] technisat-usb2: rename led enums to be specific to driver
      [media] bt8xx: make driver routines fit into its own namespcae

Ma Haijun (1):
      [media] videobuf-dma-contig: fix incorrect argument to vm_iomap_memory() call

Manuel Schönlaub (1):
      [media] az6027: Added the PID for a new revision of the Elgato EyeTV Sat DVB-S Tuner

Martin Bugge (2):
      [media] adv7842: update RGB quantization range on HDMI/DVI-D mode irq
      [media] adv7842: Disable access to EDID DDC lines before chip power up

Masanari Iida (1):
      [media] media: parport: Fix format string mismatch in bw-qcam.c

Matt DeVillier (1):
      [media] fix mceusb endpoint type identification/handling

Mauro Carvalho Chehab (14):
      Documentation: Update cardlists
      saa7134-alsa: include vmalloc.h
      Merge tag 'v3.15-rc6' into patchwork
      [media] em28xx: make em28xx_free_v4l2 static()
      Revert "[media] media: davinci: vpif_capture: drop unneeded module params"
      [media] dib0700: fix RC support on Hauppauge Nova-TD
      [media] au0828: Improve debug messages for urb_completion
      [media] au0828: reset streaming when a new frequency is set
      [media] xc5000: get rid of positive error codes
      [media] xc5000: Don't wrap msleep()
      [media] xc5000: fix CamelCase
      [media] xc5000: Don't use whitespace before tabs
      [media] xc5000: delay tuner sleep to 5 seconds
      [media] au0828-dvb: restore its permission to 644

Mike Sampson (1):
      [media] sn9c102_hv7131r: fix style warnings flagged by checkpatch.pl

Mikhail Domrachev (1):
      [media] saa7134: add vidioc_querystd

Nicolas Dufresne (3):
      [media] s5p-fimc: Iterate for each memory plane
      [media] s5p-fimc: Changed RGB32 to BGR32
      [media] s5p-fimc: Reuse calculated sizes

Olivier Langlois (1):
      [media] uvcvideo: Fix clock param realtime setting

Pali Rohár (1):
      [media] radio-bcm2048: fix wrong overflow check

Paul Bolle (1):
      [media] omap4iss: Remove VIDEO_OMAP4_DEBUG Kconfig option

Pawel Osciak (6):
      [media] s5p-mfc: Copy timestamps only when a frame is produced
      [media] s5p-mfc: Fixes for decode REQBUFS
      [media] s5p-mfc: Extract open/close MFC instance commands
      [media] s5p-mfc: Don't allocate codec buffers on STREAMON
      [media] s5p-mfc: Don't try to resubmit VP8 bitstream buffer for decode
      [media] s5p-mfc: Add support for resolution change event

Peter Senna Tschudin (1):
      [media] USB: as102_usb_drv.c: Remove useless return variables

Philipp Zabel (1):
      [media] vb2: fix num_buffers calculation if req->count > VIDEO_MAX_FRAMES

Ricardo Ribalda (1):
      [media] videobuf2-dma-sg: Fix NULL pointer dereference BUG

Robert Butora (2):
      [media] media/usb/gspca: Add support for Scopium astro webcam (0547:7303)
      [media] media:gspca:dtcs033 Clean sparse check warnings on endianess

Sakari Ailus (22):
      [media] smiapp: Remove unused quirk register functionality
      [media] smiapp: Rename SMIA_REG to SMIAPP_REG for consistency
      [media] smiapp: Fix determining the need for 8-bit read access
      [media] smiapp: Add a macro for constructing 8-bit quirk registers
      [media] smiapp: Use I2C adapter ID and address in the sub-device name
      [media] smiapp: Make PLL flags separate from regular quirk flags
      [media] smiapp: Make PLL flags unsigned long
      [media] smiapp: Make PLL (quirk) flags a function
      [media] smiapp: Add register diversion quirk
      [media] smiapp: Define macros for obtaining properties of register definitions
      [media] smiapp: Use %u for printing u32 value
      [media] v4l: Check pad arguments for [gs]_frame_interval
      [media] media: Use a better owner for the media device
      [media] v4l: Only get module if it's different than the driver for v4l2_dev
      [media] v4l: V4L2_MBUS_FRAME_DESC_FL_BLOB is about 1D DMA
      [media] v4l: Remove documentation for nonexistend input field in v4l2_buffer
      [media] smiapp: Print the index of the format descriptor
      [media] smiapp: Call limits quirk immediately after retrieving the limits
      [media] smiapp: Scaling goodness is signed
      [media] smiapp: Use better regulator name for the Device tree
      [media] smiapp: Check for GPIO validity using gpio_is_valid()
      [media] smiapp: Return correct return value in smiapp_registered()

Sylwester Nawrocki (4):
      [media] exynos4-is: Fix compilation for !CONFIG_COMMON_CLK
      [media] exynos4-is: Free FIMC-IS CPU memory only when allocated
      [media] ARM: S5PV210: Remove camera support from mach-goni.c
      [media] exynos4-is: Remove support for non-dt platforms

Takashi Iwai (1):
      [media] ivtv: Fix Oops when no firmware is loaded

Tuomas Tynkkynen (1):
      [media] staging: lirc: Fix sparse warnings

Victor Lambret (1):
      [media] videobuf2-core: remove duplicated code

Vitaly Osipov (2):
      [media] staging: media: omap24xx: fix up checkpatch error message
      [media] staging: media: omap24xx: use pr_info() instead of KERN_INFO

ileana@telecom-paristech.fr (1):
      [media] staging: omap24xx: fix coding style

 Documentation/DocBook/media/v4l/io.xml             |   15 +-
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |    8 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |    4 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml |  760 ++++++++++++
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   33 +
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |   27 +-
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |   30 +-
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   20 +
 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 Documentation/video4linux/CARDLIST.bttv            |    1 +
 Documentation/video4linux/CARDLIST.em28xx          |    1 +
 Documentation/video4linux/fimc.txt                 |   30 -
 Documentation/video4linux/v4l2-pci-skeleton.c      |   42 +-
 MAINTAINERS                                        |   21 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   51 -
 drivers/media/dvb-core/dvb-usb-ids.h               |    3 +
 drivers/media/dvb-frontends/Kconfig                |    7 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/si2168.c               |  760 ++++++++++++
 drivers/media/dvb-frontends/si2168.h               |   39 +
 drivers/media/dvb-frontends/si2168_priv.h          |   46 +
 drivers/media/i2c/ad9389b.c                        |   64 +-
 drivers/media/i2c/adv7180.c                        |    2 +-
 drivers/media/i2c/adv7183.c                        |    4 +-
 drivers/media/i2c/adv7511.c                        |   66 +-
 drivers/media/i2c/adv7604.c                        |    4 -
 drivers/media/i2c/adv7842.c                        |   28 +-
 drivers/media/i2c/bt819.c                          |    2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |    4 +-
 drivers/media/i2c/ks0127.c                         |    6 +-
 drivers/media/i2c/m5mols/m5mols_capture.c          |    2 +-
 drivers/media/i2c/ml86v7667.c                      |    2 +-
 drivers/media/i2c/msp3400-driver.c                 |    2 +-
 drivers/media/i2c/mt9p031.c                        |   53 +-
 drivers/media/i2c/saa6752hs.c                      |    2 +-
 drivers/media/i2c/saa7110.c                        |    2 +-
 drivers/media/i2c/saa7115.c                        |    2 +-
 drivers/media/i2c/saa717x.c                        |    2 +-
 drivers/media/i2c/saa7191.c                        |    2 +-
 drivers/media/i2c/smiapp-pll.h                     |    2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   57 +-
 drivers/media/i2c/smiapp/smiapp-quirk.c            |   55 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h            |   24 +-
 drivers/media/i2c/smiapp/smiapp-reg-defs.h         |    8 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |   89 +-
 drivers/media/i2c/smiapp/smiapp-regs.h             |   19 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   11 +-
 drivers/media/i2c/sony-btf-mpx.c                   |   10 +-
 drivers/media/i2c/ths8200.c                        |   10 +
 drivers/media/i2c/tvaudio.c                        |    6 +-
 drivers/media/i2c/tvp514x.c                        |    2 +-
 drivers/media/i2c/tvp5150.c                        |    6 +-
 drivers/media/i2c/tvp7002.c                        |    5 +-
 drivers/media/i2c/tw2804.c                         |    2 +-
 drivers/media/i2c/tw9903.c                         |    2 +-
 drivers/media/i2c/tw9906.c                         |    2 +-
 drivers/media/i2c/vp27smpx.c                       |    6 +-
 drivers/media/i2c/vpx3220.c                        |    2 +-
 drivers/media/media-device.c                       |    7 +-
 drivers/media/media-devnode.c                      |    5 +-
 drivers/media/parport/bw-qcam.c                    |    2 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |  110 ++
 drivers/media/pci/bt8xx/bttv-driver.c              |    2 +-
 drivers/media/pci/bt8xx/bttv.h                     |    1 +
 drivers/media/pci/bt8xx/dst.c                      |   20 +-
 drivers/media/pci/cx18/cx18-av-core.c              |    2 +-
 drivers/media/pci/cx18/cx18-fileops.c              |    2 +-
 drivers/media/pci/cx18/cx18-gpio.c                 |    6 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    4 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |    6 +
 drivers/media/pci/ivtv/ivtv-fileops.c              |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |    2 +-
 drivers/media/pci/saa7134/Kconfig                  |    4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |  107 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  130 ++-
 drivers/media/pci/saa7134/saa7134-dvb.c            |   50 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |  187 ++-
 drivers/media/pci/saa7134/saa7134-i2c.c            |    7 -
 drivers/media/pci/saa7134/saa7134-reg.h            |   12 +-
 drivers/media/pci/saa7134/saa7134-ts.c             |  191 ++--
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |    7 -
 drivers/media/pci/saa7134/saa7134-vbi.c            |  175 ++-
 drivers/media/pci/saa7134/saa7134-video.c          |  697 +++++------
 drivers/media/pci/saa7134/saa7134.h                |  108 +-
 drivers/media/pci/saa7146/mxb.c                    |   14 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    7 +-
 drivers/media/pci/ttpci/av7110_av.c                |    6 +-
 drivers/media/pci/zoran/zoran_device.c             |    2 +-
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |   14 +-
 drivers/media/platform/coda.c                      |    6 +-
 drivers/media/platform/davinci/vpbe_display.c      |   55 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   15 +-
 drivers/media/platform/davinci/vpif_capture.c      | 1119 +++++-------------
 drivers/media/platform/davinci/vpif_capture.h      |   28 -
 drivers/media/platform/davinci/vpif_display.c      | 1206 ++++++--------------
 drivers/media/platform/davinci/vpif_display.h      |   44 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |    4 +-
 drivers/media/platform/exynos4-is/Kconfig          |    3 +-
 drivers/media/platform/exynos4-is/common.c         |    2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    6 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    6 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    3 +
 drivers/media/platform/exynos4-is/fimc-isp-video.c |    7 +-
 drivers/media/platform/exynos4-is/fimc-isp.h       |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c  |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    8 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    9 +-
 drivers/media/platform/exynos4-is/fimc-reg.c       |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  329 +-----
 drivers/media/platform/exynos4-is/media-dev.h      |    2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   43 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |    7 +-
 drivers/media/platform/mem2mem_testdev.c           |    5 +-
 drivers/media/platform/mx2_emmaprp.c               |   37 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  122 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    6 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h       |    4 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h       |    5 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |  124 ++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   79 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   62 +
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    3 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  290 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   96 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |    6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  254 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  842 +++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    7 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   14 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |    9 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   11 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    6 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    4 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   12 +-
 drivers/media/platform/ti-vpe/csc.c                |    6 +-
 drivers/media/platform/ti-vpe/sc.c                 |    4 +-
 drivers/media/platform/ti-vpe/vpdma.c              |   68 +-
 drivers/media/platform/ti-vpe/vpdma.h              |   17 +-
 drivers/media/platform/ti-vpe/vpe.c                |  227 +++-
 drivers/media/platform/timblogiw.c                 |   10 +-
 drivers/media/platform/vino.c                      |    6 +-
 drivers/media/platform/vivi.c                      |    3 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    4 +-
 drivers/media/rc/mceusb.c                          |   65 +-
 drivers/media/tuners/Kconfig                       |    7 +
 drivers/media/tuners/Makefile                      |    1 +
 drivers/media/tuners/si2157.c                      |  260 +++++
 drivers/media/tuners/si2157.h                      |   34 +
 drivers/media/tuners/si2157_priv.h                 |   37 +
 drivers/media/tuners/xc5000.c                      |  302 ++---
 drivers/media/usb/au0828/au0828-dvb.c              |   57 +-
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/au0828/au0828.h                  |    2 +
 drivers/media/usb/cx231xx/cx231xx-417.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    6 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |    6 +
 drivers/media/usb/dvb-usb/az6027.c                 |    7 +-
 drivers/media/usb/dvb-usb/dib0700.h                |    2 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   43 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |    2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   28 +-
 drivers/media/usb/em28xx/Kconfig                   |    2 +
 drivers/media/usb/em28xx/em28xx-audio.c            |   39 +-
 drivers/media/usb/em28xx/em28xx-camera.c           |   51 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   47 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   89 ++
 drivers/media/usb/em28xx/em28xx-i2c.c              |    1 -
 drivers/media/usb/em28xx/em28xx-v4l.h              |    2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |   10 +-
 drivers/media/usb/em28xx/em28xx-video.c            |  622 +++++-----
 drivers/media/usb/em28xx/em28xx.h                  |  153 ++-
 drivers/media/usb/gspca/Kconfig                    |   10 +
 drivers/media/usb/gspca/Makefile                   |    2 +
 drivers/media/usb/gspca/dtcs033.c                  |  441 +++++++
 drivers/media/usb/gspca/gl860/gl860-mi2020.c       |  464 ++++----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |    2 +-
 drivers/media/usb/pwc/pwc-if.c                     |    7 +-
 drivers/media/usb/s2255/s2255drv.c                 |   11 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   10 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    8 +-
 drivers/media/usb/stk1160/stk1160.h                |    1 -
 drivers/media/usb/tm6000/tm6000-cards.c            |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    9 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    2 +-
 drivers/media/usb/uvc/uvc_video.c                  |   36 +-
 drivers/media/v4l2-core/Kconfig                    |    4 +
 drivers/media/v4l2-core/Makefile                   |    1 +
 drivers/media/v4l2-core/tuner-core.c               |    6 +-
 drivers/media/v4l2-core/v4l2-device.c              |   18 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   11 +
 drivers/media/v4l2-core/v4l2-event.c               |   36 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   12 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   67 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  706 ++++++++----
 drivers/media/v4l2-core/videobuf2-dma-sg.c         |    2 +-
 drivers/media/v4l2-core/videobuf2-dvb.c            |  336 ++++++
 drivers/staging/media/as102/as102_usb_drv.c        |    7 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c      |    2 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |    2 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   27 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    7 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |    5 +-
 drivers/staging/media/go7007/s2250-board.c         |    2 +-
 drivers/staging/media/go7007/saa7134-go7007.c      |    4 +
 drivers/staging/media/lirc/lirc_bt829.c            |    6 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   26 +-
 drivers/staging/media/lirc/lirc_serial.c           |   11 +-
 drivers/staging/media/lirc/lirc_sir.c              |   33 +-
 drivers/staging/media/lirc/lirc_zilog.c            |   23 +-
 drivers/staging/media/msi3101/sdr-msi3101.c        |   24 +-
 drivers/staging/media/omap24xx/tcm825x.c           |   12 +-
 drivers/staging/media/omap24xx/tcm825x.h           |    4 +-
 drivers/staging/media/omap4iss/Kconfig             |    6 -
 drivers/staging/media/omap4iss/iss.c               |   52 +-
 drivers/staging/media/omap4iss/iss.h               |   14 +
 drivers/staging/media/omap4iss/iss_csi2.c          |   39 +-
 drivers/staging/media/omap4iss/iss_video.h         |    2 +-
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c   |    7 +-
 drivers/staging/media/sn9c102/sn9c102.h            |   30 +-
 drivers/staging/media/sn9c102/sn9c102_core.c       |  342 +++---
 drivers/staging/media/sn9c102/sn9c102_devtable.h   |   22 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |   22 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |   23 +-
 drivers/staging/media/sn9c102/sn9c102_mi0343.c     |   30 +-
 drivers/staging/media/sn9c102/sn9c102_mi0360.c     |   30 +-
 drivers/staging/media/sn9c102/sn9c102_ov7630.c     |   22 +-
 drivers/staging/media/sn9c102/sn9c102_ov7660.c     |   22 +-
 drivers/staging/media/sn9c102/sn9c102_pas106b.c    |   22 +-
 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |   22 +-
 drivers/staging/media/sn9c102/sn9c102_sensor.h     |   34 +-
 drivers/staging/media/sn9c102/sn9c102_tas5110c1b.c |   18 +-
 drivers/staging/media/sn9c102/sn9c102_tas5110d.c   |   14 +-
 drivers/staging/media/sn9c102/sn9c102_tas5130d1b.c |   18 +-
 drivers/staging/media/solo6x10/Kconfig             |   12 +-
 drivers/staging/media/solo6x10/solo6x10-enc.c      |   31 +-
 drivers/staging/media/solo6x10/solo6x10-offsets.h  |    2 +
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |    3 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     |    3 +-
 include/linux/platform_data/mipi-csis.h            |   28 -
 include/media/adv7604.h                            |    2 +
 include/media/davinci/vpbe_display.h               |    6 +-
 include/media/davinci/vpfe_capture.h               |    6 +-
 include/media/{s5p_fimc.h => exynos-fimc.h}        |   21 -
 include/media/media-device.h                       |    4 +-
 include/media/media-devnode.h                      |    3 +-
 include/media/v4l2-device.h                        |    8 +
 include/media/v4l2-event.h                         |    4 +
 include/media/v4l2-subdev.h                        |   33 +-
 include/media/videobuf2-core.h                     |   51 +-
 include/media/videobuf2-dvb.h                      |   58 +
 include/uapi/linux/v4l2-common.h                   |    2 +-
 include/uapi/linux/v4l2-dv-timings.h               |   70 ++
 include/uapi/linux/v4l2-mediabus.h                 |   14 +-
 include/uapi/linux/v4l2-subdev.h                   |   40 +-
 include/uapi/linux/videodev2.h                     |   19 +-
 269 files changed, 9309 insertions(+), 5840 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/si2168.c
 create mode 100644 drivers/media/dvb-frontends/si2168.h
 create mode 100644 drivers/media/dvb-frontends/si2168_priv.h
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h
 create mode 100644 drivers/media/tuners/si2157.c
 create mode 100644 drivers/media/tuners/si2157.h
 create mode 100644 drivers/media/tuners/si2157_priv.h
 create mode 100644 drivers/media/usb/gspca/dtcs033.c
 create mode 100644 drivers/media/v4l2-core/videobuf2-dvb.c
 delete mode 100644 include/linux/platform_data/mipi-csis.h
 rename include/media/{s5p_fimc.h => exynos-fimc.h} (87%)
 create mode 100644 include/media/videobuf2-dvb.h

