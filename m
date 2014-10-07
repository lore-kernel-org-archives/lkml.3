Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaJGWcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:32:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJGWcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:32:05 -0400
Date: Tue, 7 Oct 2014 15:32:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.18-rc1
Message-ID: <20141007223203.GA5433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0f33be009b89d2268e94194dc4fd01a7851b6d51:

  Linux 3.17-rc6 (2014-09-21 15:43:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ staging-3.18-rc1

for you to fetch changes up to e603984823a9218857c599195aaa514c5343de03:

  staging: et131x: Remove et131x driver from drivers/staging (2014-10-03 13:55:14 -0700)

----------------------------------------------------------------
Staging patches for 3.18-rc1

Here is the big staging patch set for 3.18-rc1.

Once again, we are deleting more code than we added, with something like
150000 lines deleted overall.  Some of this is due to drivers being
added to the networking tree, so the old versions are removed here, but
even then, the overall difference is quite good.

Other than driver deletions, lots and lots and lots of minor cleanups
all over the place.  Full details are in the shortlog below.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
A Raghavendra Rao (1):
      Staging: wlan-ng: fix sparse warning in prism2fw.c

Aaro Koskinen (2):
      staging: octeon-usb: use generic control packet header
      staging: octeon-usb: use USB_DIR_IN

Abel Moyo (1):
      Staging: gdm724x: gdm_usb: added error checking in do_tx()

Adrian Nicoara (4):
      staging: ozwpan: fix missing blank line after declaration
      staging: ozwpan: fix redundant else after break or return
      staging: ozwpan: fix redundant return in void function
      staging: ozwpan: use kmalloc_array over kmalloc with multiply

Adrian Remonda (3):
      Staging: rtl8188eu: Missing a blank line after declarations.
      Staging: rtl8188eu: Lines over 80 characters fixed.
      Staging: rtl8188eu: Removed unneeded code.

An Ha (6):
      Staging: rtl8821ae: hal_bt_coexist: fix commenting style
      Staging: rtl8821ae: hal_bt_coexist: add/remove spaces
      Staging: rtl8821ae: hal_bt_coexist: fix pointer placement coding style issue
      Staging: rtl8821ae: hal_bt_coexist: fix curly brace placement
      Staging: rtl8821ae: hal_bt_coexist: add a blank newline
      Staging: rtl8821ae: base: add missing blank line after declaration

Andreas Schlick (3):
      staging: rtl8723au: Move open braces to the previous line.
      staging: rtl8723au: Remove unnecessary bit masking.
      staging: rtl8821ae: Fix sparse warning by making functions static.

Andrew Morton (1):
      drivers/staging/unisys: fix build

Andrew Plummer (2):
      Staging: bcm: LeakyBucket: format kernel-docs
      Staging: emxx_udc: emxx_udc: remove spaces before semicolons

Angelo Compagnucci (1):
      iio: adc: Add TI ADC128S052

Anh Le (1):
      Staging: bcm: fixed a comment coding style issue

Ankita Patil (1):
      Staging: dgap: Remove unnecessary variable.

Antoine Schweitzer-Chaput (6):
      staging: rtl8192u: remove unused define DEBUG_EPROM
      staging: rtl8192u: remove define always set USE_ONE_PIPE
      staging: rtl8192u: remove unused define USB_TX_DRIVER_AGGREGATION_ENABLE
      staging: rtl8192u: remove unused define USB_RX_AGGREGATION_SUPPORT
      staging: rtl8192u: remove unused define LOOP_TEST
      staging: rtl8192u: remove misc. unused defines

Arnd Bergmann (2):
      iio: adc: exynos_adc: add support for s3c64xx adc
      staging/lustre/lvfs: fix building without CONFIG_PROC_FS

Artemiy Volkov (2):
      Staging: wlan-ng: Merge string literals on adjacent lines in prism2fw.c
      staging: lustre: Fix address space mismatch in ksocknal_recv_iov()

Aybuke Ozdemir (37):
      Staging: iio: resolver: Missing a blank line after declarations
      Staging: rtl8723au: core: Fix "foo * bar" warning.
      Staging: rtl8723au: core: Fix unnecassary braces warning.
      Staging: rtl8723au: hal: Space prohibited before semicolon
      Staging: vt6655: Fix C99 style commenting.
      staging: bcm: Fix line over 80 characters
      staging: gs_fpgaboot Fix trailing whitespace.
      Staging: octeon: Missing a blank line after declarations
      Staging: media: cxd2099: Missing a blank line after declarations
      Staging: wlan-ng: Fix return in void function warning
      Staging: rtl8821ae: Fix "foo * bar" warning.
      Staging: rtl8821ae: Fix warnings of no space before tabs.
      Staging: iio: meter: Fix unnecessary space warning
      Staging: rtl8712: Remove unnecessary parentheses.
      Staging: rtl8712: Missing a blank line after declarations
      Staging: lustre: include: linux: Fix line over 80 characters.
      Staging: octeon: Fix missing blank line warning.
      Staging: rtl8192ee: Missing a blank line after declarations
      Staging: unisys: channels: Missing a blank line after declarations
      Staging: vt6655: Fix C99 style commenting.
      Staging: imx-drm: Fix line over 80 characters warning
      staging: imx-drm: Array was made static const char * const
      Staging: iio: light: Missing a blank line after declarations
      staging: iio: accel: Use __be16 instead of u16
      staging: rtl8723au: hal: Fix unnecessary whitespace before a quoted newline
      staging: rtl8723au: hal: Fix missing blank line warning.
      staging: rtl8723au: hal: Removed unnecessary braces.
      staging: rtl8723au: core: Add consistent spacing around '&'
      staging: rtl8723au: core: Add space after '|'
      Staging: wlan-ng: Fix unnecessary space before function pointer arguments
      Staging: speakup: Fix trailing space
      staging: speakup: Added blank line.
      Staging: vt6655: Add require space after that ','
      Staging: vt6655: Add require space before that '('
      Staging: unisys: common-spar: include: channels: Remove unnecessary semicolon
      staging: ft1000: ft1000-pcmcia: Add require space after that ','
      staging: rtl8192u: ieee80211: Converted symbol to static.

Benedict Boerger (2):
      drivers: staging: lustre: fix sparse warnings / delete unused function
      staging: rtl8192u: delete unused function CAM_read_entry

Benjamin Romer (68):
      staging: unisys: remove MEMCPY functions from commontypes.h
      staging: unisys: remove MEMORYBARRIER AND VolatileBarrier from commontypes
      staging: unisys: remove INLINE define from commontypes
      staging: unisys: remove GUEST_PHYSICAL_ADDRESS from commontypes.h
      staging: unisys: remove OFFSETOF from commontypes
      staging: unisys: move remaining macros from commontypes.h to channel.h
      staging: unisys: remove commontypes.h
      staging: unisys: get rid of unused VMMIO types
      staging: unisys: fix formatting in timskmod.h
      staging: unisys: get rid of semaphore macros
      staging: unisys: remove unused macros from timskmod.h
      staging: unisys: get rid of uiscmpxchg64
      staging: unisys: fix whitespace in uisutils.h
      staging: unisys: fix line lengths in controlvmcompletionstatus.h
      staging: unisys: fix spacing in iovmcall_gnuc.h
      staging: unisys: clean up vmcall functions
      staging: unisys: fix spacing in vbusdeviceinfo.h
      staging: unisys: fix spacing in uislib.c
      staging: unisys: simplify destroy_bus() in uislib.c
      staging: unisys: remove void return from uislib_mod_exit()
      staging: unisys: fix spacing in uisthread.c
      staging: unisys: fix indentation of uisutil_copy_fragsinfo_from_skb()
      staging: unisys: fix spacing in file.c
      staging: unisys: fix spacing in parser.c
      staging: unisys: fix spacing in visorchipset_main.c
      staging: unisys: remove generally useless elses from visorchipset_main.c
      staging: unisys: fix IO memory copy in channel.h
      staging: unisys: delete extra blank lines in periodic_work.h
      staging: unisys: remove typedef for PERIODIC_WORK
      staging: unisys: remove unused locking functions in timskmod.h
      staging: unisys: remove stray blank line in timskmod.h
      staging: unisys: fix spacing in timskmod.h macro
      staging: unisys: remove timskmodutils.h
      staging: unisys: fix camelcase function uisqueue_InterlockedOr()
      staging: unisys: fix CamelCase names in struct uisqueue_info
      staging: unisys: Clean up CamelCase in send_int_if_needed()
      staging: unisys: fix CamelCase in uisqueue_put_cmdrsp_with_lock_client
      staging: unisys: remove uisqueue_send_int_if_needed()
      staging: unisys: fix CamelCase in struct device_info
      staging: unisys: clean up CamelCase in DEDICATED_SWITCH() macro
      staging: unisys: fix CamelCase struct name NetworkPolicy
      staging: unisys: clean up CamelCase in struct add_virt_iopart
      staging: unisys: fix CamelCase names in struct add_vdisk_iopart
      staging: unisys: fix CamelCase in del_vdisk_iopart
      staging: unisys: fix CamelCase names in del_virt_iopart
      staging: unisys: fix CamelCase definitions in struct io_msgs
      staging: unisys: fix CamelCase in struct del_vbus_guestpart
      staging: unisys: clean up CamelCase names in struct add_virt_guestpart
      staging: unisys: fix up CamelCase in struct init_chipset_guestpart
      staging: unisys: remove excess blank lines in uisthread.h
      staging: unisys: fix line spacing in uniklog.h
      staging: unisys: fix copyright symbol in vbushelper.h
      staging: unisys: fix CamelCase in bus_device_info_init()
      staging: unisys: remove doubled blank lines in guestlinuxdebug.h
      staging: unisys: get rid of typedef for DRIVER_PC
      staging: unisys: get rid of typedef for EVENT_PC
      staging: unisys: fix CamelCase in uisctrl_register_req_handler
      staging: unisys: Fix CamelCase in Issue_VMCALL_IO_CONTROLVM_ADDR()
      staging: unisys: Fix CamelCase Issue_VMCALL_IO_DIAG_ADDR()
      staging: unisys: Fix CamelCase in Issue_VMCALL_IO_VISORSERIAL_ADDR()
      staging: unisys: fix Issue_VMCALL_QUERY_GUEST_VIRTUAL_TIME_OFFSET()
      staging: unisys: fix CamelCase in Issue_VMCALL_MEASUREMENT_DO_NOTHING()
      staging: unisys: Fix CamelCase in Issue_VMCALL_UPDATE_PHYSICAL_TIME()
      staging: unisys: Fix CamelCase in Issue_VMCALL_CHANNEL_MISMATCH()
      staging: unisys: Fix CamelCase in Issue_VMCALL_FATAL_BYE_BYE()
      staging: unisys: Fix CamelCase in uislib_enable_channel_interrupts()
      staging: unisys: Fix CamelCase in uislib_disable_channel_interrupts()
      staging: unisys: Fix CamelCase in uislib_force_channel_interrupt()

Blaj Roxana (1):
      staging: skein: replace spaces with tabs

Catalina Mocanu (13):
      staging: iio: dummy: add blank lines after declarations.
      staging: iio: trigger: add blank lines after declarations
      staging: iio: impedance-analyzer: add blank line after declaration
      staging: iio: cdc: Don't put an else right after a return
      staging: unisys: visorutil: remove unnecessary braces
      staging: unisys: virthba: remove unnecessary return statement
      staging: ft1000-pcmcia: replace DEBUG macro with netdev_dbg
      staging: ft1000-pcmcia: Don't initialise static to 0
      staging: imx-drm: Don't put an else right after a return
      staging: rtl8192ee: remove unnecessary return statement
      staging: rtl8192ee: clean up function header formatting
      staging: ft1000-usb: remove unnecessary return statement
      staging: ft1000-usb: use usleep_range instead of msleep

Chaitanya Hazarey (1):
      Staging: netlogic: xlr_net.c Fixed code-style warnings

Chaitra Ramaiah (1):
      Staging: rtl8192u: fix brace style coding issue in r819xU_firmware.c

Chanwoo Choi (1):
      iio: adc: exynos_adc: Add support for s3c24xx ADC

Chase Southwood (24):
      staging: comedi: addi_apci_1564: remove apci1564_do_config
      staging: comedi: addi_apci_1564: Remove in-driver watchdog support code
      staging: comedi: addi_apci_1564: tidy register map defines
      staging: comedi: addi_apci_1564: add whitespace to subdevice init
      staging: comedi: addi_apci_1564: correct typo in macro definition
      staging: comedi: dt3000: remove unneeded variable
      staging: comedi: dt2801: change function return type to void
      staging: comedi: s626: remove unnecessary variable initialization
      staging: comedi: usbdux: fix sparse endianness warnings
      staging: comedi: usbduxsigma: fix sparse endianness warnings
      staging: comedi: addi_apci_1564: move boilerplate text to addi_apci_1564.c
      staging: comedi: usbdux: fix more sparse endianness warnings
      staging: comedi: usbduxsigma: fix more sparse endianness warnings
      staging: comedi: hwdrv_apci035: remove useless return statement
      staging: comedi: hwdrv_apci3501: change printk to dev_err
      staging: comedi: hwdrv_apci1500: remove unneeded braces
      staging: comedi: hwdrv_apci1500: remove commented out code
      staging: comedi: hwdrv_apci1500: clean some whitespace style issues
      staging: comedi: hwdrv_apci1500: miscellaneous cleanup
      staging: comedi: hwdrv_apci1500: use dev->class_dev in calls to dev_warn()
      staging: comedi: hwdrv_apci3120: clean up comments
      staging: comedi: hwdrv_apci3120: add a blank line after declarations
      staging: comedi: hwdrv_apci3120: else is not useful after return
      staging: comedi: hwdrv_apci3120: remove void function return statement

Chen Gang (1):
      drivers/staging/unisys: Let all IOMEM related modules depend on HAS_IOMEM

Christoph Jaeger (11):
      staging: ozwpan: Add module parameter description
      staging: ozwpan: Fix typo in typedef
      staging: ozwpan: Remove unused OZ_MAX_TIMER_POOL_SIZE
      staging: ozwpan: Remove redundant initialization
      staging: ozwpan: Remove dead code
      staging: ozwpan: Simplify app interface
      staging: ozwpan: Use slab cache for oz_urb_link allocation
      staging: ozwpan: Use slab cache for oz_elt_info allocation
      staging: ozwpan: Use slab cache for oz_tx_frame allocation
      staging: ozwpan: Use list helpers
      staging: ozwpan: Remove typedefs

Daeseok Youn (14):
      staging: dgap: introduce dgap_cleanup_nodes()
      staging: dgap: remove useless variable
      staging: dgap: remove redundant declarations.
      staging: dgap: cleanup duplicated warning message on dgap_tty_init()
      staging: dgap: Simplify set a board type from configration file
      staging: dgap: Simplify to set a concentrator type
      staging: dgap: Simplify to set a module type
      staging: dgap: cleanup print messages for dgap driver
      staging: dgap: remove redundant setting a variable
      staging: dgap: remove useless a variable within board_t
      staging: dgap: use schedule_timeout_interruptible() instead of dgap_ms_sleep()
      staging: dgap: remove unused 'runwait' variable
      staging: dgap: adds missing iounmap for re_map_port in dgap_release_remap()
      staging: dgap: use dgap_release_remap() in dgap_cleanup_board()

Dan Carpenter (1):
      staging: comedi: amplc_pci230: fix a precedence bug

Daniel Baluta (5):
      io: accel: kxcjk1013: Remove redundant assignment
      iio: accel: kxcjk-1013: add support for kxcj9-1008
      iio: Add Dyna-Image AL3320A ambient light sensor driver
      iio: accel: kxcjk-1013: add support for kxtj2-1009
      iio: accel: kxcjk-1013: Fix defined but unused warning

Darshana Padmadas (13):
      Staging: lustre: include: libcfs: removed else before return statement in libcfs_crypto.h
      Staging: lustre: libcfs: fix checkpatch warning else after return statement
      Staging: lustre: place open brace following struct on same line
      Staging: lustre: Fix return in void function warning
      Staging: iio: adc: Fix warning prefer kmalloc_array over kmalloc
      Staging: iio: accel: Replace msleep with usleep for given range
      Staging: iio: adc: Fix quoted string split accross lines
      Staging: iio: adc: Fix else after return warning
      Staging: iio: meter: Add a blank line after declarations
      Staging: iio: meter: Add blank line after declarations.
      Staging: iio: meter: Add blank line after declarations
      Staging: iio: meter: Delete white spaces to make line shorter
      Staging: iio: meter: Remove space before start of line

Dilek Uzulmez (2):
      staging: octeon: Removed unnecessary else expression.
      staging: slicoss: Fix void function return statements style warning

Dipak Zope (1):
      staging: android: sync: Fix checkpatch warning: Missing a blank line after declarations

Dmitry Voytik (1):
      staging: binder: fix coding style issues

Domagoj Trsan (5):
      staging: speakup: fix warnings: line over 80 characters
      staging: speakup: fix redundant return in void functions
      staging: speakup: fix line indentations
      staging: speakup: fix missing blank lines after declarations
      staging: line6: fix midibuf.c coding style issue

Ebru Akagunduz (3):
      staging: dgnc: Fix do not add new typedefs
      staging: emxx_udc: Fix replace printk(KERN_DEBUG ..) with dev_dbg
      staging: emxx_udc: Use min_t instead of min

Eddie Kovsky (1):
      staging: clean up checkpatch warnings in lustre

Eli Billauer (27):
      staging: xillybus: Remove mmiowb() before wait_event_*() calls
      staging: xillybus: Removed mmiowb() before mutex_unlock()
      staging: xillybus: Removed mmiowb() as iowrite32() is ordered
      staging: xillybus: Removed write memory barriers before wait_event_*()
      staging: xillybus: Removed unnecessary smp_wmb()
      staging: xillybus: Removed read barrier at beginning of ISR
      MAINTAINERS: Add an entry for staging/xillybus
      staging: xillybus: Use devm_kcalloc() for arrays
      staging: xillybus: Use SEEK_* predefined constants
      staging: xillybus: Non-interruptible mutex_lock() on release method
      staging: xillybus: Removed unnecessary warning message
      staging: xillybus: Removed unnecessary error message
      staging: xillybus: Improved error handling
      staging: xillybus: Improved goto flow for error handling
      staging: xillybus: EAGAIN status handling improvement
      staging: xillybus: Fixes related to "rc" variable
      staging: xillybus: Use the return value of wait_event_interruptible
      staging: xillybus: Clarified the stop condition for a loop
      staging: xillybus: Added curly brackets as required
      staging: xillybus: Fix comments
      staging: xillybus: Reorganize line breaks for clarity
      staging: xillybus: Trivial coding style fixes
      staging: xillybus: Fix indentations
      staging: xillybus: Blank lines add/remove
      staging: xillybus: Removed unnecessary cast
      xillybus: Move out of staging
      MAINTAINERS: Move Xillybus out of staging

Erin Grasmick (3):
      staging: rtl8192ee: Fix unnecessary return at end of function.
      staging: rtl8192ee: Add blank lines after declarations
      staging: rtl8192ee: Remove unnecessary return statement

Esra Altintas (5):
      staging: bcm: Fix line 80 characters in Adapter.h
      staging: rts5208: Remove unnecessary else in rtsx_card.h
      staging: octeon: Fix line 80 characters in ethernet.c
      staging: rtl8192u: Fixed trailing whitespace in copying
      staging: vt6655: Fixed C99 // comment errors in wpactl.c

Fabien Malfoy (1):
      staging: rtl8821ae: Remove space after unary operator in efuse.c

Fabio Falzoi (2):
      Staging: rts5208: Use dev_dbg and print_hex_dump_bytes to dump memory
      Staging: rts5208: Remove CONFIG_RTS5208_DEBUG option

Fan Yong (1):
      staging/lustre/ldlm: drop redundant ibits lock interoperability check

Fernando Apesteguia (1):
      staging: rtl8192u: remove unused function.

Feyza Yavuz (2):
      staging: rtl8192e: rtl8192e: Remove unnecessary return statements
      staging: rtl8192e: rtl8192e: Remove spaces before the semicolons

Filipe Gonçalves (1):
      staging/lustre: Fixed checkpatch warning: Use #include <linux/statfs.h> instead of <asm/statfs.h>

Frank Zago (1):
      staging/lustre/llite: optimize ll_fid2path()

Fred Chou (1):
      staging: vme: remove redundant else condition

Ganesan Ramalingam (3):
      Staging: Netlogic: Add nlm_cop2_enable/restore function name change
      Staging: Netlogic: PHY address calculation fix
      Staging: Netlogic: Move all the netdev under single parent device

Georgiana Chelu (1):
      staging: rtl8192u: Add blank line after variable declarations

Greg Donald (25):
      drivers: staging: lustre: lustre: Fix "foo * bar" should be "foo *bar" errors
      drivers: staging: lustre: Fix space required before the open parenthesis '(' errors
      drivers: staging: lustre: Fix that open brace { should be on the previous line errors
      drivers: staging: lustre: Fix space required after that ',' errors
      drivers: staging: rtl8723au: Fix "foo* bar" should be "foo *bar" errors
      drivers: staging: rtl8723au: Fix space prohibited before that close parenthesis ')' errors
      drivers: staging: rtl8192u: Fix space required after that ',' errors
      drivers: staging: rtl8192u: Fix switch and case should be at the same indent errors
      drivers: staging: rtl8821ae: Fix spaces required around that '<' errors
      drivers: staging: lustre: Fix return is not a function, parentheses are not required errors
      drivers: staging: lustre: Fix 'do not use C99 // comments' errors
      drivers: staging: ft1000: Fix return is not a function, parentheses are not required errors
      drivers: staging: rtl8723au: Fix return is not a function, parentheses are not required error
      drivers: staging: rtl8192u: Fix "space prohibited after that open parenthesis '('" errors
      drivers: staging: rtl8192u: Fix "space required before that '*'" errors
      drivers: staging: rtl8723au: Fix "space required before that '*'" errors
      drivers: staging: rtl8821ae: Fix "space required before that '*'" errors
      drivers: staging: rtl8821ae: Fix '"(foo*)" should be "(foo *)"' errors
      drivers: staging: rtl8723au: Fix '"(foo*)" should be "(foo *)"' errors
      drivers: staging: lustre: Fix "space prohibited after that open parenthesis '('" errors
      drivers: staging: lustre: Fix 'code indent should use tabs where possible' errors
      drivers: staging: rtl8723au: Fix 'code indent should use tabs where possible' errors
      drivers: staging: lustre: Cleanup src/dst comparisons in obdo_cmp_md()
      drivers: staging: rtl8723au: Fix "space required after that ','" errors
      drivers: staging: lustre: Fix "open brace '{' following struct go on the same line" errors

Greg Kroah-Hartman (11):
      Merge tag 'iio-for-3.18a' of git://git.kernel.org/.../jic23/iio into work-next
      staging: remove nokia_hp4p driver
      Merge 3.17-rc3 into staging-next
      Merge tag 'ipu-for-staging-3.18' of git://git.pengutronix.de/git/pza/linux into work-next
      Revert "usb: dwc2: make the scheduler handle excessive NAKs better"
      Merge 3.17-rc5 into staging-next.
      Merge tag 'iio-for-3.18b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.17-rc6 into staging-next.
      staging: iio: fix up merge error
      staging: rtl8821ae: remove driver
      Revert "staging: media: cxd2099: use usleep_range()"

Grzegorz Swirski (2):
      staging: android: use braces on all arms of if
      staging: wlan-ng: remove unused 'result' var

Gulsah Kose (44):
      staging: rtl8188eu: core: Fixed wrong space error.
      staging: gdm724x: Fix missing blank line warning.
      staging: dgnc: Fix missing blank line warning.
      staging: dgnc: Fix unnecessary space warning.
      staging: lustre: lnet: lnet: Fix quoted string split warning.
      staging: lustre: lnet: lnet: Fix missing line warning.
      staging: lustre: lnet: lnet: Fixed quoted string split warning.
      staging: media: lirc: Fix missing blank line warning.
      staging: media: lirc: Fix unnecessary return warning.
      staging: media: lirc: Fix missing blank line warning.
      staging: media: lirc: Fix missing blank line warning.
      staging: media: lirc: Fixes unnecessary return warning.
      staging: media: lirc: Fixes missing blank line warning.
      staging: octeon: Fix missing blank line warning.
      staging: octeon: Fix quoted string split warning.
      staging: media: omap4iss: Fixes missing blank line warning.
      staging: media: omap4iss: Fix missing blank line warning.
      staging: media: lirc: Fixed quoted string split warning.
      staging: rtl8821ae: Fixes unnecessary return warning.
      staging: dgnc: Fix unnecessary braces warning.
      staging: dgnc: Fixed white space warning.
      staging: media: lirc: Removed unnecessary else expression.
      staging: media: omap24xx: Added new line after declarations.
      staging: media: omap24xx: Added blank line.
      staging: media: omap4iss: Removed unnecessary else expression.
      staging: media: omap4iss: Removed unnecessary else expression.
      staging: emxx_udc: Fixed else is not usefull warning.
      staging: vt6655: Type conversion was made.
      staging: ft1000: ft1000-pcmcia: Removed unnecessary else expression.
      staging: ft1000: ft1000-pcmcia: Used "linux" instead of "asm".
      staging: gdm724x: Removed unnecessary else expression.
      drivers: staging: gdm72xx: Removed unnecessary else expression.
      drivers: staging: gdm72xx: Removed unnecessary braces.
      staging: lustre: include: linux: libcfs: linux: Used "linux" instead of "asm".
      staging: lustre: include: linux: libcfs: Removed unnecessary else expression.
      staging: lustre: include: linux: libcfs: linux: Removed line continuations.
      staging: octeon: Combined seperate strings.
      staging: octeon: Combined seperate strings.
      staging: iio: accel: Removed unnecessary else expression.
      staging: iio: addac: Combined seperated strings.
      staging: ft1000: ft1000-usb: Added new line after declarations.
      staging: ft1000: ft1000-usb: Removed unnecessary parentheses.
      staging: ft1000: ft1000-usb: Removed unnecessary else statement.
      staging: ft1000: ft1000-usb: Removed unnecessary else statement.

H Hartley Sweeten (237):
      staging: comedi: amplc_dio200: remove private data
      staging: comedi: amplc_dio200: remove 'bustype' from boardinfo
      staging: comedi: amplc_dio200: remove 'mainsize' from ISA boardinfo
      staging: comedi: amplc_dio200_pci: remove 'mainsize' from PCI boardinfo
      staging: comedi: amplc_dio200.h: remove 'mainsize' from boardinfo
      staging: comedi: amplc_dio200: remove unnecessary local variable
      staging: comedi: amplc_dio200: tidy up comedi_driver declaration
      staging: comedi: amplc_dio200: tidy up {comedi, pci}_driver declarations
      staging: comedi: amplc_dio200.h: remove struct dio200_layout definition
      staging: comedi: amplc_dio200.h: remove unnecessary function comment descriptions
      staging: comedi: amplc_dio200.h: rename 'has_enhancements' in boardinfo
      staging: comedi: amplc_dio200.h: remove boardinfo 'mainshift'
      staging: comedi: amplc_dio200: absorb dio200_subdev_timer_init()
      staging: comedi: amplc_dio200: remove dio200_common_detach()
      staging: comedi: cb_pcidas: use dev->iobase for PCI bar 3
      staging: comedi: cb_pcimdas: refactor iobase addresses
      staging: comedi: cb_pcidda: refactor iobase addresses
      staging: comedi: amplc_pci230: refactor iobase addresses
      staging: comedi: 8255: add a comedi_device param to the (*io) callback
      staging: comedi: ni_mio_common: tidy up ni_8255_callback()
      staging: comedi: ni_labpc: tidy up labpc_8255_mmio()
      staging: comedi: daqboard2000: tidy up daqboard2000_8255_cb()
      staging: comedi: cb_pcidas64: tidy up dio_callback()
      staging: comedi: cb_pcidas64: tidy up dio_callback_4020()
      staging: comedi: 8255_pci: tidy up pci_8255_mmio()
      staging: comedi: 8255: refactor how the (*io) function works
      staging: comedi: 8255: remove incomplete async command support
      staging: comedi: 8255: handle memory mapped io
      staging: comedi: 8255: provide common defines for registers
      staging: comedi: usbduxsigma: fix errno (EL2NSYNC) check
      staging: comedi: usbduxsigma: fix kcalloc 'size' argument
      staging: comedi: usbdux: fix errno (EL2NSYNC) check
      staging: comedi: usbdux: remove deadcode in pcl726_intr_cmdtest()
      staging: comedi: ni_tiocmd: remove deadcode in ni_tio_cmdtest()
      staging: comedi: ni_mio_common: fix local var for 32-bit read
      staging: comedi: ni_mio_common: remove deadcode in ni_ai_insn_config()
      staging: comedi: ni_mio_common: remove deadcode in ni_cdio_cmdtest()
      staging: comedi: ni_65xx: remove deadcode in ni_65xx_intr_cmdtest()
      staging: comedi: ni_6527: remove deadcode in ni6527_intr_cmdtest()
      staging: comedi: me4000: fix aref test in me4000_ai_check_chanlist()
      staging: comedi: me4000: fix aref test in ai_write_chanlist()
      staging: comedi: gsc_hpdi: remove deadcode in gsc_hpdi_cmd_test()
      staging: comedi: dt3000: remove deadcode in dt3k_ai_cmdtest()
      staging: comedi: comedi_parport: remove deadcode in parport_intr_cmdtest()
      staging: comedi: amplc_pc236_common: remove deadcode in pc236_intr_cmdtest()
      staging: comedi: addi_apci_2032: remove deadcode in apci2030_int_cmdtest()
      staging: comedi: addi_apci_1564: remove deadcode in apci1564_cos_cmdtest()
      staging: comedi: addi_apci_1032: remove deadcode in apci1032_cos_cmdtest()
      staging: comedi: add a 'readback' member to comedi_subdevice
      staging: comedi: skel: use comedi_subdevice 'readback'
      staging: comedi: adl_pci6208: use comedi_subdevice 'readback'
      staging: comedi: aio_aio12_8: use comedi_subdevice 'readback'
      staging: comedi: dac02: use comedi_subdevice 'readback'
      staging: comedi: fl512: use comedi_subdevice 'readback'
      staging: comedi: multiq3: use comedi_subdevice 'readback'
      staging: comedi: cb_pcimdda: use comedi_subdevice 'readback'
      staging: comedi: adl_pci9111: use comedi_subdevice 'readback'
      staging: comedi: das16: use comedi_subdevice 'readback'
      staging: comedi: dt282x: use comedi_subdevice 'readback'
      staging: comedi: icp_multi: use comedi_subdevice 'readback'
      staging: comedi: pcl726: use comedi_subdevice 'readback'
      staging: comedi: s526: use comedi_subdevice 'readback'
      staging: comedi: rti802: use comedi_subdevice 'readback'
      staging: comedi: s626: use comedi_subdevice 'readback'
      staging: comedi: pcl812: use comedi_subdevice 'readback'
      staging: comedi: pcl711: use comedi_subdevice 'readback'
      staging: comedi: ni_at_ao: use comedi_subdevice 'readback'
      staging: comedi: pcmda12: use comedi_subdevice 'readback'
      staging: comedi: pcmmio: use comedi_subdevice 'readback'
      staging: comedi: ni_mio_common: use comedi_subdevice 'readback'
      staging: comedi: usbdux: use comedi_subdevice 'readback'
      staging: comedi: usbduxsigma: use comedi_subdevice 'readback'
      staging: comedi: das6402: use comedi_subdevice 'readback'
      staging: comedi: dt9812: use comedi_subdevice 'readback'
      staging: comedi: dt2811: use comedi_subdevice 'readback'
      staging: comedi: addi_apci_3501: use comedi_subdevice 'readback'
      staging: comedi: cb_das16_cs: use comedi_subdevice 'readback'
      staging: comedi: amplc_pci224: use comedi_subdevice 'readback'
      staging: comedi: amplc_pci230: use comedi_subdevice 'readback'
      staging: comedi: addi_apci_3xxx: use comedi_subdevice 'readback'
      staging: comedi: ni_atmio16d: cleanup atmio16d_ao_insn_write()
      staging: comedi: ni_atmio16d: use comedi_subdevice 'readback'
      staging: comedi: me_daq: fix bug in me_ao_insn_write()
      staging: comedi: me_daq: use comedi_subdevice 'readback'
      staging: comedi: ii_pci20kc: save unmunged data for ao readback
      staging: comedi: ii_pci20kc: use comedi_subdevice 'readback'
      staging: comedi: dt3000: use comedi_subdevice 'readback'
      staging: comedi: quatech_daqp_cs: fix bug in daqp_ao_insn_write()
      staging: comedi: quatech_daqp_cs: use comedi_subdevice 'readback'
      staging: comedi: pcl818: use comedi_subdevice 'readback'
      staging: comedi: das08: fix bug in das08_ao_winsn()
      staging: comedi: das08: use comedi_subdevice 'readback'
      staging: comedi: rti800: save unmunged data for ao readback
      staging: comedi: rti800: use comedi_subdevice 'readback'
      staging: comedi: daqboard2000: remove #if 0'ed out code in ao (*insn_write)
      staging: comedi: daqboard2000: use comedi_subdevice 'readback'
      staging: comedi: dmm32at: cleanup dmm32at_ao_winsn()
      staging: comedi: dmm32at: use comedi_subdevice 'readback'
      staging: comedi: ni_670x: cleanup ni_670x_ao_winsn()
      staging: comedi: ni_670x: use comedi_subdevice 'readback'
      staging: comedi: cb_pcimdas: cleanup cb_pcimdas_ao_winsn()
      staging: comedi: cb_pcimdas: use comedi_subdevice 'readback'
      staging: comedi: mf6x4: analog output data does not need extra masking
      staging: comedi: mf6x4: use comedi_subdevice 'readback'
      staging: comedi: cb_pcidas: use comedi_subdevice 'readback'
      staging: comedi: cb_pcidas64: use comedi_subdevice 'readback'
      staging: comedi: dt2801: use comedi_subdevice 'readback'
      staging: comedi: rtd520: use comedi_subdevice 'readback'
      staging: comedi: me4000: remove sanity checks in me4000_ao_insn_write()
      staging: comedi: me4000: use comedi_subdevice 'readback'
      staging: comedi: comedi_pci: introduce comedi_pci_detach()
      staging: comedi: adv_pci_dio: remove 'valid' member from private data
      staging: comedi: icp_multi: remove 'valid' member from private data
      staging: comedi: cb_pcidas64: tidy up freeing of the dma buffers
      staging: comedi: gsc_hpdi: tidy up freeing of the dma buffers
      staging: comedi: s626: tidy up freeing of the dma buffers
      staging: comedi: s626: use comedi_pci_detach()
      staging: comedi: skel: remove driver
      staging: comedi: adl_pci9118: remove unused boardinfo
      staging: comedi: adl_pci9118: remove 'rangelist_ao' boardinfo
      staging: comedi: adl_pci9118: remove 'ao_maxdata' boardinfo
      staging: comedi: adl_pci9118: remove 'n_aochan' boardinfo
      staging: comedi: adl_pci9118: remove 'half_fifo_size' boardinfo
      staging: comedi: adl_pci9118: remove 'n_aichanlist' boardinfo
      staging: comedi: adl_pci9118: remove 'n_aichand' boardinfo
      staging: comedi: adl_pci9118: remove 'n_aichan' boardinfo
      staging: comedi: adl_pci9118: remove 'ai_ns_min' from boardinfo
      staging: comedi: adl_pci9118: remove 'ai_pacer_min' from boardinfo
      staging: comedi: adl_pci9118: refactor 'rangelist_ai' in boardinfo
      staging: comedi: adl_pci9118: refactor 'ai_maxdata' in boardinfo
      staging: comedi: adl_pci9118: use 'context' in (*auto_attach)
      staging: comedi: adl_pci9118: remove 'device_id' from boardinfo
      staging: comedi: adl_pci9118: remove unnecessary dev->board_name initialization
      staging: comedi: adl_pci9118: rename boardinfo struct
      staging: comedi: adl_pci9118: allocate private data in pci9118_common_attach()
      staging: comedi: adl_pci9118: tidy up digital output subdevice init
      staging: comedi: adl_pci9118: tidy up digital input subdevice init
      staging: comedi: adl_pci9118: tidy up analog output subdevice init
      staging: comedi: adl_pci9118: tidy up analog input subdevice init
      staging: comedi: adl_pci9118: all registers are 32-bit
      staging: comedi: adl_pci9118: introduce pci9118_timer_write()
      staging: comedi: adl_pci9118: introduce pci9118_timer_set_mode()
      staging: comedi: adl_pci9118: tidy up analog input fifo register define
      staging: comedi: adl_pci9118: tidy up analog output register defines
      staging: comedi: adl_pci9118: rename PCI9118_ADSTAT define
      staging: comedi: adl_pci9118: tidy up the ai status register bit defines
      staging: comedi: adl_pci9118: rename PCI9118_ADCNTRL define
      staging: comedi: adl_pci9118: tidy up the ai control register bit defines
      staging: comedi: adl_pci9118: clarify the digital I/O register
      staging: comedi: adl_pci9118: introduce pci9118_ai_start_conv()
      staging: comedi: adl_pci9118: rename PCI9118_GAIN define
      staging: comedi: adl_pci9118: rename PCI9118_BURST define
      staging: comedi: adl_pci9118: rename PCI9118_SCANMOD define
      staging: comedi: adl_pci9118: rename PCI9118_ADFUNC define
      staging: comedi: adl_pci9118: tidy up the ai config register bit defines
      staging: comedi: adl_pci9118: introduce pci9118_ai_reset_fifo()
      staging: comedi: adl_pci9118: tidy up the interrupt control/status register
      staging: comedi: adl_pci9118: tidy up the interrupt control/status bit defines
      staging: comedi: adl_pci9118: move digitial output (*insn_bits) function
      staging: comedi: adl_pci9118: don't reset digital outputs
      staging: comedi: adl_pci9118: move digitial input (*insn_bits) function
      staging: comedi: adl_pci9118: use comedi_subdevice 'readback'
      staging: comedi: adl_pci9118: move analog output (*insn_write) function
      staging: comedi: adl_pci9118: cleanup and simplify pci9118_reset()
      staging: comedi: adl_pci9118: ai (*insn_read) does not use interrupts
      staging: comedi: adl_pci9118: fix ai range/aref programming
      staging: comedi: adl_pci9118: rename 'AdFunctionReg'
      staging: comedi: adl_pci9118: rename 'AdControlReg'
      staging: comedi: adl_pci9118: rename 'IntControlReg'
      staging: comedi: adl_pci9118: introduce pci9118_amcc_int_ena()
      staging: comedi: adl_pci9118: introduce pci9118_amcc_dma_ena()
      staging: comedi: adl_pci9118: introduce pci9118_amcc_setup_dma()
      staging: comedi: adl_pci9118: no need to reset ai FIFO after (*insn_read)
      staging: comedi: adl_pci9118: tidy up some wordy comments
      staging: comedi: adl_pci9118: move analog input (*insn_read) function
      staging: comedi: adl_pci9118: factor out DMA alloc/free
      staging: comedi: adl_pci9118: DMA requires an interrupt
      staging: comedi: adl_pci9118: always try to use interrupt and DMA
      staging: comedi: adl_pci9118: don't ignore hardware errors
      staging: comedi: adl_pci9118: handle master/target abort in main interrupt handler
      staging: comedi: adl_pci9118: handle error detection in main interrupt handler
      staging: comedi: adl_pci9118: handle hardware errors in interrupt handler
      staging: comedi: adl_pci9118: do cfc_handle_events() at end of interrupt
      staging: comedi: adl_pci9118: remove PCI9118_PARANOIDCHECK code
      staging: comedi: adl_pci9118: remove 'dmabuf_panic_size' from private data
      staging: comedi: adl_pci9118: convert private data true/false flags to bit-fields
      staging: comedi: adl_pci9118: remove 'dmabuf_used_size' from private data
      staging: comedi: adl_pci9118: introduce struct pci9118_dmabuf
      staging: comedi: adl_pci9118: change type of pci9118_dmabuf 'virt' member
      staging: comedi: adl_pci9118: fix interrupt_pci9118_ai_mode4_switch()
      staging: comedi: adl_pci9118: exttrg source is always EXTTRG_AI
      staging: comedi: adl_pci9118: merge pci9118_exttrg_{add,del}()
      staging: comedi: adl_pci9118: remove unused parameters from setup_channel_list()
      staging: comedi: adl_pci9118: rename setup_channel_list()
      staging: comedi: adl_pci9118: absorb pci9118_ai_set_range_aref()
      staging: comedi: adl_pci9118: tidy up pci9118_set_chanlist()
      staging: comedi: adl_pci9118: remove sanity checks in pci9118_calc_divisors()
      staging: comedi: adl_pci9118: TRIG_INT is not a valid scan_begin_src
      staging: comedi: adl_pci9118: clarify acquisition mode (ai_do) determination
      staging: comedi: adl_pci9118: tidy up 'ai_cfg' in pci9118_ai_docmd_dma()
      staging: comedi: adl_pci9118: enable DMA in common code path
      staging: comedi: adl_pci9118: introduce pci9118_ai_cmd_start()
      staging: comedi: adl_pci9118: clarify async command start
      staging: comedi: adl_pci9118: absorb DMA and non-DMA helpers
      staging: comedi: adl_pci9118: move pci9118_ai_cmdtest()
      staging: comedi: addi_apci_2032: remove "empty acquisition" async command
      staging: comedi: addi_apci_2032: absorb apci2032_int_start()
      staging: comedi: amplc_dio200_common: remove "empty acquisition" async command
      staging: comedi: amplc_dio200_common: 'stopcount' is always 'stop_arg'
      staging: comedi: amplc_dio200_common: return void from dio200_start_intr()
      staging: comedi: amplc_pci224: remove "empty acquisition" async command
      staging: comedi: amplc_pci230: remove analog output "empty acquisition" async command
      staging: comedi: amplc_pci230: 'ao_scan_count' is always 'stop_arg'
      staging: comedi: amplc_pci230: remove analog input "empty acquisition" async command
      staging: comedi: amplc_pci230: 'ai_scan_count' is always 'stop_arg'
      staging: comedi: cb_pcidas: prevent "empty acquisition" async commands
      staging: comedi: das16: prevent "empty acquisition" async command
      staging: comedi: das16m1: prevent "empty acquisition" async command
      staging: comedi: dt282x: prevent "empty acquisition" async commands
      staging: comedi: me4000: validate cmd->stop_arg in step 3 of (*do_cmdtest)
      staging: comedi: ni_atmio16d: prevent "empty acquisition" async command
      staging: comedi: ni_pcidio: prevent "empty acquisition" async command
      staging: comedi: pcl711: remove "empty acquisition" async command
      staging: comedi: pcmmio: remove "empty acquisition" async command
      staging: comedi: pcmmio: 'stop_count' is always 'stop_arg'
      staging: comedi: pcmmio: return void from pcmmio_start_intr()
      staging: comedi: pcmuio: remove "empty acquisition" async command
      staging: comedi: pcmuio: remove 'continuous' from private data
      staging: comedi: pcmuio: 'stop_count' is always 'stop_arg'
      staging: comedi: pcmuio: return void from pcmuio_start_intr()
      staging: comedi: rtd520: prevent "empty acquisition" async command
      staging: comedi: s626: remove 'ai_continuous' from private data
      staging: comedi: s626: clarify COMEDI_CB_EOA code
      staging: comedi: s626: 'ai_sample_count' is always 'stop_arg'
      staging: comedi: s626: fix cmd->stop_arg validation for stop_src == TRIG_COUNT
      staging: comedi: usbdux: prevent "empty acquisition" async commands
      staging: comedi: usbduxsigma: prevent "empty acquisition" async commands

Hans Wennborg (2):
      staging: rtl8821ae: fix %d confusingly prefixed with 0x in format strings
      staging: nokia_h4p: fix %d confusingly prefixed with 0x in format string

Heena Sirwani (12):
      Staging: bcm: Remove unneeded else after return.
      Staging: bcm: Fix line over 80 characters.
      Staging: rtl8192ee: Fix line over 80 characters.
      Staging: rtl8192ee: Removed unnecessary return statement.
      Staging: media: davinci_vpfe: Removed unnecessary out of memory message logging.
      Staging: bcm: Removed unnecessary else.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.
      Staging: lustre: lnet: selftest: Made a function static.

Heiko Stübner (3):
      iio: adc: add driver for Rockchip saradc
      iio: adc: rockchip_saradc: remove unused variable in probe
      dt-bindings: document Rockchip saradc

Heinrich Schuchardt (1):
      staging : android : sync : get_unused_fd

Hema Prathaban (7):
      staging: lustre: lustre: ptlrpc: Fix requires space
      staging: lustre: lustre: ptlrpc: Fix pointer declaration
      staging: lustre: lustre: ptlrpc: Donot initialise null
      staging: lustre: lustre: libcfs: do not use assignment in if condition
      staging: lustre: lustre: libcfs: pr_warn instead printk
      staging: lustre: lustre: ptlrpc: Placing inline keyword
      staging: lustre: lustre: ptlrpc: Fix space required

Himangi Saraogi (3):
      staging: iio: ad9951: Use devm_iio_device_register
      staging:iio:ad9852: Use devm_iio_device_register
      HID: hid-sensor-hub: use devm_ functions consistently

Hoang Tran (1):
      staging: rtl8821ae: fix sparse warning for static declarations in rtl8821ae/stats.c

Honggang Li (1):
      staging: unisys/virthba/virthba.c print u64 with %llu

Hugues Morisset (3):
      staging: lustre: fix coding style on long lines
      staging: lustre: fix inappropriate enums declarations.
      staging: lustre: fix coding style of function's pointer

Ian Abbott (158):
      staging: comedi: amplc_pci224: reformat some comments
      staging: comedi: amplc_pci224: fix checkpatch line over 80 characters
      staging: comedi: amplc_pci224: blank lines aren't necessary before a close brace '}'
      staging: comedi: amplc_pci224: multiple assignments should be avoided
      staging: comedi: amplc_pci224: fix spinlock_t definition without comment
      staging: comedi: amplc_pci224: add whitespace to pci224_boards[]
      staging: comedi: amplc_pci224: set a more descriptive MODULE_DESCRIPTION()
      staging: comedi: amplc_pci224: omit '!= 0' from logical expressions
      staging: comedi: amplc_pci224: remove some unnecessary parentheses
      staging: comedi: amplc_pci224: reduce leading whitespace in a few places
      staging: comedi: amplc_pci224: no need for '&function'
      staging: comedi: amplc_pci224: remove options to select output ranges
      staging: comedi: amplc_pci224: remove "legacy" attach mechanism
      staging: comedi: amplc_pci224: no need to manipulate PCI ref count
      staging: comedi: amplc_pci224: put board indices in PCI driver_data
      staging: comedi: amplc_pci224: remove PCI_DEVICE_ID_... macros
      staging: comedi: amplc_pci224: absorb pci224_attach_common()
      staging: comedi: amplc_pci224: no need to comedi_set_hw_dev() here
      staging: comedi: ni_labpc: remove unnecessary braces in labpc_common_attach()
      staging: comedi: ni_labpc: use braces on all arms of `if` statement
      staging: comedi: ni_labpc: Alignment should match open parenthesis
      staging: comedi: ni_labpc: Logical continuations should be on the previous line
      staging: comedi: ni_labpc: break lines after operators
      staging: comedi: ni_labpc: split common code to ni_labpc_common
      staging: comedi: Kconfig: make COMEDI_BOND select COMEDI_KCOMEDILIB
      staging: comedi: amplc_pci230: update MODULE_DESCRIPTION()
      staging: comedi: amplc_pci230: don't use multiple blank lines
      staging: comedi: amplc_pci230: remove some unnecessary parentheses
      staging: comedi: amplc_pci230: collapse some 'else { if' chains
      staging: comedi: amplc_pci230: remove "legacy" attach mechanism
      staging: comedi: amplc_pci230: no need to manipulate PCI ref count
      staging: comedi: amplc_pci230: set detach handler to comedi_pci_detach()
      staging: comedi: amplc_pci230: absorb pci230_attach_common()
      staging: comedi: amplc_pci230: no need to comedi_set_hw_dev() here
      staging: comedi: amplc_pci230: absorb pci230_alloc_private()
      staging: comedi: amplc_pci230: remove ai_chans member
      staging: comedi: amplc_pci230: remove ao_chans member
      staging: comedi: amplc_pci230: shrink struct pci230_board
      staging: comedi: amplc_pci230: simplify pci230_ao_mangle_datum()
      staging: comedi: amplc_pci230: simplify pci230_ai_read()
      staging: comedi: amplc_pci230: remove 'inline'
      staging: comedi: amplc_pci230: rename pci230_ai_rinsn()
      staging: comedi: amplc_pci230: add `pci230_` prefix to functions
      staging: comedi: amplc_pci230: use comedi_range_is_bipolar()
      staging: comedi: amplc_pci230: make `intr_running` a bitfield
      staging: comedi: amplc_pci230: replace `state` member with bitfields
      staging: comedi: amplc_pci230: rewrite shared resource handling
      staging: comedi: amplc_pci230: reduce indentation in pci230_ao_inttrig_scan_begin()
      staging: comedi: amplc_pci230: reduce indentation in pci230_ao_start()
      staging: comedi: amplc_pci230: reduce indentation in pci230_ai_inttrig_convert()
      staging: comedi: amplc_pci230: reduce indentation in pci230_ai_start()
      staging: comedi: amplc_pci230: change pci230_handle_ao_fifo() return type
      staging: comedi: amplc_pci230: simplify interrupt enable handling
      staging: comedi: ni_at_a2150: range check board index
      staging: comedi: comedi_test: use CMDF_PRIORITY
      staging: comedi: das16: use CMDF_PRIORITY
      staging: comedi: das1800: use CMDF_PRIORITY
      staging: comedi: ni_at_a2150: use CMDF_PRIORITY
      staging: comedi: ni_labpc_common: use CMDF_PRIORITY
      staging: comedi: add CMDF_WAKE_EOS as synonym for TRIG_WAKE_EOS
      staging: comedi: use CMDF_WAKE_EOS in do_cmd_ioctl()
      staging: comedi: addi_apci_3120: use CMDF_WAKE_EOS
      staging: comedi: adl_pci9118: use CMDF_WAKE_EOS
      staging: comedi: adv_pci1710: use CMDF_WAKE_EOS
      staging: comedi: amplc_pci230: use CMDF_WAKE_EOS
      staging: comedi: cb_pcidas: use CMDF_WAKE_EOS
      staging: comedi: cb_pcidas64: use CMDF_WAKE_EOS
      staging: comedi: das1800: use CMDF_WAKE_EOS
      staging: comedi: ni_labpc_common: use CMDF_WAKE_EOS
      staging: comedi: ni_mio_common: use CMDF_WAKE_EOS
      staging: comedi: ni_tiocmd: use CMDF_WAKE_EOS
      staging: comedi: pcl812: use CMDF_WAKE_EOS
      staging: comedi: rtd520: use CMDF_WAKE_EOS
      staging: comedi: add CMDF_BOGUS as synonym for TRIG_BOGUS
      staging: comedi: use CMDF_BOGUS in do_cmd_ioctl()
      staging: comedi: add CMDF_ROUND_... as synonyms for TRIG_ROUND_...
      staging: comedi: 8253.h: use CMDF_ROUND_...
      staging: comedi: addi_apci_3xxx: use CMDF_ROUND_...
      staging: comedi: adl_pci9118: use CMDF_ROUND_...
      staging: comedi: amplc_pci230: use CMDF_ROUND_...
      staging: comedi: cb_pcidas64: use CMDF_ROUND_...
      staging: comedi: das1800: use CMDF_ROUND_...
      staging: comedi: dt282x: use CMDF_ROUND_...
      staging: comedi: dt3000: use CMDF_ROUND_...
      staging: comedi: me4000: use CMDF_ROUND_...
      staging: comedi: ni_at_a2150: use CMDF_ROUND_...
      staging: comedi: ni_labpc_common: use CMDF_ROUND_...
      staging: comedi: ni_mio_common: use CMDF_ROUND_...
      staging: comedi: ni_pcidio: use CMDF_ROUND_...
      staging: comedi: rtd520: use CMDF_ROUND_...
      staging: comedi: s626: use CMDF_ROUND_...
      staging: comedi: addi_common: replace comedi_board() calls
      staging: comedi: addi_eeprom: replace comedi_board() calls
      staging: comedi: addi_apci_1516: replace comedi_board() calls
      staging: comedi: addi_apci_3120: replace comedi_board() calls
      staging: comedi: addi_apci_3xxx: replace comedi_board() calls
      staging: comedi: adv_pci1710: replace comedi_board() calls
      staging: comedi: adv_pci_dio: replace comedi_board() calls
      staging: comedi: aio_aio12_8: replace comedi_board() calls
      staging: comedi: amplc_pc236_common: replace comedi_board() calls
      staging: comedi: amplc_pci224: replace comedi_board() calls
      staging: comedi: amplc_pci230: replace comedi_board() calls
      staging: comedi: cb_pcidas64: replace comedi_board() calls
      staging: comedi: cb_pcidas: replace comedi_board() calls
      staging: comedi: das08: replace comedi_board() calls
      staging: comedi: das08_isa: replace comedi_board() calls
      staging: comedi: das16: replace comedi_board() calls
      staging: comedi: das1800: replace comedi_board() calls
      staging: comedi: das6402: replace comedi_board() calls
      staging: comedi: das800: replace comedi_board() calls
      staging: comedi: dt2801: replace comedi_board() calls
      staging: comedi: dt2811: replace comedi_board() calls
      staging: comedi: dt282x: replace comedi_board() calls
      staging: comedi: dt3000: replace comedi_board() calls
      staging: comedi: me4000: replace comedi_board() calls
      staging: comedi: ni_65xx: replace comedi_board() calls
      staging: comedi: ni_660x: replace comedi_board() calls
      staging: comedi: ni_at_a2150: replace comedi_board() calls
      staging: comedi: ni_at_ao: replace comedi_board() calls
      staging: comedi: ni_atmio16d: replace comedi_board() calls
      staging: comedi: ni_atmio: replace comedi_board() calls
      staging: comedi: ni_labpc_common: replace comedi_board() calls
      staging: comedi: ni_labpc_isadma: replace comedi_board() calls
      staging: comedi: ni_mio_common: replace comedi_board() calls
      staging: comedi: ni_pcimio: replace comedi_board() calls
      staging: comedi: pcl711: replace comedi_board() calls
      staging: comedi: pcl724: replace comedi_board() calls
      staging: comedi: pcl726: replace comedi_board() calls
      staging: comedi: pcl730: replace comedi_board() calls
      staging: comedi: pcl812: replace comedi_board() calls
      staging: comedi: pcl816: replace comedi_board() calls
      staging: comedi: pcl818: replace comedi_board() calls
      staging: comedi: pcmad: replace comedi_board() calls
      staging: comedi: pcmuio: replace comedi_board() calls
      staging: comedi: rtd520: replace comedi_board() calls
      staging: comedi: rti800: replace comedi_board() calls
      staging: comedi: vmk80xx: replace comedi_board() calls
      staging: comedi: amplc_dio200_common: replace comedi_board() calls
      staging: comedi: adl_pci9118: replace comedi_board() calls
      staging: comedi: adl_pci9118: don't allocate 2nd DMA buffer on failure
      staging: comedi: adl_pci9118: don't overallocate DMA buffer
      staging: comedi: adl_pci9118: use dma_alloc_coherent()
      staging: comedi: remove comedi_board()
      staging: comedi: addi_apci_3120: don't allocate 2nd DMA buffer on failure
      staging: comedi: addi_apci_3120: don't overallocate DMA buffer
      staging: comedi: addi_apci_3120: use dma_alloc_coherent()
      staging: comedi: addi_apci_3120: simplify setting of devpriv->us_UseDma
      staging: comedi: add comedi_bytes_per_scan()
      staging: comedi: comedi_fc: use comedi_bytes_per_scan()
      staging: comedi: add comedi_inc_scan_progress()
      staging: comedi: comedi_fc: use comedi_inc_scan_progress()
      staging: comedi: add comedi_handle_events()
      staging: comedi: comedi_fc: cfc_write_array_to_buffer() data is const
      staging: comedi: add comedi_write_array_to_buffer()
      staging: comedi: comedi_fc.h: use comedi_write_array_to_buffer()
      staging: comedi: add comedi_read_array_from_buffer()
      staging: comedi: migrate copyrights from "comedi_fc.c"
      staging: comedi: remove comedi_fc module

Ilja Sidoroff (1):
      Staging: wlan-ng: Remove redundant break/goto statements in hfa384x_usb.c

Irina Tirdea (3):
      iio: gyro: bmg160: only set power state if PM_RUNTIME is defined
      iio: magn: ak8975: fix unnecessary casting between char* and const char*
      iio: gyro: bmi055 gyro sensor driver

James Simmons (2):
      staging/lustre/lvfs: remove the lvfs layer
      staging/lustre: remove portals_compat25.h

Janet Liu (4):
      staging:lustre:lnet: lib-md.c delete space before '(' for code style
      staging:lustre:lnet lib-md.c erase space before ')' for code style
      staging:lustre:lnet: lib-md.c make line not over 80 characters
      staging:lustre:lnet: lib-md.c erase C99 // comments

Jeremiah Mahler (1):
      staging: rtl8192u/ieee80211: Fix sparse ieee80211_debug_init/_exit not declared warning

Jes Sorensen (1):
      staging: rtl8723au: Remove write-only variables hal_data_8723a.EEPROM[VP]ID

Jeshwanth Kumar N K (1):
      staging: wlan-ng: prism2mgmt.c Fix break not useful

Jingoo Han (2):
      iio: imu: inv_mpu6050: Remove casting the return value which is a void pointer
      staging: rts5208: Remove casting the return value which is a void pointer

Joe Perches (2):
      staging: rtl8192ee: Fix RT_TRACE #define and uses
      staging: vt6655: Convert DBG_PRT to pr_<level>

John L. Hammond (40):
      staging/lustre/mdc: cleanup intent if mdc_finish_enqueue() fails
      staging/lustre/clio: reorder initialization in cl_req_alloc()
      staging/lustre/llite: hold inode mutex around ll_setattr_raw()
      staging/lustre: remove linux/lprocfs_status.h
      staging/lustre remove linux/lustre_acl.h
      staging/lustre: remove linux/lustre_dlm.h
      staging/lustre: remove linux/lustre_handles.h
      staging/lustre: move lustre_intent.h to ..
      staging/lustre: remove linux/lustre_lib.h
      staging/lustre: remove linux/lustre_log.h
      staging/lustre: remove linux/lustre_net.h
      staging/lustre: remove linux/lustre_quota.h
      staging/lustre: remove linux/obd_class.h
      staging/lustre: remove linux/obd_support.h
      staging/lustre/obdecho: remove #if 0-ed out regions
      staging/lustre/obdclass: remove idmap.c
      staging/lustre/obdclass: remove lu_ucred.c
      staging/lustre/obdclass: remove mea.c
      staging/lustre: remove md_object.h
      staging/lustre/mgc: remove server specific handlers
      staging/lustre/obdclass: remove llog_test.ko
      staging/lustre/obdclass: remove llog_osd.c
      staging/lustre/mdc: remove obsolete llog ioctl handlers
      staging/lustre/lov: remove unused OBD methods
      staging/lustre/osc: remove unused OBD methods
      staging/lustre/osc: remove obsolete llog handling code
      staging/lustre: remove obd_ost.h
      staging/lustre/mdc: remove unused OBD methods
      staging/lustre/mdc: inline llog methods
      staging/lustre/mgc: inline mgc_cancel()
      staging/lustre: remove unused OBD methods
      staging/lustre/mgc: remove server specific llog handling
      staging/lustre/ptlrpc: remove sptlrpc_conf_target_get_rules()
      staging/lustre/obdclass: remove llog_ioctl.c
      staging/lustre/obdclass: remove local_storage.[ch]
      staging/lustre: remove linux/lustre_common.h
      staging/lustre: remove lvfs_linux.h
      staging/lustre: remove unused lvfs code
      staging/lustre/libcfs: remove upcall cache
      staging/lustre: remove lvfs.h

Jonathan Cameron (1):
      iio:buffer: Wrong sized allocation of demux table elements.

Josh Wu (1):
      iio: adc: at91: make the function handle_adc_eoc_trigger() static

Julia Lawall (22):
      iio: fix error return code
      imx-drm: imx-drm-core: delete unneeded test before of_node_put
      lustre: obdclass: use c99 initializers in structures
      staging: lustre: remove parentheses from return arguments
      staging: lustre: lmv: expand the GOTO macro
      staging: lustre: mdc: expand the GOTO macro
      staging: lustre: obdech: remove unused file
      staging: lustre: mgc: remove unused file
      staging: lustre: mgc: expand the GOTO macro
      staging: lustre: llite: expand the GOTO macro
      staging: lustre: fid,fld: expand the GOTO macro
      staging: lustre: adjust spacing within pointer casts
      staging: lustre: ldlm: expand the GOTO macro
      staging: lustre: ldlm: simplify rc initialization
      staging: lustre: libcfs: expand the GOTO macro
      staging: lustre: lvfs: expand the GOTO macro
      staging: lustre: obdclass: expand double GOTO macros
      staging: lustre: obdclass: expand the GOTO macro + break
      staging: lustre: obdclass: expand the GOTO macro
      staging: lustre: ptlrpc: expand the GOTO macro
      staging: lustre: lov: expand the GOTO macro
      staging: lustre: llite: Use kzalloc and rewrite null tests

Junien Fridrick (1):
      staging: lustre: fix coding style issue: missing space after 'if'

Juston Li (1):
      staging: lustre: lmv: lmv_internal.h: fix checkpatch.pl spacing errors

Kieron Browne (2):
      staging: dgnc: Fix checkpatch include warning
      staging: rtl8723au: fix sparse incorrect type assignment warnings

Konrad Zapalowicz (19):
      staging: dgnc: Fix externs should be avoided in the .c files
      staging: dgnc: Fix no spaces before tabs checkpath warning
      staging: dgnc: Fix frame size is larger than 1024B
      staging: dgnc: Remove unnecessary functions from dgnc_driver.c
      staging: dgnc: Move utility functions out of dgnc_driver.c
      staging: dgnc: Siplify the dgnc_start function
      staging: dgnc: Update the TODO file
      staging: dgnc: Fix included header from 'asm'
      staging: dgnc: Fix missing blank line after declarations
      staging: dgnc: Fix that open brace { should be on the previous line
      staging: dgnc: Fix braces {} are not necessary for single statement blocks
      staging: dgnc: Remove 'volatile' modifier where it is not needed
      staging: dgnc: Fix missing blank line after declarations
      staging: dgnc: Remove unnecessary 'return' statement
      staging: dgnc: Remove driver-wide state variable
      staging: dgnc: Remove driver-wide polling counter variable
      staging: dgnc: Remove not needed dgnc_driver_start variable
      staging: dgnc: Remove unnecessary dgnc_Major_Control_Registered variable
      staging: dgnc: Fix sleeping under spinlock bug

LABBE Corentin (1):
      staging: lustre: Annotate user buffer with __user

Larry Finger (1):
      staging: r8192ee: Remove staging driver

Lars Hamre (1):
      Staging: nokia_h4p: removed unnecessary return statement in nokia_fw.c

Lars-Peter Clausen (5):
      iio: buffer: Use roundup() instead of open-coding it
      iio: buffer: Coalesce adjacent demux table entries
      MAINTAINERS: Add designated reviewers for IIO subsystem
      MAINTAINERS: Add entry for Analog Devices IIO drivers
      staging:iio: Remove ad5930/ad9850/ad9852/ad9910/ad9951 dummy drivers

Laurentiu Palcu (6):
      staging: iio: light: isl29018: fix typo
      staging: iio: light: isl29018: add support for isl29023 and isl29035
      iio: accel: BMC150: fix scale value for 16G
      iio: accel: BMC150: fix issues when CONFIG_PM_RUNTIME is not set
      staging: iio: light: isl29018: add ACPI support
      iio: accel: BMC150: add support for other Bosch chips

Lee Jones (1):
      iio: sensors-core: st: Check st_sensors_set_drdy_int_pin()'s return value

Loic Pefferkorn (6):
      staging: goldfish: suppress consecutive blank lines
      staging: goldfish: remove useless space after a cast
      staging: goldfish: document spinlock usage
      staging: goldfish: fix alignment to match open parenthesis
      staging: goldfish: document mutex usage
      staging: goldfish: avoid multiple assignments

Loïc Pellegrino (1):
      staging/lustre: Different prototypes between the declaration and the definition

Luca Ceresoli (1):
      staging: rtl8188eu: fix missing blank lines after declarations

Luca Ellero (9):
      staging: comedi: add NI USB-6501 support
      staging: comedi: ni_usb6501: add counter commands
      staging: comedi: ni_usb6501: update comments
      staging: comedi: ni_usb6501: cleanup response_size
      staging: comedi: ni_usb6501: replace spaces with tabs
      staging: comedi: ni_usb6501: remove useless check
      staging: comedi: ni_usb6501: remove empty lines
      staging: comedi: ni_usb6501: rename ni6501_send_command()
      staging: comedi: ni_usb6501: add counter subdevice

Luke Hart (1):
      staging: unisys: Fix sparse error - accessing __iomem directly

Mahati Chamarthy (32):
      Staging: rtl8192e: Fix style warnings relating to printk(KERN_DEBUG
      Staging: rtl8192e: Fix unnecessary parentheses style warning
      Staging: rtl8192e: Fix else is not useful style warning
      Staging: rtl8192e: Fix void function return statements style warning
      Staging: rtl8192e: Fix else is not useful warning
      Staging: rtl8192e: Fix space before semicolon warning
      Staging: rtl8192e: Fix printk style warning
      Staging: rtl8192e: Fix printk debug style warning
      Staging: rtl8192ee: Fix missing blank line warning
      Staging: rtl8192ee: Fix else is not useful warning
      Staging: rtl8192ee: Fix break is not useful warning
      Staging: rtl8192ee: Fix else not useful style warning
      Staging: rtl8192ee: rtl8192ee: Fix missing blank line warning
      Staging: rtl8192e: Fix __constant_htons to htons style warning
      Staging: vt6656: Merges two lines of code and removes unused variable
      Staging: vt6656: Merges two lines of code and also removes unused variable
      Staging: rtl8192e: rtl8192e: Merges two lines of code and removes unused variable
      Staging: rtl8192e: Fix else is not useful warning style
      Staging: vme: devices: Merges two lines of code and removes unused variable
      Staging: media: lirc: Merge two lines and remove unused variable
      Staging: rtl8192e: rtl8192e: Merge two lines and remove unused variable
      Staging: media: omap24xx: Fix else is not useful warning
      Staging: rts5208: Fix missing blank line warning
      Staging: dgnc: Remove space before parenthesis
      Staging: media: davinci_vpfe: Remove unused variable
      Staging: rtl8192e: rtl8192e: Remove assigned unused variable
      Staging: rtl8192e: Remove unused variable
      Staging: media: omap24xx: Merge two lines and remove unused variable
      Staging: dgnc: Remove return in void function
      Staging: dgnc: Remove unnecessary braces
      Staging: dgnc: Add missing blank line
      Staging: unisys: Add missing blank line

Malcolm Priestley (61):
      staging: vt6655: rxtx: Replace typedef struct tagSMICHDRHead
      staging: vt6655: Remove TxInSleep macro
      staging: vt6655: BSSvSecondTxData remove #if 1 else directive
      staging: vt6655: Replace and remove typedef QWORD/ DQWORD
      staging: vt6655: CARDqGetNextTBTT calculate qwTSF using do_div
      staging: vt6655: CARDbSetBeaconPeriod call CARDbGetCurrentTSF to get TBTT
      staging: vt6655: upc.h: Remove unused macros
      staging: vt6655: upc.h replace read and write memory functions
      staging: vt6655: device.h use change __device_info to vnt_private
      staging: vt6655: baseband replace PSDevice
      staging: vt6655: card change PSDevice to struct vnt_private
      staging: vt6655: channel/wcmd/wctl/wmgr use struct vnt_private *
      staging: vt6655: bssdb/datarate/dpc/power/rxtx use struct vnt_private
      staging: vt6655: hostap/ioctl/iwctl use struct vnt_private
      staging: vt6655: rf/wpactl/wroute use struct vnt_private
      staging: vt6655: device_main Replace DEVICE_INFO with size of pointer
      staging: vt6655: remove typedef from struct vnt_private
      staging: vt6655: Use ether_crc in kernel.
      staging: vt6655: main_usb.c remove undefined PLICE_DEBUG code.
      staging: vt6655: remove PLICE_DEBUG where it is defined
      staging: vt6655: vntwifi.c remove unused directive PLICE_DEBUG
      staging: vt6655: remove remaining comments of PLICE_DEBUG
      staging: vt6655: device.h dead code remove bCCK
      staging: vt6655: add new stucture struct vnt_phy_field for rts/cts/data structures
      staging: vt6655: baseband add new function vnt_get_phy_field
      staging: vt6655: rxtx.c change BBvCalculateParameter to function vnt_get_phy_field
      staging: vt6655: card.c change BBvCalculateParameter to vnt_get_phy_field
      staging: vt6655: Remove BBvCalculateParameter and its data members
      staging: vt6655: remove multiple instances of driver loading.
      staging: vt6655: remove multiple instances of netdevice.
      staging: vt6655: dead code remove device_nics variable
      staging: vt6655: 80211mgr.h add ieee80211.h header and fix conflicts
      staging: vt6655: rxtx.h structure vnt_mic_hdr add IEEE80211_CCMP_PN_LEN macro
      staging: vt6655: rxtx create new structure vnt_tx_short_buf_head for csBeacon_xmit
      staging: vt6655: rxtx replace typedef struct tagSRrvTime_gRTS with struct vnt_rrv_time_rts
      staging: vt6655: rxtx replace typedef struct tagSRrvTime_gCTS with struct vnt_rrv_time_cts
      staging: vt6655: rxtx replace typedef struct tagSRrvTime_ab with struct vnt_rrv_time_ab
      staging: vt6655: create vnt_rxtx_rsvtime_le16 to return s_uGetTxRsvTime endian corrected.
      staging: vt6655: rxtx change s_uGetRTSCTSRsvTime to always return __le16
      staging: vt6655: s_vGenerateTxParameter removed nested pvRrvTime NULL check
      staging: vt6655: rxtx.c create function to return __le16 wTimeStampOff
      staging: vt6655: replace typedef struct tagSTxDataHead_g with struct vnt_tx_datahead_g
      staging: vt6655: replace typedef struct tagSTxDataHead_g_FB with struct vnt_tx_datahead_g_fb
      staging: vt6655: replace typedef struct tagSTxDataHead_ab with struct vnt_tx_datahead_ab
      staging: vt6655: replace -typedef struct tagSTxDataHead_a_FB with struct vnt_tx_datahead_a_fb
      staging: vt6655: Fix *Duration s_uFillDataHead to return to __le16
      staging: vt6655: Replace typedef struct tagSRTSData with ieee80211_rts data
      staging: vt6655: Replace typedef struct tagSCTSData with ieee80211_cts data
      staging: vt6655: replace typedef struct tagSRTS_g with struct vnt_rts_g
      staging: vt6655: replace typedef struct tagSRTS_g_FB with struct vnt_rts_g_fb
      staging: vt6655: replace typedef struct tagSRTS_ab with struct vnt_rts_ab
      staging: vt6655: replace typedef struct tagSRTS_a_FB with struct vnt_rts_a_fb
      staging: vt6655: replace typedef struct tagSCTS with struct vnt_cts
      staging: vt6655: replace typedef struct tagSCTS_FB with struct vnt_cts_fb
      stgaing: vt6655: remove unused variable wCTSDuration
      staging: vt6655: s_uGetRTSCTSDuration always return __le16
      staging: vt6655: Replace typedef enum _CARD_OP_MODE eOPMode with enum nl80211_iftype op_mode.
      staging: vt6655: device_free_info() warn: variable dereferenced before check
      staging: vt6656: remove rate_control_algorithm pid
      staging: vt6655: pr_err remove string to net device name
      staging: vt6655: device_get_options remove unused variable devname

Marco Cyriacks (1):
      staging: lustre: socklnd: Remove static initialization to NULL or 0

Mario Schlegel (1):
      staging: lustre: osc: add blank line after declarations

Mark Einon (50):
      staging: et131x: Use eth_mac_addr() instead of duplicating the functionality
      staging: et131x: Don't handle rx/tx packets when changing mtu
      staging: et131x: Use for loop to initialise contiguous registers to zero
      staging: et131x: Use for loop to initialise contiguous macstat registers to zero
      staging: et131x: Remove unnecessary i2c_wack variable
      staging: et131x: Rename NUM_PACKETS_HANDLED to MAX_PACKETS_HANDLED
      staging: et131x: Fix ET_INTR_TXDMA_ISR register name typo
      staging: et131x: Implement NAPI support
      staging: et131x: Remove dead code in isr
      staging: et131x: Remove spinlock fbr_lock
      staging: et131x: Add auto-negotiation and 1000BT_Half as supported protocols
      staging: et131x: Fix whitespace - alignment matching open parenthesis
      staging: et131x: Remove et131x_send_packets() function
      staging: et131x: In et131x_tx(), don't return NETDEV_TX_BUSY, just drop the packet
      staging: et131x: Tidy up rx/tx dropped & bytes stats
      staging: et131x: Remove ununsed statistics
      staging: et131x: Remove struct tcb->flags
      staging: et131x: Combine two if statements with same effect
      staging: et131x: Simplify code in nic_rx_pkts() for multicast_pkts_rcvd
      staging: et131x: Remove 'reduce number of spinlocks' TODO item
      staging: et131x: Remove extra blank lines in et131x.h
      staging: et131x: Remove blank lines form et131x.c
      staging: et131x: Simplify unlocking tcb_send_qlock in et131x_tx_timeout()
      staging: et131x: Remove send_hw_lock spinlock
      staging: et131x: Remove useless assignment to NULL
      staging: et131x: Add spinlock definition comments
      staging: et131x: Remove spaces after casts
      staging: et131x: Use braces on all arms of if/else statements
      staging: et131x: Use variable names instead of types in sizeof
      staging: et131x: Fix 'else is not generally useful after a break or return'
      staging: et131x: logical continuations should be on the previous line
      staging: et131x: Remove unused et131x_adapter struct members
      staging: et131x: Remove unused MP_TCB defines
      staging: et131x: Remove unused ce_stats struct member
      staging: et131x: Reduce split lines in et131x_rx_dma_memory_alloc()
      staging: et131x: Reduce split lines by renaming some psr variables
      staging: et131x: Use braces on all arms of if/else in et131x_handle_recv_pkts
      staging: et131x: Reduce split lines by renaming flowcontrol
      staging: et131x: Remove TODO item regarding split lines
      staging: et131x: zero allocation of fbr to prevent random address access
      staging: et131x: don't cast a void* to a struct pointer
      staging: et131x: Add space after { in pci ID table
      staging: et131x: Remove unnecessary defines to enable driver PM
      staging: et131x: Use ether_addr_copy when copying ethernet addresses
      staging: et131x: Cat some lines less than 80 columns
      staging: et131x: Remove unnecessary OOM message
      staging: et131x: Remove unnecessary parentheses
      staging: et131x: Audit and update comments
      staging: et131x: Simplify for loop in et131x_init_send()
      staging: et131x: Remove et131x driver from drivers/staging

Martin Berglund (2):
      staging: vt6655: iowpa.h: Fix sparse warnings
      staging: vt6655: wpactl.c: Fix sparse warnings

Martin Kelly (1):
      Staging/bcm: Fix whitespace/comments in Ioctl.h

Martin Kepplinger (1):
      rtl8192u: remove typedef

Masanari Iida (1):
      staging: exxx_udc: Convert pr_warning to pr_warn

Mathieu OTHACEHE (2):
      staging: lustre: Fix space prohibited between function name and open parenthesis
      staging: rtl8821ae: fix sparse warning for static declarations

Matthew Casey (1):
      staging: rtl8192e: fixed coding style issues

Matthias Beyer (59):
      Staging: bcm: Bcmchar.c: Fixed indentation of function arguments
      Staging: bcm: Bcmchar.c: Renamed variable "Adapter" -> "ad"
      Staging: bcm: Bcmchar.c: Renamed variable "pReadData" -> "read_data"
      Staging: bcm: Bcmchar.c: Renamed variable "stNVMReadWrite" -> "nvm_rw"
      Staging: bcm: Bcmchar.c: Renamed variable "Status" -> "status"
      Staging: bcm: Bcmchar.c: Renamed variable "ulDSDMagicNumInUsrBuff" -> "dsd_magic_num_in_usr_buff"
      Staging: bcm: Bcmchar.c: Renamed variable "pTarang" -> "tarang"
      Staging: bcm: Bcmchar.c: Renamed variable "PktLen" -> "pkt_len"
      Staging: bcm: Bcmchar.c: Renamed variable "Packet" -> "packet"
      Staging: bcm: Bcmchar.c: Renamed variable "sRdmBuffer" -> "rdm_buff"
      Staging: bcm: Bcmchar.c: Renamed variable "IoBuffer" -> "io_buff"
      Staging: bcm: Bcmchar.c: Renamed variable "Bufflen" -> "buff_len"
      Staging: bcm: Bcmchar.c: Renamed variable "sWrmBuffer" -> "wrm_buff"
      Staging: bcm: Bcmchar.c: Renamed variable "uiTempVar" -> "tmp"
      Staging: bcm: Bcmchar.c: Renamed variable "ucResetValue" -> "reset_val"
      Staging: bcm: Bcmchar.c: Renamed variable "uiBit" -> "bit"
      Staging: bcm: Bcmchar.c: Renamed variable "uiOperation" -> "operation"
      Staging: bcm: Bcmchar.c: Fixed debug output
      Staging: bcm: Bcmchar.c: Renamed variable: "Adapter" -> "ad"
      Staging: bcm: Bcmchar.c: Renamed variable: "threadReq" -> "thread_req"
      Staging: bcm: Bcmchar.c: Renamed variable: "IoBuffer" -> "io_buff"
      Staging: bcm: Bcmchar.c: Renamed variable: "uiBit" -> "bit"
      Staging: bcm: Bcmchar.c: Renamed variable: "ucRead" -> "read"
      Staging: bcm: Bcmchar.c: Renamed variable: "Status" -> "status"
      Staging: bcm: Bcmchar.c: Renamed variable: "ucResetValue" -> "reset_val"
      Staging: bcm: Bcmchar.c: Renamed variable: "pvBuffer" -> "buff"
      Staging: bcm: Bcmchar.c: Renamed variable: "ulSFId" -> "sf_id"
      Staging: bcm: Bcmchar.c: Renamed variable: "psFwInfo" -> "fw_info"
      Staging: bcm: Bcmchar.c: Renamed variable: "NVMAccess" -> "nvm_access"
      Staging: bcm: Bcmchar.c: Renamed variable: "uiLoopIndex" -> "i"
      Staging: bcm: Bcmchar.c: Renamed variable: "uiData" -> "data"
      Staging: bcm: Bcmchar.c: Renamed variable: "pBulkBuffer" -> "bulk_buff"
      Staging: bcm: Bcmchar.c: Renamed variable: "uiTempVar" -> "tmp"
      Staging: bcm: Bcmchar.c: Renamed variable: "uiSectorSize" -> "sector_size"
      Staging: bcm: Bcmchar.c: Renamed variable: "sUserDebugState" -> "user_debug_state"
      Staging: bcm: Bcmchar.c: Renamed variable: "stNVMReadWrite" -> "nvm_rw"
      Staging: bcm: Bcmchar.c: Renamed variable: "pReadData" -> "read_data"
      Staging: bcm: Bcmchar.c: Renamed variable: "sFlash2xRead" -> "flash_2x_read"
      Staging: bcm: Bcmchar.c: Renamed variable: "pReadBuff" -> "read_buff"
      Staging: bcm: Bcmchar.c: Renamed variable: "BuffSize" -> "buff_size"
      Staging: bcm: Bcmchar.c: Renamed variable: "ReadBytes" -> "read_bytes"
      Staging: bcm: Bcmchar.c: Renamed variable: "WriteBytes" -> "write_bytes"
      Staging: bcm: Bcmchar.c: Renamed variable: "pWriteBuff" -> "write_buff"
      Staging: bcm: Bcmchar.c: Renamed variable: "InputAddr" -> "input_addr"
      Staging: bcm: Bcmchar.c: Renamed variable: "WriteOffset" -> "write_off"
      Staging: bcm: Bcmchar.c: Renamed variable: "psFlash2xBitMap" -> "flash_2x_bit_map"
      Staging: bcm: Bcmchar.c: Renamed variable: "eFlash2xSectionVal" -> "flash_2x_section_val"
      Staging: bcm: Bcmchar.c: Renamed variable: "sCopySectStrut" -> "copy_sect_strut"
      Staging: bcm: Bcmchar.c: Renamed variable: "SectOfset" -> "sect_offset"
      Staging: bcm: Bcmchar.c: Renamed variable: "stNVMRead" -> "nvm_read"
      Staging: bcm: Bcmchar.c: Renamed variable: "ReadOffset" -> "read_offset"
      Staging: bcm: Bcmchar.c: Renamed variable: "RxCntrlMsgBitMask" -> "rx_cntrl_msg_bit_mask"
      Staging: bcm: Bcmchar.c: Renamed variable: "DevInfo" -> "dev_info"
      Staging: bcm: Bcmchar.c: Renamed variable: "stTimeElapsedSinceNetEntry" -> "time_elapsed_since_net_entry"
      Staging: bcm: Bcmchar.c: Renamed variable: "pTarang" -> "tarang"
      Staging: bcm: Bcmchar.c: Renamed variable: "NOB" -> "nob"
      Staging: bcm: Bcmnet.c: Renamed variable: "Adapter" -> "ad"
      Staging: bcm: Bcmnet.c: Renamed variable: "psIntfAdapter" -> "intf_ad"
      Staging: bcm: Bcmnet.c: Renamed variable: "IntfAdapter" -> "intf_ad"

Max Vozeler (1):
      staging: rtl8188eu: Add missing include to pick up prototype

Melike Yurtoglu (11):
      staging: octeon: Fix missing blank line warning.
      staging: unisys: common-spar: Fix missing blank line warning
      staging: rts5208: Fix missing blank line warning.
      staging: rts5208: Remove unneeded void return
      staging: speakup: Fix missing blank line warning
      staging: speakup: Fixed warning <linux/serial.h> instead of <asm/serial.h>
      staging: rtl8192e: Array was made static const char * const
      staging: rtl8192e: Fix unnecessary space before function pointer arguments
      staging: rtl8192e: Fix void function return statements style
      staging: rtl8192e: Remove unneeded void return
      staging: rtl8712: Fix missing blank line warning

Merlin Chlosta (1):
      staging: rtl8192u: sparse warnings: declare ieee80211_TURBO_Info static

Michal Simek (1):
      iio: adc: xilinx: Remove .owner field for driver

Michał Bartoszkiewicz (1):
      staging: gs_fpgaboot: remove unnecessary return statements

MihaelaGaman (1):
      staging: rtl8723au: Fix checkpatch errors

Mikhail Pershin (1):
      staging/lustre: use osc_reply_portal for OUT services

Mostyn Bramley-Moore (1):
      staging/lustre: annotate lock/unlock in lov_stripe_lock / lov_stripe_unlock

Murilo Opsfelder Araujo (2):
      staging: iio: accel: sca3000_core.c: Adjust code to fit 80-chars limit
      staging: iio: accel: Add blank lines between declarations and code

Nathaniel Clark (1):
      staging/lustre/llite: check for integer overflow in hsm user request

Nick Hudson (1):
      usb: dwc2: make the scheduler handle excessive NAKs better

Nicolas Thery (1):
      staging: rtl8188eu: include missing header

Nicoleta Birsan (1):
      Staging: speakup: fix checkpatch warning

Niklas Svensson (1):
      staging: comedi: fixing coding style problems

Nitin Kuppelur (2):
      Staging: octeon-hcd: removed unwanted return from void
      Staging: octeon-hcd: removed dummy label

Oleg Drokin (13):
      staging/lustre/lnet: Fix potential uninitialized variable warning
      staging/lustre/llite: Fix integer overflow in ll_fid2path
      staging/lustre: get rid of seqno_t and mdsno_t typedefs
      staging/lustre: get rid of obd_* typedefs
      lustre: Add MAINTAINERS entry
      lustre: Add some basic documentation
      staging/lustre/obdclass: remove unused file md_attrs.c
      staging/lustre/obdclass: remove unused file llog_lvfs.c
      staging/lustre/obdclass: remove unused file linkea.c
      staging/lustre: remove unused request policies.
      staging/lustre: Remove unused header libcfs_heap.h
      staging/lustre: remove unused som_attrs and hsm_attrs structures
      staging/lustre: remove unused function is_osp_on_mdt

Omar Sandoval (2):
      staging: bcm: sort.c: fix coding style
      staging: lustre: fix gfp_t/int coercion

Oussama Jabbari (1):
      staging: iio: adis16060: Fix coding style problem

Ovidiu Toader (1):
      drivers/staging/rtl8192u/r8192U_wx.c: fix warnings issued by sparse

Paul Bolle (2):
      staging: emxx_udc: remove check for CONFIG_MACH_EMGR
      staging: gs_fpgaboot: remove checks for CONFIG_B4860G100

Paul Cassella (1):
      staging/lustre/llite: Make sure ft_flags is valid

Peng Tao (1):
      staging/lustre/obdecho: remove metadata echo client

Peter Meerwald (11):
      iio:bma180: Enable use of device without IRQ
      iio:bma180: Prefix remaining tables and functions with bma18_
      iio:bma180: Rename BMA_180 to BMA180_
      iio:bma180: Use bool instead of int for state
      iio:bma180: Expose temperature channel
      iio:bma180: Drop _update_scan_mode()
      iio:bma180: Introduce part_info to differentiate further chip variants
      iio:bma180: Introduce part-specific _config() and disable() code
      iio:bma180: Prepare for accelerometer channels with different resolutions
      iio:bma180: Implement _available sysfs attribute dynamically
      iio:bma180: Add BMA250 chip support

Philippe Reynes (1):
      iio: add support of the max5821

Phong Tran (4):
      staging: android: ion: ion_dummy_driver.c Replace kzalloc() by kcalloc()
      staging: android: ion: ion.c Add a new blank line after decleration
      staging: android: ion: Remove redundant return of void function
      staging: lustre: lnet: socklnd_cb.c Fix sparse non-static symbol warning

Piotr Witoslawski (1):
      drivers: staging: dgap: fix the checkpatch.pl issue "Warning: line over 80 characters"

Purnendu Kapadia (2):
      staging: android: fix attribute as suggested by checkpatch
      staging: android: sw_sync: checkpatch fixes

Quentin Lambert (2):
      staging: imx-drm: fix a blank line coding style issue
      staging: slicoss: fix a blank line coding style issue

Ragnar B. Johannsson (4):
      staging: vt6656: remove unnecessary braces
      staging: vt6656: fix incorrect indentation
      staging: vt6656: add blank line after declaration
      staging: rtl8192u: Move ieee80211_crypto_* declarations to ieee80211/ieee80211.h

Rahul Garg (1):
      patch "staging: rtl8723au: os_dep: declared cfg80211_infrastructure_mode static

Rajbinder Brar (3):
      Staging: vt6656: Removing else after break statement to fix warning
      Staging: vt6655: Break 80 character long line to remove checkpatch error
      Staging: vt6656: Merge two lines of code into one

Ramesh Basukala (1):
      Staging: bmc: fix coding style warning

Ramon Fried (2):
      staging: netlogic: Fix checkpatch.pl warning
      staging: lustre: llite_lib.c Set ll_md_setattr function to be static

Reyad Attiyat (1):
      iio: hid-sensor-magn-3d: Fix build warning

Rickard Strandqvist (1):
      staging: lustre: Cleaning up unnecessary use of memset in conjunction with strncpy

Roberta Dobrescu (19):
      staging: dgnc: Fix warnings relating to printk()
      staging: dgnc: Replace kzalloc with kcalloc
      staging: dgnc: Do not initialise statics to 0 or NULL
      staging: dgnc: Move open brace on previous line
      staging: dgnc: Check sscanf return value
      staging: emxx_udc: Replace __constant_cpu_to_le16 with cpu_to_le16
      staging: emxx_udc: Do not use comparisons on bool tests
      staging: emxx_udc: Do not assign bool to 0/1
      staging: dgnc: Replace non-standard spinlock's macros
      staging: iio: Add #include guards to header files
      staging: iio: light: Fix quoted string split across lines
      staging: iio: light: Remove space before function pointer arguments
      staging: iio: light: Add a blank line after declarations
      staging: dgnc: dgnc_mgmt.c: Replace non-standard spinlock's macros
      staging: dgnc: dgnc_tty.c: Replace non-standard spinlock's macros
      staging: dgnc: dgnc_neo.c: Replace non-standard spinlock's macros
      staging: dgnc: dgnc_driver.c: Replace non-standard spinlock's macros
      staging: dgnc: dgnc_driver.h: Remove non-standard spinlock's macros
      staging: iio: resolver: Annotate Kconfig entries with module name information

Roxana Blaj (14):
      staging: speakup: fix checkpatch warning
      staging: speakup: fix checkpatch warning
      staging: rts5208: remove unnecessary else
      staging: rts5208: remove unnecessary return statement
      staging: rts5208: add new line after declarations
      staging: iio: frequency: add new line after declarations
      staging: iio: frequency: remove unnecessary semicolon
      staging: rtl8192u: add space before the open parenthesis '('
      staging: rtl8192u: add space after close brace '}'
      staging: rtl8192u: remove space before semicolon
      staging: rtl8192u: remove space before close parenthesis ")"
      staging: iio: addac: remove unnecessary else
      staging: rts5208: remove unnecessary else
      staging: rts5208: remove unnecessary else

Sanjeev Sharma (3):
      staging:r819xU: coding style: Fixed commenting style
      iio: remove .owner field for driver using module_platform_driver
      staging:r8190_rtl8256: coding style: Fixed commenting style

Sarah Khan (2):
      staging: rtl8712: fixed missing blank line
      staging: rtl8712: Fixed else not required after return

SeeChen Ng (1):
      staging: netlogic: fix checkpatch.pl "LINE_SPACING" issuses

Seunghun Lee (3):
      staging: dgnc: remove DPR Macros and related codes.
      staging: dgnc: remove some unused macros
      staging: dgnc: split two assignments into the two assignments on two lines.

Shawn Guo (2):
      imx-drm: ipuv3-plane: remove function ipu_plane_dpms()
      imx-drm: imx-drm-core: add basic suspend/resume support

Spencer Baugh (2):
      staging: lustre: fix function definition style
      staging: lustre: fix pointer whitespace style

Srikrishan Malik (13):
      staging: lustre: remove space between function name and and open parenthesis
      staging: lustre: remove spaces from start of line
      staging: lustre: move open brace to next line after functions
      staging: lustre: fix lines over 80 chars
      staging: lustre: Add missing spaces around operators and braces.
      staging: lustre: replace c99 style comments with C89
      staging: lustre: add blank lines after declarations
      ] staging: lustre: fix multi line strings
      staging: lustre: Added space between type name and *
      staging: lustre: Fix misplaced opening brace warnings
      staging: lustre: move else on the same line as closing brace
      staging: lustre: remove parentheses usage with return
      staging: lustre: Cleanup variable declarations in mdc_enqueue()

Srinivas Pandruvada (7):
      iio: accel: kxcjk-1013: support runtime pm
      iio: accel: kxcjk-1013: Set adjustable range
      iio: accel: BMC150 accel support
      iio: accel: BMC150 accel documentation
      iio:gyro:bmg160 Gyro Sensor driver
      iio:gyro:bmg160 documentation
      iio: accel: kxcjk-1013: Support thresholds

Stephen Rothwell (1):
      staging: rtl8188eu: using unique names is good

Steve Longerbeam (2):
      gpu: ipu-v3: Add ipu-cpmem unit
      staging: imx-drm: Convert to new ipu_cpmem API

Sudip Mukherjee (6):
      staging: lustre: lnet: lib-ptl.c: sparsa warning: symbol not declared
      staging: et131x: et131x.c: sparse warning of incompatible types
      staging: unisys: uislib: uisqueue.c: rewrite of do_locked_client_insert
      staging: unisys: uislib: uislib.c: sparse warning of context imbalance
      staging: unisys: uislib: uislib.c: sparse warning of context imbalance
      staging: unisys: uislib: uislib.c: sparse warning of context imbalance

Sun Wang (1):
      staging: lustre: lustre: mdc: mdc_reint: fix coding style issue

Sören Brinkmann (1):
      staging: ad7606_core: Fix checkpatch warning

Tapasweni Pathak (35):
      staging: iio: accel: remove else after return
      Staging: rtl8712: remove break after return statement
      Staging: rtl8712: remove semicolon after macro
      Staging: rtl8712: remove void function return; statement
      Staging: rtl8712: fixed space prohibition
      Staging: rtl8712: remove unnecessary 'out of memory' message
      Staging: rtl8712: use kmalloc_array over kmalloc
      Staging: rtl8712 : Fix line over 80 characters
      Staging: rtl8712: Remove unnecessary parentheses
      Staging: rtl8712: Add space after return type
      staging: rtl8712: merge lines and remove unused variable for immediate return
      Staging: media: lirc: fixed else after return or break warning
      staging: media: lirc: remove unnecessary break after return
      staging: speakup: remove jiffies comparison using time_after_eq()
      staging: vt6655: remove unnecessary else after return
      staging: vt6655: shift open brace '{' to previous line
      staging: vt6656: remove unnecessary else after return
      Staging: ste_rmi4: add new line after declarations
      staging: bcm: fix error do not use c99 comments
      staging: bcm: remove space before tab
      staging: rtl8723au: core: add consistent spacing around '-'
      staging: rtl8192u: remove unecessary variable
      staging: rtl8712: add new line after declarations
      staging: rts5208: Add new line after declaration
      staging: rts5208: Remove unncessary return in function returning void
      Staging: media: lirc: Add new line after declarations
      staging: media: cxd2099: use usleep_range()
      staging: vt6656: Merge three lines into one
      staging: vt6655: Merge three lines into one
      staging: lustre: include: linux: libcfs: use __packed instead of __attribute__((packed))
      staging: lustre: include: linux: libcfs: Remove intialization of static to 0
      staging: lustre: include: linux: libcfs: Remove spaces at the start of a line
      staging: lustre: lnet: lnet: Remove unnecessary else after return
      staging: lustre: lnet: lnet: Remove space between function name and open paranthesis '('
      staging: lustre: lustre: obdclass: linux: include <linux/*.h> instead of <asm/*.h>

Teodora Baluta (4):
      staging: iio: ad5933: fix sparse warnings
      staging: iio: hmc5843_core: fix sparse warnings
      staging: iio: isl29018: fix sparse warning regarding incorrect type (different signedness)
      staging: iio: adis16240: fix sparse warnings regarding incorrect argument type

Thomas Gummerer (1):
      staging: xgifb: remove unnecessary else

Tina Johnson (6):
      Staging: lustre: lustre: mdc: mdc_request: Removed useless variable
      Staging: iio: meter: ade7753: Merged assignment with immediately following return statement
      Staging: iio: meter: ade7753: Fixed checkpatch.pl warnings
      Staging: media: lirc: lirc_imon: Removed unnecessary variable to simplify return variable handling
      Staging: lustre: Replace GOTO macro with necessary code
      Staging: rts5208: Fix checkpatch warning: Missing blank line

Tobenna P. Igwe (2):
      staging: unisys: uislib: Fixed missing blank line coding style issue
      staging:rtl8188eu: Fix sparse warning cast to restricted __le16

Tobias Klauser (3):
      staging: vt6655: Remove unused member from struct vnt_private
      staging: vt6655: Use net_device_stats from struct net_device
      staging: vt6655: Remove unnecessary condition around include

Tom Wales (1):
      Staging: lustre: checkpatch: remove blank spaces

Vaishali Thakkar (12):
      Staging: rtl8188eu: os_dep: Compression of lines for immediate return
      Staging: rtl8192e: rtl8192e: Remove unnecessory variable
      Staging: rtl8192e: rtl8192e: Remove unnecessory braces and space
      Staging: rtl8192e: Fixed style warning relating to printk()
      Staging: dgnc: Merge lines and remove unused variable for immediate return
      Staging: lustre: Return statement is moved left after removing else
      Staging: lustre: Unnecessory else and braces are removed
      Staging: iio: light: Use usleep_range instead of msleep
      Staging: iio: adc: Use usleep_range instead of msleep
      Staging: iio: Remove unnecessory immediate else after return statement
      Staging: iio: adc: Add missing blank line
      Staging: iio: adc: Update Kconfig entries adding module name information

Valdis Kletnieks (1):
      staging/rtl8192u - check for skb alloc failure

Vincenzo Scotti (4):
      staging: emxx_udc: fix style warnings: blank line after declarations
      staging: emxx_udc: fix style warnings: return in void functions
      staging: emxx_udc: fix style warnings: const strings should be const char
      staging: emxx_udc: fix compile warnings: discarding const qualifier

Vladimir A. Nazarenko (1):
      Staging: comedi: Fix code style in jr3_pci.c

William Panlener (1):
      staging: android: Break up a long line in binder_send_failed_reply

Yannis Damigos (1):
      staging: imx-drm: Lines over 80 characters fixed.

Yee Chin, Chiam (1):
      Staging: android: sw_sync.c: Fixed coding style issue.

Yeliz Taneroglu (5):
      staging: bcm: Fix quoted string split across lines warning
      staging: dgnc: Fix no spaces at the start of a line in dpacompat.h
      staging: rtl8712: Fix unnecessary parentheses style warning
      staging: media: omap4iss: Fixed else after return or break warning
      staging: media: Fixed else after return or break warning

Zheng Di (1):
      staging: lustre: declare some functions as static

navin patidar (98):
      staging: rtl8188eu: Cleanup firmware initialization code
      staging: rtl8188eu: Cleanup and simplify MAC configuration code
      staging: rtl8188eu: Cleanup and simplify RF configuration code
      staging: rtl8188eu: Remove unused functions odm_ConfigRF_Radio[A, B]_8188E()
      staging: rtl8188eu: Remove unused function odm_ConfigRFReg_8188E()
      staging: rtl8188eu: Remove unused function odm_ConfigMAC_8188E()
      staging: rtl8188eu: Cleanup and simplify Baseband configuration code
      staging: rtl8188eu: Remove odm_RegConfig8188E.[h, c] files
      staging: rtl8188eu: Remove unused function storePwrIndexDiffRateOffset()
      staging: rtl8188eu: Hal8188EPhyCfg.h: Remove unused function declaration
      staging: rtl8188eu: Remove unused function rtw_IOL_accquire_xmit_frame()
      staging: rtl8188eu: Remove unused function rtw_IOL_cmd_boundary_handle()
      staging: rtl8188eu: Remove unused function rtw_IOL_append_WD_cmd()
      staging: rtl8188eu: Remove unused function rtw_IOL_exec_cmds_sync()
      staging: rtl8188eu: Remove unused functions rtw_IOL_append_DELAY_[US, MS]_cmd()
      staging: rtl8188eu: Remove unused function rtw_IOL_cmd_tx_pkt_buf_dump()
      staging: rtl8188eu: Remove unused function rtw_IOL_cmd_buf_dump()
      staging: rtl8188eu: Remove rtl8188e_IOL_exec_cmds_sync() and its wrapper function
      staging: rtl8188eu: Remove unused function iol_ioconfig()
      staging: rtl8188eu: rtw_iol.c: Remove unused functions
      staging: rtl8188eu: rtw_iol.h: Remove unused struct, enum and macro
      staging: rtl8188eu: Declare Efuse_GetCurrentSize() as a static function
      staging: rtl8188eu: Rework function phy_CalculateBitShift()
      staging: rtl8188eu: Remove unused wrapper function rtw_hal_read_bbreg()
      staging: rtl8188eu: Rework function PHY_QueryBBReg()
      staging: rtl8188eu: Remove unused wrapper function rtw_hal_write_bbreg()
      staging: rtl8188eu: Rework function PHY_SetBBReg()
      staging: rtl8188eu: Rework function phy_RFSerialRead()
      staging: rtl8188eu: Rework function phy_RFSerialWrite()
      staging: rtl8188eu: Rework function PHY_QueryRFReg()
      staging: rtl8188eu: Rework function rtl8188e_PHY_SetRFReg()
      staging: rtl8188eu: Rework function getTxPowerIndex88E()
      staging: rtl8188eu: Rework function phy_PowerIndexCheck88E()
      staging: rtl8188eu: Rework function _PHY_SetBWMode92C()
      staging: rtl8188eu: Rework function _PHY_SwChnl8192C()
      staging: rtl8188eu: Rework function PHY_SetTxPowerLevel8188E()
      staging: rtl8188eu: Rework function PHY_SetBWMode8188E()
      staging: rtl8188eu: Rework function PHY_SwChnl8188E()
      staging: rtl8188eu: Rename rtl8188e_phycfg.c to phy.c
      staging: rtl8188eu: Rename HalHWImg8188E_BB.c to bb_cfg.c
      staging: rtl8188eu: Rename HalHWImg8188E_RF.c to rf_cfg.c
      staging: rtl8188eu: Rename HalHWImg8188E_MAC.c to mac_cfg.c
      staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetBandwidth()
      staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetCckTxPower()
      staging: rtl8188eu: Rework function getpowerbase88e()
      staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetOFDMTxPower()
      staging: rtl8188eu: Rework function writeOFDMPowerReg88E()
      staging: rtl8188eu: Rework function get_rx_power_val_by_reg()
      staging: rtl8188eu: Remove file rtl8188e_rf.h
      staging: rtl8188eu: Rename rtl8188e_rf6052.c to rf.c
      staging: rtl8188eu: Remove unused function SetBcnCtrlReg()
      staging: rtl8188eu: Rework function HalPwrSeqCmdParsing()
      staging: rtl8188eu: Hal8188EPwrSeq.c: fix lines over 80 characters.
      staging: rtl8188eu: HalPwrSeqCmd.h: Remove unnecessary comments.
      staging: rtl8188eu: Rename Hal8188EPwrSeq.c to pwrseq.c
      staging: rtl8188eu: Rename HalPwrSeqCmd.c to pwrseqcmd.c
      staging: rtl8188eu: Rename HalPwrSeqCmd.h to pwrseqcmd.h
      staging: rtl8188eu: Hal8188EPwrSeq.h: fix lines over 80 char
      staging: rtl8188eu: Rename Hal8188EPwrSeq.h to pwrseq.h
      staging: rtl8188eu: Rename function ODM_GetRightChnlPlaceforIQK()
      staging: rtl8188eu: Rework function ODM_TxPwrTrackAdjust88E()
      staging: rtl8188eu: Rename function odm_TxPwrTrackSetPwr88E()
      staging: rtl8188eu: Rework odm_TXPowerTrackingCallback_ThermalMeter_8188E()
      staging: rtl8188eu: Rework function phy_PathA_RxIQK()
      staging: rtl8188eu: Rework function phy_PathA_IQK_8188E()
      staging: rtl8188eu: Rework function phy_PathB_IQK_8188E()
      staging: rtl8188eu: Rework function patha_fill_iqk()
      staging: rtl8188eu: Rework function pathb_fill_iqk()
      staging: rtl8188eu: Rework function _PHY_SaveADDARegisters()
      staging: rtl8188eu: Rework function _PHY_SaveMACRegisters()
      staging: rtl8188eu: Rework function reload_adda_reg()
      staging: rtl8188eu: Rework function _PHY_ReloadMACRegisters()
      staging: rtl8188eu: Rework function _PHY_PathADDAOn()
      staging: rtl8188eu: Rework function _PHY_MACSettingCalibration()
      staging: rtl8188eu: Rework function _PHY_PathAStandBy()
      staging: rtl8188eu: Rework function _PHY_PIModeSwitch()
      staging: rtl8188eu: Rework function phy_SimularityCompare_8188E()
      staging: rtl8188eu: Rework function phy_IQCalibrate_8188E()
      staging: rtl8188eu: Rework function phy_LCCalibrate_8188E()
      staging: rtl8188eu: Rework function PHY_LCCalibrate_8188E()
      staging: rtl8188eu: Rework function PHY_LCCalibrate_8188E()
      staging: rtl8188eu: HalPhyRf_8188e.c: Remove unused functions
      staging: rtl8188eu: HalPhyRf_8188e.h :Remove unused function declaration
      staging: rtl8188eu: Remove HalPhyRf_8188e.h
      staging: rtl8188eu: Remove HalPhyRf_8188e.c
      staging: rtl8188eu: Remove odm_debug.c
      staging: rtl8188eu: Remove unused header file odm_RegDefine11AC.h
      staging: rtl8188eu: Rework function odm_RX_HWAntDivInit()
      staging: rtl8188eu: Rework function odm_TRX_HWAntDivInit()
      staging: rtl8188eu: Rework function odm_FastAntTrainingInit()
      staging: rtl8188eu: Rework function ODM_AntennaDiversityInit_88E()
      staging: rtl8188eu: Rework function ODM_UpdateRxIdleAnt_88E()
      staging: rtl8188eu: Rework function odm_UpdateTxAnt_88E()
      staging: rtl8188eu: Rework function ODM_SetTxAntByTxInfo_88E()
      staging: rtl8188eu: Rework function ODM_AntselStatistics_88E()
      staging: rtl8188eu: Rework function odm_HWAntDiv()
      staging: rtl8188eu: Rework function ODM_AntennaDiversity_88E()
      staging: rtl8188eu: odm.h: Remove unused struct dyn_primary_cca

vibi sreenivasan (1):
      staging/mt29f_spinand: coding style fixes

 .../ABI/testing/sysfs-bus-iio-accel-bmc150         |    7 +
 .../ABI/testing/sysfs-bus-iio-gyro-bmg160          |    7 +
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   18 +-
 .../bindings/iio/adc/rockchip-saradc.txt           |   24 +
 .../devicetree/bindings/iio/dac/max5821.txt        |   14 +
 .../bindings/{staging => xillybus}/xillybus.txt    |    0
 .../xillybus/README => Documentation/xillybus.txt  |    0
 MAINTAINERS                                        |   28 +
 drivers/char/Kconfig                               |    2 +
 drivers/char/Makefile                              |    1 +
 drivers/{staging => char}/xillybus/Kconfig         |    0
 drivers/{staging => char}/xillybus/Makefile        |    0
 drivers/{staging => char}/xillybus/xillybus.h      |    1 -
 drivers/{staging => char}/xillybus/xillybus_core.c |  366 +-
 drivers/{staging => char}/xillybus/xillybus_of.c   |    5 +-
 drivers/{staging => char}/xillybus/xillybus_pcie.c |   16 +-
 drivers/gpu/ipu-v3/Makefile                        |    3 +-
 drivers/gpu/ipu-v3/ipu-common.c                    |  457 +-
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |  597 +++
 drivers/gpu/ipu-v3/ipu-prv.h                       |   14 +-
 drivers/iio/accel/Kconfig                          |   24 +-
 drivers/iio/accel/Makefile                         |    1 +
 drivers/iio/accel/bma180.c                         |  476 +-
 drivers/iio/accel/bmc150-accel.c                   | 1430 +++++
 drivers/iio/accel/hid-sensor-accel-3d.c            |    1 -
 drivers/iio/accel/kxcjk-1013.c                     |  873 +++-
 drivers/iio/adc/Kconfig                            |   22 +-
 drivers/iio/adc/Makefile                           |    2 +
 drivers/iio/adc/at91_adc.c                         |    2 +-
 drivers/iio/adc/exynos_adc.c                       |  138 +-
 drivers/iio/adc/lp8788_adc.c                       |    1 -
 drivers/iio/adc/rockchip_saradc.c                  |  316 ++
 drivers/iio/adc/ti-adc128s052.c                    |  179 +
 drivers/iio/adc/ti_am335x_adc.c                    |    1 -
 drivers/iio/adc/twl4030-madc.c                     |    1 -
 drivers/iio/adc/twl6030-gpadc.c                    |    1 -
 drivers/iio/adc/vf610_adc.c                        |    1 -
 drivers/iio/adc/viperboard_adc.c                   |    1 -
 drivers/iio/adc/xilinx-xadc-core.c                 |    9 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |    5 +-
 drivers/iio/dac/Kconfig                            |    8 +
 drivers/iio/dac/Makefile                           |    1 +
 drivers/iio/dac/max5821.c                          |  405 ++
 drivers/iio/gyro/Kconfig                           |   11 +
 drivers/iio/gyro/Makefile                          |    1 +
 drivers/iio/gyro/bmg160.c                          | 1228 +++++
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |    1 -
 drivers/iio/humidity/dht11.c                       |    1 -
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |    3 +-
 drivers/iio/industrialio-buffer.c                  |   63 +-
 drivers/iio/light/Kconfig                          |   10 +
 drivers/iio/light/Makefile                         |    1 +
 drivers/iio/light/al3320a.c                        |  232 +
 drivers/iio/light/hid-sensor-als.c                 |    1 -
 drivers/iio/light/hid-sensor-prox.c                |    1 -
 drivers/iio/light/lm3533-als.c                     |    1 -
 drivers/iio/magnetometer/ak8975.c                  |   10 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    8 +-
 drivers/iio/orientation/hid-sensor-incl-3d.c       |    1 -
 drivers/iio/orientation/hid-sensor-rotation.c      |    1 -
 drivers/iio/pressure/hid-sensor-press.c            |    1 -
 drivers/iio/trigger/iio-trig-interrupt.c           |    1 -
 drivers/staging/Kconfig                            |   10 -
 drivers/staging/Makefile                           |    5 -
 drivers/staging/android/binder.c                   |   19 +-
 drivers/staging/android/ion/ion.c                  |    2 +-
 drivers/staging/android/ion/ion_carveout_heap.c    |    1 -
 drivers/staging/android/ion/ion_chunk_heap.c       |    1 -
 drivers/staging/android/ion/ion_dummy_driver.c     |    4 +-
 drivers/staging/android/ion/ion_system_heap.c      |    1 -
 drivers/staging/android/sw_sync.c                  |    9 +-
 drivers/staging/android/sw_sync.h                  |    2 +-
 drivers/staging/android/sync.c                     |    5 +-
 drivers/staging/android/sync.h                     |    3 +-
 drivers/staging/android/uapi/binder.h              |    2 +-
 drivers/staging/bcm/Adapter.h                      |   47 +-
 drivers/staging/bcm/Bcmchar.c                      | 2434 ++++-----
 drivers/staging/bcm/Bcmnet.c                       |  101 +-
 drivers/staging/bcm/HandleControlPacket.c          |    4 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    7 +-
 drivers/staging/bcm/InterfaceMacros.h              |    2 +-
 drivers/staging/bcm/InterfaceMisc.h                |    2 +-
 drivers/staging/bcm/Ioctl.h                        |   26 +-
 drivers/staging/bcm/LeakyBucket.c                  |   81 +-
 drivers/staging/bcm/headers.h                      |    2 +-
 drivers/staging/bcm/sort.c                         |    4 +-
 drivers/staging/bcm/vendorspecificextn.c           |   19 +-
 drivers/staging/comedi/Kconfig                     |   75 +-
 drivers/staging/comedi/comedi.h                    |   32 +-
 drivers/staging/comedi/comedi_buf.c                |   66 +
 drivers/staging/comedi/comedi_fops.c               |    4 +-
 drivers/staging/comedi/comedi_pci.c                |   24 +
 drivers/staging/comedi/comedidev.h                 |   27 +-
 drivers/staging/comedi/drivers.c                   |  137 +
 drivers/staging/comedi/drivers/8253.h              |    8 +-
 drivers/staging/comedi/drivers/8255.c              |  198 +-
 drivers/staging/comedi/drivers/8255.h              |   31 +-
 drivers/staging/comedi/drivers/8255_pci.c          |   38 +-
 drivers/staging/comedi/drivers/Makefile            |    6 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   20 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    3 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |   12 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    2 -
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |  453 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  181 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  383 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |   12 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c    |    4 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  133 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |   48 +-
 drivers/staging/comedi/drivers/addi_apci_2200.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |   54 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |   23 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   37 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |   40 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci8164.c       |    2 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |   32 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       | 2106 ++++----
 drivers/staging/comedi/drivers/adv_pci1710.c       |   22 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |    2 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   23 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   52 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |  121 +-
 drivers/staging/comedi/drivers/amplc_dio200.h      |   34 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |  478 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |  167 +-
 .../staging/comedi/drivers/amplc_pc236_common.c    |   14 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  755 +--
 drivers/staging/comedi/drivers/amplc_pci230.c      | 1224 ++---
 drivers/staging/comedi/drivers/amplc_pci236.c      |    9 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |   44 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   76 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  221 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   29 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   78 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |   62 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |  132 -
 drivers/staging/comedi/drivers/comedi_fc.h         |   40 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    8 +-
 drivers/staging/comedi/drivers/comedi_test.c       |   10 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    2 +-
 drivers/staging/comedi/drivers/dac02.c             |   33 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   76 +-
 drivers/staging/comedi/drivers/das08.c             |   85 +-
 drivers/staging/comedi/drivers/das08.h             |    1 -
 drivers/staging/comedi/drivers/das08_isa.c         |    2 +-
 drivers/staging/comedi/drivers/das08_pci.c         |    2 +-
 drivers/staging/comedi/drivers/das16.c             |   34 +-
 drivers/staging/comedi/drivers/das16m1.c           |   10 +-
 drivers/staging/comedi/drivers/das1800.c           |   28 +-
 drivers/staging/comedi/drivers/das6402.c           |   16 +-
 drivers/staging/comedi/drivers/das800.c            |   10 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   69 +-
 drivers/staging/comedi/drivers/dt2801.c            |   38 +-
 drivers/staging/comedi/drivers/dt2811.c            |   48 +-
 drivers/staging/comedi/drivers/dt282x.c            |   57 +-
 drivers/staging/comedi/drivers/dt3000.c            |   70 +-
 drivers/staging/comedi/drivers/dt9812.c            |   27 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |    2 +-
 drivers/staging/comedi/drivers/fl512.c             |   35 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   51 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   67 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   39 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    2 +-
 drivers/staging/comedi/drivers/ke_counter.c        |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |  101 +-
 drivers/staging/comedi/drivers/me_daq.c            |   36 +-
 drivers/staging/comedi/drivers/mf6x4.c             |   46 +-
 drivers/staging/comedi/drivers/multiq3.c           |   46 +-
 drivers/staging/comedi/drivers/ni_6527.c           |   11 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |   15 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    8 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   66 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   24 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |   37 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   72 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    2 +-
 drivers/staging/comedi/drivers/ni_labpc.c          | 1378 +----
 drivers/staging/comedi/drivers/ni_labpc_common.c   | 1387 +++++
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |   11 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |  114 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   17 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    2 +-
 drivers/staging/comedi/drivers/ni_stc.h            |    1 -
 drivers/staging/comedi/drivers/ni_tiocmd.c         |    7 +-
 drivers/staging/comedi/drivers/ni_usb6501.c        |  621 +++
 drivers/staging/comedi/drivers/pcl711.c            |   42 +-
 drivers/staging/comedi/drivers/pcl724.c            |   12 +-
 drivers/staging/comedi/drivers/pcl726.c            |   43 +-
 drivers/staging/comedi/drivers/pcl730.c            |    2 +-
 drivers/staging/comedi/drivers/pcl812.c            |   46 +-
 drivers/staging/comedi/drivers/pcl816.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |   41 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   27 +-
 drivers/staging/comedi/drivers/pcmad.c             |    2 +-
 drivers/staging/comedi/drivers/pcmda12.c           |   16 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   72 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   58 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   11 +-
 drivers/staging/comedi/drivers/rtd520.c            |   66 +-
 drivers/staging/comedi/drivers/rti800.c            |   34 +-
 drivers/staging/comedi/drivers/rti802.c            |   29 +-
 drivers/staging/comedi/drivers/s526.c              |   43 +-
 drivers/staging/comedi/drivers/s626.c              |  136 +-
 drivers/staging/comedi/drivers/skel.c              |  726 ---
 drivers/staging/comedi/drivers/usbdux.c            |   53 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   54 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    2 +-
 drivers/staging/dgap/dgap.c                        |  650 +--
 drivers/staging/dgap/dgap.h                        |   11 -
 drivers/staging/dgnc/Makefile                      |    3 +-
 drivers/staging/dgnc/TODO                          |    7 -
 drivers/staging/dgnc/dgnc_cls.c                    |  223 +-
 drivers/staging/dgnc/dgnc_driver.c                 |  359 +-
 drivers/staging/dgnc/dgnc_driver.h                 |  115 +-
 drivers/staging/dgnc/dgnc_mgmt.c                   |   55 +-
 drivers/staging/dgnc/dgnc_neo.c                    |  329 +-
 drivers/staging/dgnc/dgnc_sysfs.c                  |   44 +-
 drivers/staging/dgnc/dgnc_tty.c                    |  622 +--
 drivers/staging/dgnc/dgnc_tty.h                    |    2 +-
 drivers/staging/dgnc/dgnc_types.h                  |    3 -
 drivers/staging/dgnc/dgnc_utils.c                  |   70 +
 drivers/staging/dgnc/dgnc_utils.h                  |    7 +
 drivers/staging/dgnc/digi.h                        |   20 +-
 drivers/staging/dgnc/dpacompat.h                   |    2 +-
 drivers/staging/emxx_udc/emxx_udc.c                |  107 +-
 drivers/staging/emxx_udc/emxx_udc.h                |    4 -
 drivers/staging/et131x/Kconfig                     |   10 -
 drivers/staging/et131x/Makefile                    |    5 -
 drivers/staging/et131x/README                      |   20 -
 drivers/staging/et131x/et131x.c                    | 4735 -----------------
 drivers/staging/et131x/et131x.h                    | 1670 ------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   27 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   19 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |    2 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   10 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   85 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    4 +-
 drivers/staging/gdm724x/gdm_mux.c                  |    1 +
 drivers/staging/gdm724x/gdm_usb.c                  |    7 +-
 drivers/staging/gdm72xx/netlink_k.c                |   12 +-
 drivers/staging/goldfish/goldfish_audio.c          |   24 +-
 drivers/staging/goldfish/goldfish_nand.c           |   42 +-
 drivers/staging/gs_fpgaboot/README                 |    3 +-
 drivers/staging/gs_fpgaboot/io.c                   |  169 -
 drivers/staging/iio/accel/adis16201_core.c         |    5 +-
 drivers/staging/iio/accel/adis16203_core.c         |    2 +
 drivers/staging/iio/accel/adis16204_core.c         |    1 +
 drivers/staging/iio/accel/adis16209_core.c         |    1 +
 drivers/staging/iio/accel/adis16220_core.c         |   17 +-
 drivers/staging/iio/accel/adis16240_core.c         |    4 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |    4 +
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    5 +-
 drivers/staging/iio/accel/sca3000_core.c           |    4 +-
 drivers/staging/iio/accel/sca3000_ring.c           |    2 +-
 drivers/staging/iio/adc/Kconfig                    |    8 +
 drivers/staging/iio/adc/ad7192.c                   |    2 +-
 drivers/staging/iio/adc/ad7606_core.c              |    2 +-
 drivers/staging/iio/adc/ad7816.c                   |   14 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   24 +-
 drivers/staging/iio/addac/adt7316.c                |   58 +-
 drivers/staging/iio/cdc/ad7150.c                   |   10 +-
 drivers/staging/iio/frequency/Kconfig              |   35 -
 drivers/staging/iio/frequency/Makefile             |    5 -
 drivers/staging/iio/frequency/ad5930.c             |  140 -
 drivers/staging/iio/frequency/ad9834.c             |    1 +
 drivers/staging/iio/frequency/ad9850.c             |  120 -
 drivers/staging/iio/frequency/ad9852.c             |  253 -
 drivers/staging/iio/frequency/ad9910.c             |  371 --
 drivers/staging/iio/frequency/ad9951.c             |  209 -
 drivers/staging/iio/frequency/dds.h                |   18 +-
 drivers/staging/iio/gyro/adis16060_core.c          |    1 +
 drivers/staging/iio/iio_dummy_evgen.c              |    1 +
 drivers/staging/iio/iio_dummy_evgen.h              |    5 +
 drivers/staging/iio/iio_simple_dummy.h             |    4 +
 drivers/staging/iio/iio_simple_dummy_buffer.c      |    1 +
 drivers/staging/iio/iio_simple_dummy_events.c      |    1 +
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   11 +-
 drivers/staging/iio/light/isl29018.c               |  217 +-
 drivers/staging/iio/light/tsl2583.c                |    1 +
 drivers/staging/iio/light/tsl2x7x.h                |    4 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |    2 +
 drivers/staging/iio/magnetometer/hmc5843_core.c    |    6 +-
 drivers/staging/iio/meter/ade7753.c                |    7 +-
 drivers/staging/iio/meter/ade7754.c                |    2 +
 drivers/staging/iio/meter/ade7758_core.c           |    4 +
 drivers/staging/iio/meter/ade7759.c                |    3 +
 drivers/staging/iio/meter/ade7854.h                |   16 +-
 drivers/staging/iio/meter/meter.h                  |   48 +-
 drivers/staging/iio/resolver/Kconfig               |    9 +
 drivers/staging/iio/resolver/ad2s1210.c            |    8 +-
 drivers/staging/iio/ring_hw.h                      |    5 +
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |    3 +
 drivers/staging/imx-drm/imx-drm-core.c             |   38 +-
 drivers/staging/imx-drm/imx-hdmi.c                 |    3 +-
 drivers/staging/imx-drm/imx-tve.c                  |    7 +-
 drivers/staging/imx-drm/ipuv3-crtc.c               |    9 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |   45 +-
 drivers/staging/imx-drm/parallel-display.c         |    5 +-
 drivers/staging/line6/midibuf.c                    |   11 +-
 drivers/staging/lustre/README.txt                  |   87 +
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    4 +-
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |    4 +-
 .../lustre/include/linux/libcfs/libcfs_crypto.h    |    6 +-
 .../lustre/include/linux/libcfs/libcfs_debug.h     |    8 +-
 .../lustre/include/linux/libcfs/libcfs_fail.h      |    7 +-
 .../lustre/include/linux/libcfs/libcfs_heap.h      |  200 -
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    3 +-
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 .../lustre/include/linux/libcfs/libcfs_private.h   |    3 +-
 .../lustre/include/linux/libcfs/libcfs_time.h      |    2 +-
 .../lustre/include/linux/libcfs/linux/libcfs.h     |    7 +-
 .../lustre/include/linux/libcfs/linux/linux-time.h |    5 +-
 .../include/linux/libcfs/linux/portals_compat25.h  |   81 -
 .../staging/lustre/include/linux/libcfs/lucache.h  |  162 -
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |   16 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    4 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   66 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    8 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |   24 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   45 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    1 -
 .../lustre/lnet/klnds/socklnd/socklnd_modparams.c  |   10 +-
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |   15 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |    8 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |  254 +-
 drivers/staging/lustre/lnet/lnet/config.c          |   59 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |   17 +-
 drivers/staging/lustre/lnet/lnet/lib-md.c          |   35 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |    4 +-
 drivers/staging/lustre/lnet/lnet/router.c          |    2 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   13 +-
 drivers/staging/lustre/lnet/selftest/brw_test.c    |   10 +-
 drivers/staging/lustre/lnet/selftest/console.c     |    4 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |    5 +-
 drivers/staging/lustre/lustre/Makefile             |    2 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |   24 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |    5 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |   17 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    2 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |   25 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |    1 -
 drivers/staging/lustre/lustre/include/cl_object.h  |    6 +-
 .../staging/lustre/lustre/include/interval_tree.h  |    2 +-
 drivers/staging/lustre/lustre/include/lclient.h    |   16 +-
 .../lustre/lustre/include/linux/lprocfs_status.h   |   57 -
 .../lustre/lustre/include/linux/lustre_acl.h       |   66 -
 .../lustre/lustre/include/linux/lustre_common.h    |   22 -
 .../lustre/lustre/include/linux/lustre_compat25.h  |   19 +-
 .../lustre/lustre/include/linux/lustre_dlm.h       |   46 -
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |  171 -
 .../lustre/lustre/include/linux/lustre_handles.h   |   52 -
 .../lustre/lustre/include/linux/lustre_lib.h       |   85 -
 .../lustre/lustre/include/linux/lustre_lite.h      |    1 -
 .../lustre/lustre/include/linux/lustre_log.h       |   57 -
 .../lustre/lustre/include/linux/lustre_net.h       |   49 -
 .../lustre/lustre/include/linux/lustre_quota.h     |   46 -
 drivers/staging/lustre/lustre/include/linux/lvfs.h |  134 -
 .../lustre/lustre/include/linux/lvfs_linux.h       |   61 -
 drivers/staging/lustre/lustre/include/linux/obd.h  |    2 +-
 .../lustre/lustre/include/linux/obd_class.h        |   58 -
 .../lustre/lustre/include/linux/obd_support.h      |   63 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   15 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |   10 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |  176 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   32 +-
 drivers/staging/lustre/lustre/include/lustre_acl.h |    9 +-
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +-
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    4 +-
 .../staging/lustre/lustre/include/lustre_export.h  |    4 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    2 +-
 drivers/staging/lustre/lustre/include/lustre_fld.h |    5 +-
 .../staging/lustre/lustre/include/lustre_fsfilt.h  |   48 -
 .../staging/lustre/lustre/include/lustre_handles.h |   10 +-
 .../staging/lustre/lustre/include/lustre_idmap.h   |  104 -
 .../staging/lustre/lustre/include/lustre_import.h  |   13 +-
 .../lustre/include/{linux => }/lustre_intent.h     |    0
 drivers/staging/lustre/lustre/include/lustre_lib.h |   27 +-
 .../staging/lustre/lustre/include/lustre_linkea.h  |   57 -
 .../staging/lustre/lustre/include/lustre_lite.h    |    3 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   26 +-
 drivers/staging/lustre/lustre/include/lustre_mdc.h |    2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |  289 +-
 .../staging/lustre/lustre/include/lustre_quota.h   |    4 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |    7 +-
 drivers/staging/lustre/lustre/include/lustre_ver.h |    4 +-
 drivers/staging/lustre/lustre/include/lvfs.h       |   57 -
 drivers/staging/lustre/lustre/include/md_object.h  |  903 ----
 drivers/staging/lustre/lustre/include/obd.h        |  177 +-
 drivers/staging/lustre/lustre/include/obd_cksum.h  |    6 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |  343 +-
 drivers/staging/lustre/lustre/include/obd_ost.h    |  100 -
 .../staging/lustre/lustre/include/obd_support.h    |   19 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   86 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |  108 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   34 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   16 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |  112 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   21 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |   19 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |   20 +-
 drivers/staging/lustre/lustre/libcfs/heap.c        |  475 --
 .../lustre/lustre/libcfs/linux/linux-debug.c       |    7 +-
 .../lustre/lustre/libcfs/linux/linux-module.c      |   10 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   20 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        |   17 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |   10 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |   13 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   12 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.h   |   10 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |  449 --
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    4 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |    4 +-
 drivers/staging/lustre/lustre/llite/dir.c          |  223 +-
 drivers/staging/lustre/lustre/llite/file.c         |  377 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |    2 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |   18 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   22 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  164 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   26 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |   16 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |    6 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   58 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   59 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   58 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |    8 +-
 drivers/staging/lustre/lustre/llite/rw.c           |   22 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |    4 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |   85 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    3 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |   13 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |    4 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   19 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   53 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |   26 +-
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |    2 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   16 +-
 drivers/staging/lustre/lustre/lmv/lmv_internal.h   |   14 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |  111 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    8 +-
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |    4 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |    8 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |   71 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |    8 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |   24 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   41 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |  721 +--
 drivers/staging/lustre/lustre/lov/lov_object.c     |   13 +-
 drivers/staging/lustre/lustre/lov/lov_offset.c     |   29 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |  199 +-
 drivers/staging/lustre/lustre/lov/lov_page.c       |   14 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |   40 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |  882 +---
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |    2 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    4 -
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |  139 -
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |  293 --
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   10 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    4 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |   48 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   77 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   12 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |  566 +-
 drivers/staging/lustre/lustre/mgc/libmgc.c         |  158 -
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |  360 +-
 drivers/staging/lustre/lustre/obdclass/Makefile    |   15 +-
 drivers/staging/lustre/lustre/obdclass/acl.c       |   27 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |   23 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   11 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    2 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  131 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |    1 -
 drivers/staging/lustre/lustre/obdclass/dt_object.c |   56 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |   49 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |  477 --
 drivers/staging/lustre/lustre/obdclass/linkea.c    |  194 -
 .../lustre/lustre/obdclass/linux/linux-module.c    |   10 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |    8 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |   89 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |   20 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |  418 --
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |  847 ---
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |   25 -
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  | 1290 -----
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |   52 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c | 1072 ----
 .../staging/lustre/lustre/obdclass/local_storage.c |  894 ----
 .../staging/lustre/lustre/obdclass/local_storage.h |   91 -
 .../lvfs_lib.c => obdclass/lprocfs_counters.c}     |   63 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  147 +-
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |  107 -
 .../lustre/lustre/obdclass/lustre_handles.c        |    2 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |  199 -
 drivers/staging/lustre/lustre/obdclass/mea.c       |  112 -
 .../staging/lustre/lustre/obdclass/obd_config.c    |  144 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   64 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |   78 +-
 .../staging/lustre/lustre/obdclass/statfs_pack.c   |    2 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |  671 ---
 .../staging/lustre/lustre/obdecho/echo_client.c    | 1185 +----
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |    4 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    2 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    3 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h   |    8 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    5 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   12 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |  635 +--
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   56 +-
 drivers/staging/lustre/lustre/ptlrpc/connection.c  |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |    9 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   72 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |   80 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |    2 -
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   61 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   27 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |   52 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c     |   40 -
 drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c    |    2 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |    7 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |   16 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   26 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |    9 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   30 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |  333 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    |    3 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   54 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   48 -
 drivers/staging/media/cxd2099/cxd2099.c            |    3 +
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    2 -
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |   14 +-
 drivers/staging/media/lirc/lirc_bt829.c            |    9 +-
 drivers/staging/media/lirc/lirc_imon.c             |   17 +-
 drivers/staging/media/lirc/lirc_parallel.c         |    5 +-
 drivers/staging/media/lirc/lirc_sasem.c            |    5 +-
 drivers/staging/media/lirc/lirc_serial.c           |   13 +-
 drivers/staging/media/lirc/lirc_sir.c              |    1 +
 drivers/staging/media/lirc/lirc_zilog.c            |    9 +-
 drivers/staging/media/omap24xx/omap24xxcam-dma.c   |   39 +-
 drivers/staging/media/omap24xx/omap24xxcam.c       |   10 +-
 drivers/staging/media/omap24xx/tcm825x.c           |    1 +
 drivers/staging/media/omap4iss/iss_csi2.c          |    6 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |    4 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |    3 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |    3 +-
 drivers/staging/media/omap4iss/iss_video.c         |    1 +
 drivers/staging/mt29f_spinand/mt29f_spinand.c      |   26 +-
 drivers/staging/netlogic/TODO                      |    1 -
 drivers/staging/netlogic/platform_net.c            |  212 +-
 drivers/staging/netlogic/platform_net.h            |    7 +-
 drivers/staging/netlogic/xlr_net.c                 |  299 +-
 drivers/staging/netlogic/xlr_net.h                 |    8 +-
 drivers/staging/nokia_h4p/Kconfig                  |    9 -
 drivers/staging/nokia_h4p/Makefile                 |    6 -
 drivers/staging/nokia_h4p/TODO                     |  132 -
 drivers/staging/nokia_h4p/hci_h4p.h                |  222 -
 drivers/staging/nokia_h4p/nokia_core.c             | 1207 -----
 drivers/staging/nokia_h4p/nokia_fw-bcm.c           |  149 -
 drivers/staging/nokia_h4p/nokia_fw-csr.c           |  149 -
 drivers/staging/nokia_h4p/nokia_fw-ti1273.c        |  110 -
 drivers/staging/nokia_h4p/nokia_fw.c               |  208 -
 drivers/staging/nokia_h4p/nokia_uart.c             |  199 -
 drivers/staging/octeon-usb/octeon-hcd.c            |   63 +-
 drivers/staging/octeon/ethernet-rgmii.c            |   14 +-
 drivers/staging/octeon/ethernet-rx.c               |    3 +-
 drivers/staging/octeon/ethernet-sgmii.c            |    1 +
 drivers/staging/octeon/ethernet-util.h             |    6 +-
 drivers/staging/octeon/ethernet-xaui.c             |    1 +
 drivers/staging/octeon/ethernet.c                  |   12 +-
 drivers/staging/ozwpan/ozcdev.c                    |   36 +-
 drivers/staging/ozwpan/ozeltbuf.c                  |  130 +-
 drivers/staging/ozwpan/ozeltbuf.h                  |    7 +-
 drivers/staging/ozwpan/ozhcd.c                     |  178 +-
 drivers/staging/ozwpan/ozmain.c                    |    4 +-
 drivers/staging/ozwpan/ozpd.c                      |  321 +-
 drivers/staging/ozwpan/ozpd.h                      |    9 +-
 drivers/staging/ozwpan/ozproto.c                   |   41 +-
 drivers/staging/ozwpan/ozproto.h                   |   27 +-
 drivers/staging/ozwpan/ozprotocol.h                |    2 -
 drivers/staging/ozwpan/ozusbsvc.c                  |   32 +-
 drivers/staging/ozwpan/ozusbsvc1.c                 |   16 +-
 drivers/staging/rtl8188eu/Makefile                 |   18 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |    5 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |    2 +-
 drivers/staging/rtl8188eu/core/rtw_iol.c           |  164 -
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c  |  231 -
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |  269 -
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     | 1467 ------
 .../rtl8188eu/hal/{HalHWImg8188E_BB.c => bb_cfg.c} |  474 +-
 drivers/staging/rtl8188eu/hal/fw.c                 |  236 +
 drivers/staging/rtl8188eu/hal/hal_intf.c           |   26 -
 drivers/staging/rtl8188eu/hal/mac_cfg.c            |  134 +
 drivers/staging/rtl8188eu/hal/odm.c                |   82 +-
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |   38 +-
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |  394 +-
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |  138 -
 drivers/staging/rtl8188eu/hal/odm_debug.c          |   32 -
 drivers/staging/rtl8188eu/hal/phy.c                | 1570 ++++++
 .../rtl8188eu/hal/{Hal8188EPwrSeq.c => pwrseq.c}   |   48 +-
 .../rtl8188eu/hal/{HalPwrSeqCmd.c => pwrseqcmd.c}  |   66 +-
 drivers/staging/rtl8188eu/hal/rf.c                 |  318 ++
 drivers/staging/rtl8188eu/hal/rf_cfg.c             |  320 ++
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |  401 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |  936 ----
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |  527 --
 drivers/staging/rtl8188eu/hal/rtl8188e_xmit.c      |    1 +
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |   25 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |    3 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   79 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |   37 -
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |  176 -
 .../staging/rtl8188eu/include/HalHWImg8188E_BB.h   |   44 -
 .../staging/rtl8188eu/include/HalHWImg8188E_MAC.h  |   30 -
 .../staging/rtl8188eu/include/HalHWImg8188E_RF.h   |   30 -
 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h |   61 -
 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h   |  128 -
 drivers/staging/rtl8188eu/include/drv_types.h      |    7 -
 .../{rtl8821ae/rc.h => rtl8188eu/include/fw.h}     |   42 +-
 drivers/staging/rtl8188eu/include/hal_intf.h       |   15 -
 drivers/staging/rtl8188eu/include/odm.h            |    9 -
 drivers/staging/rtl8188eu/include/odm_HWConfig.h   |    6 -
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h   |   16 +-
 .../staging/rtl8188eu/include/odm_RegConfig8188E.h |   43 -
 .../staging/rtl8188eu/include/odm_RegDefine11AC.h  |   54 -
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    7 -
 drivers/staging/rtl8188eu/include/phy.h            |   30 +
 drivers/staging/rtl8188eu/include/pwrseq.h         |  341 ++
 drivers/staging/rtl8188eu/include/pwrseqcmd.h      |   90 +
 drivers/staging/rtl8188eu/include/rf.h             |   11 +
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |   52 +-
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h    |   36 -
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |    1 -
 drivers/staging/rtl8188eu/include/rtw_iol.h        |   54 -
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |    7 +-
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |    9 +-
 drivers/staging/rtl8192e/dot11d.c                  |    1 +
 drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c |   12 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c  |    8 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |   16 +
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |    1 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |   18 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c        |    4 +
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   30 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         |   19 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.c         |    8 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |    8 +
 drivers/staging/rtl8192e/rtl819x_BAProc.c          |   11 +-
 drivers/staging/rtl8192e/rtl819x_HTProc.c          |   17 +-
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |   11 +-
 drivers/staging/rtl8192e/rtllib.h                  |    5 +-
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c       |   13 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |    5 +
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |    8 +-
 drivers/staging/rtl8192e/rtllib_module.c           |    1 +
 drivers/staging/rtl8192e/rtllib_rx.c               |   20 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   39 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |    3 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |    7 +-
 drivers/staging/rtl8192e/rtllib_wx.c               |    5 +
 drivers/staging/rtl8192ee/Kconfig                  |   14 -
 drivers/staging/rtl8192ee/Makefile                 |   40 -
 drivers/staging/rtl8192ee/TODO                     |   12 -
 drivers/staging/rtl8192ee/base.c                   | 1851 -------
 drivers/staging/rtl8192ee/base.h                   |  163 -
 .../staging/rtl8192ee/btcoexist/halbt_precomp.h    |   50 -
 .../staging/rtl8192ee/btcoexist/halbtc8192e2ant.c  | 4110 ---------------
 .../staging/rtl8192ee/btcoexist/halbtc8192e2ant.h  |  161 -
 .../staging/rtl8192ee/btcoexist/halbtc8723b1ant.c  | 3146 -----------
 .../staging/rtl8192ee/btcoexist/halbtc8723b1ant.h  |  160 -
 .../staging/rtl8192ee/btcoexist/halbtc8723b2ant.c  | 3929 --------------
 .../staging/rtl8192ee/btcoexist/halbtc8723b2ant.h  |  145 -
 .../staging/rtl8192ee/btcoexist/halbtc8821a1ant.c  | 2780 ----------
 .../staging/rtl8192ee/btcoexist/halbtc8821a1ant.h  |  158 -
 .../staging/rtl8192ee/btcoexist/halbtc8821a2ant.c  | 3438 ------------
 .../staging/rtl8192ee/btcoexist/halbtc8821a2ant.h  |  179 -
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c | 1297 -----
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h |  537 --
 drivers/staging/rtl8192ee/btcoexist/rtl_btc.c      |  194 -
 drivers/staging/rtl8192ee/btcoexist/rtl_btc.h      |   62 -
 drivers/staging/rtl8192ee/cam.c                    |  337 --
 drivers/staging/rtl8192ee/cam.h                    |   52 -
 drivers/staging/rtl8192ee/compat.h                 |   70 -
 drivers/staging/rtl8192ee/core.c                   | 1600 ------
 drivers/staging/rtl8192ee/core.h                   |   39 -
 drivers/staging/rtl8192ee/debug.c                  |  978 ----
 drivers/staging/rtl8192ee/debug.h                  |  221 -
 drivers/staging/rtl8192ee/efuse.c                  | 1233 -----
 drivers/staging/rtl8192ee/efuse.h                  |  127 -
 drivers/staging/rtl8192ee/pci.c                    | 2384 ---------
 drivers/staging/rtl8192ee/pci.h                    |  342 --
 drivers/staging/rtl8192ee/ps.c                     |  983 ----
 drivers/staging/rtl8192ee/ps.h                     |   52 -
 drivers/staging/rtl8192ee/rc.c                     |  288 -
 drivers/staging/rtl8192ee/rc.h                     |   47 -
 drivers/staging/rtl8192ee/regd.c                   |  448 --
 drivers/staging/rtl8192ee/regd.h                   |   63 -
 drivers/staging/rtl8192ee/rtl8192ee/def.h          |  106 -
 drivers/staging/rtl8192ee/rtl8192ee/dm.c           | 1258 -----
 drivers/staging/rtl8192ee/rtl8192ee/dm.h           |  343 --
 drivers/staging/rtl8192ee/rtl8192ee/fw.c           |  945 ----
 drivers/staging/rtl8192ee/rtl8192ee/fw.h           |  213 -
 drivers/staging/rtl8192ee/rtl8192ee/hw.c           | 2544 ---------
 drivers/staging/rtl8192ee/rtl8192ee/hw.h           |   67 -
 drivers/staging/rtl8192ee/rtl8192ee/led.c          |  134 -
 drivers/staging/rtl8192ee/rtl8192ee/led.h          |   37 -
 drivers/staging/rtl8192ee/rtl8192ee/phy.c          | 3282 ------------
 drivers/staging/rtl8192ee/rtl8192ee/phy.h          |  154 -
 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.c       |  108 -
 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.h       |  355 --
 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c    |  139 -
 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.h    |   69 -
 drivers/staging/rtl8192ee/rtl8192ee/reg.h          | 2240 --------
 drivers/staging/rtl8192ee/rtl8192ee/rf.c           |  150 -
 drivers/staging/rtl8192ee/rtl8192ee/rf.h           |   39 -
 drivers/staging/rtl8192ee/rtl8192ee/sw.c           |  428 --
 drivers/staging/rtl8192ee/rtl8192ee/sw.h           |   39 -
 drivers/staging/rtl8192ee/rtl8192ee/table.c        |  882 ----
 drivers/staging/rtl8192ee/rtl8192ee/table.h        |   48 -
 drivers/staging/rtl8192ee/rtl8192ee/trx.c          | 1286 -----
 drivers/staging/rtl8192ee/rtl8192ee/trx.h          |  877 ----
 drivers/staging/rtl8192ee/stats.c                  |  290 -
 drivers/staging/rtl8192ee/stats.h                  |   43 -
 drivers/staging/rtl8192ee/wifi.h                   | 2644 ----------
 drivers/staging/rtl8192u/Makefile                  |    3 -
 drivers/staging/rtl8192u/copying                   |   10 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   41 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   22 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   99 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |    8 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |   12 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |   37 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h    |    2 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |    4 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h   |    8 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |   52 +-
 drivers/staging/rtl8192u/r8192U_core.c             | 1067 +---
 drivers/staging/rtl8192u/r8192U_dm.c               |   24 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |    5 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   37 +-
 drivers/staging/rtl8192u/r819xU_phyreg.h           |  189 +-
 drivers/staging/rtl8712/hal_init.c                 |    7 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              |    4 +-
 drivers/staging/rtl8712/rtl8712_io.c               |   15 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.c             |    3 +
 drivers/staging/rtl8712/rtl871x_io.c               |    4 +-
 drivers/staging/rtl8712/rtl871x_io.h               |    3 +-
 drivers/staging/rtl8712/rtl871x_ioctl.h            |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   16 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |    2 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |   16 +-
 drivers/staging/rtl8712/rtl871x_mp.h               |    2 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |    2 +
 drivers/staging/rtl8712/rtl871x_recv.c             |    6 +-
 drivers/staging/rtl8712/rtl871x_security.c         |    1 -
 drivers/staging/rtl8712/rtl871x_xmit.c             |   10 +-
 drivers/staging/rtl8712/usb_intf.c                 |    7 +-
 drivers/staging/rtl8712/usb_ops_linux.c            |    9 +-
 drivers/staging/rtl8723au/core/rtw_ap.c            |   48 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c           |   14 +-
 drivers/staging/rtl8723au/core/rtw_efuse.c         |   36 +-
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |    4 +-
 drivers/staging/rtl8723au/core/rtw_led.c           |    2 +-
 drivers/staging/rtl8723au/core/rtw_mlme.c          |   77 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      |   40 +-
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |    8 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |   16 +-
 drivers/staging/rtl8723au/core/rtw_security.c      |   14 +-
 drivers/staging/rtl8723au/core/rtw_sreset.c        |    3 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |    4 +-
 drivers/staging/rtl8723au/core/rtw_xmit.c          |    4 +-
 drivers/staging/rtl8723au/hal/hal_com.c            |   12 +-
 drivers/staging/rtl8723au/hal/usb_halinit.c        |   26 +-
 drivers/staging/rtl8723au/include/ieee80211.h      |   16 +-
 drivers/staging/rtl8723au/include/odm.h            |    2 +-
 drivers/staging/rtl8723au/include/odm_HWConfig.h   |    4 +-
 drivers/staging/rtl8723au/include/osdep_service.h  |    4 +-
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |    4 -
 drivers/staging/rtl8723au/include/rtl8723a_rf.h    |    4 +-
 drivers/staging/rtl8723au/include/rtl8723a_spec.h  |    6 +-
 drivers/staging/rtl8723au/include/rtw_cmd.h        |   12 +-
 drivers/staging/rtl8723au/include/rtw_eeprom.h     |    2 +-
 drivers/staging/rtl8723au/include/rtw_efuse.h      |    5 +-
 drivers/staging/rtl8723au/include/rtw_io.h         |   20 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |   10 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  |    6 +-
 drivers/staging/rtl8821ae/Kconfig                  |   10 -
 drivers/staging/rtl8821ae/Makefile                 |   35 -
 drivers/staging/rtl8821ae/TODO                     |   10 -
 drivers/staging/rtl8821ae/base.c                   | 1831 -------
 drivers/staging/rtl8821ae/base.h                   |  159 -
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  | 3976 --------------
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h  |  205 -
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.c   | 1614 ------
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.h   |  176 -
 .../staging/rtl8821ae/btcoexist/halbt_precomp.h    |   99 -
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.c  | 3891 --------------
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.h  |  226 -
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  | 4118 ---------------
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |  160 -
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.c  | 3780 -------------
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.h  |  179 -
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  | 3892 --------------
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.h  |  175 -
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  | 4200 ---------------
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.h  |  145 -
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c | 1130 ----
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |  549 --
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c      |  236 -
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h      |   66 -
 drivers/staging/rtl8821ae/cam.c                    |  345 --
 drivers/staging/rtl8821ae/cam.h                    |   56 -
 drivers/staging/rtl8821ae/compat.h                 |   68 -
 drivers/staging/rtl8821ae/core.c                   | 1314 -----
 drivers/staging/rtl8821ae/core.h                   |   43 -
 drivers/staging/rtl8821ae/debug.c                  |  983 ----
 drivers/staging/rtl8821ae/debug.h                  |  227 -
 drivers/staging/rtl8821ae/efuse.c                  | 1283 -----
 drivers/staging/rtl8821ae/efuse.h                  |  130 -
 drivers/staging/rtl8821ae/pci.c                    | 2417 ---------
 drivers/staging/rtl8821ae/pci.h                    |  348 --
 drivers/staging/rtl8821ae/ps.c                     | 1001 ----
 drivers/staging/rtl8821ae/ps.h                     |   55 -
 drivers/staging/rtl8821ae/rc.c                     |  290 -
 drivers/staging/rtl8821ae/regd.c                   |  451 --
 drivers/staging/rtl8821ae/regd.h                   |   67 -
 drivers/staging/rtl8821ae/rtl8821ae/btc.h          |   87 -
 drivers/staging/rtl8821ae/rtl8821ae/def.h          |  442 --
 drivers/staging/rtl8821ae/rtl8821ae/dm.c           | 3045 -----------
 drivers/staging/rtl8821ae/rtl8821ae/dm.h           |  426 --
 drivers/staging/rtl8821ae/rtl8821ae/fw.c           | 1349 -----
 drivers/staging/rtl8821ae/rtl8821ae/fw.h           |  321 --
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c   |  519 --
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h   |  169 -
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      | 2054 --------
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h      |  160 -
 drivers/staging/rtl8821ae/rtl8821ae/hw.c           | 3347 ------------
 drivers/staging/rtl8821ae/rtl8821ae/hw.h           |   72 -
 drivers/staging/rtl8821ae/rtl8821ae/led.c          |  239 -
 drivers/staging/rtl8821ae/rtl8821ae/led.h          |   40 -
 drivers/staging/rtl8821ae/rtl8821ae/phy.c          | 5525 --------------------
 drivers/staging/rtl8821ae/rtl8821ae/phy.h          |  258 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c       |  199 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h       |  413 --
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c    |  140 -
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h    |   71 -
 drivers/staging/rtl8821ae/rtl8821ae/reg.h          | 2428 ---------
 drivers/staging/rtl8821ae/rtl8821ae/rf.c           |  464 --
 drivers/staging/rtl8821ae/rtl8821ae/rf.h           |   46 -
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |  478 --
 drivers/staging/rtl8821ae/rtl8821ae/sw.h           |   39 -
 drivers/staging/rtl8821ae/rtl8821ae/table.c        | 4002 --------------
 drivers/staging/rtl8821ae/rtl8821ae/table.h        |   62 -
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          | 1005 ----
 drivers/staging/rtl8821ae/rtl8821ae/trx.h          |  630 ---
 drivers/staging/rtl8821ae/stats.c                  |  281 -
 drivers/staging/rtl8821ae/stats.h                  |   46 -
 drivers/staging/rtl8821ae/wifi.h                   | 2534 ---------
 drivers/staging/rts5208/Kconfig                    |    7 -
 drivers/staging/rts5208/general.c                  |    1 +
 drivers/staging/rts5208/ms.c                       |   12 +-
 drivers/staging/rts5208/rtsx.c                     |   13 +-
 drivers/staging/rts5208/rtsx_card.h                |    4 +-
 drivers/staging/rts5208/rtsx_chip.c                |   20 +-
 drivers/staging/rts5208/rtsx_scsi.c                |   15 +-
 drivers/staging/rts5208/sd.c                       |   17 +-
 drivers/staging/rts5208/trace.h                    |    8 -
 drivers/staging/skein/skein_block.c                |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    3 +-
 drivers/staging/speakup/buffers.c                  |    1 -
 drivers/staging/speakup/i18n.h                     |   28 +-
 drivers/staging/speakup/keyhelp.c                  |    7 +-
 drivers/staging/speakup/kobjects.c                 |    7 +-
 drivers/staging/speakup/main.c                     |   46 +-
 drivers/staging/speakup/selection.c                |    1 +
 drivers/staging/speakup/serialio.c                 |    2 +
 drivers/staging/speakup/serialio.h                 |    2 +-
 drivers/staging/speakup/speakup_acntpc.c           |    3 +
 drivers/staging/speakup/speakup_audptr.c           |    2 +
 drivers/staging/speakup/speakup_decext.c           |    3 +-
 drivers/staging/speakup/speakup_decpc.c            |    9 +-
 drivers/staging/speakup/speakup_dectlk.c           |    2 +
 drivers/staging/speakup/speakup_dtlk.c             |    5 +
 drivers/staging/speakup/speakup_keypc.c            |    3 +
 drivers/staging/speakup/speakup_ltlk.c             |    1 +
 drivers/staging/speakup/speakup_soft.c             |    3 +
 drivers/staging/speakup/speakup_spkout.c           |    1 +
 drivers/staging/speakup/spk_types.h                |    4 +-
 drivers/staging/speakup/spkguide.txt               |   36 +-
 drivers/staging/speakup/synth.c                    |    9 +-
 drivers/staging/speakup/thread.c                   |    1 +
 drivers/staging/speakup/varhandlers.c              |    7 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      |    2 +
 drivers/staging/unisys/channels/channel.c          |   12 +-
 drivers/staging/unisys/channels/chanstub.c         |    4 +-
 .../unisys/common-spar/include/channels/channel.h  |   59 +-
 .../include/channels/controlframework.h            |    2 +-
 .../include/channels/controlvmchannel.h            |    4 +-
 .../common-spar/include/channels/diagchannel.h     |    2 +-
 .../common-spar/include/channels/iochannel.h       |   47 +-
 .../common-spar/include/channels/vbuschannel.h     |    1 -
 .../include/controlvmcompletionstatus.h            |   16 +-
 .../unisys/common-spar/include/iovmcall_gnuc.h     |   30 +-
 .../unisys/common-spar/include/vbusdeviceinfo.h    |    3 +-
 drivers/staging/unisys/include/commontypes.h       |   72 -
 drivers/staging/unisys/include/guestlinuxdebug.h   |   10 +-
 drivers/staging/unisys/include/periodic_work.h     |   22 +-
 drivers/staging/unisys/include/timskmod.h          |  147 +-
 drivers/staging/unisys/include/timskmodutils.h     |   77 -
 drivers/staging/unisys/include/uisqueue.h          |   99 +-
 drivers/staging/unisys/include/uisthread.h         |    3 -
 drivers/staging/unisys/include/uisutils.h          |   46 +-
 drivers/staging/unisys/include/uniklog.h           |    2 -
 drivers/staging/unisys/include/vbushelper.h        |   28 +-
 drivers/staging/unisys/uislib/Kconfig              |    2 +-
 drivers/staging/unisys/uislib/uislib.c             |  451 +-
 drivers/staging/unisys/uislib/uisqueue.c           |   69 +-
 drivers/staging/unisys/uislib/uisthread.c          |    1 +
 drivers/staging/unisys/uislib/uisutils.c           |   64 +-
 drivers/staging/unisys/virthba/virthba.c           |   25 +-
 drivers/staging/unisys/virtpci/virtpci.c           |   37 +-
 drivers/staging/unisys/visorchannel/visorchannel.h |    1 -
 .../unisys/visorchannel/visorchannel_funcs.c       |    7 +-
 drivers/staging/unisys/visorchipset/Kconfig        |    2 +-
 drivers/staging/unisys/visorchipset/file.c         |    5 +-
 drivers/staging/unisys/visorchipset/parser.c       |    2 +
 .../unisys/visorchipset/visorchipset_main.c        |   64 +-
 drivers/staging/unisys/visorutil/Kconfig           |    2 +-
 drivers/staging/unisys/visorutil/periodic_work.c   |  137 +-
 drivers/staging/unisys/visorutil/procobjecttree.c  |    3 +-
 drivers/staging/unisys/visorutil/visorkmodutils.c  |   40 -
 drivers/staging/vme/devices/vme_pio2_gpio.c        |   14 +-
 drivers/staging/vme/devices/vme_user.c             |    4 +-
 drivers/staging/vt6655/80211hdr.h                  |    3 +-
 drivers/staging/vt6655/80211mgr.c                  |   41 +-
 drivers/staging/vt6655/80211mgr.h                  |   15 +-
 drivers/staging/vt6655/aes_ccmp.c                  |    5 +-
 drivers/staging/vt6655/baseband.c                  |  315 +-
 drivers/staging/vt6655/baseband.h                  |   45 +-
 drivers/staging/vt6655/bssdb.c                     |   99 +-
 drivers/staging/vt6655/bssdb.h                     |    8 +-
 drivers/staging/vt6655/card.c                      |  454 +-
 drivers/staging/vt6655/card.h                      |   99 +-
 drivers/staging/vt6655/channel.c                   |   17 +-
 drivers/staging/vt6655/datarate.c                  |   15 +-
 drivers/staging/vt6655/desc.h                      |  219 +-
 drivers/staging/vt6655/device.h                    |   49 +-
 drivers/staging/vt6655/device_cfg.h                |    3 -
 drivers/staging/vt6655/device_main.c               |  530 +-
 drivers/staging/vt6655/dpc.c                       |  172 +-
 drivers/staging/vt6655/dpc.h                       |    2 +-
 drivers/staging/vt6655/hostap.c                    |  186 +-
 drivers/staging/vt6655/hostap.h                    |    4 +-
 drivers/staging/vt6655/ioctl.c                     |   84 +-
 drivers/staging/vt6655/ioctl.h                     |    2 +-
 drivers/staging/vt6655/iowpa.h                     |    4 +-
 drivers/staging/vt6655/iwctl.c                     |  164 +-
 drivers/staging/vt6655/key.c                       |  144 +-
 drivers/staging/vt6655/key.h                       |    8 +-
 drivers/staging/vt6655/mac.c                       |   65 +-
 drivers/staging/vt6655/mib.c                       |   54 +-
 drivers/staging/vt6655/power.c                     |   35 +-
 drivers/staging/vt6655/rf.c                        |    8 +-
 drivers/staging/vt6655/rf.h                        |    8 +-
 drivers/staging/vt6655/rxtx.c                      | 1128 ++--
 drivers/staging/vt6655/rxtx.h                      |  166 +-
 drivers/staging/vt6655/ttype.h                     |   27 -
 drivers/staging/vt6655/upc.h                       |   39 +-
 drivers/staging/vt6655/vntwifi.c                   |    4 -
 drivers/staging/vt6655/wcmd.c                      |  155 +-
 drivers/staging/vt6655/wcmd.h                      |    3 +-
 drivers/staging/vt6655/wctl.c                      |    8 +-
 drivers/staging/vt6655/wctl.h                      |    6 +-
 drivers/staging/vt6655/wmgr.c                      |  387 +-
 drivers/staging/vt6655/wmgr.h                      |    2 +-
 drivers/staging/vt6655/wpa.c                       |   28 +-
 drivers/staging/vt6655/wpa2.c                      |   20 +-
 drivers/staging/vt6655/wpactl.c                    |  148 +-
 drivers/staging/vt6655/wpactl.h                    |    6 +-
 drivers/staging/vt6655/wroute.c                    |   14 +-
 drivers/staging/vt6655/wroute.h                    |    3 +-
 drivers/staging/vt6656/baseband.c                  |   20 +-
 drivers/staging/vt6656/card.c                      |    3 +-
 drivers/staging/vt6656/firmware.c                  |    5 +-
 drivers/staging/vt6656/key.c                       |    5 +-
 drivers/staging/vt6656/main_usb.c                  |    1 -
 drivers/staging/vt6656/rf.c                        |    5 +-
 drivers/staging/vt6656/rxtx.c                      |    9 +-
 drivers/staging/vt6656/usbpipe.c                   |    5 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |   10 +-
 drivers/staging/wlan-ng/p80211netdev.h             |   14 +-
 drivers/staging/wlan-ng/prism2fw.c                 |   93 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |   19 +-
 drivers/staging/wlan-ng/prism2mib.c                |   11 +-
 drivers/staging/xgifb/XGI_main_26.c                |   10 +-
 drivers/staging/xgifb/vb_init.c                    |   50 +-
 drivers/staging/xgifb/vb_setmode.c                 |    3 +-
 drivers/staging/xillybus/TODO                      |    5 -
 include/video/imx-ipu-v3.h                         |  188 +-
 1016 files changed, 27369 insertions(+), 173726 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-accel-bmc150
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-gyro-bmg160
 create mode 100644 Documentation/devicetree/bindings/iio/adc/rockchip-saradc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/dac/max5821.txt
 rename Documentation/devicetree/bindings/{staging => xillybus}/xillybus.txt (100%)
 rename drivers/staging/xillybus/README => Documentation/xillybus.txt (100%)
 rename drivers/{staging => char}/xillybus/Kconfig (100%)
 rename drivers/{staging => char}/xillybus/Makefile (100%)
 rename drivers/{staging => char}/xillybus/xillybus.h (99%)
 rename drivers/{staging => char}/xillybus/xillybus_core.c (90%)
 rename drivers/{staging => char}/xillybus/xillybus_of.c (99%)
 rename drivers/{staging => char}/xillybus/xillybus_pcie.c (97%)
 create mode 100644 drivers/gpu/ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/iio/accel/bmc150-accel.c
 create mode 100644 drivers/iio/adc/rockchip_saradc.c
 create mode 100644 drivers/iio/adc/ti-adc128s052.c
 create mode 100644 drivers/iio/dac/max5821.c
 create mode 100644 drivers/iio/gyro/bmg160.c
 create mode 100644 drivers/iio/light/al3320a.c
 delete mode 100644 drivers/staging/comedi/drivers/comedi_fc.c
 create mode 100644 drivers/staging/comedi/drivers/ni_labpc_common.c
 create mode 100644 drivers/staging/comedi/drivers/ni_usb6501.c
 delete mode 100644 drivers/staging/comedi/drivers/skel.c
 create mode 100644 drivers/staging/dgnc/dgnc_utils.c
 create mode 100644 drivers/staging/dgnc/dgnc_utils.h
 delete mode 100644 drivers/staging/et131x/Kconfig
 delete mode 100644 drivers/staging/et131x/Makefile
 delete mode 100644 drivers/staging/et131x/README
 delete mode 100644 drivers/staging/et131x/et131x.c
 delete mode 100644 drivers/staging/et131x/et131x.h
 delete mode 100644 drivers/staging/iio/frequency/ad5930.c
 delete mode 100644 drivers/staging/iio/frequency/ad9850.c
 delete mode 100644 drivers/staging/iio/frequency/ad9852.c
 delete mode 100644 drivers/staging/iio/frequency/ad9910.c
 delete mode 100644 drivers/staging/iio/frequency/ad9951.c
 create mode 100644 drivers/staging/lustre/README.txt
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/portals_compat25.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/lucache.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lprocfs_status.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_acl.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_common.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_dlm.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_handles.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_lib.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_log.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_net.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lustre_quota.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/lvfs_linux.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/obd_class.h
 delete mode 100644 drivers/staging/lustre/lustre/include/linux/obd_support.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_fsfilt.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_idmap.h
 rename drivers/staging/lustre/lustre/include/{linux => }/lustre_intent.h (100%)
 delete mode 100644 drivers/staging/lustre/lustre/include/lustre_linkea.h
 delete mode 100644 drivers/staging/lustre/lustre/include/lvfs.h
 delete mode 100644 drivers/staging/lustre/lustre/include/md_object.h
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_ost.h
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/heap.c
 delete mode 100644 drivers/staging/lustre/lustre/libcfs/upcall_cache.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/Makefile
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/fsfilt.c
 delete mode 100644 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
 delete mode 100644 drivers/staging/lustre/lustre/mgc/libmgc.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/idmap.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/linkea.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_ioctl.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_osd.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/llog_test.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/local_storage.h
 rename drivers/staging/lustre/lustre/{lvfs/lvfs_lib.c => obdclass/lprocfs_counters.c} (70%)
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/lu_ucred.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/md_attrs.c
 delete mode 100644 drivers/staging/lustre/lustre/obdclass/mea.c
 delete mode 100644 drivers/staging/lustre/lustre/obdecho/echo.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/nrs_crr.c
 delete mode 100644 drivers/staging/nokia_h4p/Kconfig
 delete mode 100644 drivers/staging/nokia_h4p/Makefile
 delete mode 100644 drivers/staging/nokia_h4p/TODO
 delete mode 100644 drivers/staging/nokia_h4p/hci_h4p.h
 delete mode 100644 drivers/staging/nokia_h4p/nokia_core.c
 delete mode 100644 drivers/staging/nokia_h4p/nokia_fw-bcm.c
 delete mode 100644 drivers/staging/nokia_h4p/nokia_fw-csr.c
 delete mode 100644 drivers/staging/nokia_h4p/nokia_fw-ti1273.c
 delete mode 100644 drivers/staging/nokia_h4p/nokia_fw.c
 delete mode 100644 drivers/staging/nokia_h4p/nokia_uart.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
 rename drivers/staging/rtl8188eu/hal/{HalHWImg8188E_BB.c => bb_cfg.c} (54%)
 create mode 100644 drivers/staging/rtl8188eu/hal/fw.c
 create mode 100644 drivers/staging/rtl8188eu/hal/mac_cfg.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/odm_debug.c
 create mode 100644 drivers/staging/rtl8188eu/hal/phy.c
 rename drivers/staging/rtl8188eu/hal/{Hal8188EPwrSeq.c => pwrseq.c} (68%)
 rename drivers/staging/rtl8188eu/hal/{HalPwrSeqCmd.c => pwrseqcmd.c} (60%)
 create mode 100644 drivers/staging/rtl8188eu/hal/rf.c
 create mode 100644 drivers/staging/rtl8188eu/hal/rf_cfg.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
 delete mode 100644 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_BB.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_MAC.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalHWImg8188E_RF.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalPwrSeqCmd.h
 rename drivers/staging/{rtl8821ae/rc.h => rtl8188eu/include/fw.h} (67%)
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_RegConfig8188E.h
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_RegDefine11AC.h
 create mode 100644 drivers/staging/rtl8188eu/include/phy.h
 create mode 100644 drivers/staging/rtl8188eu/include/pwrseq.h
 create mode 100644 drivers/staging/rtl8188eu/include/pwrseqcmd.h
 create mode 100644 drivers/staging/rtl8188eu/include/rf.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_rf.h
 delete mode 100644 drivers/staging/rtl8192ee/Kconfig
 delete mode 100644 drivers/staging/rtl8192ee/Makefile
 delete mode 100644 drivers/staging/rtl8192ee/TODO
 delete mode 100644 drivers/staging/rtl8192ee/base.c
 delete mode 100644 drivers/staging/rtl8192ee/base.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbt_precomp.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8192e2ant.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8192e2ant.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b1ant.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b1ant.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b2ant.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b2ant.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a1ant.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a1ant.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a2ant.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a2ant.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/rtl_btc.c
 delete mode 100644 drivers/staging/rtl8192ee/btcoexist/rtl_btc.h
 delete mode 100644 drivers/staging/rtl8192ee/cam.c
 delete mode 100644 drivers/staging/rtl8192ee/cam.h
 delete mode 100644 drivers/staging/rtl8192ee/compat.h
 delete mode 100644 drivers/staging/rtl8192ee/core.c
 delete mode 100644 drivers/staging/rtl8192ee/core.h
 delete mode 100644 drivers/staging/rtl8192ee/debug.c
 delete mode 100644 drivers/staging/rtl8192ee/debug.h
 delete mode 100644 drivers/staging/rtl8192ee/efuse.c
 delete mode 100644 drivers/staging/rtl8192ee/efuse.h
 delete mode 100644 drivers/staging/rtl8192ee/pci.c
 delete mode 100644 drivers/staging/rtl8192ee/pci.h
 delete mode 100644 drivers/staging/rtl8192ee/ps.c
 delete mode 100644 drivers/staging/rtl8192ee/ps.h
 delete mode 100644 drivers/staging/rtl8192ee/rc.c
 delete mode 100644 drivers/staging/rtl8192ee/rc.h
 delete mode 100644 drivers/staging/rtl8192ee/regd.c
 delete mode 100644 drivers/staging/rtl8192ee/regd.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/def.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/dm.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/dm.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/fw.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/fw.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/hw.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/hw.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/led.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/led.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/phy.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/phy.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/reg.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/rf.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/rf.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/sw.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/sw.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/table.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/table.h
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/trx.c
 delete mode 100644 drivers/staging/rtl8192ee/rtl8192ee/trx.h
 delete mode 100644 drivers/staging/rtl8192ee/stats.c
 delete mode 100644 drivers/staging/rtl8192ee/stats.h
 delete mode 100644 drivers/staging/rtl8192ee/wifi.h
 delete mode 100644 drivers/staging/rtl8821ae/Kconfig
 delete mode 100644 drivers/staging/rtl8821ae/Makefile
 delete mode 100644 drivers/staging/rtl8821ae/TODO
 delete mode 100644 drivers/staging/rtl8821ae/base.c
 delete mode 100644 drivers/staging/rtl8821ae/base.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/habtc8723a1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723a2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c
 delete mode 100644 drivers/staging/rtl8821ae/btcoexist/rtl_btc.h
 delete mode 100644 drivers/staging/rtl8821ae/cam.c
 delete mode 100644 drivers/staging/rtl8821ae/cam.h
 delete mode 100644 drivers/staging/rtl8821ae/compat.h
 delete mode 100644 drivers/staging/rtl8821ae/core.c
 delete mode 100644 drivers/staging/rtl8821ae/core.h
 delete mode 100644 drivers/staging/rtl8821ae/debug.c
 delete mode 100644 drivers/staging/rtl8821ae/debug.h
 delete mode 100644 drivers/staging/rtl8821ae/efuse.c
 delete mode 100644 drivers/staging/rtl8821ae/efuse.h
 delete mode 100644 drivers/staging/rtl8821ae/pci.c
 delete mode 100644 drivers/staging/rtl8821ae/pci.h
 delete mode 100644 drivers/staging/rtl8821ae/ps.c
 delete mode 100644 drivers/staging/rtl8821ae/ps.h
 delete mode 100644 drivers/staging/rtl8821ae/rc.c
 delete mode 100644 drivers/staging/rtl8821ae/regd.c
 delete mode 100644 drivers/staging/rtl8821ae/regd.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/btc.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/def.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/dm.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/fw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/hw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/led.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/phy.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/reg.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/rf.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/sw.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/table.h
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.c
 delete mode 100644 drivers/staging/rtl8821ae/rtl8821ae/trx.h
 delete mode 100644 drivers/staging/rtl8821ae/stats.c
 delete mode 100644 drivers/staging/rtl8821ae/stats.h
 delete mode 100644 drivers/staging/rtl8821ae/wifi.h
 delete mode 100644 drivers/staging/unisys/include/commontypes.h
 delete mode 100644 drivers/staging/unisys/include/timskmodutils.h
 delete mode 100644 drivers/staging/xillybus/TODO
