Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3KYTDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:03:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42047 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab3KYTDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:03:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [RESEND GIT PULL] USB fixes for v3.13-rc2
Date: Mon, 25 Nov 2013 13:02:33 -0600
Message-ID: <1385406153-28085-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's my first set of fixes for this -rc cycle. Please
consider merging them on your usb-linus branch.

Let me know if you need any changes to this pull request. I
did a test merge of this tag with your usb-linus branch and
it merges just fine.

cheers

ps: resending with lkml in Cc, looks like my emails aren't reaching
linux-usb@vger.kernel.org and marc.info seems to not be picking up
any emails at all from no list.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git master

for you to fetch changes up to 2d27c2a70011870013dc911c750183ea397ee2f5:

  Merge tag 'fixes-for-v3.13-rc2' (2013-11-25 12:09:58 -0600)

----------------------------------------------------------------

Aaro Koskinen (1):
      usb: phy-generic: fix nop xceiv probe

Ajay Kumar Gupta (3):
      usb: musb: restore INDEX register in resume path
      usb: musb: fix bug in musb_cleanup_urb
      usb: musb: Fix wrong config for am33xx and ti81xx

Alan Stern (10):
      usb: gadget: deprecate g_file_storage
      USB: fix regression occurring during device removal
      USB: deprecate g_file_storage
      USB: gadget: storage: remove alignment assumption
      USB: gadget: storage: remove alignment assumption
      USB: gadget: storage: remove alignment assumption
      usb: gadget: udc-core: fix a regression during gadget driver unbinding
      USB: gadget: net2280: remove leftover driver->unbind call in error pathway
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd
      usb: dwc3: fix implementation of endpoint wedge

Alexander Aring (1):
      usb: gadget: fsl_udc_core: fix compile error.

Alexander Shishkin (3):
      usb: otg: kill langwell_otg driver
      usb: gadget: langwell: drop langwell_otg support
      usb: gadget: langwell: don't call gadget's disconnect()

Alexey Khoroshilov (1):
      usb: gadget: mv_u3d_core: fix violation of locking discipline in mv_u3d_ep_disable()

Amit Blay (1):
      usb: gadget: zero: add superspeed support

Anand Gadiyar (3):
      usb: musb: Enable DMA mode1 RX for transfers without short packets
      usb: musb: Enable DMA mode1 RX for transfers without short packets
      usb: musb: Enable DMA mode1 RX for transfers without short packets

Anatolij Gustschin (1):
      USB: fsl_udc_core: fix build breakage when building for ARM arch

Andiry Xu (1):
      usb: gadget: storage: endian fix

Andrzej Pietrasiewicz (4):
      usb: gadget: FunctionFS: clear FFS_FL_BOUND flag on unbind (bugfix)
      usb: gadget: FunctionFS: make module init & exit __init & __exit
      usb: gadget: add multiple definition guards
      usb: gadget: f_mass_storage: fix mass storage dependency

Andy Shevchenko (3):
      usb: gadget: use native print_hex_dump_bytes()
      usb: gadget: use %pm to print mac addresses
      usb: gadget: use %pm to print mac addresses

Anton Tikhomirov (8):
      usb: dwc3: Add Exynos Specific Glue layer
      usb: dwc3: use proper function for setting endpoint name
      usb: dwc3: use proper function for setting endpoint name
      usb: s3c-hsotg: Fix TX FIFOs allocation
      usb: s3c-hsotg: Fix maximum patcket size setting for EP0
      usb: s3c-hsotg: Avoid TxFIFO corruption in DMA mode
      usb: s3c-hsotg: Fix big buffers transfer in DMA mode
      usb: dwc3: Free event buffers array

Apelete Seketeli (1):
      usb: fix musb gadget to enable OTG mode conditionally

Arnd Bergmann (7):
      usb: gadget: pxa25x: is_vbus_present is gone
      usb: musb: use a Kconfig choice to pick the right DMA method
      usb: musb: allow building USB_MUSB_TUSB6010 as a module
      usb: musb: use a Kconfig choice to pick the right DMA method
      usb: musb: allow building USB_MUSB_TUSB6010 as a module
      usb: musb: use a Kconfig choice to pick the right DMA method
      usb: musb: allow building USB_MUSB_TUSB6010 as a module

Axel Lin (2):
      usb: gadget: s3c2410_udc: fix unterminated platform_device_id table
      usb: gadget: use module_pci_driver

Bob Liu (1):
      USB: gadget: fix req length in sourcesink_setup()

Boris BREZILLON (2):
      usb: gadget: at91_udc: prepare clk before calling enable
      usb: gadget: atmel_usba: prepare clk before calling enable

Chanho Park (1):
      usb: dwc3: use devm_xxx functions

Chao Xie (26):
      usb: gadget: mv_udc: add iso support
      usb: gadget: mv_udc: use udc_start and udc_stop functions
      usb: gadget: mv_udc: use devm_xxx for probe
      usb: gadget: mv_udc: fix the warning of mv_udc_remove
      usb: otg: mv_otg: use devm_xxx for probe
      usb: host: ehci-mv: remove unused variable
      usb: gadget: mv_udc: fix the value of tranceiver
      usb: phy: mv_usb2: add PHY driver for marvell usb2 controller
      usb: gadget: mv_udc: use PHY driver for udc
      usb: ehci: ehci-mv: use PHY driver for ehci
      usb: otg: mv_otg: use PHY driver for otg
      arm: mmp2: change the defintion of usb devices
      arm: pxa910: change the defintion of usb devices
      arm: brownstone: add usb support for the board
      arm: ttc_dkb: add usb support
      arm: mmp: remove the usb phy setting
      arm: mmp: remove usb devices from pxa168
      usb: phy: mv_usb2_phy: add externel chip support
      usb: gadget: mv_udc: add extern chip support
      usb: ehci: ehci-mv: add extern chip support
      usb: otg: mv_otg: add extern chip support
      arm: mmp: add extern chip support for brownstone
      arm: mmp: add extern chip support for ttc_dkb
      usb: gadget: mv_udc: add device tree support
      usb: otg: mv_otg: add device tree support
      usb: ehci: ehci-mv: add device tree support

Chen Gang (1):
      usb: gadget: s3c-hsudc: delete outdated comment

Dan Carpenter (5):
      usb: dwc3: debugfs: add a kfree() on error to dwc3_testmode_open()
      usb: dwc3: make dwc3_get_device_id() return the id
      usb: dwc3: make dwc3_get_device_id() return the id
      usb: dwc3: make dwc3_get_device_id() return the id
      usb: gadget: add a sparse endian notation

Daniel Mack (5):
      USB: gadget: midi: rename g_midi.c to midi.c
      USB: gadget: midi: add midi function driver
      USB: gadget: midi: refactor the device code
      USB: gadget: f_midi: allow a dynamic number of input and output ports
      usb: gadget: fix MIDI gadget jack allocation

Danny Kukawka (1):
      usb: dwc3: linux/module.h included twice

Du, Changbin (1):
      usb: gadget: s3c-hsotg: fix core reset timeout failure

Fabio Baltieri (4):
      usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
      usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
      usb: musb: ux500: use clk_prepare_enable and clk_disable_unprepare
      usb: musb: drop dangling CONFIG_USB_MUSB_DEBUG

Fabio Estevam (6):
      usb: fsl_mxc_udc.c: Fix build issue by including missing header file
      usb: fsl_mxc_udc.c: Remove compile-time dependency of MX35 SoC type
      drivers: usb: otg: Fix dependencies for some OTG drivers
      usb: gadget: f_mass_storage: Use "bool" instead of "int" in fsg_module_parameters
      usb: gadget: Include i.MX processors in the USB_FSL_USB2 help text
      usb: phy: phy-mxs-usb: Check the return value from stmp_reset_block()

Fabio Porcedda (1):
      usb: convert drivers/usb/* to use module_platform_driver_probe()

Felipe Balbi (1546):
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: move structures to core.h
      usb: dwc3: split gadget functions to gadget.c
      usb: dwc3: more __devinit annotations
      usb: dwc3: fix event buffer memleak
      usb: dwc3: add the basic OMAP glue
      usb: dwc3: start implement IRQ handling
      usb: dwc3: gadget: implement depcfg command
      usb: dwc3: add a few more parameters
      usb: dwc3: gadget: fix parameter setting of DEPXFERCFG
      usb: gadget: introduce gadget_is_dwc3()
      usb: dwc3: gadget: half initialization of endpoints
      usb: dwc: gadget: split more of the generic stuff
      usb: dwc: gadget: add more nops
      usb: dwc3: add structures for all events
      usb: dwc3: implement disconnect IRQ
      usb: dwc3: handle in and out ep irq separately
      usb: dwc3: partially implemented reset irq
      usb: dwc3: drop OTG events
      usb: dwc: half done IN ep IRQ
      usb: dwc3: increase event buffer size
      usb: dwc3: omap: we're parents of core dwc3 device
      usb: dwc: gadget: add missing static
      usb: dwc: gadget: implement queue()/dequeue()
      usb: dwc: gadget: substitute dwc_ with dwc3_
      usb: dwc: gadget: add usb_gadget_ops
      usb: dwc: gadget: implement pullup()
      usb: dwc3: implement get_frame()
      usb: dwc3: implement set_selfpowered()
      usb: dwc3: hold pointers to eps in dwc structure
      usb: dwc3: introduce struct dwc3_trb
      usb: dwc3: gadget: minimal driver load/unload
      usb: dwc3: gadget: drop ioctl
      usb: dwc3: gadget: implement map/unmap buffer
      usb: dwc3: gadget: setup TRB
      usb: dwc3: use the define
      usb: dwc3: gadget: combine endpoint ops
      usb: dwc3: gadget: implement fifo_flush
      usb: dwc3: gadget: flush all fifos on gadget init
      usb: dwc3: gadget: variable names are better uniform
      usb: dwc3: gadget: add missing line break
      usb: dwc3: move irq handling to gadget.c
      usb: dwc3: gadget: drop carkit and i2c events
      usb: dwc3: gadget: add debugging to EP irq
      usb: dwc3: gadget: split event handlers to their own functions
      usb: dwc3: add ep0_state
      usb: dwc3: gadget: add debugging
      usb: dwc3: gagdget: implement connect done IRQ
      usb: dwc3: gadget: implement link state change
      usb: dwc3: gadget: add a bit of spacing
      usb: dwc3: gadget: lock when clearing gadget and gadget_driver
      Merge commit 'v2.6.38-rc4' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: fix checkpatch.pl warnings
      usb: dwc3: headers: search and replace patch
      usb: dwc3: omap: mark dev_pm_ops const
      usb: dwc3: gadget.h: fix 80+ character lines
      Merge branch 'dwc3' into home-master
      usb: dwc3: add a dma_pool for TRBs for each endpoint
      usb: dwc3: gadget: create/destroy trb_pool based on ep enable/disable
      usb: dwc3: gadget: unfinished TRB allocation
      Merge commit 'v2.6.38-rc5' into home-master
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: switch over to an array
      usb: dwc3: gadget: use & instead of %
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: add a debugging print
      usb: dwc3: add missing kernel-doc
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: all struct dwc3_ep to be called dep
      usb: dwc3: gadget: brain-less cleanups
      usb: dwc3: gadget: drop a useless goto
      usb: dwc3: gadget: use res_trans_idx
      Merge branch 'dwc3' into home-master
      Merge commit 'v2.6.38-rc6' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: use is_chained flag
      usb: dwc3: gadget: add ep_ to the function name
      usb: dwc3: gadget: make __dwc3_gadget_ep_queue return a value
      usb: dwc3: gadget: free the TRB if queueing fails
      usb: dwc3: gadget: get rid of magic constants
      usb: dwc3: gadget: move some code around
      usb: dwc3: gadget: don't overwrite trbctl
      usb: dwc3: gadget: combine two cases
      usb: dwc3: gadget: only interrupt on last TRB
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: introduce dwc3_gadget_ep_get_transfer_index
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: implement dwc3_gadget_init_endpoint
      usb: dwc3: gadget: cut down on duplication
      usb: dwc3: gadget: implement dwc3_disable_endpoint()
      usb: dwc3: gadget: disable all eps on exit
      usb: dwc3: gadget: return early on two cases
      Merge branch 'dwc3' into home-master
      Merge commit 'v2.6.38-rc7' into home-master
      usb: dwc3: gadget: return early on two cases
      usb: dwc3: gadget: implement dwc3_gadget_ep_set_halt
      usb: dwc3: gadget: implement dwc3_gadget_ep_set_wedge
      Revert "usb: dwc3: gadget: return early on two cases"
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into tmp
      Merge branch 'home-master' into tmp
      usb: dwc3: gadget: drop dwc3_gadget_fifo_status
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: add blank lines
      usb: dwc3: gadget: implement wakeup method
      Merge branch 'dwc3' into home-master
      usb: dwc3: core: make suspend and resume return something
      usb: dwc3: core: move us to fs_initcall()
      Merge branch 'dwc3' into home-master
      usb: dwc3: remove event_ prefix from two fields
      usb: dwc3: gadget: introduce next_request()
      usb: dwc3: gadget: implement transfer complete IRQ
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: add request_count
      usb: dwc3: gadget: start next request if we have it queued
      usb: dwc3: gadget: introduce list_add/list_del helpers
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: fix compile error
      Merge branch 'dwc3' into home-master
      usb: dwc3: shift has to be defined first
      usb: dwc3: gadget: combine IN and OUT ep IRQs
      usb: dwc3: add enumeration for TRB Statuses
      usb: dwc3: gadget: XFERINPROG and XFERNRDY are Isoc-only
      usb: dwc3: gadget: use EP CMD Complete IRQ
      Merge commit 'v2.6.38-rc8' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: introduce HAPS glue layer
      usb: dwc3: glue layers need to probe before core dwc3
      usb: dwc3: add resources to dwc3 device
      usb: dwc3: gadget: increment after check
      usb: dwc3: gadget: return IRQ_HANDLED
      Revert "usb: dwc3: gadget: use EP CMD Complete IRQ"
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: add dwc3_ prefix to prepare_trbs
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: drop unneeded gadget ops
      usb: dwc3: haps: few fixes to haps glue
      usb: dwc3: keep it all on module_init
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: set CSP bit in TRB
      usb: dwc3: gadget: use max packet size from ep descriptor
      usb: dwc3: gadget: set binterval_m1 field
      usb: dwc3: haps: checkpatch.pl asks to use DEFINE_PCI_DEVICE_TABLE
      usb: dwc3: gadget: misc cleanups
      usb: dwc3: gadget: add missing register write
      usb: dwc3: gadget: fix typo DCW -> DWC
      Merge branch 'dwc3' into home-master
      Merge commit 'v2.6.38' into home-master
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: fix up copyright
      device: add dev_WARN_ONCE
      usb: dwc3: gadget: convert WARN_ONCE() to dev_WARN_ONCE()
      usb: dwc3: gadget: Search&Replace dwc_ dwc3_
      usb: dwc3: gadget: drop useless check for ep type
      usb: dwc3: gadget: make internal function name uniform
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: dwc3: gadget: compile gadget code only if enabled
      usb: dwc3: Kconfig: drop "Disable DMA" entry
      usb: dwc3: omap: fix exit section annotation
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      usb: dwc3: drop unnused enumeration
      usb: dwc3: fix typo
      usb: dwc3: gadget: give ep0 a wMaxPacketSize
      usb: dwc3: make our driver Dual BSD/GPL
      Merge branch 'dwc3' into home-master
      usb: dwc3: fix license on OMAP and HAPS glue layers
      Merge branch 'dwc3' into home-master
      usb: dwc3: core: drop ramN memory bases
      usb: dwc3: ep0: remove unneeded return statement
      usb: dwc: core: ioremap global space first
      usb: dwc3: gadget: fix typo in debugging message
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: introduce next_queued_request()
      usb: dwc3: gadget: convert to next_queued_request()
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: pass the list_head instead of endpoint
      Merge branch 'dwc3' into home-master
      usb: dwc3: gadget: WARN() on double allocation of TRB pool
      usb: dwc3: gadget: add lock around __dwc3_gadget_ep_disable()
      usb: dwc3: gagdget: fix typo s/requeust/request/
      usb: dwc3: gadget: update ep names with xfer type
      Revert "usb: dwc3: gadget: WARN() on double allocation of TRB pool"
      Merge branch 'dwc3' into home-master
      usb: dwc3: introduce platform_data.h
      usb: dwc3: update to use new platform_data
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3' into home-master
      Merge commit 'v2.6.39-rc1' into home-master
      Merge branch 'dwc3' into home-master
      Merge branch 'dwc3'
      usb: dwc3: gadget: drop unused argument
      Merge branch 'dwc3'
      usb: dwc3: gadget: handle Transfer In Progress
      Merge branch 'dwc3'
      Revert "usb: dwc3: update to use new platform_data"
      Revert "usb: dwc3: introduce platform_data.h"
      usb: dwc3: convert to only one base
      usb: dwc3: add features bit definitions
      usb: dwc3: use platform_device_id
      usb: dwc3: adapt to new platform_device_id
      usb: gadget: chips: fix dwc3 recognition
      usb: dwc3: core: use pm_runtime_get_sync()
      usb: always enter USB directory
      usb: dwc3: Kconfig: depend on USB or USB_GADGET
      Merge branch 'dwc3'
      usb: dwc3: haps: remove unused code
      usb: dwc3: core: mark platform_device_id __devinitconst
      Revert "usb: always enter USB directory"
      usb: don't enter usb subdirectories directly
      usb: dwc3: core: fix up the reset loop
      usb: gadget: chips: fixup our name
      usb: dwc3: use platform_get_resource_byname
      usb: dwc3: gadget: enable correct IRQs
      usb: dwc3: drop BIT(13) of DEVTEN
      Merge branch 'dwc3'
      Merge commit 'v2.6.39-rc2'
      usb: dwc3: gadget: add IRQF_SHARED
      usb: dwc3: core: get IRQ by name
      usb: dwc3: io: include <asm/io.h>
      usb: dwc3: introduce omap glue layer
      usb: dwc3: omap: don't try to reinitilize the device
      usb: dwc3: omap: drop pm_runtime from the glue layer
      usb: dwc3: omap: request IRQ lines before enabling the events
      usb: dwc3: fix up Makefile so we always build correctly
      usb: dwc3: fix offset of DEPCMD registers
      usb: dwc3: gadget: only set binternal_m1 if we have to
      usb: dwc3: gadget: we need to enable ep0/1 on POR
      usb: dwc3: core: save size of address space in our struct
      usb: dwc3: introduce simple debugfs interface
      Merge branch 'dwc3'
      usb: dwc3: haps: don't reinitialize pdev, HAPS remix
      usb: dwc3: haps: we need to pass IRQ to core driver too
      usb: dwc3: gadget: add verbose print when sending commands
      usb: dwc3: gadget: pass ignore_sequence_number as paramter
      usb: dwc3: gadget: fix up connection done IRQ
      usb: dwc3: gadget: move TRB allocation one layer up
      usb: dwc3: allow verbose debug to be selected
      usb: dwc3: gadget: fix up wMaxPacketSize on conndone IRQ
      usb: dwc3: gadget: move disabled check one layer up
      Merge branch 'dwc3'
      usb: dwc3: gadget: we should write back BYTE count
      usb: dwc3: gadget: don't reenable eps on reset IRQ
      usb: dwc3: gadget: no need for two defines
      usb: dwc3: gadget: don't drop run/stop on disconnect
      usb: dwc3: fix typo 'ponts'
      usb: dwc3: drop extra semicolon
      usb: dwc3: gadget: kill one compile warning
      usb: dwc3: gadget: alloc from coherent instead
      usb: dwc3: ep0: reference code uses ISP bit
      usb: dwc3: gadget: don't hardcode endpoint number to 1
      usb: dwc3: gadget: usb & instead of %
      usb: dwc3: gadget: issue start transfer after run/stop
      Merge branch 'dwc3'
      usb: dwc3: gadget: don't dereference null pointer
      usb: dwc3: ep0: pretty print ep0state
      usb: dwc3: ep0: add missing break
      usb: dwc3: ep0: drop few warnings
      usb: dwc3: ep0: add a few debugging prints
      usb: dwc3: ep0: only call complete() if queue isn't empty
      usb: dwc3: ep0: inspect the setup packet always
      Merge branch 'dwc3'
      usb: dwc3: ep0: fix compile error
      Merge branch 'dwc3'
      usb: dwc3: ep0: don't queue always to ep0
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: dwc3: gadget: call device register
      Merge branch 'dwc3'
      usb: dwc3: more debugging info
      usb: dwc3: ep0: use next_request()
      usb: dwc3: gadget: patch gadget speed
      usb: dwc3: ep0: do setup_status phase
      usb: dwc3: gadget: pass descriptor to alloc_trb
      usb: dwc3: gadget: fix endpoint mapping
      usb: dwc3: gadget: only enable xfer_in_progress for isoc
      usb: dwc3: gadget: we only need bInterval on SS
      Merge branch 'dwc3'
      usb: dwc3: core: define macro for command status
      usb: dwc3: gadget: pretty print for events
      usb: dwc3: ep0: print physical endpoint name instead
      usb: dwc3: gadget: fix up endpoint name
      usb: dwc3: gadget: follow reference code
      usb: dwc3: gadget: only call disconnect if we're working
      usb: gadget: ep0: move xfernotready closer to its sibling
      usb: dwc3: ep0: simplify debugging and handler
      Merge branch 'dwc3'
      Merge commit 'v2.6.39-rc4'
      usb: dwc3: core: fix a register name
      usb: dwc3: debugfs: improve regdump utility
      usb: dwc3: omap: move platform_set_drvdata up
      usb: dwc3: gadget: move req->queued to move_request_queued
      usb: dwc3: gadget: stop transfers before disconnect
      usb: dwc3: ep0: call giveback instead of reimplementing it
      usb: dwc3: ep0: we only support one request on control ep
      usb: dwc3: gadget: no need to command completion IRQ
      usb: dwc3: gadget: nuke all requests on disconnect
      usb: dwc3: ep0: simply ep0 handlers
      usb: dwc3: gadget: decrease verbosity to dev_dbg
      usb: dwc3: ep0: fix a compile warning
      usb: dwc3: ep0: don't handle setup on xfernotready
      usb: dwc3: gadget: disconnect when removing gadget driver
      usb: dwc3: gadget: unregister gadget device
      Merge branch 'dwc3'
      usb: dwc3: ep0: don't access list_head without locks
      usb: dwc3: ep0: fix for ep0_do_setup_status
      usb: dwc3: gadget: no need for XferNotReady for Bulk
      usb: dwc3: gadget: don't stop transfers on control pipe
      usb: dwc3: gadget: a little re-organization
      usb: dwc3: gadget: don't rely on request_count
      usb: dwc3: gadget: pass the entire event to handler
      usb: dwc3: gadget: add more consts
      Merge commit 'v2.6.39-rc5'
      Merge branch 'dwc3'
      usb: dwc3: haps: rename to pci
      Merge branch 'dwc3'
      usb: dwc3: haps: rename to pci
      Revert "usb: dwc3: haps: rename to pci"
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: dwc3: fix DAVADDR typo
      usb: dwc3: ep0: prevent a possible buffer overflow
      usb: dwc3: gadget: ep0 packet size in SS is 512
      usb: dwc3: gadget: increase maxpacket size of all non-0 eps
      Merge commit 'v2.6.39-rc6'
      usb: dwc3: gadget: add missing break
      usb: dwc3: gadget: disable the uneeded PHY
      usb: dwc3: gadget: use correct FIFO numbers
      usb: dwc3: gadget: enable XferNotReady for all endpoints
      usb: dwc3: gadget: always set bInterval
      usb: dwc3: gadget: check correct list
      usb: dwc3: gadget: check if request is valid
      usb: dwc3: add DWC3_EP_BUSY flag
      usb: dwc3: gadget: ep0/ep1 need direction too
      usb: dwc3: gadget: use XferNotReady IRQ
      usb: dwc3: gadget: control endpoints don't need XferInProgress
      usb: dwc3: gadget: print ep name when sending ep cmd
      usb: dwc3: gadget: verbose debug print for each IRQ
      Merge branch 'dwc3'
      Merge commit 'v2.6.39-rc7'
      Merge branch 'dwc3'
      usb: dwc3: pci: fix pci_set_drvdata() call
      Merge branch 'dwc3'
      Merge commit 'v2.6.39'
      usb: dwc3: gadget: add DWC3_EP_PENDING_REQUEST flag
      Merge branch 'dwc3'
      usb: dwc3: pci: add a name to the driver
      Merge commit 'v3.0-rc1'
      usb: dwc3: pci: use pci_resource_end()
      usb: dwc3: core: calculate timeout correctly
      usb: dwc3: core: request the memory region
      usb: dwc3: omap: set dma_mask and dma_parms
      usb: dwc3: pci: set coherent_dma_mask
      usb: dwc3: gadget: introduce helpers for powering PHYs
      usb: dwc3: ep0: set address on correct register
      Merge branch 'dwc3'
      usb: dwc3: gadget: reset USB PHYs during init
      usb: dwc3: gadget: don't overwrite DCFG
      usb: dwc3: core: allow for memory over 4GiB
      usb: dwc3: ep0: allow for memory over 4GiB
      usb: dwc3: gadget: no need to restart ep0 out
      usb: dwc3: gadget: put PHY in reset when powered down
      Merge branch 'dwc3'
      Merge commit 'v3.0-rc2'
      usb: gadget: introduce UDC Class
      Merge branch 'fixes'
      Merge branch 'gadget'
      Merge branch 'dwc3'
      usb: dwc3: search and replace
      Merge branch 'dwc3'
      Merge commit 'v3.0-rc3'
      usb: gadget: introduce UDC Class
      usb: gadget: ci13xx_udc: fix usb_ep_enable() call
      usb: gadget: chips: remove ifdef trickery
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp-15062011
      Merge branch 'master' into tmp-15062011
      Rebuild usb tree on top of v3.0-rc3
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: gadget: introduce UDC Class
      usb: gadget: ci13xx_udc: fix usb_ep_enable() call
      usb: gadget: chips: remove ifdef trickery
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp-16062011
      Merge branch 'master' into tmp-16062011
      Rebuild usb tree on top of v3.0-rc3
      usb: gadget: introduce UDC Class
      usb: gadget: ci13xx_udc: fix usb_ep_enable() call
      usb: gadget: chips: remove ifdef trickery
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into dwc3
      Merge branch 'master' into dwc3
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp-16062011
      Rebuild usb tree on top of v3.0-rc3
      usb: gadget: composite: fix compile error on ARM
      Merge branch 'gadget'
      usb: musb: be careful when using different fifo_modes
      usb: musb: drop a gigantic amount of ifdeferry
      usb: gadget: allow multiple gadgets to be built
      usb: musb: omap: always create musb device
      usb: musb: no need to access platform_device
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: dwc3: gadget: fix Kconfig entry
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp-27062011
      Merge branch 'master' into tmp-27062011
      Rebuild usb tree on top of v3.0-rc4
      usb: musb: fix an auto-merge issue
      usb: gadget: ci13xx_udc: fix usb_ep_enable() call
      usb: gadget: chips: remove ifdef trickery
      usb: musb: be careful when using different fifo_modes
      usb: musb: drop a gigantic amount of ifdeferry
      usb: musb: choose correct fifo_mode
      usb: gadget: allow multiple gadgets to be built
      usb: musb: omap: always create musb device
      usb: musb: no need to access platform_device
      usb: musb: move to threaded IRQ
      Merge commit 'v3.0-rc5'
      usb: gadget: fusb300_udc: drop dead code
      usb: gadget: langwell_udc: fix compile warnings
      usb: gadget: net2272: fix compile warnings
      usb: gadget: storage: fix compile warnings
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: dwc3: gadget: fix Kconfig entry
      usb: dwc3: gadget: move to threaded IRQ
      Merge branches 'musb', 'gadget', 'dwc3', 'hci', 'fixes' and 'xceiv' into tmp-04072011
      Merge branch 'master' into tmp-04072011
      Rebuild tree on top of v3.0-rc5
      Merge commit 'v3.0-rc6'
      usb: musb: fix build breakage
      usb: musb: move to threaded IRQ
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: dwc3: gadget: fix Kconfig entry
      Merge branches 'musb', 'hci', 'gadget', 'fixes' and 'dwc3' into tmp-11072011
      Merge branch 'master' into tmp-11072011
      Rebuild usb tree on top of v3.0-rc6
      Merge commit 'v3.0-rc7'
      usb: gadget: introduce UDC Class
      usb: gadget: ci13xx_udc: fix usb_ep_enable() call
      usb: gadget: chips: remove ifdef trickery
      usb: musb: be careful when using different fifo_modes
      usb: musb: drop a gigantic amount of ifdeferry
      usb: musb: choose correct fifo_mode
      usb: gadget: allow multiple gadgets to be built
      usb: musb: omap: always create musb device
      usb: musb: no need to access platform_device
      usb: gadget: fusb300_udc: drop dead code
      usb: gadget: langwell_udc: fix compile warnings
      usb: gadget: net2272: fix compile warnings
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: dwc3: gadget: fix Kconfig entry
      usb: dwc3: core: fix compile warning
      usb: dwc3: gadget: set correct port mode
      usb: dwc3: gadget: don't keep PHY in SoftRst
      usb: dwc3: gadget: wait a bit after SoftRst too
      usb: dwc3: gadget: fix compilation as module
      usb: dwc3: gadget: fix usb ep enable sequence
      usb: dwc3: gadget: drop ignore argument
      usb: dwc3: gadget: fix wrong logic
      usb: dwc3: ep0: fix device address setting
      usb: dwc3: gadget: reset PHYs on disconnect
      usb: dwc3: ep0: in case of error, tell gadget driver
      usb: dwc3: gadget: apply SuperSpeed connect/disconnect workaround
      usb: dwc3: gadget: move start/stop up in the source file
      usb: dwc3: gadget: move to udc_start/udc_stop
      usb: dwc3: gadget: move more code to udc_start/stop
      musb
      Merge branch 'master' into tmp-22072011
      Rebuild usb tree on top of tag v3.0
      usb: musb: fix build breakage
      usb: musb: move to threaded IRQ
      usb: gadget: add USB_GADGET_SUPERSPEED
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      usb: dwc3: gadget: only set run/stop bit as the last step
      usb: dwc3: gadget: fix Kconfig entry
      usb: dwc3: core: fix compile warning
      usb: dwc3: gadget: set correct port mode
      usb: dwc3: gadget: don't keep PHY in SoftRst
      usb: dwc3: gadget: wait a bit after SoftRst too
      usb: dwc3: gadget: fix compilation as module
      usb: dwc3: gadget: fix usb ep enable sequence
      usb: dwc3: gadget: drop ignore argument
      usb: dwc3: gadget: fix wrong logic
      usb: dwc3: ep0: fix device address setting
      usb: dwc3: gadget: reset PHYs on disconnect
      usb: dwc3: ep0: in case of error, tell gadget driver
      usb: dwc3: gadget: apply SuperSpeed connect/disconnect workaround
      usb: dwc3: gadget: move start/stop up in the source file
      usb: dwc3: gadget: move to udc_start/udc_stop
      usb: dwc3: gadget: move more code to udc_start/stop
      Merge remote-tracking branch 'linus/master'
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of Linus
      Merge branches 'musb' and 'fixes'
      Merge branch 'fixes'
      Revert "usb: musb: fix oops on musb_gadget_pullup"
      Merge branch 'fixes'
      usb: dwc3: gadget: fix up ep0->maxpacket
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: gadget: storage: add superspeed support
      usb: musb: fix build breakage
      usb: musb: move to threaded IRQ
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on top of v3.1-rc1
      usb: dwc3: gadget: fix compile warning
      usb: dwc3: gadget: move trb_pool allocation earlier
      usb: dwc3: gadget: allocate trb_pool from coherent
      usb: dwc3: gadget: set all dma parameters correctly
      usb: dwc3: core: use SIMPLE_DEV_PM_OPS
      usb: dwc3: omap: use memcpy_to/fromio()
      usb: dwc3: omap: use UNIVERSAL_DEV_PM_OPS
      usb: dwc3: Makefile: allow omap glue to build on all omaps
      Merge branch 'dwc3'
      Merge commit 'v3.1-rc2'
      usb: dwc3: gadget: fix debug print
      usb: dwc3: gadget: add a few more debugging prints
      usb: dwc3: gadget: set LST bit on all TRBs for now
      Merge branch 'dwc3'
      usb: dwc3: core: drop dev_pm_ops
      usb: dwc3: core: move pm_runtime init to a saner location
      usb: dwc3: omap: dynamically allocate context space
      usb: dwc3: Makefile: always allow dwc3-omap to build
      MAINTAINERS: add a maintainer for this driver
      Merge branch 'dwc3'
      usb: dwc3: core: this can't be const
      usb: dwc3: omap: remove __read_mostly
      usb: dwc3: gadget: fix inverted logic
      usb: gadget: storage: add superspeed support
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      MAINTAINERS: add a maintainer for DesignWare USB3 driver
      Merge branches 'musb', 'hci', 'gadget', 'fixes', 'xceiv' and 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of v3.2-rc1
      usb: dwc3: pci: allow multiple PCIe cards on one PC
      usb: dwc3: core: fix comment
      Merge branch 'dwc3'
      usb: Introduce DesignWare USB3 DRD Driver
      MAINTAINERS: add a maintainer for DesignWare USB3 driver
      usb: gadget: storage: add superspeed support
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of v3.1-rc3
      usb: musb: fix build breakage
      usb: gadget: audio: actually support both speeds
      usb: gadget: audio: queue wLength-sized requests
      usb: gadget: storage: add superspeed support
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'fixes' into tmp
      usb: gadget: introduce gadget_is_dwc3()
      usb: Introduce DesignWare USB3 DRD Driver
      MAINTAINERS: add a maintainer for DesignWare USB3 driver
      usb: dwc3: core: add missing @ for kerneldoc
      usb: dwc3: gadget: set request dma to invalid when unmapping
      usb: dwc3: ep0: fix 'transfered' typo
      usb: dwc3: gadget: set request dma to invalid when unmapping
      usb: dwc3: gadget: improve command completion debug message
      usb: dwc3: core: add defines for XferNotReady event on Control EPs
      usb: dwc3: add a bounce buffer for control endpoints
      usb: dwc3: ep0: add handling for unaligned OUT transfers
      usb: dwc3: core: add flag for EP0 direction
      usb: dwc3: ep0: simplify EP0 state machine
      Merge branch 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on top of v3.1-rc4
      usb: dwc3: gadget: set request dma to invalid when unmapping
      usb: dwc3: gadget: improve command completion debug message
      usb: dwc3: core: add defines for XferNotReady event on Control EPs
      usb: dwc3: add a bounce buffer for control endpoints
      usb: dwc3: ep0: add handling for unaligned OUT transfers
      usb: dwc3: core: add flag for EP0 direction
      usb: dwc3: ep0: simplify EP0 state machine
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of v3.1-rc4
      usb: dwc3: ep0: fix Get Status handling
      usb: dwc3: ep0: clear all EP0 flags
      usb: dwc3: drop EP0_STALL state
      usb: dwc3: core: add ep0_next_event field
      usb: dwc3: use ep0_next_event field
      Merge branch 'dwc3'
      usb: dwc3: omap: fix dev_dbg() calls
      usb: dwc3: omap: do not enable DMA Disable Clear IRQ
      usb: dwc3: omap: use the macro we already have
      usb: dwc3: omap: drop DEV_PM_OPS for now
      usb: dwc3: omap: distinguish between SW and HW modes
      usb: dwc3: add module.h to dwc3-omap.c and core.c
      usb: dwc3: omap: change IRQ name to dwc3-omap
      usb: dwc3: omap: fix IRQ handling
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: dwc3: Fix definition of DWC3_GCTL_U2RSTECN
      usb: dwc3: define ScaleDown macro helper
      usb: dwc3: gadget: fix GCTL programming
      usb: dwc3: gadget: drop the useless dma_sync_single* calls
      usb: dwc3: ep0: giveback requests on stall_and_restart
      usb: dwc3: ep0: fix ep0_expect_in initialization
      usb: gadget: udc-core: fix bug on soft_connect interface
      Merge branches 'dwc3' and 'fixes'
      usb: dwc3: ep0: introduce ep0_expect_in flag
      usb: dwc3: omap: set idle and standby modes
      usb: dwc3: gadget: improve debug on link state change
      Revert "usb: dwc3: ep0: fix ep0_expect_in initialization"
      Merge branch 'dwc3'
      usb: gadget: audio: actually support both speeds
      usb: gadget: audio: queue wLength-sized requests
      usb: gadget: storage: add superspeed support
      usb: dwc3: ep0: Make USB30CV happy with SetAddress
      usb: dwc3: ep0: ignore direction on 2-stage transfer
      usb: dwc3: ep0: fix debug message
      Merge branch 'dwc3'
      Merge commit 'v3.1-rc7'
      usb: dwc3: gadget: add support for Bursts
      Merge branch 'dwc3'
      usb: dwc3: gadget: add support for Bursts
      usb: dwc3: gadget: implement streams support
      usb: dwc3: add struct dwc3_hwparams
      usb: dwc3: core: cache GHWPARAMS* registers
      usb: dwc3: gadget: allow clock gating to work
      usb: dwc3: convert structures into bitshifts
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of 3.1-rc7
      Merge commit 'v3.1-rc8'
      usb: gadget: udc-core: fix bug on soft_connect and srp interfaces
      usb: musb: gadget: don't call ->disconnect() on exit
      usb: gadget: core: fix bug when removing gadget drivers
      usb: gadget: core: allow everybody to read sysfs attributes
      Merge commit 'v3.1-rc9'
      usb: dwc3: gadget: don't disable endpoints on exit
      usb: dwc3: allow forcing a maximum speed
      usb: gadget: langwell: don't use the_controller when it's not needed
      usb: gadget: langwell: convert to new style
      usb: gadget: net2272: convert to new style
      usb: gadget: net2280: convert to new style
      usb: gadget: renesas: convert to new style
      usb: gadget: r8a66597: convert to new style
      usb: gadget: fix typo for default U1/U2 exit latencies
      usb: dwc3: calculate number of event buffers dynamically
      usb: dwc3: fetch mode of operation from HW
      usb: dwc3: add xHCI Host support
      usb: dwc3: always compile gadget side too
      usb: dwc3: move gadget prototypes to core.h
      usb: gadget: storage: add superspeed support
      usb: dwc3: depend on both Host and Gadget stacks
      usb: gadget: renesas_usbhs: drop dependency
      usb: gadget: renesas_usbhs: fix compile warning
      usb: gadget: mv_udc: fix compile warning
      usb: dwc3: ep0: SetAddress() won't be issued while Configured
      usb: dwc3: debugfs: add support for changing port mode
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge branch 'fixes'
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      Merge commit 'v3.1'
      Merge branch 'dwc3'
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      Merge branch 'dwc3'
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      Merge branch 'dwc3'
      usb: dwc3: gadget: don't disable endpoints on exit
      usb: dwc3: allow forcing a maximum speed
      usb: dwc3: calculate number of event buffers dynamically
      usb: dwc3: fetch mode of operation from HW
      usb: dwc3: add xHCI Host support
      usb: dwc3: always compile gadget side too
      usb: dwc3: move gadget prototypes to core.h
      usb: dwc3: depend on both Host and Gadget stacks
      usb: dwc3: ep0: SetAddress() won't be issued while Configured
      usb: dwc3: debugfs: add support for changing port mode
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: musb: headers cleanup
      usb: musb: drop ARCH dependency
      usb: gadget: udc-core: fix bug on soft_connect and srp interfaces
      usb: musb: gadget: don't call ->disconnect() on exit
      usb: gadget: core: fix bug when removing gadget drivers
      usb: gadget: core: allow everybody to read sysfs attributes
      Merge branch 'musb' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of master
      Merge remote-tracking branch 'linus/master'
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      Merge branch 'dwc3'
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      Merge branch 'dwc3'
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      Merge branch 'dwc3'
      usb: dwc3: gadget: don't disable endpoints on exit
      usb: dwc3: allow forcing a maximum speed
      usb: dwc3: calculate number of event buffers dynamically
      usb: dwc3: fetch mode of operation from HW
      usb: dwc3: add xHCI Host support
      usb: dwc3: always compile gadget side too
      usb: dwc3: move gadget prototypes to core.h
      usb: dwc3: depend on both Host and Gadget stacks
      usb: dwc3: ep0: SetAddress() won't be issued while Configured
      usb: dwc3: debugfs: add support for changing port mode
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: dwc3: fix few coding style problems
      usb: dwc3: fix sparse errors
      usb: gadget: udc-core: fix bug on soft_connect and srp interfaces
      usb: musb: gadget: don't call ->disconnect() on exit
      usb: gadget: core: fix bug when removing gadget drivers
      usb: gadget: core: allow everybody to read sysfs attributes
      usb: musb: headers cleanup
      usb: musb: drop ARCH dependency
      Merge branch 'fixes' into gadget
      Merge branches 'dwc3', 'fixes', 'gadget', 'xceiv', 'hci' and 'musb' into tmp
      Merge branch 'master' into tmp
      usb: musb: fix compilation breakage introduced by de47725
      Merge branch 'fixes'
      usb: dwc3: workaround: U1/U2 -> U0 transiton
      usb: dwc3: workaround: missing USB3 Reset event
      usb: dwc3: workaround: missing disconnect event
      Merge commit 'v3.2-rc2'
      usb: dwc3: omap: move to module_platform_driver
      Merge branch 'dwc3'
      usb: dwc3: gadget: don't disable endpoints on exit
      usb: dwc3: allow forcing a maximum speed
      usb: dwc3: calculate number of event buffers dynamically
      usb: dwc3: fetch mode of operation from HW
      usb: dwc3: add xHCI Host support
      usb: dwc3: always compile gadget side too
      usb: dwc3: move gadget prototypes to core.h
      usb: dwc3: depend on both Host and Gadget stacks
      usb: dwc3: ep0: SetAddress() won't be issued while Configured
      usb: dwc3: debugfs: add support for changing port mode
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: core: add DeviceTree match table
      usb: musb: headers cleanup
      usb: musb: drop ARCH dependency
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: dwc3: fix few coding style problems
      usb: dwc3: fix sparse errors
      usb: dwc3: workaround: U1/U2 -> U0 transiton
      usb: dwc3: workaround: missing USB3 Reset event
      usb: dwc3: workaround: missing disconnect event
      usb: dwc3: omap: move to module_platform_driver
      Merge branch 'dwc3' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on top of v3.2-rc3
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: dwc3: fix few coding style problems
      usb: dwc3: fix sparse errors
      usb: dwc3: workaround: U1/U2 -> U0 transiton
      usb: dwc3: workaround: missing USB3 Reset event
      usb: dwc3: workaround: missing disconnect event
      usb: dwc3: omap: move to module_platform_driver
      Merge branch 'dwc3'
      usb: dwc3: core: add DeviceTree match table
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: dwc3: fix few coding style problems
      usb: dwc3: fix sparse errors
      usb: dwc3: workaround: U1/U2 -> U0 transiton
      usb: dwc3: workaround: missing USB3 Reset event
      usb: dwc3: workaround: missing disconnect event
      usb: dwc3: omap: move to module_platform_driver
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: dwc3: ep0: fix GetStatus handling (again)
      Merge branch 'dwc3'
      usb: dwc3: ep0: fix GetStatus handling (again)
      Merge branch 'dwc3'
      usb: dwc3: gadget: fix stream enable bit
      Merge branch 'dwc3'
      Merge commit 'v3.2-rc4'
      Merge branch 'gadget'
      usb: dwc3: gadget: don't disable endpoints on exit
      usb: dwc3: allow forcing a maximum speed
      usb: dwc3: calculate number of event buffers dynamically
      usb: dwc3: fetch mode of operation from HW
      usb: dwc3: add xHCI Host support
      usb: dwc3: always compile gadget side too
      usb: dwc3: move gadget prototypes to core.h
      usb: dwc3: depend on both Host and Gadget stacks
      usb: dwc3: ep0: SetAddress() won't be issued while Configured
      usb: dwc3: debugfs: add support for changing port mode
      usb: dwc3: ep0: handle unexpected XferNotReady events
      usb: dwc3: move dwc3 device ID bitmap to core.c
      usb: dwc3: omap: add multiple instances support to OMAP
      usb: dwc3: core: drop DWC3_EVENT_BUFFERS_MAX
      usb: dwc3: fix few coding style problems
      usb: dwc3: fix sparse errors
      usb: dwc3: workaround: U1/U2 -> U0 transiton
      usb: dwc3: workaround: missing USB3 Reset event
      usb: dwc3: workaround: missing disconnect event
      usb: dwc3: omap: move to module_platform_driver
      usb: dwc3: ep0: fix GetStatus handling (again)
      usb: dwc3: gadget: fix stream enable bit
      usb: dwc3: ep0: fix for possible early delayed_status
      Merge branch 'dwc3'
      usb: musb: drop is_host_capable() and is_peripheral_capable()
      usb: musb: omap2430: fix compile warning
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of v3.2-rc5
      Revert "usb: musb: drop is_host_capable() and is_peripheral_capable()"
      Merge commit 'v3.2-rc6'
      Merge branch 'gadget'
      usb: gadget: introduce support for sg lists
      usb: dwc3: gadget: re-factor dwc3_prepare_trbs()
      usb: dwc3: gadget: don't return anything on prepare trbs
      usb: dwc3: gadget: don't force 'LST' always
      usb: dwc3: gadget: add support for SG lists
      usb: gadget: add generic map/unmap request utilities
      usb: dwc3: gadget: use generic map/unmap routines
      usb: gadget: langwell: use generic map/unmap functions
      usb: renesas: gadget: use generic map/unmap routines
      usb: gadget: amd5536: use generic map/unmap routines
      usb: gadget: r8a66597: use generic map/unmap routines
      usb: gadget: net2272: use generic map/umap routines
      usb: gadget: net2280: use generic map/unmap routines
      usb: gadget: goku: use generic map/unmap routines
      Merge branch 'gadget'
      Merge branch 'gadget-sg-support'
      Merge branch 'generic-map-unmap'
      usb: gadget: add generic map/unmap request utilities
      usb: dwc3: gadget: use generic map/unmap routines
      usb: gadget: langwell: use generic map/unmap functions
      usb: renesas: gadget: use generic map/unmap routines
      usb: gadget: amd5536: use generic map/unmap routines
      usb: gadget: r8a66597: use generic map/unmap routines
      usb: gadget: net2272: use generic map/umap routines
      usb: gadget: net2280: use generic map/unmap routines
      usb: gadget: goku: use generic map/unmap routines
      Merge branch 'xceiv' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'generic-map-unmap' into tmp
      Merge branch 'master' into tmp
      Rebuild USB Tree on top of 3.2-rc6
      usb: dwc3: gadget: use generic map/unmap routines
      usb: gadget: langwell: use generic map/unmap functions
      usb: renesas: gadget: use generic map/unmap routines
      usb: gadget: amd5536: use generic map/unmap routines
      usb: gadget: r8a66597: use generic map/unmap routines
      usb: gadget: net2272: use generic map/umap routines
      usb: gadget: net2280: use generic map/unmap routines
      usb: gadget: goku: use generic map/unmap routines
      Merge branch 'generic-map-unmap'
      usb: dwc3: fix Setup Buf handling
      usb: ch9: fix up MaxStreams helper
      usb: ch9: fix up MaxStreams helper
      Merge branch 'pending-upstream'
      usb: dwc3: gadget: re-factor USB2 test mode to a function
      usb: dwc3: gadget: allow testmodes changes via debugfs
      usb: dwc3: gadget: re-factor Link state change to a function
      usb: dwc3: gadget: allow Link state changes via debugfs
      Merge branch 'dwc3'
      usb: dwc3: ep0: tidy up Pending Request handling
      usb: dwc3: ep0: fix compile warning
      Merge branch 'dwc3' into tmp
      Merge branch 'xceiv' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on v3.2
      usb: dwc3: gadget: allow Link state changes via debugfs
      usb: dwc3: gadget: fix XferNotReady debug print
      usb: dwc3: gadget: use the descriptor pointer we hold
      usb: dwc3: ep0: move to CONFIGURED also on delayed status
      usb: dwc3: gadget: dynamically re-size TxFifos
      usb: dwc3: gadget: start core on Rx.Detect
      Merge branch 'dwc3'
      Merge commit 'v3.3-rc1'
      Merge branch 'musb'
      Merge branch 'gadget'
      Merge branch 'fixes'
      Merge branch 'fixes'
      usb: dwc3: gadget: dynamically re-size TxFifos
      usb: dwc3: gadget: start core on Rx.Detect
      usb: dwc3: omap: convert pdata to of property
      usb: dwc3: switch to GPL-only
      usb: musb: make modules behave better
      Merge branch 'fixes'
      Merge branch 'dwc3'
      Merge branch 'musb'
      Merge branch 'gadget'
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'master' into tmp
      Rebuild USB tree on v3.3-rc1
      usb: dwc3: debugfs: fix error check
      Merge branches 'musb' and 'dwc3'
      Merge tag 'v3.3-rc2'
      usb: dwc3: host: align on host device name
      Merge branch 'fixes'
      Merge branch 'dwc3'
      usb: dwc3: convert TRBs into bitshifts
      Merge branch 'dwc3-trb-shift'
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      Merge branch 'dwc3'
      usb: gadget: add generic map/unmap request utilities
      usb: dwc3: gadget: use generic map/unmap routines
      usb: gadget: langwell: use generic map/unmap functions
      usb: renesas: gadget: use generic map/unmap routines
      usb: gadget: amd5536: use generic map/unmap routines
      usb: gadget: r8a66597: use generic map/unmap routines
      usb: gadget: net2272: use generic map/umap routines
      usb: gadget: net2280: use generic map/unmap routines
      usb: gadget: goku: use generic map/unmap routines
      Merge branch 'gadget' into tmp
      Merge branch 'generic-map-unmap' into tmp
      Merge branch 'xceiv' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild USB tree on v3.3-rc3
      Merge branch 'gadget'
      Merge branch 'dwc3'
      Merge branches 'fixes', 'dwc3' and 'gadget', tag 'v3.3-rc4'
      Merge branches 'gadget', 'musb' and 'dwc3'
      Merge branch 'xceiv'
      Merge branch 'gadget'
      Merge tag 'v3.3-rc5'
      Merge tag 'dwc3-for-v3.4' into tmp
      Merge tag 'gadget-for-v3.4' into tmp
      Merge tag 'musb-for-v3.4' into tmp
      Merge tag 'xceiv-for-v3.4' into tmp
      Merge branch 'master' into tmp
      Rebuild USB Tree on v3.3-rc5
      Merge tag 'v3.3-rc7'
      Merge branch 'dwc3'
      usb: dwc3: fix temporary merge issue
      usb: dwc3: pci: fix another failure path in dwc3_pci_probe()
      Merge branch 'dwc3'
      Merge tag 'v3.3'
      usb: host: xhci: don't re-enable IE constantly
      usb: gadget: udc-core: stop UDC on device-initiated disconnect
      usb: dwc3: ep0: increment "actual" on bounced ep0 case
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge tag 'v3.4-rc2'
      Merge branches 'dwc3' and 'gadget'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'dwc3'
      usb: ch9: define Set SEL and Set Isoch Delay macros
      usb: dwc3: gadget: implement Global Command support
      usb: dwc3: gadget: increase setup buffer size
      usb: dwc3: ep0: implement Set SEL support
      usb: dwc3: ep0: implement support for Set Isoch Delay request
      Merge tag 'v3.4-rc4'
      Merge branch 'dwc3-usb30cv'
      Merge branch 'gadget'
      Merge branch 'xceiv'
      usb: dwc3: ep0: fix unused variable warning
      Merge tag 'fixes-for-v3.4-rc5'
      Merge tag 'v3.4-rc5'
      usb: dwc3: gadget: implement Global Command support
      usb: dwc3: ep0: implement Set SEL support
      usb: dwc3: gadget: increase setup buffer size
      usb: dwc3: ep0: implement support for Set Isoch Delay request
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge branch 'dwc3'
      Merge branch 'dwc3-hibernation'
      usb: dwc3: handle pending unaligned Control OUT data phase correctly
      usb: dwc3: ep0: switch over to IS_ALIGNED
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge branch 'gadget'
      Merge tag 'v3.4-rc7'
      Merge tag 'v3.4'
      usb: dwc3: handle pending unaligned Control OUT data phase correctly
      usb: dwc3: ep0: switch over to IS_ALIGNED
      usb: dwc3: ep0: align on function signature
      usb: dwc3: ep0: fix a in comment
      usb: dwc3: gadget: remove trailing semicolon
      Merge branch 'dwc3'
      usb: dwc3: ep0: fix merge issue
      Merge branch 'musb' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild USB Tree on v3.4
      usb: dwc3: ep0: fix a badly solved merge conflict
      Merge branch 'fixes' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'xceiv' into tmp
      Merge branch 'master' into tmp
      Merge branch 'dwc3'
      usb: gadget: tcm_usb_gadget: fix UASP_SS_EP_COMP_NUM_STREAMS
      Merge branch 'fixes'
      Merge tag 'v3.5-rc2'
      Merge branch 'dwc3'
      Merge branch 'xceiv' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild USB Tree on top of v3.5-rc2
      Merge tag 'v3.5-rc3'
      Merge branch 'fixes'
      Merge branch 'dwc3'
      Merge branch 'xceiv'
      Merge branch 'gadget'
      Merge tag 'v3.5-rc4'
      Merge branch 'fixes'
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge branch 'xceiv'
      Merge branch 'dwc3'
      Merge branch 'xceiv'
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge tag 'v3.5-rc6'
      Merge tag 'v3.5-rc7'
      Merge tag 'v3.5'
      usb: dwc3: gadget: set Ignore Sequence Number bit from ConnectDone Event
      usb: dwc3: ep0: drop unnecessary variable
      usb: dwc3: ep0: split the special cases on ep0_queue
      usb: dwc3: ep0: drop dead code
      usb: dwc3: ep0: ignore XferNotReady(STATUS) when we're not expecting it
      usb: dwc3: ep0: move DATA phase away from on-demand
      usb: dwc3: ep0: drop XferNotReady(DATA) support
      usb: dwc3: ep0: fix status phase delayed status direction
      usb: dwc3: ep0: make sure to reinitilize ep1 on STALL
      Merge branch 'dwc3-dev'
      Merge branch 'dwc3' into tmp
      Merge branch 'fixes' into tmp
      Merge branch 'gadget' into tmp
      Merge branch 'musb' into tmp
      Merge branch 'xceiv' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.6-rc1
      Merge branch 'musb'
      Merge branch 'dwc3'
      Merge branch 'musb'
      Merge branch 'musb'
      Merge branch 'dwc3'
      Merge branch 'musb'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'gadget'
      Merge branch 'fixes'
      Merge branch 'gadget'
      Merge branch 'dwc3'
      Merge branches 'xceiv' and 'musb'
      Merge branches 'musb' and 'xceiv'
      Merge branch 'gadget'
      Merge branch 'dwc3'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'musb'
      Merge branch 'dwc3'
      Merge branch 'xceiv'
      Merge tag 'v3.6-rc2'
      Merge branch 'musb'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'musb'
      Merge branch 'gadget'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branches 'fixes' and 'gadget'
      Merge branch 'fixes'
      Merge tag 'v3.6-rc3'
      Merge branches 'musb', 'dwc3' and 'fixes'
      Merge tag 'v3.6-rc4'
      Merge branch 'gadget'
      Merge branch 'xceiv'
      Merge branch 'gadget'
      Merge branch 'xceiv'
      Merge branch 'xceiv'
      Merge branch 'xceiv'
      Merge tag 'v3.6-rc5'
      Merge branch 'gadget'
      Merge branch 'gadget'
      Merge branch 'gadget'
      Merge branch 'gadget'
      Merge branches 'gadget', 'xceiv' and 'fixes'
      Merge branch 'musb'
      usb: dwc3: fix bad merge result
      Merge tag 'v3.6-rc7'
      Merge tag 'v3.6'
      Merge branch 'fixes' into tmp
      Merge branch 'dwc3' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.7-rc1
      Merge branches 'musb' and 'xceiv'
      Merge branch 'fixes'
      Merge branches 'dwc3', 'gadget', 'xceiv' and 'fixes'
      Merge tag 'v3.7-rc2'
      Merge branch 'fixes'
      Merge branch 'musb'
      Merge tag 'v3.7-rc3'
      Merge tag 'fixes-for-v3.7-rc4'
      Merge branches 'dwc3', 'gadget' and 'musb'
      Merge branch 'fixes'
      Merge branch 'xceiv'
      Merge tag 'v3.7-rc4'
      Merge branch 'gadget'
      Merge branch 'musb'
      Merge branch 'dwc3'
      Merge branch 'gadget'
      Merge branch 'musb'
      Merge branch 'musb'
      Merge branch 'musb'
      Merge tag 'v3.7-rc5'
      Merge branch 'dwc3'
      Merge branch 'musb'
      Merge branch 'gadget'
      Merge tag 'v3.7-rc6'
      Merge tag 'v3.7-rc7'
      Merge tag 'v3.7-rc8'
      usb: dwc3: decrease event buffer size
      Merge branch 'dwc3'
      Merge tag 'v3.7'
      Merge remote-tracking branch 'linus/master'
      Merge branch 'fixes'
      Merge branch 'dwc3'
      usb: dwc3: gadget: don't redefine 'ret'
      Merge branch 'dwc3'
      Merge tag 'v3.8-rc1'
      Merge tag 'v3.8-rc2'
      Merge tag 'v3.8-rc3'
      Merge branches 'musb' and 'gadget'
      Merge branches 'gadget', 'dwc3', 'musb' and 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild usb tree on top of v3.8-rc3
      Merge branches 'gadget' and 'musb'
      usb: gadget: f_uac2: fix compile warning
      Merge tag 'v3.8-rc4'
      Merge branch 'dwc3'
      usb: gadget: fix two sparse warnings
      Merge branch 'gadget'
      Merge branch 'fixes'
      Merge branch 'dwc3'
      Merge branch 'xceiv'
      Merge branch 'xceiv'
      usb: gadget: udc-core: allow udc class register gadget device
      usb: dwc3: gadget: let udc-core manage gadget->dev
      usb: musb: gadget: let udc-core manage gadget-dev
      usb: gadget: omap_udc: let udc-core manage gadget->dev
      usb: gadget: amd5536udc: let udc-core manage gadget->dev
      usb: gadget: at91_udc: let udc-core manage gadget->dev
      usb: gadget: atmel_usba_udc: let udc-core manage gadget->dev
      Merge branches 'gadget', 'musb', 'dwc3', 'xceiv' and 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.8-rc4
      Merge branch 'xceiv'
      Merge tags 'dwc3-for-v3.9' and 'xceiv-for-v3.9'
      Merge tag 'v3.8-rc5'
      usb: phy: fix Kconfig warning
      usb: gadget: bcm63xx_udc: let udc-core manage gadget->dev
      usb: gadget: dummy_hcd: let udc-core manage gadget->dev
      usb: gadget: fsl_qe_udc: let udc-core manage gadget->dev
      usb: gadget: fsl_udc_core: let udc-core manage gadget->dev
      usb: gadget: fusb300_udc: let udc-core manage gadget->dev
      usb: gadget: goku_udc: let udc-core manage gadget->dev
      usb: gadget: imx_udc: let udc-core manage gadget->dev
      usb: gadget: lpc32xx_udc: let udc-core manage gadget->dev
      usb: gadget: m66592-udc: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: fix a compile warning
      usb: gadget: mv_udc_core: let udc-core manage gadget->dev
      usb: gadget: net2272: let udc-core manage gadget->dev
      usb: gadget: net2280: let udc-core manage gadget->dev
      usb: gadget: pch_udc: let udc-core manage gadget->dev
      usb: gadget: r8a66597-udc: let udc-core manage gadget->dev
      usb: gadget: s3c-hsotg: let udc-core manage gadget->dev
      usb: gadget: s3c-hsudc: let udc-core manage gadget->dev
      usb: gadget: s3c2410_udc: let udc-core manage gadget->dev
      usb: renesas_usbhs: gadget: let udc-core manage gadget->dev
      usb: gadget: pxa25x_udc: let udc-core manage gadget->dev
      usb: gadget: pxa27x_udc: let udc-core manage gadget->dev
      usb: chipidea: register debugging syfs on our device
      usb: chipidea: let udc-core manage gadget->dev
      usb: gadget: drop now unnecessary flag
      Merge branch 'gadget-refactor-dev-registration'
      usb: common: introduce usb_state_string()
      usb: gadget: introduce gadget state tracking
      usb: dwc3: gadget: implement gadget state tracking
      usb: dwc3: remove our homebrew state mechanism
      usb: gadget: s3c-hsotg: switch over to usb_gadget_map/unmap_request()
      usb: gadget: amd5536udc: remove unused structure member
      usb: gadget: atmel_usba_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fsl_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fusb300: switch over to usb_gadget_map/unmap_request()
      usb: gadget: lpc32xx_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: mv_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: musb: gadget: switch over to usb_gadget_map/unmap_request()
      Merge branch 'udc-cable-status'
      Merge branch 'gadget-use-usb_gadget_map_request'
      Merge tag 'v3.8-rc6'
      Merge branch 'xceiv'
      Merge remote-tracking branch 'greg/usb-next'
      usb: dwc3: core: don't forget to free coherent memory
      usb: dwc3: core: explicitly setup and cleanup event buffers
      usb: dwc3: gadget: introduce and use enable/disable irq methods
      usb: dwc3: gadget: save state of pullups
      usb: dwc3: core: add power management support
      Merge branch 'dwc3-dev-pm-ops'
      Merge tag 'v3.8-rc7'
      Merge tag 'v3.8'
      Merge tag 'v3.9-rc1'
      Merge tag 'fixes-for-v3.9-rc2' into tmp-v3.9-rc1
      Merge branch 'master' into tmp-v3.9-rc1
      Merge branch 'tmp-v3.9-rc1'
      Merge tag 'fixes-for-v3.9-rc3'
      usb: gadget: udc-core: allow udc class register gadget device
      usb: dwc3: gadget: let udc-core manage gadget->dev
      usb: musb: gadget: let udc-core manage gadget-dev
      usb: gadget: omap_udc: let udc-core manage gadget->dev
      usb: gadget: amd5536udc: let udc-core manage gadget->dev
      usb: gadget: at91_udc: let udc-core manage gadget->dev
      usb: gadget: atmel_usba_udc: let udc-core manage gadget->dev
      usb: gadget: bcm63xx_udc: let udc-core manage gadget->dev
      usb: gadget: dummy_hcd: let udc-core manage gadget->dev
      usb: gadget: fsl_qe_udc: let udc-core manage gadget->dev
      usb: gadget: fsl_udc_core: let udc-core manage gadget->dev
      usb: gadget: fusb300_udc: let udc-core manage gadget->dev
      usb: gadget: goku_udc: let udc-core manage gadget->dev
      usb: gadget: imx_udc: let udc-core manage gadget->dev
      usb: gadget: lpc32xx_udc: let udc-core manage gadget->dev
      usb: gadget: m66592-udc: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: let udc-core manage gadget->dev
      usb: gadget: mv_u3d_core: fix a compile warning
      usb: gadget: mv_udc_core: let udc-core manage gadget->dev
      usb: gadget: net2272: let udc-core manage gadget->dev
      usb: gadget: net2280: let udc-core manage gadget->dev
      usb: gadget: pch_udc: let udc-core manage gadget->dev
      usb: gadget: r8a66597-udc: let udc-core manage gadget->dev
      usb: gadget: s3c-hsotg: let udc-core manage gadget->dev
      usb: gadget: s3c-hsudc: let udc-core manage gadget->dev
      usb: gadget: s3c2410_udc: let udc-core manage gadget->dev
      usb: renesas_usbhs: gadget: let udc-core manage gadget->dev
      usb: gadget: pxa25x_udc: let udc-core manage gadget->dev
      usb: gadget: pxa27x_udc: let udc-core manage gadget->dev
      usb: chipidea: let udc-core manage gadget->dev
      usb: gadget: drop now unnecessary flag
      usb: gadget: s3c-hsotg: switch over to usb_gadget_map/unmap_request()
      usb: gadget: amd5536udc: remove unused structure member
      usb: gadget: atmel_usba_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fsl_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: gadget: fusb300: switch over to usb_gadget_map/unmap_request()
      usb: gadget: lpc32xx_udc: switch over to usb_gadget_map/unmap_request()
      usb: gadget: mv_udc_core: switch over to usb_gadget_map/unmap_request()
      usb: musb: gadget: switch over to usb_gadget_map/unmap_request()
      usb: dwc3: core: explicitly setup and cleanup event buffers
      usb: dwc3: gadget: introduce and use enable/disable irq methods
      usb: dwc3: gadget: save state of pullups
      usb: dwc3: core: add power management support
      usb: dwc3: omap: introduce enable/disable IRQ methods
      usb: dwc3: omap: remove unused fields from private structure
      usb: dwc3: omap: add basic suspend/resume support
      usb: dwc3: pci: add basic suspend/resume support
      usb: musb: core: remove unnecessary pr_info()
      usb: musb: switch over to devm_ioremap_resource()
      usb: musb: gadget: delete wrong comment
      usb: musb: force PIO-only if we're building multiplatform kernels
      usb: musb: make davinci and da8xx glues depend on BROKEN
      usb: musb: dsps: add missing include
      usb: musb: ux500_dma: kill compile warnings
      usb: musb: dsps: fix possible compile warning
      usb: musb: gadget: fix compile warning
      usb: musb: Kconfig: drop unnecessary dependencies
      usb: dwc3: core: remove bogus comment to our structure
      usb: dwc3: add a flags field to event buffer
      usb: dwc3: add count field to event buffer
      usb: dwc3: gadget: move to threaded IRQ
      usb: common: introduce usb_state_string()
      usb: gadget: introduce gadget state tracking
      usb: dwc3: gadget: implement gadget state tracking
      usb: dwc3: remove our homebrew state mechanism
      usb: dwc3: debugfs: add two missing Link States
      usb: dwc3: debugfs: when unknown, print only the state value
      usb: dwc3: debugfs: mark our regset structure const
      usb: dwc3: debugfs: improve debugfs file creation
      usb: dwc3: core: avoid checkpatch.pl warning
      usb: gadget: pxa27x_udc: drop ARCH_PXA dependency
      usb: gadget: pxa27x_udc: switch over to module_platform_driver
      usb: gadget: udc-core: copy dma-related parameters from parent
      usb: gadget: udc-core: initialize parent
      usb: gadget: chipidea: remove unnecessary initializations
      usb: gadget: amd5536udc: remove unnecessary initializations
      usb: gadget: atmel_usba_udc: remove unnecessary initializations
      usb: gadget: bcm63xx_udc: remove unnecessary initializations
      usb: gadget: fusb300_udc: remove unnecessary initializations
      usb: gadget: goku_udc: remove unnecessary initializations
      usb: gadget: goku_udc: remove unused macro
      usb: gadget: imx_udc: remove unnecessary initializations
      usb: gadget: m66592-udc: remove unnecessary initializations
      usb: dwc3: gadget: remove unnecessary initializations
      usb: gadget: mv_u3d_core: remove unnecessary initializations
      usb: gadget: mv_udc_core: remove unnecessary initializations
      usb: gadget: net2272: remove unnecessary initializations
      usb: gadget: net2280: remove unnecessary initializations
      usb: gadget: omap_udc: remove unnecessary initializations
      usb: gadget: pch_udc: remove unnecessary initializations
      usb: gadget: pxa25x_udc: remove unnecessary initializations
      usb: gadget: pxa27x_udc: remove unnecessary initializations
      usb: gadget: r8a66597-udc: remove unnecessary initializations
      usb: gadget: s3c-hsotg: remove unnecessary initializations
      usb: gadget: s3c-hsudc: remove unnecessary initializations
      usb: gadget: s3c2410_udc: remove unnecessary initializations
      usb: musb: gadget: remove unnecessary initializations
      usb: gadget: fsl_udc_core: remove unnecessary initializations
      usb: gadget: udc-core: initialize gadget->dev.driver
      usb: dwc3: gadget: don't touch gadget.dev.driver
      usb: gadget: amd5536udc: don't touch gadget.dev.driver
      usb: gadget: at91_udc: don't touch gadget.dev.driver
      usb: gadget: atmel_usba_udc: don't touch gadget.dev.driver
      usb: gadget: bcm63xx_udc: don't touch gadget.dev.driver
      usb: gadget: dummy_hcd: don't touch gadget.dev.driver
      usb: gadget: fsl_qe_udc: don't touch gadget.dev.driver
      usb: gadget: fsl_udc_core: don't touch gadget.dev.driver
      usb: gadget: fusb300_udc: don't touch gadget.dev.driver
      usb: gadget: goku_udc: don't touch gadget.dev.driver
      usb: gadget: imx_udc: don't touch gadget.dev.driver
      usb: gadget: lpc32xx_udc: don't touch gadget.dev.driver
      usb: gadget: m66592-udc: don't touch gadget.dev.driver
      usb: gadget: mv_u3d_core: don't touch gadget.dev.driver
      usb: gadget: mv_udc_core: don't touch gadget.dev.driver
      usb: gadget: net2272: don't touch gadget.dev.driver
      usb: gadget: net2280: don't touch gadget.dev.driver
      usb: gadget: omap_udc: don't touch gadget.dev.driver
      usb: gadget: pch_udc: don't touch gadget.dev.driver
      usb: gadget: pxa25x_udc: don't touch gadget.dev.driver
      usb: gadget: pxa27x_udc: don't touch gadget.dev.driver
      usb: gadget: s3c-hsotg: don't touch gadget.dev.driver
      usb: gadget: s3c-hsudc: don't touch gadget.dev.driver
      usb: gadget: s3c2410_udc: don't touch gadget.dev.driver
      usb: renesas: gadget: don't touch gadget.dev.driver
      usb: gadget: udc-core: introduce usb_add_gadget_udc_release()
      usb: chipidea: udc: don't assign gadget.dev.release directly
      usb: dwc3: gadget: don't assign gadget.dev.release directly
      usb: gadget: amd5536udc: don't assign gadget.dev.release directly
      usb: gadget: bcm63xx_udc: don't assign gadget.dev.release directly
      usb: gadget: dummy_hcd: don't assign gadget.dev.release directly
      usb: gadget: fsl_qe_udc: don't assign gadget.dev.release directly
      usb: gadget: fsl_udc_core: don't assign gadget.dev.release directly
      usb: gadget: fusb300_udc: don't assign gadget.dev.release directly
      usb: gadget: goku_udc: don't assign gadget.dev.release directly
      usb: gadget: m66592-udc: don't assign gadget.dev.release directly
      usb: gadget: mv_u3d_core: don't assign gadget.dev.release directly
      usb: gadget: mv_udc_core: don't assign gadget.dev.release directly
      usb: gadget: net2272: don't assign gadget.dev.release directly
      usb: gadget: net2280: don't assign gadget.dev.release directly
      usb: gadget: omap_udc: don't assign gadget.dev.release directly
      usb: gadget: pch_udc: don't assign gadget.dev.release directly
      usb: gadget: r8a66597-udc: don't assign gadget.dev.release directly
      usb: gadget: s3c-hsotg: don't assign gadget.dev.release directly
      usb: musb: gadget: don't assign gadget.dev.release directly
      usb: renesas: gadget: don't assign gadget.dev.release directly
      usb: gadget: udc-core: remove protection when setting gadget.dev.release
      usb: gadget: udc-core: anywone can read 'speed' attributes
      usb: dwc3: core: define more revisions
      usb: dwc3: workaround: unexpected transtion U3 -> RESUME
      usb: dwc3: calculate the number of endpoints
      usb: dwc3: gadget: use num_(in|out)_eps from HW params
      usb: otg: prefix otg_state_string with usb_
      usb: otg: move usb_otg_state_string to usb-common.c
      usb: phy: convert EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
      usb: phy: move all PHY drivers to drivers/usb/phy/
      usb: phy: make it a menuconfig
      usb: power: pda_power: check against CONFIG_USB_PHY
      usb: gadget: mv_udc_core: check against CONFIG_USB_PHY
      usb: ehci: marvel: check against CONFIG_USB_PHY
      usb: ehci: tegra: check against CONFIG_USB_PHY
      usb: phy: remove CONFIG_USB_OTG_UTILS
      usb: phy: rename all phy drivers to phy-$name-usb.c
      usb: phy: isp1301: give it a context structure
      usb: phy: introduce ->set_vbus() method
      usb: phy: isp1301: implement PHY API
      Merge tag 'fixes-for-v3.9-rc2' into tmp
      Merge tag 'fixes-for-v3.9-rc3' into tmp
      Merge branch 'testing-rebase-fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.9-rc2
      usb: gadget: net22xx: fix ->disconnect reporting
      Merge branch 'fixes' into tmp
      Merge branch 'next' into tmp
      Merge branch 'master' into tmp
      rebuild tree on v3.9-rc3
      Merge branch 'next'
      Merge branch 'fixes'
      Merge branch 'next'
      Merge branch 'next'
      Merge branch 'fixes'
      Merge tag 'v3.9-rc4'
      Merge branch 'next'
      Merge tag 'v3.9-rc5'
      Merge branch 'next'
      Merge tag 'usb-for-v3.10'
      Merge tag 'usb-for-v3.10'
      Merge tag 'usb-for-v3.10' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.9-rc5
      Merge tag 'usb-for-v3.10'
      Merge branch 'next'
      Merge tag 'v3.9-rc8'
      Merge tag 'v3.9'
      Merge tag 'v3.10-rc1'
      Merge tag 'v3.10-rc2'
      Merge branch 'fixes'
      Merge tag 'v3.10-rc3'
      Merge branch 'next'
      Merge tag 'usb-for-v3.11'
      Merge tag 'v3.10-rc5'
      Merge tag 'v3.10-rc6'
      Merge tag 'v3.10-rc7'
      Merge tag 'v3.10'
      usb: dwc3: make glue layers selectable
      usb: gadget: remove imx_udc
      usb: dwc3: gadget: don't request IRQs in atomic
      usb: dwc3: switch to GPL v2 only
      usb: phy: protect against NULL phy pointers
      usb: common: introduce of_usb_get_maximum_speed()
      usb: dwc3: let non-DT platforms pass tx-fifo-resize flag;
      usb: dwc3: make maximum-speed a per-instance attribute
      usb: dwc3: core: switch to snps,dwc3
      usb: dwc3: gadget: drop dwc3 manual phy control
      usb: dwc3: omap: switch over to devm_ioremap_resource()
      usb: dwc3: core: switch over to devm_ioremap_resource()
      usb: dwc3: gadget: move debugging print around
      usb: dwc3: gadget: move direction setting up
      usb: dwc3: gadget: add a debugging print when initializing endpoints
      usb: dwc3: core: don't redefine DWC3_DCFG_LPM_CAP
      usb: dwc3: gadget: don't enable LPM early
      usb: dwc3: core: introduce and use macros for Event Size register
      usb: dwc3: gadget: get rid of IRQF_ONESHOT
      usb: dwc3: gadget: rename dwc3_process_event_buf
      usb: dwc3: gadget: introduce dwc3_process_event_buf
      Merge tag 'fixes-for-v3.11-rc1'
      usb: gadget: udc-core: move sysfs_notify() to a workqueue
      usb: dwc3: ep0: only change to ADDRESS if set_config() succeeds
      usb: dwc3: ep0: don't change to configured state too early
      Merge tag 'v3.11-rc2'
      Merge branch 'testing'
      Merge tag 'v3.11-rc3'
      Merge branch 'fixes' into tmp
      Merge branch 'next' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.11-rc3
      Merge branch 'fixes'
      Merge branch 'fixes'
      Merge branch 'next'
      Merge tag 'v3.11-rc7'
      Merge branch 'fixes' into tmp
      Merge branch 'master' into tmp
      Rebuild tree on v3.12-rc1
      Merge tag 'v3.12-rc4'
      Merge branch 'next'
      Merge branch 'next'
      Merge tag 'v3.12-rc5'
      Merge tag 'v3.12-rc6'
      Merge remote-tracking branch 'linus/master'
      Merge remote-tracking branch 'linus/master'
      Merge tag 'v3.13-rc1'
      usb: phy: generic: fix how we find out about our resources
      usb: gadget: storage: fix sparse warning
      usb: gadget: ffs: fix sparse warning
      usb: gadget: tcm_usb_gadget: mark bot_cleanup_old_alt static
      Merge tag 'fixes-for-v3.13-rc2'

Fengguang Wu (1):
      usb: gadget: zero: module parameters can be static

George Cherian (1):
      usb: gadget: f_mass_storage: call try_to_freeze only when its safe

Gerard Cauvy (2):
      usb: dwc3: ep0: fix SetFeature(TEST)
      usb: dwc3: ep0: add a default case for SetFeature command

Grazvydas Ignotas (3):
      usb: musb: fix shutdown while usb gadget is in use
      usb: musb: fix some runtime_pm issues
      usb: musb: wake the device before ulpi transfers

Greg Kroah-Hartman (1):
      usb: musb: get rid of unused proc_dir_entry

Guenter Roeck (1):
      usb/gadget: (fusb300_udc) Remove unused function fusb300_ep0_complete

Heikki Krogerus (5):
      usb: otg: mv_otg: Start using struct usb_otg
      usb: Convert all users to new usb_phy
      usb: otg: Remove OTG specific members from usb_phy
      usb: otg: Convert all users to pass struct usb_otg for OTG functions
      usb: phy: generic: fix a compiler warning

Hema HK (5):
      usb: musb: OMAP4430: Fix usb device detection if connected during boot
      usb: musb: OMAP4430: Fix usb device detection if connected during boot
      usb: musb: omap2+: save and restore OTG_INTERFSEL
      usb: musb: omap2+: save and restore OTG_INTERFSEL
      usb: musb: omap2+: save and restore OTG_INTERFSEL

Huang Rui (2):
      usb: dwc3: clean up redundant parameter comment
      usb: dwc3: fix typo in comment of dwc3_ep

Ido Shayevitz (20):
      usb: gadget: Clear usb_endpoint_descriptor inside the struct usb_ep on disable
      usb: gadget: Clear usb_endpoint_descriptor inside the struct usb_ep on disable
      usb: gadget: Update ci13xxx_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: dwc3: Update dwc3 udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update amd5536udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update at91_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update atmel_usba_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fsl_qe_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fsl_udc_core to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update fusb300_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update goku_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update langwell_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update m66592-udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update mv_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update omap_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update pxa25x_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update r8a66597-udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update s3c2410_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update pch_udc to use usb_endpoint_descriptor inside the struct usb_ep
      usb: gadget: Update s3c-hsudc to use usb_endpoint_descriptor inside the struct usb_ep

Jassi Brar (3):
      usb: gadget: webcam: return correct result on bind
      USB: Gadget: Webcam: Return correct result of bind
      usb: gadget: webcam: return correct result on bind

Jesper Juhl (1):
      usb: renesas: silence uninitialized variable report in usbhsg_recip_run_handle()

Jingoo Han (1):
      usb: dwc3: exynos: use devm_ functions

Jisheng Zhang (1):
      usb: phy: phy-mxs-usb: set the correct platform drvdata

John Stultz (2):
      usb: musb: fix oops on musb_gadget_pullup
      usb: musb: fix oops on musb_gadget_pullup

Julia Lawall (4):
      usb: host: ohci: omap3: test the just-initialized value
      usb: host: ohci: omap3: test the just-initialized value
      usb: host: ohci: omap3: test the just-initialized value
      usb: gadget: s3c-hsotg.c: fix error return code

Keshava Munegowda (6):
      arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
      arm: omap: usb: register hwmods of usbhs
      arm: omap: usb: device name change for the clk names of usbhs
      arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
      arm: omap: usb: register hwmods of usbhs
      arm: omap: usb: device name change for the clk names of usbhs

Kevin Cernekee (2):
      usb_gadget_remove_driver() runs through a four-step sequence to shut down     the gadget driver.  For the case of a composite gadget + at91 UDC, this     would look like:
      usb: gadget: udc-core: Race between disconnect/unbind and setup

Kevin Hilman (1):
      usb: musb: PM: fix context save/restore in suspend/resume path

Kishon Vijay Abraham I (10):
      usb: musb: omap: fix crash when musb glue (omap) gets initialized
      usb: gadget: udc-core: fix asymmetric calls in remove_driver
      usb: dwc3: core: fix incorrect usage of resource pointer
      usb: dwc3: core: fix incorrect usage of resource pointer
      usb: otg: add an api to bind the usb controller and phy
      usb: otg: utils: add facilities in phy lib to support multiple PHYs of same type
      usb: otg: add device tree support to otg library
      usb: dwc3: omap: minor fixes to get dt working
      usb: dwc3: omap: remove platform data associated with dwc3-omap
      usb: dwc3: omap: stop using nop-usb-xceiv

Klaus Schwarzkopf (1):
      usb: gadget: add new usb gadget for ACM and mass storage

Kuninori Morimoto (127):
      usb: renesas_usbhs: modify pipe direction flags
      usb: renesas_usbhs: fifo became independent from pipe.
      usb: renesas_usbhs: divide data transfer functions
      usb: renesas_usbhs: modify packet queue control method
      usb: renesas_usbhs: modify data transfer method
      usb: renesas_usbhs: modify data transfer interrupt
      usb: renesas_usbhs: remove usbhsg_queue_get
      usb: renesas_usbhs: shrink spin lock area
      usb: renesas_usbhs: add usbhsf_fifo
      usb: renesas_usbhs: add pipe/fifo link
      usb: renesas_usbhs: tifyup packet start timing
      usb: renesas_usbhs: tidyup pio handler name
      usb: renesas_usbhs: add DMAEngine support
      usb: renesas_usbhs: fixup connection fail
      usb: renesas_usbhs: put obtained dma channel info to debug message
      usb: renesas_usbhs: use dma handler
      usb: renesas_usbhs: fixup comment-out
      usb: renesas_usbhs: compile/config are rescued
      usb: renesas_usbhs: care buff alignment when dma handler
      usb: renesas_usbhs: inaccessible pipe is not an error
      usb: renesas_usbhs: support multi driver
      usb: add usb_endpoint_maxp() macro
      USB: use usb_endpoint_maxp() instead of le16_to_cpu()
      usb: gadget: renesas_usbhs: add suspend/resume support
      usb: gadget: renesas_usbhs: move USBHSF_PKT_xxx to pipe.c
      usb: gadget: renesas_usbhs: remove desc from usbhs_pipe_malloc
      usb: gadget: renesas_usbhs: each pipe hold maxpacket size
      usb: gadget: renesas_usbhs: struct usbhs_pipe hold handler
      usb: gadget: renesas_usbhs: tidyup INTENB0 method
      usb: gadget: renesas_usbhs: change usbhsc_bus_ctrl() to usbsc_set_buswait()
      usb: gadget: renesas_usbhs: add bus control functions
      usb: gadget: renesas_usbhs: add usbhs_bus_get_speed()
      usb: gadget: renesas_usbhs: move usbhsp_type() to usbhs_pipe_type()
      usb: gadget: renesas_usbhs: move usbhs_usbreq_get/set_val() to common.c
      usb: gadget: renesas_usbhs: remove unneeded parameter from usbhs_mod_is_host()
      usb: gadget: renesas_usbhs: add usbhs_dcp_dir_for_host()
      usb: gadget: renesas_usbhs: add struct usbhs_priv to packet done function
      usb: gadget: renesas_usbhs: add device select support in usbhs_pipe_config_update()
      usb: gadget: renesas_usbhs: add usbhs_pipe_name()
      usb: gadget: renesas_usbhs: move done callback to struct usbhs_pkt
      usb: gadget: renesas_usbhs: disable auto paket start on usbhs_pkt_push()
      usb: gadget: renesas_usbhs: modify pipe sequence settings
      usb: gadget: renesas_usbhs: disable pipe on top of interrupt
      usb: gadget: renesas_usbhs: support otg pin control
      usb: gadget: renesas_usbhs: make sure SOF packet sending-out control
      usb: gadget: renesas_usbhs: add usbhs_set_device_speed() support for host
      usb: gadget: renesas_usbhs: add INTSTS1 interrupt support
      usb: gadget: renesas_usbhs: add data/status stage handler
      usb: gadget: renesas_usbhs: usbhs_dcp_control_transfer_done() cares mod_host
      usb: gadget: renesas_usbhs: add mod_host support
      usb: gadget: renesas_usbhs: bugfix: don't modify platform data
      usb: gadget: renesas_usbhs: fixup driver compile style
      usb: gadget: renesas_usbhs: fixup struct completion usage
      usb: gadget: renesas_usbhs: fixup bogus conversion
      usb: gadget: renesas_usbhs: fixup section mismatch warning
      usb: gadget: renesas_usbhs: bugfix: care pipe direction
      usb: gadget: renesas_usbhs: bugfix: disable irq when device stop
      usb: gadget: renesas_usbhs: bugfix: set DATA0 when usbhsh_endpoint_alloc()
      usb: gadget: renesas_usbhs: remove usbhs_sys_hispeed_ctrl()
      usb: gadget: renesas_usbhs: remove usbhs_sys_usb_ctrl()
      usb: gadget: renesas_usbhs: tidyup usbhs_sys_clock_ctrl() was local function
      usb: gadget: renesas_usbhs: tidyup mod_host request variable name
      usb: gadget: renesas_usbhs: tidyup the unit of detection_delay
      usb: gadget: renesas_usbhs: add platform power control function
      usb: gadget: renesas_usbhs: unified callback function
      usb: gadget: renesas_usbhs: drop dependency for mod_gadget
      usb: gadget: renesas_usbhs: cleanup complicated ureq alloc/free
      usb: gadget: renesas_usbhs: usbhsh_ureq_alloc/free() care urb->hcpriv
      usb: gadget: renesas_usbhs: modify function name of usbhs_set_device_xx()
      usb: gadget: renesas_usbhs: cleanup usbhs_endpoint_disable()
      usb: gadget: renesas_usbhs: usbhs_set_device_config() care upphub/hubport
      usb: gadget: renesas_usbhs: remove usbhsh_request list
      usb: gadget: renesas_usbhs: check device0 status when alloc
      usb: gadget: renesas_usbhs: adds spin lock area on mod_host
      usb: gadget: renesas_usbhs: cleanup usbhsh_endpoint_xxx()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_xx_queue_push()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_endpoint_xx()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_device_xx()
      usb: renesas_usbhs: fixup device_register timing
      usb: renesas_usbhs: fixup signal the driver that cable was disconnected
      usb: renesas_usbhs: fixup gadget.dev.driver when udc_stop.
      usb: renesas_usbhs: fixup driver speed
      usb: gadget: renesas_usbhs: remove usbhs_sys_hispeed_ctrl()
      usb: gadget: renesas_usbhs: remove usbhs_sys_usb_ctrl()
      usb: gadget: renesas_usbhs: tidyup usbhs_sys_clock_ctrl() was local function
      usb: gadget: renesas_usbhs: tidyup mod_host request variable name
      usb: gadget: renesas_usbhs: tidyup the unit of detection_delay
      usb: gadget: renesas_usbhs: add platform power control function
      usb: gadget: renesas_usbhs: unified callback function
      usb: gadget: renesas_usbhs: drop dependency for mod_gadget
      usb: gadget: renesas_usbhs: cleanup complicated ureq alloc/free
      usb: gadget: renesas_usbhs: usbhsh_ureq_alloc/free() care urb->hcpriv
      usb: gadget: renesas_usbhs: modify function name of usbhs_set_device_xx()
      usb: gadget: renesas_usbhs: cleanup usbhs_endpoint_disable()
      usb: gadget: renesas_usbhs: usbhs_set_device_config() care upphub/hubport
      usb: gadget: renesas_usbhs: remove usbhsh_request list
      usb: gadget: renesas_usbhs: check device0 status when alloc
      usb: gadget: renesas_usbhs: adds spin lock area on mod_host
      usb: gadget: renesas_usbhs: cleanup usbhsh_endpoint_xxx()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_xx_queue_push()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_endpoint_xx()
      usb: gadget: renesas_usbhs: parameter cleanup for usbhsh_device_xx()
      usb: renesas_usbhs: remove superfluous usbhs_lock from recip handler
      usb: renesas_usbhs: add usbhs_pipe_is_stall()
      usb: renesas_usbhs: add basic USB_REQ_SET_FEATURE support
      usb: renesas_usbhs: add basic USB_REQ_GET_STATUS support
      usb: renesas_usbhs: send packet in necessary timing.
      usb: renesas_usbhs: call usbhsg_queue_pop() when pipe disable.
      usb: renesas_usbhs: add test-mode support
      usb: renesas_usbhs: remove the_controller_link
      usb: renesas_usbhs: care HCD_FLAG_SAW_IRQ bit on mod_host
      usb: renesas_usbhs: modify device attach method
      usb: renesas_usbhs: add usbhsh_endpoint_detach_all() for error case
      usb: renesas_usbhs: add usbhs_pipe_attach() method
      usb: renesas_usbhs: care pipe sequence
      usb: renesas_usbhs: disable attch irq after device attached
      usb: renesas_usbhs: add usbhsh_is_running()
      usb: renesas_usbhs: care usb_hcd_giveback_urb() status
      usb: renesas_usbhs: add force packet remove method
      usb: renesas_usbhs: show error reason on usbhsh_urb_enqueu()
      usb: renesas_usbhs: bugfix: add .release function to gpriv->gadget.dev
      usb: renesas_usbhs: mod_host: add missing .bus_suspend/resume
      usb: renesas_usbhs: fixup resume method for autonomy mode
      usb: renesas_usbhs: fixup DMA transport data alignment
      usb: renesas_usbhs: remove debug information from usbhsh_hub_status_data()
      usb: renesas_usbhs: host: add endpoint user counter
      usb: renesas_usbhs: tidyup original usbhsx_for_each_xxx macro

Li Yang (1):
      usb: gadget: fsl_udc: fix dequeuing a request in progress

Linus Walleij (1):
      usb: gadget: fix pxa25x compilation problems

Luciano Coelho (1):
      usb: musb: hdrc: fix dependency on USB_GADGET_DUALSPEED in Kconfig

Lukasz Majewski (18):
      usb:hsotg:samsung: Remove platform dependency from s3c-hsotg
      usb:hsotg:samsung: Remove platform dependent functions from s3c-hsotg
      usb:hsotg:samsung: Wrappers for USB PHY methods
      usb:hsotg:samsung: Use of regulator_bulk_* functions for USB regulators
      usb:hsotg:samsung: NAK management for EP0 (Setup stage of control transfers)
      usb:hsotg:samsung: Sending ZLP packet for IN EP0 transfers
      usb:hsotg:samsung: Extract core initialization function
      usb:hsotg:samsung: Remove Disconnect Interrupt handler
      usb:hsotg:samsung: Rename s3c_hsotg_disconnect function
      usb:hsotg:samsung: Cable disconnection recovery code
      usb:hsotg:samsung: Determine number of EPs from HW configuration register
      usb:hsotg:samsung: Use new udc_start and udc_stop callbacks
      usb:hsotg:samsung: Comments reorganization and cleanup
      usb:hsotg:samsung: Remove our_hsotg global pointer
      usb:hsotg:samsung: Add release function for hsotg device
      usb:hsotg:samsung: Remove the S3C_ prefix from registers definition.
      usb:hsotg:samsung: Use clk_prepare_enable and clk_disable_unprepare
      usb:hsotg:samsung: err_irq: support for probe function

Marc Kleine-Budde (9):
      USB: gadgetfs: gadgetfs_disconnect: fix inconsistent lock state
      USB: ci13xxx_udc: fix deadlock during rmmod
      USB: ci13xxx_udc: fix debug trace code
      USB: ci13xxx_msm: add module license
      USB: ci13xxx_udc: make suspend and resume in gadget driver optional
      USB: ci13xxx_udc: handle controllers with less than 16 EPs
      USB: ci13xxx_udc: make suspend and resume in gadget driver optional
      USB: ci13xxx_udc: handle controllers with less than 16 EPs
      usb: phy: mxs: use readl(), writel() instead of the _relaxed() versions

Mark Brown (1):
      USB: gadget.h depends on ch9.h so include ch9.h directly

Masanari Iida (1):
      usb: fix typo in drivers/usb

Mian Yousaf Kaukab (1):
      usb: musb: remove incorrectly added ARCH_U5500 define

Michael BRIGHT (1):
      usb: gadget: inode: remove compile warning

Michael Grzeschik (4):
      USB: ci13xxx_udc: fix logic to mark request dma addresses as invalid
      usb: gadget: u_ether: fix kworker 100% CPU issue with still used interfaces in eth_stop
      usb composite: fix locking in usb_function_activate
      usb: gadget: composite: reset delayed_status on reset_config

Michal Nazarewicz (9):
      usb: Provide usb_speed_string() function
      usb: gadget: replace usb_gadget::is_dualspeed with max_speed
      usb: gadget: rename usb_gadget_driver::speed to max_speed
      usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED
      usb: udc: Fix gadget driver's speed check in various UDC drivers
      usb: gadget: replace usb_gadget::is_dualspeed with max_speed
      usb: gadget: rename usb_gadget_driver::speed to max_speed
      usb: gadget: f_mass_storage: remove deprecated fsg_add()
      usb: phy: remove dead code

Mike Frysinger (5):
      usb: musb: update musb_platform_ops docs to match code
      usb: musb: update musb_platform_ops docs to match code
      usb: musb: update musb_platform_ops docs to match code
      usb: musb: update musb_platform_ops docs to match code
      usb: musb: update musb_platform_ops docs to match code

Ming Lei (3):
      usb: host: ehci-omap: fix .remove and failure handling path of .probe(v1)
      usb: musb: core: fix failure path
      usb: musb: fix dependency on transceiver driver

Moiz Sonasath (2):
      USB: OTG: Use work_queue in set_vbus for TWL6030 transciever
      usb: dwc3: ep0: Handle requests greater than wMaxPacketSize

Márton Németh (3):
      usb: musb: host: compare status for negative error values
      usb: musb: host: compare status for negative error values
      usb: musb: host: compare status for negative error values

Neil Zhang (26):
      usb: gadget: mv_udc: refine the driver structure
      usb: gadget: mv_udc: add section information
      usb: gadget: mv_udc: fix kernel panic on some platforms
      usb: gadget: mv_udc: fix a clerical error
      usb: gadget: mv_udc: ep0 needn't set toggle flag
      usb: gadget: mv_udc: init next dtd ptr for dqh when init ep0
      usb: gadget: mv_udc: fix bug when handle setup package.
      usb: gadget: mv_udc: add missing spinlock in ep enable/disable
      usb: gadget: mv_udc: set unused endpoint with right type
      usb: gadget: mv_udc: rewrite fifo flush
      usb: gadget: mv_udc: correct ep0 state
      usb: gadget: mv_udc: add shutdown function for it
      usb: gadget: mv_udc: fix dtd dma confusion
      usb: gadget: mv_udc: use DMA API for status_req's dma address
      usb: gadget: mv_udc: add test mode support
      usb: gadget: mv_udc: add clock gating support
      usb: gadget: mv_udc: add otg relative code
      usb: gadget: mv_udc: disable ISR when stopped
      usb: gadget: mv_udc: refine the clock relative code
      usb: gadget: mv_udc: refine suspend/resume function
      usb: gadget: mv_udc: replace some debug info
      usb: gadget: mv_udc: reduce the delay interval
      usb: gadget: mv_udc: remove unused code
      usb: gadget: mv_udc: avoid sleeping on spinlock
      usb: gadget: mv_udc: enable stream mode
      usb: gadget: mv_udc: fix boot up hang

Paul Walmsley (1):
      usb: otg: isp1301_omap: resolve unused variable warning from gcc

Paul Zimmerman (29):
      usb: gadget: add SS descriptors to Ethernet gadget
      usb: dwc3: gadget: fix DEPSTARTCFG for non-EP0 EPs
      usb: dwc3: gadget: driver should not wait for RxFIFO to drain
      usb: dwc3: gadget: make DWC3_EP_WEDGE do the right thing
      usb: dwc3: gadget: fix DMA offset calculation
      usb: dwc3: gadget: fix DMA offset calculation
      usb: gadget: storage: fix mass storage gadgets to work with Synopsys UDC
      usb: gadget: storage: check for valid USB_BULK_GET_MAX_LUN_REQUEST
      usb: dwc3: clean up whitespace damage, typos, missing parens, etc.
      usb: dwc3: gadget: don't wrap around the TRB poll on non-ISOC
      usb: dwc3: fix bogus test in dwc3_gadget_start_isoc
      usb: dwc3: gadget: don't wrap around the TRB poll on non-ISOC
      usb: dwc3: fix bogus test in dwc3_gadget_start_isoc
      usb: dwc3: replace hard-coded constant in DWC3_GCTL_SCALEDOWN(3)
      usb: dwc3: pci: fix failure path in dwc3_pci_probe()
      usb: dwc3: shorten long delay in dwc3_gadget_set_link_state()
      usb: dwc3: take lock while modifying flags
      usb: dwc3: clear 'res_trans_idx' as soon as it becomes invalid
      usb: gadget: add isochronous support to gadget zero
      usb: dwc3: add definitions for new registers
      usb: dwc3: gadget: reinitialize retries
      usb: dwc3: gadget: rename phy_power() to phy_suspend()
      usb: dwc3: support new revisions of DWC3 core
      usb: dwc3: gadget: implement dwc3_gadget_get_link_state
      usb: dwc3: add 'saved_state' field to dwc3_ep structure
      usb: dwc3: gadget: re-factor dwc3_gadget_start
      usb: dwc3: gadget: add 'restore' parameter to endpoint handling
      usb: dwc3: gadget: add 'force' argument to stop_active_transfer
      usb: dwc3: core: make sure evt->lpos is correctly initialized

Paul.Zimmerman@synopsys.com (2):
      usb: gadget: storage: check for valid USB_BULK_RESET_REQUEST wLength
      usb: gadget: SS Isoc endpoints use comp_desc->bMaxBurst too

Peiyu Li (3):
      usb: gadget: storage: adapt logic block size to bound block devices
      usb: gadget: storage: adapt logic block size to bound block devices
      usb: gadget: storage: adapt logic block size to bound block devices

Per Forlin (8):
      usb: gadget: storage: make FSG_NUM_BUFFERS variable size
      usb: musb: ux500: optimize DMA callback routine
      usb: musb: ux500: optimize DMA callback routine
      usb: gadget: storage: make FSG_NUM_BUFFERS variable size
      usb: gadget: storage: make FSG_NUM_BUFFERS variable size
      usb: musb: ux500: optimize DMA callback routine
      usb: musb: ux500: optimize DMA callback routine
      usb: musb: ux500: optimize DMA callback routine

Peter Chen (5):
      USB: fsl_udc_core: use usb_endpoint_xfer_isoc to judge ISO XFER
      usb: gadget: fsl_udc: fix the usage of udc->max_ep
      usb: fsl_udc_core: Fix scheduling while atomic dump message
      usb: fsl_udc_core: prime status stage once data stage has primed
      usb: gadget: fsl_udc_core: dTD's next dtd pointer need to be updated once written

Peter Korsgaard (1):
      f_fs: ffs_func_free: cleanup requests allocated by autoconfig

Pratyush Anand (3):
      usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced
      usb: dwc3: gadget: fix pending isoc handling
      usb: gadget: mass storage: fix return of delayed status

Rabin Vincent (1):
      usb: musb: fix Kconfig

Randy Dunlap (2):
      usb: fix dwc3 build when USB_GADGET_DWC3 is not enabled
      usb gadget: fix langwell_udc.c build error

Robert Baldyga (2):
      usb: gadget: s3c-hsotg: fix spinlock locking
      usb: gadget: s3c-hsotg: fix disconnect handling

Robert Jarzmik (1):
      usb: gadget: fix g_serial regression

Robert Schwebel (1):
      usb: gadget: at91_udc: change french comments to english

Roger Quadros (3):
      usb: phy: make PHY driver selection possible by controller drivers
      usb: ehci-omap: select NOP_USB_XCEIV PHY driver
      usb: phy: omap-usb3: Improve DPLL parameter lookup code

Ruchika Kharwar (1):
      usb: dwc3: adapt to use dr_mode device tree helper

Sachin Kamat (1):
      usb: gadget: fsl_udc_core: Use module_platform_driver_probe macro

Sascha Hauer (2):
      usb: phy: move bulk of otg/otg.c to phy/phy.c
      usb: phy: mxs-phy: register phy with framework

Sebastian Andrzej Siewior (468):
      usb: dwc3: use platform_device_unregister()
      usb: dwc3: add a comment about the error case / use list iterator
      usb: dwc3: add missing break to dwc3_interrupt
      usb: dwc3: fix id detection
      usb: dwc3: add type for identify the event buffer type
      usb: dwc3: fixup event buffer definition
      usb: dwc3: reorganize event buffer handling
      usb: dwc3: make use of an if block instead of multiple depends
      usb: dwc3: handle error case in dwc3_gadget_init_endpoints()
      usb: dwc3: remove list head init
      usb: dwc3: add dwc3_gadget_free_endpoints
      usb: dwc3: add core deinit function
      usb: dwc3: gagdet: fix dev vs device
      usb: dwc3: again, use io instead of this
      usb: dwc3: save epnum in ep
      usb: dwc3: check for DevCtrlHl after touching START/STOP bit
      usb: dwc3: rename pullup dwc3_gadget_run_stop()
      usb: dwc3: add disconnect interrupt handling
      usb: dwc3: split dwc3_gadget_disconnect_interrupt()
      usb: dwc3: go through dwc3_gadget_reset_interrupt()
      usb: dwc3: partly revert "save epnum in ep"
      usb: dwc3: enlarge interrupt_number in dwc3_gadget_ep_depcfg_param1
      usb: dwc3: enlarge reserved16_14 in dwc3_gadget_ep_depcfg_param0
      usb: dwc3: go through connect done
      usb: dwc3: update dwc3_gadget_linksts_change_interrupt
      usb: dwc3: remove init list head in dwc3_gadget_ep_alloc_request()
      usb: dwc3: don't list_del on dwc3_gadget_ep_free_request()
      usb: dwc3: map dma later
      usb: dwc3: init request's dma address
      usb: dwc3: save the trb belonging to an request
      usb: dwc3: fix maybe not initialized value
      usb: dwc3: fix buffer address
      usb: dwc3: poll for command complete on the correct endpoint
      usb: dwc3: simple tx transfer of non ep0
      usb: dwc3: dwc3_gadget_conndone_interrupt() send msg to correct endpoint
      usb: dwc3: remove double assignment of bpl and length
      usb: dwc3: recognize ep0 correctly
      usb: dwc3: add an usb control request
      usb: dwc3: fix trb address
      usb: dwc3: add first setup phase for ep0
      usb: dwc3: prepare dwc3_ep0_start_dataphase() for split
      usb: dwc3: use dma_map() for the trb.
      usb: dwc3: split dwc3_ep0_start_trans() into dwc3_ep0_start_dataphase()
      usb: dwc3: add more ep0 bits
      usb: dwc3: remove dead block
      usb: dwc3: remove assignment of isp_imi
      usb: dwc3: move ep0 related functions into a separate file
      usb: dwc3: move DWC3_DEPCMD_SETTRANSFRESOURCE to dwc3_init_endpoint()
      usb: dwc3: don't init ep0/1 in gadget_init()
      usb: dwc3: add missing EP0_IN_WAIT_GADGET bits
      usb: dwc3: fix "is singular" assumption
      usb: dwc3: use delayed TRB allocations
      usb: dwc3: remove one level of indention
      usb: dwc3: remove __dwc3_gadget_kick_transfers()
      usb: dwc3: remove arguments from __dwc3_gadget_kick_transfer()
      usb: dwc3: clear TRB before usage
      usb: dwc3: fix the length argument in dwc3_endpoint_transfer_complete()
      usb: dwc3: don't enqueue new requsts unless it is the last one
      usb: dwc3: unmap the TRB earlier on completion
      usb: dwc3: remove irqreturn_t from most functions
      usb: dwc3: start ISOC transfers on XferNotReady event
      usb: dwc3: convert the current TRB queue design into a ring buffer
      usb: dwc3: make a lock less version of dwc3_gadget_ep_set_halt()
      usb: dwc3: go to EP0_OUT_WAIT_NRDY on XferNotReady event in EP0_OUT_WAIT_GADGET state
      usb: dwc3: stall and restart setup TRB in error case
      usb: dwc3: remove extra argument in dwc3_ep0_out_start()
      usb: dwc3: handle missing states in dwc3_ep0_start_trans()
      usb: dwc3: don't error out on EP0_*_WAIT_GADGET
      usb: dwc3: use usb_request directly dwc3_ep0_complete_data()
      usb: dwc3: start handling standard usb requests
      usb: dwc3: fixup Kconfig madness
      usb: dwc3: fix set addr to zero in dwc3_gadget_reset_interrupt()
      usb: dwc3: handle USB_REQ_SET_ADDRESS
      usb: dwc3: execute DWC3_DEPCMD_SETTRANSFRESOURCE for the correct EP
      usb: dwc3: handle USB_REQ_SET_CONFIGURATION
      usb: dwc3: let the gadgt driver handle requests by default
      usb: ch9: add function defines from ch9, USB 3.0 spec
      usb: dwc3: handle USB_REQ_CLEAR_FEATURE
      usb: dwc3: handle USB_REQ_SET_FEATURE
      usb: dwc3: merge dwc3_ep0_clear_feature() and dwc3_ep0_set_feature()
      usb: dwc3: remove WARN_ON() in XFERNOTREADY
      usb: dwc3: fixup typo
      usb: dwc3: prepare for ISOC updates
      usb: dwc3: toggle the HWO in dwc3_prepare_trbs() once the TRB is complete
      usb: dwc3: initialize request_list
      usb: dwc3: don't remove ep1 from the EP1 list
      usb: dwc3: move queued requests onto a seperate list
      usb: dwc3: allow to queue ISOC while ISOC are scheduled
      usb: dwc3: don't schedule ISOC if we don't have any requests
      usb: dwc3: add myself as the Co-Author
      usb: dwc3: support for 64bit addr_t
      usb: dwc3: generated IOC for ISOC more frequently
      usb: dwc3: link the ISOC TRBs
      usb: dwc3: fixup IOC/LST/CHN logic on ISOC
      usb: dwc3: return -EBUSY if the request is handled
      dwc: usb3: make __dwc3_gadget_kick_transfer() consider the correct list
      usb: dwc3: add 64bit support for TRBs
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: remove driver name from haps
      usb: dwc3: fixup bitfield definitions
      usb: dwc3: remove CHN bit
      usb: dwc3: add a missing ;
      usb: dwc3: initialize dwc in dwc3_gadget_ep_disable()
      usb: dwc3: make the TRB structure endian safe
      usb: dwc3: invert wait logic in dwc3_send_gadget_ep_cmd()
      usb: dwc3: don't look at jiffies in dwc3_send_gadget_ep_cmd()
      usb: dwc3: use usb_endpoint_type() where possible
      usb: dwc3: remove locking from atomic context
      usb: dwc3: remove jiffies assumption in dwc3_gadget_run_stop()
      usb: dwc3: no need for irqsave() in dwc3_interrupt()
      usb: dwc3: don't flush the fifo on init
      usb: dwc3: nuke dwc3_gadget_ep_fifo_flush()
      usb: dwc3: gadget: send DEPCMD_SETEPCONFIG/DEPCMD_DEPSTARTCFG correctly
      usb: dwc3: fix DWC3_DALEPENA_EPIN() macro
      usb: dwc3: DWC3_DALEPENA_EP() is always used for both directions
      usb: dwc3: don't queue req for ep0/1 if something is going on
      usb: dwc3: simplify dwc3_prepare_trbs() by removing access request_count
      usb: dwc3: remove remaining request_count users request_count users
      usb: dwc3: add small todo list
      usb: dwc3: gadget: use computed value instead
      usb: gadget: convert all users to the new udc infrastructure
      usb: gadget: net2272: cleanup pci_register_driver() error path
      usb: gadget: add platform module alias where it is missing
      usb: gadget: s3c2410_udc: use platform ids instead
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: gadget: convert all users to the new udc infrastructure
      usb: gadget: net2272: cleanup pci_register_driver() error path
      usb: gadget: add platform module alias where it is missing
      usb: gadget: s3c2410_udc: use platform ids instead
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: gadget: convert all users to the new udc infrastructure
      usb: gadget: net2272: cleanup pci_register_driver() error path
      usb: gadget: add platform module alias where it is missing
      usb: gadget: s3c2410_udc: use platform ids instead
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: gadget: dummy_hcd: use dummy_pullup() instead of open coding
      usb: gadget: dummy_hcd: set gadget.is_otg before calling bind()
      usb: gadget: dummy_hcd: use gadget_to_dummy_hcd() where possible
      usb: gadget: dummy_hcd: use less checks for USB_SPEED_SUPER
      usb: gadget: remove net2280_set_fifo_mode()
      usb: gadget: dummy_hcd: move common bits of suspend/resume into one function
      usb: gadget: defer setting maxpacket till ->setup()
      usb: gadget: dummy_hcd: move ep initialisation HW setup
      usb: gadget: dummy_hcd: init is_otg in init_dummy_udc_hw()
      usb: gadget: dummy_hcd: move selection of speed into ->pullup()
      usb: gadget: udc-core: add "new-style" registration interface
      usb: musb: convert musb to new style bind
      usb: gadget: dummy_hcd: convert to new-style udc-probe
      usb: gadget: udc-core: wire up sysfs files
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: gadget: net2272: cleanup pci_register_driver() error path
      usb: gadget: add platform module alias where it is missing
      usb: gadget: s3c2410_udc: use platform ids instead
      usb: gadget: dummy_hcd: use dummy_pullup() instead of open coding
      usb: gadget: dummy_hcd: set gadget.is_otg before calling bind()
      usb: gadget: dummy_hcd: use gadget_to_dummy_hcd() where possible
      usb: gadget: dummy_hcd: use less checks for USB_SPEED_SUPER
      usb: gadget: remove net2280_set_fifo_mode()
      usb: gadget: dummy_hcd: move common bits of suspend/resume into one function
      usb: gadget: defer setting maxpacket till ->setup()
      usb: gadget: dummy_hcd: move ep initialisation HW setup
      usb: gadget: dummy_hcd: init is_otg in init_dummy_udc_hw()
      usb: gadget: dummy_hcd: move selection of speed into ->pullup()
      usb: gadget: udc-core: add "new-style" registration interface
      usb: musb: convert musb to new style bind
      usb: gadget: dummy_hcd: convert to new-style udc-probe
      usb: gadget: udc-core: wire up sysfs files
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: dwc3: gadget: fix starting one EP more than once
      usb: dwc3: gadget: don't treat -EBUSY on TRANSFER_NOT_READY
      usb: dwc3: omap: recognize the error on getting irq properly
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: dwc3: gadget: fix starting one EP more than once
      usb: dwc3: gadget: don't treat -EBUSY on TRANSFER_NOT_READY
      usb: dwc3: omap: recognize the error on getting irq properly
      usb: gadget: convert all users to the new udc infrastructure
      usb: gadget: net2272: cleanup pci_register_driver() error path
      usb: gadget: add platform module alias where it is missing
      usb: gadget: s3c2410_udc: use platform ids instead
      usb: gadget: dummy_hcd: use dummy_pullup() instead of open coding
      usb: gadget: dummy_hcd: set gadget.is_otg before calling bind()
      usb: gadget: dummy_hcd: use gadget_to_dummy_hcd() where possible
      usb: gadget: dummy_hcd: use less checks for USB_SPEED_SUPER
      usb: gadget: remove net2280_set_fifo_mode()
      usb: gadget: dummy_hcd: move common bits of suspend/resume into one function
      usb: gadget: defer setting maxpacket till ->setup()
      usb: gadget: dummy_hcd: move ep initialisation HW setup
      usb: gadget: dummy_hcd: init is_otg in init_dummy_udc_hw()
      usb: gadget: dummy_hcd: move selection of speed into ->pullup()
      usb: gadget: udc-core: add "new-style" registration interface
      usb: musb: convert musb to new style bind
      usb: gadget: dummy_hcd: convert to new-style udc-probe
      usb: gadget: udc-core: wire up sysfs files
      usb: gadget: ci13xx_udc.c: fix compile warning
      usb: gadget: fusb300_udc: fix compile warnings
      usb: gadget: fix up depencies
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: dwc3: gadget: fix starting one EP more than once
      usb: dwc3: gadget: don't treat -EBUSY on TRANSFER_NOT_READY
      usb: dwc3: omap: recognize the error on getting irq properly
      usb: dwc3: gadget: fix maxpacket size for SS
      usb: dwc3: gadget: fix multi TRB handling
      usb: dwc3: gadget: don't set IOC bit
      usb: dwc3: fix XferResourceIndex mask
      usb: dwc3: gadget: don't sleep in interrupt
      usb: ch9: add function defines from ch9, USB 3.0 spec
      arm: omap: use hwmod to create a dwc3 device
      usb: dwc3: gadget: also disable IRQs on error path
      usb: dwc3: gadget: move put_device before goto label in err path
      uwb: dwc3: gadget: convert dwc3 to new udc class
      usb: dwc3: gadget: remove __devexit from exit path (dwc3_gadget_exit)
      usb: dwc3: gadget: fix starting one EP more than once
      usb: dwc3: gadget: don't treat -EBUSY on TRANSFER_NOT_READY
      usb: dwc3: omap: recognize the error on getting irq properly
      usb: dwc3: gadget: fix maxpacket size for SS
      usb: dwc3: gadget: fix multi TRB handling
      usb: dwc3: gadget: don't set IOC bit
      usb: dwc3: fix XferResourceIndex mask
      usb: dwc3: gadget: don't sleep in interrupt
      usb: gadget: fusb300: remove #if 0 block
      usb: gadget: composite: fix bMaxPacketSize for SuperSpeed
      usb: dwc3: gadget: remove isp_imi for non ISO
      usb: dwc3: gadget: add TEST_MODE
      usb: gadget: composite: fix bMaxPacketSize for SuperSpeed
      usb: dwc3: gadget: use proper endian accessor for wMaxPacketSize
      usb: dwc3: gadget: use the length of the name array
      usb: dwc3: gadget: handle short-packets-OUT transfers
      usb: dwc3: gadget: use GFP_ATOMIC in ep_enable
      usb: dwc3: gadget: don't queue transfers if we got interrupt on a short packet
      usb: dwc3: gadget: handle more cases in the clean up routine
      usb: dwc3: gadget: ep0: use wIndex and initialize it
      usb: dwc3: gadget: fixup merge conflict for "proper endian accessor for wMaxPacketSize"
      usb: gadget: create a usb-composite.ko module
      arm: omap: use hwmod to create a dwc3 device
      usb: ch9: add function defines from ch9, USB 3.0 spec
      usb: dwc3: gadget: remove DWC3_EP_ISOC_RUNNING
      usb: dwc3: gadget: issue UPDATE transfer command XferInprogress
      usb: dwc3: use numbers instead of name for platform_resources
      usb: dwc3: omap: add DT probing
      usb: dwc3: gadget: split dwc3_stop_active_transfers() into two functions
      usb: dwc3: gadget: only stop a transfer if there is an active one
      usb: dwc3: gadget: use dwc3_stop_active_transfer() in ep disable
      usb: dwc3: gadget: handle the ISO clean up
      usb: dwc3: gadget: prepare to retrieve res_trans_idx via CmdComplete event
      usb: dwc3: gadget: split TRB cleanup/complete into two pieces
      usb: dwc3: gadget: make the pre-mature dequeue of requests possible
      usb: gadget: create a usb-composite.ko module
      arm: omap: use hwmod to create a dwc3 device
      usb: ch9: add function defines from ch9, USB 3.0 spec
      usb: gadget: create a usb-composite.ko module
      usb: gadget: create a usb-composite.ko module
      arm: omap: use hwmod to create a dwc3 device
      usb: ch9: add function defines from ch9, USB 3.0 spec
      usb: dwc3: gadget: fixing dequeue of TRBs
      usb: dwc3: gadget: reset resource index to zero
      usb: dwc3: gadget: use TRB type 6 for ISOC transfers
      usb: dwc3: gaget: clear DWC3_EP_WILL_SHUTDOWN bit
      usb: dwc3: debugfs: remove test mode interface
      usb: dwc3: core: move the core check before soft reset
      usb: dwc3: gadget: rework the dequeue on RESET & DISCONNECT
      usb: dwc3: gadget: replace mdelay with udelay in the busy loop
      usb: dwc3: gadget: do not map/unmap ZLP transfers
      usb: dwc3: ep0: remove second giveback in error case
      usb: dwc3: ep0: fix debug output
      usb: dwc: remove "All rights reserved" statement.
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: use a helper function for operation mode setting
      usb: dwc3: move generic dwc3 code from gadget into core
      usb: dwc3: ep0: push ep0state into xfernotready processing
      usb: dwc3: ep0: handle delayed_status again
      usb: dwc3: gadget: return early in dwc3_cleanup_done_reqs()
      usb: dwc3: gadget: initialize max_streams
      usb: dwc3: omap: fix dwc3 binding match table
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: use a helper function for operation mode setting
      usb: dwc3: move generic dwc3 code from gadget into core
      usb: dwc3: ep0: push ep0state into xfernotready processing
      usb: dwc3: ep0: handle delayed_status again
      usb: dwc3: gadget: return early in dwc3_cleanup_done_reqs()
      usb: dwc3: use correct hwparam register for power mgm check
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: use a helper function for operation mode setting
      usb: dwc3: move generic dwc3 code from gadget into core
      usb: dwc3: ep0: push ep0state into xfernotready processing
      usb: dwc3: ep0: handle delayed_status again
      usb: dwc3: gadget: return early in dwc3_cleanup_done_reqs()
      usb: dwc3: use correct hwparam register for power mgm check
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: use a helper function for operation mode setting
      usb: dwc3: move generic dwc3 code from gadget into core
      usb: dwc3: ep0: push ep0state into xfernotready processing
      usb: dwc3: ep0: handle delayed_status again
      usb: dwc3: gadget: return early in dwc3_cleanup_done_reqs()
      usb: dwc3: use correct hwparam register for power mgm check
      usb: dwc3: ep0: use dwc3_request for ep0 requsts instead of usb_request
      usb: dwc3: add a platform device alias
      usb: dwc3: debugfs: hold the lock in during mode change
      usb: dwc3: host: remove unused includes
      usb: dwc3: reset pending status flag in error case
      usb: dwc3: remove special status request handling in ep0
      usb: dwc3: ep0: use proper endianess in SetFeature for wIndex
      usb: dwc3: ep0: don't use ep0in for transfers
      usb: dwc3: use a helper function for operation mode setting
      usb: dwc3: move generic dwc3 code from gadget into core
      usb: dwc3: ep0: push ep0state into xfernotready processing
      usb: dwc3: ep0: handle delayed_status again
      usb: dwc3: gadget: return early in dwc3_cleanup_done_reqs()
      usb: dwc3: use correct hwparam register for power mgm check
      usb: dwc3: ep0: use dwc3_request for ep0 requsts instead of usb_request
      usb: gadget: check for streams only for SS udcs
      usb: dwc3: unmap the proper number of sg entries
      usb: gadget: at91_udc: convert to new style start/stop interface
      usb: gadget: atmel_usba_udc: convert to newstyle start/stop interface
      usb: gadget: fsl_qe_udc: convert to new style start/stop
      usb: gadget: fsl_qe_udc: remove not implemented callbacks
      usb: gadget: imx_udc: convert to new style start/stop
      usb: gadget: remove DUALSPEED from printer
      usb: gadget: make g_printer use composite
      usb: gadget: dummy_hcd: allow to free requests on disabled endpoints
      usb: dwc3: ep0: add LPM handling
      usb: gadget: at91udc: don't overwrite driver data
      usb: gadget: at91udc: Don't check for ep->ep.desc
      usb: gadget: dummy_hcd: fixup error probe path
      usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
      usb: gadget: dummy_hcd: fixup error probe path
      usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
      usb: gadget: at91udc: don't overwrite driver data
      usb: gadget: at91udc: Don't check for ep->ep.desc
      usb: gadget: remove usb_gadget_controller_number()
      usb: gadget: file_storage: fix build error by selecting libcomposite
      usb: gadget: composite: don't call driver's unbind() if bind() failed
      usb: gadget: remove u32 castings of address passed to readl()
      usb: gadget: provide a wrapper around SourceSink's setup function
      usb: gadget: move source sink's config descriptor out of f_sourcesink
      usb: gadget: move loopback's config descriptor out of f_loopback
      usb: gadget: add some infracture to register/unregister functions
      usb: gadget: convert source sink and loopback to new function interface
      usb: gadget: f_acm: remove empty function
      usb: gadget: g_serial: split the three possible functions into three bind functions
      usb: gadget: u_serial: convert into a module
      usb: gadget: composite: add usb_remove_function()
      usb: gadget: allocate & giveback serial ports instead hard code them
      usb: gadget: f_acm: convert to new function interface with backwards compatibility
      usb: gadget: acm_ms: use function framework for ACM
      usb: gadget: cdc2: use function framework for ACM
      usb: gadget: multi: use function framework for ACM
      usb: gadget: add a forward pointer from usb_function to its "instance"
      usb: gadget: udc-core: introduce UDC binding by name
      usb: gadget: factor out two helper functions from composite_bind()
      usb: gadget: export composite's setup & disconnect function
      usb: gadget: composite: introduce usb_gstrings_attach()
      usb: gadget: f_acm: use usb_gstrings_attach()
      musb: musb: dsps: support multiple instances
      musb: musb: dsps: determine the number of instances at runtime
      usb: musb: replace ifndef with ifdef for CONFIG_MUSB_PIO_ONLY
      usb: musb: musbhsdma: drop the controller check in dma_controller_destroy()
      usb: musb: dma: merge ->start/stop into create/destroy
      usb: musb: provide empty dma_controller_create() in PIO mode
      usb: musb: remove a few is_dma_capable() in init/exit code
      usb: musb: core: call dma_controller_destroy() in the err path
      usb: musb: unmap reqs in musb_gadget_queue()'s error case
      usb: musb: dsps: init / shutdown the phy
      usb: musb: remove ti81xx pieces from musb
      usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
      usb: musb: do not change dev's dma_mask
      usb: musb: musb_cppi41: factor most of cppi41_dma_callback() into cppi41_trans_done()
      usb: musb: musb_cppi41: handle pre-mature TX complete interrupt
      usb: musb: only cancel work if it is initialized

Sebastian Bauer (1):
      usb: gadget: hid: don't STALL when processing a HID Descriptor request

Sekhar Nori (1):
      usb: musb: davinci: fix build breakage

Sergei Shtylyov (14):
      usb: gadget: add missing #include's
      usb: gadget: add missing #include's
      usb: gadget: add missing #include's
      usb: gadget: add missing #include's
      usb: gadget: add missing #include's
      usb: musb: tusb6010: fix error path in tusb_probe()
      usb: musb: musbhsdma: fix IRQ check
      usb: musb: musbhsdma: fix IRQ check
      usb: musb: cppi_dma: drop '__init' annotation
      usb: musb: omap2430: kill redundant assignments in omap2430_probe()
      usb: musb: cppi_dma: drop '__init' annotation
      usb: musb: omap2430: kill redundant assignments in omap2430_probe()
      usb: musb: omap2430: kill redundant assignments in omap2430_probe()
      usb: musb: omap2430: fix wrong devm_kzalloc() result check

Sergei Trofimovich (1):
      usb: musb: tusb6010_omap: fix build failure: error: 'musb' undeclared

Seth Levy (1):
      USB: net2272: driver for PLX NET2272 USB device controller

Shimoda, Yoshihiro (3):
      usb: renesas_usbhs: gadget: add support for set_selfpowered
      usb: gadget: r8a66597-udc: add support for set_selfpowered
      usb: renesas_usbhs: modify the irq handler for sharing irq

Shubhrajyoti D (2):
      usb: musb: omap: fix the error check for pm_runtime_get_sync
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Srinivas Kandagatla (1):
      usb: phy: mv_otg: use module_platform_driver macro

Stephen Rothwell (1):
      usb: include module.h in the DesignWare USB3 DRD driver

Supriya Karanth (1):
      usb: musb: Reselect index reg in interrupt context

Syam Sidhardhan (1):
      usb: otg: fsl_otg: remove redundant NULL check before kfree

Tatyana Brokhman (46):
      usb: gadget: add usb_endpoint_descriptor to struct usb_ep
      usb: gadget: configure endpoint according to gadget speed
      usb: gadget: use config_ep_by_speed() instead of ep_choose()
      usb: gadget: add max_speed to usb_composite_driver
      usb: gadget: coding style fix
      usb: gadget: add streams support to the gadget framework
      usb: gadget: add SuperSpeed support to the Gadget Framework
      usb: gadget: dummy_hcd: use the shared_hcd infrastructure
      usb: gadget: dummy_hcd: add SuperSpeed support
      usb: gadget: dummy_hcd: add 'is_high_speed' parameter
      usb: gadget: add usb_endpoint_descriptor to struct usb_ep
      usb: gadget: configure endpoint according to gadget speed
      usb: gadget: use config_ep_by_speed() instead of ep_choose()
      usb: gadget: add max_speed to usb_composite_driver
      usb: gadget: coding style fix
      usb: gadget: add streams support to the gadget framework
      usb: gadget: add SuperSpeed support to the Gadget Framework
      usb: gadget: dummy_hcd: use the shared_hcd infrastructure
      usb: gadget: dummy_hcd: add SuperSpeed support
      usb: gadget: dummy_hcd: add 'is_high_speed' parameter
      usb: gadget: add usb_endpoint_descriptor to struct usb_ep
      usb: gadget: configure endpoint according to gadget speed
      usb: gadget: use config_ep_by_speed() instead of ep_choose()
      usb: gadget: add max_speed to usb_composite_driver
      usb: gadget: coding style fix
      usb: gadget: add streams support to the gadget framework
      usb: gadget: add SuperSpeed support to the Gadget Framework
      usb: gadget: dummy_hcd: use the shared_hcd infrastructure
      usb: gadget: dummy_hcd: add SuperSpeed support
      usb: gadget: dummy_hcd: add 'is_high_speed' parameter
      usb: gadget: add max_speed to usb_composite_driver
      usb: gadget: add SuperSpeed support to the Gadget Framework
      usb: gadget: dummy_hcd: use the shared_hcd infrastructure
      usb: gadget: dummy_hcd: add SuperSpeed support
      usb: gadget: dummy_hcd: add 'is_high_speed' parameter
      usb: gadget: add usb_endpoint_descriptor to struct usb_ep
      usb: gadget: configure endpoint according to gadget speed
      usb: gadget: use config_ep_by_speed() instead of ep_choose()
      usb: gadget: coding style fix
      usb: gadget: add streams support to the gadget framework
      usb: gadget: add max_speed to usb_composite_driver
      usb: gadget: add SuperSpeed support to the Gadget Framework
      usb: gadget: dummy_hcd: use the shared_hcd infrastructure
      usb: gadget: dummy_hcd: add SuperSpeed support
      usb: gadget: dummy_hcd: add 'is_high_speed' parameter
      usb: gadget: Compilation warning fix

Thomas Meyer (1):
      usb: gadget: Use kcalloc instead of kzalloc to allocate array

Tobias Klauser (1):
      USB: Documentation: Use correct character in gadget_hid.txt

Tomasz Figa (1):
      usb: gadget: s3c-hsotg: Allow driver instantiation using device tree

Valentine Barshak (1):
      usb: phy: phy-rcar-gen2-usb: fix phy initialization

Vikas Sajjan (1):
      usb: dwc3: exynos: add basic suspend/resume support

Vikram Pandita (5):
      usb: musb: omap2+: fix context api's
      usb: musb: omap2+: fix context api's
      usb: musb: fix pm_runtime calls while atomic
      usb: musb: omap2+: fix context api's
      usb: musb: fix pm_runtime calls while atomic

Viliam Mateicka (3):
      usb: gadget: s3c2410_udc: fix custom UDC command handling
      usb: gadget: s3c2410_udc: fix custom UDC command handling
      USB: s3c2410_udc: fix custom UDC command handling

Vivek Gautam (1):
      usb: dwc3: set 'mode' based on selected Kconfig choices

Vladimir Zapolskiy (1):
      usb: musb: fix oops on omap2430 module unload

Wei Yongjun (1):
      usb: phy: phy-generic: fix return value check in usb_nop_xceiv_register()

Wolfram Sang (1):
      usb: phy: don't check resource with devm_ioremap_resource

Yauheni Kaliuta (2):
      usb: musb: gadget: clear TXPKTRDY flag when set FLUSHFIFO
      usb: musb: gadget: clear TXPKTRDY flag when set FLUSHFIFO

Yongsul Oh (1):
      usb: gadget: composite: prevent a memory leak when configuration bind fails

Yoshihiro Shimoda (15):
      usb: r8a66597-hcd: add function for external controller
      usb: update email address in r8a66597-udc and m66592-udc
      usb: gadget: r8a66597-udc: fix cannot connect after rmmod gadget driver
      usb: gadget: r8a66597-udc: Make BUSWAIT configurable through platform data
      usb: gadget: m66592-udc: add support for TEST_MODE
      usb: gadget: r8a66597-udc: add support for TEST_MODE
      usb: gadget: r8a66597-udc: add pullup function
      usb: gadget: m66592-udc: add function for external controller
      usb: gadget: m66592-udc: add pullup function
      usb: gadget: r8a66597-udc: change prototype of r8a66597_write_fifo
      usb: gadget: r8a66597-udc: add function for external controller
      usb: gadget: r8a66597-udc: use dev_*() instead of printk()
      usb: gadget: r8a66597-udc: add support for SUDMAC
      usb: gadget: r8a66597-udc: fix for udc-newstyle
      usb: gadget: r8a66597-udc: fix flush fifo handling

Yunfan Zhang (1):
      usb: gadget: mv_udc: fix hang when shutdown

Yuping Luo (2):
      usb: gadget: mass_storage: support multi-luns with different logic block size
      usb: gadget: mass_storage: support multi-luns with different logic block size

supriya karanth (1):
      usb: musb: Double buffering issues in host mode TX

yuzheng ma (1):
      usb: musb: host: fix for musb_start_urb Oops

 drivers/usb/dwc3/ep0.c              |   2 +
 drivers/usb/dwc3/gadget.c           |   5 +-
 drivers/usb/gadget/Kconfig          |   1 +
 drivers/usb/gadget/composite.c      |   1 +
 drivers/usb/gadget/f_fs.c           |   2 +-
 drivers/usb/gadget/f_mass_storage.c |  27 +++---
 drivers/usb/gadget/pxa25x_udc.c     |   1 +
 drivers/usb/gadget/s3c-hsotg.c      |   7 +-
 drivers/usb/gadget/storage_common.h |   4 -
 drivers/usb/gadget/tcm_usb_gadget.c |   2 +-
 drivers/usb/gadget/zero.c           |   6 +-
 drivers/usb/musb/musb_core.c        |   9 +-
 drivers/usb/musb/musb_cppi41.c      | 164 ++++++++++++++++++++++++++++++------
 drivers/usb/musb/musb_gadget.c      |   4 +
 drivers/usb/phy/phy-am335x.c        |   5 +-
 drivers/usb/phy/phy-generic.c       |  68 +++++++--------
 drivers/usb/phy/phy-generic.h       |   4 +-
 drivers/usb/phy/phy-mxs-usb.c       |   2 +-
 drivers/usb/phy/phy-rcar-gen2-usb.c |   4 +-
 19 files changed, 221 insertions(+), 97 deletions(-)
