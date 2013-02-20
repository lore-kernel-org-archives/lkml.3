Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935490Ab3BTUIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:08:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935207Ab3BTUEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:04:45 -0500
Date: Wed, 20 Feb 2013 17:04:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.9] media updates
Message-ID: <20130220170427.1862140b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For:
	- Some cleanups at V4L2 documentation;
	- new drivers: ts2020 frontend, ov9650 sensor, s5c73m3 sensor,
	  sh-mobile veu mem2mem driver, radio-ma901, davinci_vpfe staging
	  driver;
	- Lots of missing MAINTAINERS entries added;
	- several em28xx driver improvements, including its conversion to
	  videobuf2;
	- several fixups on drivers to make them to better comply with the API;
	- DVB core: add support for DVBv5 stats, allowing the implementation of
	  statistics for new standards like ISDB;
	- mb86a20s: add statistics to the driver;
	- lots of new board additions, cleanups, and  driver improvements.

Thank you!
Mauro

-

The following changes since commit 68d6f84ba0c47e658beff3a4bf0c43acee4b4690:

  [media] uvcvideo: Set error_idx properly for S_EXT_CTRLS failures (2013-01-11 13:30:27 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to ed72d37a33fdf43dc47787fe220532cdec9da528:

  [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff) (2013-02-13 18:05:29 -0200)

----------------------------------------------------------------
Al Viro (1):
      [media] omap_vout: find_vma() needs ->mmap_sem held

Alexander Inyukhin (1):
      [media] rtl28xxu: add Gigabyte U7300 DVB-T Dongle

Alexandre Lissy (1):
      [media] imon: fix Knob event interpretation issues on ARM

Alexey Klimov (5):
      [media] MAINTAINERS: add entry for radio-ma901 driver
      [media] MAINTAINERS: add entry for dsbr100 usb radio driver
      [media] media: add driver for Masterkit MA901 usb radio
      [hid] usb hid quirks for Masterkit MA901 usb radio
      [media] radio-si470x doc: add info about v4l2-ctl and sox+alsa

Alf Høgemark (1):
      [media] cx231xx : Add support for Elgato Video Capture V2

Alfredo Jesús Delaiti (2):
      [media] rc/keymaps: add RC keytable for MyGica X8507
      [media] cx23885: add RC support for MyGica X8507

Alistair Buxton (1):
      [media] rtl28xxu: Add USB IDs for Compro VideoMate U620F

Anatolij Gustschin (1):
      [media] soc_camera: fix VIDIOC_S_CROP ioctl

Andreas Regel (1):
      [media] stv090x: On STV0903 do not set registers of the second path

Andrzej Hajda (3):
      [media] s5p-fimc: Add support for sensors with multiple pads
      [media] V4L: Add S5C73M3 camera driver
      [media] MAINTAINERS: Add s5c73m3 driver entry

Andy Shevchenko (3):
      [media] or51211: use %*ph[N] to dump small buffers
      [media] ix2505v: use %*ph[N] to dump small buffers
      [media] or51211: apply pr_fmt and use pr_* macros instead of printk

Antonio Ospite (10):
      [media] dvb-usb: fix indentation of a for loop
      [media] m920x: fix a typo in a comment
      [media] m920x: factor out a m920x_write_seq() function
      [media] m920x: factor out a m920x_parse_rc_state() function
      [media] m920x: avoid repeating RC state parsing at each keycode
      [media] m920x: introduce m920x_rc_core_query()
      [media] m920x: send the RC init sequence also when rc.core is used
      [media] get_dvb_firmware: add entry for the vp7049 firmware
      [media] m920x: add support for the VP-7049 Twinhan DVB-T USB Stick
      [media] Documentation/media-framework.txt: fix a sentence

Antti Palosaari (30):
      [media] af9033: add support for Fitipower FC0012 tuner
      [media] af9035: support for Fitipower FC0012 tuner devices
      [media] af9035: dual mode related changes
      [media] fc0012: use struct for driver config
      [media] fc0012: add RF loop through
      [media] fc0012: enable clock output on attach()
      [media] af9035: add support for fc0012 dual tuner configuration
      [media] fc0012: use config directly from the config struct
      [media] fc0012: rework attach() to check chip id and I/O errors
      [media] fc0012: use Kernel dev_foo() logging
      [media] fc0012: remove unused callback and correct one comment
      [media] af9033: update demod init sequence
      [media] af9033: update tua9001 init sequence
      [media] af9033: update fc0011 init sequence
      [media] af9033: update fc2580 init sequence
      [media] af9035: print warning when firmware is bad
      [media] dvb_usb_v2: make remote controller optional
      [media] rtl28xxu: make remote controller optional
      [media] anysee: make remote controller optional
      [media] af9015: make remote controller optional
      [media] af9035: make remote controller optional
      [media] az6007: make remote controller optional
      [media] it913x: make remote controller optional
      [media] it913x: remove unused define and increase module version
      [media] dvb_usb_v2: remove rc-core stub implementations
      [media] dvb_usb_v2: use dummy function defines instead stub functions
      [media] dvb_usb_v2: change rc polling active/deactive logic
      [media] dvb_usb_v2: use IS_ENABLED() macro
      [media] rtl28xxu: [1b80:d3a8] ASUS My Cinema-U3100Mini Plus V2
      [media] rtl28xxu: correct some device names

Arun Kumar K (3):
      [media] s5p-mfc: Add device tree support
      [media] s5p-mfc: Flush DPB buffers during stream off
      [media] s5p-mfc: Fix kernel warning on memory init

Cesar Eduardo Barros (2):
      [media] MAINTAINERS: fix drivers/media/platform/atmel-isi.c
      [media] MAINTAINERS: fix drivers/media/usb/dvb-usb/cxusb*

Christoph Nuscheler (1):
      [media] media: Add 0x3009 USB PID to ttusb2 driver (fixed diff)

Cong Ding (1):
      [media] stv0900: remove unnecessary null pointer check

Cyril Roelandt (3):
      [media] mx2_camera: use GFP_ATOMIC under spin lock
      [media] staging/media/solo6x10/v4l2-enc.c: fix error-handling
      [media] media: saa7146: don't use mutex_lock_interruptible() in device_release()

Dan Carpenter (11):
      [media] rc: unlock on error in show_protocols()
      [media] rc: unlock on error in store_protocols()
      [media] mantis: cleanup NULL checking in mantis_ca_exit()
      [media] dvb: unlock on error in dvb_ca_en50221_io_do_ioctl()
      [media] staging: go7007: print the audio input type
      [media] cx231xx: add a missing break statement
      [media] tuners/xc5000: fix MODE_AIR in xc5000_set_params()
      [media] staging: go7007: fix test for V4L2_STD_SECAM
      [media] tm6000: check an allocation for failure
      [media] dvb-usb: check for invalid length in ttusb_process_muxpack()
      [media] mceusb: move check earlier to make smatch happy

Devin Heitmueller (1):
      [media] em28xx: convert to videobuf2

Eddi De Pieri (2):
      [media] it913x: add support for Avermedia A835B
      [media] Support Digivox Mini HD (rtl2832)

Erik Andrén (1):
      [media] gspca_stv06xx: Disable flip controls for vv6410 sensor

Evgeny Plehov (1):
      [media] stv0900: Multistream support

Ezequiel Garcia (24):
      [media] cx231xx: Replace memcpy with struct assignment
      [media] usbvision: Replace memcpy with struct assignment
      [media] sn9c102: Replace memcpy with struct assignment
      [media] pwc: Replace memcpy with struct assignment
      [media] pvrusb2: Replace memcpy with struct assignment
      [media] hdpvr: Replace memcpy with struct assignment
      [media] cx25840: Replace memcpy with struct assignment
      [media] zr36067: Replace memcpy with struct assignment
      [media] dvb-usb/friio-fe: Replace memcpy with struct assignment
      [media] au0828: Replace memcpy with struct assignment
      [media] tuners/xc4000: Replace memcpy with struct assignment
      [media] tuners/xc2028: Replace memcpy with struct assignment
      [media] tuners/tda18271: Replace memcpy with struct assignment
      [media] ivtv: Replace memcpy with struct assignment
      [media] cx88: Replace memcpy with struct assignment
      [media] cx23885: Replace memcpy with struct assignment
      [media] cx18: Replace memcpy with struct assignment
      [media] bttv: Replace memcpy with struct assignment
      [media] dvb-core: Replace memcpy with struct assignment
      [media] dvb-frontends: Replace memcpy with struct assignment
      [media] radio-wl1273: Replace memcpy with struct assignment
      [media] wl128x: Replace memcpy with struct assignment
      [media] stk1160: Replace BUG_ON with WARN_ON
      [media] uvcvideo: Replace memcpy with struct assignment

Fabio Estevam (2):
      [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
      [media] mx2_camera: Convert it to platform driver

Federico Vaga (2):
      [media] sta2x11_vip: convert to videobuf2, control framework, file handler
      [media] adv7180: remove {query/g_/s_}ctrl

Frank Schaefer (57):
      [media] em28xx: input: fix oops on device removal
      [media] em28xx: fix wrong data offset for non-interlaced mode in em28xx_copy_video
      [media] em28xx: clarify meaning of field 'progressive' in struct em28xx
      [media] em28xx: rename isoc packet number constants and parameters
      [media] em28xx: rename struct em28xx_usb_isoc_bufs to em28xx_usb_bufs
      [media] em28xx: rename struct em28xx_usb_isoc_ctl to em28xx_usb_ctl
      [media] em28xx: remove obsolete #define EM28XX_URB_TIMEOUT
      [media] em28xx: update description of em28xx_irq_callback
      [media] em28xx: rename function em28xx_uninit_isoc to em28xx_uninit_usb_xfer
      [media] em28xx: create a common function for isoc and bulk URB allocation and setup
      [media] em28xx: create a common function for isoc and bulk USB transfer initialization
      [media] em28xx: clear USB halt/stall condition in em28xx_init_usb_xfer when using bulk transfers
      [media] em28xx: remove double checks for urb->status == -ENOENT in urb_data_copy functions
      [media] em28xx: rename function em28xx_isoc_copy and extend for USB bulk transfers
      [media] em28xx: rename function em28xx_isoc_copy_vbi and extend for USB bulk transfers
      [media] em28xx: rename function em28xx_dvb_isoc_copy and extend for USB bulk transfers
      [media] em28xx: rename some USB parameter fields in struct em28xx to clarify their role
      [media] em28xx: add fields for analog and DVB USB transfer type selection to struct em28xx
      [media] em28xx: set USB alternate settings for analog video bulk transfers properly
      [media] em28xx: improve USB endpoint logic, also use bulk transfers
      [media] em28xx: add module parameter for selection of the preferred USB transfer type
      [media] em28xx: fix video data start position calculation in em28xx_urb_data_copy_vbi()
      [media] em28xx: make sure the packet size is >= 4 before checking for headers in em28xx_urb_data_copy_vbi()
      [media] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
      [media] em28xx: em28xx_urb_data_copy_vbi(): calculate vbi_size only if needed
      [media] em28xx: use common urb data copying function for vbi and non-vbi data streams
      [media] em28xx: refactor get_next_buf() and use it for vbi data, too
      [media] em28xx: use common function for video and vbi buffer completion
      [media] em28xx: remove obsolete field 'frame' from struct em28xx_buffer
      [media] em28xx: move field 'pos' from struct em28xx_dmaqueue to struct em28xx_buffer
      [media] em28xx: refactor VBI data processing code in em28xx_urb_data_copy()
      [media] em28xx: move caching of pointer to vmalloc memory in videobuf to struct em28xx_buffer
      [media] em28xx: em28xx_urb_data_copy(): move duplicate code for capture_type=0 and capture_type=2 to a function
      [media] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
      [media] em28xx: clean up and unify functions em28xx_copy_vbi() em28xx_copy_video()
      [media] em28xx: clean up the data type mess of the i2c transfer function parameters
      [media] em28xx: rename module parameter prefer_bulk to usb_xfer_mode
      [media] em28xx: simplify device state tracking
      [media] em28xx: refactor the code in em28xx_usb_disconnect()
      [media] em28xx: IR RC: move assignment of get_key functions from *_change_protocol() functions to em28xx_ir_init()
      [media] em28xx: respect the message size constraints for i2c transfers
      [media] em28xx: fix two severe bugs in function em2800_i2c_recv_bytes()
      [media] em28xx: fix the i2c adapter functionality flags
      [media] em28xx: fix+improve+unify i2c error handling, debug messages and code comments
      [media] em28xx: consider the message length limitation of the i2c adapter when reading the eeprom
      [media] em28xx: fix audio input for TV mode of device Terratec Cinergy 250
      [media] em28xx: add missing IR RC slave address to the list of known i2c devices
      [media] em28xx-input: remove dead code line from em28xx_get_key_em_haup()
      [media] em28xx: remove i2cdprintk() messages
      [media] em28xx: get rid of the dependency on module ir-kbd-i2c
      [media] em28xx: remove unused parameter ir_raw from i2c RC key polling functions
      [media] em28xx: fix a comment and a small coding style issue
      [media] em28xx: i2c RC devices: minor code size and memory usage optimization
      [media] em28xx: input: use common work_struct callback function for IR RC key polling
      [media] v4l2-core: do not enable the buffer ioctls for radio devices
      [media] em28xx: overhaul em28xx_capture_area_set()
      [media] em28xx: fix analog streaming with USB bulk transfers

Frank Schäfer (1):
      [media] tda18271: add missing entries for qam_7 to tda18271_update_std_map() and tda18271_dump_std_map()

Guennadi Liakhovetski (18):
      [media] media: sh-vou: fix compiler warnings
      [media] media: mem2mem: make reference to struct m2m_ops in the core const
      [media] media: add a VEU MEM2MEM format conversion and scaling driver
      [media] media: soc-camera: use managed devm_regulator_bulk_get()
      [media] media: sh-mobile-ceu-camera: runtime PM suspending doesn't have to be synchronous
      [media] media: soc-camera: update documentation
      [media] media: soc-camera: remove superfluous JPEG checking
      [media] media: sh_mobile_csi2: use managed memory and resource allocations
      [media] sh_mobile_ceu_camera: use managed memory and resource allocations
      [media] MAINTAINERS: add entries for sh_veu and sh_vou V4L2 drivers
      [media] soc-camera: properly fix camera probing races
      [media] soc-camera: fix repeated regulator requesting
      [media] soc-camera: remove struct soc_camera_device::video_lock
      [media] soc-camera: split struct soc_camera_link into host and subdevice parts
      [media] soc-camera: use devm_kzalloc in subdevice drivers
      [media] soc-camera: fix compilation breakage in 3 drivers
      [media] sh-mobile-ceu-camera: fix SHARPNESS control default
      [media] mt9t112: mt9t111 format set up differs from mt9t112

Hans Verkuil (64):
      [media] MAINTAINERS: add adv7604/ad9389b entries
      [media] MAINTAINERS: add cx2341x entry
      [media] MAINTAINERS: add entry for the quickcam parallel port webcams
      [media] MAINTAINERS: add radio-keene entry
      [media] MAINTAINERS: add radio-cadet entry
      [media] MAINTAINERS: add radio-isa entry
      [media] MAINTAINERS: add radio-aztech entry
      [media] MAINTAINERS: add radio-aimslab entry
      [media] MAINTAINERS: add radio-gemtek entry
      [media] MAINTAINERS: add radio-maxiradio entry
      [media] MAINTAINERS: add radio-miropcm20 entry
      [media] MAINTAINERS: add pms entry
      [media] MAINTAINERS: add saa6588 entry
      [media] MAINTAINERS: add usbvision entry
      [media] MAINTAINERS: add vivi entry
      [media] MAINTAINERS: Taking over saa7146 maintainership from Michael Hunold
      [media] MAINTAINERS: add tda9840, tea6415c and tea6420 entries
      [media] MAINTAINERS: add si470x-usb+common and si470x-i2c entries
      [media] Improve media Kconfig menu
      [media] em28xx: fix querycap
      [media] em28xx: remove bogus input/audio ioctls for the radio device
      [media] em28xx: fix VIDIOC_DBG_G_CHIP_IDENT compliance errors
      [media] em28xx: fix tuner/frequency handling
      [media] v4l2-ctrls: add a notify callback
      [media] em28xx: convert to the control framework
      [media] em28xx: convert to v4l2_fh, fix priority handling
      [media] em28xx: add support for control events
      [media] em28xx: fill in readbuffers and fix incorrect return code
      [media] tvp5150: remove compat control ops
      [media] em28xx: std fixes: don't implement in webcam mode, and fix std changes
      [media] em28xx: remove sliced VBI support
      [media] em28xx: zero vbi_format reserved array and add try_vbi_fmt
      [media] tuner-core: map audmode to STEREO for radio devices
      [media] Move DV-class control IDs from videodev2.h to v4l2-controls.h
      [media] mt9v011: convert to the control framework
      [media] tvaudio: fix broken volume/balance calculations
      [media] tvaudio: fix two tea6420 errors
      [media] tvaudio: convert to the control framework
      [media] radio-miropcm20: fix querycap
      [media] radio-miropcm20: remove input/audio ioctls
      [media] radio-miropcm20: convert to the control framework
      [media] radio-miropcm20: add prio and control event support
      [media] radio-miropcm20: Fix audmode/tuner/frequency handling
      [media] radio-miropcm20: fix signal and stereo indication
      [media] bw-qcam: zero priv field
      [media] bw-qcam: convert to videobuf2
      [media] bw-qcam: remove unnecessary qc_reset and qc_setscanmode calls
      [media] videobuf2: don't return POLLERR when only polling for events
      [media] meye: convert to the control framework
      [media] tm6000: fix querycap and input/tuner compliance issues
      [media] tm6000: convert to the control framework
      [media] tm6000: add support for control events and prio handling
      [media] tm6000: set colorspace field
      [media] tm6000: add poll op for radio device node
      [media] tm6000: fix G/TRY_FMT
      [media] DocBook: fix various validation errors
      [media] DocBook: improve the error_idx field documentation
      [media] DocBook: mention that EINVAL can be returned for invalid menu indices
      [media] cx2341x: move from media/i2c to media/common
      [media] btcx-risc: move from media/i2c to media/common
      [media] tveeprom: move from media/i2c to media/common
      [media] [REVIEW] em28xx: fix bytesperline calculation in TRY_FMT
      [media] tm6000: fix an uninitialized variable
      [media] cx18/ivtv: fix regression: remove __init from a non-init function

Hans de Goede (7):
      [media] gspca-pac207: Add a led_invert module parameter
      [media] stk-webcam: Add an upside down dmi table, and add the Asus G1 to it
      [media] Documentation/media: Remove docs for obsoleted and removed v4l1 drivers
      [media] gspca_t613: Fix compiling with GSPCA_DEBUG defined
      [media] gspca_sonixb: Properly wait between i2c writes
      [media] gspca_sonixj: Add a small delay after i2c_w1
      [media] pwc: Don't return EINVAL when an unsupported pixelformat is requested

Igor M. Liplianin (6):
      [media] TeVii DVB-S s421 and s632 cards support
      [media] TeVii DVB-S s421 and s632 cards support, rs2000 part
      [media] dw2102: autoselect DVB_M88RS2000
      [media] m88rs2000: SNR, BER implemented
      [media] ds3000: lock led procedure added
      [media] m88rs2000: make use ts2020

Jacob Schloss (1):
      [media] gspca_kinect: add Kinect for Windows USB id

Javier Martin (17):
      [media] media: mx2_camera: Add image size HW limits
      [media] media: coda: Fix H.264 header alignment
      [media] media: coda: Fix H.264 header alignment - v2
      [media] media: m2m-deinterlace: Do not set debugging flag to true
      [media] media: ov7670: Allow 32x maximum gain for yuv422
      [media] mx2_camera: Remove i.mx25 support
      [media] mx2_camera: Remove 'buf_cleanup' callback
      [media] mx2_camera: Remove buffer states
      [media] media: ov7670: add support for ov7675
      [media] media: ov7670: make try_fmt() consistent with 'min_height' and 'min_width'
      [media] media: ov7670: calculate framerate properly for ov7675
      [media] media: ov7670: add possibility to bypass pll for ov7675
      [media] media: ov7670: Add possibility to disable pixclk during hblank
      [media] ov7670: use the control framework
      [media] mcam-core: implement the control framework
      [media] via-camera: implement the control framework
      [media] ov7670: remove legacy ctrl callbacks

Jean-François Moine (1):
      [media] gspca - stv06xx: Fix a regression with the bridge/sensor vv6410

Jesper Juhl (2):
      [media] rc: Fix double free in gpio_ir_recv_probe()
      [media] rc: Fix double free in gpio_ir_recv_remove()

Jiri Slaby (1):
      [media] dib0700: do not lock interruptible on tear-down paths

Joe Perches (1):
      [media] staging: media: Remove unnecessary OOM messages

Johannes Schellen (1):
      [media] omap3isp: Fix histogram regions

John Törnblom (1):
      [media] bttv: avoid flooding the kernel log when i2c debugging is disabled

Jonathan McDowell (1):
      [media] Autoselect more relevant frontends for EM28XX DVB stick

Jose Alberto Reguero (2):
      [media] af9035: dual mode support
      [media] [PATH,1/2] mxl5007 move reset to attach

Juergen Lock (1):
      [media] dvb_frontend: fix ioctls failing if frontend open/closed too fast

Julia Lawall (1):
      [media] drivers/media/platform/soc_camera/pxa_camera.c: use devm_ functions

Julian Scheel (2):
      [media] tm6000: Add parameter to keep urb bufs allocated
      [media] tm6000-dvb: Fix module unload

Kamil Debski (7):
      [media] MAINTAINERS: add g2d entry
      [media] s5p-mfc: Move firmware allocation point to avoid allocation problems
      [media] s5p-mfc: Correct check of vb2_dma_contig_init_ctx return value
      [media] s5p-mfc: Change internal buffer allocation from vb2 ops to dma_alloc_coherent
      [media] s5p-mfc: Context handling in open() bugfix
      [media] s5p-mfc: Fix a watchdog bug
      [media] s5p-mfc: end-of-stream handling in encoder bug fix

Kirill Smelkov (6):
      [media] vivi: Optimize gen_text()
      [media] vivi: vivi_dev->line[] was not aligned
      [media] vivi: Move computations out of vivi_fillbuf linecopy loop
      [media] vivi: Optimize precalculate_line()
      [media] vivi: Teach it to tune FPS
      [media] vivi: Constify structures

Konstantin Dimitrov (3):
      [media] ds3000: remove ts2020 tuner related code
      [media] ts2020: add ts2020 tuner driver
      [media] make the other drivers take use of the new ts2020 driver

Konstantin Khlebnikov (1):
      [media] media/rc: fix oops on unloading module rc-core

Lad, Prabhakar (9):
      [media] davinci: vpbe: pass different platform names to handle different ip's
      [media] media: davinci: vpbe: enable building of vpbe driver for DM355 and DM365
      [media] ths7303: use devm_kzalloc() instead of kzalloc()
      [media] tvp7002: use devm_kzalloc() instead of kzalloc()
      [media] tvp514x: use devm_kzalloc() instead of kzalloc()
      [media] adv7343: use devm_kzalloc() instead of kzalloc()
      [media] davinci: dm355: Fix uninitialized variable compiler warnings
      [media] media: adv7343: accept configuration through platform data
      [media] ARM: davinci: da850 evm: pass platform data for adv7343 encoder

Laurent Pinchart (14):
      [media] omap_vout: Drop overlay format enumeration
      [media] omap_vout: Use the output overlay ioctl operations
      [media] MAINTAINERS: Add entries for Aptina sensor drivers
      [media] MAINTAINERS: Add an entry for the ad3645a LED flash controller driver
      [media] omap3isp: csiphy: Fix an uninitialized variable compiler warning
      [media] omap3isp: ispqueue: Fix uninitialized variable compiler warnings
      [media] v4l: Reset subdev v4l2_dev field to NULL if registration fails
      [media] omap3isp: preview: Lower the crop margins
      [media] omap3isp: Remove unneeded memset after kzalloc
      [media] omap3isp: Use devm_* managed functions
      [media] DocBook: media: struct v4l2_capability card field is a UTF-8 string
      [media] uvcvideo: Implement videobuf2 .wait_prepare and .wait_finish operations
      [media] sh_vou: Use video_drvdata()
      [media] sh_vou: Use vou_dev instead of vou_file wherever possible

Libin Yang (1):
      [media] marvell-ccic: use internal variable replace global frame stats variable

Luis R. Rodriguez (2):
      [media] s5p-fimc: convert struct spinlock to spinlock_t
      [media] s5p-jpeg: convert struct spinlock to spinlock_t

Malcolm Priestley (4):
      [media] it913x: fix correct endpoint size when pid filter on
      [media] lmedm04: correct I2C values to 7 bit addressing
      [media] ts2020.c: ts2020_set_params [BUG] point to fe->tuner_priv
      [media] ts2020: call get_rf_strength from frontend

Manjunath Hadli (14):
      [media] media: add new mediabus format enums for dm365
      [media] v4l2: add new pixel formats supported on dm365
      [media] davinci: vpss: dm365: enable ISP registers
      [media] davinci: vpss: dm365: set vpss clk ctrl
      [media] davinci/vpss: add helper functions for setting hw params
      [media] davinci: vpfe: add v4l2 capture driver with media interface
      [media] davinci: vpfe: add v4l2 video driver support
      [media] davinci: vpfe: dm365: add IPIPEIF driver based on media framework
      [media] davinci: vpfe: dm365: add ISIF driver based on media framework
      [media] davinci: vpfe: dm365: add IPIPE support for media controller driver
      [media] davinci: vpfe: dm365: add IPIPE hardware layer support
      [media] davinci: vpfe: dm365: resizer driver based on media framework
      [media] davinci: vpfe: dm365: add build infrastructure for capture driver
      [media] davinci: vpfe: Add documentation and TODO

Martin Blumenstingl (1):
      [media] get_dvb_firmware: Fix the location of firmware for Terratec HTC

Masanari Iida (1):
      [media] staging: media: Fix minor typo in staging/media

Matthijs Kooijman (3):
      [media] rc: Make probe cleanup goto labels more verbose
      [media] rc: Set rdev before irq setup
      [media] rc: Call rc_register_device before irq setup

Matti Kurkela (1):
      [media] ttusb2: Kconfig patch to auto-select frontends for TechnoTrend CT-3650

Mauro Carvalho Chehab (52):
      Merge tag 'v3.7-rc8' into staging/for_v3.8
      [media] DocBook: fix an index reference
      [media] sh_veu.c: fix two compilation warnings
      [media] tm6000-video.c: warning fix
      [media] tda10071: fix a warning introduced by changeset 41f55d5755
      em28xx: add two missing tuners at the Kconfig file
      [media] em28xx: add support for NEC proto variants on em2874 and upper
      [media] em28xx: add support for RC6 mode 0 on devices that support it
      [media] em28xx: prefer_bulk parameter is read-only
      [media] em28xx: display the isoc/bulk mode
      [media] em28xx: make the logs reflect the specific chip name
      [media] em28xx: prefer bulk mode on webcams
      Merge tag 'v3.8-rc1' into staging/for_v3.9
      [media] ttpci: Fix a missing Kconfig dependency
      [media] omap: Fix Kconfig dependencies on OMAP2
      [media] m920x: Fix CodingStyle issues
      [media] ts2020: fix two warnings added by changeset 73f0af4
      [media] blackfin Kconfig: select is evil; use, instead depends on
      [media] em28xx: initialize button/I2C IR earlier
      [media] em28xx: autoload em28xx-rc if the device has an I2C IR
      [media] em28xx: simplify IR names on I2C devices
      [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
      [media] em28xx: declare em28xx_stop_streaming as static
      [media] ngene: fix commit 36a495a336c3fbbb2f4eeed2a94ab6d5be19d186
      [media] em28xx: enable DMABUF
      [media] extract_xc3028.pl: fix permissions
      [media] mb86a20s: improve error handling at get_frontend
      [media] mb86a20s: Fix i2c gate on error
      [media] mb86a20s: make AGC work better
      [media] mb86a20s: fix interleaving and FEC retrival
      [media] mb86a20s: Split status read logic from DVB callback
      [media] mb86a20s: Function reorder
      [media] mb86a20s: convert it to use dev_info/dev_err/dev_dbg
      [media] mb86a20s: don't use state before initializing it
      [media] dvb: Add DVBv5 statistics properties
      [media] dvb: the core logic to handle the DVBv5 QoS properties
      [media] mb86a20s: calculate statistics at .read_status()
      [media] mb86a20s: add BER measurement
      [media] mb86a20s: improve bit error count for BER
      [media] mb86a20s: add CNR measurement
      [media] dvb_frontend: print a msg if a property doesn't exist
      [media] mb86a20s: add block count measures (PER/UCB)
      [media] mb86a20s: some fixes at preBER logic
      [media] mb86a20s: fix the PER reset logic
      [media] mb86a20s: add a logic for post-BER measurement
      [media] mb86a20s: remove global BER/PER counters if per-layer counters vanish
      Merge branch 'v4l_for_linus' into staging/for_v3.9
      Revert "[media] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift"
      [media] Documentation: update V4L cardlists
      [media] tveeprom: Fix lots of bad whitespace
      Revert "[media] [PATH,1/2] mxl5007 move reset to attach"
      Revert "[media] fc0011: Return early, if the frequency is already tuned"

Michael Buesch (4):
      [media] fc0011: fp/fa value overflow fix
      [media] fc0011: Fix xin value clamping
      [media] fc0011: Add some sanity checks and cleanups
      [media] fc0011: Return early, if the frequency is already tuned

Michael Krufky (7):
      [media] au0828: add missing model 72281, usb id 2040:7270 to the model matrix
      [media] au0828: update model matrix entries for 72261, 72271 & 72281
      [media] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
      [media] au0828: break au0828_card_setup() down into smaller functions
      [media] tda10071: add tuner_i2c_addr to struct tda10071_config
      [media] cx23885: add basic DVB-S2 support for Hauppauge HVR-4400
      [media] tda10071: make sure both tuner and demod i2c addresses are specified

Nickolai Zeldovich (3):
      [media] drivers/media/usb/dvb-usb/dib0700_core.c: fix left shift
      [media] media: cx18, ivtv: eliminate unnecessary array index checks
      [media] drivers/media/pci: use memmove for overlapping regions

Nicolas THERY (1):
      [media] Documentation: fix outdated statement re. v4l2

Nikolaus Schulz (1):
      [media] dvb: push down ioctl lock in dvb_usercopy

Oleh Kravchenko (1):
      [media] Added support for AVerTV Hybrid Express Slim HC81R

Oliver Neukum (1):
      [media] uvcvideo: Fix race of open and suspend in error case

Patrice Chotard (2):
      [media] drxd: allow functional gate control after, attach
      [media] ngene: separate demodulator and tuner attach

Paul Bolle (3):
      [media] budget-av: only use t_state if initialized
      [media] tda18212: tda18218: use 'val' if initialized
      [media] saa7164: silence GCC warnings

Peter Huewe (2):
      [media] staging/media/go7007: Use kmemdup rather than duplicating its implementation
      [media] staging/media/solo6x10: Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR

Peter Senna Tschudin (26):
      [media] drivers/media/pci/saa7134/saa7134-dvb.c: Test if videobuf_dvb_get_frontend return NULL
      [media] radio/si470x/radio-si470x.h: use IS_ENABLED() macro
      [media] usb/gspca/cpia1.c: use IS_ENABLED() macro
      [media] usb/gspca: use IS_ENABLED() macro
      [media] usb/gspca/konica.c: use IS_ENABLED() macro
      [media] usb/gspca/ov519.c: use IS_ENABLED() macro
      [media] usb/gspca/pac207.c: use IS_ENABLED() macro
      [media] gspca/pac7302.c: use IS_ENABLED() macro
      [media] usb/gspca/pac7311.c: use IS_ENABLED() macro
      [media] usb/gspca/se401.c: use IS_ENABLED() macro
      [media] usb/gspca/sn9c20x.c: use IS_ENABLED() macro
      [media] usb/gspca/sonixb.c: use IS_ENABLED() macro
      [media] usb/gspca/sonixj.c: use IS_ENABLED() macro
      [media] usb/gspca/spca561.c: use IS_ENABLED() macro
      [media] usb/gspca/stv06xx/stv06xx.c: use IS_ENABLED() macro
      [media] usb/gspca/t613.c: use IS_ENABLED() macro
      [media] usb/gspca/xirlink_cit.c: use IS_ENABLED() macro
      [media] usb/gspca/zc3xx.c: use IS_ENABLED() macro
      [media] [V2,01/24] pci/cx88/cx88.h: use IS_ENABLED() macro
      [media] [V2,02/24] pci/saa7134/saa7134.h: use IS_ENABLED() macro
      [media] [V2,03/24] pci/ttpci/av7110.c: use IS_ENABLED() macro
      [media] [V2,04/24] platform/marvell-ccic/mcam-core.h: use IS_ENABLED() macro
      [media] [V2,22/24] usb/hdpvr/hdpvr-core.c: use IS_ENABLED() macro
      [media] [V2,23/24] usb/hdpvr/hdpvr-i2c.c: use IS_ENABLED() macro
      [media] [V2,24/24] v4l2-core/v4l2-common.c: use IS_ENABLED() macro
      [media] use IS_ENABLED() macro

Prabhakar Lad (2):
      [media] s5p-fimc: Fix typo of URL pointing to Media Controller API's
      [media] media: tvp514x: remove field description

Roland Scheidegger (1):
      [media] em28xx: add usb id for terratec h5 rev. 3

Rémi Cardona (2):
      [media] dw2102: Declare MODULE_FIRMWARE usage
      [media] ds3000: bail out early on i2c failures during firmware load

Sachin Kamat (24):
      [media] exynos-gsc: Fix checkpatch warning in gsc-m2m.c
      [media] exynos-gsc: Rearrange error messages for valid prints
      [media] exynos-gsc: Use devm_clk_get()
      [media] gspca: Use module_usb_driver macro
      [media] s5p-tv: Use devm_gpio_request in sii9234_drv.c
      [media] s3c-camif: Add missing version.h header file
      [media] s5p-tv: Add missing braces around sizeof in sdo_drv.c
      [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
      [media] s5p-tv: Add missing braces around sizeof in mixer_reg.c
      [media] s5p-tv: Add missing braces around sizeof in mixer_drv.c
      [media] s5p-tv: Add missing braces around sizeof in hdmiphy_drv.c
      [media] s5p-tv: Add missing braces around sizeof in hdmi_drv.c
      [media] s5p-mfc: Remove redundant 'break'
      [media] s5p-mfc: Fix a typo in error message in s5p_mfc_pm.c
      [media] s5p-mfc: Fix an error check
      [media] s5p-mfc: Use NULL instead of 0 for pointer
      [media] s5p-g2d: Add support for G2D H/W Rev.4.1
      [media] s5k6aa: Use devm_regulator_bulk_get API
      [media] s5p-mfc: Use WARN_ON(condition) directly
      [media] s5p-csis: Use devm_regulator_bulk_get API
      [media] s5c73m3: Staticize some symbols
      [media] s5c73m3: Use devm_regulator_bulk_get API
      [media] s5p-tv: Include missing irqreturn.h header
      [media] s5p-tv: Include missing platform_device.h header

Sakari Ailus (6):
      [media] v4l: Define video buffer flags for timestamp types
      [media] v4l: Helper function for obtaining timestamps
      [media] v4l: Convert drivers to use monotonic timestamps
      [media] v4l: Tell user space we're using monotonic timestamps
      [media] v4l: There's no __unsigned
      [media] v4l: Don't compile v4l2-int-device unless really needed

Sasha Levin (1):
      [media] m2m-deinterlace: use correct check for kzalloc failure

Scott Jiang (4):
      [media] v4l2: blackfin: convert ppi driver to a module
      [media] v4l2: blackfin: add EPPI3 support
      [media] add maintainer for blackfin media drivers
      [media] blackfin: add error frame support

Sean Young (8):
      [media] winbond-cir: only enable higher sample resolution if needed
      [media] iguanair: ensure transmission mask is initialized
      [media] iguanair: intermittent initialization failure
      [media] ttusbir: do not set led twice on resume
      [media] ttusbir: add missing endian conversion
      [media] mceusb: make transmit work on the Philips IR transceiver
      [media] mceusb: make transmit work on HP transceiver
      [media] redrat3: fix transmit return value and overrun

Sebastian Hesselbarth (1):
      [media] media: rc: gpio-ir-recv: add support for device tree parsing

Shaik Ameer Basha (4):
      [media] exynos-gsc: Adding tiled multi-planar format to G-Scaler
      [media] exynos-gsc: propagate timestamps from src to dst buffers
      [media] exynos-gsc: modify number of output/capture buffers
      [media] exynos-gsc: Support dmabuf export buffer

Simon Farnsworth (1):
      [media] saa7134: Add pm_qos_request to fix video corruption

Stephen Rothwell (1):
      [media] media: remove __dev* annotations

Sylwester Nawrocki (40):
      [media] exynos-gsc: Correct the clock handling
      [media] s5p-fimc: Fix horizontal/vertical image flip
      [media] s5p-csis: Correct the event counters logging
      [media] V4L: DocBook: Add V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code
      [media] fimc-lite: Register dump function cleanup
      [media] s5p-fimc: Clean up capture enable/disable helpers
      [media] s5p-fimc: Add variant data structure for Exynos4x12
      [media] s5p-csis: Add support for raw Bayer pixel formats
      [media] s5p-csis: Enable only data lanes that are actively used
      [media] s5p-csis: Add registers logging for debugging
      [media] s5p-fimc: Add sensor group ids for fimc-is
      [media] fimc-lite: Add ISP FIFO output support
      [media] s5p-fimc: Improved pipeline try format routine
      [media] s5p-fimc: Avoid possible NULL pointer dereference in set_fmt op
      [media] s5p-fimc: Prevent potential buffer overflow
      [media] s5p-fimc: Prevent AB-BA deadlock during links reconfiguration
      [media] s5p-tv: Fix return value in sdo_probe() on error paths
      [media] V4L: Remove deprecated image centering controls
      [media] V4L: Add header file defining standard image sizes
      [media] v4l2-ctrl: Add helper function for the controls range update
      [media] V4L: Add v4l2_event_subdev_unsubscribe() helper function
      [media] V4L: Add v4l2_ctrl_subdev_subscribe_event() helper function
      [media] V4L: Add v4l2_ctrl_subdev_log_status() helper function
      [media] V4L: Add driver for OV9650/52 image sensors
      [media] s5p-fimc: Fix bytesperline value for V4L2_PIX_FMT_YUV420M format
      [media] noon010p30: Remove unneeded v4l2 control compatibility ops
      [media] s5p-fimc: fimc-lite: Remove empty s_power subdev callback
      [media] s5p-fimc: fimc-lite: Prevent deadlock at STREAMON/OFF ioctls
      [media] s5p-fimc: Add missing line breaks
      [media] s5p-fimc: Change platform subdevs registration method
      [media] s5p-fimc: Check return value of clk_enable/clk_set_rate
      [media] s5p-csis: Check return value of clk_enable/clk_set_rate
      [media] s5p-fimc: Avoid null pointer dereference in fimc_capture_ctrls_create()
      [media] s5p-fimc: Set default image format at device open()
      [media] s5p-fimc: Fix FIMC.n subdev set_selection ioctl handler
      [media] s5p-fimc: Add clk_prepare/unprepare for sclk_cam clocks
      [media] s5p-fimc: Redefine platform data structure for fimc-is
      [media] s5p-csis: Fix clock handling on error path in probe()
      [media] s5p-fimc: Fix fimc-lite entities deregistration
      [media] s5c73m3: Remove __dev* attributes

Thierry Reding (1):
      [media] media: Convert to devm_ioremap_resource()

Tony Prisk (3):
      [media] s5p-fimc: Fix incorrect usage of IS_ERR_OR_NULL
      [media] s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
      [media] s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL

Vadim Frolov (1):
      [media] saa7134: Add capture card Hawell HW-9004V1

Volokh Konstantin (4):
      [media] staging: media: go7007: memory clear fix memory clearing for v4l2_subdev allocation
      [media] staging: media: go7007: firmware protection Protection for unfirmware load
      [media] staging: media: go7007: i2c GPIO initialization Reset i2c stuff for GO7007_BOARDID_ADLINK_MPG24 need reset GPIO always when encoder initialize
      [media] staging: media: go7007: call_all stream stuff Some Additional stuff for v4l2_subdev stream events partial need for new style framework. Also need for wis_tw2804 notification stuff

Wei Yongjun (6):
      [media] media: davinci: vpbe: fix return value check in vpbe_display_reqbufs()
      [media] media: davinci: vpbe: return error code on error in vpbe_display_g_crop()
      [media] davinci: vpbe: remove unused variable in vpbe_initialize()
      [media] mt9v022: fix potential NULL pointer dereference in mt9v022_probe()
      [media] s5p-mfc: remove unused variable
      [media] davinci: vpbe: fix missing unlock on error in vpbe_initialize()

YAMANE Toshiaki (20):
      [media] staging/media: Use dev_ printks in cxd2099/cxd2099.[ch]
      [media] staging/media: Use dev_ printks in go7007/go7007-driver.c
      [media] staging/media: Use dev_ printks in go7007/wis-sony-tuner.c
      [media] staging/media: Use dev_ printks in go7007/s2250-loader.c
      [media] staging/media: Use dev_ or pr_ printks in go7007/go7007-i2c.c
      [media] Staging/media: fixed spacing coding style in go7007/wis-tw9903.c
      [media] Staging/media: Use dev_ printks in go7007/wis-tw9903.c
      [media] Staging/media: Use dev_ printks in go7007/go7007-v4l2.c
      [media] Staging/media: Use dev_ printks in go7007/wis-uda1342.c
      [media] Staging/media: fixed spacing coding style in go7007/wis-uda1342.c
      [media] Staging/media: Use dev_ printks in go7007/wis-tw2804.c
      [media] Staging/media: Use dev_ printks in go7007/s2250-board.c
      [media] Staging/media: Use dev_ printks in solo6x10/p2m.c
      [media] staging/media: Use dev_ or pr_ printks in lirc/lirc_sasem.c
      [media] staging/media: Use pr_ printks in lirc/lirc_sir.c
      [media] staging/media: Use pr_ printks in lirc/lirc_bt829.c
      [media] staging/media: Use pr_ printks in lirc/lirc_parallel.c
      [media] staging/media: Use pr_ printks in lirc/lirc_serial.c
      [media] staging/media: Use dev_ or pr_ printks in lirc/lirc_imon.c
      [media] staging/media: Use dev_ printks in lirc/igorplugusb.c

 Documentation/DocBook/media/dvb/dvbapi.xml         |    2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  180 +-
 Documentation/DocBook/media/dvb/frontend.xml       |    2 +-
 Documentation/DocBook/media/v4l/common.xml         |    2 +-
 Documentation/DocBook/media/v4l/compat.xml         |   16 +
 Documentation/DocBook/media/v4l/controls.xml       |   23 -
 Documentation/DocBook/media/v4l/io.xml             |   59 +-
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml   |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  926 ++++-----
 Documentation/DocBook/media/v4l/v4l2.xml           |   12 +-
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |    6 +
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml  |   28 +-
 Documentation/DocBook/media/v4l/vidioc-g-ctrl.xml  |    8 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   57 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |    2 +-
 Documentation/DocBook/media_api.tmpl               |    1 +
 .../devicetree/bindings/media/gpio-ir-receiver.txt |   16 +
 Documentation/dvb/get_dvb_firmware                 |   17 +-
 Documentation/media-framework.txt                  |    2 +-
 Documentation/video4linux/CARDLIST.au0828          |    2 +-
 Documentation/video4linux/CARDLIST.cx23885         |    2 +
 Documentation/video4linux/CARDLIST.em28xx          |    3 +-
 Documentation/video4linux/CARDLIST.saa7134         |    1 +
 Documentation/video4linux/et61x251.txt             |  315 ---
 Documentation/video4linux/extract_xc3028.pl        |    0
 Documentation/video4linux/fimc.txt                 |    2 +-
 Documentation/video4linux/ibmcam.txt               |  323 ---
 Documentation/video4linux/m5602.txt                |   12 -
 Documentation/video4linux/ov511.txt                |  288 ---
 Documentation/video4linux/se401.txt                |   54 -
 Documentation/video4linux/si470x.txt               |    7 +-
 Documentation/video4linux/soc-camera.txt           |  146 +-
 Documentation/video4linux/stv680.txt               |   53 -
 Documentation/video4linux/v4l2-controls.txt        |   22 +-
 Documentation/video4linux/v4l2-framework.txt       |    3 +-
 Documentation/video4linux/w9968cf.txt              |  458 -----
 Documentation/video4linux/zc0301.txt               |  270 ---
 MAINTAINERS                                        |  262 ++-
 arch/arm/mach-davinci/board-da850-evm.c            |   13 +
 arch/arm/mach-davinci/board-dm644x-evm.c           |    8 +-
 arch/arm/mach-davinci/dm644x.c                     |   10 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    8 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    6 +-
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    3 +
 drivers/media/Kconfig                              |   19 +-
 drivers/media/common/Kconfig                       |   11 +
 drivers/media/common/Makefile                      |    3 +
 drivers/media/{i2c => common}/btcx-risc.c          |    0
 drivers/media/{i2c => common}/btcx-risc.h          |    0
 drivers/media/{i2c => common}/cx2341x.c            |    0
 drivers/media/common/saa7146/saa7146_fops.c        |    5 +-
 drivers/media/{i2c => common}/tveeprom.c           |  290 ++-
 drivers/media/dvb-core/dvb-usb-ids.h               |    6 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |   16 +-
 drivers/media/dvb-core/dvb_frontend.c              |   59 +-
 drivers/media/dvb-core/dvb_frontend.h              |   10 +
 drivers/media/dvb-core/dvb_net.c                   |   71 +-
 drivers/media/dvb-core/dvb_net.h                   |    1 +
 drivers/media/dvb-core/dvbdev.c                    |    2 -
 drivers/media/dvb-frontends/Kconfig                |    7 +
 drivers/media/dvb-frontends/Makefile               |    1 +
 drivers/media/dvb-frontends/af9033.c               |   18 +
 drivers/media/dvb-frontends/af9033.h               |    1 +
 drivers/media/dvb-frontends/af9033_priv.h          |  132 +-
 drivers/media/dvb-frontends/bcm3510.h              |    2 +-
 drivers/media/dvb-frontends/cx22700.h              |    2 +-
 drivers/media/dvb-frontends/cx24110.h              |    2 +-
 drivers/media/dvb-frontends/cx24116.c              |    2 +-
 drivers/media/dvb-frontends/dib0070.h              |    2 +-
 drivers/media/dvb-frontends/dib0090.h              |    2 +-
 drivers/media/dvb-frontends/dib3000.h              |    2 +-
 drivers/media/dvb-frontends/dib8000.h              |    2 +-
 drivers/media/dvb-frontends/dib9000.h              |    2 +-
 drivers/media/dvb-frontends/drxd_hard.c            |    9 +-
 drivers/media/dvb-frontends/ds3000.c               |  261 +--
 drivers/media/dvb-frontends/ds3000.h               |   10 +-
 drivers/media/dvb-frontends/dvb-pll.h              |    2 +-
 drivers/media/dvb-frontends/isl6405.h              |    2 +-
 drivers/media/dvb-frontends/isl6421.h              |    2 +-
 drivers/media/dvb-frontends/isl6423.h              |    2 +-
 drivers/media/dvb-frontends/itd1000.h              |    2 +-
 drivers/media/dvb-frontends/ix2505v.c              |    2 +-
 drivers/media/dvb-frontends/l64781.h               |    2 +-
 drivers/media/dvb-frontends/lgdt330x.h             |    2 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  422 ++--
 drivers/media/dvb-frontends/m88rs2000.h            |    6 -
 drivers/media/dvb-frontends/mb86a16.h              |    2 +-
 drivers/media/dvb-frontends/mb86a20s.c             | 1836 ++++++++++++++---
 drivers/media/dvb-frontends/mt312.h                |    2 +-
 drivers/media/dvb-frontends/mt352.h                |    2 +-
 drivers/media/dvb-frontends/nxt200x.h              |    2 +-
 drivers/media/dvb-frontends/nxt6000.h              |    2 +-
 drivers/media/dvb-frontends/or51132.h              |    2 +-
 drivers/media/dvb-frontends/or51211.c              |   99 +-
 drivers/media/dvb-frontends/or51211.h              |    2 +-
 drivers/media/dvb-frontends/s5h1420.h              |    2 +-
 drivers/media/dvb-frontends/sp8870.h               |    2 +-
 drivers/media/dvb-frontends/sp887x.h               |    2 +-
 drivers/media/dvb-frontends/stb0899_drv.h          |    2 +-
 drivers/media/dvb-frontends/stb6100.h              |    2 +-
 drivers/media/dvb-frontends/stv0297.h              |    2 +-
 drivers/media/dvb-frontends/stv0299.c              |    2 +-
 drivers/media/dvb-frontends/stv0299.h              |    2 +-
 drivers/media/dvb-frontends/stv0900_core.c         |   40 +-
 drivers/media/dvb-frontends/stv0900_reg.h          |    3 +
 drivers/media/dvb-frontends/stv0900_sw.c           |    7 +-
 drivers/media/dvb-frontends/stv090x.c              |  141 +-
 drivers/media/dvb-frontends/stv090x.h              |    2 +-
 drivers/media/dvb-frontends/stv6110x.h             |    2 +-
 drivers/media/dvb-frontends/tda1002x.h             |    5 +-
 drivers/media/dvb-frontends/tda1004x.h             |    2 +-
 drivers/media/dvb-frontends/tda10071.c             |   22 +-
 drivers/media/dvb-frontends/tda10071.h             |    8 +-
 drivers/media/dvb-frontends/tda10086.h             |    2 +-
 drivers/media/dvb-frontends/tda665x.h              |    2 +-
 drivers/media/dvb-frontends/tda8083.h              |    2 +-
 drivers/media/dvb-frontends/tda8261.h              |    2 +-
 drivers/media/dvb-frontends/tda8261_cfg.h          |    2 +-
 drivers/media/dvb-frontends/tda826x.h              |    2 +-
 drivers/media/dvb-frontends/ts2020.c               |  373 ++++
 drivers/media/dvb-frontends/ts2020.h               |   50 +
 drivers/media/dvb-frontends/tua6100.h              |    2 +-
 drivers/media/dvb-frontends/ves1820.h              |    2 +-
 drivers/media/dvb-frontends/ves1x93.h              |    2 +-
 drivers/media/dvb-frontends/zl10353.h              |    2 +-
 drivers/media/i2c/Kconfig                          |   42 +-
 drivers/media/i2c/Makefile                         |    5 +-
 drivers/media/i2c/adv7180.c                        |    3 -
 drivers/media/i2c/adv7343.c                        |   45 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |    6 +-
 drivers/media/i2c/mt9v011.c                        |  223 +--
 drivers/media/i2c/noon010pc30.c                    |    7 -
 drivers/media/i2c/ov7670.c                         |  589 +++---
 drivers/media/i2c/ov9650.c                         | 1562 +++++++++++++++
 drivers/media/i2c/s5c73m3/Makefile                 |    2 +
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 1704 ++++++++++++++++
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c          |  563 ++++++
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c            |  156 ++
 drivers/media/i2c/s5c73m3/s5c73m3.h                |  459 +++++
 drivers/media/i2c/s5k6aa.c                         |    7 +-
 drivers/media/i2c/soc_camera/imx074.c              |   27 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   52 +-
 drivers/media/i2c/soc_camera/mt9m111.c             |   36 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   36 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   45 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   45 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   29 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   31 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   30 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   36 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   27 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   29 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   39 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   30 +-
 drivers/media/i2c/ths7303.c                        |    3 +-
 drivers/media/i2c/tvaudio.c                        |  238 +--
 drivers/media/i2c/tvp514x.c                        |    4 +-
 drivers/media/i2c/tvp5150.c                        |    7 -
 drivers/media/i2c/tvp7002.c                        |   18 +-
 drivers/media/parport/Kconfig                      |    1 +
 drivers/media/parport/bw-qcam.c                    |  165 +-
 drivers/media/pci/bt8xx/Makefile                   |    1 +
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |    5 +-
 drivers/media/pci/bt8xx/dst_ca.c                   |    4 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |    2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.h             |    2 +-
 drivers/media/pci/cx18/cx18-i2c.c                  |    9 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |    2 +-
 drivers/media/pci/cx23885/Kconfig                  |    3 +
 drivers/media/pci/cx23885/Makefile                 |    1 +
 drivers/media/pci/cx23885/cx23885-cards.c          |  114 ++
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   66 +-
 drivers/media/pci/cx23885/cx23885-input.c          |    9 +
 drivers/media/pci/cx23885/cx23885-video.c          |   20 +-
 drivers/media/pci/cx23885/cx23885.h                |    2 +
 drivers/media/pci/cx23885/cx23888-ir.c             |    6 +-
 drivers/media/pci/cx25821/Makefile                 |    1 +
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx88/Kconfig                     |    2 +
 drivers/media/pci/cx88/Makefile                    |    1 +
 drivers/media/pci/cx88/cx88-cards.c                |    2 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   15 +-
 drivers/media/pci/cx88/cx88-i2c.c                  |    3 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.c           |    3 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.h           |    2 +-
 drivers/media/pci/cx88/cx88.h                      |   10 +-
 drivers/media/pci/dm1105/Kconfig                   |    1 +
 drivers/media/pci/dm1105/dm1105.c                  |   11 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             |    2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |    2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                  |   14 +-
 drivers/media/pci/ivtv/ivtv-vbi.c                  |    4 +-
 drivers/media/pci/mantis/mantis_ca.c               |    5 +-
 drivers/media/pci/meye/meye.c                      |  286 +--
 drivers/media/pci/meye/meye.h                      |    2 +
 drivers/media/pci/ngene/ngene-cards.c              |    9 +
 drivers/media/pci/saa7134/saa7134-cards.c          |   17 +
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    3 +
 drivers/media/pci/saa7134/saa7134-video.c          |   13 +
 drivers/media/pci/saa7134/saa7134.h                |    7 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |    2 +
 drivers/media/pci/sta2x11/Kconfig                  |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            | 1073 ++++------
 drivers/media/pci/ttpci/Kconfig                    |    5 -
 drivers/media/pci/ttpci/av7110.c                   |   12 +-
 drivers/media/pci/ttpci/av7110.h                   |    2 +
 drivers/media/pci/ttpci/av7110_av.c                |    8 +
 drivers/media/pci/ttpci/av7110_ca.c                |   24 +-
 drivers/media/pci/zoran/zoran_card.c               |    3 +-
 drivers/media/pci/zoran/zoran_device.c             |    4 +-
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/Kconfig                     |   11 +-
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/blackfin/Kconfig            |    7 +-
 drivers/media/platform/blackfin/Makefile           |    4 +-
 drivers/media/platform/blackfin/bfin_capture.c     |  189 +-
 drivers/media/platform/blackfin/ppi.c              |   90 +-
 drivers/media/platform/coda.c                      |   32 +-
 drivers/media/platform/davinci/Kconfig             |   22 +-
 drivers/media/platform/davinci/Makefile            |    4 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |    2 +-
 drivers/media/platform/davinci/vpbe.c              |   12 +-
 drivers/media/platform/davinci/vpbe_display.c      |    9 +-
 drivers/media/platform/davinci/vpbe_osd.c          |   35 +-
 drivers/media/platform/davinci/vpbe_venc.c         |   65 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    5 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    6 +-
 drivers/media/platform/davinci/vpss.c              |   70 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       |   56 +-
 drivers/media/platform/exynos-gsc/gsc-core.h       |    5 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   34 +-
 drivers/media/platform/exynos-gsc/gsc-regs.c       |    6 +
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/m2m-deinterlace.c           |    6 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   84 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |   17 +-
 drivers/media/platform/mx2_emmaprp.c               |    6 +-
 drivers/media/platform/omap/Kconfig                |    2 +-
 drivers/media/platform/omap/omap_vout.c            |   36 +-
 drivers/media/platform/omap24xxcam.c               |    2 +-
 drivers/media/platform/omap3isp/isp.c              |   74 +-
 drivers/media/platform/omap3isp/ispccp2.c          |    8 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |   13 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   28 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |   28 +-
 drivers/media/platform/omap3isp/isphist.c          |   21 +-
 drivers/media/platform/omap3isp/isppreview.c       |   40 +-
 drivers/media/platform/omap3isp/ispqueue.c         |    5 +-
 drivers/media/platform/s3c-camif/camif-core.c      |    9 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c     |  190 +-
 drivers/media/platform/s5p-fimc/fimc-core.c        |  173 +-
 drivers/media/platform/s5p-fimc/fimc-core.h        |   17 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c    |   16 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.h    |    4 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |  200 +-
 drivers/media/platform/s5p-fimc/fimc-lite.h        |    9 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c         |  136 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c     |  400 ++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.h     |   14 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c         |   82 +-
 drivers/media/platform/s5p-fimc/fimc-reg.h         |   10 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  109 +-
 drivers/media/platform/s5p-g2d/g2d-hw.c            |   16 +-
 drivers/media/platform/s5p-g2d/g2d-regs.h          |    7 +
 drivers/media/platform/s5p-g2d/g2d.c               |   43 +-
 drivers/media/platform/s5p-g2d/g2d.h               |   17 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    8 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  173 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   31 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  149 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h      |    3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   15 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c       |   30 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |    5 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |  197 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  148 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |    2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |   18 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |    2 +-
 drivers/media/platform/s5p-tv/mixer.h              |    1 +
 drivers/media/platform/s5p-tv/mixer_drv.c          |   14 +-
 drivers/media/platform/s5p-tv/mixer_reg.c          |    6 +-
 drivers/media/platform/s5p-tv/mixer_video.c        |   19 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |   29 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |    6 +-
 drivers/media/platform/sh_veu.c                    | 1266 ++++++++++++
 drivers/media/platform/sh_vou.c                    |  123 +-
 drivers/media/platform/soc_camera/Kconfig          |    7 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    6 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    5 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  541 ++---
 drivers/media/platform/soc_camera/mx3_camera.c     |    6 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    6 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |   73 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   44 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |   23 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  172 +-
 .../platform/soc_camera/soc_camera_platform.c      |    6 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |    6 -
 drivers/media/platform/timblogiw.c                 |    2 +-
 drivers/media/platform/via-camera.c                |   60 +-
 drivers/media/platform/vino.c                      |   11 +-
 drivers/media/platform/vivi.c                      |  224 ++-
 drivers/media/radio/Kconfig                        |   12 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-ma901.c                  |  460 +++++
 drivers/media/radio/radio-miropcm20.c              |  173 +-
 drivers/media/radio/radio-wl1273.c                 |    3 +-
 drivers/media/radio/si470x/radio-si470x.h          |    4 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |    3 +-
 drivers/media/rc/ati_remote.c                      |   27 +-
 drivers/media/rc/ene_ir.c                          |   28 +-
 drivers/media/rc/fintek-cir.c                      |   24 +-
 drivers/media/rc/gpio-ir-recv.c                    |   55 +-
 drivers/media/rc/iguanair.c                        |   26 +-
 drivers/media/rc/imon.c                            |    4 +-
 drivers/media/rc/ir-raw.c                          |   17 +-
 drivers/media/rc/ite-cir.c                         |   26 +-
 drivers/media/rc/keymaps/Makefile                  |    1 +
 .../media/rc/keymaps/rc-total-media-in-hand-02.c   |   86 +
 drivers/media/rc/mceusb.c                          |   37 +-
 drivers/media/rc/nuvoton-cir.c                     |   41 +-
 drivers/media/rc/rc-core-priv.h                    |   16 +-
 drivers/media/rc/rc-main.c                         |    7 +-
 drivers/media/rc/redrat3.c                         |   18 +-
 drivers/media/rc/ttusbir.c                         |   10 +-
 drivers/media/rc/winbond-cir.c                     |   41 +-
 drivers/media/tuners/fc0011.c                      |   19 +-
 drivers/media/tuners/fc0012-priv.h                 |   13 +-
 drivers/media/tuners/fc0012.c                      |  113 +-
 drivers/media/tuners/fc0012.h                      |   32 +-
 drivers/media/tuners/mt2060.h                      |    2 +-
 drivers/media/tuners/mt2063.h                      |    2 +-
 drivers/media/tuners/mt20xx.h                      |    2 +-
 drivers/media/tuners/mt2131.h                      |    2 +-
 drivers/media/tuners/mt2266.h                      |    2 +-
 drivers/media/tuners/mxl5007t.h                    |    2 +-
 drivers/media/tuners/qt1010.h                      |    2 +-
 drivers/media/tuners/tda18212.c                    |    6 +-
 drivers/media/tuners/tda18218.c                    |    6 +-
 drivers/media/tuners/tda18271-fe.c                 |    2 +
 drivers/media/tuners/tda18271-maps.c               |    6 +-
 drivers/media/tuners/tda18271.h                    |    2 +-
 drivers/media/tuners/tda827x.h                     |    2 +-
 drivers/media/tuners/tda8290.h                     |    2 +-
 drivers/media/tuners/tda9887.h                     |    2 +-
 drivers/media/tuners/tea5761.h                     |    2 +-
 drivers/media/tuners/tea5767.h                     |    2 +-
 drivers/media/tuners/tuner-simple.h                |    2 +-
 drivers/media/tuners/tuner-xc2028.c                |    2 +-
 drivers/media/tuners/tuner-xc2028.h                |    2 +-
 drivers/media/tuners/xc4000.c                      |    2 +-
 drivers/media/tuners/xc4000.h                      |    2 +-
 drivers/media/tuners/xc5000.c                      |    1 +
 drivers/media/usb/Kconfig                          |    2 +-
 drivers/media/usb/au0828/Kconfig                   |   17 +-
 drivers/media/usb/au0828/Makefile                  |    6 +-
 drivers/media/usb/au0828/au0828-cards.c            |   24 +-
 drivers/media/usb/au0828/au0828-core.c             |   13 +-
 drivers/media/usb/au0828/au0828-i2c.c              |   13 +-
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/au0828/au0828.h                  |    2 +
 drivers/media/usb/cpia2/cpia2_usb.c                |    2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |    5 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   31 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    6 +-
 drivers/media/usb/cx231xx/cx231xx.h                |    1 +
 drivers/media/usb/dvb-usb-v2/Kconfig               |    4 +-
 drivers/media/usb/dvb-usb-v2/af9015.c              |    4 +
 drivers/media/usb/dvb-usb-v2/af9035.c              |  289 ++-
 drivers/media/usb/dvb-usb-v2/af9035.h              |    3 +-
 drivers/media/usb/dvb-usb-v2/anysee.c              |    4 +
 drivers/media/usb/dvb-usb-v2/az6007.c              |   26 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |    3 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   15 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |   54 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c             |   38 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c            |   30 +-
 drivers/media/usb/dvb-usb/Kconfig                  |    8 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |    5 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |   60 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  179 +-
 drivers/media/usb/dvb-usb/friio-fe.c               |    5 +-
 drivers/media/usb/dvb-usb/m920x.c                  |  277 ++-
 drivers/media/usb/dvb-usb/ttusb2.c                 |    8 +-
 drivers/media/usb/em28xx/Kconfig                   |    8 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  270 ++-
 drivers/media/usb/em28xx/em28xx-core.c             |  296 +--
 drivers/media/usb/em28xx/em28xx-dvb.c              |   96 +-
 drivers/media/usb/em28xx/em28xx-i2c.c              |  293 +--
 drivers/media/usb/em28xx/em28xx-input.c            |  359 ++--
 drivers/media/usb/em28xx/em28xx-reg.h              |    5 +-
 drivers/media/usb/em28xx/em28xx-vbi.c              |  123 +-
 drivers/media/usb/em28xx/em28xx-video.c            | 1699 +++++-----------
 drivers/media/usb/em28xx/em28xx.h                  |  149 +-
 drivers/media/usb/gspca/cpia1.c                    |    6 +-
 drivers/media/usb/gspca/gspca.c                    |   10 +-
 drivers/media/usb/gspca/gspca.h                    |    6 +-
 drivers/media/usb/gspca/jl2005bcd.c                |   18 +-
 drivers/media/usb/gspca/konica.c                   |    6 +-
 drivers/media/usb/gspca/ov519.c                    |    6 +-
 drivers/media/usb/gspca/pac207.c                   |   36 +-
 drivers/media/usb/gspca/pac7302.c                  |    4 +-
 drivers/media/usb/gspca/pac7311.c                  |    4 +-
 drivers/media/usb/gspca/se401.c                    |    4 +-
 drivers/media/usb/gspca/sn9c20x.c                  |    4 +-
 drivers/media/usb/gspca/sonixb.c                   |    6 +-
 drivers/media/usb/gspca/sonixj.c                   |    4 +-
 drivers/media/usb/gspca/spca561.c                  |    6 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |    4 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   |   17 +-
 drivers/media/usb/gspca/t613.c                     |    8 +-
 drivers/media/usb/gspca/xirlink_cit.c              |    8 +-
 drivers/media/usb/gspca/zc3xx.c                    |    4 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |    6 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |    5 +-
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |    3 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |    2 +-
 drivers/media/usb/pwc/pwc-if.c                     |    5 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |    7 +-
 drivers/media/usb/s2255/s2255drv.c                 |    6 +-
 drivers/media/usb/sn9c102/sn9c102_core.c           |    9 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    4 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   59 +-
 drivers/media/usb/tlg2300/pd-video.c               |    2 +-
 drivers/media/usb/tm6000/tm6000-core.c             |    9 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |    4 +-
 drivers/media/usb/tm6000/tm6000-video.c            |  542 +++--
 drivers/media/usb/tm6000/tm6000.h                  |   10 +
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |    7 +
 drivers/media/usb/usbvision/usbvision-core.c       |    2 +-
 drivers/media/usb/usbvision/usbvision-i2c.c        |    3 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    5 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   16 +
 drivers/media/usb/uvc/uvc_v4l2.c                   |    8 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    6 +-
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    3 +-
 drivers/media/v4l2-core/tuner-core.c               |   17 +-
 drivers/media/v4l2-core/v4l2-common.c              |   14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  179 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   14 +-
 drivers/media/v4l2-core/v4l2-device.c              |   32 +-
 drivers/media/v4l2-core/v4l2-event.c               |    7 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |    4 +-
 drivers/media/v4l2-core/videobuf-core.c            |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   15 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/as102/as102_usb_drv.c        |    4 +-
 drivers/staging/media/as102/as10x_cmd_cfg.c        |    2 +-
 drivers/staging/media/cxd2099/cxd2099.c            |   29 +-
 drivers/staging/media/cxd2099/cxd2099.h            |    2 +-
 drivers/staging/media/davinci_vpfe/Kconfig         |    9 +
 drivers/staging/media/davinci_vpfe/Makefile        |    3 +
 drivers/staging/media/davinci_vpfe/TODO            |   37 +
 .../staging/media/davinci_vpfe/davinci-vpfe-mc.txt |  154 ++
 .../staging/media/davinci_vpfe/davinci_vpfe_user.h | 1290 ++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 1863 +++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipe.h   |  179 ++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    | 1048 ++++++++++
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.h    |  559 ++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 1071 ++++++++++
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h |  233 +++
 .../media/davinci_vpfe/dm365_ipipeif_user.h        |   93 +
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2104 ++++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_isif.h    |  203 ++
 .../staging/media/davinci_vpfe/dm365_isif_regs.h   |  294 +++
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 1999 +++++++++++++++++++
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |  244 +++
 drivers/staging/media/davinci_vpfe/vpfe.h          |   86 +
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  740 +++++++
 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |   97 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    | 1620 +++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |  155 ++
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    2 +-
 drivers/staging/media/go7007/go7007-driver.c       |   15 +-
 drivers/staging/media/go7007/go7007-fw.c           |   24 +-
 drivers/staging/media/go7007/go7007-i2c.c          |   10 +-
 drivers/staging/media/go7007/go7007-usb.c          |    5 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |   11 +-
 drivers/staging/media/go7007/s2250-board.c         |   32 +-
 drivers/staging/media/go7007/s2250-loader.c        |   38 +-
 drivers/staging/media/go7007/wis-saa7113.c         |    2 +-
 drivers/staging/media/go7007/wis-sony-tuner.c      |   86 +-
 drivers/staging/media/go7007/wis-tw2804.c          |   24 +-
 drivers/staging/media/go7007/wis-tw9903.c          |   12 +-
 drivers/staging/media/go7007/wis-uda1342.c         |    7 +-
 drivers/staging/media/lirc/lirc_bt829.c            |   15 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c      |   12 +-
 drivers/staging/media/lirc/lirc_imon.c             |   31 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   49 +-
 drivers/staging/media/lirc/lirc_sasem.c            |   73 +-
 drivers/staging/media/lirc/lirc_serial.c           |   70 +-
 drivers/staging/media/lirc/lirc_sir.c              |   36 +-
 drivers/staging/media/solo6x10/p2m.c               |    8 +-
 drivers/staging/media/solo6x10/v4l2-enc.c          |    4 +
 drivers/staging/media/solo6x10/v4l2.c              |    5 +-
 include/media/adv7343.h                            |   52 +
 include/media/blackfin/bfin_capture.h              |    5 +-
 include/media/blackfin/ppi.h                       |   36 +-
 include/media/davinci/vpbe_osd.h                   |    5 +-
 include/media/davinci/vpbe_venc.h                  |    5 +-
 include/media/davinci/vpss.h                       |   16 +
 include/media/ov7670.h                             |    2 +
 include/media/ov9650.h                             |   27 +
 include/media/rc-map.h                             |    1 +
 include/media/s5c73m3.h                            |   55 +
 include/media/s5p_fimc.h                           |   49 +-
 include/media/soc_camera.h                         |  107 +-
 include/media/soc_camera_platform.h                |   10 +-
 include/media/tvp514x.h                            |    7 +-
 include/media/v4l2-common.h                        |    2 +
 include/media/v4l2-ctrls.h                         |   53 +
 include/media/v4l2-event.h                         |    4 +-
 include/media/v4l2-image-sizes.h                   |   34 +
 include/media/v4l2-mem2mem.h                       |    2 +-
 include/uapi/linux/dvb/frontend.h                  |   79 +-
 include/uapi/linux/dvb/version.h                   |    2 +-
 include/uapi/linux/meye.h                          |    8 +-
 include/uapi/linux/v4l2-controls.h                 |   33 +-
 include/uapi/linux/v4l2-mediabus.h                 |   11 +-
 include/uapi/linux/videodev2.h                     |   35 +-
 540 files changed, 33018 insertions(+), 11116 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
 create mode 100644 Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
 delete mode 100644 Documentation/video4linux/et61x251.txt
 mode change 100644 => 100755 Documentation/video4linux/extract_xc3028.pl
 delete mode 100644 Documentation/video4linux/ibmcam.txt
 delete mode 100644 Documentation/video4linux/m5602.txt
 delete mode 100644 Documentation/video4linux/ov511.txt
 delete mode 100644 Documentation/video4linux/se401.txt
 delete mode 100644 Documentation/video4linux/stv680.txt
 delete mode 100644 Documentation/video4linux/w9968cf.txt
 delete mode 100644 Documentation/video4linux/zc0301.txt
 rename drivers/media/{i2c => common}/btcx-risc.c (100%)
 rename drivers/media/{i2c => common}/btcx-risc.h (100%)
 rename drivers/media/{i2c => common}/cx2341x.c (100%)
 rename drivers/media/{i2c => common}/tveeprom.c (74%)
 create mode 100644 drivers/media/dvb-frontends/ts2020.c
 create mode 100644 drivers/media/dvb-frontends/ts2020.h
 create mode 100644 drivers/media/i2c/ov9650.c
 create mode 100644 drivers/media/i2c/s5c73m3/Makefile
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-core.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3-spi.c
 create mode 100644 drivers/media/i2c/s5c73m3/s5c73m3.h
 create mode 100644 drivers/media/platform/sh_veu.c
 create mode 100644 drivers/media/radio/radio-ma901.c
 create mode 100644 drivers/media/rc/keymaps/rc-total-media-in-hand-02.c
 create mode 100644 drivers/staging/media/davinci_vpfe/Kconfig
 create mode 100644 drivers/staging/media/davinci_vpfe/Makefile
 create mode 100644 drivers/staging/media/davinci_vpfe/TODO
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
 create mode 100644 drivers/staging/media/davinci_vpfe/davinci_vpfe_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_ipipeif_user.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_isif_regs.h
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.c
 create mode 100644 drivers/staging/media/davinci_vpfe/dm365_resizer.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.c
 create mode 100644 drivers/staging/media/davinci_vpfe/vpfe_video.h
 create mode 100644 include/media/ov9650.h
 create mode 100644 include/media/s5c73m3.h
 create mode 100644 include/media/v4l2-image-sizes.h

