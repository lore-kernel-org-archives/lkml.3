Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaATVFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:05:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaATVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:05:41 -0500
Date: Mon, 20 Jan 2014 13:06:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.14-rc1
Message-ID: <20140120210627.GA312@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.14-rc1

for you to fetch changes up to aa3bee0daa38570b174ef6b8a77261b4473d5614:

  lustre: delete linux/lustre_debug.h (2014-01-13 16:19:00 -0800)

----------------------------------------------------------------
Staging driver tree patches for 3.14-rc1

Here's the big drivers/staging/ update for 3.14-rc1

Lots and lots of cleanups, IIO driver updates are also mixed in here due
to the subsystem still crossing staging and drivers/iio/, and the dwc2
driver is moved out of staging.  There's a new driver (rts5208), which
ends up making us adding more lines than removing, but overall there was
lots of work toward moving code out of here, which was good.

All of this has been in linux-next with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaron Sierra (4):
      vme: Convert VME core to register as a subsystem
      vme_user: Update API to work in mixed environments
      vme_user: Enable compat_ioctl for mixed environment
      vme_user: Use __u64 and __u32 in userspace structs

Adam Lee (1):
      staging: ft1000: fix uninitialized return variable in request_code_segment

Alan (1):
      usbip: Fix sscanf handling

Aldo Iljazi (6):
      Staging: ft1000: boot.h: fixed a few styling issues
      Staging: ft1000: ft1000_download: fixed coding style issues
      Drivers: staging: ft1000-usb: ft1000_proc.c: fixed a few styling issues.
      Staging: dwc2: hcd.c: Fixed a coding style issue
      Staging: dgnc: dgnc_trace.c: fixed coding style issues
      Staging: usbip: vhci_hcd.c: removed a space

Alexandre Belloni (2):
      iio: mxs-lradc: compute temperature from channel 8 and 9
      iio: mxs-lradc: convert is_divided to a bitmap

Alexandre Demers (1):
      staging r8712u: Remove useless netdev_info slowly polluting dmesg

Alexey Khoroshilov (2):
      staging: gdm724x: fix leak at failure path in gdm_usb_probe()
      staging: wlan-ng: fix leaks on failure paths in prism2sta_probe_usb()

Amir Shehata (6):
      staging/lustre/lnet: coding style fix for lst_test_add_ioctl
      staging/lustre/lnet: remove extra space in lstcon_rpc_trans_abort
      staging/lustre/lnet: constify name argument of lstcon_group_find/lstcon_batch_find
      staging/lustre/lnet: coding style fix for lstcon_test_add
      staging/lustre/lnet: Fix assert on empty group in selftest module
      staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Ana Rey (1):
      staging: rtl8187se: fix coding style in function declarations

Ana Rey Botello (1):
      Staging: rtl8187se: use macro IW_HANDLER to initialize r8180_wx_handlers

Andreas Dilger (1):
      staging/lustre/ldlm: fix resource/fid check, use DLDLMRES

Andreas Frembs (6):
      rtl8192e: Fixing checkpatch errors
      rtl8192e: Removing unused defines in rtl819x_Qos.h
      rlt8192e: Removing unused defines in rltlib_endianfree.h
      Staging rtl8192e: Fixing checkpatch error in rtllib_crypt_tkip.c
      Staging rtl8192e: Fixing checkpatch error in rtllib_debug.h
      Staging rtl8192e: Correcting wrong usage of macro in r8192E_phy.c and removing corresponding warning in rtllib_debug.h

Andrew Perepechko (1):
      staging/lustre/llite: extended attribute cache

Andriy Skulysh (1):
      staging/lustre/ptlrpc: Fix race during exp_flock_hash creation

Anmol Sarma (3):
      Staging: rtl8187se: r8180_core.c: mark symbols as static
      Staging: rtl8187se: r8180_wx.c: make 'rtl8180_rates' static
      Staging: rtl8187se: ieee80211: ieee80211_softmac.c: mark symbols as static

Archana kumari (5):
      staging: imx-drm: Fix warning for static const char * array in imx-ldb.c
      staging: vt6655: fixed sparse warning for static declaration in wpa2.c
      staging: media: lirc: fixed sparse warnings by adding __user annotations in lirc_serial.c
      staging: media: davinci_vpfe:Removed space before semicolon in dm365_ipipe_hw.c
      staging: rtl8192e: Fixed space prohibited warning in dot11d.c

Arnd Bergmann (3):
      staging: panel: fix interruptible_sleep_on race
      staging: serqt_usb2: don't use sleep_on
      staging: gdm72xx: fix interruptible_sleep_on race

Arve Hjønnevåg (2):
      gpu: ion: __dma_page_cpu_to_dev -> arm_dma_ops.sync_single_for_device hack
      gpu: ion: Remove __GFP_NO_KSWAPD

Axel Lin (1):
      iio:trigger: Convert to use ATTRIBUTE_GROUPS

Ben Hutchings (1):
      staging: lustre: Make LUSTRE_LLITE_LLOOP tristate

Benjamin Gaignard (4):
      gpu: ion: fix carveout ops
      gpu: ion: fix compilation warning
      gpu: ion: fix ion_platform_data definition
      gpu: ion: add CMA heap

Bernd Porr (4):
      staging: comedi: fix result of memdup_user for user chanlist
      staging: comedi: report success/failure of autoconfig
      staging: comedi: usbduxsigma: return failure of auto attach
      staging: comedi: usbduxsigma: removing unneccesay attached info

Chase Southwood (5):
      Staging: comedi: fix spacing/style problem in das1800.c (and das6402.c)
      Staging: comedi: fix spacing coding style issue in 8255.c.
      Staging: comedi: fix numerous brace coding style issues in ni_mio_common.c.
      Staging: comedi: fix indentation coding style issue in ni_mio_common.c.
      Staging: comedi: fix extra whitespace style issues in ni_mio_common.c.

Chen Gang (2):
      drivers: staging: speakup: serialio: only use platform specific SERIAL_PORT_DFNS.
      drivers: staging: ft1000: ft1000-usb: ft1000_debug.c: check return value of get_user() in ft1000_ioctl()

Chris Bajumpaa (1):
      staging: line6: Add support for POD HD400 to line6usb driver

Christian Engelmayer (1):
      staging: vt6655: Fix memory leak in wpa_ioctl()

Colin Cross (37):
      gpu: ion: ion_carveout_heap: fix for 3.4
      ion: chunk_heap: fix leak in allocated counter
      ion: add free list size to heap debug files
      ion: convert map_kernel to return ERR_PTR
      ion: remove IS_ERR_OR_NULL
      ion: replace userspace handle cookies with idr
      ion: index client->handles rbtree by buffer
      ion: don't use id 0 for handle cookie
      gpu: ion: delete ion_system_mapper.c
      ion: move userspace api into uapi/ion.h
      ion: hold reference to handle after ion_uhandle_get
      ion: fix crash when alloc len is -1
      ion: fix dma APIs
      ion: convert sg_dma_len(sg) to sg->length
      ion: check invalid values in ion_system_heap
      ion: add test device for unit tests to interact with dma_bufs
      ion: update idr to avoid deprecated apis
      ion: don't use __arm_ioremap to map pages
      ion: don't use phys_to_page or __phys_to_pfn
      ion: fix printk warnings
      gpu: ion: remove unnecessary function from system heap
      ion: clean up ioctls
      ion: drop dependency on ARM
      ion: add alignment check to carveout heap
      ion: optimize ion_heap_buffer_zero
      ion: free low memory from page pools first
      ion: check return value from remap_pfn_range
      ion: use vm_insert_pfn for faulted pages
      ion: remove ion_heap_alloc_pages
      ion: allow cached mappings of chunk and system heap buffers
      ion: use alloc_pages in system contig heap
      ion: fix sparse warnings
      ion: carveout heap: zero buffers on free, fix memory leak
      ion: add helper to zero contiguous region of pages
      ion: add alignment check to chunk heap
      ion: fix bugs in cma heap
      ion: remove ion_user_handle_t from ion_test.h

Conrad Gomes (7):
      Staging: comedi: fix line over 80 character warning in unioxx5.c
      Staging: comedi: fix line over 80 character warning in unioxx5.c
      Staging: comedi: change printk to dev_err/dev_dbg in unioxx5.c
      Staging: comedi: change pr_err to dev_err in __unioxx5_analog_read
      Staging: comedi: change pr_err to dev_err in __unioxx5_digital_write
      Staging: comedi: change pr_err to dev_err in __unioxx5_analog_write
      Staging: comedi: remove MACRO pr_fmt in unioxx5.c

Dan Carpenter (5):
      staging: dwc2: cleanups in dwc2_hcd_qh_add()
      staging: dwc2: remove some indent levels
      staging: vt6655: check too restrictive (off by one)
      staging: vt6656: remove an unneeded NULL check
      staging: bcm: clean up a type issue in ConfigureEndPointTypesThroughEEPROM()

Dan LaManna (1):
      Staging: rtl8187se: fix styling issues in r8180_wx.c

Daniel Dodge (1):
      Drivers: Staging: ft1000: Fixed C99 // comments styling issue

Daniel Vetter (1):
      drm/imx: directly call drm_put_dev in ->remove

Dima Zavin (1):
      gpu: ion: do not ask for compound pages in system heap

Dmitry Eremin (5):
      staging/lustre/build: fix compilation issue with is_compat_task
      staging/lustre: clean up SET_BUT_UNUSED/UNUSED macros
      staging/lustre/pinger: remove never implemented suspend timeouts functionality
      staging/lustre/obdclass: remove unuse variables from lprocfs_stats_collect/clear
      staging/lustre/ptlrpc: better error handling in ptlrpcd_start

Doug Oucharek (1):
      staging/lustre/lnet: Add LNet Router Priority parameter

Duan Jiong (1):
      lustre/fld: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Dulshani Gunawardhana (5):
      staging/cxt1e1:Fixes incorrect brace placement
      staging:lustre: Fix plain integer as NULL pointer warning
      staging: lustre: Fix incorrect type in assignment
      staging:lustre: Fix variable type declaration
      staging: lustre: Fix sparse warning for one-bit signed bitfield

Ebru Akagunduz (3):
      Staging: rtl8187se: fix printk() should include kern_ facility level
      Staging: media: fix space prohibited before semicolon
      Staging: rtl8187se: Fix Sparse Warnings

Eddie Kovsky (1):
      staging: Clean up whitespace warnings in staging/winbond

Eli Billauer (5):
      staging: xillybus: Removed force to be a module
      staging: xillybus: Return -EIO if *_iomap fails, instead of 0
      staging: xillybus: Added documentation on device tree bindings
      staging: xillybus: Changed Open Firmware "compatible" property
      staging: xillybus: Open Firmware driver supporting coherent DMA

Eric Skoglund (3):
      Drivers: Staging: cxt1e1: sbeid: Fixed coding style issue - space -> tabs
      Drivers: Staging: cxt1e1: sbeid: Fixed braces coding style issue
      Drivers: Staging: cxt1e1: stbeid: Fixed whitespace between function and parameters

Fabio Estevam (1):
      imx-drm: Add mx6 hdmi transmitter support

Fan Yong (2):
      staging/lustre/scrub: OI scrub on OST
      staging/lustre: make code align in lma_incompat

Gary Rookard (4):
      Staging: bcm: DDRInit: fixed issues w/ indentation.
      Staging: bcm: DDRInit: fixed issues w/ commenting.
      Staging: bcm: DDRInit: fixed up some commenting issues.
      Staging: bcm: DDRInit: fix up some bracing issues.

Geert Uytterhoeven (4):
      staging: Remove superfluous name casts
      staging: r8188eu: Remove superfluous name cast
      staging: usbip: Remove superfluous name cast
      mfd: staging: Constify struct mfd_cell where possible

Gokulnath A (2):
      staging:bcm: Removed developer debug prints in InterfaceDld.c
      staging: bcm: line over 80 characters in InterfaceDld.c

Gokulnath Avanashilingam (4):
      staging: bcm: Remove Developer Debug prints in InterfaceIdleMode.c
      staging: bcm: line over 80 characters in InterfaceIdleMode.c
      staging: bcm: using time_after and time_before in InterfaceIdleMode.c
      staging: bcm: fixed warning about no and prohibited space in InterfaceIdleMode.c.

Greg Hackmann (2):
      gpu: ion: fill in buffer->{dev,size} before mapping new buffers
      gpu: ion: fix page offset in dma_buf_kmap()

Greg Kroah-Hartman (24):
      Merge branch 'opw-next' into staging-next
      Merge tag 'iio-for-3.14a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge v3.13-rc2 into staging-next
      staging: lustre: reapply an older patch that was reverted
      staging: btmtk_usb: remove driver
      Merge 3.13-rc4 into staging-next.
      Merge 3.13-rc5 into staging-next
      Merge tag 'iio-for-3.14b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.14c' of git://git.kernel.org/.../jic23/iio into staging-next
      staging: wlags49_h2: remove unneeded MODULE_DATE string
      staging: wlags49_h2: remove some unused macros
      staging: wlags49_h2: remove empty DBG_FUNC()
      staging: wlags49_h2: remove DBG_ENTER() macro
      staging: wlags49_h2: remove DBG_LEAVE()
      staging: wlags49_h2: remove DBG_TRAP()
      staging: wlags49_h2: remove DBG_DEFN()
      staging: wlags49_h2: remove PRINTK()
      staging: wlags49_h2: remove custom ways of creating a module name
      staging: wlags49_h2: remove some DBG_TRACE() calls
      staging: wlags49_h2: debug.h: fix up some coding style issues.
      staging: wlags49_h2: debug.h: remove typedef for debug structure
      staging: wlags49_h2: remove wl_pci.?
      staging: lustre: remove some unused debug macros
      lustre: delete linux/lustre_debug.h

Grygorii Strashko (1):
      mm/staging: remove unnecessary inclusion of bootmem.h

Gu Zheng (1):
      staging/olpc_docn: reorder the lock sequence to avoid potential dead lock

H Hartley Sweeten (276):
      staging: comedi: das6402: remove DEBUG noise
      staging: comedi: pcl816: remove DEBUG macro
      staging: comedi: dt282x: remove DEBUG define
      staging: comedi: fl512: remove DEBUG define
      staging: comedi: ni_pcidio: remove custom DPRINTK macro
      staging: comedi: ni_pcidio: remove DEBUG and DEBUG_FLAGS defines
      staging: comedi: ni_pcidio: remove DEBUG define
      staging: comedi: dt3000: remove DEBUG define
      staging: comedi: remove comedi_debug module parameter
      staging: comedi: range: remove use of DPRINTK
      staging: comedi: pcl816: remove use of DPRINTK
      staging: comedi: amplc_pci224: remove use of DPRINTK
      staging: comedi: amplc_pci230: remove use of DPRINTK
      staging: comedi: dt2801: remove use of DPRINTK
      staging: comedi: comedi_fops: remove use of DPRINTK
      staging: comedi: ni_pcidio: remove DEBUG_FLAGS define and code
      staging: comedi: ni_pcidio: remove debug_int()
      staging: comedi: ni_pcidio: remove use of DPRINTK
      staging: comedi: remove DPRINTK macro
      staging: comedi: mite: remove MDPRINTK macro
      staging: comedi: mite: remove DEBUG_MITE code
      staging: comedi: cb_pcidas64: remove DEBUG_PRINT
      staging: comedi: gsc_hpdi: remove DEBUG_PRINT
      staging: comedi: ni_at_a2150: remove A2150_DEBUG
      staging: comedi: cb_pcimdas: remove CBPCIMDAS_DEBUG
      staging: comedi: ni_pcimio: remove PCI_DEBUG
      staging: comedi: pcmmio: remove DAMMIT_ITS_BROKEN debug
      staging: comedi: pcmmio: remove commented out debug code
      staging: comedi: dyna_pci10xx: convert a KERN_DEBUG message to dev_dbg()
      staging: comedi: pcmmio: convert a KERN_DEBUG message to dev_dbg()
      staging: comedi: c6xdigio: remove unnecessary c6xdigio_pwmo_insn_read()
      staging: comedi: dt2814: remove disabled irq probe code
      staging: comedi: pcl818: remove an unnecessary printk(KERN_DEBUG ...
      staging: comedi: dmm32at: remove some unnecessary printk(KERN_DEBUG ...
      staging: comedi: ni_mio_common: remove unused NI_CS5529_DEBUG code
      staging: comedi: ni_mio_common: remove DEBUG_DIO messages
      staging: comedi: ni_mio_common: remove DEBUG_STATUS_B messages
      staging: comedi: ni_mio_common: remove DEBUG_STATUS_A messages
      staging: comedi: ni_mio_common: remove DEBUG_INTERRUPT messages
      staging: comedi: unionxx5: tidy up some dev_{level} messages
      staging: comedi: pcmmio.c: remove kcalloc() failure message
      staging: comedi: adv_pci1710: convert some printk's to dev_dbg()
      staging: comedi: dmm32at: remove final attach noise and fix return value
      staging: comedi: pcl812: convert some printk's to dev_dbg()
      staging: comedi: pcl816: convert some printk's to dev_dbg()
      staging: comedi: pcl818: convert some printk's to dev_dbg()
      staging: comedi: adq12b: remove commented out debug message
      staging: comedi: c6xdigio: remove commented out subdevice code
      staging: comedi: c6xdigio: remove commented out function trace messages
      staging: comedi: cb_pcimdas: remove commented out irq init code
      staging: comedi: cb_pcimdas: remove unnecessary printk noise
      staging: comedi: das16m1: tidy up the irq support in das16m1_attach()
      staging: comedi: dmm32at: remove unnecessary printk noise
      staging: comedi: dmm32at: remove commented out printk debug
      staging: comedi: dmm32at: tidy up the irq support in dmm32at_attach()
      staging: comedi: dmm32at: convert a printk(KERN_ERR to a dev->err()
      staging: comedi: dt2801: remove disabled code in dt2801_writedata
      staging: comedi: dt2801: remove commented out printk()
      staging: comedi: dt2801: convert printk() messages to dev_dbg()
      staging: comedi: dt2811: remove disabled dt2811_adtrig() function
      staging: comedi: dt2811: remove disabled interrupt support code
      staging: comedi: dt2814: remove unnecessary printk noise
      staging: comedi: dt2814: remove bad printk noise
      staging: comedi: dt2814: convert a printk(KERN_ERR into a dev_err()
      staging: comedi: dt2814: tidy up the irq support in dt2814_attach()
      staging: comedi: dt2815: convert printk's in dt2815_ao_insn()
      staging: comedi: dt2815: convert printk's in dt2815_attach()
      staging: comedi: dt282x: tidy up the irq support in dt282x_attach()
      staging: comedi: dt282x: remove attach noise in dt282x_grab_dma()
      staging: comedi: dt282x: convert printk() in dt282x_attach to a dev_err()
      staging: comedi: dt282x: remove unnecessary blank line message
      staging: comedi: dt282x: remove disable code that disables the irq
      staging: comedi: dt282x: convert dt282x_ao_dma_interrupt() messages
      staging: comedi: dt282x: convert dt282x_ai_dma_interrupt() messages
      staging: comedi: dt282x: convert dt282x_ao_inttrig() messages
      staging: comedi: dt282x: remove commented out printk
      staging: comedi: mpc624: remove commented out printk
      staging: comedi: mpc624: remove unnecessary test
      staging: comedi: mpc624: remove unnecessary printk noise
      staging: comedi: mpc624: convert printk messages in mpc624_ai_rinsn()
      staging: comedi: rtd520: remove commented out printk debug
      staging: comedi: plx9080.h: remove unnecessary printk noise
      staging: comedi: pcm3724: remove commented out printk debug
      staging: comedi: pcl818: remove commented out printk debug
      staging: comedi: pcl818: remove printk function trace messages
      staging: comedi: pcl818: remove board attach noise
      staging: comedi: pcl818: tidy up the irq support in pcl818_attach()
      staging: comedi: pcl818: convert printk() messages to dev_{level}
      staging: comedi: pcl816: remove commented out outb() macro
      staging: comedi: pcl816: remove TRIG_WAKE_EOS support stub
      staging: comedi: pcl816: tidy up the irq support in pcl816_attach()
      staging: comedi: pcl816: remove commented out printk debug
      staging: comedi: pcl816: convert printk messages in pcl816_attach()
      staging: comedi: pcl812: tidy up the irq support in pcl812_attach()
      staging: comedi: pcl812: convert printk messages in pcl812_attach()
      staging: comedi: ni_tio: remove commented out printk message
      staging: comedi: ni_pcimio: convert printk() to dev_dbg()
      staging: comedi: ni_atmio16d: remove printk() noise in atmio16d_ai_insn_read()
      staging: comedi: ni_atmio16d: tidy up the irq support in atmio16d_attach()
      staging: comedi: ni_atmio16d: remove an unnecessary printk
      staging: comedi: s626: fix async command hookup
      staging: comedi: pcl816: remove 'irq_free' from private data
      staging: comedi: pcl816: only init command support if irq is available
      staging: comedi: pcl816: remove 'sub_ai' from private data
      staging: comedi: pcl816: use dev->read_subdev
      staging: comedi: pcl818: remove 'irq_free' from private data
      staging: comedi: pcl818: remove unnecessary 'dev->irq' tests
      staging: comedi: pcl818: remove function trace noise
      staging: comedi: pcl818: only init async command members when needed
      staging: comedi: pcl818: remove 'sub_ai' from private data
      staging: comedi: pcl818: use dev->read_subdev
      staging: comedi: pcl818: remove unnecessary s->len_chanlist init
      staging: comedi: pcl812: remove unnecessary s->len_chanlist init
      staging: comedi: pcl812: only init async command members when needed
      staging: comedi: pcl812: use dev->read_subdev
      staging: comedi: ni_pcimio: tidy up the irq request
      staging: comedi: ni_pcidio: tidy up the irq request
      staging: comedi: ni_at_2150: tidy up irq/dma request
      staging: comedi: me4000: use dev->read_subdev
      staging: comedi: me4000: refactor request_irq() during attach
      staging: comedi: me4000: remove unnecessary check in the irq handler
      staging: comedi: das1800: tidy up irq request
      staging: comedi: das1800: use dev->read_subdev
      staging: comedi: das16m1: remove unnecessary 'dev->irq' test
      staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq()
      staging: comedi: adl_pci9111: the irq is only needed for async command support
      staging: comedi: dt2814: use dev->read_subdev
      staging: comedi: dt282x: use dev->read_subdev
      staging: comedi: dt282x: use dev->write_subdev
      staging: comedi: amplc_pci230: tidy up irq request
      staging: comedi: adl_pci9118: tidy up irq request
      staging: comedi: adv_pci1710: only init async command members when needed
      staging: comedi: adv_pci1710: use dev->read_subdev
      staging: comedi: dt3000: don't fail attach if irq is not available
      staging: comedi: dt3000: use dev->read_subdev
      staging: comedi: s626: use dev->read_subdev
      staging: comedi: hwrdv_apci3120: use dev->read_subdev
      staging: comedi: hwrdv_apci3200: use dev->read_subdev
      staging: comedi: adl_pci9118: use dev->read_subdev
      staging: comedi: amplc_pc236: use dev->read_subdev
      staging: comedi: amplc_pci224: use dev->write_subdev
      staging: comedi: ni_65xx: use dev->read_subdev
      staging: comedi: ni_atmio16d: use dev->read_subdev
      staging: comedi: rtd520: use dev->read_subdev
      staging: comedi: ni_pcidio: factor board reset out of attach
      staging: comedi: ni_pcidio: use dev->read_subdev
      staging: comedi: pcmuio: fix interrupt requests
      staging: comedi: pcmuio: spinlock protect pcmuio_{write, read}()
      staging: comedi: pcmuio: tidy up pcmuio_handle_asic_interrupt()
      staging: comedi: pcmuio: remove 'asic' member from subdevice private data
      staging: comedi: pcmuio: remove subdevice private data
      staging: comedi: pcmuio: fix pcmuio_dio_insn_bits()
      staging: comedi: pcmuio: remove unnecessary mask of triggered channels
      staging: comedi: pcmuio: add inline helpers to get the 'iobase', 'asic', and 'port'
      staging: comedi: pcmuio: document the spinlock_t variables
      staging: comedi: pcmuio: fix types of some private data variables
      staging: comedi: pcmuio: remove unneeded include
      staging: comedi: pcmuio: tidy up pcmuio_attach()
      staging: comedi: pcmuio: tidy up pcmuio_start_intr()
      staging: comedi: ni_at_a2150: fix an always true condition test
      staging: comedi: pcmmio: remove unused {lock, unlock}_port()
      staging: comedi: pcmmio: tidy up switch_page()
      staging: comedi: pcmmio: cleanup comedi_lrange tables
      staging: comedi: pcmmio: use core helpers to munge bipolar ai data
      staging: comedi: pcmmio: cleanup ai_rinsn()
      staging: comedi: pcmmio: return error if ai conversion times out
      staging: comedi: pcmmio: define the offset to the 2nd ADC device
      staging: comedi: pcmmio: tidy up the ai subdevice init
      staging: comedi: pcmmio: move ao shadow data to device private data
      staging: comedi: pcmmio: remove 'iobase' from subdevice private data
      staging: comedi: pcmmio: cleanup ao_winsn()
      staging: comedi: pcmmio: return error if ao conversion times out
      staging: comedi: pcmmio: tidy up ao_rinsn()
      staging: comedi: pcmmio: tidy up the ao subdevice init
      staging: comedi: pcmmio: tidy up the irq request
      staging: comedi: pcmmio: remove unused members in private data
      staging: comedi: pcmmio: there is only one asic
      staging: comedi: pcmmio: remove 'asic' parameter from switch_page()
      staging: comedi: pcmmio: tidy up init_asics()
      staging: comedi: pcmmio: cleanup the digital i/o register defines
      staging: comedi: pcmmio: remove 'subpriv' macro
      staging: comedi: pcmmio: rename 'spinlock' in the private data
      staging: comedi: pcmmio: introduce pcmmio_dio_write()
      staging: comedi: pcmmio: simplify pcmmio_dio_insn_config()
      staging: comedi: pcmmio: simplify pcmmio_dio_insn_bits()
      staging: comedi: pcmmio: remove 'iobases' from the subdevice private data
      staging: comedi: pcmmio: simplify pcmmio_stop_intr()
      staging: comedi: pcmmio: unwind the digital i/o subdevice init
      staging: comedi: pcmmio: remove unnecessary for () loop and sanity check
      staging: comedi: pcmmio: remove 'asic' member from subdevice private data
      staging: comedi: pcmmio: remove 'first_chan' from subdevice private data
      staging: comedi: pcmmio: remove 'asic_chan' from subdevice private data
      staging: comedi: pcmmio: remove 'num_asic_chans' from subdevice private data
      staging: comedi: pcmmio: remove subdevice private data
      staging: comedi: pcmmio: use comedi_legacy_detach() for (*detach)
      staging: comedi: pcmmio: cleanup indent levels in interrupt_pcmmio()
      staging: comedi: pcmmio: use pcmmio_dio_{read, write}() in interrupt_pcmmio()
      staging: comedi: pcmmio: factor the trigger handling out of interrupt_pcmmio()
      staging: comedi: pcmmio: tidy up pcmmio_handle_dio_intr()
      staging: comedi: pcmmio: only hook up async command support if irq is available
      staging: comedi: pcmmio: setup irq routing during (*attach)
      staging: comedi: pcmmio: tidy up pcmmio_start_intr()
      staging: comedi: pcmmio: remove unused defines
      staging: comedi: pcmmio: cleanup the private data
      staging: comedi: pcmmio: return '0' after successful attach
      staging: comedi: pcmmio: update the MODULE_DESCRIPTION
      staging: comedi: pcmmio: tidy up the multi-line comments
      staging: comedi: pcmmio: fix final checkpatch warning
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug
      staging: comedi: pcl812: tidy up comedi_lrange tables
      staging: comedi: ni_mio_common: tidy up comedi_lrange tables
      staging: comedi: cb_pcidas64: tidy up comedi_lrange tables
      staging: comedi: pcl818: tidy up comedi_lrange tables
      staging: comedi: adv_pci1710: tidy up comedi_lrange tables
      staging: comedi: das08: tidy up comedi_lrange tables
      staging: comedi: dt2801: tidy up comedi_lrange tables
      staging: comedi: cb_pcidas: tidy up comedi_lrange tables
      staging: comedi: ni_atmio16d: tidy up comedi_lrange tables
      staging: comedi: dt2811: tidy up comedi_lrange tables
      staging: comedi: dt282x: tidy up comedi_lrange tables
      staging: comedi: das1800: tidy up comedi_lrange tables
      staging: comedi: adl_pci9118: tidy up comedi_lrange tables
      staging: comedi: amplc_pci224: tidy up comedi_lrange tables
      staging: comedi: ni_pcimio: tidy up comedi_lrange tables
      staging: comedi: amplc_pci230: tidy up comedi_lrange tables
      staging: comedi: dmm32at: tidy up comedi_lrange tables
      staging: comedi: adq12b: tidy up comedi_lrange tables
      staging: comedi: das16m1: tidy up comedi_lrange tables
      staging: comedi: fl512: tidy up comedi_lrange tables
      staging: comedi: pcl816: tidy up comedi_lrange tables
      staging: comedi: aio_aio12_8: tidy up comedi_lrange tables
      staging: comedi: icp_multi: tidy up comedi_lrange tables
      staging: comedi: me4000: tidy up comedi_lrange tables
      staging: comedi: dyna_pci10xx: tidy up comedi_lrange tables
      staging: comedi: comedi_test: tidy up comedi_lrange tables
      staging: comedi: ni_at_a2150: tidy up comedi_lrange tables
      staging: comedi: usbduxfast: tidy up comedi_lrange tables
      staging: comedi: adv_pci1724: tidy up comedi_lrange tables
      staging: comedi: adl_pci9111: tidy up comedi_lrange tables
      staging: comedi: s626: tidy up comedi_lrange table
      staging: comedi: ni_tio.h: rename the CamelCase enum ni_gpct_register labels
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Autoincrement_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Command_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_SW_Save_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Mode_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_LoadA_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_LoadB_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Input_Select_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Counting_Mode_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Second_Gate_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gxx_Status_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gxx_Joint_Reset_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gxx_Joint_Status1_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gxx_Joint_Status2_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_DMA_Config_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_DMA_Status_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_ABZ_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Interrupt_Acknowledge_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Status_Reg()
      staging: comedi: ni_tio_internal.h: replace NITIO_Gi_Interrupt_Enable_Reg()
      staging: comedi: ni_tio_internal.h: add missing NITIO_*_REG macro
      staging: comedi: ni_tiocmd: use a local var for the 'counter_index'
      staging: comedi: ni_tio: use a local var for the 'counter_index'
      staging: comedi: ni_tiocmd: move the MODULE_* stuff to the end of file
      staging: comedi: ni_tio: move the MODULE_* stuff to the end of file
      staging: comedi: ni_tio.h: remove 'extern' from exported function prototypes
      staging: comedi: ni_tio.h: remove subdev_to_counter()
      staging: comedi: ni_tio: make ni_tio_rinsn() a proper comedi (*insn_read)
      staging: comedi: ni_tio: make ni_tio_winsn() a proper comedi (*insn_write)
      staging: comedi: ni_tio: make ni_tio_insn_config() a proper comedi (*insn_config)
      staging: comedi: ni_tiocmd: make ni_tio_cmdtest() a proper comedi (*do_cmdtest)
      staging: comedi: ni_tiocmd: make ni_tio_cmd() a proper comedi (*do_cmd)
      staging: comedi: ni_660x: rename the CamelCase enum NI_660x_Register and labels
      staging: comedi: ni_660x: use a local var for the 'chip_index'
      staging: comedi: ni_660x: remove dma_selection_counter()
      staging: comedi: ni_660x: tidy up set_tio_counterswap()

Harald Geyer (2):
      iio: Add support for humidity sensors
      iio: Add new driver dht11

Hector Palacios (3):
      iio: mxs-lradc: add scale attribute to channels
      iio: mxs-lradc: add scale_available file to channels
      iio: mxs-lradc: add write_raw function to modify scale

Himangi Saraogi (18):
      drivers : staging :rtl8187se : r8180_core.c : remove space before semicolon
      Staging: rtl8187se: Fix C99 style commenting in dot11d.h
      staging:rtl8187se: Shift open brace of function declarations to next line
      staging:rtl8187se: Use preferred library linux/uaccess.h over asm/uaccess.h
      Staging:rtl8187se: Insert spaces after commas
      Staging:rtl8187se: Add space before open parenthesis of if condition
      Staging:rtl8187se: Remove unnecessary braces from if-else statement
      Staging: rtl8187se: Fix indentation errors
      Staging: rtl8187se: Remove C99 style commenting
      staging:media:go7007:go7007-fw.c: move trailing statement to next line
      staging:media:go7007:saa7134-go7007.c: Remove space before tabs
      staging:wlan-ng:cfg80211.c: Shorten lines to 80 characters
      staging:wlan-ng:hfa384x.h: remove typedef struct hfa384x_bytestr __packed hfa384x_bytestr_t
      staging:usbip:stub_rx.c: Remove warning quoted string split across lines
      staging:usbip:usbip_common.c: Join quoted string split accross lines
      staging:rtl8192e: Rewrite macro definition as static inline function.
      staging:wlags49_h2: Fix sparse warnings in sta_h25.c
      staging:dwc2:hcd_queue.c : cleanups to the microframe scheduler code

Ian Abbott (25):
      staging: comedi: remove unused command callback support
      staging: comedi: add a couple of #includes to comedidev.h
      staging: comedi: add rw_semaphore to protect against device detachment
      staging: comedi: use attach_lock semaphore during attach and detach
      staging: comedi: cleanup_device() -> comedi_device_detach_cleanup()
      staging: comedi: wake up async waiters when become non-busy
      staging: comedi: cancel commands before detaching device
      staging: comedi: add detachment counter for validity checks
      staging: comedi: protect against detach during write operation
      staging: comedi: protect against detach during read operation
      staging: comedi: add a kref to comedi device
      staging: comedi: add comedi_dev_get_from_minor()
      staging: comedi: increment reference while file open
      staging: comedi: use refcount in comedi_driver_unregister()
      staging: comedi: use refcount while reading /proc/comedi
      staging: comedi: use refcount in sysfs attribute handlers
      staging: comedi: kcomedilib: increment reference while device in use
      staging: comedi: kcomedilib: protect against device detachment
      staging: comedi: use file->private_data in file operations
      staging: comedi: remove comedi_dev_from_minor()
      staging: comedi: make determination of read or write subdevice safer
      staging: comedi: protect buffer from being freed while mmapped
      staging/comedi: keep reference to class device after destroyed
      staging/comedi: bug fix for module usage count on device removal
      staging: comedi: fix bug destroying subdevice files after parent

Ingrid Cheung (2):
      Staging: bcm: Fix checkpatch warning for long line.
      Staging: bcm: Fix checkpatch warnings for long lines.

Ivaylo Dimitrov (2):
      Staging: TIDSPBRIDGE: Remove UUID helper
      Staging: tidspbridge: Use hashtable implementation

JC Lafoucriere (5):
      staging/lustre/llite: Access to released file triggers a restore
      staging/lustre/mdt: HSM coordinator client interface
      staging/lustre: constify uuid argument of obd_uuid2str
      staging/lustre: make obd_uuid_equals return bool
      staging/lustre/api: HSM import uses new released pattern

JP Abgrall (1):
      gpu: ion: fix kfree/list_del order

James Simmons (2):
      staging/lustre/autoconf: remove vectored fops tests
      staging/lustre/autoconf: remove LIBCFS_HAVE_IS_COMPAT_TASK test

Jie Liu (1):
      staging: ozwpan: remove unneeded __GFP_ZERO to kzalloc() at oz_elt_stream_create()

Jingoo Han (2):
      staging: remove DEFINE_PCI_DEVICE_TABLE macro
      vme: remove DEFINE_PCI_DEVICE_TABLE macro

Jinshan Xiong (2):
      staging/lustre/hsm: Implementation of exclusive open
      staging/lustre/hsm: Add hsm_release feature.

Joachim Adi Schuetz (1):
      staging: ced401: ced_ioc: fix a blank/tab codingstyle issue.

Joe Perches (1):
      staging: slicoss: Remove last reference to compare_ether_addr

Johan Mossberg (2):
      gpu: ion: Export ion_client_create
      gpu: ion: Add support for sharing buffers with dma buf kernel handles

John L. Hammond (5):
      staging/lustre/llite: use correct FID in ll_och_fill()
      staging/lustre/lov: convert magic to host-endian in lov_dump_lmm()
      staging/lustre/mdc: prevent fall through in mdc_iocontrol()
      staging/lustre/lu: shrink lu_object by 8 bytes on x86_64
      staging/lustre/llite: don't check for O_CREAT in it_create_mode

John Stultz (14):
      ion: Add Kconfig dependency to ARM
      ion: Fix compat support to use proper compat ioctl numbers
      ion: Fix two small issues in system_heap allocation
      ion: Cleanup whitespace issues and other checkpatch problems
      ion: Improve ION config description
      ion: Update system heap shrinker to use the new count/scan interface
      ion: Don't allow building ION as a module.
      ion: Reenable the build
      staging: ion: Add HAVE_MEMBLOCK config dependency
      staging: ion: Fix possible null pointer dereference
      staging: ion: Avoid using rt_mutexes directly
      ion_test: Add compat_ioctl support (v2)
      ion: Add dummy driver for testing
      ion: Add carveout and chunk heaps to dummy driver

Jonathan Cameron (19):
      iio:accel:bma180 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:mag:mag3110 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5064 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5360 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5380 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5421 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5446 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5449 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5504 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5624r replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5686 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5755 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5764 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:ad5791 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:dac:max517 drop specification of scan type as unused in this driver.
      iio:dac:mcp4725 drop specification of scan type as unused in this driver.
      iio:light:adjd_s311 replaces IIO_ST macro with explicit entries to struct scan_type
      iio:light:tcs3472 replaces IIO_ST macro with explicit entries to struct scan_type
      staging:iio:ad7606 replaces IIO_ST macro with explicit entries to struct scan_type

Josh Triplett (3):
      staging: wlags49_h2: Drop debug macro recording build date/time
      staging: rts5139: Drop print of build time
      staging: rtl8188eu: Drop print of build date/time

Julia Lawall (1):
      staging: tidspbridge: adjust error return code (bugfix)

Julien DELACOU (2):
      staging: dwc2: do not clear pending interrupts twice
      staging: dwc2: add check on dwc2_core_reset return

Kelley Nielsen (10):
      staging: ft1000: STATUS_ defines removed from ft1000_download.c
      staging: ft1000: remove formal function headers from ft1000_hw.c
      staging: ft1000: STATUS defines completely removed
      staging: ft1000: remove unused variable nxtph
      staging: ft1000: extract dsp_broadcast_msg_id()
      staging: ft1000: extract helper handle_misc_portid()
      staging: ft1000: flatten nesting in handle_misc_portid
      staging: ft1000: fix checkpatch issues in ft1000_poll()
      staging: ft1000: flatten nesting in dsp_broadcast_msg_id()
      staging: ft1000: fix remaining checkpatch issues in ft1000_hw.c

Kevin Tsai (1):
      iio: add Capella CM32181 ambient light sensor driver.

Kristina Martsenko (9):
      staging: lustre: ptlrpc: pack_generic: clean up whitespace around parentheses
      staging: lustre: ptlrpc: clean up whitespace around parentheses
      staging: lustre: ptlrpc: clean up whitespace around braces
      staging: lustre: ptlrpc: remove an unnecessary semicolon
      staging: lustre: ptlrpc: convert spaces to tabs
      staging: lustre: ptlrpc: remove whitespace before a newline
      staging: lustre: ptlrpc: fix indentation
      staging: lustre: ptlrpc: fix label indentation
      staging: lustre: fix checkpatch issue regarding pointer coding style

KyongHo Cho (1):
      gpu: ion: several bugfixes and enhancements of ION

Larry Finger (44):
      staging: r8188eu: Remove pointless thread_exit macro
      staging: r8188eu: Remove wrapper around spin_lock_bh
      staging: r8188eu: Remove wrapper around spin_unlock_bh
      staging: r8188eu: Remove wrappers for spin_lock_irqsave
      staging: r8188eu: Remove wrappers around spin_unlock_irqrestore
      staging: r8188eu: Remove wrapper around spin_lock_init
      staging: r8188eu: Remove calls to _rtw_spinlock_free
      staging: r8188eu: Replace rtw_get_current_time() with jiffies
      staging: r8188eu: Replace wrappers ODM_sleep_ms() and rtw_msleep_os() with a simple msleep
      staging: r8188eu: Replace wrappers ODM_delay_ms() and rtw_mdelay_os() with a simple mdelay
      staging: r8188eu: Replace wrappers ODM_StallExecution, ODM_delay_us, and rtw_udelay_os
      staging: r8188eu: Restore line that was incorrectly removed
      staging: r8188eu: Fix unused variable warnings
      staging: r8188eu: Replace wrappers ODM_sleep_us and rtw_usleep_os
      staging: r8188eu: Replace wrapper rtw_yield_os
      staging: r8188eu: Remove wrapper code for rtw_suspend_lock_init, rtw_suspend_lock_uninit, rtw_lock_suspend, and rtw_unlock_suspend
      staging: r8188eu: Replace ATOMIC_T with atomic_t
      staging: r8188eu: Replace wrapper around atomic_set()
      staging: r8188eu: Remove unused atomic_xxx wrappers
      staging: r8188eu: Replace wrappers for atomic_inc and atomic_inc_return
      staging: r8188eu: Remove daemonize conditional
      staging: r8188eu: Replace wrapper around sema_init
      staging: r8188eu: Remove wrappers _rtw_free_sema, _rtw_up_sema, and _rtw_mutex_init
      staging: r8188eu: Remove wrapper around mutex_destroy
      staging: r8188eu: Remove macro ODM_SetBBReg
      staging: r8188eu: Remove macro ODM_GetBBReg
      staging: r8188eu: Remove macro ODM_SetRFReg
      staging: r8188eu: Remove macro ODM_GetRFReg
      staging: r8188eu: Remove macro ODM_SetMACReg
      staging: r8188eu: Remove macro ODM_GetMACReg
      staging: r8188eu: Remove - number of dummy and unused routines
      staging: r8188eu: Remove more empty routines
      staging: r8188eu: Remove even more empty routines
      staging: r8188eu: Simplify code concerning SupportPlatform
      staging: r8188eu: Simplify code related to SupportICType
      staging: r8188eu: Remove unneeded prototypes from include/odm.h
      staging: r8188eu: Additional cleanup of include/odm.h
      staging: r8188eu: Cleanup of include/hal_intf.h
      staging: r8188eu: Eliminate enum ODM_RADIO_PATH in favor of rf_radio_path
      staging: r8188eu: Fix sparse warning in core/rtw_sta_mgt.c
      staging: r8188eu: Fix sparse warning in core/rtw_pwrctrl.c
      staging: r8188eu: Fix sparse warning in core/rtw_xmit.c
      staging: r8188eu: Fix sparse warnings in core/rtw_br_ext.c
      staging: r8712u: Set device type to wlan

Lars-Peter Clausen (20):
      iio:ad5504: Mark transfer buffers as __be16
      iio:ad5504: Do not store transfer buffers on the stack
      iio:ad5421: Mark transfer buffer as __be32
      iio:ad5686: Mark transfer buffer as __be32
      iio:ad5755: Mark transfer buffer as __be32
      iio:ad5791: Mark transfer buffers as __be32
      iio:ad5791: Do not store transfer buffers on the stack
      iio:ad7266: Mark transfer buffer as __be16
      iio:vcnl4000: Mark transfer buffer as __be16
      staging:iio:ad7280a: Mark transfer buffer as __be32
      staging:iio:ad7280a: Do not store transfer buffer on the stack
      staging:iio:ad7746: Mark transfer buffer as __be32
      staging:iio:ad7746: Do not store the transfer buffer on the stack
      iio: Add data_available callback for buffers
      iio: kfifo_buf: Implement data_available() callback
      iio: Add support for blocking IO on buffers
      staging:iio:ad9832: Mark transfer buffers as __be16
      staging:iio:ad9834: Mark transfer buffers as __b16
      iio:cm36651: Convert to new event config interface
      iio: Remove support for the legacy event config interface

Laura Abbott (4):
      gpu: ion: Loop on the handle count when destroying
      gpu: ion: Map only the vma size given
      gpu: ion: Don't call ion_buffer_put on error path
      staging: lustre: Use is_vmalloc_addr

Li Xi (1):
      staging/lustre/llog: fix return value of llog_alloc_handle

Lidza Louina (1):
      staging: dgap: uses kzalloc for allocating memory

Liu Ying (1):
      staging: imx-drm: imx-tve: Fix a sparse warning

Lothar Waßmann (1):
      imx-drm: parallel-display: honor 'native-mode' property when selecting video mode from DT

Lucas Stach (2):
      staging: drm/imx: handle framebuffer offsets correctly
      staging: drm/imx: don't drop crtc offsets when doing pageflip

Malcolm Priestley (32):
      staging: vt6656: device.h Remove typedef enum __device_init_type.
      staging: vt6656: Replace typedef struct _CMD_CARD_INIT
      staging: vt6656: Replace typedef struct _RSP_CARD_INIT.
      staging; vt6656: device_init_registers Change vnt_cmd_card_int and vnt_rsp_card_int to off stack
      staging: vt6656: cleanup device_init_registers
      staging: vt6656: main_usb.c ether_crc use kernel code
      staging: vt6656: Remove always 0 variable dwDiagRefCount
      staging: vt6656: csBeacon_xmit merge structures.
      staging: vt6656: vnt_beacon_buffer attach mac header.
      staging: vt6656: Remove unused variable bLongHeader
      staging: vt6656: Remove unused variable bAES.
      staging: vt6656: remove void pointer from s_vGetFreeContext
      staging: vt6656: s_vGetFreeContext remove pReturnContext
      staging: vt6656: clean up s_vGetFreeContext
      staging: vt6656: baseband.c clean up BBbVT3184Init
      staging: vt6656: Remove STAvUpdateTDStatCounter and apply directly to stats
      staging: vt6656: Get wireless stats qual.qual directly from s_uCalculateLinkQual
      staging: vt6656: s_uCalculateLinkQual use netstats rx values
      staging: vt6656: Replace pStatistic->abyTxPktInfo with struct vnt_tx_pkt_info
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning
      staging: vt6656: Move double definition of MAX_RATE to device_cfg.h
      staging: vt6656: dead code remove mib.c mic.h from driver.
      staging: vt6656: Remove unused scStatistic data/functions from driver.
      staging: vt6656: clean up CARDbSetMediaChannel.
      staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT
      staging: vt6656: CARDqGetNextTBTT replace code using do_div.
      staging: vt6656: rxtx.c Camel case and clean up s_uGetTxRsvTime
      staging: vt6656: rxtx.c Camel case and clean up s_uGetRTSCTSRsvTime
      staging: vt6656: sparse fixes: dpc.c missing dpc.h
      staging: vt6656: sparse fixes ethtool_ioctl Use struct ifreq *
      staging: vt6656: sparse fixes: iwctl_siwgenie use memcpy.
      staging: vt6656: sparse fixes: iwctl_giwgenie use memcpy.

Mark Einon (7):
      staging: et131x: improve indenting in et131x_adjust_link()
      staging: et131x: Remove unnecessary phydev checks
      staging: et131x: replace magic number bitmask with defined values
      staging: et131x: clear up use of TRUEPHY defines
      staging: et131x: remove two useless debug statements
      staging: et131x: remove unhelpful comments
      staging: et131x: trivial whitespace and line / character reductions

Martin Hofmann (6):
      vt6655: balance faulty parentheses in 80211hdr.h
      vt6655: remove casts in wroute.c
      vt6655: remove unnecessary braces in wroute.c
      vt6655: fix indentation in wroute.c
      vt6655: remove typedefs in wpactl.h
      vt6655: fix printk usage in wpactl.c

Martyn Welch (2):
      VME: Provide access to VME bus enumeration and fix vme_user match function
      VME: Rename vme_slot_get to avoid confusion with reference counting

Masanari Iida (26):
      staging: android: Fix typo in android/sync.h
      staging: sb105x: Fix typo in sb105x
      staging: crystalhd: Fix typo in crystalhd
      staging: dgap: Fixed trailing white space from dgap_conf.h
      staging: lustre: Fix typo in lustre/lnet/selftest
      staging: lustre: Fix typo in lustre/lustre/lov
      staging: lustre: Fix typo in lustre/lustre/lmv
      staging: lustre: Fix typo in lustre/lustre/osc
      staging: lustre: Fix typo in lustre/lustre/fld and ldlm
      staging: lustre: Fix typo in lustre/lustre/libcfs
      staging: dgrp: Fix space prohibited before semicolon
      staging: gdm72xx: Fix WARNING space prohibited before semicolon in gdm_qos.c
      staging: keucr: Fix typo in keucr driver
      staging: dgap: Fix trailing whitespace in downld.c
      staging: dgap: Fix trailing whitespace in dgap_tty.c
      staging: dgap: Fix trailing whitespace in dgap_trace.c
      lustre: Fix space required before the open parenthesis in mgc_required.c
      staging: lustre: Fix brace {} are not necessary for single statement blocks
      staging: lustre: Fix do not use C99 // comments in mgc_request.c
      staging: lustre: Fix space prohibited between function name and open parenthesis in lcommon_cl.c
      staging: lustre: Fix do not use C99 // comments in lcommon_cl.c
      staging: lustre: Remove braces for single statement in kernel_user_comm.c
      staging: rtl8187se: Fix space prohibited before semicolon in r8180_core.c and r8180.h
      staging: rtl8187se: Fix trailing whitespace in r8180_hw.h and r8180_wx.c
      staging: bcm : Fix typo in staging/bcm
      staging: wlags49_h2: Fix "do not use C99 //" in wl_cs.h, wl_enc.h wl_main.h and wl_wext.h

Matina Maria Trompouki (3):
      Staging: ozwpan: fixed whitespace before semicolon
      Staging: lirc: fix quoted string split across lines
      Staging: lirc: fix line over 80 characters

Matthias Oefelein (6):
      beeceem: Fix missing spaces around operators and unwanted spaces around semicolons in InterfaceRx.c
      beeceem: Fix missing spaces between function arguments in InterfaceRx.c
      beeceem: Fix broken indentations in InterfaceRx.c
      beeceem: Fix whitespace issues at opening parentheses in InterfaceRx.c
      beeceem: Fix newline issues at opening braces of conditional statements in InterfaceRx.c
      beeceem: Replace C99 comments with C89 ones and remove unneeded comments in InterfaceRx.c

Matthias Schoepe (1):
      Staging rtl8192e: Fixing checkpatch errors

Matthias Wirth (3):
      rtl8188eu: fix whitespace and indentation
      rtl8188eu: fix coding style
      rtl8188eu: remove unused code

Michael Hoefler (3):
      silicom: fix whitespace issues in bypass.c
      silicom: fix coding style issues in bypass.c
      silicom: remaining checkpatch issues in bypass.c

Michal Kwiatkowski (1):
      Staging: comedi: amcc_s5933: "no space before tabs" coding style fixes.

Michal Nazarewicz (2):
      staging: silicom: remove dead code
      staging: lustre: fix potential NULL pointer dereference

Micky Ching (1):
      staging: rts5208: add support for rts5208 and rts5288

Mikhail Pershin (4):
      staging/lustre/server: use unified request handler for MGS
      staging/lustre/llog: MGC to use OSD API for backup logs
      staging/lustre/target: move OUT to the unified target code
      staging/lustre/seq: remove seq_{query,handle}

Minchan Kim (1):
      zsmalloc: add Kconfig for enabling page table method

Mitchel Humpherys (1):
      gpu: ion: fix use-after-free in ion_heap_freelist_drain

Morgan Creekmore (1):
      Staging: rts5139: rts51x_card: fixed style issues

Nandini Hanumanthagowda (15):
      staging: vt6656: fixed whitespace related errors around operators
      staging: bcm: removed prohibited space before semicolon
      staging: bcm: fixed space related errors around operators
      staging: ctxt1e1: Fixed sparse warning related to static declaration
      staging: vt6656: removed unnecessary braces around if-else statements
      staging: vt6656: fixed open brace placement related error
      staging: vt6656: fixed checkpatch errors related to close brace
      staging: vt6656: fixed unnecessary whitespace warning
      staging: vt6656: fixed the switch case indentation level error
      staging: vt6656: indented all if-else statement blocks
      staging: vt6656: indented the code under all function blocks
      staging: vt6656: removed parenthesis from return statement
      staging: vt6656: removed all whitespace errors
      staging: vt6656: added space after coma operator in funtion call
      staging: vt6656: removed the trailing statement should be on next line error

NeilBrown (1):
      iio:magnetometer:hmc5843 - add basic dt support

Nick Hudson (1):
      staging: dwc2: don't issue traffic to LS devices in FS mode

Nitin Cupta (1):
      zsmalloc: add more comment

Olav Haugan (3):
      gpu: ion: Add missing argument to WARN call
      gpu: ion: Add EXPORT_SYMBOL to functions
      gpu: ion: IOCTL return success when error occurs

Patrick Farrell (1):
      staging/lustre/nfs: writing to new files will return ENOENT

Paul Gortmaker (2):
      lustre: delete pointless wait queue related casts.
      staging: delete non-required instances of include <linux/init.h>

Paul Zimmerman (15):
      staging: dwc2: fix some functions to return a proper error code
      staging: dwc2: fix potential use after free
      staging: dwc2: rename DWC2_PARAM_TEST to DWC2_OUT_OF_BOUNDS
      staging: dwc2: make all the dwc2_set_param* functions void
      staging: dwc2: remove use of NO_FS_PHY_HW_CHECKS macro
      staging: dwc2: remove useless cast
      staging: dwc2: rename dwc2_check_core_status()
      staging: dwc2: remove #ifdef DEBUG from a couple of places
      staging: dwc2: remove stale comment after changing function to void
      staging: dwc2: fix screwup in checking return value
      staging: dwc2: fix thinko in dwc2_fill_host_dma_desc()
      staging: dwc2: fix useless test for non-0
      staging: dwc2: move function to more logical place
      Move DWC2 driver out of staging
      usb: dwc2: move device tree bindings doc to correct place

Peng Tao (43):
      staging/lustre/llite: restore ll_fiemap
      staging/lustre: remove lu_target.h
      staging/lustre: remove llog_server.c
      drivers/staging/lustre: indent lustre_ldlm_flags_vals
      staging/lustre/libcfs: remove HAVE_MM_INLINE
      staging/lustre: remove liblustreapi.h
      staging/lustre: remove lustreapi.h
      staging/lustre: remove fsfilt_ext3.c
      staging/lustre/o2iblnd: remove kib_sysctl
      staging/lustre/socklnd: remove ksnd_sysctl
      staging/lustre: remove CFS_SYSFS_MODULE_PARM
      staging/lustre/libcfs: remove IOCTL_LIBCFS_TYPE
      staging/lustre: remove __CYGWIN__
      staging/lustre: remove _LWORDSIZE
      staging/lustre: get_cpu is always defined
      staging/lustre: remove INIT_CTL_NAME
      staging/lustre: remove INIT_STRATEGY
      staging/lustre/libcfs: remove filp_size/filp_poff
      staging/lustre/libcfs: remove filp_fsync
      staging/lustre/libcfs: remove filp_read
      staging/lustre/libcfs: remove filp_write
      staging/lustre: move IFTODT/DTTOIF to lustre_idl.h
      staging/lustre/libcfs: remove flock wrappers
      staging/lustre/libcfs: remove linux-fs.h
      staging/lustre/libcfs: remove lwt code
      staging/lustre: remove CFS_MODULE_PARM
      staging/lustre/libcfs: remove LI_POISON
      staging/lustre/obdclass: add empty tailing member to ctl_table
      staging/lustre: fix build error on i386-randconfig
      staging/lustre: fix build error when CONFIG_FS_POSIX_ACL is off
      staging/lustre: remove wirehdr.c
      Revert "staging/lustre/nfs: writing to new files will return ENOENT"
      staging/lustre/obdclass: fix false used uninitialized warning
      staging/lustre/obdclass: lprocfs_{alloc_stats,register} always defined
      staging/lustre/ldlm: inline ldlm_proc_setup
      staging/lustre/obdclass: move obd_sysctl_init out of class_procfs_init
      staging/lustre: fix defined not used warning
      staging/lustre/llite: fix used uninitialized warning
      staging/lustre: fix build error in ll_setxattr_common
      staging/lustre/llite: remove ll_file_get_iov_count
      staging/lustre: fix undefined reference if CONFIG_PROC_FS is off
      staging/lustre: don't compile procfs code when CONFIG_PROC_FS is off
      staging/lustre: remove server macros from lustre_net.h

Peter Meerwald (4):
      iio: Drop scan_type from viperboard adc driver
      iio: Minor kerneldoc fix for iio_trigger_write_current()
      iio: Remove redundant check that new trigger is different from old
      iio: Add Freescale MPL3115A2 pressure / temperature sensor driver

Philipp Zabel (1):
      staging: drm/imx: set second plane base address

Preetam D'Souza (1):
      Staging: rts5139: fix parantheses coding style issue in ms.c

Ralph Mueck (4):
      beeceem: Fix several whitespace issues in InterfaceTx.c
      beeceem: Add spaces before opening parentheses in if-conditionals in InterfaceTx.c
      beeceem: Fix position of braces in conditional statements in InterfaceTx.c
      beeceem: Replace C99-style comments with C89 pendants in InterfaceTx.c

Rashika Kheria (64):
      Staging: rtl8187se: Fix C99 style commenting in dot11d.c
      Staging: rtl8187se: Fix printk() should include KERN_ facility level
      Staging: rtl8187se: Fix space prohibited before semicolon in dot11d.c
      Staging: rtl8187se: Remove unnecessary braces around single statement in dot11d.c
      Staging: rtl8187se: Fix line over 80 characters in dot11d.c
      Staging: rtl8187se: Remove unnecessary comments in ieee80211_crypt_ccmp.c
      Staging: rtl8187se: Fix quoted strings split across lines in ieee80211_crypt_ccmp.c
      Staging: rtl8187se: Remove useless comments in ieee80211_crypt_tkip.c
      Staging: rtl8187se: Replace "foo * bar" with "foo *bar" in ieee80211_crypt_tkip.c
      Staging: rtl8187se: Fix code indent should use tabs in ieee80211_crypt_tkip.c
      Staging: rtl8187se: Remove unnecessary return statement in ieee80211_crypt_tkip.c
      Staging: rtl8187se: Remove useless comments in dot11d.c
      Staging: keucr: Fix externs are avoided in smilmain.c
      Staging: keucr: Fix externs are avoided in smilsub.c
      Staging: keucr: Fix externs are avoided in smscsi.c
      Staging: rtl8192e: Fix incorrect type in assignment in rtllib_rx.c
      Staging: rtl8192e: Fix Sparse warning of restricted __le16 degrades to integer in rtllib_rx.c
      Staging: rtl8192e: Fix incorrect casting in rtllib_rx.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtllib_module.c
      Staging: rtl8192e: Fix incorrect type in assignment in rtllib_tx.c
      Staging: rtl8192e: Fix Sparse Warning of restricted __le16 degrades to integer in rtllib_tx.c
      Staging: rtl8192e: Fix Sparse warning of restricted __le16 degrades to integer in rtllib_softmac.c
      Staging: rtl8192e: Fix Sparse Warning of invalid assignment '|=' in rtllib_softmac.c
      Staging: rtl8192e: Fix incorrect type in assignment in rtllib_softmac.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtllib_softmac.c
      Staging: rtl8192e: Fix incorrect type in assignment in rtl819x_BAProc.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtllib_crypt_ccmp.c
      Staging: rtl8192e: Fix Sparse warning of cast to restricted __le16 in rtllib_crypt_tkip.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtllib_crypt_tkip.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtllib_crypt_wep.c
      Staging: rtl8192e: Fix Sparse warning of cast from restricted __le16 in r8192E_dev.c
      Staging: rtl8192e: Fix incorrect type in assignment in r8192E_dev.c
      Staging: rtl8192e: Fix Sparse Warning for Static Declarations in rtl_core.c
      Staging: rtl8192e: Fix incorrect type in assignment in rtl_core.c
      Staging: rtl8192e: Fix Sparse warning of cast to restricted __le32 in rtl_core.c
      Staging: tidspbridge: Fix foo ** bar should be foo **bar in cmm.c
      Staging: tidspbridge: Fix quoted string split across lines in cmm.c
      Staging: tidspbridge: Fix quoted string split across line in dbll.c
      Staging: tidspbridge: Fix no space before tabs in dbll.c
      Staging: tidspbridge: Fix no space at the start of the line in dbll.c
      Staging: tidspbridge: Fix foo * bar should be foo *bar in dev.c
      Staging: tidspbridge: Fix no space at the start of the line in dev.c
      Staging: tidspbridge: Fix quoted string split across line in dmm.c
      Staging: tidspbridge: Remove unnecessary white space before a quoted newline in dmm.c
      Staging: tidspbridge: Prefer dev_info() then printk() in dmm.c
      Staging: tidspbridge: Fix foo * bar should be foo *bar in dspapi.c
      Staging: gdm724x: Remove confusing macro gdm_lte_rcv_with_cb in gdm_lte.c
      Staging: gdm724x: Remove confusing macro gdm_dev_endian in gdm_lte.c
      Staging: gdm724x: Remove confusing macro gdm_lte_hci_send in gdm_lte.c
      Staging: gdm724x: Use ALIGN() macro for dummy_cnt in gdm_mux.c
      Staging: keucr: Move the declaration of variable ErrXDCode in smilsub.c
      Staging: keucr: Move the declaration of variable ErrCode in smilmain.c
      Staging: keucr: Move the declaration of variable IsSSFDCCompliance in smilsub.c
      Staging: keucr: Move the declaration of variable IsXDCompliance in smilsub.c
      Staging: dgrp: Refactor the function dgrp_receive() in drrp_net_ops.c
      Staging: gdm724x: Remove confusing macro gdm_lte_sdu_send in gdm_lte.c
      Staging: tidspbridge: Remove unnecessary newline character in dmm.c
      drivers: dgap: Include appropriate header file in dgap_trace.c
      drivers: dgap: Include appropriate header file in dgap_parse.c
      drivers: sm7xxfb: Mark function as static in sm7xxfb.c
      drivers: sbe-2t3e3: Mark functions as static in ctrl.c
      drivers: bcm: Mark functions as static in Qos.c
      drivers: bcm: Remove unused function in nvm.c
      drivers: dgnc: Include appropriate header file in dgnc_trace.c

Rebecca Schultz Zavin (50):
      gpu: ion: Add ION Memory Manager
      ion: Switch map/unmap dma api to sg_tables
      ion: Add reserve function to ion
      ion: Switch ion to use dma-buf
      gpu: ion: Use alloc_pages instead of vmalloc from the system heap
      gpu: ion: support begin/end and kmap/kunmap dma_buf ops
      gpu: ion: Allocate the sg_table at creation time rather than dynamically
      gpu: ion: Get an sg_table from an ion handle
      gpu: ion: Set the dma_address of the sg list at alloc time
      gpu: ion: ion_system_heap: Change allocations to GFP_HIGHUSER
      gpu: ion: Add cache maintenance to ion.
      gpu: ion: Modify the system heap to try to allocate large/huge pages
      gpu: ion: Add explicit sync ioctl
      gpu: ion: Only map as much of the vma as the user requested
      gpu: ion: Switch to using kmalloc rather than kmap during allocation
      gpu: ion: Fix race between ion_import and ion_free
      gpu: ion: Fix bug in ion_free
      gpu: ion: Add debug information for orphaned handles
      gpu: ion: Fix memory leak of dirty bits
      gpu: ion: Add support for cached mappings that don't fault
      gpu: ion: optimize system heap for non fault buffers
      gpu: ion: Stop trying to allocate from an order on first failure
      gpu: ion: ion_system_heap: Fix bug preventing compilation
      gpu: ion: use vmalloc to allocate page array to map kernel
      gpu: ion: Add ion_page_pool.
      gpu: ion: Use the ion_page_pool from the system heap
      gpu: ion: Modify gfp flags in ion_system_heap
      gpu: ion: Fix several issues with page pool
      gpu: ion: Fix lockdep issue in ion_page_pool
      gpu: ion: Switch to using a single shrink function
      gpu: ion: Refactor locking
      gpu: ion: Clear GFP_WAIT flag on high order allocations
      gpu: ion: Don't flush allocatoins that come from the page pools
      gpu: ion: Fix bug in ion_system_heap map_user
      gpu: ion: Fix bug in zeroing pages in system heap
      gpu: ion: Modify reserve function for carveouts with no start address
      gpu: ion: Fix bug where MAP ioctl was no longer supported
      gpu: ion: Switch heap rbtree to a prio list
      gpu: ion: Refactor common mapping functions out of system heap
      gpu: ion: Add chunk heap
      gpu: ion: Clarify variable names and comments around heap ids v types
      gpu: ion: Remove heapmask from client
      gpu: ion: Modify zeroing code so it only allocates address space once
      gpu: ion: Refactor the code to zero buffers
      gpu: ion: Only flush buffers in the chunk heap if they were used cached
      gpu: ion: Make ion_free asynchronous
      gpu: ion: ion_chunk_heap: Zero chunk heap memory at creation time
      gpu: ion: Fix bug in ion shrinker
      gpu: ion: Also shrink memory cached in the deferred free list
      gpu: ion: Fix performance issue in faulting code

Rom Lemarchand (3):
      ion: add new ion_user_handle_t type for the user-space token
      ion: change ion_user_handle_t definition to int
      ion: add compat_ioctl

Rostislav Lisovy (1):
      comedi: Humusoft MF634 and MF624 DAQ cards driver

Rupert Muchembled (2):
      Staging: silicom: Remove unnecessary variable from do_cmd()
      Staging: silicom: Remove unnecessary variable from get_bypass_info()

Sachin Kamat (18):
      iio: core: Implement devm_iio_device_{register,unregister}
      iio: core: Move kernel doc to the right location
      iio: adc: mcp3422: Use devm_iio_device_register
      iio: adc: viperboard: Use devm_iio_device_register
      iio: dac: ad5421: Use devm_iio_device_register
      iio: dac: ad5755: Use devm_iio_device_register
      iio: gyro: adis16130: Use devm_iio_device_register
      iio: gyro: adxrs450: Use devm_iio_device_register
      iio: light: vcnl4000: Use devm_iio_device_register
      staging: iio: adis16220: Use devm_iio_device_register
      staging: iio: ad7816: Use devm_iio_device_register
      staging: iio: lpc32xx_adc: Use devm_iio_device_register
      staging: iio: addac: Use devm_iio_device_register
      staging: iio: adis16060: Use devm_iio_device_register
      staging: iio: isl29018: Use devm_iio_device_register
      staging: iio: ad2s1200: Use devm_iio_device_register
      iio: cm36651: Remove redundant of_match_ptr helper
      staging: iio: hmc5843: Remove redundant of_match_ptr helper

Salym Senyonga (4):
      staging: lustre: libcfs_debug.h: align define values
      staging: lustre: libcfs_debug.h: Align backslashes in macros
      staging: lustre: libcfs_debug.h: remove extra blank lines
      staging: lustre: libcfs_debug: small whitespace cleanups

Samuel Domínguez (1):
      staging: lustre: lnet: lnet: fixed space coding style issues

Sebastian Rachuj (2):
      Staging: vt6656: Remove bogus parentheses in conditions
      Staging: vt6656: Remove explicit comparisons against NULL

Sebastian Reichel (1):
      iio:light:tsl2563: Add DT support

SeongJae Park (3):
      staging: alarm-dev: Remove unnecessary parenthesis
      staging: alarm-dev: Remove unnecessary blank lines
      staging: alarm-dev: Seperate functions with one blank line

Sima Baymani (6):
      staging: cxt1e1: comet.h - fix wrong indentation
      staging: cxt1e1: comet.h - fix long lines warning
      staging: cxt1e1: comet,h - fix placement of braces
      staging: cxt1e1: remove typedef comet_t
      staging: cxt1e1: fix long lines warning
      staging: imx-drm: remove unnecessary braces

Simon Schuster (11):
      Staging: vt6656: Fix indentation of bssdb.c
      Staging: vt6656: Adjust comments in bssdb.c
      Staging: vt6656: Remove unnecessary semicolons
      Staging: vt6656: Correct operator coding style
      Staging: vt6656: Correct single space mistakes
      Staging: vt6656: Remove line feeds before else
      Staging: vt6656: Remove unnecessary spaces in format strings
      Staging: vt6656: Combine "else { if" to "else if"
      Staging: vt6656: Correct usage of braces
      Staging: vt6656: Combined nested conditions
      Staging: vt6656: Reduce line length of bssdb.c

Srinivas Pandruvada (5):
      iio: hid-sensors: accelerometer: Add sensitivity
      iio: hid-sensors: gyro : Add sensitivity
      iio: hid-sensors: light/als : Add sensitivity
      iio: hid-sensors: magnetometer : Add sensitivity
      iio: hid-sensors: Added Inclinometer 3D

Stephen Warren (2):
      staging: dwc2: set up all module params
      staging: dwc2: disable uframe_sched on the bcm2835

Steven Luo (1):
      Staging: TIDSPBRIDGE: Fix mmap to map the correct region of physical memory

Teodora Baluta (19):
      staging: lustre: remove space between function name and open parenthesis
      staging: lustre: place EXPORT_SYMBOL after its function
      staging: lustre: remove initialisation of static variable
      staging: vt6655: replace C99 comments wtih C89 comments
      staging: vt6655: remove braces for single statement blocks
      staging: vt6655: put trailing statements on next line
      staging: vt6655: put brace on previous line
      staging: vt6655: delete explicit comparison to bool
      staging: vt6655: fix assignment of bool to 0
      staging: vt6655: fix comparison of bool to 0/1
      staging: vt6655: remove unneeded semicolon
      staging: usbip: fix sparse warnings regarding endianness
      staging: rtl8188eu: correct code alignment
      staging: rtl8188eu: remove unneeded semicolon
      staging: comedi: remove unneeded semicolon
      staging: comedi: change bool assignment to true
      staging: vt6655: use netdev_* instead of printk
      staging: vt6655: delete unnecessary whitespace before a quoted newline
      staging: vt6655: delete explicit comparison to bool

Tim Jester-Pfadt (6):
      Staging: rtl8188eu: Fixed coding style issues
      Staging: rtl8188eu: Fixed coding style issues
      Staging: rtl8188eu: Fixed spaces before tabs and before close parentheses
      Staging: rtl8188eu: Fixed whitespace related coding style issues
      Staging: rtl8188eu: Fixed required spaces after ',' and around '=' and '=='
      Staging: rtl8188eu: Fixed "foo * bar" related coding style issues

Valentina Manea (3):
      staging: vt6656: Fix (most) sparse warnings regarding static functions/variables
      staging: crystalhd: return true and false instead of 1 and 0
      staging: usbip: userspace: add support for viewing imported devices

Vincent Stehlé (2):
      staging: dgap: fix missing header inclusion
      staging: dgap: fix checkpatch warnings

Wei Yongjun (8):
      staging: rts5208: fix error return code in rtsx_probe()
      staging: dwc2: fix sparse non static symbol warning
      gpu: ion: use module_platform_driver to simplify the code
      gpu: ion: fix sparse non static symbol warnings
      staging: xillybus: fix error return code in xilly_probe()
      staging: lustre: fix return value check in capa_hmac()
      staging: sep: add missing destroy_workqueue() in sep_crypto.c
      Staging: silicom: fix sparse non static symbol warnings

Wenliang Fan (1):
      drivers/staging/bcm: Integer overflow

ZHAO Gang (11):
      staging: et131x: change function name
      staging: et131x: delete unnecessary variable in function et131x_init
      staging: et131x: reduce split lines in et131x_config_rx_dma_regs
      staging: et131x: reduce split lines in et131x_rx_dma_memory_alloc
      staging: et131x: reduce split lines in et131x_rx_dma_memory_free
      staging: et131x: reduce split lines in nic_return_rfd
      staging: et131x: reduce split lines in nic_rx_pkts
      staging: et131x: remove item that have been done in TODO file
      staging: et131x: remove unnecessary pointer typecast
      staging: et131x: improve code consistency: access struct rx_ring
      staging: et131x: improve code consistency: access struct tx_ring

stalinsrinivasan.s (3):
      staging: dgnc: fix 80 characters per line limitation and code indent warnings.
      staging: dgnc: fix checkpatch.pl usage of volatile.
      staging: dgnc: fix checkpatch.pl usage of comparison with jiffies

 Documentation/ABI/testing/sysfs-bus-iio            |   13 +
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 .../devicetree/bindings/iio/humidity/dht11.txt     |   14 +
 .../devicetree/bindings/iio/light/tsl2563.txt      |   19 +
 .../bindings/iio/magnetometer/hmc5843.txt          |   17 +
 .../devicetree/bindings/staging/xillybus.txt       |   20 +
 .../devicetree/bindings/{staging => usb}/dwc2.txt  |    4 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/driver-model/devres.txt              |    2 +
 Documentation/vme_api.txt                          |   12 +-
 MAINTAINERS                                        |    2 +-
 drivers/iio/Kconfig                                |    2 +
 drivers/iio/Makefile                               |    2 +
 drivers/iio/accel/bma180.c                         |    7 +-
 drivers/iio/accel/hid-sensor-accel-3d.c            |   12 +
 drivers/iio/adc/ad7266.c                           |   21 +-
 drivers/iio/adc/max1363.c                          |    8 +-
 drivers/iio/adc/mcp3422.c                          |    9 +-
 drivers/iio/adc/viperboard_adc.c                   |   20 +-
 drivers/iio/dac/ad5064.c                           |    7 +-
 drivers/iio/dac/ad5360.c                           |    7 +-
 drivers/iio/dac/ad5380.c                           |    7 +-
 drivers/iio/dac/ad5421.c                           |   26 +-
 drivers/iio/dac/ad5446.c                           |    9 +-
 drivers/iio/dac/ad5449.c                           |    7 +-
 drivers/iio/dac/ad5504.c                           |   46 +-
 drivers/iio/dac/ad5624r_spi.c                      |    7 +-
 drivers/iio/dac/ad5686.c                           |   11 +-
 drivers/iio/dac/ad5755.c                           |   21 +-
 drivers/iio/dac/ad5764.c                           |    7 +-
 drivers/iio/dac/ad5791.c                           |   55 +-
 drivers/iio/dac/max517.c                           |    1 -
 drivers/iio/dac/mcp4725.c                          |    1 -
 drivers/iio/gyro/adis16130.c                       |    9 +-
 drivers/iio/gyro/adxrs450.c                        |   14 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   11 +
 drivers/iio/humidity/Kconfig                       |   15 +
 drivers/iio/humidity/Makefile                      |    5 +
 drivers/iio/humidity/dht11.c                       |  294 ++
 drivers/iio/industrialio-buffer.c                  |   33 +-
 drivers/iio/industrialio-core.c                    |  102 +
 drivers/iio/industrialio-event.c                   |  160 +-
 drivers/iio/industrialio-trigger.c                 |   40 +-
 drivers/iio/kfifo_buf.c                            |   23 +-
 drivers/iio/light/Kconfig                          |   11 +
 drivers/iio/light/Makefile                         |    1 +
 drivers/iio/light/adjd_s311.c                      |    7 +-
 drivers/iio/light/apds9300.c                       |    8 +-
 drivers/iio/light/cm32181.c                        |  379 ++
 drivers/iio/light/cm36651.c                        |   35 +-
 drivers/iio/light/gp2ap020a00f.c                   |    8 +-
 drivers/iio/light/hid-sensor-als.c                 |   11 +
 drivers/iio/light/tcs3472.c                        |    7 +-
 drivers/iio/light/tsl2563.c                        |   12 +-
 drivers/iio/light/vcnl4000.c                       |   11 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |   12 +
 drivers/iio/magnetometer/mag3110.c                 |    6 +-
 drivers/iio/orientation/Kconfig                    |   19 +
 drivers/iio/orientation/Makefile                   |    6 +
 drivers/iio/orientation/hid-sensor-incl-3d.c       |  428 ++
 drivers/iio/pressure/Kconfig                       |   12 +
 drivers/iio/pressure/Makefile                      |    1 +
 drivers/iio/pressure/mpl3115.c                     |  329 ++
 drivers/staging/Kconfig                            |    6 +-
 drivers/staging/Makefile                           |    3 +-
 drivers/staging/android/Kconfig                    |    2 +
 drivers/staging/android/Makefile                   |    2 +
 drivers/staging/android/alarm-dev.c                |    8 +-
 drivers/staging/android/ion/Kconfig                |   35 +
 drivers/staging/android/ion/Makefile               |   10 +
 drivers/staging/android/ion/compat_ion.c           |  177 +
 drivers/staging/android/ion/compat_ion.h           |   30 +
 drivers/staging/android/ion/ion.c                  | 1549 +++++++
 drivers/staging/android/ion/ion.h                  |  204 +
 drivers/staging/android/ion/ion_carveout_heap.c    |  194 +
 drivers/staging/android/ion/ion_chunk_heap.c       |  195 +
 drivers/staging/android/ion/ion_cma_heap.c         |  218 +
 drivers/staging/android/ion/ion_dummy_driver.c     |  158 +
 drivers/staging/android/ion/ion_heap.c             |  318 ++
 drivers/staging/android/ion/ion_page_pool.c        |  195 +
 drivers/staging/android/ion/ion_priv.h             |  360 ++
 drivers/staging/android/ion/ion_system_heap.c      |  488 +++
 drivers/staging/android/ion/ion_test.c             |  282 ++
 drivers/staging/android/ion/tegra/Makefile         |    1 +
 drivers/staging/android/ion/tegra/tegra_ion.c      |   84 +
 drivers/staging/android/sync.h                     |   50 +-
 drivers/staging/android/uapi/ion.h                 |  196 +
 drivers/staging/android/uapi/ion_test.h            |   70 +
 drivers/staging/bcm/Adapter.h                      |    2 +-
 drivers/staging/bcm/Bcmchar.c                      |  142 +-
 drivers/staging/bcm/DDRInit.c                      | 2042 +++++----
 drivers/staging/bcm/InterfaceDld.c                 |  140 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |  230 +-
 drivers/staging/bcm/InterfaceInit.c                |   10 +-
 drivers/staging/bcm/InterfaceRx.c                  |  187 +-
 drivers/staging/bcm/InterfaceTx.c                  |  151 +-
 drivers/staging/bcm/PHSModule.c                    |    4 +-
 drivers/staging/bcm/Qos.c                          |    6 +-
 drivers/staging/bcm/nvm.c                          |   80 +-
 drivers/staging/btmtk_usb/Kconfig                  |   11 -
 drivers/staging/btmtk_usb/Makefile                 |    1 -
 drivers/staging/btmtk_usb/README                   |   14 -
 drivers/staging/btmtk_usb/TODO                     |   10 -
 drivers/staging/btmtk_usb/btmtk_usb.c              | 1810 --------
 drivers/staging/btmtk_usb/btmtk_usb.h              |  138 -
 drivers/staging/ced1401/ced_ioc.c                  |    3 +-
 drivers/staging/ced1401/usb1401.c                  |    1 -
 drivers/staging/comedi/Kconfig                     |    6 +
 drivers/staging/comedi/Makefile                    |    2 +
 drivers/staging/comedi/comedi_buf.c                |   99 +-
 drivers/staging/comedi/comedi_fops.c               |  527 ++-
 drivers/staging/comedi/comedi_internal.h           |    4 +
 drivers/staging/comedi/comedidev.h                 |   40 +-
 drivers/staging/comedi/drivers.c                   |   34 +-
 drivers/staging/comedi/drivers/8255.c              |    6 +-
 drivers/staging/comedi/drivers/8255_pci.c          |    2 +-
 drivers/staging/comedi/drivers/Makefile            |    2 +
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    6 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    6 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   36 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   89 +-
 drivers/staging/comedi/drivers/adq12b.c            |   29 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  128 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |    6 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    2 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   13 +-
 drivers/staging/comedi/drivers/amcc_s5933.h        |    8 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |    2 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |    2 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    4 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   62 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  109 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |    2 +-
 drivers/staging/comedi/drivers/c6xdigio.c          |   54 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |   57 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  270 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   19 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    9 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    2 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |    2 +-
 drivers/staging/comedi/drivers/das08.c             |   75 +-
 drivers/staging/comedi/drivers/das08_pci.c         |    2 +-
 drivers/staging/comedi/drivers/das16m1.c           |  107 +-
 drivers/staging/comedi/drivers/das1800.c           |  139 +-
 drivers/staging/comedi/drivers/das6402.c           |   11 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   94 +-
 drivers/staging/comedi/drivers/dt2801.c            |  109 +-
 drivers/staging/comedi/drivers/dt2811.c            |  149 +-
 drivers/staging/comedi/drivers/dt2814.c            |   70 +-
 drivers/staging/comedi/drivers/dt2815.c            |   19 +-
 drivers/staging/comedi/drivers/dt282x.c            |  188 +-
 drivers/staging/comedi/drivers/dt3000.c            |   54 +-
 drivers/staging/comedi/drivers/dt9812.c            |    1 -
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   16 +-
 drivers/staging/comedi/drivers/fl512.c             |   21 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   80 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   15 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    2 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |   52 +-
 drivers/staging/comedi/drivers/me_daq.c            |    2 +-
 drivers/staging/comedi/drivers/mf6x4.c             |  354 ++
 drivers/staging/comedi/drivers/mite.c              |  145 +-
 drivers/staging/comedi/drivers/mite.h              |   12 -
 drivers/staging/comedi/drivers/mpc624.c            |   19 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    2 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    7 +-
 drivers/staging/comedi/drivers/ni_660x.c           |  708 ++-
 drivers/staging/comedi/drivers/ni_670x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  111 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |   15 -
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   95 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |  631 +--
 drivers/staging/comedi/drivers/ni_mio_cs.c         |    2 -
 drivers/staging/comedi/drivers/ni_pcidio.c         |  179 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   63 +-
 drivers/staging/comedi/drivers/ni_tio.c            |  315 +-
 drivers/staging/comedi/drivers/ni_tio.h            |  209 +-
 drivers/staging/comedi/drivers/ni_tio_internal.h   |  431 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |   88 +-
 drivers/staging/comedi/drivers/pcl812.c            |  330 +-
 drivers/staging/comedi/drivers/pcl816.c            |  195 +-
 drivers/staging/comedi/drivers/pcl818.c            |  249 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    6 -
 drivers/staging/comedi/drivers/pcmmio.c            | 1476 +++----
 drivers/staging/comedi/drivers/pcmuio.c            |  428 +-
 drivers/staging/comedi/drivers/plx9080.h           |   13 +-
 drivers/staging/comedi/drivers/rtd520.c            |    7 +-
 drivers/staging/comedi/drivers/s626.c              |   21 +-
 drivers/staging/comedi/drivers/skel.c              |    2 +-
 drivers/staging/comedi/drivers/unioxx5.c           |   68 +-
 drivers/staging/comedi/drivers/usbdux.c            |    1 -
 drivers/staging/comedi/drivers/usbduxfast.c        |    6 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |    9 +-
 drivers/staging/comedi/kcomedilib/Makefile         |    2 +
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |   74 +-
 drivers/staging/comedi/proc.c                      |    6 +-
 drivers/staging/comedi/range.c                     |    9 +-
 drivers/staging/crystalhd/bc_dts_glob_lnx.h        |    2 +-
 drivers/staging/crystalhd/crystalhd_cmds.c         |    4 +-
 drivers/staging/crystalhd/crystalhd_cmds.h         |    2 +-
 drivers/staging/crystalhd/crystalhd_fw_if.h        |    2 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
 drivers/staging/crystalhd/crystalhd_hw.h           |    6 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.h          |    3 +-
 drivers/staging/crystalhd/crystalhd_misc.c         |    4 +-
 drivers/staging/crystalhd/crystalhd_misc.h         |    2 +-
 drivers/staging/cxt1e1/comet.c                     |   60 +-
 drivers/staging/cxt1e1/comet.h                     |  601 +--
 drivers/staging/cxt1e1/functions.c                 |    2 +-
 drivers/staging/cxt1e1/musycc.c                    |    4 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   10 +-
 drivers/staging/cxt1e1/pmcc4_private.h             |    2 +-
 drivers/staging/cxt1e1/sbeid.c                     |  323 +-
 drivers/staging/dgap/dgap_conf.h                   |    6 +-
 drivers/staging/dgap/dgap_driver.c                 |   18 +-
 drivers/staging/dgap/dgap_driver.h                 |    1 -
 drivers/staging/dgap/dgap_fep5.c                   |  112 +-
 drivers/staging/dgap/dgap_parse.c                  |    1 +
 drivers/staging/dgap/dgap_trace.c                  |   17 +-
 drivers/staging/dgap/dgap_tty.c                    |  180 +-
 drivers/staging/dgap/downld.c                      |  168 +-
 drivers/staging/dgnc/dgnc_cls.c                    |  253 +-
 drivers/staging/dgnc/dgnc_trace.c                  |   19 +-
 drivers/staging/dgrp/dgrp_driver.c                 |    1 -
 drivers/staging/dgrp/dgrp_net_ops.c                |  330 +-
 drivers/staging/dgrp/dgrp_tty.c                    |    4 +-
 drivers/staging/dwc2/TODO                          |   33 -
 drivers/staging/et131x/README                      |    4 -
 drivers/staging/et131x/et131x.c                    |  841 ++--
 drivers/staging/et131x/et131x.h                    |   40 -
 drivers/staging/frontier/alphatrack.c              |    1 -
 drivers/staging/frontier/tranzport.c               |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |  304 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |  766 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |    2 +
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  133 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      | 1309 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   14 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    5 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    5 -
 drivers/staging/gdm724x/gdm_lte.c                  |   44 +-
 drivers/staging/gdm724x/gdm_mux.c                  |    8 +-
 drivers/staging/gdm724x/gdm_tty.c                  |    1 -
 drivers/staging/gdm724x/gdm_usb.c                  |   40 +-
 drivers/staging/gdm72xx/gdm_qos.c                  |    2 +-
 drivers/staging/gdm72xx/gdm_usb.c                  |    5 +-
 drivers/staging/gdm72xx/sdio_boot.c                |    1 -
 drivers/staging/goldfish/goldfish_nand.c           |    1 -
 drivers/staging/iio/accel/adis16220_core.c         |    7 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |    8 +-
 drivers/staging/iio/accel/sca3000_core.c           |   16 +-
 drivers/staging/iio/adc/ad7280a.c                  |   28 +-
 drivers/staging/iio/adc/ad7291.c                   |    8 +-
 drivers/staging/iio/adc/ad7606_core.c              |    7 +-
 drivers/staging/iio/adc/ad7816.c                   |   12 +-
 drivers/staging/iio/adc/ad799x_core.c              |    6 +-
 drivers/staging/iio/adc/lpc32xx_adc.c              |   12 +-
 drivers/staging/iio/adc/mxs-lradc.c                |  311 +-
 drivers/staging/iio/addac/adt7316-i2c.c            |    6 -
 drivers/staging/iio/addac/adt7316-spi.c            |    6 -
 drivers/staging/iio/addac/adt7316.c                |   12 +-
 drivers/staging/iio/addac/adt7316.h                |    1 -
 drivers/staging/iio/cdc/ad7150.c                   |    8 +-
 drivers/staging/iio/cdc/ad7746.c                   |   14 +-
 drivers/staging/iio/frequency/ad9832.h             |    6 +-
 drivers/staging/iio/frequency/ad9834.h             |    4 +-
 drivers/staging/iio/gyro/adis16060_core.c          |   10 +-
 drivers/staging/iio/iio_simple_dummy.c             |    8 +-
 drivers/staging/iio/light/isl29018.c               |   13 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |   40 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |    7 +
 drivers/staging/iio/resolver/ad2s1200.c            |   10 +-
 drivers/staging/imx-drm/Kconfig                    |    6 +
 drivers/staging/imx-drm/Makefile                   |    1 +
 drivers/staging/imx-drm/imx-drm-core.c             |    3 +-
 drivers/staging/imx-drm/imx-hdmi.c                 | 1916 +++++++++
 drivers/staging/imx-drm/imx-hdmi.h                 | 1032 +++++
 drivers/staging/imx-drm/imx-ldb.c                  |    5 +-
 drivers/staging/imx-drm/imx-tve.c                  |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |    1 -
 drivers/staging/imx-drm/ipuv3-crtc.c               |    3 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |   12 +-
 drivers/staging/imx-drm/parallel-display.c         |    3 +-
 drivers/staging/keucr/smcommon.h                   |    2 +-
 drivers/staging/keucr/smil.h                       |    8 +-
 drivers/staging/keucr/smilecc.c                    |    2 +-
 drivers/staging/keucr/smilmain.c                   |  101 +-
 drivers/staging/keucr/smilsub.c                    |   37 +-
 drivers/staging/keucr/smscsi.c                     |   28 +-
 drivers/staging/keucr/usb.c                        |    1 -
 drivers/staging/line6/driver.c                     |    7 +
 drivers/staging/line6/pcm.c                        |    1 +
 drivers/staging/line6/usbdefs.h                    |    7 +-
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 -
 .../lustre/include/linux/libcfs/libcfs_debug.h     |  210 +-
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |   64 +-
 .../lustre/include/linux/libcfs/linux/kp30.h       |  150 +-
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    1 -
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |   92 -
 .../lustre/include/linux/libcfs/linux/linux-prim.h |    1 -
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    5 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    2 +-
 drivers/staging/lustre/include/linux/lnet/types.h  |   11 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |    4 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    3 +-
 .../lustre/lnet/klnds/o2iblnd/o2iblnd_modparams.c  |  358 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    1 -
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |    6 -
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |  307 --
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    1 -
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |  124 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   16 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |   21 +-
 drivers/staging/lustre/lnet/lnet/config.c          |   39 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |   10 +-
 drivers/staging/lustre/lnet/lnet/lib-msg.c         |    8 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |    4 +-
 drivers/staging/lustre/lnet/lnet/module.c          |    4 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   63 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   30 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |    7 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |   64 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    2 +-
 drivers/staging/lustre/lnet/selftest/console.c     |  105 +-
 drivers/staging/lustre/lnet/selftest/console.h     |    8 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |    8 +-
 drivers/staging/lustre/lnet/selftest/ping_test.c   |    5 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    4 +-
 drivers/staging/lustre/lnet/selftest/selftest.h    |    5 +-
 drivers/staging/lustre/lnet/selftest/timer.c       |   11 +-
 drivers/staging/lustre/lustre/Kconfig              |    2 +-
 drivers/staging/lustre/lustre/fid/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    2 -
 drivers/staging/lustre/lustre/fld/Makefile         |    3 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |    2 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    1 -
 drivers/staging/lustre/lustre/fld/fld_request.c    |    7 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    3 -
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    2 +-
 .../lustre/lustre/include/linux/lustre_acl.h       |   18 +-
 .../lustre/lustre/include/linux/lustre_debug.h     |   47 -
 .../lustre/lustre/include/linux/lustre_intent.h    |    2 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 +
 .../staging/lustre/lustre/include/lprocfs_status.h |    8 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |   19 -
 drivers/staging/lustre/lustre/include/lu_target.h  |   91 -
 .../lustre/lustre/include/lustre/liblustreapi.h    |   43 -
 .../lustre/lustre/include/lustre/lustre_idl.h      |   72 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   42 +-
 .../lustre/lustre/include/lustre/lustreapi.h       |  310 --
 .../staging/lustre/lustre/include/lustre_debug.h   |   19 -
 .../staging/lustre/lustre/include/lustre_disk.h    |    1 +
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    3 +-
 .../lustre/lustre/include/lustre_dlm_flags.h       |   90 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 -
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 drivers/staging/lustre/lustre/include/lustre_lib.h |   11 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   13 +-
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    9 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |  245 --
 .../lustre/lustre/include/lustre_req_layout.h      |    7 +
 drivers/staging/lustre/lustre/include/lustre_sec.h |   17 +-
 drivers/staging/lustre/lustre/include/md_object.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |   15 +-
 .../staging/lustre/lustre/include/obd_support.h    |   12 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   18 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   45 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   15 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   57 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |    9 +
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   49 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   23 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |   42 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |   12 +-
 .../lustre/lustre/libcfs/kernel_user_comm.c        |    7 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |    6 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   13 -
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   11 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        |   36 +-
 drivers/staging/lustre/lustre/libcfs/lwt.c         |  266 --
 drivers/staging/lustre/lustre/libcfs/module.c      |   55 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |   34 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   22 +-
 drivers/staging/lustre/lustre/llite/Makefile       |    5 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   34 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   24 +-
 drivers/staging/lustre/lustre/llite/file.c         |  657 ++-
 .../staging/lustre/lustre/llite/llite_internal.h   |   76 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   76 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    3 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   41 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   14 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    4 +
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   61 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    2 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |  104 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  617 +++
 drivers/staging/lustre/lustre/lmv/Makefile         |    4 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |    1 -
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |    1 -
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |    6 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    5 -
 drivers/staging/lustre/lustre/lov/Makefile         |    3 +-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |   16 +
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    2 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |   15 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |    2 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |    2 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    2 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   35 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   20 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |    2 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |   14 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |   40 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    3 +-
 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c   |  760 ----
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    2 -
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    1 -
 drivers/staging/lustre/lustre/mdc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |    3 -
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    3 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   31 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  113 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   86 +-
 drivers/staging/lustre/lustre/mgc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |    3 -
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |    3 -
 drivers/staging/lustre/lustre/mgc/mgc_internal.h   |    2 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  416 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |    5 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   20 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |    3 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    6 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   21 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |  214 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |    6 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |   11 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    3 +
 .../lustre/lustre/obdclass/lprocfs_status.c        |  356 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   30 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    3 +
 .../staging/lustre/lustre/obdecho/echo_client.c    |    2 +-
 drivers/staging/lustre/lustre/osc/Makefile         |    3 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    2 -
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    6 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    2 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |    2 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    4 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |   14 +-
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    5 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   25 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |   75 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_asn1.h    |    6 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |    1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_err.h |   10 +-
 .../lustre/lustre/ptlrpc/gss/gss_generic_token.c   |    1 -
 .../staging/lustre/lustre/ptlrpc/gss/gss_keyring.c |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_mech_switch.c     |    1 -
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |    1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |   14 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   40 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   73 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_server.c |  450 --
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   14 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   81 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |  375 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   70 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |   16 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   50 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   77 +-
 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c     |   47 -
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   86 +-
 drivers/staging/media/as102/as102_drv.c            |    1 -
 drivers/staging/media/cxd2099/cxd2099.c            |    1 -
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    2 +-
 .../staging/media/davinci_vpfe/dm365_ipipe_hw.c    |    4 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    2 +-
 drivers/staging/media/go7007/go7007-driver.c       |    1 -
 drivers/staging/media/go7007/go7007-fw.c           |    4 +-
 drivers/staging/media/go7007/go7007-i2c.c          |    1 -
 drivers/staging/media/go7007/go7007-loader.c       |    1 -
 drivers/staging/media/go7007/go7007-usb.c          |    1 -
 drivers/staging/media/go7007/go7007-v4l2.c         |    1 -
 drivers/staging/media/go7007/s2250-board.c         |    1 -
 drivers/staging/media/go7007/saa7134-go7007.c      |    2 +-
 drivers/staging/media/go7007/snd-go7007.c          |    1 -
 drivers/staging/media/lirc/lirc_igorplugusb.c      |    4 +-
 drivers/staging/media/lirc/lirc_imon.c             |   12 +-
 drivers/staging/media/lirc/lirc_sasem.c            |    1 -
 drivers/staging/media/lirc/lirc_serial.c           |    6 +-
 drivers/staging/media/lirc/lirc_zilog.c            |    4 +-
 drivers/staging/media/solo6x10/solo6x10-core.c     |    2 +-
 drivers/staging/nvec/nvec.c                        |    2 +-
 drivers/staging/octeon/ethernet-mdio.h             |    1 -
 drivers/staging/octeon/ethernet-rx.c               |    1 -
 drivers/staging/octeon/ethernet-tx.c               |    1 -
 drivers/staging/octeon/ethernet.c                  |    1 -
 drivers/staging/olpc_dcon/olpc_dcon.c              |    6 +-
 drivers/staging/ozwpan/ozeltbuf.c                  |    3 +-
 drivers/staging/ozwpan/ozpd.c                      |    1 -
 drivers/staging/ozwpan/ozproto.c                   |    3 +-
 drivers/staging/ozwpan/ozusbsvc.c                  |    1 -
 drivers/staging/ozwpan/ozusbsvc1.c                 |    1 -
 drivers/staging/panel/panel.c                      |    4 +-
 drivers/staging/phison/phison.c                    |    3 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.c       |  132 +-
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |   66 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |  125 +-
 .../staging/rtl8187se/ieee80211/ieee80211_crypt.c  |    4 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |   13 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |   53 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   39 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |  188 +-
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   64 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |   13 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    8 +-
 drivers/staging/rtl8187se/r8180.h                  |   35 +-
 drivers/staging/rtl8187se/r8180_core.c             |   43 +-
 drivers/staging/rtl8187se/r8180_dm.h               |    2 +-
 drivers/staging/rtl8187se/r8180_hw.h               |    4 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h          |    3 +-
 drivers/staging/rtl8187se/r8180_wx.c               |  257 +-
 drivers/staging/rtl8187se/r8185b_init.c            |   17 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |   92 +-
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        |   87 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |   67 +-
 drivers/staging/rtl8188eu/core/rtw_debug.c         |    5 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |    2 +-
 drivers/staging/rtl8188eu/core/rtw_io.c            |   14 +-
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c     |   36 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |  163 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |   99 +-
 drivers/staging/rtl8188eu/core/rtw_mp.c            |   23 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      |    6 +-
 drivers/staging/rtl8188eu/core/rtw_p2p.c           |   27 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |   33 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   71 +-
 drivers/staging/rtl8188eu/core/rtw_sreset.c        |    2 +-
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |  122 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  136 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |    4 +-
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |    4 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |  292 +-
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c       |    6 +-
 drivers/staging/rtl8188eu/hal/odm.c                |  918 +---
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |  361 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |  163 +-
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |   62 +-
 drivers/staging/rtl8188eu/hal/odm_interface.c      |  102 -
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |    4 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |    5 -
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |   16 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c        |   40 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |    6 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   12 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |   12 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |    6 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |    1 -
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |    2 +-
 drivers/staging/rtl8188eu/include/drv_types.h      |    4 +-
 drivers/staging/rtl8188eu/include/hal_intf.h       |   29 -
 drivers/staging/rtl8188eu/include/odm.h            |   90 +-
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |    4 +-
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h |    2 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      |   15 +-
 drivers/staging/rtl8188eu/include/odm_interface.h  |   54 +-
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    7 -
 drivers/staging/rtl8188eu/include/osdep_service.h  |  143 +-
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |    4 +-
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h  |    6 +-
 drivers/staging/rtl8188eu/include/rtl8188e_spec.h  |   70 +-
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |  105 +-
 drivers/staging/rtl8188eu/include/rtw_eeprom.h     |    2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |    2 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         |   36 +-
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h  |    4 +-
 drivers/staging/rtl8188eu/include/rtw_iol.h        |    8 +-
 drivers/staging/rtl8188eu/include/rtw_led.h        |    6 +-
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |   62 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |   14 +-
 drivers/staging/rtl8188eu/include/rtw_mp.h         |   10 +-
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h   |    2 +-
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h    |   10 +-
 drivers/staging/rtl8188eu/include/rtw_security.h   |    2 +-
 drivers/staging/rtl8188eu/include/usb_ops.h        |    4 +-
 drivers/staging/rtl8188eu/include/wifi.h           |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |  125 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   13 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |  139 +-
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |    6 +-
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |    2 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   22 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |    8 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |   12 +-
 drivers/staging/rtl8192e/dot11d.c                  |    2 +-
 drivers/staging/rtl8192e/dot11d.h                  |    5 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |   13 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c        |    1 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   24 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h       |    3 +-
 drivers/staging/rtl8192e/rtl819x_BAProc.c          |   10 +-
 drivers/staging/rtl8192e/rtl819x_Qos.h             |   37 -
 drivers/staging/rtl8192e/rtllib.h                  |    2 +-
 drivers/staging/rtl8192e/rtllib_crypt.c            |    2 +-
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c       |    4 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |    8 +-
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |    4 +-
 drivers/staging/rtl8192e/rtllib_debug.h            |    6 +-
 drivers/staging/rtl8192e/rtllib_endianfree.h       |   44 +-
 drivers/staging/rtl8192e/rtllib_module.c           |    4 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |   76 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   32 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |   16 +-
 drivers/staging/rtl8192u/r8192U.h                  |    1 -
 drivers/staging/rtl8712/os_intfs.c                 |    1 -
 drivers/staging/rtl8712/rtl8712_cmd.c              |    1 -
 drivers/staging/rtl8712/rtl871x_cmd.c              |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    1 -
 drivers/staging/rtl8712/rtl871x_mlme.c             |    3 -
 drivers/staging/rtl8712/rtl871x_security.c         |    1 -
 drivers/staging/rtl8712/usb_intf.c                 |    5 +
 drivers/staging/rts5139/ms.c                       |    2 +-
 drivers/staging/rts5139/rts51x.c                   |    1 -
 drivers/staging/rts5139/rts51x_card.c              |   10 +-
 drivers/staging/rts5139/rts51x_card.h              |    8 +-
 drivers/staging/rts5139/rts51x_scsi.c              |    1 -
 drivers/staging/rts5208/Kconfig                    |   15 +
 drivers/staging/rts5208/Makefile                   |    6 +
 drivers/staging/rts5208/TODO                       |    7 +
 drivers/staging/rts5208/debug.h                    |   43 +
 drivers/staging/rts5208/general.c                  |   35 +
 drivers/staging/rts5208/general.h                  |   31 +
 drivers/staging/rts5208/ms.c                       | 4208 ++++++++++++++++++
 drivers/staging/rts5208/ms.h                       |  227 +
 drivers/staging/rts5208/rtsx.c                     | 1071 +++++
 drivers/staging/rts5208/rtsx.h                     |  185 +
 drivers/staging/rts5208/rtsx_card.c                | 1126 +++++
 drivers/staging/rts5208/rtsx_card.h                | 1098 +++++
 drivers/staging/rts5208/rtsx_chip.c                | 1979 +++++++++
 drivers/staging/rts5208/rtsx_chip.h                | 1002 +++++
 drivers/staging/rts5208/rtsx_scsi.c                | 3370 +++++++++++++++
 drivers/staging/rts5208/rtsx_scsi.h                |  143 +
 drivers/staging/rts5208/rtsx_sys.h                 |   50 +
 drivers/staging/rts5208/rtsx_transport.c           |  769 ++++
 drivers/staging/rts5208/rtsx_transport.h           |   66 +
 drivers/staging/rts5208/sd.c                       | 4525 ++++++++++++++++++++
 drivers/staging/rts5208/sd.h                       |  301 ++
 drivers/staging/rts5208/spi.c                      |  877 ++++
 drivers/staging/rts5208/spi.h                      |   65 +
 drivers/staging/rts5208/trace.h                    |   93 +
 drivers/staging/rts5208/xd.c                       | 2088 +++++++++
 drivers/staging/rts5208/xd.h                       |  188 +
 drivers/staging/sb105x/sb_mp_register.h            |    8 +-
 drivers/staging/sb105x/sb_pci_mp.c                 |    4 +-
 drivers/staging/sb105x/sb_pci_mp.h                 |    1 -
 drivers/staging/sbe-2t3e3/ctrl.c                   |   14 +-
 drivers/staging/sep/sep_crypto.c                   |    3 +-
 drivers/staging/sep/sep_main.c                     |    3 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   18 +-
 drivers/staging/silicom/bpctl_mod.c                |    2 -
 drivers/staging/silicom/bypasslib/bypass.c         |  170 +-
 drivers/staging/slicoss/README                     |    1 -
 drivers/staging/slicoss/slicoss.c                  |   23 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                  |    4 +-
 drivers/staging/speakup/main.c                     |    2 -
 drivers/staging/speakup/serialio.c                 |    4 +
 drivers/staging/speakup/serialio.h                 |   26 -
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/gen/gh.c               |  148 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |   85 -
 drivers/staging/tidspbridge/include/dspbridge/gh.h |   12 +-
 .../tidspbridge/include/dspbridge/uuidutil.h       |   18 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |    7 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |   98 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |    6 +-
 drivers/staging/tidspbridge/pmgr/dmm.c             |   20 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   12 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |  108 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   33 +-
 drivers/staging/usbip/stub_rx.c                    |   20 +-
 drivers/staging/usbip/usbip_common.c               |    5 +-
 .../staging/usbip/userspace/libsrc/usbip_common.c  |    2 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |   69 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |    2 +
 drivers/staging/usbip/userspace/src/Makefile.am    |    2 +-
 drivers/staging/usbip/userspace/src/usbip.c        |    6 +
 drivers/staging/usbip/userspace/src/usbip.h        |    1 +
 drivers/staging/usbip/userspace/src/usbip_port.c   |   57 +
 drivers/staging/usbip/vhci_hcd.c                   |   15 +-
 drivers/staging/vme/devices/vme_user.c             |   14 +-
 drivers/staging/vme/devices/vme_user.h             |   26 +-
 drivers/staging/vt6655/80211hdr.h                  |    2 +-
 drivers/staging/vt6655/baseband.c                  |    4 +-
 drivers/staging/vt6655/bssdb.c                     |  354 +-
 drivers/staging/vt6655/card.c                      |   10 +-
 drivers/staging/vt6655/channel.c                   |   16 +-
 drivers/staging/vt6655/datarate.c                  |    8 +-
 drivers/staging/vt6655/device.h                    |    1 -
 drivers/staging/vt6655/device_main.c               |   62 +-
 drivers/staging/vt6655/dpc.c                       |   40 +-
 drivers/staging/vt6655/hostap.c                    |   14 +-
 drivers/staging/vt6655/iwctl.c                     |    4 +-
 drivers/staging/vt6655/key.c                       |   44 +-
 drivers/staging/vt6655/mac.c                       |    4 +-
 drivers/staging/vt6655/power.c                     |    9 +-
 drivers/staging/vt6655/rf.c                        |    2 +-
 drivers/staging/vt6655/rxtx.c                      |   12 +-
 drivers/staging/vt6655/vntwifi.c                   |    6 +-
 drivers/staging/vt6655/wcmd.c                      |   22 +-
 drivers/staging/vt6655/wctl.c                      |    6 +-
 drivers/staging/vt6655/wmgr.c                      |  125 +-
 drivers/staging/vt6655/wpa.c                       |    2 +-
 drivers/staging/vt6655/wpa2.c                      |   18 +-
 drivers/staging/vt6655/wpactl.c                    |   44 +-
 drivers/staging/vt6655/wpactl.h                    |   12 +-
 drivers/staging/vt6655/wroute.c                    |   50 +-
 drivers/staging/vt6656/Makefile                    |    1 -
 drivers/staging/vt6656/aes_ccmp.c                  |   16 +-
 drivers/staging/vt6656/baseband.c                  |  335 +-
 drivers/staging/vt6656/bssdb.c                     | 2271 +++++-----
 drivers/staging/vt6656/bssdb.h                     |    4 +-
 drivers/staging/vt6656/card.c                      |  108 +-
 drivers/staging/vt6656/channel.c                   |    3 +-
 drivers/staging/vt6656/datarate.c                  |    2 +-
 drivers/staging/vt6656/datarate.h                  |    1 -
 drivers/staging/vt6656/desc.h                      |    8 -
 drivers/staging/vt6656/device.h                    |   30 +-
 drivers/staging/vt6656/device_cfg.h                |    2 +
 drivers/staging/vt6656/dpc.c                       |   49 +-
 drivers/staging/vt6656/int.c                       |   60 +-
 drivers/staging/vt6656/iwctl.c                     |   20 +-
 drivers/staging/vt6656/main_usb.c                  |  553 ++-
 drivers/staging/vt6656/mib.c                       |  489 ---
 drivers/staging/vt6656/mib.h                       |  378 --
 drivers/staging/vt6656/rf.c                        |    7 +-
 drivers/staging/vt6656/rndis.h                     |   30 +-
 drivers/staging/vt6656/rxtx.c                      |  344 +-
 drivers/staging/vt6656/rxtx.h                      |   12 +-
 drivers/staging/vt6656/tkip.c                      |    4 +-
 drivers/staging/vt6656/usbpipe.c                   |   10 -
 drivers/staging/vt6656/wcmd.c                      | 1712 ++++----
 drivers/staging/vt6656/wmgr.c                      |   10 +-
 drivers/staging/vt6656/wpa.c                       |   12 +-
 drivers/staging/vt6656/wpa2.c                      |   16 +-
 drivers/staging/vt6656/wpactl.c                    |    2 +-
 drivers/staging/winbond/mds.c                      |  101 +-
 drivers/staging/wlags49_h2/debug.h                 |   56 +-
 drivers/staging/wlags49_h2/sta_h25.c               |    6 +-
 drivers/staging/wlags49_h2/wl_cs.c                 |   67 +-
 drivers/staging/wlags49_h2/wl_cs.h                 |    2 +-
 drivers/staging/wlags49_h2/wl_enc.c                |   15 -
 drivers/staging/wlags49_h2/wl_enc.h                |    4 +-
 drivers/staging/wlags49_h2/wl_main.c               |  155 +-
 drivers/staging/wlags49_h2/wl_main.h               |    2 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |   97 +-
 drivers/staging/wlags49_h2/wl_pci.c                | 1578 -------
 drivers/staging/wlags49_h2/wl_pci.h                |  109 -
 drivers/staging/wlags49_h2/wl_priv.c               |  134 -
 drivers/staging/wlags49_h2/wl_profile.c            |   17 -
 drivers/staging/wlags49_h2/wl_util.c               |   59 -
 drivers/staging/wlags49_h2/wl_version.h            |   34 +-
 drivers/staging/wlags49_h2/wl_wext.c               |  188 +-
 drivers/staging/wlags49_h2/wl_wext.h               |    2 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   18 +-
 drivers/staging/wlan-ng/hfa384x.h                  |    4 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |    4 +-
 drivers/staging/wlan-ng/prism2mgmt.h               |    6 +-
 drivers/staging/wlan-ng/prism2mib.c                |    6 +-
 drivers/staging/wlan-ng/prism2sta.c                |    7 +-
 drivers/staging/wlan-ng/prism2usb.c                |   10 +-
 drivers/staging/xgifb/XGI_main.h                   |    2 +-
 drivers/staging/xillybus/Kconfig                   |    2 +-
 drivers/staging/xillybus/xillybus_of.c             |   26 +-
 drivers/staging/xillybus/xillybus_pcie.c           |    4 +-
 drivers/staging/zsmalloc/Kconfig                   |   13 +
 drivers/staging/zsmalloc/zsmalloc-main.c           |   86 +-
 drivers/staging/zsmalloc/zsmalloc.h                |    9 +-
 drivers/usb/Kconfig                                |    2 +
 drivers/usb/Makefile                               |    1 +
 drivers/{staging => usb}/dwc2/Kconfig              |    0
 drivers/{staging => usb}/dwc2/Makefile             |    0
 drivers/{staging => usb}/dwc2/core.c               |  378 +-
 drivers/{staging => usb}/dwc2/core.h               |   62 +-
 drivers/{staging => usb}/dwc2/core_intr.c          |   10 +-
 drivers/{staging => usb}/dwc2/hcd.c                |   22 +-
 drivers/{staging => usb}/dwc2/hcd.h                |    4 +-
 drivers/{staging => usb}/dwc2/hcd_ddma.c           |    8 +-
 drivers/{staging => usb}/dwc2/hcd_intr.c           |    6 +-
 drivers/{staging => usb}/dwc2/hcd_queue.c          |  195 +-
 drivers/{staging => usb}/dwc2/hw.h                 |    0
 drivers/{staging => usb}/dwc2/pci.c                |    2 +-
 drivers/{staging => usb}/dwc2/platform.c           |   60 +-
 drivers/vme/Kconfig                                |    2 +-
 drivers/vme/boards/vme_vmivme7805.c                |    2 +-
 drivers/vme/bridges/vme_ca91cx42.c                 |    2 +-
 drivers/vme/bridges/vme_tsi148.c                   |    2 +-
 drivers/vme/vme.c                                  |   25 +-
 include/linux/hid-sensor-ids.h                     |   12 +
 include/linux/iio/buffer.h                         |    3 +
 include/linux/iio/events.h                         |    4 -
 include/linux/iio/iio.h                            |  115 +-
 include/linux/iio/types.h                          |    1 +
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |    1 +
 include/linux/vme.h                                |    3 +-
 837 files changed, 51733 insertions(+), 29522 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/humidity/dht11.txt
 create mode 100644 Documentation/devicetree/bindings/iio/light/tsl2563.txt
 create mode 100644 Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
 create mode 100644 Documentation/devicetree/bindings/staging/xillybus.txt
 rename Documentation/devicetree/bindings/{staging => usb}/dwc2.txt (70%)
 create mode 100644 drivers/iio/humidity/Kconfig
 create mode 100644 drivers/iio/humidity/Makefile
 create mode 100644 drivers/iio/humidity/dht11.c
 create mode 100644 drivers/iio/light/cm32181.c
 create mode 100644 drivers/iio/orientation/Kconfig
 create mode 100644 drivers/iio/orientation/Makefile
 create mode 100644 drivers/iio/orientation/hid-sensor-incl-3d.c
 create mode 100644 drivers/iio/pressure/mpl3115.c
 create mode 100644 drivers/staging/android/ion/Kconfig
 create mode 100644 drivers/staging/android/ion/Makefile
 create mode 100644 drivers/staging/android/ion/compat_ion.c
 create mode 100644 drivers/staging/android/ion/compat_ion.h
 create mode 100644 drivers/staging/android/ion/ion.c
 create mode 100644 drivers/staging/android/ion/ion.h
 create mode 100644 drivers/staging/android/ion/ion_carveout_heap.c
 create mode 100644 drivers/staging/android/ion/ion_chunk_heap.c
 create mode 100644 drivers/staging/android/ion/ion_cma_heap.c
 create mode 100644 drivers/staging/android/ion/ion_dummy_driver.c
 create mode 100644 drivers/staging/android/ion/ion_heap.c
 create mode 100644 drivers/staging/android/ion/ion_page_pool.c
 create mode 100644 drivers/staging/android/ion/ion_priv.h
 create mode 100644 drivers/staging/android/ion/ion_system_heap.c
 create mode 100644 drivers/staging/android/ion/ion_test.c
 create mode 100644 drivers/staging/android/ion/tegra/Makefile
 create mode 100644 drivers/staging/android/ion/tegra/tegra_ion.c
 create mode 100644 drivers/staging/android/uapi/ion.h
 create mode 100644 drivers/staging/android/uapi/ion_test.h
 delete mode 100644 drivers/staging/btmtk_usb/Kconfig
 delete mode 100644 drivers/staging/btmtk_usb/Makefile
 delete mode 100644 drivers/staging/btmtk_usb/README
 delete mode 100644 drivers/staging/btmtk_usb/TODO
 delete mode 100644 drivers/staging/btmtk_usb/btmtk_usb.c
 delete mode 100644 drivers/staging/btmtk_usb/btmtk_usb.h
 create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
 delete mode 100644 drivers/staging/dwc2/TODO
 create mode 100644 drivers/staging/imx-drm/imx-hdmi.c
 create mode 100644 drivers/staging/imx-drm/imx-hdmi.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_debug.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lu_target.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre/liblustreapi.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre/lustreapi.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/lwt.c
 create mode 100644 drivers/staging/lustre/lustre/llite/xattr_cache.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt_ext3.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/llog_server.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/wirehdr.c
 create mode 100644 drivers/staging/rts5208/Kconfig
 create mode 100644 drivers/staging/rts5208/Makefile
 create mode 100644 drivers/staging/rts5208/TODO
 create mode 100644 drivers/staging/rts5208/debug.h
 create mode 100644 drivers/staging/rts5208/general.c
 create mode 100644 drivers/staging/rts5208/general.h
 create mode 100644 drivers/staging/rts5208/ms.c
 create mode 100644 drivers/staging/rts5208/ms.h
 create mode 100644 drivers/staging/rts5208/rtsx.c
 create mode 100644 drivers/staging/rts5208/rtsx.h
 create mode 100644 drivers/staging/rts5208/rtsx_card.c
 create mode 100644 drivers/staging/rts5208/rtsx_card.h
 create mode 100644 drivers/staging/rts5208/rtsx_chip.c
 create mode 100644 drivers/staging/rts5208/rtsx_chip.h
 create mode 100644 drivers/staging/rts5208/rtsx_scsi.c
 create mode 100644 drivers/staging/rts5208/rtsx_scsi.h
 create mode 100644 drivers/staging/rts5208/rtsx_sys.h
 create mode 100644 drivers/staging/rts5208/rtsx_transport.c
 create mode 100644 drivers/staging/rts5208/rtsx_transport.h
 create mode 100644 drivers/staging/rts5208/sd.c
 create mode 100644 drivers/staging/rts5208/sd.h
 create mode 100644 drivers/staging/rts5208/spi.c
 create mode 100644 drivers/staging/rts5208/spi.h
 create mode 100644 drivers/staging/rts5208/trace.h
 create mode 100644 drivers/staging/rts5208/xd.c
 create mode 100644 drivers/staging/rts5208/xd.h
 delete mode 100644 drivers/staging/tidspbridge/gen/uuidutil.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_port.c
 delete mode 100644 drivers/staging/vt6656/mib.c
 delete mode 100644 drivers/staging/vt6656/mib.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_pci.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_pci.h
 rename drivers/{staging => usb}/dwc2/Kconfig (100%)
 rename drivers/{staging => usb}/dwc2/Makefile (100%)
 rename drivers/{staging => usb}/dwc2/core.c (92%)
 rename drivers/{staging => usb}/dwc2/core.h (94%)
 rename drivers/{staging => usb}/dwc2/core_intr.c (98%)
 rename drivers/{staging => usb}/dwc2/hcd.c (99%)
 rename drivers/{staging => usb}/dwc2/hcd.h (99%)
 rename drivers/{staging => usb}/dwc2/hcd_ddma.c (99%)
 rename drivers/{staging => usb}/dwc2/hcd_intr.c (99%)
 rename drivers/{staging => usb}/dwc2/hcd_queue.c (89%)
 rename drivers/{staging => usb}/dwc2/hw.h (100%)
 rename drivers/{staging => usb}/dwc2/pci.c (99%)
 rename drivers/{staging => usb}/dwc2/platform.c (77%)
