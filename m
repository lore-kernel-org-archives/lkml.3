Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3BUR6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:58:34 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54074 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab3BUR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:58:30 -0500
Date: Thu, 21 Feb 2013 09:59:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.9-rc1
Message-ID: <20130221175900.GA15189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.9-rc1

for you to fetch changes up to 951348b377385475aa256c27e1c9e2564c9ec160:

  staging: comedi: vmk80xx: wait for URBs to complete (2013-02-18 10:53:50 -0800)

----------------------------------------------------------------
Staging tree update for 3.9-rc1

Here's the big staging tree merge for 3.9-rc1

Lots of cleanups and updates for drivers all through the staging tree.
We are pretty much "code neutral" here, adding just about as many lines
as we removed.

All of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (10):
      staging: xgifb: use XGIRegInit()
      staging: xgifb: do not use pVBInfo->BaseAddr
      staging: xgifb: delete pVBInfo->BaseAddr
      staging: xgifb: initialize register 3cc address
      staging: xgifb: XGI_GetVCLK2Ptr(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_GetVBInfo(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_GetTVInfo(): delete IF_DEF_LVDS checks
      staging: xgifb: XGI_GetLCDInfo(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_GetCRT2ResInfo(): delete IF_DEF_LVDS check
      staging: xgifb: XGI_SetDelayComp(): delete IF_DEF_LVDS check

Alan Cox (2):
      goldfish: Add a FIXME note to the pipe driver
      goldfish: audio support

Alexander Holler (4):
      iio: Add Usage IDs for HID time sensors.
      iio: merge hid-sensor-attributes.h into hid-sensor-hub.h
      rtc: add rtc-driver for HID sensors of type time
      hid: iio: rename struct hid_sensor_iio_common to hid_sensor_common

Alexander Stein (1):
      iio: Fix some comments

Alexey Khoroshilov (1):
      staging: ced1401: fix GFP_KERNEL in spinlock context

Andres More (9):
      staging: vt6656: cleared 'do not use C99 // comments' checkpatch errors
      staging: vt6656: cleared 'do not use C99 // comments' checkpatch errors
      staging: vt6656: fixed C99 // comments
      staging: vt6656: cleared C99 // comments in datarate.c
      staging: vt6656: fixed C99 // comments in two headers
      staging: vt6656: fix C99 // comments in main_usb.c
      staging: vt6656: replace custom BOOL definition with bool
      staging: vt6656: replaced custom FALSE definition with false
      staging: vt6656: replaced custom TRUE definition with true

Andy Gross (2):
      drm/omap: Add PM capabilities
      drm/omap: Add OMAP5 support

Arve Hjønnevåg (1):
      goldfish: NAND flash driver

Axel Lin (1):
      rtc: hid-sensor-time: Add missing spin_lock_init

Chen Gang (3):
      staging: tidspbridge/pmgr: additional checking after return from strlen_user
      staging: tidspbridge/pmgr: use strlcpy instead of strncpy
      staging: tidspbridge/pmgr: another using strlcpy instead of strncpy

Chris Kelly (1):
      staging:ozwpan: Removed myself (Chris Kelly) as maintainer.

Cong Ding (3):
      staging: echo: remove unused variable
      staging: echo.c: fix memory leakage
      staging: omapdrm/omap_gem_dmabuf.c: fix memory leakage

Cruz Julian Bishop (6):
      staging: android: Avoid using camelcase in binder.h
      staging: android: Fix two checkpatch issues in binder.c
      staging: android: Add some Kconfig help entries
      staging: slicoss: Stop swearing in slicoss.c
      staging: slicoss: Fix three checkpatch.pl errors in slicoss.c
      staging: slicoss: Fix space-related checkpatch.pl warnings

Cyril Roelandt (8):
      staging: wlags49_h2: remove unneeded memset() in wireless_get_bssid()
      staging: vt6656: remove a useless call to memset().
      staging: csr: remove unneeded call to memset().
      staging: omap-thermal: fix error check in omap_thermal_expose_sensor() and in omap_thermal_register_cpu_cooling().
      staging: rtl8712: avoid a useless call to memset().
      rtl8712: remove useless calls to memset().
      staging: dgrp: remove redundant NULL check before unregister_dgrp_device().
      staging: tidspbridge: remove redundant NULL check before delete_msg_mgr().

Dan Carpenter (7):
      staging: line6: delete an unused function
      Staging: bcm: add a missing break statement
      Staging: bcm: copying more data than intended
      Staging: comedi: add a missing break statement
      staging: sb105x: move dereference under IS_ERR() check
      staging: sb105x: clean up interface type test
      staging: cxt1e1: buffer overflow in do_del_chan()

Dan Magenheimer (8):
      staging: ramster: disable build in anticipation of renaming
      staging: zcache: rename ramster to zcache
      staging: zcache: adjustments to config/build files due to renaming
      staging: zcache: re-enable config/build of zcache after renaming
      staging: zcache: fix uninitialized variable compile warning
      staging: zcache: fix ppc64 and other arches where PAGE_SIZE!=4K
      staging/zcache: Fix/improve zcache writeback code, tie to a config option
      staging: zcache: add TODO file

David 'Digit' Turner (1):
      goldfish: add QEMU pipe driver

Davidlohr Bueso (4):
      staging: zram: simplify num_devices paramater
      staging: zram: show correct disksize
      staging: zram: drop zram_stat_dec/inc functions
      staging: zsmalloc: comment zs_create_pool function

Denis CIOCCA (2):
      iio:common: removed unused functions outside st_sensors library
      iio:common: added allocate and deallocate trigger functions when trigger is disabled.

Denis Ciocca (4):
      iio:common: Add STMicroelectronics common library
      iio:accel: Add STMicroelectronics accelerometers driver
      iio:gyro: Add STMicroelectronics gyroscopes driver
      iio:magnetometer: Add STMicroelectronics magnetometers driver

Devendra Naga (6):
      staging: vt6655: s/kmalloc + memset/kzalloc in alloc_rd_info
      staging: vt6655: checkpatch fixes
      staging: vt6655: s/kmalloc + memset / kzalloc
      staging: vt6655: no braces needed for single statement if , for blocks
      staging: dgrp: check for a valid proc dir entry pointer
      staging: sep: remove assignment to i and j in sep_crypto_setup

Fabio Estevam (3):
      staging: imx-drm: ipu-common: Remove unused variable
      staging: ipu-di: Change DI address info to dev_dbg
      iio: mxs-lradc: Fix 'duplicate const' warning

Fengguang Wu (1):
      staging: zram: __zram_reset_device() can be static

Garrick He (1):
      Staging: wlan-ng: Fix tab coding style issue in hfa384x.h

Ge Gao (1):
      Invensense MPU6050 Device Driver.

Geert Uytterhoeven (1):
      staging: comedi: ISA DMA drivers should depend on ISA_DMA_API

Greg Kroah-Hartman (8):
      Merge tag 'iio-for-3.9a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge branch 'staging-linus' into staging-next
      Staging: zcache: delete it
      Staging: comedi: enable it to build on all arches
      Merge 3.8-rc5 into staging-next
      Merge tag 'iio-for-3.9b-v2' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.9c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.9d' of git://git.kernel.org/.../jic23/iio into staging-next

Guenter Roeck (12):
      staging/iio: (iio_hwmon) Use devm_kzalloc
      staging/iio: (iio_hwmon) Add support for sysfs name attribute
      staging/iio: (iio_hwmon) Basic devicetree support
      iio/adc: (lp8788) Provide OF node information to iio device
      iio/adc: (max1363) Provide OF node information to iio device
      iio/adc: (max1363) Remove duplicate code
      iio/adc: (max1363) Fix data conversion problems
      iio: Update iio_channel_get_all and iio_channel_get_all_cb API
      iio: Simplify iio_map_array_unregister API
      iio: max1363: Use devm_ functions whereever possible to allocate resources
      iio/adc: (max1363) Add support for external reference voltage
      iio: Update iio_channel_get API to use consumer device pointer as argument

H Hartley Sweeten (254):
      staging: comedi: pcm_common: remove module
      staging: comedi: comedi_fops: remove forward declarations
      staging: comedi: don't expose comedi_get_{read, write}_subdevice
      staging: comedi: comedi_fops: introduce comedi_dev_from_minor()
      staging: comedi: use comedi_dev_from_minor()
      staging: comedi: comedi_fops: don't export comedi_get_device_file_info()
      staging: comedi: don't expose struct comedi_device_file_info
      staging: comedi: comedi_fops: rename struct comedi_device_file_info
      staging: comedi: comedi_fops: rename comedi_get_device_file_info()
      staging: comedi: comedi_fops: rename comedi_{read,write}_subdevice()
      staging: comedi: comedi_fops: cleanup do_devinfo_ioctl()
      staging: comedi: comedi_fops: cleanup comedi_poll()
      staging: comedi: comedi_fops: remove the goto's in comedi_read()
      staging: comedi: comedi_fops: remove the goto's in comedi_write()
      staging: comedi: comedi_fops: move the MODULE_* information to EOF
      staging: comedi: comedi_fops: move the module_{init, exit} functions to EOF
      staging: comedi: comedi_fops: move comedi_cleanup_legacy_minors()
      staging: comedi: comedi_fops: fix a number of sizeof(struct foo) forms
      staging: comedi: comedi_fops: move comedi_get_subdevice_runflags()
      staging: comedi: comedi_fops: introduce comedi_is_subdevice_running()
      staging: comedi: use comedi_is_subdevice_running()
      staging: comedi: comedi_fops: don't export comedi_get_subdevice_runflags()
      staging: comedi: comedi_fops: introduce comedi_is_subdevice_in_error()
      staging: comedi: comedi_fops: introduce comedi_is_subdevice_idle()
      staging: comedi: comedi_fops: cleanup comedi_{read, write}_subdevice()
      staging: comedi: comedi_fops: cleanup comedi_mmap()
      staging: comedi: comedi_fops: use kzalloc in comedi_alloc_subdevice_minor()
      staging: comedi: store the 'index' for each subdevice
      staging: comedi: Makefile: conditionally compile multi-file core module
      staging: comedi: deprecate loading firmware with comedi_config
      staging: comedi: separate out comedi_buf_* functions
      staging: comedi: comedi_buf: factor out common code to free the async buffer
      staging: comedi: comedi_buf: factor out new buffer allocation code
      staging: comedi: comedi_buf: rename comedi_reset_async_buf()
      staging: comedi: comedi_buf: factor out common comedi_buf_write_alloc_* code
      staging: comedi: comedi_buf: remove comedi_buf_write_alloc_strict
      staging: comedi: comedi_buf: cleanup comedi_buf_munge()
      staging: comedi: comedi_buf: clarify comedi_buf_write_free()
      staging: comedi: comedi_buf: cleanup comedi_buf_read_n_available()
      staging: comedi: comedi_buf: clarify comedi_buf_read_alloc()
      staging: comedi: comedi_buf: clarify comedi_buf_read_free()
      staging: comedi: comedi_buf: don't expose comedi_buf_read_n_allocated()
      staging: comedi: comedi_buf: don't expose comedi_buf_write_n_allocated()
      staging: comedi: comedi_buf: reorder exported function prototypes
      staging: comedi: comedi_buf: remove BUG_ON in comedi_buf_munge()
      staging: comedi: comedi_buf: remove unreachable dev_warn in comedi_buf_munge()
      staging: comedi: comedi_buf: remove noise in comedi_buf_write_free()
      staging: comedi: comedi_buf: remove noise in comedi_buf_read_free()
      staging: comedi: addi_apci_2200: separate from addi_common.c
      staging: comedi: addi_apci_2200: board does not have ttl i/o
      staging: comedi: addi_apci_2200: board does not have analog outputs
      staging: comedi: addi_apci_2200: board does not have analog inputs
      staging: comedi: addi_apci_2200: remove eeprom support code
      staging: comedi: addi_apci_2200: absorb i_APCI2200_Reset()
      staging: comedi: addi_apci_2200: simplify the PCI bar reading
      staging: comedi: addi_apci_2200: remove unnecessary info from boardinfo
      staging: comedi: addi_apci_2200: remove devpriv->iobase usage
      staging: comedi: addi_apci_2200: don't read the unused PCI bars
      staging: comedi: addi_apci_2200: remove use of devpriv->s_EeParameters
      staging: comedi: addi_apci_2200: remove interrupt support code
      staging: comedi: addi_apci_2200: cleanup digital input subdevice
      staging: comedi: addi_apci_2200: cleanup digital output subdevice
      staging: comedi: introduce addi_watchdog driver
      staging: comedi: addi_apci_2032: use addi_watchdog module
      staging: comedi: addi_apci_16xx: separate from addi_common.c
      staging: comedi: addi_apci_16xx: board does not have analog inputs
      staging: comedi: addi_apci_16xx: board does not have analog outputs
      staging: comedi: addi_apci_16xx: board does not have digital inputs
      staging: comedi: addi_apci_16xx: board does not have digital outputs
      staging: comedi: addi_apci_16xx: board does not have a timer
      staging: comedi: addi_apci_16xx: remove eeprom support code
      staging: comedi: addi_apci_16xx: remove i_APCI16XX_Reset()
      staging: comedi: addi_apci_16xx: remove interrupt support code
      staging: comedi: addi_apci_16xx: simplify PCI bar reading
      staging: comedi: addi_apci_16xx: remove unnecessary comments
      staging: comedi: addi_apci_16xx: remove devpriv->iobase usage
      staging: comedi: addi_apci_16xx: remove devpriv->s_EeParameters usage
      staging: comedi: addi_apci_16xx: only allocate needed subdevices
      staging: comedi: addi_apci_16xx: cleanup subdevice initialization
      staging: comedi: addi_apci_16xx: remove need for comedi_board()
      staging: comedi: addi_apci_16xx: redefine the boardinfo
      staging: comedi: addi_apci_16xx: cleanup addi_find_boardinfo()
      staging: comedi: comedi_fops: remove last forward declaration
      staging: comedi: drivers (core): remove forward declarations
      staging: comedi: drivers (core): factor out async subdevice postconfig
      staging: comedi: drivers (core): don't BUG_ON due to faulty drivers
      staging: comedi: drivers (core): remove BUG_ON in comedi_auto_unconfig()
      staging: comedi: addi_apci_2200: use addi_watchdog module
      staging: comedi: addi_apci_2200: remove devpriv allocation
      staging: comedi: addi_apci_2200: remove unnecessary boardinfo
      staging: comedi: addi_apci_2200: remove unnecessary include
      staging: comedi: addi_apci_2200: add missing copyright comment
      staging: comedi: addi_apci_2200: only allocate needed subdevices
      staging: comedi: addi_apci_2200: change the MODULE_DESCRIPTION
      staging: comedi: addi_apci_16xx: rewrite low-level support code
      staging: comedi: addi_apci_16xx: add missing copyright comment
      staging: comedi: addi_apci_16xx: remove unnecessary include
      staging: comedi: addi_apci_16xx: change the MODULE_DESCRIPTION
      staging: comedi: addi_apci_16xx: add defines for the PCI device ids
      staging: comedi: addi_apci_3501: separate from addi_common.c
      staging: comedi: addi_apci_3501: board does not have ttl i/o
      staging: comedi: addi_apci_3501: board has a timer
      staging: comedi: addi_apci_3501: cleanup the digital output subdevice
      staging: comedi: addi_apci_3501: cleanup the digital input subdevice
      staging: comedi: addi_apci_3501: board does not have analog inputs
      staging: comedi: addi_apci_3501: absorb i_APCI3501_Reset()
      staging: comedi: addi_apci_3501: absorb v_APCI3501_Interrupt()
      staging: comedi: addi_apci_3501: simplify eeprom read
      staging: comedi: addi_apci_3501: simplify the PCI bar reading
      staging: comedi: addi_apci_3501: remove devpriv->iobase usage
      staging: comedi: addi_apci_3501: board does not support dma
      staging: comedi: addi_apci_3501: don't read the unused PCI bars
      staging: comedi: addi_apci_3501: analog output resolution is fixed
      staging: comedi: addi_apci_3501: remove analog output boardinfo
      staging: comedi: addi_apci_3501: board has an eeprom
      staging: comedi: addi_apci_3501: simplify reading the eeprom
      staging: comedi: addi_apci_3501: remove boardinfo
      staging: comedi: addi_apci_3501: only allocate needed subdevices
      staging: comedi: addi_apci_3501: remove dependency on addi_common.h
      staging: comedi: addi_apci_3501: start defining i/o map
      staging: comedi: addi_apci_3501: reorder code a bit
      staging: comedi: addi_apci_3501: move range_apci3501_ao to driver
      staging: comedi: addi_apci_3501: introduce apci3501_wait_for_dac()
      staging: comedi: addi_apci_3501: cleanup apci3501_reset()
      staging: comedi: addi_apci_3501: rewrite the analog output support
      staging: comedi: addi_apci_3501: move the copyright information
      staging: comedi: addi_apci_3501: change the MODULE_DESCRIPTION
      staging: comedi: addi_apci_3501: define the timer i/o registers
      staging: comedi: addi_apci_3501: cleanup comments in hwdrv_apci3501.c
      staging: comedi: addi_apci_1516: use addi_watchdog module
      staging: comedi: addi_watchdog: all i/o registers are 32-bit
      staging: comedi: quatech_daqp_cs: move MODULE_* info to end of file
      staging: comedi: quatech_daqp_cs: cleanup pcmcia_driver
      staging: comedi: quatech_daqp_cs: remove forward declarations
      staging: comedi: quatech_daqp_cs: remove daqp_cs_release()
      staging: comedi: quatech_daqp_cs: cleanup daqp_cs_attach()
      staging: comedi: quatech_daqp_cs: remove casts of void *
      staging: comedi: quatech_daqp_cs: simplify IRQ_NONE checks in daqp_interrupt()
      staging: comedi: quatech_daqp_cs: remove debug functions
      staging: comedi: quatech_daqp_cs: remove #define pr_fmt
      staging: comedi: quatech_daqp_cs: cleanup the comedi_lrange tables
      staging: comedi: quatech_daqp_cs: fix possible memory dereference issue
      staging: comedi: quatech_daqp_cs: cleanup subdevice init
      staging: comedi: ni_mio_cs: move MODULE_* info to end of file
      staging: comedi: ni_mio_cs: cleanup pcmcia_driver
      staging: comedi: ni_mio_cs: remove setting dev->driver
      staging: comedi: ni_mio_cs: remove pcmcia_driver suspend/resume
      staging: comedi: ni_mio_cs: move pcmcia_driver functions
      staging: comedi: ni_mio_cs: remove cs_release()
      staging: comedi: ni_mio_cs: cleanup cs_attach()
      staging: comedi: ni_mio_cs: move comedi_driver declaration
      staging: comedi: ni_mio_cs: move mio_cs_detach()
      staging: comedi: ni_mio_cs: remove last forward declaration
      staging: comedi: ni_mio_cs: cleanup mio_cs_attach()
      staging: comedi: ni_mio_cs: cleanup the boardinfo declaration
      staging: comedi: ni_labpc_cs: move MODULE_* info to end of file
      staging: comedi: ni_labpc_cs: cleanup pcmcia_driver
      staging: comedi: ni_labpc_cs: remove labpc_release()
      staging: comedi: ni_labpc_cs: remove 'stop' from private pcmcia data
      staging: comedi: ni_labpc_cs: remove pcmcia_driver suspend/resume
      staging: comedi: ni_labpc_cs: move pcmcia_driver functions
      staging: comedi: ni_labpc_cs: cleanup labpc_cs_attach()
      staging: comedi: ni_labpc_cs: remove pcmcia_device private data
      staging: comedi: ni_labpc_cs: move comedi_driver declaration
      staging: comedi: ni_labpc_cs: remove thisboard macro
      staging: comedi: ni_labpc_cs: cleanup the boardinfo declaration
      staging: comedi: ni_labpc_cs: remove '#undef LABPC_DEBUG'
      staging: comedi: conditionally build in USB driver support
      staging: comedi: conditionally build in PCI driver support
      staging: comedi: conditionally build in PCMCIA driver support
      staging: comedi: allow pcmcia drivers to auto attach
      staging: comedi: cb_das16_cs: convert to auto attach
      staging: comedi: das08_cs: convert to auto attach
      staging: comedi: ni_daq_700: convert to auto attach
      staging: comedi: tidy up the general purpose driver functions
      staging: comedi: don't expose comedi_device_{attach,detach}
      staging: comedi: don't expose comedi_proc_{init,cleanup}
      staging: comedi: ni_daq_dio24: move MODULE_* info to end of file
      staging: comedi: ni_daq_dio24: cleanup pcmcia_driver
      staging: comedi: ni_daq_dio24: remove dio24_release()
      staging: comedi: ni_daq_dio24: remove 'stop' from private pcmcia data
      staging: comedi: ni_daq_dio24: remove pcmcia_driver suspend/resume
      staging: comedi: ni_daq_dio24: cleanup pcmcia probe/remove
      staging: comedi: ni_daq_dio24: remove pcmcia_device private data
      staging: comedi: ni_daq_dio24: move comedi_driver declaration
      staging: comedi: ni_daq_dio24: remove thisboard macro
      staging: comedi: ni_daq_dio24: remove the '#ifdef incomplete' code
      staging: comedi: ni_daq_dio24: remove comedi private data
      staging: comedi: ni_daq_dio24: remove '#undef LABPC_DEBUG'
      staging: comedi: ni_daq_dio24: cleanup dio24_detach
      staging: comedi: ni_daq_dio24: convert to auto attach
      staging: comedi: ni_daq_dio24: remove some unnecessary includes
      staging: comedi: ni_labpc_cs: convert to auto attach
      staging: comedi: ni_mio_cs: convert to auto attach
      staging: comedi: das08: split out bus specific code
      pci_ids.h: add common pci vendor ids from comedi subsystem
      staging: comedi: comedi_pcmcia: introduce comedi_pcmcia_{enable, disable}
      staging: comedi: cb_das16_cs: use comedi_pcmcia_{enable, disable}
      staging: comedi: cb_das16_cs: use pcmcia_request_irq()
      staging: comedi: cb_das16_cs: use comedi_pcmcia_disable() for (*detach)
      staging: comedi: das08_cs: use comedi_pcmcia_{enable, disable}
      staging: comedi: ni_daq_700: use comedi_pcmcia_{enable, disable}
      staging: comedi: ni_daq_700: use comedi_pcmcia_disable() for (*detach)
      staging: comedi: quatech_daqp_cs: convert to auto attach
      staging: comedi: quatech_daqp_cs: use comedi_pcmcia_{enable, disable}
      staging: comedi: quatech_daqp_cs: use comedi_pcmcia_disable() for (*detach)
      staging: comedi: quatech_daqp_cs: ao subdevice does not support commands
      staging: comedi: quatech_daqp_cs: store private data in the comedi_device
      staging: comedi: quatech_daqp_cs: rename the private data struct
      staging: comedi: quatech_daqp_cs: remove unused define
      staging: comedi: quatech_daqp_cs: use (*insn_bits) for digital inputs
      staging: comedi: quatech_daqp_cs: use (*insn_bits) for digital outputs
      staging: comedi: quatech_daqp_cs: fix daqp_ao_insn_write()
      staging: comedi: quatech_daqp_cs: factor out common ai scanlist code
      staging: comedi: remove 'comedi_autoconfig' module parameter
      staging: comedi: vmk80xx: remove support for manual attaching
      staging: comedi: vmk80xx: move usb_driver (*disconnect) code
      staging: comedi: vmk80xx: use comedi_auto_unconfig() for (*disconnect)
      staging: comedi: vmk80xx: move boardinfo into a const array
      staging: comedi: vmk80xx: save the boardinfo in the comedi_device
      staging: comedi: vmk80xx: remove common and unused boardinfo
      staging: comedi: vmk80xx: remove VMK80XX_SUBD_* enum
      staging: comedi: vmk80xx: rename struct vmk80xx_usb
      staging: comedi: vmk80xx: consistently use the same local var names
      staging: comedi: vmk80xx: factor out usb endpoint detection
      staging: comedi: vmk80xx: factor out usb buffer allocation
      staging: comedi: vmk80xx: remove private data 'count'
      staging: comedi: vmk80xx: make sure private data is clean when detached
      staging: comedi: vmk80xx: remove private data 'probed'
      staging: comedi: vmk80xx: remove private data 'attached'
      staging: comedi: comedi_usb: allow comedi usb drivers to pass a 'context'
      staging: comedi: vmk80xx: push usb (*probe) into comedi (*auto_attach)
      staging: comedi: vmk80xx: remove need for boardinfo in private_data
      staging: comedi: vmk80xx: cleanup analog input subdevice init
      staging: comedi: vmk80xx: cleanup analog output subdevice init
      staging: comedi: vmk80xx: cleanup digital input subdevice init
      staging: comedi: vmk80xx: cleanup digital input subdevice init
      staging: comedi: vmk80xx: cleanup counter subdevice init
      staging: comedi: vmk80xx: cleanup pwm subdevice init
      staging: comedi: vmk80xx: remove digital output (*insn_read)
      staging: comedi: vmk80xx: remove digital output (*insn_write)
      staging: comedi: vmk80xx: remove digital input (*insn_read)
      staging: comedi: vmk80xx: remove unused #define
      staging: comedi: vmk80xx: remove CONFIG_COMEDI_DEBUG code
      staging: comedi: vmk80xx: cleanup the comedi_lrange tables
      staging: comedi: vmk80xx: remove the 'Changelog' comments
      staging: comedi: vmk80xx: rename vmk80xx_attach_common()
      staging: comedi: ni_daq_dio24: use comedi_pcmcia_{enable,disable}
      staging: comedi: ni_labpc_cs: use comedi_pcmcia_{enable,disable}
      staging: comedi: comedi_pcmcia: allow drivers to use a custom conf_check()
      staging: comedi: ni_mio_cs: use comedi_pcmcia_{enable, disable}
      staging: comedi: ni_mio_cs: use pcmcia_request_irq()
      staging: comedi: quatech_daqp_cs: fix build error
      staging: comedi: ni_daq_dio24: add back missing 'if (ret)'

Harvey Yang (2):
      staging: usbip: use interrupt safe spinlock to avoid potential deadlock.
      staging: usbip: replace the interrupt safe spinlocks with common ones.

Ian Abbott (33):
      staging: comedi: addi_apci_2032: interrupt safety change
      staging: comedi: addi_apci_2032: correct interrupt subdevice
      staging: comedi: addi_apci_2032: set COMEDI_CB_OVERFLOW
      staging: comedi: addi_apci_2032: make insn_bits read live data
      staging: comedi: addi_apci_2032: only disable triggered interrupts
      staging: comedi: addi_apci_2032: use channel list
      staging: comedi: addi_apci_2032: always initialize interrupt subdevice
      staging: comedi: addi_apci_2032: support stop_src == TRIG_COUNT
      staging: comedi: comedi_test: fix race when cancelling command
      staging: comedi: comedi_test: remove unnecessary del_timer() call
      staging: comedi: comedi_test: change end-of-acquisition test
      staging: comedi: comedi_test: make samples unsigned
      staging: comedi: comedi_test: tidy up waveform_ai_interrupt()
      staging: comedi: comedi_test: whitespace fixes
      staging: comedi: (core): add comedi_dev_from_file_info()
      staging: comedi: Allow comedi on ARM
      staging: comedi: don't override read/write subdevice if not supported
      staging: comedi: simplify comedi_set_hw_dev()
      staging: comedi: disallow COMEDI_DEVCONFIG on non-board minors
      staging: comedi: cleanup all board minors on module exit
      staging: comedi: move comedi_alloc_subdevice_minor declarations
      staging: comedi: change comedi_alloc_subdevice_minor parameters
      staging: comedi: export comedi_set_hw_dev()
      staging: comedi: restrict comedi_set_hw_dev() usage
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: ni_labpc: correct differential channel sequence for AI commands
      staging: comedi: check s->async for poll(), read() and write()
      staging: comedi: don't return minor from comedi_alloc_subdevice_minor()
      staging: comedi: correct error message in comedi_alloc_subdevice_minor()
      staging: comedi: vmk80xx: zero buffers on allocation
      staging: comedi: vmk80xx: simplify vmk80xx_reset_device()
      staging: comedi: vmk80xx: initialize K8055 outputs to known state
      staging: comedi: vmk80xx: wait for URBs to complete

Ilija Hadzic (5):
      staging: usbip: userspace: fix build breakage in doc directory
      staging: usbip: userspace: add gitignore file
      staging: usbip: userspace: eliminate glib dependency
      staging: usbip: userspace: add option to turn fortify on or off
      staging: usbip: userspace: suppress a bogus error

Jake Champlin (5):
      Staging: usbip: usbipcommon: Fixed single line bracing issue
      Staging: Comedi: ni_tio: Fixed spacing issue
      Staging: Comedi: amplc_dio200: Fixed bracing issue
      Staging: Comedi: pcl818: Fixed Coding Style Issues
      Staging: Comedi: daqboard2000: Fixed Coding Style Issue

Jennifer Naumann (1):
      staging/rtl8192u: put { on same line as struct

Joe Perches (1):
      staging: Remove unnecessary OOM messages

Johan Meiring (32):
      staging: wlags49_h2: ap_h2: corrects a pointer styling issue
      staging: wlags49_h2: ap_h25: corrects tabs/spaces syling issues
      staging: wlags49_h2: ap_h25: corrects parentheses styling issue
      staging: wlags49_h2: ap_h25: corrects malformed #include warning
      staging: wlags49_h2: ap_h25: corrects casting styling issue
      staging: wlags49_h2: ap_h25: corrects incorrect use of // comments
      staging: wlags49_h2: wl_enc: converts indentation spaces to tabs
      staging: wlags49_h2: wl_enc: corrects spacing around parentheses
      staging: wlags49_h2: wl_enc: corrects spacing around colons
      staging: wlags49_h2: wl_enc: fixes incorrect use of return
      staging: wlags49_h2: wl_priv.h: fixes spacing around parentheses
      staging: wlags49_h2: wl_priv.h: converts C99 // comments
      staging: wlags49_h2: wl_priv.h: fixes instances of 80+ char lines
      staging: wlags49_h2: wl_netdev.h: converts C99 // comments
      staging: wlags49_h2: wl_netdev.h: sorts out spacing issues
      staging: wlags49_h2: sta_h2: fixes spaces-before-tabs problems
      staging: wlags49_h2: sta_h2: fixes malformed #include filename
      staging: wlags49_h2: sta_h2: fixes spaces around parentheses
      staging: wlags49_h2: sta_h2: fixes casting style issue
      staging: wlags49_h2: sta_h2: corrects C99 // comments
      staging: wlags49_h2: wl_profile.h: fixes spacing around parentheses
      staging: wlags49_h2: wl_profile.h: fixes C99 // comment
      staging: wlags49_h2: wl_priv: fixes spacing around parentheses
      staging: wlags49_h2: wl_priv: fixes parentheses styling issues
      staging: wlags49_h2: wl_priv: fixes incorrect #include
      staging: wlags49_h2: wl_priv: fixes case statement styling issues
      staging: wlags49_h2: wl_priv: fixes brace placement
      staging: wlags49_h2: wl_priv: converts indentation to tabs
      staging: wlags49_h2: wl_priv: converts C99 // comments
      staging: wlags49_h2: wl_util: fixes spacing around parentheses
      staging: wlags49_h2: wl_util: converts C99 // comment
      staging: wlags49_h2: wl_util: corrects asterisk placement

John Stultz (3):
      staging: alarm-dev: Drop pre Android 1.0 _OLD ioctls
      staging: alarm-dev: Refactor alarm-dev ioctl code in prep for compat_ioctl
      staging: alarm-dev: Implement compat_ioctl support

Jonathan Cameron (14):
      staging:iio:accel:lis3l02dq remove sw_ring support.
      staging:iio:impedance-analyzer switch from sw_ring to kfifo.
      staging:iio:meter:ade7758 switch from sw_ring to kfifo
      staging:iio: drop sw_ring buffer implementation.
      staging:iio:accel:kxsd9
      iio:accel:kxsd9 move out of staging
      staging:iio:light:tsl2563 drop unnecessary brackets around constants.
      staging:iio:light:tsl2563 clean comments up.
      staging:iio:tsl2563 Simplify exit path on error in read_interrupt_config.
      staging:iio:tsl2563 drop pointless forward declaration
      iio:light:tsl2563 move out of staging
      iio:max1363 remove some functions left after merge
      iio:triggers Protect functions in triggers.h from use when not compiled
      iio:st_sensors fix build when !CONFIG_IIO_TRIGGER

Julia Lawall (1):
      staging: omap-thermal/omap-bandgap.c: adjust duplicate test

Jun Nakajima (1):
      goldfish: add the goldfish virtual bus

Kevin McKinney (95):
      Staging: bcm: Fix all white space issues in nvm.h
      Staging: bcm: Properly format and remove comments as needed in nvm.h
      Staging: bcm: Properly format braces in nvm.h
      Staging: bcm: Enclose complex values in parenthesis in nvm.h
      Staging: bcm: Replace B_UINT32 with u32 in nvm.h
      Staging: bcm: Replace UINT with unsigned int in nvm.h
      Staging: bcm: Replace PUCHAR with u8 * in nmv.h
      Staging: bcm: Remove typedef for _ISO_HEADER and call directly.
      Staging: bcm: Remove typedef for _DSD_HEADER and call directly.
      Staging: bcm: Remove typedef for _FLASH2X_VENDORSPECIFIC_INFO and call directly.
      Staging: bcm: Remove typedef for _VENDOR_SECTION_INFO and call directly.
      Staging: bcm: Remove typedef for _FLASH_2X_CS_INFO and call directly.
      Staging: bcm: Remove typedef for _FLASH_CS_INFO and call directly.
      Staging: bcm: Remove typedef for _FLASH_SECTOR_INFO.
      Staging: bcm: Replace unsigned long long with u64 in Ioctl.h
      Staging: bcm: Remove unnecessary comments in CmHost.h
      Staging: bcm: Fix all white space issues in IPv6ProtocolHdr.h
      Staging: bcm: Properly format and remove comments as needed in IPv6ProtocolHdr.h
      Staging: bcm: Properly format braces in IPv6ProtocolHdr.h
      Staging: bcm: Replace USHORT with unsigned short in IPv6ProtocolHdr.h
      Staging: bcm: Replace ULONG with unsigned long in IPv6ProtocolHdr.h
      Staging: bcm: Replace UCHAR with unsigned char in IPv6ProtocolHdr.h
      Staging: bcm: Replace PVOID with void * in IPv6ProtocolHdr.h
      Staging: bcm: Replace VOID with void in IPv6ProtocolHdr.h
      Staging: bcm: Replace BOOLEAN with bool in IPv6ProtocolHdr.h
      Staging: bcm: Remove typedef for _E_IPADDR_CONTEXT and call directly.
      Staging: bcm: Remove typedef for IPV6IcmpHeaderFormatTag.
      Staging: bcm: Remove typedef for IPV6AuthenticationHeaderFormatTag and call directly.
      Staging: bcm: Remove typedef for IPV6HopByHopOptionsHeaderFormatTag and call directly.
      Staging: bcm: Remove typedef for IPV6DestOptionsHeaderFormatTag and call directly.
      Staging: bcm: Remove typedef for IPV6FragmentHeaderFormatTag and call directly.
      Staging: bcm: Remove typedef for IPV6RoutingHeaderFormatTag and call directly.
      Staging: bcm: Remove typedef for IPV6HeaderFormatTag and call directly.
      Staging: bcm: Fix all white space issues in led_control.h
      Staging: bcm: Properly format comments as needed in led_control.h
      Staging: bcm: Fix warning: "do {} while (0) macros should not be semicolon terminated" in led_control.h
      Staging: bcm: Replace UCHAR with unsigned char in led_control.h
      Staging: bcm: Replace BOOLEAN with bool in led_control.h
      Staging: bcm: Replace UINT with unsigned int in led_control.h
      Staging: bcm: Remove typedef for _LED_INFO_STRUCT and call directly.
      Staging: bcm: Remove typedef for LedStateInfo_t and call directly.
      Staging: bcm: Remove typedef for LedEvents and call directly.
      Staging: bcm: Remove typedef for _LEDColors and call directly.
      Staging: bcm: Remove macro B_ULONG32 in led_control.h.
      Staging: bcm: Fix all white space issues in target_params.h
      Staging: bcm: Properly format comments as needed in target_params.h
      Staging: bcm: Properly format braces in target_params.h
      Staging: bcm: Replace B_UINT32 with u32 in target_params.h
      Staging: bcm: Remove typedef for _TARGET_PARAMS and call directly.
      Staging: bcm: Fix all white space issues in PHSDefines.h
      Staging: bcm: Properly format comments in PHSDefines.h
      Staging: bcm: Properly format braces in PHSDefines.h
      Staging: bcm: Replace B_UINT8 with u8 in PHSDefines.h
      Staging: bcm: Replace B_UINT16 with u16 in PHSDefines.h
      Staging: bcm: Replace ULONG with unsigned long in PHSDefines.h
      Staging: bcm: Replace LONG with long in PHSDefines.h
      Staging: bcm: Remove typedef for _PHS_DEVICE_EXTENSION and call directly.
      Staging: bcm: Remove typedef for _S_SERVICEFLOW_TABLE and call directly.
      Staging: bcm: Remove typedef for _S_SERVICEFLOW_ENTRY and call directly.
      Staging: bcm: Remove typedef for _S_CLASSIFIER_TABLE and call directly.
      Staging: bcm: Remove typedef for _S_CLASSIFIER_ENTRY and call directly.
      Staging: bcm: Remove typedef for _E_CLASSIFIER_ENTRY_CONTEXT and call directly.
      Staging: bcm: Remove typedef for _S_PHS_RULE and call directly.
      Staging: bcm: Remove typedef for ePMU_MODES and call directly.
      Staging: bcm: Remove typedef for eNVM_TYPE and call directly.
      Staging: bcm: Remove typedef for _E_PHS_DSC_ACTION and call directly.
      Staging: bcm: Remove typedef for _LINK_STATE and call directly.
      Staging: bcm: Replace UCHAR with unsigned char in Macros.h
      Staging: bcm: Fix all white space issues in Protocol.h
      Staging: bcm: Properly format comments in Protocol.h
      Staging: bcm: Properly format braces in Protocol.h
      Staging: bcm: Fix warning: "__packed is preferred over __attribute__((packed))" in Protocol.h
      Staging: bcm: Fix issue: "Macros with complex values should be enclosed in parenthesis" in Protocol.h
      Staging: bcm: Replace USHORT with unsigned short in Protocol.h
      Staging: bcm: Replace ULONG with unsigned long in Protocol.h
      Staging: bcm: Replace UCHAR with unsigned char in Protocol.h
      Staging: bcm: Remove typedef for _TCP_HEADER and call directly.
      Staging: bcm: Remove typedef for _E_SERVICEFLOW_CS_SPEC_ and call directly.
      Staging: bcm: Remove typedef for _ETH_CS_ETH2_FRAME and call directly.
      Staging: bcm: Remove typedef for _ETH_CS_802_LLC_SNAP_FRAME and call directly.
      Staging: bcm: Remove typedef for _ETH_CS_802_LLC_FRAME and call directly.
      Staging: bcm: Remove typedef for _ETH_CS_802_Q_FRAME and call directly.
      Staging: bcm: Remove typedef for _S_ETHCS_PKT_INFO and call directly.
      Staging: bcm: Remove typedef for _E_NWPKT_ETHFRAME_TYPE and call directly.
      Staging: bcm: Remove typedef for _E_NWPKT_IPFRAME_TYPE and call directly.
      Staging: bcm: Remove typedef for TransportHeaderT and call directly.
      Staging: bcm: Fix all white space issues in Debug.h
      Staging: bcm: Properly format comments in Debug.h
      Staging: bcm: Properly format braces in Debug.h
      Staging: bcm: Fix warning: "__packed is preferred over __attribute__((packed))" in Debug.h
      Staging: bcm: Fix error: "Macros with complex values should be enclosed in parenthesis" in Debug.h
      Staging: bcm: Replace UINT with unsigned int in Debug.h
      Staging: bcm: Remove typedef for _S_BCM_DEBUG_STATE and call directly.
      Staging: bcm: Change the name of typedef USER_BCM_DBG_STATE to bcm_user_debug_state.
      Staging: bcm: Fix warning: "Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(... to printk(KERN_DEBUG ..."

Kim, Milo (2):
      iio: lp8788_adc: fix a parent device in _probe()
      iio: lp8788_adc: fix parent device in kernel message

Konrad Rzeszutek Wilk (4):
      zcache: Fix compile warnings due to usage of debugfs_create_size_t
      ramster: Fix compile warnings due to usage of debugfs_create_size_t
      zbud: Fix compile warnings due to usage of debugfs_create_size_t
      zcache/zbud: Fix __init mismatch

Kumar Amit Mehta (2):
      staging: wlan-ng: hfa384x.h: fix for error reported by smatch
      staging: comedi: drivers: addi-data: hwdrv_apci3200.c: Add a missing semicolon

Kurt Kanzenbach (4):
      Staging: ft1000-usb: Fix call to obsolete function
      staging: keucr: Replaced c99 comments
      staging: keucr: Removed trailing whitespaces
      staging: keucr: Fix parens/braces

Lars-Peter Clausen (38):
      staging:iio:gyro: Remove stale Makefile entry
      staging:iio:tsl2x7x: Use iio_str_to_fixedpoint instead of open-coding it
      staging:iio:adis16400: Don't pass 0 to ilog2
      staging:iio:adis16400: Fix and cleanup 3db filter setting
      staging:iio:adis16400: Remove unused default_scan_mask
      staging:iio:adis16400: Use adis library
      staging:iio:adis16400: Use triggered buffer setup helper function
      staging:iio:adis16400: Add helper macros for channel declaration
      staging:iio:adis16400: Preallocate transfer message
      staging:iio:adis16400: Remove unit suffix from samplerate attribute
      staging:iio:adis16400: Remove samplerate_available attribute
      staging:iio:adis16400: Code style cleanup
      staging:iio: Move adis16400 out of staging
      iio:adis16400: Increase samplerate precession
      iio:adis16400: Add support for the 52.85 Hz base sampling rate
      iio:adis16400: Expose some debug information in debugfs
      iio:adis16400: Add support for the adis16448
      staging:iio:adis16080: Add device id table entry for the adis16100
      staging:iio:adis16080: Cleanup SPI transfer
      staging:iio:adis16080: be16 cleanups
      staging:iio:adis16080: Remove unnecessary lock
      staging:iio:adis16080: Add scale and offset attributes
      staging:iio:adis16080: Move out of staging
      staging:iio: Remove noop call to __iio_update_buffer
      Partially revert "staging:iio:gyro:adxrs450 make more use of spi_read and spi_write."
      staging:iio:adxrs450: Make transfer buffers __be32
      staging:iio:adxrs450: Perform sign extension for the calibbias register
      staging:iio:adxrs450: Reject out of range calibscale values
      staging:iio:adxrs450: Don't spam the bootlog
      staging:iio:adxrs450: Reflow overlong lines
      staging:iio:adxrs450: Don't split string across multiple lines
      staging:iio:adxrs450: Use usleep_range for the sequential transfer dealy
      staging:iio:adxrs450: Fixup kernel doc comments
      staging:iio:adxrs450: Move header file contents to main file
      staging:iio: Move adxrs450 driver out of staging
      spi: Add helper functions for setting up transfers
      iio: Use spi_sync_transfer()
      staging:iio: Use spi_sync_transfer()

Laurent Navet (2):
      staging: line6: pcm.c fix checkpatch issues
      staging: line6: Use kmemdup rather than duplicating its implementation

Lijo Antony (5):
      Staging: comedi: comedidev.h: fixed a camel case
      Staging: comedi: addi_common.c: checkpatch.pl fixes
      Staging: speakup: buffers.c: checkpatch.pl fixes
      Staging: speakup: keyhelp.c: checkpatch.pl fixes
      Staging: speakup: kobjects.c: checkpatch.pl fixes

Malcolm Priestley (15):
      staging: vt6656: Remove QWORD from source and replace with u64.
      staging: vt6656: create new structure names to remove typedefs.
      staging: vt6656: card/main_usb/device use new structure names
      staging: vt6656: change baseband/mac/wcmd/wctl to new structures.
      staging: vt6656: change wmgr to new structures
      staging: vt6656: iwctl/key/rf use new structures.
      staging: vt6656: channel/control/firmware/int/usbpipe to new structures
      staging: vt6656: change bssdb/rxtx/wpa2 to new structures
      staging: vt6656: datarate/dpc/hostap/power use new structures.
      staging: vt6656: staging: vt6656 change remaining to vnt_mgmt and remove typedef.
      staging: vt6656: cleanup struct vnt_private
      staging: vt6656: cleanup vnt_manger.
      staging: vt6656: revert : 64 bit- Correctly address void structure.
      staging: vt6656: Revert: 64bit fixes: dpc.c incorrect addressing of void structure.
      staging: vt6656: Fix URB submitted while active warning.

Manuel Stahl (1):
      iio: gyro: Add itg3200

Marc Dietrich (3):
      staging: nvec: move toggle global event reporting to its own function
      staging: nvec: fix mouse suspend/resume calls
      staging: nvec: cleanup the string mess

Marek Vasut (4):
      iio: mxs: Remove unused struct mxs_lradc_chan
      iio: mxs: Implement support for touchscreen
      iio: mxs: Add MX23 support into the IIO driver
      ARM: mxs: Add OF props for MX23 LRADC

Mark Einon (9):
      staging: et131x: Replace rxdma csr register magic numbers with defines
      staging: et131x: Use register defines instead of magic numbers
      staging: et131x: Only configure regs if link state changes
      staging: et131x: Fix endian bugs in et131x_get_regs()
      staging: et131x: Trivial camel case fixes
      staging: et131x: Modify block comments to fit with networking style
      staging: et131x: Fix all sparse warnings
      staging: et131x: Remove assignment of skb->dev
      staging: et131x: Update TODO list

Masanari Iida (3):
      staging: vt6655: Fix typo in vt6655 driver
      staging: vme: Fix URL in Kconfig
      staging: Add angle bracket before and after the URL

Minchan Kim (6):
      staging: zsmalloc: Fix TLB coherency and build problem
      zram: Fix deadlock bug in partial read/write
      zram: force disksize setting before using zram
      zram: give up lazy initialization of zram metadata
      zram: fix warning of print format
      zram: get rid of lockdep warning

Omar Ramirez Luna (5):
      staging: tidspbridge: fix potential array out of bounds write
      staging: tidspbridge: fix memory corruption on long string names
      staging: tidspbridge: fix uninitialized variable sym_name
      staging: tidspbridge: use scm functions to set boot address and mode
      staging: tidspbridge: remove unused code to handle iva_img

Ondrej Zary (2):
      staging: ft1000: unify struct ft1000_info between USB and PCMCIA drivers
      staging: ft1000: rename struct ft1000_device to ft1000_usb

Patrik Karlin (3):
      staging: rtl8192u: fixed some coding style issues in r8192U_core.c
      staging: rtl8192u: removed some non used else's
      staging: rtl8192u: fixed coding style issues in r8192U_core.c

Peter Huewe (82):
      staging/csr: Fix dereference before check
      staging/comedi: Add macro for registering a comedi PCMCIA driver
      staging/comedi/ni_daq_dio24: Convert to module_comedi_pcmcia_driver
      staging/comedi/ni_mio_cs: Convert to module_comedi_pcmcia_driver
      staging/comedi/quatech_daqp_cs: Convert to module_comedi_pcmcia_driver
      staging/comedi/cb_das16_cs: Convert to module_comedi_pcmcia_driver
      staging/comedi/das08_cs: Convert to module_comedi_pcmcia_driver
      staging/comedi/ni_daq_700: Convert to module_comedi_pcmcia_driver
      staging/comedi/ni_labpc_cs: Convert to module_comedi_pcmcia_driver
      staging/comedi: Use bool initializations
      staging/comedi: Add pci_driver.name to skel driver
      staging/comedi: remove workaround for !pci_driver.name
      staging/comedi: use comedi_usb_driver_(un)register for init/deinit
      staging/comedi: Move comedi_pci_auto_unconfig to drivers.c
      staging/comedi: Use comedi_pci_auto_unconfig directly for pci_driver.remove
      staging/iio: Use correct argument for sizeof
      staging/comedi/adl_pci8164: Don't assign string
      staging/csr: Use kmemdup rather than duplicating its implementation
      staging/omapdrm: Use kmemdup rather than duplicating its implementation
      staging/xgifb: Remove unused variables and dead assignments
      staging/xgifb: Remove unused variable
      staging/xgifb: Remove unused variable and dead assignment
      staging/xgifb: Remove unused variables
      staging/xgifb: Remove redundant if statement
      staging/xgifb: remove unused variables
      staging/xgifb: Simplify XGI_GetRatePtrCRT2
      staging/xgifb: Remove always false comparisons
      staging/xgifb: mttr must be (signed) int
      staging/xgifb: Fix return of uninitialized variable
      staging/xgifb: Simplify XGI_SetSeqRegs
      staging/xgifb: rewrite XGIfb_get_cmap_len
      staging/xgifb: remove unnecessary temp variable in XGIfb_mode_rate_to_ddata
      staging/xgifb: Remove unnecessary bitshifts in XGI_SetCRT1ModeRegs
      staging/xgifb: Consolidate XGI_EnableChISLCD and XGI_DisableChISLCD
      staging/xgifb: Simplify XGISetModeNew
      staging/xgifb: Replace XGI340_CR6B table with simple if/else
      staging/xgifb: Move duplicated code for dram to helper function
      staging/xgifb: Don't write the same values x times
      staging/xgifb: Consolidate if/else for 'identical' branches
      staging/xgifb: Consolidate if branches with similar conditions
      staging/xgifb: Remove unused variable
      staging/xgifb: Remove unused values in XGI340_cr41 and XGI27_cr41
      staging/xgifb: Remove unused values in XG27_SR13 and XGI340_SR13
      staging/xgifb: Remove unused entries in XGI340New_MCLKData and XGI27New_MCLKData
      staging/xgifb: Remove unused values in XGI340_ECLKData
      staging/xgifb: Remove unneeded conditional assignment
      staging/xgifb: Remove always false if statement
      staging/vt6656: Fix sparse warning constant 0xffffffff00000000U is so big it is unsigned long
      staging/goldfish: Use %zx for printing size_t variables
      staging/goldfish: Add MTD dependency to KCONFIG
      staging/comedi: Fix undefined array subscript
      staging/wlan-ng: Fix 'Branch condition evaluates to a garbage value' in p80211netdev.c
      staging/rtl8192u/ieee80211: Fix buffer overflow in ieee80211_softmac_wx.c
      staging/comedi: Use && instead of & for logical comparision
      staging/comedi: Remove if(); statement without effect
      staging/panel: Mark local functions/structs static and add const if applicable (fix sparse warnings)
      staging/ozwpan: Fix NULL vs zero in ozpd.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozusbsvc1.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozeltbuf.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozproto.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozcdev.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozusbsvc.c (sparse warning)
      staging/ozwpan: Fix NULL vs zero in ozhcd.c (sparse warning)
      staging/rtl8187se: Remove code without effect
      staging/rtl8187se: Remove code without effect
      staging/rtl8187se: Remove code without effect
      staging/rtl8187se: Remove unused/unnecessary variables
      staging/rtl8187se: Reuse ReadBBPortUchar to avoid duplicated code
      staging/rtl8187se: Remove temporary variable for return value
      staging/rtl8187se: Remove unused functions PlatformIORead2Byte / PlatformIORead4Byte
      staging/rtl8187se: Remove duplicated code by using an offset
      staging/rtl8187se: Mark functions as static to silence sparse
      staging/xgifb: Consolidate if/else if with identical code branches
      staging/xgifb: Remove unnecessary casts
      staging/xgifb: Remove code without effect
      staging/xgifb: Consolidate return paths
      staging/xgifb: Remove duplicated code in loops.
      staging/usbip: Mark local functions as static (fix sparse warnings)
      staging/ozwpan: Add missing header includes
      staging/ozwpan: Mark local functions as static (fix sparse warnings)
      staging/ozwpan: Remove empty and unused function oz_cdev_heartbeat
      staging/ozwpan: Mark read only parameters and structs as const

Peter Hurley (18):
      staging/fwserial: Remove bandwidth limit logic
      staging/fwserial: Refer to fw_device as "node"
      staging/fwserial: Simplify max payload calculation
      staging/fwserial: Fold constant MAX_ASYNC_PAYLOAD
      staging/fwserial: Assume firmware is OHCI-complaint
      staging/fwserial: Drop suggestion for helper fn integration
      staging/fwserial: Only reset port status for attached peers
      staging/fwserial: Release port regardless of unplug response code
      staging/fwserial: Fix sparse build warnings
      staging/fwserial: Create loop device the 'tty' way
      staging/fwserial: Cleanup /proc/tty/driver/ file
      staging/fwserial: Factor unstable stats/debug/status info to debugfs
      staging/fwserial: Don't use deprecated alloc_tty_driver()
      staging/fwserial: Remove reference to removed constant
      staging/fwserial: add diagnostic for buffer overflow
      staging/fwserial: Fix endian issue in unit directory
      staging/fwserial: Annotate rcu pointers with __rcu
      staging/fwserial: Fix compiler warning

Peter Meerwald (4):
      iio: cleanup buffer setup code in max1363 driver
      iio: max1363 comment and whitespace fixes
      iio: fix Kconfig for max1363
      iio: tweak language in industrialio-trigger comments

Przemo Firszt (7):
      rtl8712: code clean up
      rtl8712: remove unused macros from rtl8712/wifi.h
      rtl8712: replace printk with better solutions
      rtl8712: replace min with min_t
      rtl8712: remove unused macros
      rtl8712: remove all NDIS_* definitions and use rndis.h instead
      rtl8712: remove unused definitions from ethernet.h

Robert Berger (1):
      staging/zache checkpatch ERROR: spaces prohibited around that

Rupesh Gujare (2):
      staging:ozwpan: Change email address.
      staging:ozwpan: Fix following warning.

Ryo Munakata (1):
      Staging: zcache: remove unnecessary braces in zcache-main.c

Samuel Thibault (2):
      staging: speakup: Prefix externally-visible symbols
      staging: speakup: Turn some symbols static

Sebastian Hahn (5):
      staging/rtl8192u: cleanfile run
      staging/rtl8192u: indent with tabs, not spaces
      staging/rtl8192u: don't init globals to 0 or NULL
      staging/rtl8192u: use same indent for switch and case
      staging/rtl8192u: do not init statics to 0

Sebastian Wankerl (2):
      wlan-ng/prism2mgmt.c: added parantheses to macro
      wlan-ng/prism2mgmt.c: formated too long lines

Seth Jennings (2):
      staging: zsmalloc: make CLASS_DELTA relative to PAGE_SIZE
      staging: zsmalloc: remove unused pool name

Stefan Hajnoczi (9):
      staging: line6: drop ToneportSourceInfo CamelCase name
      staging: line6: wrap lines to 80 chars in pod.c
      staging: line6: wrap comment to 80 chars in driver.c
      staging: line6: use pr_err() instead of printk(KERN_ERR, ...)
      staging: line6: rename MidiBuffer to avoid CamelCase
      staging: line6: avoid CamelCase POD_* enums in pod.c
      staging: line6: drop CONFIG_LINE6_USB_DUMP_PCM
      staging: line6: clean up line6_pod_process_message()
      staging: line6: clean up line6_variax_process_message()

Tommi Rantala (2):
      staging: dgrp: use correct release op for /proc/dgrp/info
      staging: dgrp: prefix function names with dgrp_ in dgrp_specproc.c

YAMANE Toshiaki (7):
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_wx.c
      staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/dot11d.c

 Documentation/ABI/testing/sysfs-bus-iio-mpu6050    |   13 +
 .../bindings/staging/iio/adc/mxs-lradc.txt         |    6 +
 MAINTAINERS                                        |    3 +-
 arch/arm/boot/dts/imx23.dtsi                       |    2 +
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    2 +-
 drivers/extcon/extcon-adc-jack.c                   |    3 +-
 drivers/iio/accel/Kconfig                          |   38 +
 drivers/iio/accel/Makefile                         |    9 +
 drivers/iio/accel/hid-sensor-accel-3d.c            |    3 +-
 drivers/{staging => }/iio/accel/kxsd9.c            |   16 +-
 drivers/iio/accel/st_accel.h                       |   47 +
 drivers/iio/accel/st_accel_buffer.c                |  114 +
 drivers/iio/accel/st_accel_core.c                  |  500 ++++
 drivers/iio/accel/st_accel_i2c.c                   |   86 +
 drivers/iio/accel/st_accel_spi.c                   |   85 +
 drivers/iio/adc/Kconfig                            |    4 +-
 drivers/iio/adc/lp8788_adc.c                       |   18 +-
 drivers/iio/adc/max1363.c                          |  167 +-
 drivers/iio/buffer_cb.c                            |    4 +-
 drivers/iio/common/Kconfig                         |    1 +
 drivers/iio/common/Makefile                        |    1 +
 .../iio/common/hid-sensors/hid-sensor-attributes.c |   11 +-
 .../iio/common/hid-sensors/hid-sensor-attributes.h |   57 -
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |    5 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.h    |    2 +-
 drivers/iio/common/st_sensors/Kconfig              |   14 +
 drivers/iio/common/st_sensors/Makefile             |   10 +
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |  116 +
 drivers/iio/common/st_sensors/st_sensors_core.c    |  446 ++++
 drivers/iio/common/st_sensors/st_sensors_i2c.c     |   81 +
 drivers/iio/common/st_sensors/st_sensors_spi.c     |  128 +
 drivers/iio/common/st_sensors/st_sensors_trigger.c |   77 +
 drivers/iio/dac/ad5360.c                           |    7 +-
 drivers/iio/dac/ad5421.c                           |    7 +-
 drivers/iio/dac/ad5504.c                           |    6 +-
 drivers/iio/dac/ad5686.c                           |    7 +-
 drivers/iio/dac/ad5755.c                           |    7 +-
 drivers/iio/dac/ad5764.c                           |    7 +-
 drivers/iio/dac/ad5791.c                           |    6 +-
 drivers/iio/frequency/ad9523.c                     |   14 +-
 drivers/iio/gyro/Kconfig                           |   55 +
 drivers/iio/gyro/Makefile                          |   14 +
 .../gyro/adis16080_core.c => iio/gyro/adis16080.c} |  154 +-
 .../gyro/adxrs450_core.c => iio/gyro/adxrs450.c}   |  202 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |    3 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  156 ++
 drivers/iio/gyro/itg3200_core.c                    |  401 +++
 drivers/iio/gyro/st_gyro.h                         |   45 +
 drivers/iio/gyro/st_gyro_buffer.c                  |  114 +
 drivers/iio/gyro/st_gyro_core.c                    |  368 +++
 drivers/iio/gyro/st_gyro_i2c.c                     |   84 +
 drivers/iio/gyro/st_gyro_spi.c                     |   83 +
 drivers/iio/imu/Kconfig                            |   13 +
 drivers/iio/imu/Makefile                           |    5 +
 drivers/{staging => }/iio/imu/adis16400.h          |  141 +-
 drivers/iio/imu/adis16400_buffer.c                 |   96 +
 drivers/iio/imu/adis16400_core.c                   |  965 ++++++++
 drivers/iio/imu/inv_mpu6050/Kconfig                |   13 +
 drivers/iio/imu/inv_mpu6050/Makefile               |    6 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  795 ++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |  246 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |  196 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |  155 ++
 drivers/iio/industrialio-trigger.c                 |   12 +-
 drivers/iio/inkern.c                               |   53 +-
 drivers/iio/kfifo_buf.c                            |    1 -
 drivers/iio/light/Kconfig                          |   10 +
 drivers/iio/light/Makefile                         |    1 +
 drivers/iio/light/hid-sensor-als.c                 |    3 +-
 drivers/{staging => }/iio/light/tsl2563.c          |   96 +-
 drivers/iio/magnetometer/Kconfig                   |   30 +
 drivers/iio/magnetometer/Makefile                  |    7 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    3 +-
 drivers/iio/magnetometer/st_magn.h                 |   45 +
 drivers/iio/magnetometer/st_magn_buffer.c          |   98 +
 drivers/iio/magnetometer/st_magn_core.c            |  400 +++
 drivers/iio/magnetometer/st_magn_i2c.c             |   80 +
 drivers/iio/magnetometer/st_magn_spi.c             |   79 +
 drivers/platform/Kconfig                           |    4 +
 drivers/platform/Makefile                          |    1 +
 drivers/platform/goldfish/Kconfig                  |    5 +
 drivers/platform/goldfish/Makefile                 |    5 +
 drivers/platform/goldfish/goldfish_pipe.c          |  612 +++++
 drivers/platform/goldfish/pdev_bus.c               |  240 ++
 drivers/power/generic-adc-battery.c                |    4 +-
 drivers/power/lp8788-charger.c                     |    8 +-
 drivers/rtc/Kconfig                                |   16 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-hid-sensor-time.c                  |  292 +++
 drivers/staging/Kconfig                            |    8 +-
 drivers/staging/Makefile                           |    4 +-
 drivers/staging/android/Kconfig                    |   29 +-
 drivers/staging/android/alarm-dev.c                |  277 ++-
 drivers/staging/android/android_alarm.h            |   19 +
 drivers/staging/android/binder.c                   |    6 +-
 drivers/staging/android/binder.h                   |    4 +-
 drivers/staging/asus_oled/asus_oled.c              |   15 +-
 drivers/staging/bcm/Adapter.h                      |   20 +-
 drivers/staging/bcm/Bcmchar.c                      |   14 +-
 drivers/staging/bcm/CmHost.c                       |    6 +-
 drivers/staging/bcm/CmHost.h                       |   12 +-
 drivers/staging/bcm/Debug.h                        |  356 ++-
 drivers/staging/bcm/IPv6Protocol.c                 |   34 +-
 drivers/staging/bcm/IPv6ProtocolHdr.h              |  149 +-
 drivers/staging/bcm/InterfaceDld.c                 |    6 +-
 drivers/staging/bcm/InterfaceInit.c                |   14 +-
 drivers/staging/bcm/Ioctl.h                        |    6 +-
 drivers/staging/bcm/Macros.h                       |   25 +-
 drivers/staging/bcm/Misc.c                         |   10 +-
 drivers/staging/bcm/PHSDefines.h                   |  200 +-
 drivers/staging/bcm/PHSModule.c                    |  160 +-
 drivers/staging/bcm/PHSModule.h                    |   14 +-
 drivers/staging/bcm/Protocol.h                     |  177 +-
 drivers/staging/bcm/Prototypes.h                   |    6 +-
 drivers/staging/bcm/Qos.c                          |   46 +-
 drivers/staging/bcm/hostmibs.c                     |   12 +-
 drivers/staging/bcm/led_control.c                  |    8 +-
 drivers/staging/bcm/led_control.h                  |  138 +-
 drivers/staging/bcm/nvm.c                          |   87 +-
 drivers/staging/bcm/nvm.h                          |  665 ++---
 drivers/staging/bcm/target_params.h                |  128 +-
 drivers/staging/bcm/vendorspecificextn.c           |    2 +-
 drivers/staging/bcm/vendorspecificextn.h           |    2 +-
 drivers/staging/ced1401/ced_ioc.c                  |   18 +-
 drivers/staging/ced1401/usb1401.c                  |   14 +-
 drivers/staging/ced1401/usb1401.h                  |    2 +-
 drivers/staging/comedi/Kconfig                     |   46 +-
 drivers/staging/comedi/Makefile                    |   19 +-
 drivers/staging/comedi/comedi.h                    |   12 +-
 drivers/staging/comedi/comedi_buf.c                |  415 ++++
 drivers/staging/comedi/comedi_compat32.c           |    4 -
 drivers/staging/comedi/comedi_fops.c               | 1061 ++++----
 drivers/staging/comedi/comedi_internal.h           |   33 +-
 drivers/staging/comedi/comedi_pci.c                |  140 ++
 drivers/staging/comedi/comedi_pcmcia.c             |  160 ++
 drivers/staging/comedi/comedi_usb.c                |  108 +
 drivers/staging/comedi/comedidev.h                 |  370 ++-
 drivers/staging/comedi/drivers.c                   |  859 ++-----
 drivers/staging/comedi/drivers/8255_pci.c          |    9 +-
 drivers/staging/comedi/drivers/Makefile            |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   26 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |  807 ------
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |  263 --
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |  589 +----
 drivers/staging/comedi/drivers/addi_apci_035.c     |    9 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   10 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    9 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |  114 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    9 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |  257 +-
 drivers/staging/comedi/drivers/addi_apci_1710.c    |    9 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |  282 ++-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |  187 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    9 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    9 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |  482 +++-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    9 +-
 drivers/staging/comedi/drivers/addi_watchdog.c     |  172 ++
 drivers/staging/comedi/drivers/addi_watchdog.h     |   10 +
 drivers/staging/comedi/drivers/adl_pci6208.c       |    9 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |   17 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |   39 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   12 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   13 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    8 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    9 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   12 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |   20 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    8 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |    9 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |    8 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   12 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  132 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   11 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   12 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    9 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   12 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    9 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    5 +-
 drivers/staging/comedi/drivers/comedi_test.c       |   75 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    9 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   14 +-
 drivers/staging/comedi/drivers/das08.c             |  358 +--
 drivers/staging/comedi/drivers/das08.h             |    2 -
 drivers/staging/comedi/drivers/das08_cs.c          |  152 +-
 drivers/staging/comedi/drivers/das08_isa.c         |  217 ++
 drivers/staging/comedi/drivers/das08_pci.c         |  121 +
 drivers/staging/comedi/drivers/das16.c             |    2 +
 drivers/staging/comedi/drivers/dt3000.c            |   11 +-
 drivers/staging/comedi/drivers/dt9812.c            |   30 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   11 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   11 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   13 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   15 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    9 +-
 drivers/staging/comedi/drivers/me4000.c            |   14 +-
 drivers/staging/comedi/drivers/me_daq.c            |    9 +-
 drivers/staging/comedi/drivers/mite.c              |    5 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    9 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |   10 +-
 drivers/staging/comedi/drivers/ni_660x.c           |   10 +-
 drivers/staging/comedi/drivers/ni_670x.c           |    9 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |  119 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |  303 +--
 drivers/staging/comedi/drivers/ni_labpc.c          |   55 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c       |  257 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    4 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c         |  399 +--
 drivers/staging/comedi/drivers/ni_pcidio.c         |    9 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   11 +-
 drivers/staging/comedi/drivers/ni_tio.c            |    2 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |    1 +
 drivers/staging/comedi/drivers/pcl818.c            |   19 +-
 drivers/staging/comedi/drivers/pcm_common.c        |   63 -
 drivers/staging/comedi/drivers/pcm_common.h        |    8 -
 drivers/staging/comedi/drivers/pcmda12.c           |    3 -
 drivers/staging/comedi/drivers/pcmmio.c            |   62 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   72 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |  589 ++---
 drivers/staging/comedi/drivers/rtd520.c            |   10 +-
 drivers/staging/comedi/drivers/s626.c              |    8 +-
 drivers/staging/comedi/drivers/skel.c              |   12 +-
 drivers/staging/comedi/drivers/unioxx5.c           |    6 +-
 drivers/staging/comedi/drivers/usbdux.c            |   29 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    8 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   33 +-
 drivers/staging/comedi/drivers/vmk80xx.c           | 1272 +++-------
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    8 +-
 drivers/staging/comedi/proc.c                      |    9 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |    5 +-
 drivers/staging/csr/drv.c                          |    6 +-
 drivers/staging/csr/sme_sys.c                      |   41 +-
 drivers/staging/csr/unifi_sme.c                    |    1 -
 drivers/staging/cxt1e1/linux.c                     |    4 +-
 drivers/staging/dgrp/dgrp_specproc.c               |   81 +-
 drivers/staging/echo/echo.c                        |   42 +-
 drivers/staging/et131x/README                      |    4 +
 drivers/staging/et131x/et131x.c                    |  793 +++---
 drivers/staging/et131x/et131x.h                    |   96 +-
 drivers/staging/frontier/alphatrack.c              |   51 +-
 drivers/staging/frontier/tranzport.c               |   26 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   33 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   21 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |   10 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |  153 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  110 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  166 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   39 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   84 +-
 drivers/staging/ft1000/ft1000.h                    |   35 +
 drivers/staging/fwserial/TODO                      |   15 -
 drivers/staging/fwserial/fwserial.c                |  361 +--
 drivers/staging/fwserial/fwserial.h                |   25 +-
 drivers/staging/gdm72xx/gdm_sdio.c                 |    8 +-
 drivers/staging/gdm72xx/sdio_boot.c                |    9 +-
 drivers/staging/gdm72xx/usb_boot.c                 |    8 +-
 drivers/staging/goldfish/Kconfig                   |   13 +
 drivers/staging/goldfish/Makefile                  |    6 +
 drivers/staging/goldfish/README                    |   12 +
 drivers/staging/goldfish/goldfish_audio.c          |  363 +++
 drivers/staging/goldfish/goldfish_nand.c           |  444 ++++
 drivers/staging/goldfish/goldfish_nand_reg.h       |   72 +
 drivers/staging/iio/Kconfig                        |   14 -
 drivers/staging/iio/Makefile                       |    3 -
 drivers/staging/iio/accel/Kconfig                  |   30 +-
 drivers/staging/iio/accel/Makefile                 |    2 -
 drivers/staging/iio/accel/lis3l02dq.h              |    8 -
 drivers/staging/iio/accel/lis3l02dq_core.c         |   18 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |   12 +-
 drivers/staging/iio/accel/sca3000_core.c           |   13 +-
 drivers/staging/iio/accel/sca3000_ring.c           |    6 +-
 drivers/staging/iio/adc/Kconfig                    |    4 +-
 drivers/staging/iio/adc/ad7280a.c                  |    6 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  525 +++-
 drivers/staging/iio/frequency/ad5930.c             |    5 +-
 drivers/staging/iio/frequency/ad9850.c             |    5 +-
 drivers/staging/iio/frequency/ad9852.c             |    5 +-
 drivers/staging/iio/gyro/Kconfig                   |   17 -
 drivers/staging/iio/gyro/Makefile                  |    9 -
 drivers/staging/iio/gyro/adxrs450.h                |   62 -
 drivers/staging/iio/iio_hwmon.c                    |   83 +-
 drivers/staging/iio/iio_simple_dummy.c             |    4 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c      |    2 +-
 drivers/staging/iio/impedance-analyzer/Kconfig     |    2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |    8 +-
 drivers/staging/iio/imu/Kconfig                    |   17 -
 drivers/staging/iio/imu/Makefile                   |    7 -
 drivers/staging/iio/imu/adis16400_core.c           | 1320 ----------
 drivers/staging/iio/imu/adis16400_ring.c           |  204 --
 drivers/staging/iio/imu/adis16400_trigger.c        |   74 -
 drivers/staging/iio/light/Kconfig                  |   10 -
 drivers/staging/iio/light/Makefile                 |    1 -
 drivers/staging/iio/light/tsl2x7x_core.c           |   78 +-
 drivers/staging/iio/meter/Kconfig                  |    2 +-
 drivers/staging/iio/meter/ade7753.c                |    6 +-
 drivers/staging/iio/meter/ade7754.c                |    5 +-
 drivers/staging/iio/meter/ade7758_core.c           |   28 +-
 drivers/staging/iio/meter/ade7758_ring.c           |   12 +-
 drivers/staging/iio/meter/ade7759.c                |    5 +-
 drivers/staging/iio/meter/ade7854-spi.c            |   44 +-
 drivers/staging/iio/resolver/ad2s1210.c            |    5 +-
 drivers/staging/iio/ring_sw.c                      |  366 ---
 drivers/staging/iio/ring_sw.h                      |   30 -
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |    3 -
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    2 +-
 drivers/staging/keucr/usb.c                        |  188 +-
 drivers/staging/line6/Kconfig                      |   10 -
 drivers/staging/line6/capture.c                    |   10 -
 drivers/staging/line6/driver.c                     |   86 +-
 drivers/staging/line6/driver.h                     |   13 +-
 drivers/staging/line6/midi.c                       |    2 +-
 drivers/staging/line6/midi.h                       |    4 +-
 drivers/staging/line6/midibuf.c                    |   25 +-
 drivers/staging/line6/midibuf.h                    |   22 +-
 drivers/staging/line6/pcm.c                        |   36 +-
 drivers/staging/line6/playback.c                   |    9 -
 drivers/staging/line6/pod.c                        |  105 +-
 drivers/staging/line6/toneport.c                   |    6 +-
 drivers/staging/line6/variax.c                     |   14 -
 drivers/staging/nvec/nvec.c                        |   82 +-
 drivers/staging/nvec/nvec.h                        |    5 +-
 drivers/staging/nvec/nvec_kbd.c                    |   42 +-
 drivers/staging/nvec/nvec_power.c                  |    8 +-
 drivers/staging/nvec/nvec_ps2.c                    |   37 +-
 drivers/staging/omap-thermal/omap-bandgap.c        |    2 -
 drivers/staging/omap-thermal/omap-thermal-common.c |    4 +-
 drivers/staging/omapdrm/omap_connector.c           |    4 +-
 drivers/staging/omapdrm/omap_crtc.c                |    5 +-
 drivers/staging/omapdrm/omap_dmm_priv.h            |    5 +
 drivers/staging/omapdrm/omap_dmm_tiler.c           |  172 +-
 drivers/staging/omapdrm/omap_drv.c                 |   18 +-
 drivers/staging/omapdrm/omap_drv.h                 |    4 +
 drivers/staging/omapdrm/omap_encoder.c             |    4 +-
 drivers/staging/omapdrm/omap_fb.c                  |    1 -
 drivers/staging/omapdrm/omap_fbdev.c               |    4 +-
 drivers/staging/omapdrm/omap_gem.c                 |   42 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c          |    6 +-
 drivers/staging/omapdrm/omap_plane.c               |    4 +-
 drivers/staging/omapdrm/tcm.h                      |    2 +
 drivers/staging/ozwpan/TODO                        |    3 +-
 drivers/staging/ozwpan/ozcdev.c                    |   52 +-
 drivers/staging/ozwpan/ozcdev.h                    |    1 -
 drivers/staging/ozwpan/ozeltbuf.c                  |   18 +-
 drivers/staging/ozwpan/ozevent.c                   |    8 +-
 drivers/staging/ozwpan/ozhcd.c                     |  152 +-
 drivers/staging/ozwpan/ozmain.c                    |    2 +-
 drivers/staging/ozwpan/ozpd.c                      |   88 +-
 drivers/staging/ozwpan/ozpd.h                      |    4 +-
 drivers/staging/ozwpan/ozproto.c                   |   84 +-
 drivers/staging/ozwpan/ozproto.h                   |    2 +-
 drivers/staging/ozwpan/ozusbif.h                   |    8 +-
 drivers/staging/ozwpan/ozusbsvc.c                  |   22 +-
 drivers/staging/ozwpan/ozusbsvc1.c                 |   26 +-
 drivers/staging/panel/panel.c                      |   31 +-
 drivers/staging/ramster/Kconfig                    |   31 -
 drivers/staging/ramster/Makefile                   |    6 -
 drivers/staging/ramster/tmem.c                     |  894 -------
 drivers/staging/ramster/tmem.h                     |  259 --
 drivers/staging/ramster/zcache-main.c              | 1820 --------------
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |   71 +-
 .../staging/rtl8187se/ieee80211/ieee80211_module.c |    4 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    6 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  408 ++-
 drivers/staging/rtl8187se/r8185b_init.c            |  301 +--
 drivers/staging/rtl8192u/changes                   |    1 -
 drivers/staging/rtl8192u/ieee80211/Makefile        |    1 -
 drivers/staging/rtl8192u/ieee80211/aes.c           |    3 +-
 drivers/staging/rtl8192u/ieee80211/arc4.c          |    2 +-
 drivers/staging/rtl8192u/ieee80211/crypto_compat.h |    2 -
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |  102 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    8 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  394 +--
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |  280 +--
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |   31 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |   54 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/internal.h      |    1 -
 drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h    |    6 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |   63 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h    |   13 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |  124 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h   |   83 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h    |    3 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |   18 +-
 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |   93 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
 drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |   13 +-
 drivers/staging/rtl8192u/r8192U.h                  |  299 ++-
 drivers/staging/rtl8192u/r8192U_core.c             |  589 +++--
 drivers/staging/rtl8192u/r8192U_dm.c               |  197 +-
 drivers/staging/rtl8192u/r8192U_dm.h               |   24 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |   16 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   37 +-
 drivers/staging/rtl8192u/r819xU_HTGen.h            |    1 -
 drivers/staging/rtl8192u/r819xU_HTType.h           |    9 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |   38 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |   44 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |  109 +-
 drivers/staging/rtl8192u/r819xU_firmware.h         |    1 -
 drivers/staging/rtl8192u/r819xU_phy.c              |  127 +-
 drivers/staging/rtl8192u/r819xU_phyreg.h           | 1044 ++++----
 drivers/staging/rtl8712/ethernet.h                 |    7 -
 drivers/staging/rtl8712/hal_init.c                 |   17 +-
 drivers/staging/rtl8712/ieee80211.h                |    2 +-
 drivers/staging/rtl8712/mlme_linux.c               |    2 -
 drivers/staging/rtl8712/os_intfs.c                 |    3 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |   14 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |    1 -
 drivers/staging/rtl8712/rtl871x_cmd.h              |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   66 +-
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c        |  181 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |    2 -
 drivers/staging/rtl8712/rtl871x_mlme.c             |    9 +-
 drivers/staging/rtl8712/rtl871x_mp.h               |   56 -
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         |  393 +--
 drivers/staging/rtl8712/rtl871x_security.h         |    6 +-
 drivers/staging/rtl8712/sta_info.h                 |    2 +-
 drivers/staging/rtl8712/usb_intf.c                 |   33 +-
 drivers/staging/rtl8712/usb_ops_linux.c            |   15 +-
 drivers/staging/rtl8712/wifi.h                     |  171 +-
 drivers/staging/rtl8712/xmit_linux.c               |    3 +-
 drivers/staging/sb105x/sb_mp_register.h            |    2 +-
 drivers/staging/sb105x/sb_pci_mp.c                 |   18 +-
 drivers/staging/sbe-2t3e3/dc.c                     |    9 +-
 drivers/staging/sbe-2t3e3/module.c                 |    7 +-
 drivers/staging/sep/sep_crypto.c                   |   10 +-
 drivers/staging/sep/sep_main.c                     |   44 +-
 drivers/staging/slicoss/slic.h                     |  504 ++--
 drivers/staging/slicoss/slichw.h                   |    6 +-
 drivers/staging/slicoss/slicoss.c                  |   35 +-
 drivers/staging/speakup/Kconfig                    |    2 +-
 drivers/staging/speakup/buffers.c                  |   14 +-
 drivers/staging/speakup/fakekey.c                  |    2 +-
 drivers/staging/speakup/i18n.c                     |   12 +-
 drivers/staging/speakup/i18n.h                     |   12 +-
 drivers/staging/speakup/keyhelp.c                  |   39 +-
 drivers/staging/speakup/kobjects.c                 |   84 +-
 drivers/staging/speakup/main.c                     |  370 +--
 drivers/staging/speakup/selection.c                |   15 +-
 drivers/staging/speakup/serialio.c                 |    6 +-
 drivers/staging/speakup/speakup.h                  |   72 +-
 drivers/staging/speakup/speakup_acntpc.c           |    6 +-
 drivers/staging/speakup/speakup_acntsa.c           |    2 +-
 drivers/staging/speakup/speakup_apollo.c           |    8 +-
 drivers/staging/speakup/speakup_audptr.c           |    2 +-
 drivers/staging/speakup/speakup_bns.c              |    2 +-
 drivers/staging/speakup/speakup_decext.c           |    6 +-
 drivers/staging/speakup/speakup_decpc.c            |    4 +-
 drivers/staging/speakup/speakup_dectlk.c           |    6 +-
 drivers/staging/speakup/speakup_dtlk.c             |    4 +-
 drivers/staging/speakup/speakup_dummy.c            |    2 +-
 drivers/staging/speakup/speakup_keypc.c            |    6 +-
 drivers/staging/speakup/speakup_ltlk.c             |    2 +-
 drivers/staging/speakup/speakup_spkout.c           |    2 +-
 drivers/staging/speakup/speakup_txprt.c            |    2 +-
 drivers/staging/speakup/spk_priv.h                 |    8 +-
 drivers/staging/speakup/synth.c                    |   38 +-
 drivers/staging/speakup/thread.c                   |    4 +-
 drivers/staging/speakup/varhandlers.c              |   66 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |   18 +-
 drivers/staging/tidspbridge/core/msg_sm.c          |    3 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   34 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |    2 -
 drivers/staging/tidspbridge/pmgr/cod.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   11 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    3 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    1 -
 drivers/staging/tidspbridge/rmgr/nldr.c            |    6 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   12 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   23 +-
 drivers/staging/usbip/Kconfig                      |    2 +-
 drivers/staging/usbip/stub_dev.c                   |   42 +-
 drivers/staging/usbip/stub_rx.c                    |    5 +-
 drivers/staging/usbip/stub_tx.c                    |    1 -
 drivers/staging/usbip/usbip_common.c               |    3 +-
 drivers/staging/usbip/usbip_event.c                |    6 +-
 drivers/staging/usbip/userspace/.gitignore         |   28 +
 drivers/staging/usbip/userspace/Makefile.am        |    2 +-
 drivers/staging/usbip/userspace/README             |    2 -
 drivers/staging/usbip/userspace/configure.ac       |   20 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |    4 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |   15 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |   96 +-
 drivers/staging/usbip/vhci_hcd.c                   |   80 +-
 drivers/staging/usbip/vhci_rx.c                    |   10 +-
 drivers/staging/usbip/vhci_tx.c                    |   14 +-
 drivers/staging/vme/devices/Kconfig                |    2 +-
 drivers/staging/vme/devices/vme_pio2_core.c        |    1 -
 drivers/staging/vme/devices/vme_pio2_gpio.c        |    4 +-
 drivers/staging/vme/devices/vme_user.c             |    2 -
 drivers/staging/vt6655/channel.c                   |   11 +-
 drivers/staging/vt6655/device.h                    |   24 +-
 drivers/staging/vt6655/rxtx.c                      |    6 +-
 drivers/staging/vt6655/wcmd.c                      |    2 +-
 drivers/staging/vt6655/wmgr.c                      |    2 +-
 drivers/staging/vt6656/80211mgr.c                  |   36 +-
 drivers/staging/vt6656/80211mgr.h                  |  169 +-
 drivers/staging/vt6656/aes_ccmp.c                  |   10 +-
 drivers/staging/vt6656/aes_ccmp.h                  |    2 +-
 drivers/staging/vt6656/baseband.c                  |   91 +-
 drivers/staging/vt6656/baseband.h                  |   70 +-
 drivers/staging/vt6656/bssdb.c                     |  435 ++--
 drivers/staging/vt6656/bssdb.h                     |  172 +-
 drivers/staging/vt6656/card.c                      |  366 ++-
 drivers/staging/vt6656/card.h                      |   47 +-
 drivers/staging/vt6656/channel.c                   |  157 +-
 drivers/staging/vt6656/channel.h                   |    9 +-
 drivers/staging/vt6656/control.c                   |   55 +-
 drivers/staging/vt6656/control.h                   |   26 +-
 drivers/staging/vt6656/datarate.c                  |  109 +-
 drivers/staging/vt6656/datarate.h                  |   43 +-
 drivers/staging/vt6656/desc.h                      |  195 +-
 drivers/staging/vt6656/device.h                    |  879 ++++---
 drivers/staging/vt6656/device_cfg.h                |   12 +-
 drivers/staging/vt6656/dpc.c                       |  470 ++--
 drivers/staging/vt6656/dpc.h                       |   16 +-
 drivers/staging/vt6656/firmware.c                  |   33 +-
 drivers/staging/vt6656/firmware.h                  |   17 +-
 drivers/staging/vt6656/hostap.c                    |  147 +-
 drivers/staging/vt6656/hostap.h                    |    4 +-
 drivers/staging/vt6656/int.c                       |   22 +-
 drivers/staging/vt6656/int.h                       |    7 +-
 drivers/staging/vt6656/iocmd.h                     |   22 +-
 drivers/staging/vt6656/iwctl.c                     |  184 +-
 drivers/staging/vt6656/key.c                       |  364 ++-
 drivers/staging/vt6656/key.h                       |  104 +-
 drivers/staging/vt6656/mac.c                       |   92 +-
 drivers/staging/vt6656/mac.h                       |   35 +-
 drivers/staging/vt6656/main_usb.c                  |  530 ++--
 drivers/staging/vt6656/power.c                     |  104 +-
 drivers/staging/vt6656/power.h                     |   16 +-
 drivers/staging/vt6656/rf.c                        |  178 +-
 drivers/staging/vt6656/rf.h                        |   26 +-
 drivers/staging/vt6656/rxtx.c                      |  965 +++-----
 drivers/staging/vt6656/rxtx.h                      |   31 +-
 drivers/staging/vt6656/tether.c                    |    8 +-
 drivers/staging/vt6656/tether.h                    |    2 +-
 drivers/staging/vt6656/ttype.h                     |   23 -
 drivers/staging/vt6656/usbpipe.c                   |  216 +-
 drivers/staging/vt6656/usbpipe.h                   |   40 +-
 drivers/staging/vt6656/wcmd.c                      |  323 ++-
 drivers/staging/vt6656/wcmd.h                      |   18 +-
 drivers/staging/vt6656/wctl.c                      |   50 +-
 drivers/staging/vt6656/wctl.h                      |   10 +-
 drivers/staging/vt6656/wmgr.c                      | 1406 +++++------
 drivers/staging/vt6656/wmgr.h                      |  394 ++-
 drivers/staging/vt6656/wpa.c                       |   30 +-
 drivers/staging/vt6656/wpa.h                       |    4 +-
 drivers/staging/vt6656/wpa2.c                      |   41 +-
 drivers/staging/vt6656/wpactl.c                    |   34 +-
 drivers/staging/vt6656/wpactl.h                    |    2 +-
 drivers/staging/winbond/Kconfig                    |    2 +-
 drivers/staging/wlags49_h2/ap_h2.c                 |    8 +-
 drivers/staging/wlags49_h2/ap_h25.c                |   78 +-
 drivers/staging/wlags49_h2/sta_h2.c                |   80 +-
 drivers/staging/wlags49_h2/wl_enc.c                |  128 +-
 drivers/staging/wlags49_h2/wl_netdev.h             |   94 +-
 drivers/staging/wlags49_h2/wl_priv.c               | 1113 +++++----
 drivers/staging/wlags49_h2/wl_priv.h               |   58 +-
 drivers/staging/wlags49_h2/wl_profile.h            |   12 +-
 drivers/staging/wlags49_h2/wl_util.h               |   38 +-
 drivers/staging/wlags49_h2/wl_wext.c               |    2 -
 drivers/staging/wlan-ng/hfa384x.h                  |   31 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    2 +
 drivers/staging/wlan-ng/prism2mgmt.c               |   40 +-
 drivers/staging/xgifb/XGI_main_26.c                |   84 +-
 drivers/staging/xgifb/XGIfb.h                      |    2 +-
 drivers/staging/xgifb/vb_init.c                    |  119 +-
 drivers/staging/xgifb/vb_init.h                    |    1 +
 drivers/staging/xgifb/vb_setmode.c                 |  684 ++----
 drivers/staging/xgifb/vb_struct.h                  |    5 +-
 drivers/staging/xgifb/vb_table.h                   |  168 +-
 drivers/staging/zcache/Kconfig                     |   34 +-
 drivers/staging/zcache/Makefile                    |    5 +-
 drivers/staging/zcache/TODO                        |   69 +
 drivers/staging/{ramster => zcache}/ramster.h      |    0
 .../{ramster => zcache}/ramster/heartbeat.c        |    0
 .../{ramster => zcache}/ramster/heartbeat.h        |    0
 .../staging/{ramster => zcache}/ramster/masklog.c  |    0
 .../staging/{ramster => zcache}/ramster/masklog.h  |    0
 .../{ramster => zcache}/ramster/nodemanager.c      |    0
 .../{ramster => zcache}/ramster/nodemanager.h      |    0
 .../staging/{ramster => zcache}/ramster/r2net.c    |    0
 .../staging/{ramster => zcache}/ramster/ramster.c  |   34 +-
 .../staging/{ramster => zcache}/ramster/ramster.h  |    0
 .../ramster/ramster_nodemanager.h                  |    0
 drivers/staging/{ramster => zcache}/ramster/tcp.c  |    0
 drivers/staging/{ramster => zcache}/ramster/tcp.h  |    0
 .../{ramster => zcache}/ramster/tcp_internal.h     |    0
 drivers/staging/zcache/tmem.c                      |  327 ++-
 drivers/staging/zcache/tmem.h                      |   83 +-
 drivers/staging/{ramster => zcache}/zbud.c         |   41 +-
 drivers/staging/{ramster => zcache}/zbud.h         |    0
 drivers/staging/zcache/zcache-main.c               | 2590 ++++++++++----------
 drivers/staging/{ramster => zcache}/zcache.h       |    0
 drivers/staging/zram/Kconfig                       |    2 +-
 drivers/staging/zram/zram.txt                      |   27 +-
 drivers/staging/zram/zram_drv.c                    |  294 +--
 drivers/staging/zram/zram_drv.h                    |   17 +-
 drivers/staging/zram/zram_sysfs.c                  |   16 +-
 drivers/staging/zsmalloc/zsmalloc-main.c           |   29 +-
 drivers/staging/zsmalloc/zsmalloc.h                |    2 +-
 include/linux/hid-sensor-hub.h                     |   38 +
 include/linux/hid-sensor-ids.h                     |    9 +
 include/linux/iio/buffer.h                         |   13 -
 include/linux/iio/common/st_sensors.h              |  280 +++
 include/linux/iio/common/st_sensors_i2c.h          |   20 +
 include/linux/iio/common/st_sensors_spi.h          |   20 +
 include/linux/iio/consumer.h                       |   14 +-
 include/linux/iio/driver.h                         |    9 +-
 include/linux/iio/gyro/itg3200.h                   |  154 ++
 include/linux/iio/trigger.h                        |    5 +
 include/linux/pci_ids.h                            |   10 +
 include/linux/platform_data/invensense_mpu6050.h   |   31 +
 .../linux/platform_data}/tsl2563.h                 |    1 -
 include/linux/spi/spi.h                            |   44 +
 621 files changed, 28254 insertions(+), 28403 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-mpu6050
 rename drivers/{staging => }/iio/accel/kxsd9.c (97%)
 create mode 100644 drivers/iio/accel/st_accel.h
 create mode 100644 drivers/iio/accel/st_accel_buffer.c
 create mode 100644 drivers/iio/accel/st_accel_core.c
 create mode 100644 drivers/iio/accel/st_accel_i2c.c
 create mode 100644 drivers/iio/accel/st_accel_spi.c
 delete mode 100644 drivers/iio/common/hid-sensors/hid-sensor-attributes.h
 create mode 100644 drivers/iio/common/st_sensors/Kconfig
 create mode 100644 drivers/iio/common/st_sensors/Makefile
 create mode 100644 drivers/iio/common/st_sensors/st_sensors_buffer.c
 create mode 100644 drivers/iio/common/st_sensors/st_sensors_core.c
 create mode 100644 drivers/iio/common/st_sensors/st_sensors_i2c.c
 create mode 100644 drivers/iio/common/st_sensors/st_sensors_spi.c
 create mode 100644 drivers/iio/common/st_sensors/st_sensors_trigger.c
 rename drivers/{staging/iio/gyro/adis16080_core.c => iio/gyro/adis16080.c} (55%)
 rename drivers/{staging/iio/gyro/adxrs450_core.c => iio/gyro/adxrs450.c} (68%)
 create mode 100644 drivers/iio/gyro/itg3200_buffer.c
 create mode 100644 drivers/iio/gyro/itg3200_core.c
 create mode 100644 drivers/iio/gyro/st_gyro.h
 create mode 100644 drivers/iio/gyro/st_gyro_buffer.c
 create mode 100644 drivers/iio/gyro/st_gyro_core.c
 create mode 100644 drivers/iio/gyro/st_gyro_i2c.c
 create mode 100644 drivers/iio/gyro/st_gyro_spi.c
 rename drivers/{staging => }/iio/imu/adis16400.h (68%)
 create mode 100644 drivers/iio/imu/adis16400_buffer.c
 create mode 100644 drivers/iio/imu/adis16400_core.c
 create mode 100644 drivers/iio/imu/inv_mpu6050/Kconfig
 create mode 100644 drivers/iio/imu/inv_mpu6050/Makefile
 create mode 100644 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
 create mode 100644 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
 create mode 100644 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
 create mode 100644 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
 rename drivers/{staging => }/iio/light/tsl2563.c (91%)
 create mode 100644 drivers/iio/magnetometer/st_magn.h
 create mode 100644 drivers/iio/magnetometer/st_magn_buffer.c
 create mode 100644 drivers/iio/magnetometer/st_magn_core.c
 create mode 100644 drivers/iio/magnetometer/st_magn_i2c.c
 create mode 100644 drivers/iio/magnetometer/st_magn_spi.c
 create mode 100644 drivers/platform/goldfish/Kconfig
 create mode 100644 drivers/platform/goldfish/Makefile
 create mode 100644 drivers/platform/goldfish/goldfish_pipe.c
 create mode 100644 drivers/platform/goldfish/pdev_bus.c
 create mode 100644 drivers/rtc/rtc-hid-sensor-time.c
 create mode 100644 drivers/staging/comedi/comedi_buf.c
 create mode 100644 drivers/staging/comedi/comedi_pci.c
 create mode 100644 drivers/staging/comedi/comedi_pcmcia.c
 create mode 100644 drivers/staging/comedi/comedi_usb.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
 create mode 100644 drivers/staging/comedi/drivers/addi_watchdog.c
 create mode 100644 drivers/staging/comedi/drivers/addi_watchdog.h
 create mode 100644 drivers/staging/comedi/drivers/das08_isa.c
 create mode 100644 drivers/staging/comedi/drivers/das08_pci.c
 delete mode 100644 drivers/staging/comedi/drivers/pcm_common.c
 delete mode 100644 drivers/staging/comedi/drivers/pcm_common.h
 create mode 100644 drivers/staging/goldfish/Kconfig
 create mode 100644 drivers/staging/goldfish/Makefile
 create mode 100644 drivers/staging/goldfish/README
 create mode 100644 drivers/staging/goldfish/goldfish_audio.c
 create mode 100644 drivers/staging/goldfish/goldfish_nand.c
 create mode 100644 drivers/staging/goldfish/goldfish_nand_reg.h
 delete mode 100644 drivers/staging/iio/gyro/adxrs450.h
 delete mode 100644 drivers/staging/iio/imu/Kconfig
 delete mode 100644 drivers/staging/iio/imu/Makefile
 delete mode 100644 drivers/staging/iio/imu/adis16400_core.c
 delete mode 100644 drivers/staging/iio/imu/adis16400_ring.c
 delete mode 100644 drivers/staging/iio/imu/adis16400_trigger.c
 delete mode 100644 drivers/staging/iio/ring_sw.c
 delete mode 100644 drivers/staging/iio/ring_sw.h
 delete mode 100644 drivers/staging/ramster/Kconfig
 delete mode 100644 drivers/staging/ramster/Makefile
 delete mode 100644 drivers/staging/ramster/tmem.c
 delete mode 100644 drivers/staging/ramster/tmem.h
 delete mode 100644 drivers/staging/ramster/zcache-main.c
 create mode 100644 drivers/staging/usbip/userspace/.gitignore
 create mode 100644 drivers/staging/zcache/TODO
 rename drivers/staging/{ramster => zcache}/ramster.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/heartbeat.c (100%)
 rename drivers/staging/{ramster => zcache}/ramster/heartbeat.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/masklog.c (100%)
 rename drivers/staging/{ramster => zcache}/ramster/masklog.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/nodemanager.c (100%)
 rename drivers/staging/{ramster => zcache}/ramster/nodemanager.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/r2net.c (100%)
 rename drivers/staging/{ramster => zcache}/ramster/ramster.c (97%)
 rename drivers/staging/{ramster => zcache}/ramster/ramster.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/ramster_nodemanager.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/tcp.c (100%)
 rename drivers/staging/{ramster => zcache}/ramster/tcp.h (100%)
 rename drivers/staging/{ramster => zcache}/ramster/tcp_internal.h (100%)
 rename drivers/staging/{ramster => zcache}/zbud.c (97%)
 rename drivers/staging/{ramster => zcache}/zbud.h (100%)
 rename drivers/staging/{ramster => zcache}/zcache.h (100%)
 create mode 100644 include/linux/iio/common/st_sensors.h
 create mode 100644 include/linux/iio/common/st_sensors_i2c.h
 create mode 100644 include/linux/iio/common/st_sensors_spi.h
 create mode 100644 include/linux/iio/gyro/itg3200.h
 create mode 100644 include/linux/platform_data/invensense_mpu6050.h
 rename {drivers/staging/iio/light => include/linux/platform_data}/tsl2563.h (99%)
