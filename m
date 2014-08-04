Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaHDTIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:08:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaHDTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:08:39 -0400
Date: Mon, 4 Aug 2014 12:08:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.17-rc1
Message-ID: <20140804190837.GA27292@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.17-rc1

for you to fetch changes up to b9aaea39f65e242303103b5283abeaefd8e538a4:

  staging: comedi: addi_apci_1564: remove diagnostic interrupt support code (2014-08-01 15:37:22 -0700)

----------------------------------------------------------------
Staging driver patches for 3.17-rc1

Here's the big pull request for the staging driver tree for 3.17-rc1.

Lots of things in here, over 2000 patches, but the best part is this:
 1480 files changed, 39070 insertions(+), 254659 deletions(-)

Thanks to the great work of Kristina Martšenko, 14 different staging
drivers have been removed from the tree as they were obsolete and no one
was willing to work on cleaning them up.  Other than the driver
removals, loads of cleanups are in here (comedi, lustre, etc.) as well
as the usual IIO driver updates and additions.

All of this has been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
A Raghavendra Rao (1):
      Staging: rtl8192e: dot11d: Fixed printk coding style issues

Aaro Koskinen (5):
      staging: octeon-usb: drop dequeue tasklet
      staging: octeon-usb: use usb_hcd_link_urb_to_ep()
      staging: octeon-usb: don't retry on data toggle error
      staging: octeon-usb: return transferred bytes only on success
      staging: octeon-usb: fix endianness bug

Adithya Krishnamurthy (4):
      Staging:tidspbridge Fix minor checkpatch.pl warning
      Staging:tidspbridge Fix checkpatch.pl warning char * array declaration might be better as static const
      Staging:tidspbridge Fix minor checkpatch.pl warning unnecessary whitespace before a quoted newline
      Staging:tidspbridge Fix minor checkpatch.pl warining Unnecessary parentheses

Alexander.Boyko (1):
      staging/lustre/ptlrpc: race at req processing

Alexey Khoroshilov (2):
      staging: line6: do not return 0 from probe if no initialization done
      staging: gdm724x: fix leak at failure path in init_usb()

Alexey Lyashkov (1):
      staging/lustre/ptlrpc: unlink request buffer correctly

Alexey Tulia (1):
      staging: usbip: fixed a coding-style warning

Andrey Skvortsov (4):
      staging: lustre: obdclass: linux-sysctl.c: fix pointer coding style issue
      staging: lustre: obdclass: linux-sysctl.c: fix checkpatch warnings about included headers
      staging: lustre: obdclass: linux-sysctl.c: fix unnecessary spaces coding style issue
      staging: lustre: obdclass: fix sparse warnings about static declaration

Andrey Utkin (5):
      staging: rtl8192ee: Correct bitmask in comparsion
      staging: ft1000-usb: check for errors in card_send_command
      staging: comedi: ni_atmio16d.c: remove pointless condition
      drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c: drop incorrect checks
      drivers/staging/bcm/Misc.c: fix a check

Andriy Skulysh (2):
      staging/lustre/mgc: mgc import reconnect race
      staging/lustre/osc: osc_extent_truncate()) ASSERTION( !ext->oe_urgent ) failed

Andy Shevchenko (3):
      staging: rtl8188eu: re-use mac_pton() helper
      staging: rtl8188eu: substitute custom hex2bin()
      staging: rtl8188eu: re-use hex_to_bin() instead of custom code

Anil Belur (24):
      staging: lustre: lclient: glimpse.c fixing coding style issues
      staging: lustre: lclient: glimpse.c fixing coding style issues
      staging: lustre: lclient: lcommon_misc.c fixing coding style issues
      staging: lustre: lclient: lcommon_cl.c fixing coding style issues
      staging: lustre: lclient: lcommon_cl.c fixing coding style issues
      staging: lustre: lclient: lcommon_cl.c fixing coding style issues
      staging: lustre: lclient: lcommon_cl.c fixing coding style issues
      staging: lustre: lclient: lcommon_cl.c fixing coding style issues
      staging : lustre : lustre : fid : lproc_fid.c: fixed warning
      staging: lustre: ldlm: ldlm_resource.c removed unecessary braces
      staging: lustre: ldlm: ldlm_resource.c replace obsolete function with kstrtoul()
      staging: lustre: lustre: fld: lproc_fld.c fixed warning
      staging: lustre: lustre: fld: lproc_fld.c fixed warning
      staging: lustre: lustre: ldlm: ldlm_lib.c - removed unnecessary braces
      staging: lustre: ldlm: ldlm_lib.c removed unecessary space after function name
      staging: lustre: lustre: libcfs: fail.c - fix sparse warnings EXPORT_SYMBOL
      staging: lustre: llite: llite_capa.c - fixes checkpatch errors - unecessary init of static variables to 0
      staging: lustre: llite: llite_capa.c - fixed warning to use recomended headers <linux/uaccess.h>
      staging: lustre: llite: dir.c - fixes indented labels in code
      staging: lustre: llite: dir.c - fix for coding style issues
      staging: lustre: lnet: api-ni.c: fixed sparse warnings
      staging: speakup: speakup_dectlk.c - use time_before_eq()
      staging: lustre: ldlm: ldlm_resource.c - fix dereferenceing user space buffer
      staging: lustre: ptlrpc: lproc_ptlrpc.c - fix dereferenceing user space buffer

Anton Protopopov (2):
      staging: vt6655: fixed sparse warnings
      Staging: comedi: check the return value of kobject_set_name

Arnd Bergmann (5):
      staging: rtl8712, rtl8712: avoid lots of build warnings
      staging: sn9c102 depends on USB
      staging: lirc: remove sa1100 support
      staging: wlags49_h2: avoid PROFILE_ALL_BRANCHES warnings
      staging/lustre: disable virtual block device for 64K pages

Ben Chan (10):
      staging: gdm72xx: check return value of sscanf
      staging: gdm72xx: fix block comment style
      staging: gdm72xx: remove blank lines after an open brace
      staging: gdm72xx: return -EINVAL instead of BUG_ON for invalid data length
      staging: gdm72xx: use bool instead of custom-defined BOOLEAN
      staging: gdm72xx: use int instead of u32 whenever makes sense
      staging: gdm72xx: use lower case for variable names for consistency
      staging: gdm72xx: use consistent style for header guards
      staging: gdm72xx: clean up endianness conversions
      staging: gdm72xx: add help text to Kconfig

Benedict Boerger (1):
      staging: sep: Fix checkpatch.pl warnings

Benjamin Romer (26):
      staging: unisys: remove proc entries from /proc/visorchipset/controlvm
      staging: unisys: simplify controlvm channel address function
      staging: unisys: detect controlvm channel on module load
      staging: unisys: add toolaction to sysfs
      staging: unisys: move boottotool out of proc to sysfs
      staging: unisys: move installer to sysfs and split fields
      staging: unisys: move chipsetready to sysfs
      staging: unisys: clean up diagdump proc entry code
      staging: unisys: ABI documentation for new sysfs entries
      staging: unisys: fix visorchipset sysfs attribute functions
      staging: unisys: remove partition information from proc
      staging: unisys: remove parahotplug proc entry
      staging: unisys: add sysfs entries for parahotplug support
      staging: unisys: remove U8 type
      staging: unisys: remove U16 type
      staging: unisys: remove U32 type
      staging: unisys: remove U64 type
      staging: unisys: remove S8 type
      staging: unisys: remove S16 type
      staging: unisys: remove S32 type
      staging: unisys: remove S64 type
      staging: unisys: remove non-kernel code from commontypes.h
      staging: unisys: remove unused defines from commontypes.h
      staging: unisys: remove UINTN type
      staging: unisys: remove MEMSET define
      staging: unisys: remove MEMCMP_IO

Beomho Seo (2):
      iio: light: cm32181: Use devm_* APIs
      iio: magnetometer: ak8975: Use devm_* APIs

Bernd Porr (2):
      staging: comedi: usbduxsigma: fixing rounding error in the range struct
      staging: comedi: usbduxfast: adding missing break in case statement

Bob Glossman (1):
      staging/lustre/obdclass: runtime load lustre client when needed

Bobi Jam (1):
      staging/lustre/osc: get rid of old checksum initial value

Chaitanya Hazarey (12):
      Staging: rtl8192u: r8192U_wx.c removed commented dead code
      Staging: rtl8192u: r8192U_wx.c Removed all C99 comments
      Staging: rtl8192u: r8192U_wx.c Added a single space for code-style issue
      Staging: rtl8192u: r8192U_wx.c Removed some more commented out dead code
      Staging: rtl8192u: r8192U_core.c Added a space after ','
      Staging: rtl8192u: r8192U_core.c Rearranged statements to fix code-style errors
      Staging: rtl8192u: r8192U_core.c Converted some C99 comments to fix code-style errors
      Staging: rtl8192u: r8192U_core.c Fixed open brace { placement
      Staging: rtl8192u: r8192U_core.c Converted a C99 comment to fix code-style error
      Staging: rtl8192u: r8192U_wx.c Fixed code-style warnings
      Staging: rtl8192u: r8192U_wx.c Fixed some more code-style warnings about spaces
      Staging: rtl8192u: r8192U_wx.c Fixed a code-style error about trailing whitespace

Chanwoo Choi (4):
      iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
      iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
      iio: devicetree: Add DT binding documentation for Exynos3250 ADC
      ARM: dts: Fix wrong compatible string for Exynos3250 ADC

Chase Southwood (16):
      staging: comedi: addi_apci_1564: remove use of devpriv->b_OutputMemoryStatus
      staging: comedi: addi_apci_1564: remove unused static variables
      staging: comedi: addi_apci_1564: introduce apci1564_private struct
      staging: comedi: addi_apci_1564: add Change-of-State interrupt subdevice and required functions
      staging: comedi: addi_apci_1564: move apci1564_interrupt() into addi_apci_1564.c
      staging: comedi: addi_apci_1564: move addi_watchdog.h include to addi_apci_1564.c
      staging: comedi: addi_apci_1564: fix use of apci1564_reset() to disable DI interrupts
      staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
      staging: comedi: addi_apci_1564: remove len_chanlist from di and do subdevices
      staging: comedi: addi_apci_1564: remove unnecessary dev->board_name initialization
      staging: comedi: addi_apci_1564: remove null check of devpriv in apci1564_detach()
      staging: comedi: addi_apci_1564: fix s->maxdata assignment in do subdevice init.
      staging: comedi: addi_apci_1564: driver no longer needs to include addi_common.h
      staging: comedi: addi_apci_1564: use addi_watchdog module to init watchdog subdevice
      staging: comedi: addi_apci_1564: add subdevice to check diagnostic status
      staging: comedi: addi_apci_1564: remove diagnostic interrupt support code

Chen Gang (3):
      drivers: staging: android: ion: Kconfig: Let it also depend on HAS_DMA
      staging:iio:adc:Kconfig: Let MXS_LRADC depend on HAS_IOMEM
      drivers: staging: lustre: Use 'force_die' instead of 'die' to avoid compiling issue

Cheng Shao (1):
      staging/lustre/mgc: replace hard-coded MGC_ENQUEUE_LIMIT value

Cheng-Wei Lee (2):
      staging: ft1000_dnld.c:code indent should use tabs where possible
      staging: wlan-ng/hfa384x_usb.c: add blank line after declarations

Chi Pham (1):
      staging: ced1401: Add void declarations in zero-arg functions.

Christopher J. Morrone (1):
      staging/lustre/ptlrpc: Add schedule point to ptlrpc_check_set()

Chuong Ngo (1):
      drivers/staging/bcm: Added a space after a comma.

Cihangir Akturk (1):
      staging: gdm724x: fix misplaced open braces

Clément Calmels (1):
      staging: rtl8723au: fix sparse warning

Daeseok Youn (45):
      staging: dgap: remove useless dgap_probe1() function
      staging: dgap: unwind on error in dgap_found_board()
      staging: dgap: remove bogus null test in dgap_tty_init()
      staging: dgap: unwind on error in dgap_tty_init()
      staging: dgap: unwind on error in dgap_tty_register_ports()
      staging: dgap: make dgap_config_buf a local buffer
      staging: dgap: pass "dgap_numboards" as a paramter to dgap_found_board()
      staging: dgap: pass "brd" as a paramter to dgap_after_config_loaded()
      staging: dgap: rename dgap_finalize_board_init() to dgap_request_irq()
      staging: dgap: rename dgap_tty_uninit() to dgap_cleanup_tty()
      staging: dgap: remove unused paramter in dgap_parsefile()
      staging: dgap: get rid of brd->firstminor because it is 0
      staging: dgap: introduce dgap_tty_free() for freeing channels.
      staging: dgap: introduce dgap_free_irq()
      staging: dgap: rename dgap_after_config_loaded() to dgap_alloc_flipbuf()
      staging: dgap: move unrelated functions in dgap_firmware_load()
      staging: dgap: unwind on error in dgap_init_one()
      staging: dgap: make dgap_found_board() return a brd pointer
      staging: dgap: fixed "foo* bar should be foo * bar" in dgap.c
      staging: dgap: remove "return" statement in void function
      staging: dgap: Adds a blank line after declaration
      staging: dgap: remove unneccessary dgap_init_pci() function
      staging: dgap: remove unused waitqueues
      staging: dgap: use kzalloc instead of kmalloc/memset
      staging: dgap: remove redundant NULL check in dgap_tty_init()
      staging: dgnc: remove redundant null check for kfree()
      staging: dgnc: Fix unsigned value for less than zero
      staging: dgnc: removes unreachable code
      staging: dgnc: remove redundant memset call
      staging: dgap: removes redundant null check and change paramter for dgap_maxcps_room()
      staging: dgap: redundant NULL and magic check in dgap_get_modem_info()
      staging: dgap: remove unused variable in dgap_param()
      staging: dgap: removes redundant null check and change the paramter for dgap_param()
      staging: dgap: removes redundant null check and change paramter for dgap_tty_digiseta()
      staging: dgap: removes redundant null check and change paramter for dgap_tty_digigeta()
      staging: dgap: removes redundant null check and change paramter for dgap_set_modem_info()
      staging: dgap: removes redundant null check and change paramter for dgap_tty_digisetedelay()
      staging: dgap: removes redundant null check and change paramter for dgap_tty_digigetcustombaud()
      staging: dgap: removes redundant null check and change paramter for dgap_tty_digisetcustombaud()
      MAINTAINERS: Adds Daeseok Youn to maintainers list for dgap
      staging: dgap: remove redundant error value check
      staging: dgap: remove unused case value in dgap_parsefile()
      staging: dgap: fix a typo in dgap_gettok()
      staging: dgap: remove unused a parameter in dgap_gettok()
      staging: dgap: remove dgap_newnode()

Dan Carpenter (3):
      staging: rtl8188eu: use GFP_ATOMIC under spinlock
      staging: comedi: ni_tio: remove some dead code
      staging: lustre: bitwise vs logical typo

Daniel Baluta (2):
      iio: hid-sensors: make hid_sensor_get_reporting_interval static
      staging: iio: remove duplicate case labels

David Daney (1):
      staging: octeon-ethernet: Move PHY activation to .ndo_open().

Dmitry Eremin (4):
      staging/lustre: fix frong ldlm flags type used
      staging/lustre/ptlrpc: fix NULL pointer dereference of {exp, imp}_obd
      staging/lustre/obdclass: Fix uninitialized variables
      staging/lustre/llite: Fix uninitialized variable

Eli Billauer (6):
      staging: xillybus: Use devm_ API for memory allocation and DMA mapping
      staging: xillybus: Add sanity check in interrupt handler
      staging: xillybus: Reorganizing xilly_setupchannels()
      staging: xillybus: Register's address offset notation update
      staging: xillybus: Fix if-else coding style errors
      staging: xillybus: Removed outdated part in README

Emil Goode (1):
      Staging: rtl8192e: Fix potential NULL pointer dereference

Erik Arfvidson (7):
      staging: unisys: remove all proc entries from virtpci
      staging: unisys: added virtpci info entry
      staging: unisys: remove virthba proc files
      staging: unisys: added virthba debugfs dir and info entry
      staging: unisys: added virthba rqwait entry
      staging: unisys: added virthba enable_ints entry
      staging: unisys: fix and remove virthba comments

Evgeny Budilovsky (1):
      staging/cptm1217: fix checkpatch warnings about else clause

Fabian Frederick (5):
      drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c: remove unnecessary null test before kfree
      staging: rtl8723au: Remove unnecessary null test before kfree
      staging/lustre/obdclass: use static const for seq_operations
      staging/lustre/libcfs: use ARRAY_SIZE instead of sizeof/sizeof[0]
      staging: ion: vm_insert_pfn and zap_page_range rely on CONFIG_MMU

Fabio Falzoi (2):
      Staging: rts5208: Remove useless debug prints
      Staging: rts5208: Replace custom macro with dev_dbg

Federico Di Pierro (1):
      staging: iio: Coding style issues fix.

Fengguang Wu (1):
      staging: r8192ee: fix coccinelle warnings

Fred Brooks (1):
      staging: comedi: ni_daq_700: add AI range and input mode switching

Geert Uytterhoeven (2):
      staging: rtl8723au: Add compiler check for -Wtype-limits
      Documentation/kernel-parameters: Remove obsolete ip2=

Greg Kroah-Hartman (76):
      Merge tag 'iio-for-3.17a' of git://git.kernel.org/.../jic23/iio into staging-next
      Revert "staging: tidspbridge: use safer test on the result of find_first_zero_bit"
      Merge 3.16-rc2 into staging-next
      Merge tag 'iio-for-3.17b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.16-rc4 into staging-next
      Merge branch 'component-for-staging' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-next
      staging: lnet: types.h: checkpatch cleanup: whitespace neatening
      staging: lnet: lib-lnet.h: checkpatch cleanup: align arguments to parenthesis
      staging: lnet: lib-lnet.h: checkpatch cleanup: remove unnecessary externs
      staging: lnet: lnetctl.h: checkpatch cleanup: whitespace neatening
      staging: lnet: ptllnd_wire.h: checkpatch cleanup: whitespace neatening
      staging: lustre: remove top level ccflags variable
      staging: lustre: remove some unneeded cflags
      staging: lustre: libcfs: remove ccflags from Makefile
      staging: lustre: fix include relative paths
      staging: lustre: fid: remove ccflags from Makefile
      staging: lustre: fld: remove ccflags from Makefile
      staging: lustre: llite: remove ccflags from Makefile
      staging: lustre: lmv: remove ccflags from Makefile
      staging: lustre: lov: remove ccflags from Makefile
      staging: lustre: lvfs: remove ccflags from Makefile
      staging: lustre: mdc: remove ccflags from Makefile
      staging: lustre: obdclass: remove ccflags from Makefile
      staging: lustre: mgc: remove ccflags from Makefile
      staging: lustre: osc: remove ccflags from Makefile
      staging: lustre: obdecho: remove ccflags from Makefile
      staging: lustre: ptlrpc/ldlm: remove ccflags from Makefile
      staging: lustre: ptlrpc: gss: delete unused code
      staging: lustre: lnet: include: minor whitespace fixes
      staging: lustre: libcfs: include: minor whitespace fixes
      staging: lustre: remove empty bitmap.h
      staging: lustre: remove l_dentry define
      staging: lustre: remove l_file define
      staging: lustre: remove l_filep_open define
      staging: lustre: remove unneeded DECLARE_LL_PROC_PPOS_DECL macro
      staging: lustre: make include/linux/libcfs/linux/linux-crypto.h private
      staging: lustre: remove include/libcfs/linux/linux-bitops.h
      staging: lustre: linux-cpu.h
      staging: lustre: delete linux-lock.h
      staging: lustre: fix build breakage on microblaze
      staging: lustre: remove linux-types.h
      staging: lustre: remove ctl_table typedefs
      staging: lustre: remove socket_t typedef
      staging: lustre: fix makefile build breakage
      staging: lustre: linux-tcpip.h: remove unused macros
      staging: lustre: remove linux-tcpip.h
      staging: lustre: remove cfs_fs_time_t
      staging: lustre: remove unused functions from linux-time.h
      staging: lustre: remove cfs_time_t typedef
      staging: lustre: remove cfs_time_beforeq wrapper
      staging: lustre: remove cfs_time_current_sec wrapper
      staging: lustre: remove cfs_duration_t typedef
      staging: lustre: cfs_time_sub() must return unsigned long
      staging: lustre: remove cfs_time_before()
      staging: lustre: fid: fid_request.c: checkpatch cleanup: align arguments to parenthesis
      staging: lustre: remove LL_PROC_PROTO macro
      staging: lustre: remove hpdd-discuss list from TODO file
      staging: lustre: clean up some proc file declarations
      staging: lustre: remove linux-prim.h
      staging: lustre: remove LPF64 #define
      staging: lustre: remove LPLU, LPLD, and LPLX defines
      staging: lustre: remove LPX64i define
      staging: lustre: remove LPD64 define
      staging: lustre: remove LPU64 define
      staging: lustre: remove LPX64 define
      staging: lustre: remove kp30.h
      staging: lustre: remove ALLOC_ATOMIC_TRY
      staging: lustre: don't use custom typedef for an inode
      staging: lustre: use CONFIG_PROC_FS
      staging: lustre: delete params_tree.h
      staging: lustre: remove proc function wrappers
      Merge tag 'iio-for-3.17c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.16-rc5 into staging-next
      Merge 'delete tidspbridge branch' into staging-next
      staging: gdm72xx: fix build errors
      Merge tag 'iio-for-3.17d' of git://git.kernel.org/.../jic23/iio into staging-next

Guillaume Clement (20):
      staging: vt6655: change type of PortOffset to void __iomem *
      staging: vt6655:fix warning for unexported non-static functions
      staging: vt6655: statify some variables
      staging: vt6655: remove unused functions
      staging: vt6655: Fix unused function warning
      staging: vt6655: remove useless return statements
      staging: vt6655: Add missing blank lines after declarations
      staging: vt6655: Remove spaces before quoted newlines
      staging: vt6655: fix function braces not on the proper line
      staging: vt6655: fix braces at newline for structs
      staging: vt6655: fix static position in inline function
      staging: vt6655: Use pr_* functions instead of printk
      staging: vt6655: break single line if statements
      staging: vt6655: Remove unreachable break statements
      staging: vt6655: add missing whitespace
      staging: vt6655: remove braces for single statements if
      staging: vt6655: fix braces at newline in if statements
      staging: vt6655: remove unused macro
      staging: vt6655: Remove NULL pointer sparse warning
      staging: vt6655: fix direct dereferencing of user pointer

Guillaume Morin (3):
      staging: iio: ad9850.c: code cleanup
      staging: dgnc_driver.c: code style fixes
      staging: lustre: llite: rw.c: remove gfp_mask

H Hartley Sweeten (393):
      staging: comedi: ni_mio_common: remove forward declaration 1
      staging: comedi: ni_mio_common: remove forward declaration 2
      staging: comedi: ni_mio_common: remove forward declaration 3
      staging: comedi: ni_mio_common: remove forward declaration 4
      staging: comedi: ni_mio_common: remove forward declaration 5
      staging: comedi: ni_mio_common: remove forward declaration 6
      staging: comedi: ni_mio_common: remove forward declaration 7
      staging: comedi: ni_mio_common: remove forward declaration 8
      staging: comedi: ni_mio_common: remove forward declaration 9
      staging: comedi: ni_mio_common: remove forward declaration 10
      staging: comedi: ni_mio_common: remove forward declaration 11
      staging: comedi: ni_mio_common: remove forward declaration 12
      staging: comedi: ni_mio_common: remove forward declaration 13
      staging: comedi: ni_mio_common: remove forward declaration 14
      staging: comedi: ni_mio_common: remove forward declaration 15
      staging: comedi: ni_mio_common: remove forward declaration 16
      staging: comedi: ni_mio_common: remove forward declaration 17
      staging: comedi: ni_mio_common: remove forward declaration 18
      staging: comedi: ni_mio_common: remove forward declaration 19
      staging: comedi: ni_mio_common: remove forward declaration 20
      staging: comedi: ni_mio_common: remove forward declaration 21
      staging: comedi: ni_mio_common: remove forward declaration 22
      staging: comedi: ni_mio_common: remove forward declaration 23
      staging: comedi: ni_mio_common: remove forward declaration 24
      staging: comedi: ni_mio_common: move disabled GPCT functions
      staging: comedi: ni_mio_common: move externally called functions to EOF
      staging: comedi: ni_mio_common: use dev->read_subdev
      staging: comedi: ni_mio_common: use dev->write_subdev
      staging: comedi: ni_mio_common: absorb helpers into ni_freq_out_insn_config()
      staging: comedi: ni_mio_common: fix the (*insn_write) for the freq_out counter
      staging: comedi: ni_mio_common: fix the (*insn_read) for the freq_out counter
      staging: comedi: adq12b: fix ctreg (ai channel/range) programming
      staging: comedi: adq12b: tidy up adq12b_ai_rinsn()
      staging: comedi: adq12b: remove 'unipolar' from private data
      staging: comedi: adq12b: remove 'differential' from private data
      staging: comedi: adq12b: remove ADQ12B_SIZE define
      staging: comedi: adq12b: remove 's->len_chanlist' init for analog inputs
      staging: comedi: adq12b: tidy up the subdevice init
      staging: comedi: adq12b: tidy up the register map defines
      staging: comedi: addi_common.h: remove 'b_SingleDiff' from private data
      staging: comedi: addi_common.h: remove APCI1710_SAVE_INTERRUPT define
      staging: comedi: addi_common.h: remove ADDI_{EN, DIS}ABLE defines
      staging: comedi: addi_common.h: remove ADDIDATA_{EN, DIS}ABLE defines
      staging: comedi: addi_common.h: remove {LO, HI}WORD macros
      staging: comedi: addi_common.h: remove ADDIDATA_* defines
      staging: comedi: pcl730: add support for Diamond Systems IR104-PBF module
      staging: comedi: pcl724: add support for Diamond Systems ONYX-MM-DIO module
      staging: comedi: adl_pci9111: remove PCI9111_DRIVER_NAME define
      staging: comedi: adl_pci9111: remove PCI9111_HR_DEVICE_ID define
      staging: comedi: adl_pci9111: simplify A/D trigger selection code
      staging: comedi: ke_counter: add ability to select counter clock source
      staging: comedi: ni_stc.h: remove NI_PRIVATE_COMMON macro
      staging: comedi: ni_stc.h: remove unused members from struct ni_private
      staging: comedi: ni_stc.h: add read/write callbacks to struct ni_private
      staging: comedi: ni_stc.h: add a 'is_m_series' flag to private data
      staging: comedi: ni_stc.h: cleanup ni_e_series_enable_second_irq()
      staging: comedi: ni_mio_common.c: wrap the stc_read/write operations
      staging: comedi: ni_mio_common.c: wrap the read/write operations
      staging: comedi: ni_stc.h: remove read/write callbacks from ni_private
      staging: comedi: ni_stc.h: remove stc read/write callbacks from ni_private
      staging: comedi: ke_counter: expose clock source options to user space
      staging: comedi: introduce comedi_buf_n_bytes_ready()
      staging: comedi: dt282x: remove forward declarations
      staging: comedi: dt282x: move boardinfo declaration
      staging: comedi: dt282x: remove '= 0' boardinfo
      staging: comedi: dt282x: convert 'adbits' boardinfo to 'ai_maxdata'
      staging: comedi: dt282x: convert 'dabits' boardinfo to 'ao_maxdata'
      staging: comedi: dt282x: fix dt282x_ao_insn_write()
      staging: comedi: dt282x: remove 'volatile' on private data variables
      staging: comedi: dt282x: IRQ and DMA are needed for async command support
      staging: comedi: dt282x: remove DT2821_SIZE define
      staging: comedi: dt282x: convert private data flags to bit-fields
      staging: comedi: dt282x: remove unused chan_to_DAC() macro
      staging: comedi: dt282x: rename the prep_{ai,ao}_dma() functions
      staging: comedi: dt282x: tidy up Digital I/O subdevice init
      staging: comedi: dt282x: remove sanity checks of 's->async->prealloc_buf'
      staging: comedi: dt282x: tidy up dt282x_ao_dma_interrupt()
      staging: comedi: dt282x: tidy up dt282x_ai_dma_interrupt()
      staging: comedi: dt282x: fix dt282x_ao_insn_read()
      staging: comedi: dt282x: factor board initialization out of (*attach)
      staging: comedi: dt282x: remove the 'opt_*' enum
      staging: comedi: dt282x: tidy up Analog Output subdevice init
      staging: comedi: dt282x: tidy up Analog Input subdevice init
      staging: comedi: dt282x: fix Analog Input se/diff channel configuration
      staging: comedi: dt282x: cleanup analog output range table
      staging: comedi: dt282x: tidy up multi-line comments
      staging: comedi: dt282x: update the MODULE_DESCRIPTION
      staging: comedi: dt282x: avoid calculating the timer divisor multiple times
      staging: comedi: dt282x: tidy up the register map and bit defines
      staging: comedi: dt282x: fix bug where DIO direction is reset to inputs
      staging: comedi: dt282x: automatically handle D/A data format
      staging: comedi: s626: define CRA/CRB registers based on channel number
      staging: comedi: s626: add comedi "chan" number to struct s626_enc_info
      staging: comedi: s626: remove my_cr[ab] from encoder private data
      staging: comedi: s626: define S626_LP_CNTR* registers based on channel number
      staging: comedi: s626: remove my_latch_lsw from encoder private data
      staging: comedi: s626: remove 'set_enable' callback from encoder private data
      staging: comedi: s626: remove 'get_enable' callback from encoder private data
      staging: comedi: s626: remove 'set_load_trig' callback from encoder private data
      staging: comedi: s626: remove 'get_load_trig' callback from encoder private data
      staging: comedi: s626: remove 'set_int_src' callback from encoder private data
      staging: comedi: s626: remove 'get_int_src' callback from encoder private data
      staging: comedi: s626: remove 'pulse_index' callback from encoder private data
      staging: comedi: s626: remove 'reset_cap_flags' callback from encoder private data
      staging: comedi: s626: remove 'get_mode' callback from encoder private data
      staging: comedi: s626: remove 'set_mode' callback from encoder private data
      staging: comedi: s626: remove 'my_event_bits' from encoder private data
      staging: comedi: s626: tidy up s626_enc_insn_read()
      staging: comedi: s626: remove struct s626_enc_info
      staging: comedi: ni_pcimio: remove forward declarations
      staging: comedi: ni_mio_common.c: remove interrupt_pin() macros
      staging: comedi: ni_mio_common drivers: remove NI_E_IRQ_FLAGS defines
      staging: comedi: ni_mio_common.c: remove IRQ_POLARITY defines
      staging: comedi: ni_atmio: remove '= 0' boardinfo data
      staging: comedi: ni_atmio: remove NI_SIZE define
      staging: comedi: ni_mio_cs: remove NI_SIZE define
      staging: comedi: ni_atmio: tidy up the boardinfo
      staging: comedi: ni_stc.h: the boardinfo 'name' should be first
      staging: comedi: ni_pcimio: remove DRV_NAME define
      staging: comedi: ni_atmio: remove ATMIO and PCIMIO defines
      staging: comedi: ni_mio_cs: remove ATMIO and PCIMIO defines
      staging: comedi: ni_pcimio: remove ATMIO and PCIMIO defines
      staging: comedi: mite.h: remove mite_irq()
      staging: comedi: mite.h: remove mite_device()
      staging: comedi: mite: cleanup mite_unsetup()
      staging: comedi: 8255_pci: remove include of mite.h
      staging: comedi: ni_labpc_pci: remove COMEDI_MITE and HAS_DMA dependancy
      staging: comedi: ni_65xx: remove COMEDI_MITE and HAS_DMA dependancy
      staging: comedi: ni_670x: remove COMEDI_MITE and HAS_DMA dependancy
      staging: comedi: ni_65xx: filter interval register is 32-bit
      staging: comedi: ni_65xx: cleanup non-recurring register map defines
      staging: comedi: ni_65xx: cleanup recurring register map
      staging: comedi: ni_65xx: cleanup INSN_CONFIG_FILTER handling
      staging: comedi: ni_65xx: remove 'dio_direction' from private data
      staging: comedi: ni_65xx: remove the need for the subdevice private data
      staging: comedi: ni_65xx: hook up command support only if irq is available
      staging: comedi: ni_65xx: fix ni_65xx_intr_insn_config()
      staging: comedi: ni_65xx: tidy up the port<->chan conversions
      staging: comedi: ni_65xx: tidy up the subdevice initialization
      staging: comedi: ni_65xx: tidy up the comedi_driver declaration
      staging: comedi: ni_65xx: clean up multi-line comments
      staging: comedi: ni_65xx: update the MODULE_DESCRIPTION
      staging: comedi: ni_65xx: tidy ni_65xx_intr_insn_bits() declaration
      staging: comedi: ni_65xx: remove 'output_bits' from private data
      staging: comedi: ni_65xx: use the subdevice 'io_bits' to handle the 'invert_outputs'
      staging: comedi: ni_65xx: fix digital output reset during attach
      staging: comedi: ni_65xx: factor input filter disable out of (*auto_attach)
      staging: comedi: mite.h: tidy up the mite channel register offsets
      staging: comedi: comedidev.h: introduce some 'range_is_external' helpers
      staging: comedi: ni_stc.h: remove 'ao_unipolar' flag from ni_board_struct
      staging: comedi: ni_mio_common: fix ni_ao_insn_write_671x()
      staging: comedi: ni_mio_common: remove ao_win_out() macro
      staging: comedi: ni_mio_common: fix ni_ao_insn_write()
      staging: comedi: ni_stc.h: add some 'is_{board type}' flags to private data
      staging: comedi: ni_mio_common: tidy up ni_ao_munge()
      staging: comedi: ni_mio_common: remove INSN_CONFIG_ANALOG_TRIG support code
      staging: comedi: ni_mio_common: remove some unnecessary boardinfo access
      staging: comedi: ni_mio_common: merge analog output (*insn_write) functions
      staging: comedi: ni_mio_common: remove ai_continuous from private data
      staging: comedi: ni_mio_common: fix ni_ao_insn_read()
      staging: comedi: ni_mio_common: remove unnecessary use of 'board->adbits'
      staging: comedi: ni_stc.h: refactor 'adbits' boardinfo
      staging: comedi: ni_stc.h: refactor 'aobits' boardinfo
      staging: comedi: ni_mio_common: (*cancel) only works with async cmd support
      staging: comedi: ni_mio_common: tidy up the Analog Input subdevice init
      staging: comedi: ni_mio_common: tidy up the Analog Output subdevice init
      staging: comedi: ni_mio_common: refactor 'num_p0_dio_channels' boardinfo
      staging: comedi: ni_mio_common: tidy up the Digital I/O subdevice init
      staging: comedi: ni_mio_common: init clock dividers early in ni_E_init()
      staging: comedi: ni_mio_common: only reset the ai/ao subdevices if they exist
      staging: comedi: ni_mio_common: tidy up the calibration subdevice init
      staging: comedi: ni_mio_common: tidy up the EEPROM subdevice init
      staging: comedi: ni_mio_common: tidy up the PFI subdevice init
      staging: comedi: ni_mio_common: tidy up the gpct counter subdevice init
      staging: comedi: ni_mio_common: tidy up the frequency output subdevice init
      staging: comedi: 8255_pci: checkpatch.pl cleanup (else after return)
      staging: comedi: 8255: checkpatch.pl cleanup (else after return)
      staging: comedi: addi_apci_3xxx: checkpatch.pl cleanup (else after return)
      staging: comedi: amplc_dio200_common: checkpatch.pl cleanup (else after return)
      staging: comedi: amplc_pc236: checkpatch.pl cleanup (else after return)
      staging: comedi: amplc_pci224: checkpatch.pl cleanup (else after return)
      staging: comedi: cb_pcidas64: checkpatch.pl cleanup (else after return)
      staging: comedi: daqboard2000: checkpatch.pl cleanup (else after return)
      staging: comedi: dt282x: checkpatch.pl cleanup (else after return)
      staging: comedi: pcl724: checkpatch.pl cleanup (else after return)
      staging: comedi: das1800: checkpatch.pl cleanup (break not useful)
      staging: comedi: ni_at_a2150: checkpatch.pl cleanup (break not useful)
      staging: comedi: s526: checkpatch.pl cleanup (break not useful)
      staging: comedi: cb_pcidas64: checkpatch.pl cleanup (break not useful)
      staging: comedi: cb_pcidas: checkpatch.pl cleanup (break not useful)
      staging: comedi: ni_660x: checkpatch.pl cleanup (break not useful)
      staging: comedi: ni_660x: checkpatch.pl cleanup (else not useful)
      staging: comedi: s626: checkpatch.pl cleanup (else not useful)
      staging: comedi: ni_mio_common: checkpatch.pl cleanup (break not useful)
      staging: comedi: ni_mio_common: checkpatch.pl cleanup (else not useful)
      staging: comedi: usbdux: checkpatch.pl cleanup (else not useful)
      staging: comedi: usbduxsigma: checkpatch.pl cleanup (else not useful)
      staging: comedi: ni_tio: checkpatch.pl cleanup (break is not useful)
      staging: comedi: ni_tio: checkpatch.pl cleanup (else is not useful)
      staging: comedi: ni_tiocmd: checkpatch.pl cleanup (break is not useful)
      staging: comedi: ni_labpc: checkpatch.pl cleanup (else is not useful)
      staging: comedi: das08: checkpatch.pl cleanup (break is not useful)
      staging: comedi: ni_tio_internal.c: checkpatch.pl cleanup (break is not useful)
      staging: comedi: mite.h: tidy up mite_csigr_wpdep()
      staging: comedi: 8253.h: checkpatch.pl cleanup (void function return)
      staging: comedi: adv_pci1723: checkpatch.pl cleanup (missing blank line)
      staging: comedi: amplc_pc236: checkpatch.pl cleanup (missing blank line)
      staging: comedi: amplc_pci230: checkpatch.pl cleanup (void function return)
      staging: comedi: cb_pcidas64: checkpatch.pl cleanup (missing blank line)
      staging: comedi: cd_pcidas64: checkpatch.pl cleanup (void function return)
      staging: comedi: das16: checkpatch.pl cleanup (missing blank line)
      staging: comedi: das1800: checkpatch.pl cleanup (void function return)
      staging: comedi: dt2815: checkpatch.pl cleanup (missing blank line)
      staging: comedi: dt9812: checkpatch.pl cleanup (missing blank line)
      staging: comedi: jr3_pci: checkpatch.pl cleanup (missing blank line)
      staging: comedi: comedi_test: checkpatch.pl cleanup (break is not useful)
      staging: comedi: serial2000: checkpatch.pl cleanup (missing blank line)
      staging: comedi: serial2000: reduce indent level of serial2002_setup_subdevs()
      staging: comedi: ni_at_a2150: checkpatch.pl cleanup (missing blank line)
      staging: comedi: pcmuio: checkpatch.pl cleanup (missing blank line)
      staging: comedi: multiq3: checkpatch.pl cleanup (missing blank line)
      staging: comedi: ni_660x: checkpatch.pl cleanup (missing blank line)
      staging: comedi: ni_pcidio: checkpatch.pl cleanup (missing blank line)
      staging: comedi: ni_mio_common: checkpatch.pl cleanup (missing blank line)
      staging: comedi: mite: checkpatch.pl cleanup (missing blank line)
      staging: comedi: ni_tio: checkpatch.pl cleanup (missing blank line)
      staging: comedi: adv_pci_dio: checkpatch.pl cleanup (missing blank line)
      staging: comedi: adv_pci_dio: checkpatch.pl cleanup (fallthrough)
      staging: comedi: amcc_s5933.h: checkpatch.pl cleanup (space prohibited)
      staging: comedi: cb_pcidas64: remove 'volatile' from private data
      staging: comedi: cb_pcidas64: remove 'volatile' from set_dac_range_bits() param
      staging: comedi: daqboard2000: checkpatch.pl cleanup (space before tab)
      staging: comedi: das16m1: remove 'volatile' from private data
      staging: comedi: das1800: remove 'volatile' from private data
      staging: comedi: me4000: checkpatch.pl cleanup (complex macro)
      staging: comedi: serial2000: checkpatch.pl cleanup (kmalloc_array)
      staging: comedi: pcl724: checkpatch.pl cleanup (foo*/foo *)
      staging: comedi: ni_660x: checkpatch.pl cleanup (trailing whitespace)
      staging: comedi: ni_660x: checkpatch.pl cleanup (space prohibited)
      staging: comedi: ni_mio_common: checkpatch.pl cleanup (braces not necessary)
      staging: comedi: ni_tio: checkpatch.pl cleanup (braces not necessary)
      staging: comedi: ni_labpc.h: checkpatch.pl cleanup (unnecessary space)
      staging: comedi: ni_670x: fix compile on ARCH=arm
      staging: comedi: s626: remove use of comedi_error()
      staging: comedi: pcl818: remove use of comedi_error()
      staging: comedi: pcl816: remove use of comedi_error()
      staging: comedi: pcl711: remove use of comedi_error()
      staging: comedi: ni_pcidio: remove use of comedi_error()
      staging: comedi: ni_mio_common: remove use of comedi_error()
      staging: comedi: ni_labpc: remove use of comedi_error()
      staging: comedi: ni_at_a2150: remove use of comedi_error()
      staging: comedi: ni_660x: remove use of comedi_error()
      staging: comedi: cb_pcidas64: remove use of comedi_error()
      staging: comedi: icp_multi: remove use of comedi_error()
      staging: comedi: dt282x: remove use of comedi_error()
      staging: comedi: dt2814: remove use of comedi_error()
      staging: comedi: dmm32at: remove use of comedi_error()
      staging: comedi: das1800: remove use of comedi_error()
      staging: comedi: das16m1: remove use of comedi_error()
      staging: comedi: das08: remove use of comedi_error()
      staging: comedi: comedi_test: remove use of comedi_error()
      staging: comedi: cb_pcidas: remove use of comedi_error()
      staging: comedi: amplc_pci230: remove use of comedi_error()
      staging: comedi: amplc_dio_common: remove use of comedi_error()
      staging: comedi: adv_pci_dio: remove use of comedi_error()
      staging: comedi: adv_pci1724: remove use of comedi_error()
      staging: comedi: adl_pci9118: remove use of comedi_error()
      staging: comedi: addi_apci_3501: remove use of comedi_error()
      staging: comedi: hwdrv_apci3120: remove use of comedi_error()
      staging: comedi: hwdrv_apci1564: remove use of comedi_error()
      staging: comedi: hwdrv_apci1500: remove use of comedi_error()
      staging: comedi: remove comedi_error()
      staging: comedi: usbduxfast: convert pr_err() to dev_err()
      staging: comedi: usbduxfast: convert pr_warn() to dev_warn()
      staging: comedi: cb_pcidas64: remove unused pr_fmt() macro
      staging: comedi: ni_labpc: tidy up labpc_ai_scan_mode()
      staging: comedi: comedi_fops: use pr_fmt()
      staging: comedi: ni_mio_common: convert printk messages to dev_err
      staging: comedi: ni_mio_common: consolidate call to ni_mseries_get_pll_parameters()
      staging: comedi: ni_atmio: remove board attach noise
      staging: comedi: ni_atmio: convert printk to dev_err in ni_getboardtype()
      staging: comedi: ni_at_a2150: convert printk to dev_err
      staging: comedi: das1800: tidy up das1800_probe()
      staging: comedi: comedi_fops: remove commented out debug messages
      staging: comedi: hwdrv_apci3200: remove disabled PRINT_INFO debug
      staging: comedi: ni_atmio: remove printk noise in ni_isapnp_find_board()
      staging: comedi: hwdrv_apci3200: remove commented out printk messages
      staging: comedi: hwdrv_apci3120: cleanup printk messages
      staging: comedi: comedi_compat32: checkpatch.pl --strict cleanup
      staging: comedi: drivers.c: checkpatch.pl --strict cleanup
      staging: comedi: comedi_internal.h: checkpatch.pl --strict cleanup
      staging: comedi: comedi.h: checkpatch.pl --strict cleanup
      staging: comedi: comedi_fops: checkpatch.pl --strict cleanup
      staging: comedi: comedidev.h: checkpatch.pl --strict cleanup
      staging: comedi: comedi_compat32.h: checkpatch.pl --strict cleanup
      staging: comedi: drivers: cleanup cmd->flags use
      staging: comedi: ni_at_a2150: remove forward declarations
      staging: comedi: ni_pcidio: remove forward declarations
      staging: comedi: pcm3724: use default (*io) callback from 8255 module
      staging: comedi: pcl816: remove forward declaration
      staging: comedi: drivers: remove unnecessary PCI_DEVICE_ID_* defines
      staging: comedi: drivers: remove unnecessary *_SIZE defines
      staging: comedi: drivers: remove unnecessary DRIVER_NAME defines
      staging: comedi: drivers: use dev->board_name in request_irq()
      staging: comedi: drivers: remove unnecessary *_{IO, MEM}SIZE defines
      staging: comedi: comedi_fops: remove disabled subdevice lock/unlock callback
      staging: comedi: comedidev.h: remove unused callbacks from comedi_subdevice
      staging: comedi: comedidev.h: remove 'new_size' param from subdevice (*buf_change)
      staging: comedi: ni_tio: fix ni_tio_insn_read()
      staging: comedi: ni_tio: fix > 80 char comments
      staging: comedi: ni_tio: tidy up some function declarations
      staging: comedi: ni_tio: remove unnecessary ni_gpct_variant BUG() cases
      staging: comedi: ni_tio: tidy up ni_660x_set_second_gate()
      staging: comedi: ni_tio: tidy up ni_m_series_set_first_gate()
      staging: comedi: ni_tio: tidy up ni_660x_set_first_gate()
      staging: comedi: ni_tio: convert NI_M_Series_RTSI_Clock() to a macro
      staging: comedi: ni_tio: convert NI_M_Series_PFI_Clock() to a macro
      staging: comedi: ni_tio: convert NI_660x_Gate_Pin_Gate_Select() to a macro
      staging: comedi: ni_tio: convert NI_660x_RTSI_Gate_Select() to a macro
      staging: comedi: ni_tio: convert NI_M_Series_RTSI_Gate_Select() to a macro
      staging: comedi: ni_tio: convert NI_M_Series_PFI_Gate_Select() to a macro
      staging: comedi: ni_tio: convert NI_660x_Source_Pin_Clock() to a macro
      staging: comedi: ni_tio: convert NI_660x_RTSI_Clock() to a macro
      staging: comedi: ni_tio: convert NI_660x_RTSI_Second_Gate_Select() to a macro
      staging: comedi: ni_tio: convert NI_660x_Up_Down_Pin_Second_Gate_Select() to a macro
      staging: comedi: ni_tio: convert global static const variables to defines
      staging: comedi: ni_tio: remove counter_status_mask
      staging: comedi: ni_tio: tidy up enum ni_660x_second_gate_select
      staging: comedi: ni_tio: tidy up enum ni_m_series_gate_select
      staging: comedi: ni_tio: tidy up enum ni_660x_gate_select
      staging: comedi: ni_tio: tidy up enum ni_m_series_clock_source
      staging: comedi: ni_tio: tidy up enum ni_660x_clock_source
      staging: comedi: ni_tio: move defines to head of file
      staging: comedi: ni_tio: tidy up ni_gpct_device_{construct,destroy)()
      staging: comedi: ni_tio: tidy up ni_tio_init_counter()
      staging: comedi: ni_tio: rename ni_tio_second_gate_registers_present()
      staging: comedi: ni_tio: tidy up ni_m_series_source_select_bits()
      staging: comedi: ni_tio: tidy up ni_660x_source_select_bits()
      staging: comedi: ni_tio: tidy up ni_tio_set_sync_mode()
      staging: comedi: ni_tio: absorb ni_tio_counter_status()
      staging: comedi: ni_tio: tidy up ni_tio_get_gate_src() and helpers
      staging: comedi: ni_tio: tidy up ni_tio_set_other_src()
      staging: comedi: ni_tio: tidy up ni_tio_set_gate_src() and helpers
      staging: comedi: ni_tio: absorb ni_tio_set_first_gate_modifiers()
      staging: comedi: ni_tio: tidy up ni_tio_get_clock_src()
      staging: comedi: ni_tio: tidy up ni_tio_set_clock_src() and helpers
      staging: comedi: ni_tio: remove forward declarations
      staging: comedi: ni_tio: convert printk to pr_err
      staging: comedi: ni_tio: tidy up ni_tio_read_sw_save_reg()
      staging: comedi: ni_tio: tidy up Gi_Counting_Mode_Reg_Bits
      staging: comedi: ni_tio: tidy up Gi_Command_Reg_Bits
      staging: comedi: ni_tio: tidy up Gi_Auto_Increment_Reg_Bits
      staging: comedi: ni_tio: tidy up Gi_Input_Select_Bits
      staging: comedi: ni_tio: tidy up Gi_Mode_Bits
      staging: comedi: ni_tio: tidy up Gi_Second_Gate_Bits
      staging: comedi: ni_tio: tidy up Gxx_Status_Bits
      staging: comedi: ni_tio: tidy up Gi_Reset_Bit
      staging: comedi: ni_tio: tidy up Gxx_Joint_Status2_Bits
      staging: comedi: ni_tio: tidy up Gi_DMA_Config_Reg_Bits
      staging: comedi: ni_tio: tidy up Gi_DMA_Status_Reg_Bits
      staging: comedi: ni_tio: tidy up Gxx_Interrupt_Acknowledge_Bits
      staging: comedi: ni_tio: tidy up Gi_Status_Bits
      staging: comedi: ni_tio: tidy up G{02, 12}_Interrupt_Enable_Bits
      staging: comedi: ni_tiocmd: tidy up ni_tio_configure_dma()
      staging: comedi: ni_tiocmd: tidy up ni_tio_input_inttrig()
      staging: comedi: ni_tiocmd: tidy up ni_tio_input_cmd()
      staging: comedi: ni_tiocmd: introduce ni_tio_acknowledge()
      staging: comedi: add an 'mmio' member to comedi_device
      staging: comedi: 8255_pci: use the comedi_device 'mmio' member
      staging: comedi: ni_65xx: use the comedi_device 'mmio' member
      staging: comedi: gsc_hpdi: use the comedi_device 'mmio' member
      staging: comedi: me_daq: use the comedi_device 'mmio' member
      staging: comedi: mf6x4: use the comedi_device 'mmio' member
      staging: comedi: icp_multi: use the comedi_device 'mmio' member
      staging: comedi: addi_apci_3xxx: use the comedi_device 'mmio' member
      staging: comedi: daqboard2000: use the comedi_device 'mmio' member
      staging: comedi: dt3000: use the comedi_device 'mmio' member
      staging: comedi: ni_6527: use the comedi_device 'mmio' member
      staging: comedi: ni_6527: iounmap resource when detached
      staging: comedi: ni_670x: use the comedi_device 'mmio' member
      staging: comedi: cb_pcidas64: use the comedi_device 'mmio' member
      staging: comedi: rtd520: use the comedi_device 'mmio' member
      staging: comedi: s626: use the comedi_device 'mmio' member
      staging: comedi: mite: inline mite_setup()
      staging: comedi: mite: pass comedi_device to mite_setup()
      staging: comedi: mite: use the comedi_device 'mmio' member
      staging: comedi: ni_labpc: pass comedi_device to the I/O callbacks
      staging: comedi: ni_labpc: don't pass dev->iobase to labpc_counter_load()
      staging: comedi: ni_labpc: don't pass dev->iobase to labpc_counter_set_mode()
      staging: comedi: ni_labpc: refactor labpc_8255_mmio()
      staging: comedi: ni_labpc: use the comedi_device 'mmio' member
      staging: comedi: ii_pci20kc: use the comedi_device 'mmio' member
      staging: comedi: amplc_dio200: use the comedi_device 'mmio' member

Hartmut Knaack (5):
      staging:iio:ad7291 remove double define
      staging:iio:ad7291 fix coding style
      staging:iio:ad7291 cleanup defines
      staging:iio:ad7291 faciliate ad7291_read_event_config()
      staging:iio:ad7291 define alert register bits

Heesub Shin (5):
      staging: ion: remove order from struct page_info
      staging: ion: remove struct page_info
      staging: ion: remove order argument from free_buffer_page()
      staging: ion: optimize struct ion_system_heap
      staging: ion: fixup invalid kfree() calls on heap destroy

Himangi Saraogi (7):
      Staging: rtl8192e: adjust error handling
      staging: wlags49_h2: Fix use of skb after netif_rx
      staging: iio: Introduce the use of devm_ioremap_resource
      iio:trigger: Introduce the use of devm_kzalloc
      staging: goldfish: Introduce the use of managed interfaces
      devres: Add devm_kasprintf and devm_kvasprintf API
      staging: gdm724x: Use NLMSG_HDRLEN

Hoang Tran (1):
      staging: goldfish: fix coding style.

Honggang Li (2):
      lustre/osc/osc_dev.c remove space between sizeof and open parenthesis
      lustre/osc/osc_dev.c add a blank line after declarations

Ian Abbott (52):
      staging: comedi: ni_daq_700: update driver comment
      staging: comedi: describe struct comedi_async
      staging: comedi: allow COMEDI_BUFINFO, COMEDI_CANCEL and COMEDI_POLL on locked subdevice
      staging: comedi: vmk80xx: remove MODULE_VERSION() from in-kernel module
      staging: comedi: ni_daq_700: remove MODULE_VERSION() and commentary
      staging: comedi: ni_65xx: don't invert outputs by default
      staging: comedi: ni_6527: support INSN_CONFIG_DIGITAL_TRIG
      staging: comedi: ni_6527: reset edge detection registers
      staging: comedi: ni_65xx: add ni_65xx_num_ports()
      staging: comedi: ni_65xx: refactor edge detection configuration
      staging: comedi: ni_65xx: support INSN_CONFIG_DIGITAL_TRIG
      staging: comedi: ni_65xx: disable edge detection on initialization
      staging: comedi: amplc_pc236: reformat header comments
      staging: comedi: amplc_pc236: remove some boilerplate comments
      staging: comedi: amplc_pc236: remove manual configuration of PCI boards
      staging: comedi: amplc_pc236: no need to manipulate PCI ref count
      staging: comedi: amplc_pc236: no need to set hw_dev
      staging: comedi: amplc_pc236: absorb pc236_pci_common_attach()
      staging: comedi: amplc_pc236: remove 'model' member
      staging: comedi: amplc_pc236: split pc236_boards[] into ISA & PCI
      staging: comedi: amplc_pc236: don't check bus type in attach
      staging: comedi: amplc_pc236: Simplify PCI board look-up
      staging: comedi: amplc_pc236: remove PCI device ID macros
      staging: comedi: amplc_pc236: set board_name before common attach
      staging: comedi: amplc_dio200_common: prevent extra free_irq()
      staging: comedi: amplc_dio200_common: remove some tests from amplc_dio200_common_detach()
      staging: comedi: amplc_dio200_pci: no need to test board pointer in dio200_pci_detach()
      staging: comedi: amplc_pc236: move static board data
      staging: comedi: amplc_pc236: don't disable h/w interrupt on detach()
      staging: comedi: amplc_pc236: add callback to enable/disable interrupt
      staging: comedi: amplc_pc236: combine interrupt enable/disable functions
      staging: comedi: amplc_pc236: add callback to check and clear interrupt
      staging: comedi: amplc_pc236: split into ISA, PCI and common module
      staging: comedi: amplc_pc236, amplc_pci236: get rid of bustype
      staging: comedi: amplc_pci230: reformat a load of comments
      staging: comedi: amplc_pci230: fix checkpatch line over 80 characters
      staging: comedi: amplc_pci230: logical continuations should be on the previous line
      staging: comedi: amplc_pci230: blank lines aren't necessary before a close brace '}'
      staging: comedi: amplc_pci230: alignment should match open parenthesis
      staging: comedi: amplc_pci230: usleep_range is preferred over udelay
      staging: comedi: amplc_pci230: remove unused settling time constants
      staging: comedi: amplc_pci230: remove PCI230_ADC_CONV
      staging: comedi: amplc_pci230: remove PCI230_TEST_BIT()
      staging: comedi: amplc_pci230: add whitespace to register values
      staging: comedi: amplc_pci230: don't begin line with binary operator
      staging: comedi: amplc_pci230: omit '!= 0' from logical expressions
      staging: comedi: amplc_pci230: remove some indentation in pci230_ai_check_chanlist()
      staging: comedi: amplc_pci230: no need for '&function'
      staging: comedi: amplc_pci230: add whitespace to pci230_boards[]
      staging: comedi: amplc_pci230: no need to initialize named members to zero
      staging: comedi: amplc_pci230: tidy up stuct pci230_private
      staging: comedi: ii_pci20kc: request and ioremap memory

Igor Bezukh (22):
      Staging: vt6655: fix missing blank line after variable declaration
      Staging: vt6655: Remove redundant comments in wcmd.h
      Staging: vt6655: removed redundant comments from aes_ccmp.h
      Staging: vt6655: Removed redundant comments and newlines
      Staging: vt6655: remove redundant comments from 80211hdr.h
      Staging: vt6655: remove redundant comments from baseband.h
      Staging: vt6655: remove redundant comments from bssdb.h
      Staging: vt6655: remove redundant comments from card.h
      Staging: vt6655: removed redundant comments from datarate.h
      Staging: vt6655: removed redundant comments from country.h
      Staging: vt6655: removed redundant comments from channel.h
      Staging: vt6655: removed redundant comments from desc.h
      Staging: vt6655: removed redundant comments from device_cfg.h
      Staging: vt6655: removed redundant comments from dpc.h
      Staging: vt6655: removed redundant comments from hostap.h
      Staging: vt6655: removed redundant comments from IEEE11h.h
      Staging: vt6655: removed redundant comments from iocmd.h
      Staging: vt6655: removed redundant comments from ioctl.h
      Staging: vt6655: removed redundant comments from iowpa.h
      Staging: vt6655: removed redundant comments from mib.h
      Staging: vt6655: removed redundant comments from michael.h
      Staging: vt6655: removed redundant comments from power.h

Isaac Huang (1):
      staging/lustre/lnet: abort messages whose MD has been unlinked

James A Shackleford (25):
      staging: vt6655: fix sparse warning "cast removes address space of expression"
      staging: vt6655: fix sparse warning for static declarations
      staging: vt6655: update out-of-date function declaration
      staging: vt6655: update iwctl_private_args extern declaration
      staging: vt6655: fix sparse warning for static declarations
      staging: vt6655: replace C99 style comments
      staging: skein: fix sparse warning for static arrays
      staging: lustre: fix sparse warnings for static symbols
      staging: vt6655: remove header declarations for static functions
      staging: rtl8712: remove inline _RND8() and use round_up()
      staging: rtl8712: remove inline _RND128() and use round_up()
      staging: rtl8712: remove unused inline _RND256()
      staging: rtl8712: remove unused inline _RND512()
      staging: rtl8712: remove wrapper function _init_listhead
      staging: rtl8712: remove wrapper function is_list_empty
      staging: rtl8712: remove wrapper function list_insert_tail
      staging: rtl8712: remove wrapper function list_delete
      staging: rtl8712: remove wrapper function get_next
      staging: rtl8712: remove function get_list_head
      staging: rtl8712: remove wrapper function _queue_empty
      staging: rtl8712: remove inapplicable comment
      staging: rtl8712: remove wrapper function _init_workitem()
      staging: rtl8712: remove wrapper function _set_workitem()
      staging: rtl8712: remove #define _workitem struct work_struct
      staging: rtl8712: remove wrapper function thread_enter()

Jeff Oczek (3):
      staging: tidspbridge: Add parameter names to function ptrs in struct dbll_attrs
      staging: tidspbridge: Fix whitespace for pointers in function headers
      staging: rtl8188eu: Fix static symbol sparse warnings

Jeremiah Mahler (1):
      staging: dgnc: DGNC_VERIFY_BOARD macro in do while block

Jerry Stralko (1):
      staging: android: logger: fixed checkpatch.pl warnings.

Jes Sorensen (237):
      staging: rtl8723au: rtw_get_wps_ie23a(): Remove unused dest pointer wps_ie
      staging: rtl8723au: rtw_mlme_ext.c: Convert rtw_get_wps_ie23a() to cfg80211_find_vendor_ie()
      staging: rtl8723au: rtw_mlme.c: Convert rtw_get_wps_ie23a() to cfg80211_find_vendor_ie()
      staging: rtl8723au: ioctl_cfg80211.c: Convert rtw_get_wps_ie23a() to cfg80211_find_vendor_ie()
      staging: rtl8723au: rtw_ap.c: Convert from rtw_get_wps_ie23a() to cfg80211_find_vendor_ie()
      staging: rtl8723au: Remove obsolete rtw_get_wps_ie23a()
      staging: rtl8723au: Request correct firmware file for A-cut parts
      staging: rtl8723au: Reference correct firmwarefiles with MODULE_FIRMWARE()
      staging: rtl8723au: rtw_mlme_ext.c: Fix up some of the bad formatting
      staging: rtl8723au: rtw_mlme.c: Remove some tab and parenthesis abuse
      staging: rtl8723au: Use struct ieee80211_mcs_info to describe MCS information
      staging: rtl8723au: Use struct ieee80211_ht_cap and associated #defines
      staging: rtl8723au: Use correct struct for WLAN_EID_HT_CAPABILITY
      staging: rtl8723au: Eliminate struct HT_info_element
      staging: rtl8723au: Don't carry ht_cap_info and ht_param in struct wlan_bcn_info
      staging: rtl8723au: rtw_check_bcn_info23a(): Use capability bit define
      staging: rtl8723au: Remmove buddy-adapter linking
      staging: rtl8723au: Rewrite update_beacon23a_info() tto use cfg80211_find_ie()
      staging: rtl8723au: collect_bss_info23a(): Collect beacon_interval correct
      staging: rtl8723au: collect_bss_info23a(): ieee80211_mgmt capab_info is little endian
      staging: rtl8723au: rtw_update_ht_cap23a(): Use correct mask when determining 40MHz channel location
      staging: rtl8723au: rtw_get_bcn_info23a(): Use cfg80211_* to obtain crypto info
      staging: rtl8723au: rtw_wlan_util.c: Use cfg80211_* to determine crypto
      staging: rtl8723au: Remove obsolete rtw_get_sec_ie23a()
      staging: rtl8723au: Declare rtw_get_wpa{2, }_cipher_suite() static
      staging: rtl8723au: Make WMM_param_handler23a() and HT_caps_handler23a() take a const u8 *
      staging: rtl8723au: OnAssocRsp23a(): Use cfg80211_* to parse IEs
      staging: rtl8723au: Remove WMM_ defines
      staging: rtl8723au: Make struct ht_priv.ht_option a bool
      staging: rtl8723au: Be consistent in how htpriv.ht_option is checked
      staging: rtl8723au: Make struct htpriv.ampdu_enable a bool
      staging: rtl8723au: issue_auth(): Convert to using struct ieee80211_mgmt
      staging: rtl8723au: issue_assocrsp(): Use struct ieee80211_mgmt instead of rtw_set_fixed_ie23a()
      staging: rtl8723au: _issue_deauth(): Use struct ieee80211_mgmt to build frame
      staging: rtl8723au: issue_action_spct_ch_switch23a(): Use struct ieee80211_mgmt
      staging: rtl8723au: issue_action_BSSCoexistPacket(): Use struct ieee80211_mgmt
      staging: rtl8723au: Do not xmit BSS Coexistence management action frames
      staging: rtl8723au: Let cfg80211 handle public action management frames
      staging: rtl8723au: ioctl_cfg80211.c: Use struct ieee80211_mgmt to build mgmt frame
      staging: rtl8723au: issue_action_BA23a(): Use struct ieee80211_mgmt to build action frames
      staging: rtl8723au: Remove obsolete rtw_set_fixed_ie23a()
      staging: rtl8723au: Remove duplicate defines of IEEE80211_HT_PARAM_CHA_SEC_*
      staging: rtl8723au: Remove unused #defines WEP_KEY_LEN and MGMT_QUEUE_NUM
      staging: rtl8723au: Remove some unused 80211 header parsing macros
      staging: rtl8723au: rtw_check_bcn_info23a(): Use ether_addr_equal() to check BSSID
      staging: rtl8723au: rtw_check_bcn_info23a(): Don't make a local copy of beacon just to parse it
      staging: rtl8723au: rtw_check_bcn_info23a(): Don't search for WPA/WPA2 info twice
      staging: rtl8723au: Declare rtw_update_scanned_network() static
      staging: rtl8723au: rtw_survey_event_cb23a(): Use the correct types for the received arguments
      staging: rtl8723au: Do not embed struct wlan_bssid_ex in struct survey_event
      staging: rtl8723au: Allocate struct wlan_bssid_ex in collect_bss_info()
      staging: rtl8723au: collect_bss_info(): Don't memset() what we just kzalloc()'d
      staging: rtl8723au: free_scanqueue(): Use _rtw_free_network23a()
      staging: rtl8723au: rtw_stadel_event_callback23a(): Remove superfluous memset()
      staging: rtl8723au: OnAuth23a(): Use ether_addr_copy()
      staging: rtl8723au: Get rid of IW_ESSID_MAX_SIZE
      staging: rtl8723au: Make rtw_is_same_ibss23a() return bool
      staging: rtl8723au: cfg80211_rtw_connect(): Check correct return value from rtw_set_802_11_ssid23a()
      staging: rtl8723au: Fold rtw_set_802_11_authentication_mode23a() into cfg80211_rtw_connect()
      staging: rtl8723au: Move rtw_set_802_11_ssid23a() to ioctl_cfg80211.c
      staging: rtl8723au: cfg80211_rtw_connect(): Clean up various bits
      staging: rtl8723au: cfg80211_rtw_connect(): Remove obfuscating pointers
      staging: rtl8723au: cfg80211_rtw_connect(): Simplify ssid preparation
      staging: rtl8723au: Pass a struct wlan_network to rtw_set_ssid()
      staging: rtl8723au: rtw_set_ssid(): This is never called with _FW_UNDER_LINKING
      staging: rtl8723au: rtw_cfg80211_add_wep(): Use WLAN_KEY_LEN_*
      staging: rtl8723au: rtw_do_join23a(): Use correct error return values
      staging: rtl8723au: Minor debug message fixup
      staging: rtl8723au: Don't prepend debug console messages with 'ERROR '
      staging: rtl8723au: Introduce rtw_select_candidate_from_queue()
      staging: rtl8723au: Introduce rtw_do_join_network()
      staging: rtl8723au: rtw_do_join23a(): Use __func__ to get function name in debug messages
      staging: rtl8723au: rtw_surveydone_event_callback23a(): Remove superfluous memset()
      staging: rtl8723au: Consolidate duplicate adhoc joining code into rtw_do_join_adhoc()
      staging: rtl8723au: Remove no-op rtw_get_encrypt_decrypt_from_registrypriv23a()
      staging: rtl8723au: to_join will no be true if _FW_LINKED is set
      staging: rtl8723au: rtw_surveydone_event_callback23a(): We always set _FW_UNDER_LINKING
      staging: rtl8723au: rtw_select_and_join_from_scanned_queue23a() never returns 2
      staging: rtl8723au: rtw_set_ssid(): Use rtw_do_join_network()
      staging: rtl8723au: rtw_do_join23a(): Don't start scanning if network isn't found
      staging: rtl8723au: Move rtw_do_join23a() to rtw_mlme.c and declare it static
      staging: rtl8723au: rtw_get_cur_max_rate23a(): Remove duplicate fwstate checks
      staging: rtl8723au: rtw_get_cur_max_rate23a(): We are in N mode if WLAN_EID_HT_CAPABILITY is present
      staging: rtl8723au: Move rtw_get_cur_max_rate23a() to ioctl_cfg80211.c
      staging: rtl8723au: rtw_set_802_11_bssid23a_list_scan(): Use __func__ to print function name
      staging: rtl8723au: Don't run regular scans in the driver, the stack handles that
      staging: rtl8723au: Quiet unused variable warning when building with CONFIG_8723AU_AP_MODE=n
      staging: rtl8723au: Move FillH2CCmd() prototype to rtl8723a_cmd.h where it really belongs
      staging: rtl8723au: rtw_cfg80211_set_wpa_ie(): Avoid pointless memcpy
      staging: rtl8723au: rtw_cfg80211_inform_bss(): timestamp isn't used
      staging: rtl8723au: rtw_cfg80211_inform_bss(): Use cfg80211_inform_bss()
      staging: rtl8723au: Save timestamp for network in collect_bss_info() and report it to the stack
      staging: rtl8723au: rtw_cfg80211_inform_bss(): Report the beacon interval already retrieved
      staging: rtl8723au: collect_bss_info(): Save capability in struct wlan_bssid_ex
      staging: rtl8723au: rtw_cfg80211_inform_bss(): Use the capability info we already saved
      staging: rtl8723au: struct wlan_bssid_ex: Rename BeaconPeriod to beacon_interval
      staging: rtl8723au: rtw_add_beacon(): Replace magic constant with appropriate struct size
      staging: rtl8723au: Update bss beacon info in rtw_add_beacon()
      staging: rtl8723au: is_same_network23a(): Use the capability info from wlan_bssid_ex
      staging: rtl8723au: ConstructBeacon(): Use struct ieee80211_mgmt to build beacon
      staging: rtl8723au: issue_beacon23a(): Do not copy IEs in front of beacon data
      staging: rtl8723au: issue_beacon23a(): Use struct ieee80211_mgmt to build beacon
      staging: rtl8723au: issue_probersp(): Do not copy the IEs in front of probe_resp data
      staging: rtl8723au: issue_assocrsp(): Use capability from struct wlan_bssid_ex
      staging: rtl8723au: issue_assocreq(): Use struct ieee80211_mgmt to build assoc_req frame
      staging: rtl8723au: rtw_get_bcn_info23a(): Use capability from wlan_bssid_ex
      staging: rtl8723au: rtw_get_bcn_info23a(): Use __func__ in debug prints
      staging: rtl8723au: Remove last users of rtw_get_capability*() functions
      staging: rtl8723au: Eliminate last rtw_get_beacon_interval*() usage
      staging: rtl8723au: struct mlme_priv->wps_beacon_ie is never set
      staging: rtl8723au: Remove unused mlme_priv->wps_assoc_resp_ie and friends
      staging: rtl8723au: Remove unused struct mlme_priv->wps_probe_resp_ie
      staging: rtl8723au: Remove obsolete mlme_priv->p2p_* entries
      staging: rtl8723au: Remove unused struct mlme_priv->wfd_* entries
      staging: rtl8723au: Remove write-only struct security_priv->authenticator_ie
      staging: rtl8723au: Remove (hopefully) last duplicate define of WLAN_EID_RSN
      staging: rtl8723au: rtw_survey_event_cb23a(): Remember to clone beacon data
      staging: rtl8723au: rtw_joinbss_update_network23a(): update beacon info as well
      staging: rtl8723au: issue_probersp(): Don't insert beacon data twice
      staging: rtl8723au: issue_probersp(): No need to calculate location of IEs, we know where they are
      staging: rtl8723au: Remove unused size defines for mgmt frame elements
      staging: rtl8723au: Remove usage of _{RE, }ASOCREQ_IE_OFFSET_
      staging: rtl8723au: Remove unused IE offset #defines
      staging: rtl8723au: rtw_get_cur_max_rate(): Use _FIXED_IE_LENGTH_ instead of hardcoded value
      staging: rtl8723au: rtw_add_beacon(): Construct a full beacon frame for validation
      staging: rtl8723au: rtw_check_beacon_data23a(): Capability is already uptodate in cur_network
      staging: rtl8723au: Use _FIXED_IE_LEN_ instead of hard coded value
      staging: rtl8723au: ConstructProbeRsp(): Use struct ieee80211_mgmt
      staging: rtl8723au: Remove no-op CheckFwRsvdPageContent23a()
      staging: rtl8723au: Remove unused dump_txrpt_ccx_8723a()
      staging: rtl8723au: issue_beacon23a(): Fix another case issuing a corrupted beacon
      staging: rtl8723au: issue_beacon23a(): Determine ie buffer location using 80211_mgmt
      staging: rtl8723au: rtw_generate_ie23a(): update network info as well as IE
      staging: rtl8723au: Stop carrying half the beacon frame header in the stored IE array
      staging: rtl8723au: Get rid of obsolete _FIXED_IE_LENGTH_ + _BEACON_IE_OFFSET
      staging: rtl8723au: Remove unused #define EID_BSSIntolerantChlReport
      staging: rtl8723au: Remove unused #define P80211CAPTURE_VERSION
      staging: rtl8723au: rtw_get_wps_attr_content23a(): Remove unused argument
      staging: rtl8723au: Remove unused RSN_VERSION_BSD23A
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): Use key_params->cipher to determine encryption
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption() is only called for WIFI_AP_STATE
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): Use key len from struct key_params
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): Stop using param->u.crypt.alg
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): Use keyparms->cipher to set WEP size
      staging: rtl8723au: rtw_cfg80211_set_encryption(): Pass additional struct key_params
      staging: rtl8723au: rtw_cfg80211_set_encryption(): Obtain key_len from struct key_params
      staging: rtl8723au: rtw_cfg80211_set_encryption(): Use key_params->cipher
      staging: rtl8723au: rtw_cfg80211_set_encryption(): Obtain key from key_params->key
      staging: rtl8723au: rtw_cfg80211_set_encryption(): Pass key_index as argument
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): Pass key_index argument
      staging: rtl8723au: rtw_cfg80211_ap_set_encryption(): obtain key from key_params
      staging: rtl8723au: rtw_cfg80211_{ap_}set_encryption(): Add set_tx argument
      staging: rtl8723au: Stop setting ieee_parm arguments that aren't used
      staging: rtl8723au: rtw_cfg80211_{ap_}set_encryption(): No more string parsing to determine cipher
      staging: rtl8723au: rtw_cfg80211_{ap_}set_encryption(): Add sta_addr argument
      staging: rtl8723au: rtw_cfg80211_{ap_}set_encryption(): Stop passing ieee_parms argument
      staging: rtl8723au: Remove obsolete struct ieee_parm
      staging: rtl8723au: Validate keys in cfg80211_rtw_add_key()
      staging: rtl8723au: Eliminate set_wep_key() and call set_group_key() directly
      staging: rtl8723au: rtw_restruct_wmm_ie23a(): Use cfg80211_find_vendor_ie()
      staging: rtl8723au: rtw_append_pmkid(): Adjust for IEs array not arrying fixed elements
      staging: rtl8723au: Only validate vendor specific ies, when they it is vendor specific
      staging: rtl8723au: OnAssocReq23a(): Use cfg80211_find_vendor_ie() to locate VMM
      staging: rtl8723au: usb_ops_linux.c: Add blank line between declaration and usage
      staging: rtl8723au: rtw_sta_mgt.c: Use ether_addr_{copy, equal}()
      staging: rtl8723au: rtw_sta_mgt.c: One copy of the broadcast address should suffice
      staging: rtl8723au: rtw_allow_stainfo23a(): Make hwaddr argument const
      staging: rtl8723au: Remove unused rtw_sreset_get_wifi_status()
      staging: rtl8723au: Wifi_Error_Status isn't used for anything
      staging: rtl8723au: sreset_priv->dbg_trigger_point is never set
      staging: rtl8723au: Remove no-op rtl8723a_sreset_linked_status_check()
      staging: rtl8723au: Remove unused rtw_pwr_wakeup_ex()
      staging: rtl8723au: Clean up rtw_pm_set_ips23a()
      staging: rtl8723au: Fold power_saving_wk_hdl() into rtw_drvextra_cmd_hdl23a()
      staging: rtl8723au: Remove unused pwrctrl_priv->brfoffbyhw
      staging: rtl8723au: Remove unused variables from struct pwrctrl_priv
      staging: rtl8723au: pnp_bstop_trx is never set
      staging: rtl8723au: pwrctrl_priv->ps_flag is never set
      staging: rtl8723au: Remove never set struct rtw_adapter->bNotifyChannelChange
      staging: rtl8723au: Sanitize USB read/write functions
      staging: rtl8723au: Simplify _BlockWrite() based on saner rtl8723au_writeN()
      staging: rtl8723au: Remove horrendous code obfuscation READ_AND_CONFIG*()
      staging: rtl8723au: Call to ODM_ConfigRFWithHeaderFile23a path is identical for RF_PATH_[AB]
      staging: rtl8723au: Eliminate wrapper ODM_ConfigRFWithHeaderFile23a()
      staging: rtl8723au: Remove zero value calculation added to address
      staging: rtl8723au: Remove pointless wrappers for calling odm_ConfigRFReg_8723A()
      staging: rtl8723au: Remove unused ODM_ReadAndConfig_PHY_REG_PG_8723A() and related code+data
      staging: rtl8723au: Remove ugly wrapper ODM_ConfigBBWithHeaderFile23a()
      staging: rtl8723au: Remove unused ODM_MacStatusQuery23a()
      staging: rtl8723au: Remove obfuscating wrapper ODM_ConfigMACWithHeaderFile23a()
      staging: rtl8723au: Remove unncessary wrapper PHY_RFConfig8723A()
      staging: rtl8723au: Eliminate Set_MSR() wrapper call
      staging: rtl8723au: Reduce number of duplicate defines for link state
      staging: rtl8723au: Use rtl8723au_set_media_status() to replace _InitNetworkType()
      staging: rtl8723au: Remove write-only variable UsbRxHighSpeedMode
      staging: rtl8723au: Remove no-op usb_AggSetting*()
      staging: rtl8723au: Remove no-op _InitOperation_mode() function
      staging: rtl8723au: Remove RegBcnCtrlVal
      staging: rtl8723au: Use proper name REG_CAMCMD and remove wrapper invalidate_cam_all23a()
      staging: rtl8723au: rtl8723a_InitBeaconParameters(): Remove unused variable
      staging: rtl8723au: ODM_IC_11N_SERIES is always true for SupportICType
      staging: rtl8723au: Remove unused odm_RegDefine11AC.h
      staging: rtl8723au: Remove pointless IS_STA_VALID() macro
      staging: rtl8723au: Fold odm_EdcaTurboCheck23aCE23a() into odm_EdcaTurboCheck23a()
      staging: rtl8723au: Declare odm_EdcaTurbo*() functions static
      staging: rtl8723au: bDMInitialGainEnable is always true
      staging: rtl8723au: Remove unused DefaultInitialGain array
      staging: rtl8723au: Remove some redundant check for hw_init_completed
      staging: rtl8723au: Remove no-op rtl8723a_deinit_dm_priv()
      staging: rtl8723au: Remove no-op function dm_CheckStatistics()
      staging: rtl8723au: Remove write-only struct dm_priv->DM_Type variable
      staging: rtl8723au: Remove write-only variables struct dm_priv->{Init,}DMFlag
      staging: rtl8723au: Remove ODM_CMNINFO_[RT]X_UNI and related code
      staging: rtl8723au: Remove useless ODM_CMNINFO_{WM_MODE, BAND} related code
      staging: rtl8723au: Remove another pile of useless ODM variables
      staging: rtl8723au: Remove another pile of awful unused ODM variables
      staging: rtl8723au: We don't need two APIs to set pHalData->odmpriv.SupportAbility
      staging: rtl8723au: ODM_DMWatchdog23a(): Take a struct hal_data_8723a *
      staging: rtl8723au: Eliminate ugly ODM_CMNINFO_SEC_CHNL_OFFSET usage
      staging: rtl8723au: Eliminate ODM_CMNINFO_BW usage
      staging: rtl8723au: Eliminate ODM_CMNINFO_CHNL usage
      staging: rtl8723au: Eliminate ODM_CMNINFO_SCAN related code
      staging: rtl8723au: Eliminate ODM_CMNINFO_POWER_SAVING usage
      staging: rtl8723au: Eliminate obsolete odm_CmnInfoHook_Debug23a()
      staging: rtl8723au: Remove obsolete ODM23a_CmnInfoHook()
      staging: rtl8723au: Merge Init_ODM_ComInfo_8723a() into rtl8723a_init_dm_priv()
      staging: rtl8723au: odm_CommonInfoSelfInit23a(): Use proper register defines
      staging: rtl8723au: Remove a pile of fluff for calling into a bunch of no-op functions
      staging: rtl8723au: Fold rtl8723a_set_nav_upper() into rtl8723au_hal_init()
      staging: rtl8723au: Reduce wrapper layers around hal_{de, }init() calls
      staging: rtl8723au: Fold rtw_resume_process23a() into rtw_resume()
      staging: rtl8723au: rtw_resume(): release semaphore before exit on error
      staging: rtl8723au: RSSI_test is never set
      staging: rtl8723au: Remove two never set variables
      staging: rtl8723au: Remove never set struct pwrctrl_priv.bHWPowerdown
      staging: rtl8723au: Do not duplicate kernel provided USB macros
      staging: rtl8723au: usb_dvobj_init(): Remove unused variable 'pdev_desc'

Jessica Yu (4):
      Staging: lustre: linux-module: fix pointer style issue
      Staging: lustre: linux-module: remove unnecessary spaces
      Staging: lustre: linux-module: remove extraneous parens
      Staging: lustre: linux-module: add const modifier to file_operations

Jimmy Picard (1):
      staging: iio: fix coding style by adding blank lines in iio_simple_dummy

Joe Perches (1):
      MAINTAINERS: update staging removals and movements

Joerg C. Meyer (1):
      Staging: rtl8821ae: delete unneeded lines in cam.c

Johannes Stadlinger (6):
      wlan-ng/prism2mgmt:checkpatch: Fix long lines
      wlan-ng/prism2mgmt:checkpatch: Fix string split
      wlan-ng/prism2mgmt:checkpatch: Insert blank line
      wlan-ng/prism2mib:checkpatch: Fix string split
      wlan-ng/prism2sta:checkpatch: Fix string split
      wlan-ng/prism2sta:checkpatch: Insert blank lines

John Church (1):
      staging: lustre: fix sparse warnings for undeclared symbols

Jonathan Cameron (5):
      iio:st sensors: remove custom sampling frequence attribute in favour of core support.
      iio: gyro: itg3200 switch sampling frequency attr to core support.
      iio: adis: Switch sampling frequency attr to core support.
      iio: imu: adis16400 switch sampling frequency attr to core support.
      iio: imu: adis16480 switch sampling frequency attr to core support

Josef Gajdusek (5):
      staging:iio:hmc5843: Added regmap support
      staging:iio:hmc5843: Split hmc5843.c to multiple files
      staging:iio:hmc5843: register <-> value arrays now can have different lengths
      staging:iio:hmc5843: Add support for i2c hmc5983
      staging:iio:hmc5843: Add support for spi hmc5983

Josep Puigdemont (1):
      staging: lustre: plain interger was used as NULL pointer

Josselin Costanzi (1):
      iio: staging: sca3000: hide stufftoread logic

Julia Lawall (1):
      staging: tidspbridge: use safer test on the result of find_first_zero_bit

KANG Yuxuan (1):
      staging: emxx_udc: Fix coding style errors

Karthik Nayak (1):
      Staging: Android: removed an unnecessary else statement

Kees Cook (2):
      staging: r8192ee: avoid leaking format string
      staging: r8821ae: avoid leaking format string

Ken Cox (7):
      Staging: unisys: remove references to __DATE__ and __TIME__
      Staging: unisys Remove BROKEN from Kconfig to allow compilation
      Staging:unisys: Add Kconfig dependency on UNISYS_VISORUTIL to UNISYS_CHANNELSTUB
      Staging: unisys: use Linux coding convention for function names
      Staging: unisys: Remove isServer arg from init_vbus_channel()
      Staging: unisys: Remove ultra_vbus_init_channel function
      Staging: unisys: Fix noderef sparse warnings in vbusdeviceinfo.h

Kevin McKinney (2):
      Staging: bcm: Change TODO to include maintainers.
      Staging: bcm: Add entry for bcm wimax driver support

Khoa Mai (2):
      staging: bcm: Qos.c: Fix coding style
      staging: bcm: Qos.c: Fix coding style

Kinka Huang (1):
      staging: comedi: removing not useful `else` after return

Kiran Padwal (2):
      Staging: gdm724x: gdm_tty.c: fix missing blank line after variable declaration
      Staging: gdm724x: gdm_usb.c: fix missing blank line after variable declaration

Kristina Martšenko (15):
      staging: crystalhd: remove driver
      staging: winbond: remove driver
      staging: wlags49_h2(5): remove driver
      staging: serqt_usb2: remove driver
      staging: dgrp: remove driver
      staging: cxt1e1: remove driver
      staging: tidspbridge: remove driver
      ARM: OMAP2+: remove DSP platform device
      staging: ced1401: remove driver
      staging: frontier: remove driver
      staging: keucr: remove driver
      staging: phison: remove driver
      staging: quickstart: remove driver
      staging: silicom: remove driver
      staging: sep: remove driver

L. Alberto Giménez (1):
      staging/lustre: Fix sparse error (signature mismatch)

LABBE Corentin (3):
      staging: sep: No else is necessary after a break (reported by checkpatch)
      staging: sep: Fix misceanellous problems reported by checkpatch
      staging: sep: Fix blank lines issue reported by checkpatch

Larry Finger (1):
      staging: rtl8192ee: Fix setting highest n rate

Lars-Peter Clausen (1):
      staging:iio:ad7291: Move out of staging

Li Xi (1):
      staging/lustre/llite: fix a flag bug of vvp_io_kernel_fault()

Linus Walleij (3):
      iio: st_sensors: get platform data from device tree
      iio: st_sensors: add device tree bindings
      iio: st_sensors: add devicetree probing support

Luca Ellero (121):
      staging: ced1401: rename CanAcceptIoRequests()
      staging: ced1401: rename SendChars()
      staging: ced1401: rename CopyUserSpace()
      staging: ced1401: rename StageChunk()
      staging: ced1401: rename ReadWriteMem()
      staging: ced1401: rename ReadChar()
      staging: ced1401: rename ReadWord()
      staging: ced1401: rename ReadHuff()
      staging: ced1401: rename ReadDMAInfo()
      staging: ced1401: rename Handle1401Esc()
      staging: ced1401: rename Allowi()
      staging: ced1401: rename FlushOutBuff()
      staging: ced1401: rename FlushInBuff()
      staging: ced1401: rename PutChars()
      staging: ced1401: rename SendString()
      staging: ced1401: rename SendChar()
      staging: ced1401: rename Get1401State()
      staging: ced1401: rename ReadWrite_Cancel()
      staging: ced1401: rename InSelfTest()
      staging: ced1401: rename Is1401()
      staging: ced1401: make ced_is_1401() static
      staging: ced1401: rename QuickCheck()
      staging: ced1401: rename Reset1401()
      staging: ced1401: rename GetString()
      staging: ced1401: rename Stat1401()
      staging: ced1401: rename LineCount()
      staging: ced1401: rename GetOutBufSpace()
      staging: ced1401: rename ClearArea()
      staging: ced1401: rename SetArea()
      staging: ced1401: rename SetTransfer()
      staging: ced1401: rename UnsetTransfer()
      staging: ced1401: rename SetEvent()
      staging: ced1401: rename WaitEvent()
      staging: ced1401: rename TestEvent()
      staging: ced1401: rename GetTransfer()
      staging: ced1401: rename KillIO1401()
      staging: ced1401: remove unused func BlkTransState
      staging: ced1401: rename StateOf1401()
      staging: ced1401: rename StartSelfTest()
      staging: ced1401: rename CheckSelfTest()
      staging: ced1401: rename TypeOf1401()
      staging: ced1401: rename TransferFlags()
      staging: ced1401: rename DbgCmd1401()
      staging: ced1401: rename DbgPeek()
      staging: ced1401: rename DbgPoke()
      staging: ced1401: rename DbgRampData()
      staging: ced1401: rename DbgRampAddr()
      staging: ced1401: rename DbgGetData()
      staging: ced1401: rename DbgStopLoop()
      staging: ced1401: rename SetCircular()
      staging: ced1401: rename GetCircBlock()
      staging: ced1401: rename FreeCircBlock()
      staging: ced1401: remove typedef for CIRCBLK
      staging: ced1401: remove typedef for TRANSAREA
      staging: ced1401: remove typedef for DMADESC
      staging: ced1401: remove typedef DEVICE_EXTENSION
      staging: ced1401: rename members of struct circ_blk
      staging: ced1401: rename members of struct transarea
      staging: ced1401: rename members of struct dmadesc
      staging: ced1401: rename members of struct ced_data
      staging: ced1401: fix ced_writechar_callback()
      staging: ced1401: fix ced_send_chars()
      staging: ced1401: fix ced_copy_user_space()
      staging: ced1401: fix staged_callback()
      staging: ced1401: fix ced_stage_chunk()
      staging: ced1401: fix ced_read_write_mem()
      staging: ced1401: fix ced_read_char()
      staging: ced1401: fix ced_read_word()
      staging: ced1401: fix ced_read_huff()
      staging: ced1401: fix ced_read_dma_info()
      staging: ced1401: fix ced_handle_esc()
      staging: ced1401: fix ced_readchar_callback()
      staging: ced1401: fix ced_allowi()
      staging: ced1401: fix ced_ioctl()
      staging: ced1401: fix ced_disconnect()
      staging: ced1401: fix comment
      staging: ced1401: fix ced_put_chars()
      staging: ced1401: fix ced_send_string()
      staging: ced1401: fix ced_send_char()
      staging: ced1401: fix ced_get_state()
      staging: ced1401: fix ced_in_self_test()
      staging: ced1401: fix ced_is_1401()
      staging: ced1401: fix ced_quick_check()
      staging: ced1401: fix ced_get_char()
      staging: ced1401: fix ced_get_string()
      staging: ced1401: fix ced_stat_1401()
      staging: ced1401: fix ced_line_count()
      staging: ced1401: fix ced_get_out_buf_space()
      staging: ced1401: fix ced_clear_area()
      staging: ced1401: fix ced_set_area()
      staging: ced1401: fix ced_set_transfer()
      staging: ced1401: fix ced_unset_transfer()
      staging: ced1401: fix ced_set_event()
      staging: ced1401: fix ced_wait_event()
      staging: ced1401: fix ced_test_event()
      staging: ced1401: fix ced_get_transfer()
      staging: ced1401: fix ced_state_of_1401()
      staging: ced1401: fix ced_start_self_test()
      staging: ced1401: fix ced_check_self_test()
      staging: ced1401: fix ced_type_of_1401()
      staging: ced1401: fix ced_transfer_flags()
      staging: ced1401: fix ced_dbg_cmd()
      staging: ced1401: fix ced_dbg_peek/poke()
      staging: ced1401: fix ced_dbg_ramp_data/addr()
      staging: ced1401: fix ced_dbg_get_data()
      staging: ced1401: fix ced_dbg_stop_loop()
      staging: ced1401: fix ced_set_circular()
      staging: ced1401: fix ced_get_circ_block()
      staging: ced1401: fix ced_free_circ_block()
      staging: ced1401: usb1401.c: change spaces to tabs
      staging: ced1401: usb1401.h: fix "foo * bar"
      staging: ced1401: ced_ioc.c: add blank line after declarations
      staging: ced1401: ced_ioc.c: remove space before tabs
      staging: ced1401: ced_ioc.c: remove else branch in ced_set_event
      staging: ced1401: ced_ioc.c: remove else branch in ced_wait_event
      staging: ced1401: ced_ioc.c : split long lines
      staging: ced1401: usb1401.c: add blank line after declarations
      staging: ced1401: usb1401.c: fix code indent
      staging: ced1401: usb1401.c rename camel case variable
      staging: ced1401: usb1401.c: split long lines
      staging: ced1401: usb1401.c: join quoted strings

Lucas Tanure (2):
      staging: android: Clean up else statement from sync_fence_poll()
      staging: android: Clean up else statement from binder_send_failed_reply

Magnus Damm (5):
      staging: emxx_udc: Add Emma Mobile USB Gadget driver
      staging: emxx_udc: I/O memory and IRQ resource support
      staging: emxx_udc: Add TODO file
      staging: board: Initial board staging support
      staging: board: kzm9d: Board staging support for emxx_udc

Malcolm Priestley (321):
      staging: vt6656: rename CARDbSetMediaChannel to vnt_set_channel
      staging: vt6656: rename swGetCCKControlRate to vnt_get_cck_rate
      staging: vt6656: rename swGetOFDMControlRate to vnt_get_ofdm_rate
      staging: vt6656: rename CARDvCalculateOFDMRParameter to vnt_calculate_ofdm_rate
      staging: vt6656: rename vUpdateIFS to vnt_update_ifs
      staging: vt6656: rename CARDvUpdateBasicTopRate to vnt_update_top_rates
      staging: vt6656: rename CARDvSetRSPINF to vnt_set_rspinf
      staging: vt6656: rename CARDbAddBasicRate to vnt_add_basic_rate
      staging: vt6656: rename CARDbIsOFDMinBasicRate to vnt_ofdm_min_rate
      staging: vt6656: rename CARDbyGetPktType to vnt_get_pkt_type
      staging: vt6656: rename CARDqGetTSFOffset to vnt_get_tsf_offset
      staging: vt6656: rename CARDvAdjustTSF to vnt_adjust_tsf
      staging: vt6656: rename CARDbGetCurrentTSF to vnt_get_current_tsf
      staging: vt6656: rename CARDbClearCurrentTSF to vnt_clear_current_tsf
      staging: vt6656: rename CARDqGetNextTBTT to vnt_get_next_tbtt
      staging: vt6656: rename CARDvSetFirstNextTBTT to vnt_reset_next_tbtt
      staging: vt6656: rename CARDvUpdateNextTBTT to vnt_update_next_tbtt
      staging: vt6656: rename CARDbRadioPowerOff to vnt_radio_power_off
      staging: vt6656: rename CARDbRadioPowerOn to vnt_radio_power_on
      staging: vt6656: rename CARDvSetBSSMode to vnt_set_bss_mode
      staging: vt6656: rename MACvWriteMultiAddr to vnt_mac_set_filter
      staging: vt6656: rename MACbShutdown to vnt_mac_shutdown
      staging: vt6656: rename MACvSetBBType to vnt_mac_set_bb_type
      staging: vt6656: rename MACvDisableKeyEntry to vnt_mac_disable_keyentry
      staging: vt6656: rename MACvSetKeyEntry to vnt_mac_set_keyentry
      staging: vt6656: rename MACvRegBitsOff to vnt_mac_reg_bits_off
      staging: vt6656: rename MACvRegBitsOff to vnt_mac_reg_bits_off
      staging: vt6656: rename MACvWriteWord to vnt_mac_write_word
      staging: vt6656: rename MACvWriteBSSIDAddress to vnt_mac_set_bssid_addr
      staging: vt6656: rename MACvEnableProtectMD to vnt_mac_enable_protect_mode
      staging: vt6656: rename MACvDisableProtectMD to vnt_mac_disable_protect_mode
      staging: vt6656: rename MACvEnableBarkerPreambleMd to vnt_mac_enable_barker_preamble_mode
      staging: vt6656: rename MACvDisableBarkerPreambleMd to vnt_mac_disable_barker_preamble_mode
      staging: vt6656: rename MACvWriteBeaconInterval to vnt_mac_set_beacon_interval
      staging: vt6656: rxtx move vnt_usb_send_context into tx structure.
      staging: vt6656: rxtx add mac header to vnt_tx_datahead_* structures
      staging: vt6656: rxtx s_vFillTxKey use vnt_usb_send_context
      staging: vt6656: rxtx replace adwTxKey[4]
      staging: vt6656: PSvEnablePowerSaving remove camel case
      staging: vt6656: PSvDisablePowerSaving remove camel case
      staging: vt6656: PSbIsNextTBTTWakeUp remove camel case
      staging: vt6656: rename PSvEnablePowerSaving to vnt_enable_power_saving
      staging: vt6656: rename PSvDisablePowerSaving to vnt_disable_power_saving
      staging: vt6656: rename PSbIsNextTBTTWakeUp to vnt_next_tbtt_wakeup
      staging: vt6656: FIRMWAREbDownload remove camel case
      staging: vt6656: FIRMWAREbBrach2Sram remove camel case
      staging: vt6656: FIRMWAREbCheckVersion remove camel case
      staging: vt6656: firmware.c replace DBG_PRT debug messages
      staging: vt6656: rename FIRMWAREbDownload to vnt_download_firmware
      staging: vt6656: rename FIRMWAREbBrach2Sram to vnt_firmware_branch_to_sram
      staging: vt6656: rename FIRMWAREbCheckVersion to vnt_check_firmware_version
      staging: vt6656: rename BBvCalculateParameter to vnt_get_phy_field
      staging: vt6656: rename BBuGetFrameTime to vnt_get_frame_time
      staging: vt6656: mac80211 conversion: create rx function.
      staging: vt6656: mac80211 conversion: Create tx functions
      staging: vt6656: mac80211 conversion: add key functions
      staging: vt6656: mac80211 conversion: main_usb add functions and change usb_driver functions
      staging: vt6656: mac80211 conversion: add channel bands
      staging: vt6656: mac80211 conversion: add vnt_init to bScheduleCommand
      staging: vt6656: mac80211 conversion: vnt_update_ifs change basic rates
      staging: vt6656: mac80211 conversion: enable power saving
      staging: vt6656: mac80211 conversion: vRunCommand change beacon
      staging: vt6656: mac80211 conversion: change vnt_next_tbtt_wakeup
      staging: vt6656: mac80211 conversion: int.c changes
      staging: vt6656: mac80211 conversion: vRunCommand channel changes
      staging: vt6656: mac80211 conversion: move data rates to device.h
      staging: vt6656: mac80211 conversion: change vnt_rf_set_txpower
      staging: vt6656: vnt_mac_set_keyentry remove byLocalID check
      staging: vt6656: mac80211 conversion: device_alloc_bufs use dev_err
      staging: vt6656: mac80211 conversion: rxtx implement power save poll
      staging: vt6656: dead code remove zonetypes
      staging: vt6656: move life time macros to rxtx.h
      staging: vt6656: dpc remove dead code.
      staging: vt6656: main_usb removed dead code
      staging: vt6656: deadcode iwctl.c/h
      staging: vt6656: wcmd remove dead code
      staging: vt6656: rxtx remove dead code
      staging: vt6656: dead code remove wmgr.c
      staging: vt6656: dead code remove bssdb.c
      staging: vt6656: dead code wpactl
      staging: vt6656: dead code remove wpa2.c
      staging: vt6656: remove dead code wpa
      staging: vt6656: dead code remove wctl
      staging: vt6656: dead code remove tkip.c/h
      staging: vt6656: dead code remove micheal.c/h
      staging: vt6656: dead code remove rc4.c/h
      staging: vt6656: dead code remove iowpa.h
      staging: vt6656: decode remove tether.c/h
      staging: vt6656: remove dead code datarate
      staging: vt6656: dead code remove 80211mgr.c/h
      staging: vt6656: remove dead code from power.c/h
      staging: vt6656: dead code remove old key functions
      staging: vt6656: dead code remove tmacro.h
      staging: vt6656: dead codead remove bssdb.h header
      staging: vt6656: dpc remove dead code RXvMngWorkItem
      staging: vt6656: Remove vnt_set_channel from device_init_registers
      staging: vt6656: remove old rx receive list
      staging: vt6656: dead code remove wmgr.h
      staging: vt6656: remove old channel tables
      staging: vt6656: dead code remove 80211hdr.h
      staging: vt6656: device_init_registers remove unused variables
      staging: vt6656: dead code remove variables device_set_options
      staging: vt6656: device.h remove dead strutures and variables
      staging: vt6656: remove unneeded config and headers
      staging: vt6656: rxtx struct vnt_mic_hdr change tsc_47_16/tsc_15_0
      staging: vt6656: rxtx replace wFragCtl with frag_ctl.
      staging: vt6656: vnt_tx_packet remove first assignment of time_stamp.
      staging: vt6656: Remove rx handing from RXvWorkItem
      staging: vt6656: dead code remove RXvWorkItem and RXvFreeRCB
      staging: vt6656: remove vnt_add_basic_rate
      staging: vt6656: set BBvSetVGAGainOffset inside vnt_set_bss_mode
      staging: vt6656: device_init_registers move out vnt_set_bss_mode
      staging: vt6656: implement get_stats ieee80211_low_level_stats
      staging: vt6656: s_nsBulkOutIoCompleteWrite fix bug of 5GHZ a rates idx
      staging: vt6656: turn radio off after mac registered.
      staging: vt6656: vnt_rf_set_txpower use power for priv->byCurPwr
      staging: vt6656: vnt_rf_setpower rate <= RATE_11M check array bound
      staging: vt6656: vnt_tx_packet don't change power when off channel.
      staging: vt6656: vnt_rx_data add track rsr and new_rsr errors
      staging: vt6656: vnt_set_channel remove power setting functions
      staging: vt6656: Include re_alloc_skb within lock.
      stagingL vt6656: implement fall back rates reporting.
      staging: vt6656: s_nsBulkInUsbIoCompleteRead check that used sk_buff is clean and ready to reuse.
      staging: vt6656: vnt_set_keymode don't save pairwise key entry.
      staging: vt6656: vnt_update_ifs vendor changes to uSIFS/uDIFS
      staging: vt6656: rxtx remove struct ethhdr from functions
      staging: vt6656: rxtx: move tx_context->fb_option into function structure.
      staging: vt6656: rxtx remove fb_option from functions.
      staging: vt6656: move current_rate setting out of s_vGenerateTxParameter
      staging: vt6656: s_vGenerateTxParameter Parse out struct vnt_rrv_time_rts
      staging: vt6656: s_vGenerateTxParameter Parse out struct vnt_rrv_time_cts
      staging: vt6656: s_vGenerateTxParameter rxtx.c s_vGenerateTxParameter pBuf->rrv_time always the calling pkt_type
      staging: vt6656: s_vGenerateTxParameter parse out vnt_rrv_time_ab
      staging: vt6656: merge PK_TYPE_11GB and PK_TYPE_11GA into vnt_rxtx_rts
      staging: vt6656: move s_vFillCTSHead to vnt_rxtx_cts
      staging: vt6656: merge data positions for packet types a and b into vnt_rxtx_ab
      staging: vt6656: s_vGenerateTxParameter remove else from if statements
      staging: vt6656: s_vGenerateTxParameter remove camel case
      staging: vt6656: rename s_vGenerateTxParameter to vnt_generate_tx_parameter
      staging: vt6656: s_vFillCTSHead remove camel case
      staging: vt6656: rename s_vFillCTSHead to vnt_fill_cts_head
      staging: vt6656: s_uGetRTSCTSDuration remove camel case
      staging: vt6656: rxtx rename s_uGetRTSCTSDuration to vnt_get_rtscts_duration_le
      staging: vt6656: s_uGetDataDuration remove camel case
      staging: vt6656: rename s_uGetDataDuration to vnt_get_duration_le
      staging: vt6656: rename s_uGetRTSCTSRsvTime to vnt_get_rtscts_rsvtime_le
      staging: vt6656: rename s_uGetTxRsvTime to vnt_get_rsvtime
      staging: vt6656: rename and cleanup wTimeStampOff
      staging: vt6656: clean up and rename wFB_Opt0 to vnt_fb_opt0
      staging: vt6656: clean up and rename wFB_Opt1 to vnt_fb_opt1
      staging: vt6656: rename s_vGetFreeContext to vnt_get_free_context
      staging: vt6656: rxtx remove static declarations
      staging: vt6656: rxtx remove unneeded comments
      staging: vt6656: rxtx replace debug messages DBG_PRT
      staging: vt6656: vnt_init_bands fix missing default.
      staging: vt6656: Fix pairwise key for non station modes
      staging: vt6656: vCommandTimerWait remove camel case.
      staging: vt6656: wcmd Remove command WLAN_CMD_RADIO
      staging: vt6656: wcmd remove unused commands
      staging: vt6656: vRunCommand remove camel case.
      staging: vt6656: remove unused variables from struct tagCMD_ITEM
      staging: vt6656: s_bCommandComplete remove else from if
      staging: vt6656: s_bCommandComplete clean up and remove camel case
      staging: vt6656: bScheduleCommand remove camel case
      staging: vt6656: vResetCommandTimer remove camel case
      staging: vt6656: wcmd replace debug message with dev_dbg
      staging: vt6656: rf.c clean up channel and power tables
      staging: vt6656: rf.c remove dead code RFaby11aChannelIndex
      staging: vt6656: vnt_rf_write_embedded add reg length and IFREGCTL_REGW
      staging: vt6656: rf.c cleanup comments
      staging: vt6656: baseband clean up VT3184 static variables
      staging: vt6656: baseband.c rename abyVT3184_AGC to vnt_vt3184_agc
      staging: vt6656: baseband.c remame abyVT3184_AL2230 to vnt_vt3184_al2230
      staging: vt6656: baseband.c rename abyVT3184_VT3226D0 to vnt_vt3184_vt3226d0
      staging: vt6656: replace typedef enum tagCMD_CODE with enum vnt_cmd
      staging: vt6656: replace typedef enum tagCMD_STATE with enum vnt_cmd_state
      staging: vt6656: remove typedef struct tagCMD_ITEM
      staging: vt6656: remove unused variables bCmdClear and bNeedRadioOFF
      staging: vt6656: replace camel case from command variables
      staging: vt6656: dead code remove typedef enum tagCMD_STATUS
      staging: vt6656: Move and rename s_bCommandComplete to vnt_cmd_complete
      staging: vt6656: rename vCommandTimerWait to vnt_cmd_timer_wait
      staging: vt6656: rename vRunCommand to vnt_run_command
      staging: vt6656: Drop u8 pointer and rename bScheduleCommand.
      staging: vt6656: rename vResetCommandTimer to vnt_reset_command_timer
      staging: vt6656: wcmd remove unneeded headers
      staging: vt6656: wcnd.c clean up comments
      staging: vt6656: device.h remove old wireless stats
      staging: vt6656: set BBvSetAntennaMode in device_init_registers
      staging: vt6656: INTvWorkItem remove camel case
      staging: vt6656: int.c Replace DBG_PRT debug messages
      staging: vt6656: int rename INTnsProcessData to vnt_int_process_data
      staging: vt6656: rename INTvWorkItem to vnt_int_start_interrupt
      staging: vt6656: int.c remove irrelevant function description
      staging: vt6656: usbpipe rename PIPEnsInterruptRead to vnt_start_interrupt_urb
      staging: vt6656: rename s_nsInterruptUsbIoCompleteRead to vnt_start_interrupt_urb_complete
      staging: vt6656: rename PIPEnsSendBulkOut to vnt_tx_context.
      staging: vt6656: rename s_nsBulkOutIoCompleteWrite to vnt_tx_context_complete
      staging: vt6656: rename PIPEnsBulkInUsbRead to vnt_submit_rx_urb
      staging: vt6656: rename s_nsBulkInUsbIoCompleteRead to vnt_submit_rx_urb_complete
      staging: vt6656: usbpipe irrelevant function descriptions
      staging: vt6656: baseband.c rename awcFrameTime to vnt_frame_time
      staging: vt6656: rename BBvSetAntennaMode to vnt_set_antenna_mode
      staging: vt6656: rename BBbVT3184Init to vnt_vt3184_init
      staging: vt6656: rename BBvSetShortSlotTime to vnt_set_short_slot_time
      staging: vt6656: rename BBvSetVGAGainOffset to vnt_set_vga_gain_offset
      staging: vt6656: rename BBvSetDeepSleep to vnt_set_deep_sleep
      staging: vt6656: rename BBvExitDeepSleep to vnt_exit_deep_sleep
      staging: vt6656: rename BBvUpdatePreEDThreshold to vnt_update_pre_ed_threshold
      staging: vt6656: device_set_options fix opening function bracket
      staging: vt6656: device_set_options remove camel case
      staging: vt6656: device_init_registers remove camel case
      staging: vt6656: main_usb replace DBG_PRT debug messages
      staging: vt6656: replace DBG_PRT error messages
      staging: vt6656: power.c replace DBG_PRT debug messages
      staging: vt6656: remove DBG_PRT kernel messages macro and enums
      staging: vt6656: main_usb.c Replace DEVICE_PARAM RxDescriptors0
      staging: vt6656: main_usb.c Replace DEVICE_PARAM TxDescriptors0
      staging: vt6656: remove dead code DEVICE_PARAM
      staging: vt6656: main_usb remove dead module params macros
      staging: vt6656: main_usb remove static function declarations.
      staging: vt6656: Remove commented out long frequency_list
      staging: vt6656: usb_device_reset remove camel case
      staging: vt6656: fix module_param_named tx_buffers variable
      staging: vt6656: struct vnt_rcb remove unused members
      staging: vt6656: struct vnt_rcb remove camel case
      staging: vt6656: remove dead structure struct vnt_tx_pkt_info
      staging: vt6656: struct vnt_private remove dead variables
      staging: vt6656: struct vnt_private pInterruptURB rename to interrupt_urb
      staging: vt6656: struct vnt_private rename apRCB to rcb
      staging: vt6656: struct vnt_private rename apTD to tx_context
      staging: vt6656: struct vnt_private remove unused variable bRadioControlOff
      staging: vt6656: struct vnt_private remove unused variable bRadioOff
      staging: vt6656: put radio power off and on into correct state every time.
      staging: vt6656: mac.h clean up macros
      staging: vt6656: remove unused macros
      staging: vt6656: struct vnt_private rename cbRD to num_rcb
      staging: vt6656: struct vnt_private rename cdTD to num_tx_context
      staging: vt6656: struct vnt_private rename wFirmwareVersion to firmware_version
      staging: vt6656: struct vnt_private rename byLocalID to local_id
      staging: vt6656: struct vnt_private replace byRFType with rf_type
      staging: vt6656: struct vnt_private rename byBBRxConf to bb_rx_conf
      staging: vt6656: remove variable byZoneType
      staging: vt6656: remame abyCurrentNetAddr to current_net_addr
      staging: vt6656: rename abyPermanentNetAddr to permanent_net_addr
      staging: vt6656: replace bExistSWNetAddr with exist_sw_net_addr
      staging: vt6656: struct vnt_private rename qwCurrTSF to current_tsf
      staging: vt6656: struct vnt_private rename uCurrRSSI to current_rssi
      staging: vt6656: antenna modes remove unused variables
      staging: vt6656: struct vnt_private remove camel case antenna variables
      staging: vt6656: struct vnt_private remove uCwMin/uCwMax
      staging: vt6656: struct vnt_private remove camel case IFS names
      staging: vt6656: struct vnt_private replace byBBType with bb_type
      staging: vt6656: struct vnt_private replace byPacketType with packet_type
      staging: vt6656: struct vnt_private replace wBasicRate with basic_rates
      staging: vt6656: struct vnt_private replace byTopOFDMBasicRate with top_ofdm_basic_rate
      staging: vt6656: struct vnt_private replace byTopCCKBasicRate with top_cck_basic_rate
      staging: vt6656: struct vnt_private replace abyEEPROM with eeprom
      staging: vt6656: struct vnt_private replace byPreambleType with preamble_type
      staging: vt6656: struct vnt_private rf power table remove camel case
      staging: vt6656: struct vnt_private replace wCurrentRate with current_rate
      staging: vt6656: struct vnt_private remove camel case retry limit
      staging: vt6656: struct vnt_private replace bShortSlotTime with short_slot_time
      staging: vt6656: struct vnt_private remove dead variable bBarkerPreambleMd
      staging: vt6656: struct vnt_private replace wSeqCounter with seq_counter
      staging: vt6656: struct vnt_private replace byAutoFBCtrl with auto_fb_ctrl
      staging: vt6656: struct vnt_private replace abyBBVGA with bb_vga
      staging: vt6656: struct vnt_private remove dead code ldBmThreshold
      staging: vt6656: struct vnt_private replace byBBPreEDRSSI with bb_pre_ed_rssi
      staging: vt6656: struct vnt_private rename byBBPreEDIndex with bb_pre_ed_index
      staging: vt6656: dead code remove channel switch.
      staging: vt6656: vnt_get_duration_le fix typo piv to priv
      staging: vt6656: rxtx move pkt_type into vnt_usb_send_context
      staging: vt6656: move need_ack into into vnt_usb_send_context
      staging: vt6656: rxtx move frame_len/size into vnt_usb_send_context as frame_len
      staging; vt6656: rxtx add current_rate into vnt_usb_send_context as tx_rate
      staging: vt6656: struct vnt_usb_send_context context into vnt_get_duration_le
      staging: vt6656: Remove static declaration vnt_start_interrupt_urb_complete
      staging: vt6656: Remove static declaration vnt_submit_rx_urb_complete
      staging: vt6656: remove static declaration vnt_tx_context_complete
      staging: vt6656: Remove ununsed macro URB_ASYNC_UNLINK
      staging: vt6656: usbpipe remove unneeded comments
      staging: vt6656: usbpipe.c clean up USB_CTL_WAIT
      staging: vt6656: vnt_tx_fifo_head rename wFIFOCtl to fifo_ctl
      staging: vt6656: struct vnt_tx_buffer replace byPKTNO with pkt_no
      staging: vt6656: struct vnt_beacon_buffer replace byPKTNO with pkt_no
      staging: vt6656: vnt_tx_buffer replace byType with type
      staging: vt6656: struct vnt_beacon_buffer replace byType with type
      staging: vt6656: struct vnt_tx_fifo_head fifo_ctl change base type to __le16
      staging: vt6656: struct vnt_tx_short_buf_head change base type of fifo_ctl to __le16
      staging: vt6656: Remove flags fMP_POST_READS and fMP_POST_WRITES
      staging: vt6656: remove macro MP_IS_READY
      staging: vt6656: Remove unsed macro DEVICE_FLAGS_OPENED
      staging: vt6656: struct vnt_private merge flag and macros
      staging: vt6656: use set_bit to set flags
      staging: vt6656: use clear_bit to remove device flag
      staging: vt6656: Remove unused macro MP_TEST_FLAGS
      staging: vt6656: use test_bit to check flags status
      staging: vt6656: rename device_set_options to vnt_set_options
      staging: vt6656: rename device_init_registers to vnt_init_registers
      staging: vt6656: rename device_free_tx_bufs to vnt_free_tx_bufs
      staging: vt6656: rename device_free_rx_bufs to vnt_free_rx_bufs
      staging: vt6656: rename device_free_int_bufs to vnt_free_int_bufs
      staging: vt6656: rename device_alloc_bufs to vnt_alloc_bufs
      staging: vt6656: main_usb.c remove comments to functions nolonger present.
      staging: vt6656: change driver version to mac80211
      staging: vt6656: main_usb.c remove return from void functions
      staging: vt6656: remove return from all void functions
      staging: vt6656: remove comments of old functions nolonger present.
      staging: vt6656: rf.h clean up comments
      staging: vt6656: dpc.h remove dead function prototypes
      staging: vt6656: dpc remove unneeded headers
      staging: vt6656: power.h remove dead macros
      staging: vt6656: rf.h cleanup C_PWBT comments
      staging: vt6656: wcmd.h remove dead macros
      staging: vt6655: remove undefined TASK_LET code
      staging: vt6655: deadcode remove undefined macro THREAD code.
      staging: vt6655: dead code remove undefined macro FOR_LED_ON_NOTEBOOK code.
      staging: vt6655: dead code remove undefined macro IO_MAP
      staging: vt6655: remove typedef enum __device_init_type
      staging: vt6655: clean up the tail of function device_init_registers

Marc Fite (2):
      staging: lustre: removed spaces at the start of a line
      staging: lustre: lov: Fix sparse warning using plain integer as NULL pointer

Marcus Farkas (1):
      staging: rtl8821ae: fix sparse warning for static declarations

Marek Belisko (2):
      staging: iio: hmc5843: Add all available models to device tree id table.
      Documentation: iio: Extend documentation for hmc5843 bindings.

Martin Fuzzey (1):
      iio: mma8452: add DT support

Martin Gumbrecht (7):
      Staging: bcm: Prototypes.h: fix checkpatch errors: blank lines
      Staging: bcm: Prototypes.h: fix checkpatch errors: whitespaces
      Staging: bcm: Queue.h: fix checkpatch errors: comments
      Staging: bcm: Queue.h: fix checkpatch errors: brackets
      Staging: bcm: Queue.h: fix checkpatch errors: whitespaces
      Staging: bcm: Qos.c: fix checkpatch errors: comments
      Staging: bcm: Qos.c: fix checkpatch errors: whitespaces

Martin Kepplinger (1):
      staging: vt6655: remove unnecessary typedef struct.

Masanari Iida (12):
      staging: bcm: Remove unnecessary parentheses
      staging: unisys: Remove trailing semicolon from macro
      staging: vme: Fix typo in vme_pio2_gpio.c
      staging: vme: Add missing CR in error message
      staging: vme: Add missing CR in printk messages in vme_pio2_core.c
      staging: rtl8723au: Fix typo in rtw_mlme_ext.c
      staging: rtl8723au: Fix typo in rtw_mlme.c
      staging: rtl8723au: Fix typo in rtw_xmit.c
      staging: rtl8723au: Fix typo in rtw_ap.c
      staging: rtl8723au: Fix typo in rtl8723au/core
      staging: et131x: Fix typo in et131x
      staging: et131x: Remove trailing semicolon from macros in et131x.h

Mathias Engan (1):
      staging: keucr: usb.c: add blank lines after declarations

Matt Kurz (2):
      staging: wlan-ng/prism2fw.c: Add blank line after declarations
      staging: lustre: Fix sparse warnings

Matthias Beyer (114):
      Staging: bcm: led_control.c: Indentation/Whitespace/Line length cleanup
      Staging: bcm: led_control.c: Outsourced adapter driver state handling
      Staging: bcm: led_control.{c,h}: Fixed macro
      Staging: bcm: led_control.c: Simplified nested if conditions
      Staging: bcm: led_control.c: Replaced member accessing
      Staging: bcm: led_control.c: Outsourced code chunk
      Staging: bcm: led_control.c: Refactored variable name
      Staging: bcm: led_control.c: Removed dead code
      Staging: bcm: led_control.c: Refactored line lengths
      Staging: bcm: led_control.c: More variable names refactored
      Staging: bcm: led_control.c: Replaced time selecting ifelse with ternary operator
      Staging: bcm: led_control.c: Replaced doubled if-check by logical OR in one check
      Staging: bcm: led_control.c: Replaced member accessing by variable
      Staging: bcm: led_control.c: Replaced member accessing by variable
      Staging: bcm: led_control.c: Replaced nested ifs with logical AND concatenation
      Staging: bcm: Shortened some lines
      Staging: bcm: replaced member accessing by variable
      Staging: bcm: Replaced member accessing with variable in device_run()
      Staging: bcm: Replaced member accessing with variable in InterfaceAdapterInit()
      Staging: bcm: Merged some lines which got shorter by the latest patch
      Staging: bcm: Outsourced selecting of alternate setting
      Staging: bcm: Shortened some lines in select_alternate_setting_for_highspeed_modem()
      Staging: bcm: Line length cleanup
      Staging: bcm: line length fixed
      Staging: bcm: Whitespace for indentation fixed
      Staging: bcm: Replaced member accssing with variable
      Staging: bcm: Added missing blank line after declarations
      Staging: bcm: replaced member accessing with variable for readability
      Staging: bcm: hostmibs.c: Shortened lines
      Staging: bcm: Misc whitespace fixes
      Staging: bcm: Indentation fixes
      Staging: bcm: Fixed indention for inner if-block
      Staging: bcm: Moved doubled if-block
      Staging: bcm: Lines shortened in ddr_init()
      Staging: bcm: Lines shortened in download_ddr_settings()
      Staging: bcm: InterfaceRx.c: Lines shortened
      Staging: bcm: InterfaceRx.c: Outsourced control packet handling
      Staging: bcm: InterfaceRx.c: Outsourced code chunk
      Staging: bcm: InterfaceRx.c: Removed unused variable
      Staging: bcm: InterfaceTx.c: Shortened lines + Whitespace cleanup
      Staging: bcm: InterfaceTx.c: Outsourced code chunk
      Staging: bcm: InterfaceTx.c: checkpath fix: Blank line after declarations
      Staging: bcm: LeakyBucket.c: Replaced member accessing by variable
      Staging: bcm: LeakyBucket.c: Shortened lines
      Staging: bcm: LeakyBucket.c: Outsourced code chunk into function
      Staging: bcm: LeakyBucket.c: Outsourced ctrl packet sending
      Staging: bcm: LeakyBucket.c: Removed unneccessary return; statement
      Staging: bcm: Shortened lines
      Staging: bcm: InterfaceMisc.c: Outsourced doubled error checking
      Staging: bcm: Transmit.c: Replaced member accessing with variable
      Staging: bcm: Transmit.c: Line length / Whitespace cleanup
      Staging: bcm: Transmit.c: Removed obvious comment
      Staging: bcm: PHSModule.c: Whitespace & Indentation cleanup
      Staging: bcm: PHSModule.c: Outsourced debug printing in own function
      Staging: bcm: PHSModule.c: Outsourced debug printing for phs classifier entry
      Staging: bcm: PHSModule.c: Replaced member accessing with variable in PhsDeletePHSRule()
      Staging: bcm: PHSModule.c: Replaced nested if statements with logical AND concatenation of the conditions
      Staging: bcm: PHSModule.c: Reduced indentation level by using jump label
      Staging: bcm: PHSModule.c: Shortened lines
      Staging: bcm: PHSModule.c: Reduced indentation by using jump label in PhsDeleteSFRules()
      Staging: bcm: PHSModule.c: Replaced member accessing with variables
      Staging: bcm: PHSModule.c: Whitespace cleanup in PhsCompress()
      Staging: bcm: PHSModule.c: Added missing braces around else block
      Staging: bcm: PHSModule.c: Replaced member accessing with variable in free_phs_service()
      Staging: bcm: PHSModule.c: Replaced indentation level with goto jump on bad condition
      Staging: bcm: PHSModule.c: Rewrote ValidatePHSRuleComplete()
      Staging: bcm: PHSModule.c: Added const keyword to ValidatePHSRUleComplete() argument
      Staging: bcm: PHSModule.c: Replaced member accessing with variable in GetServiceFlowEntry()
      Staging: bcm: PHSModule.c: Simplified nested if statements by linking them with logical AND in GetServiceFlowEntry()
      Staging: bcm: PHSModule.c: Simplified nested if statements by linking them with logical AND in GetServiceFlowEntry()
      Staging: bcm: PHSModule.c: Simplified nested if statements by linking them with logical AND in GetPhsRuleEntry()
      Staging: bcm: PHSModule.c: Replaced member accessing with variable in CreateSFToClassifierRuleMapping()
      Staging: bcm: PHSModule.c: Replaced if-else return code with simple return assertion
      Staging: bcm: PHSModule.c: Shortened lines
      Staging: bcm: nvm.c: Shortened lines
      Staging: bcm: nvm.c: Outsourced chunk of code into function
      Staging: bcm: nvm.c: Removed indentation level by using continue statement
      Staging: bcm: nvm.c: Removed indentation level by concatenating nested if statements
      Staging: bcm: nvm.c: replaced member accessing with variable
      Staging: bcm: nvm.c: Fixed variable type
      Staging: bcm: nvm.c: Don't pass the index
      Staging: bcm: IPv6Protocol.c: Reindented switch-case
      Staging: bcm: IPv6Protocol.c: Removed unnecessary if-else blocks
      Staging: bcm: IPv6Procotol.c: Replaced member accessing with variable
      Staging: bcm: IPv6Protocol.c: Replaced member accessing with variable
      Staging: bcm: IPv6Protocol.c: Whitespace cleanup
      Staging: bcm: IPv6Protocol.c: Line length fixes
      Staging: bcm: Qos.c: Replaced member accessing with variable in PruneQueue()
      Staging: bcm: Qos.c: Replaced member accessing with variable in MatchDestIpAddress()
      Staging: bcm: Qos.c: Replaced do-while(0) jumps with goto and label, removes one level of indentation
      Staging: bcm: Qos.c: Replaced member accessing with variable in PruneQueue()
      Staging: bcm: Qos.c: Replaced member accessing by variable in flush_all_queues()
      Staging: bcm: Qos.c: Replaced do-while(0) breaks with continue
      Staging: bcm: Qos.c: Replaced if-else return with ternary operator
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchSrcIpAddress()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchDestIpAddress()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchTos()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchProtocol()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchSrcPort()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in MatchDestPort()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in IpVersion4()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in PruneQueue()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in flush_all_queues()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in ClassifyPacket()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EthCSMatchSrcMACAdress()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EthCSMatchDestMACAdress()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EthCSMatchEThTypeSAP()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EthCSMatchVLANRules()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EThCSClassifyPkt()
      Staging: bcm: Qos.c: Line length / Whitespace cleanup in EThCSGetPktInfo()
      Staging: bcm: Qos.c: checkpatch.pl fix: Added blank lines after declarations
      Staging: bcm: Qos.c: checkpatch.pl fix: Transformed C99-style comments
      Staging: bcm: Qos.c: checkpatch.pl fix: Removed parentheses from return statement
      Staging: bcm: Qos.c: checkpatch.pl fix: Indentation of case-statements fixed

Max Vozeler (1):
      staging: usbip: remove redundant return statements

Merlin Chlosta (1):
      staging: vt6655: coding style: use C89 comments

Michael Welling (1):
      iio: dac: mcp4902/mcp4912/mcp4922 dac driver

Michalis Pappas (5):
      staging: gdm72xx: remove unused code
      staging: gdm72xx: move T_CAPABILITY definitions to hci.h
      staging: gdm72xx: reorder functions and remove forward declarations
      staging: gdm72xx: remove debug code
      staging: gdm72xx: replace print_hex_dump_debug() with dev_dbg()

Miguel Oliveira (2):
      staging: nokia_h4: nokia_core.c Fixed coding style
      staging: rtl8723au: Fix static symbol sparse warning

Modestas Stankus (2):
      staging: wlan-ng: fixing coding style problems
      staging: wlan-ng: coding style problem fix

Morgan S. Stuart (1):
      Staging: rtl8192ee: fixed tab coding style issue in base.h

Mostyn Bramley-Moore (1):
      staging: netlogic: coding style fixup

Murilo Opsfelder Araujo (2):
      Staging: android: timed_output.c: use kstrtoint() instead of sscanf()
      Staging: android: timed_gpio.c: improved logic of gpio_get_time()

Nathaniel Clark (1):
      staging/lustre/llite: Only kill SGID/SUID bits

NeilBrown (1):
      staging/lustre: fix misuse of current->parent.

Nicolas Koch (1):
      Staging: octeon: minor style cleanups

Nicolas Thery (1):
      staging: ft1000: remove procfs entries

Oleg Drokin (2):
      staging/lustre/libcfs: revert changes to libcfs_sock_ioctl
      staging/lustre/ptlrpc: Protect request buffer changing

Patrick Farrell (1):
      staging/lustre/vvp: release mmap_sem in error case

Paul Bolle (3):
      staging: rtl8192u: remove checks for CONFIG_IEEE80211_CRYPT_TKIP
      staging: Remove useless "default N" lines
      staging: unisys: remove unused macros

Pawel Lebioda (5):
      staging: cxt1e1: fix sbeCrc function declaration
      staging: nvec: insert blank lines after declarations
      staging: nvec: remove unnecessary 'else' after 'return' statement
      staging: nvec: remove unneccessary 'out of memory' message
      staging: bcm: add missing blank lines after declarations

Petar Dimitrijevic (1):
      staging: vt6655: Fixed checkpatch errors

Peter Meerwald (29):
      iio: Add ABI documentation for proximity
      iio: Add t5403 barometric pressure sensor driver
      iio:adc:ad799x: Fix ad799x_chip_info kerneldoc
      iio:adc:ad5791: Use BIT() and GENMASK() macros
      iio:adc:ad5504: Use BIT() and GENMASK() macros
      iio:adc:ad7887: Use BIT() and GENMASK() macros
      iio:adc:ad7476: Use GENMASK() macro
      iio:adc:ad7298: Use BIT() and GENMASK() macros
      iio: Move documentation of iio-trig-sysfs to ABI/testing
      staging:iio: Update iio_event_monitor program
      staging:iio: Fix iio_utils.h function prototypes
      staging:iio: Fix mention of INDIO_RING_TRIGGERED to INDIO_BUFFER_TRIGGERED
      staging:iio: Fix error handling in generic_buffer example
      staging:iio-trig-periodic-rtc: Cleanup
      staging:iio-trig-periodic-rtc: Allow to reset frequency to 0
      iio: Remove timestamp argument from iio_trigger_poll() and iio_trigger_poll_chained()
      iio: Add Intersil isl29125 digital color light sensor driver
      iio: Add driver for AMS/TAOS tcs3414 digital color sensor
      iio:adc:ad799x: Drop I2C access helper functions
      iio:adc:ad799x: Save some lines in ad7997_8_update_scan_mode() exit handling
      iio:adc:ad799x: Use BIT() and GENMASK()
      iio:adc:ad799x: Only expose event interface when IRQ is available
      iio:adc:ad799x: Make chan_spec const in ad799x_chip_config struct
      iio:adc:ad799x: Add helper function to read/write config register
      iio:adc:ad799x: Write default config on probe and reset alert status on probe
      iio:adc:ad799x: Set conversion channels and rename ad7997_8_update_scan_mode()
      iio:adc:ad799x: Return more meaningful event enabled state
      iio:adc:ad799x: Allow writing of event config
      iio:kxcjk-1013: Fix endianness in scan_type

Peter Senna Tschudin (8):
      staging: vt6556: Remove double parentheses
      staging: vt6556: Cleanup indentation on statements
      staging: vt6556: Cleanup coding style: #define
      staging: vt6556: Cleanup coding style: comments
      staging: vt6556: Cleanup coding style: lines over 80 chars
      staging: vt6556: Cleanup coding style: indentation
      staging: vt6556: Remove typedefs
      staging: vt6556: Replace printk by dev_warn

Philippe Reynes (1):
      iio: add support of the max1027

Phong Tran (1):
      staging: android: ion: ion_cma_heap.c: Fix checkpatch warning

Pramod Gurav (3):
      alarmtimer: Export symbols of alarmtimer_get_rtcdev
      staging: alarm-dev: Support to Compile as Module
      staging: alarm-dev: Set the license to GPL

Radek Dostal (3):
      staging/fwserial: (coding style) add blank line after every declaration
      staging/fwserial: (coding style) remove not needed return statements
      staging: lustre: fix sparse warnings "Using plain integer as NULL pointer"

Rahul Bedarkar (1):
      staging: octeon: fix coding style

Rahul Garg (1):
      staging: vt6655: coding style: Fixed commenting style

Raphael Silva (1):
      staging: rtl8723au: Corrections in the coding style

Rasmus Villemoes (3):
      drivers/staging/rtl8821ae/rtl8821ae: Remove dead code
      staging: rtl8821ae: Pass large struct by const reference
      staging: rtl8192ee: Pass large struct by const reference

Reyad Attiyat (4):
      iio: Documentation: Add documentation for rotation from north sensor usage attributes
      iio: types: Added support for rotation from north usage attributes
      iio: hid-sensor-magn-3d: Scan for usage attributes before setting up iio channels
      iio: hid-sensor-magn-3d: Add support for rotation from north

Riccardo Lucchese (3):
      staging: lustre: lov: Cleanup lov_check_set() in lov_request.c
      staging: lustre: lov: Add a blank line after declarations in lov_request.c
      staging: lustre: lov: Add a space before open braces '{' in lov_request.c

Rickard Strandqvist (11):
      staging: tidspbridge: pmgr: dspapi.c: Cleaning up uninitialized variable
      staging: rtl8192u: r8192U_core.c: Cleaning up unclear and confusing code
      staging: rtl8188eu: os_dep: usb_intf.c: Cleaning up unnecessary code
      staging: rtl8712: rtl871x_ioctl_linux.c: Cleaning up useless if statement
      staging: bcm: nvm.c: Cleaning up a array that is filled incompletely
      staging: ced1401: userspace: use1401.c: Cleaning up if statement that always evaluates to true
      staging: rtl8192u: r8192U_core.c: Cleaning up variable is set more than once
      drivers/staging/rtl8821ae: replace magic number by macro
      staging: bcm: nvm.c: Cleaning up check unsigned is less than zero
      staging: unisys: include: uisutils.h: Cleaning up missing null-terminate in conjunction with strncpy
      staging: usbip: stub_main.c: Cleaning up missing null-terminate in conjunction with strncpy

Robin Schroer (5):
      drivers/staging/bcm/Misc: style: added blank lines after declarations
      drivers/staging/bcm/Misc: style: removed duplicate parentheses
      drivers/staging/bcm/Misc: style: removed void returns
      drivers/staging/speakup/main: fixed jiffie comparison
      staging/goldfish/goldfish_audio: fix a sparse warning

Russell King (5):
      component: fix missed cleanup in case of devres failure
      component: ignore multiple additions of the same component
      component: add support for component match array
      component: fix bug with legacy API
      imx-drm: update to use component match support

Sachin Kamat (14):
      staging: rtl8723au: Remove redundant casting in rtw_mlme_ext.c
      staging: rtl8723au: Remove redundant casting in rtw_mlme.c
      staging: bcm: Remove redundant casting in Bcmchar.c
      staging: emxx_udc: Fix build error
      staging: emxx_udc: Use module_platform_driver
      iio: adis16400: Remove unused variable
      iio: ad5624r_spi: Remove redundant variable
      iio: ad5504: Remove redundant variable
      iio: ad5686: Remove redundant variable
      iio: xilinx-xadc: Remove unused variable
      iio: hid-sensors: Fix compilation warning
      staging: iio: ad9832: Remove redundant check
      staging: emxx_udc: Fix build error
      staging: ion: Remove left over comment

Sam Asadi (14):
      Staging: comedi: adl_pci9118: a style issue fixed
      Staging: comedi: adl_pci9118: fractured spelling fixed
      Staging: adl_pci9118: a language issue fixed
      Staging: comedi: adl_pci9118: line over 80 fixed
      Staging: comedi: adl_paci9118: organized entry comments
      Staging: comedi: adv_pci1710: a line over 80 fixed
      Staging: comedi: adv_pci1710: a line over 80 issue fixed
      Staging: comedi: adv_pci1710: A line style issue fixed
      Staging: comedi: adv_pci1710: a line over 80 characters fixed
      Staging: comedi: adv_pci1710: a line over 80 characters resolved
      Staging: comedi: adv_pci1710: an issue in line over 80 fixed
      Staging: comedi: adv_pci1710: an issue in code style fixed
      Staging: comedi: amcc_s5933: a line over 80 fixed
      Staging: comedi: amcc_s5933: a style issue fixed

Sami Laine (1):
      drivers/staging/lustre/lustre/llite: sparse warning corrections

Samuel Thibault (1):
      Update speakup mailing list address

Sanjeev Sharma (3):
      staging:r8180: coding style: Fixed commenting style
      staging:r8180: coding style: Fixed too long lines
      staging:r8190: coding style: Fixed checkpatch reported Error

Santiago Torres (1):
      staging:rtl8712:mlme_linux.c: Adds blank lines to pass checkpatch.pl

Scott Weir (2):
      staging: lustre: Fix sparse warnings for undeclared symbols
      staging: gdm724x: Added blank lines after declarations in gdm_lte.c

Seunghun Lee (7):
      staging: ced1401: fix sparse warning for ced1401
      staging: dgnc: Remove all C99 comments
      staging: dgnc: Fix space required after that ','
      staging: dgnc: remove commented code
      staging: dgnc: removes unused if defined code
      staging: dgnc: rephrase comment
      staging: dgnc: Remove unneeded dgnc_trace.c and dgnc_trace.h

Srinivas Pandruvada (7):
      iio: accel: kxcjk1013 3-axis accelerometer driver
      iio: AK09911 : 3 axis compass support
      iio: accel: kxcjk1013 Fix missing unlock errors
      iio: core : events ABI for specifying period
      iio: accel: kxcjk-1013: Fix setting frequency
      iio: accel: kxcjk-1013: Use try_reenable to ack intr
      iio: accel: kxcjk-1013: Increment ref counter for indio_dev->trig

Stephan Gabert (3):
      staging/wlags49_h2: checkpatch: including <linux/*.h> instead of <asm/*.h>
      staging/wlags49_h2: checkpatch: added spaces around equal sign
      staging/wlags49_h2: checkpatch: line over 80 characters

Stephen Rothwell (1):
      staging: board: disable as it breaks the build

Sudip Mukherjee (2):
      staging:bcm:Transmit.c:coding style:line over 80 char
      staging: bcm: DDRInit.c: fixed coding style: lines over 80 char

Sylvain Calador (1):
      staging: rtl8821ae: fixed a space coding style issue

Tair Rzayev (3):
      staging: wlan-ng: cfg80211.c: Fix sparse warnings
      staging: android: ion: ion_chunk_heap.c: Fix checkpatch warning
      staging: android: binder.c: binder_ioctl() cleanup

Thierry Reding (3):
      staging/nvec: Remove double const qualifier
      staging/nvec: Do not pass resource to mfd_add_devices()
      staging/nvec: Use platform_get_irq()

Thomas Vegas (2):
      staging: rtl8712: Fix oops on dongle removal if firmware is not available
      staging: rtl8712: Remove useless variable 'fw_found'

Tobias Klauser (4):
      staging: gdm72xx: Use net_device_stats from struct net_device
      staging: gdm72xx: Remove unnecessary memset of netdev private data
      staging: wlan-ng: Use net_device_stats from struct net_device
      staging: et131x: Use net_device_stats from struct net_device

Tom Jorquera (1):
      staging: vme: removed useless breaks in vme_user.c

Toralf Förster (1):
      v2 staging: translates 3 comments into english in HalBtc8812a1Ant.c

Vinayak Menon (1):
      staging: binder: add vm_fault handler

Vincent Bernat (2):
      staging: xillybus: fix some coding style errors
      staging: visorchipset: fix sparse warnings about static declaration

Vincent Heuken (5):
      Staging: dgnc: fixed brace coding style issue in dgnc_driver.c
      Staging: serqt_usb2: fixed blank line style warning in serqt_usb2.c
      Staging: serqt_usb2: fixed frivolous else statement warnings
      Staging: slicoss: fixed frivolous else statement warnings in slicoss.c
      Staging: panel: fixed frivilous else statement warning

Vitaly Osipov (2):
      staging: lustre: remove memset(0) after LIBCFS_ALLOC
      staging: rtl8712: replace kmalloc(..., sizeof(T))

Wahib Faizi (2):
      staging: usbip: usbip_host_driver.c: avoid assignment in if
      staging: usbip: usbip_host_driver.c: fix line over 80 characters

Wolfgang Ocker (2):
      staging: comedi: style - use kmalloc_array(n, s, ...) instead of kmalloc(n*s, ...)
      staging cxt1e1: refactored ring buffer dump functions to avoid sparse warnings

Zahari Doychev (1):
      bcm: fix code style

navin patidar (269):
      staging: rtl8188eu: Remove "silentreset_mutex" from struct sreset_priv
      staging: rtl8188eu:Remove "silent_reset_inprogress" from struct sreset_priv
      staging: rtl8188eu: Use rtw_hal_sreset_init() in rtw_reset_drv_sw()
      staging: rtl8188eu: Remove unused function rtw_hal_sreset_reset_value()
      staging: rtl8188eu: Remove unused function pointer ->sreset_reset_value
      staging: rtl8188eu: Remove unused function reset_reset_value()
      staging: rtl8188eu: Remove function rtw_hal_sreset_xmit_status_check()
      staging: rtl8188eu: Remove unused function rtl8188e_sreset_xmit_status_check()
      staging:rtl8188eu: Remove function rtw_hal_sreset_linked_status_check()
      staging:rtl8188eu: Remove function rtl8188e_sreset_linked_status_check()
      staging: rtl8188eu: Remove function rtw_hal_sreset_reset()
      staging: rtl8188eu: Remove function rtl8188e_silentreset_for_specific_platform()
      staging: rtl8188eu: Remove empty files rtl8188e_sreset.[c|h]
      staging: rtl8188eu: Remove "last_tx_time" from struct sreset_priv
      staging: rtl8188eu: Remove "last_tx_complete_time" from struct sreset_priv
      staging: rtl8188eu: Remove Hal8188EReg.h file
      staging: rtl8188eu: Remove unused function declaration
      staging: rtl8188eu: Remove usb_vendor_req.h header file
      staging: rtl8188eu: Remove function with empty defination ODM_ResetIQKResult()
      staging :rtl8188eu: Remove HalPhyRf.[h|c] files.
      staging: rtl8188eu: Remove header file rtw_version.h
      staging: rtl8188eu: Remove hw_init_mutex from struct rtw_usb_drv
      staging: rtl8188eu: Use unregistering flag from struct usb_interface
      staging : rtl8188eu: Remove drv_registered from struct rtw_usb_drv
      staging: rtl8188eu: Remove struct rtw_usb_drv
      staging: rtl8188eu: Use module_usb_driver() macro
      staging: rtl8188eu: Remove function declarations in usb_intf.c
      staging: rtl8188eu: Remove unused stucture defination struct specific_device_id
      staging: rtl8188eu: Remove unused enum
      staging: rtl8188eu: Remove unused members of struct dvobj_priv
      staging: rtl8188eu: Remove usb_suspend_sema from struct dvobj_priv
      staging: rtl8188eu: Remove usb_alloc_vendor_req_buf from struct dvobj_priv
      staging: rtl8188eu: Remove unused enum _ADAPTER_TYPE
      staging: rtl8188eu: Remove unused enum _IFACE_TYPE
      staging: rtl8188eu: Remove enum driver_state
      staging: rtl8188eu: Remove DriverState from struct adapter
      staging: rtl8188eu: Remove unused function rtl8188e_clone_haldata()
      staging: rtl8188eu: Remove hal_data_sz from struct adapter
      staging: rtl8188eu: Remove unused member variable of struct adapter
      staging: rtl8188eu:Remove EepromAddressSize from struct adapter
      staging: rtl8188eu: Remove pbuddy_adapter from struct adapter
      staging: rtl8188eu: Remove bCardDisableWOHSM from struct adapter
      staging: rtl8188eu: Remove unused function nat25_handle_frame()
      staging: rtl8188eu: Remove function with empty defination()
      staging: rtl8188eu: usb_halinit.c: Remove ReadAdapterInfo8188EU()
      staging: rtl8188eu: Remove rtw_deinit_intf_priv()
      staging: rtl8188eu: Remove rtw_init_intf_priv()
      staging: rtl8188eu:Move rtw_hw_[suspend, resume]() to rtw_pwrctrl.c
      staging: rtl8188eu: Remove unused struct intf_priv
      staging: rtl8188eu: Remove unused funtion _rtw_read_mem()
      staging: rtl8188eu: Remove unused function _rtw_write_mem()
      staging: rtl8188eu: Remove unused function declaration and macro
      staging: rtl8188eu: rtw_io.h: Remove unused structures
      staging: rtl8188eu: HalPhyRf_8188e.c: Remove unused macro
      staging: rtl8188eu: HalPhyRf_8188e.c: Remove unnecessary comments
      staging: rtl8188eu: rtw_io.h: Remove unused macros
      staging: rtl8188eu: rtw_io.h: Remove unused members from struct _io_ops
      staging: rtl8188eu: rtw_io.c: Remove unused function _rtw_write8_async()
      staging: rtl8188eu: rtw_io.c: Remove unused function rtw_write16_async()
      staging: rtl8188eu: rtw_io.c: Remove unused function _rtw_write32_async()
      staging: rtl8188eu: rtw_io.c: Remove unused function _rtw_write_port_and_wait()
      staging: rtl8188eu: rtw_io.h: Remove unused function declarations
      staging: rtl8188eu: Instead of intf_hdl pass adapter in read & write functions
      staging: rtl8188eu: Remove function _rtw_writeN()
      staging: rtl8188eu: Remove function _rtw_read_port()
      staging: rtl8188eu: Remove function _rtw_read_port_cancel()
      staging: rtl8188eu: Remove function _rtw_write_port()
      staging: rtl8188eu: Remove function _rtw_write_port_cancel()
      staging: rtl8188eu: Remove function _rtw_write32()
      staging: rtl8188eu: Remove function _rtw_write16()
      staging: rtl8188eu: Remove function _rtw_write8()
      staging: rtl8188eu: Remove function _rtw_read32()
      staging: rtl8188eu: Remove function _rtw_read16()
      staging: rtl8188eu: Remove function _rtw_read8()
      staging: rtl8188eu: Remove functions initialize rtw_[read,write] wrapper
      staging: rtl8188eu: usb_ops_linux.h: Remove unused function declarations
      staging: rtl8188eu: rtw_io.h: Remove unused structures and macros
      staging: rtl8188eu: Move usb_[read, write]() declarations to usb_ops_linux.h
      staging: rtl8188eu: Remove empty files rtw_io.[c,h]
      staging: rtl8188eu: Remove function rtw_br_client_tx()
      staging: rtl8188eu: Remove unused functons defined in rtw_br_ext.c
      staging: rtl8188eu: Remove function nat25_db_cleanup()
      staging: rtl8188eu: Remove pppoe_connection_in_progress from struct adapter
      staging: rtl8188eu: Remove function nat25_db_expire()
      staging: rtl8188eu: Remove function netdev_br_init()
      staging: rtl8188eu: core: Remove file rtw_br_ext.c
      staging: rtl8188eu: Remove unused members of struct adapter
      staging: rtl8188eu: Remove file rtw_br_ext.h
      staging: rtl8188eu: Rename hal_EfusePowerSwitch_RTL8188E()
      staging: rtl8188eu: Remove rtl8188e_ReadEFuse()
      staging: rtl8188eu: Remove unused function ReadEFuse_Pseudo()
      staging: rtl8188eu: Remove rtl8188e_EfuseGetCurrentSize()
      staging: rtl8188eu: Remove unused function Hal_EfuseGetCurrentSize_Pseudo()
      staging: rtl8188eu: Remove function Hal_EFUSEGetEfuseDefinition_Pseudo88E()
      staging: rtl8188eu: Rename Hal_EFUSEGetEfuseDefinition88E()
      staging: rtl8188eu: assign hal_EfusePgPacketRead_8188e() to ->Efuse_PgPacketRead
      staging:rtl8188eu:assign hal_EfusePgPacketWrite_8188e() to ->Efuse_PgPacketWrite
      staging:rtl8188eu: Assign rtl8188e_Efuse_WordEnableDataWrite() to ->Efuse_WordEnableDataWrite
      staging: rtl8188eu: rtw_efuse.c: Remove unnecessary function declaration
      staging: rtl8188eu: Rename rtl8188e_EFUSE_GetEfuseDefinition()
      staging: rtl8188eu: Rename hal_EfuseGetCurrentSize_8188e()
      staging: rtl8188eu: Rename rtl8188e_EfusePowerSwitch() to Efuse_PowerSwitch()
      staging: rtl8188eu: Rename function Hal_EfuseWordEnableDataWrite()
      staging: rtl8188eu: Remove function Hal_EfuseReadEFuse88E()
      staging: rtl8188eu: Rename function ReadEFuseByIC() to efuse_ReadEFuse()
      staging: rtl8188eu: Rename hal_EfusePgPacketRead_8188e() to Efuse_PgPacketRead()
      staging: rtl8188eu: Rename hal_EfusePgPacketWrite_8188e()
      staging: rtl8188eu: Remove function Efuse_Write1ByteToFakeContent()
      staging: rtl8188eu: Remove function Efuse_Read1ByteFromFakeContent()
      staging: rtl8188eu: Remove function rtw_BT_efuse_map_write()
      staging: rtl8188eu: Remove unused function Efuse_PgPacketWrite_BT()
      staging: rtl8188eu: Remove function rtw_BT_efuse_map_read()
      staging: rtl8188eu: Remove unused function ReadEFuseByte()
      staging: rtl8188eu: Remove unused function EFUSE_Read1Byte()
      staging: rtl8188eu: efuse_OneByteRead():Remove unused parameter bool test
      staging: rtl8188eu: efuse_OneByteWrite(): Remove unused parameter bool test
      staging: rtl8188eu: efuse_ReadEFuse(): Remove parameter bool bPseudoTest
      staging: rtl8188eu: Efuse_GetCurrentSize(): Remove parameter bool test
      staging: rtl8188eu: Efuse_ReadAllMap(): Remove unused parameter bool test
      staging: rtl8188eu: EFUSE_ShadowMapUpdate():Remove unused parameter bool test
      staging: rtl8188eu: Efuse_WordEnableDataWrite(): Remove unused parameter test
      staging: rtl8188eu: hal_EfuseCheckIfDatafollowed(): Remove unused parameter
      staging: rtl8188eu: Remove bool bPseudoTest parameter from efuse functions
      staging: rtl8188eu: rtl8188e_hal_init.c: Remove forward declarations
      staging: rtl8188eu: hal_EfusePartialWriteCheck(): Remove bluetooth specific code
      staging: rtl8188eu: rtw_efuse.c: Remove unused global variables
      staging: rtl8188eu: rtw_efuse.c: Remove unused local variables
      staging: rtl8188eu: rtw_efuse.c: Remove unnecessary comments
      staging: rtl8188eu: Move all efuse related code to rtw_efuse.c
      staging: rtl8188eu: Merge hal/usb_ops_linux.c into os_dep/usb_ops_linux.c
      staging: rtl8188eu: Remove macros specific to kernel version < 2.6.12
      staging:rtl8188eu:usb_ops.h:Remove unused enum, macros and function declaration
      staging: rtl8188eu: usb_ops.h: Remove macro rtw_usb_control_msg()
      staging: rtl8188eu: Remove inline function rtw_inc_and_chk_continual_urb_error()
      staging: rtl8188eu: Remove continual_urb_error from struct dvobj_priv
      staging: rtl8188eu: Merge usb_ops.h into usb_ops_linux.h
      staging: rtl8188eu: Remove dummy function odm_DynamicTxPower()
      staging: rtl8188eu: Remove dummy function CheckFwRsvdPageContent()
      staging: rtl8188eu: Remove dummy rtl8188e_GetHalODMVar() and its wrapper
      staging: rtl8188eu: Remove dummy rtl8188e_start_thread() and its wrapper
      staging: rtl8188eu: Remove dummy rtl8188e_stop_thread() and its wrapper
      staging: rtl8188eu: Remove dummy function Hal_InitChannelPlan()
      staging: rtl8188eu: Remove dummy rtl8188eu_free_xmit_priv() and its wrapper
      staging: rtl8188eu: Remove function _rtw_memset()
      staging: rtl8188eu: Remove rtw_mfree2d(), wrapper for kfree()
      staging: rtl8188eu: Remove unused function rtw_list_insert_head()
      staging: rtl8188eu: Remove rtw_list_insert_tail(), wrapper for list_add_tail()
      staging: rtl8188eu: Remove function rtw_end_of_queue_search()
      staging: rtl8188eu: Remove rtw_is_list_empty(), wrapper for list_emty()
      staging: rtl8188eu: Remove _rtw_init_listhead(), wrapper for INIT_LIST_HEAD()
      staging: rtl8188eu: Remove unused function rtw_sleep_schedulable()
      staging: rtl8188eu: Use kstrtoul() for string to long conversion
      staging: rtl8188eu:Remove rtw_zmalloc(), wrapper for kzalloc()
      staging: rtl8188eu: Remove unused function rtw_division64()
      staging: rtl8188eu: Remove unused function rtw_get_time_interval_ms()
      staging: rtl8188eu: osdep_service.h: Remove unused macro, enum and variables
      staging: rtl8188eu: Replace rtw_list_delete() with list_del_init()
      staging: rtl8188eu: osdep_service.c: Remove unused macro
      staging: rtl8188eu: Replace _rtw_queue_empty() with list_empty()
      staging: rtl8188eu: Replace _cancel_workitem_sync() with cancel_work_sync()
      staging: rtl8188eu: Remove unused inline function _RND512()
      staging: rtl8188eu: Replace _cancel_timer_ex() with del_timer_sync()
      staging: rtl8188eu: Use cpu_to_be32() instead of RTW_PUT_BE32()
      staging: rtl8188eu: Use cpu_to_be16() instead of RTW_PUT_BE16()
      staging: rtl8188eu: Use get_unaligned_be16() instead of RTW_GET_BE16()
      staging: rtl8188eu: Remove unused inline function bitshift()
      staging: rtl8188eu: Use get_unaligned_le16() instead of RTW_GET_LE16()
      staging: rtl8188eu: Use cpu_to_le16() insted of RTW_PUT_LE16()
      staging: rtl8188eu: osdep_service.h: Remove unused function definations
      staging: rtl8188eu: Remove unused inline function _RND256()
      staging: rtl8188eu: Use round_up() instead of _RND128()
      staging: rtl8188eu: Use round_up() instead of _RND8()
      staging: rtl8188eu: Use round_up() instead of _RND4()
      staging: rtl8188eu: osdep_service.h: Remove unused macros
      staging: rtl8188eu: Use round_up() instead of RND4()
      staging: rtl8188eu: Remove function thread_enter()
      staging: rtl8188eu: Remove function flush_signals_thread()
      staging: rtl8188eu: Replace _cancel_timer() with del_timer_sync()
      staging: rtl8188eu: Remove WEXT_PRIV private ioctl handlers
      staging: rtl8188eu: Remove files rtw_mp_ioctl.[c,h]
      staging: rtl8188eu: Remove usb_osintf.h header file.
      staging: rtl8188eu: Remove mp( mesh point) mode support
      staging: rtl8188eu: Remove P2P support
      staging: rtl8188eu: Remove struct evt_priv and its uses
      staging: rtl8188eu: Remove function c2h_evt_hdl()
      staging: rtl8188eu: Remove unused function c2h_evt_read()
      staging: rtl8188eu: Remove unused function c2h_evt_clear()
      staging: rtl8188eu: Remove dummy function rtw_hal_c2h_handler()
      staging: rtl8188eu: Remove unused function rtw_hal_c2h_id_filter_ccx()
      staging: rtl8188eu: rtw_cmd.h: Remove unused macro and structure
      staging: rtl8188eu: Remove unused function rtw_getrttbl_cmd()
      staging: rtl8188eu: Remove unused function rtw_c2h_wk_cmd()
      staging: rtl8188eu: Remove unused function rtw_setbasicrate_cmd()
      staging: rtl8188eu: Remove unused function rtw_setphy_cmd()
      staging: rtl8188eu: Remove unused function rtw_setbbreg_cmd()
      staging: rtl8188eu: Remove unused function rtw_getbbreg_cmd()
      staging: rtl8188eu: Remove unused function rtw_[set, get]rfreg_cmd()
      staging: rtl8188eu: Remove unused function rtw_setrttbl_cmd()
      staging: rtl8188eu: Remove unused function rtw_set_ch_cmd()
      staging: rtl8188eu: Remove unused function rtw_set_csa_cmd()
      staging: rtl8188eu: Remove dummy function rtw_tdls_cmd()
      staging: rtl8188eu: Remove unused function rtw_setassocsta_cmd()
      staging: rtl8188eu: Remove unused function rtw_setstandby_cmd()
      staging: rtl8188eu: Remove unused function rtw_createbss_cmd_ex()
      staging: rtl8188eu: rtw_cmd.h: Remove unused function declaration
      staging: rtl8188eu: rtw_cmd.h: Remove unused macros
      staging: rtl8188eu: rtw_cmd.h: Remove unused structures
      staging: rtl8188eu: Remove unused function rtw_cmd_clr_isr()
      staging: rtl8188eu: rtw_cmd.h: Remove struct [join, create]bss_parm
      staging: rtl8188eu: rtw_cmd.h: Remove struct Tx_Beacon_param
      staging: rtl8188eu: Remove header file cmd_osdep.h
      staging: rtl8188eu: Remove wrapper function power_saving_wk_hdl()
      staging: rtl8188eu: Rename _rtw_init_cmd_priv() to rtw_init_cmd_priv()
      staging: rtl8188eu: Rename _rtw_free_cmd_priv() to rtw_free_cmd_priv()
      staging: rtl8188eu: Rename _rtw_dequeue_cmd() to rtw_dequeue_cmd()
      staging: rtl8188eu: Remove unused member rsp_cnt from struct cmd_priv
      staging: rtl8188eu: Remove unused member cmd_issued_cnt from struct cmd_priv
      staging: rtl8188eu: Remove unused member cmd_done_cnt from struct cmd_priv
      staging: rtl8188eu: Remove unused members rsp_[allocated, ]_buf from struct cmd_priv
      staging: rtl8188eu: Remove members cmd_[allocated,]_buf from struct cmd_priv
      staging: rtl8188eu: Remove function rtw_getbbrfreg_cmdrsp_callback()
      staging: rtl8188eu: Remove function rtw_setdatarate_cmd()
      staging: rtl8188eu: rtw_[cmd, mlme_ext].h: Remove unused command codes
      staging: rtl8188eu: rtw_cmd.h: Remove unused structures
      staging: rtl8188eu: Remove command _TDLS and its handler
      staging: rtl8188eu: Remove command _SetChannelSwitch and its handler
      staging: rtl8188eu: Remove command _LedBlink and its handler
      staging: rtl8188eu: Remove command _Set_H2C_MSG and its handler
      staging: rtl8188eu: rtw_cmd.h: Remove unused structures
      staging: rtl8188eu: Remove cmd_seq from struct cmd_priv
      staging: rtl8188eu: Remove dummy function rtw_free_cmd_priv()
      staging: rtl8188eu: Remove unused function rtw_change_ifname()
      staging: rtl8188eu: Remove function rtw_alloc_etherdev()
      staging: rtl8188eu: Remove unused function efuse_GetCurrentSize()
      staging: rtl8188eu: Remove function efuse_GetMaxSize()
      staging: rtl8188eu: rtw_efuse.c : Remove unused functions
      staging: rtl8188eu: Remove unused functions rtw_efuse_map_[read, write]()
      staging: rtl8188eu: Remove unused function HalDetectPwrDownMode88E()
      staging: rtl8188eu: rtw_efuse.c: Remove unused functions
      staging: rtl8188eu: use jiffies_to_msecs() instead of rtw_systime_to_ms()
      staging: rtl8188eu: Use msecs_to_jiffies() instead of rtw_ms_to_systime()
      staging: rtl8188eu: Remove unused function rtw_cbuf_alloc()
      staging: rtl8188eu: Remove unused functions rtw_cbuf_[full, empty, push, pop]()
      staging: rtl8188eu: osdep_service.h: Remove unused struct rtw_cbuf
      staging: rtl8188eu: Remove unused function rtw_use_tkipkey_handler()
      staging: rtl8188eu: Remove function rtw_set_channel_plan()
      staging: rtl8188eu: Remove unused function rtw_set_scan_mode()
      staging: rtl8188eu: Remove unused function rtw_validate_ssid()
      staging: rtl8188eu: Remove unused function rtw_set_802_11_add_key()
      staging: rtl8188eu: Remove unused function rtw_set_802_11_remove_key()
      staging: rtl8188eu: Remove unused function rtw_set_802_11_remove_wep()
      staging: rtl8188eu: Remove unused function _rtw_IOL_append_WW_cmd()
      staging: rtl8188eu: Remove unused function rtw_get_timestampe_from_ie()
      staging: rtl8188eu: Rename _rtw_free_network_queue() to rtw_free_network_queue()
      staging: rtl8188eu: Rename _rtw_find_network() to rtw_find_network()
      staging: rtl8188eu: Make _rtw_free_network() static
      staging: rtl8188eu: Remove unused function _rtw_dequeue_network()
      staging: rtl8188eu: Remove unused function _rtw_enqueue_network()
      staging: rtl8188eu: Rename _rtw_free_mlme_priv() to rtw_free_mlme_priv()
      staging: rtl8188eu: Rename _rtw_init_mlme_priv() to rtw_init_mlme_priv()
      staging: rtl8188eu: Remove unused member MultiFunc from struct hal_data_8188e
      staging: rtl8188eu: Remove wrapper function rtw_join_timeout_handler()
      staging: rtl8188eu: Remove wrapper function _rtw_scan_timeout_handler()
      staging: rtl8188eu: Remove wrapper function _dynamic_check_timer_handlder()
      staging: rtl8188eu: Remove wrapper function _survey_timer_hdl()
      staging: rtl8188eu: Remove wrapper function _link_timer_hdl()
      staging: rtl8188eu: Remove wrapper function _addba_timer_hdl()
      staging: rtl8188eu: Remove unused function rtw_os_read_port()
      staging: rtl8188eu: Remove wrapper function _rtw_reordering_ctrl_timeout_handler()

sanjeev sharma (2):
      staging: rtl8192u: Remove useless return statement
      staging: rtl8192u: Fixed switch and case indentation error

 Documentation/ABI/testing/sysfs-bus-iio            |   95 +
 .../ABI/testing}/sysfs-bus-iio-trigger-sysfs       |    0
 .../devicetree/bindings/arm/samsung/exynos-adc.txt |   25 +-
 .../devicetree/bindings/i2c/trivial-devices.txt    |    1 +
 .../devicetree/bindings/iio/adc/max1027-adc.txt    |   22 +
 .../bindings/iio/magnetometer/hmc5843.txt          |    4 +
 .../devicetree/bindings/iio/st-sensors.txt         |   54 +
 Documentation/kernel-parameters.txt                |    4 -
 MAINTAINERS                                        |   67 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |    5 +-
 arch/arm/mach-omap2/Makefile                       |    4 -
 arch/arm/mach-omap2/common.c                       |    2 -
 arch/arm/mach-omap2/dsp.c                          |  134 -
 .../cavium-octeon/executive/cvmx-helper-sgmii.c    |   12 +-
 arch/mips/configs/cavium_octeon_defconfig          |    1 -
 arch/parisc/configs/generic-64bit_defconfig        |    1 -
 arch/powerpc/configs/85xx/kmp204x_defconfig        |    1 -
 drivers/base/component.c                           |  192 +-
 drivers/base/devres.c                              |   55 +
 drivers/iio/accel/Kconfig                          |   12 +
 drivers/iio/accel/Makefile                         |    1 +
 drivers/iio/accel/kxcjk-1013.c                     |  764 ++
 drivers/iio/accel/mma8452.c                        |    6 +
 drivers/iio/accel/st_accel_core.c                  |   12 +-
 drivers/iio/accel/st_accel_i2c.c                   |   51 +
 drivers/iio/adc/Kconfig                            |   19 +
 drivers/iio/adc/Makefile                           |    2 +
 drivers/{staging => }/iio/adc/ad7291.c             |  107 +-
 drivers/iio/adc/ad7298.c                           |   21 +-
 drivers/iio/adc/ad7476.c                           |    5 +-
 drivers/iio/adc/ad7887.c                           |   21 +-
 drivers/iio/adc/ad799x.c                           |  507 +-
 drivers/iio/adc/ad_sigma_delta.c                   |    2 +-
 drivers/iio/adc/at91_adc.c                         |    2 +-
 drivers/iio/adc/exynos_adc.c                       |  335 +-
 drivers/iio/adc/max1027.c                          |  521 ++
 drivers/iio/adc/xilinx-xadc-core.c                 |    2 +-
 drivers/iio/adc/xilinx-xadc-events.c               |    6 -
 .../iio/common/hid-sensors/hid-sensor-attributes.c |    5 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |   64 +-
 drivers/iio/common/st_sensors/st_sensors_i2c.c     |   30 +
 drivers/iio/dac/Kconfig                            |   10 +
 drivers/iio/dac/Makefile                           |    1 +
 drivers/iio/dac/ad5504.c                           |   16 +-
 drivers/iio/dac/ad5624r_spi.c                      |    5 +-
 drivers/iio/dac/ad5686.c                           |    3 +-
 drivers/iio/dac/ad5791.c                           |   29 +-
 drivers/iio/dac/mcp4922.c                          |  216 +
 drivers/iio/gyro/adis16260.c                       |  124 +-
 drivers/iio/gyro/itg3200_core.c                    |  101 +-
 drivers/iio/gyro/st_gyro_core.c                    |   12 +-
 drivers/iio/gyro/st_gyro_i2c.c                     |   39 +
 drivers/iio/imu/adis16400_buffer.c                 |    3 +-
 drivers/iio/imu/adis16400_core.c                   |   78 +-
 drivers/iio/imu/adis16480.c                        |   82 +-
 drivers/iio/industrialio-buffer.c                  |    5 +-
 drivers/iio/industrialio-core.c                    |    4 +
 drivers/iio/industrialio-event.c                   |    1 +
 drivers/iio/industrialio-trigger.c                 |    8 +-
 drivers/iio/light/Kconfig                          |   24 +
 drivers/iio/light/Makefile                         |    2 +
 drivers/iio/light/cm32181.c                        |   11 +-
 drivers/iio/light/gp2ap020a00f.c                   |    2 +-
 drivers/iio/light/isl29125.c                       |  347 +
 drivers/iio/light/tcs3414.c                        |  405 ++
 drivers/iio/magnetometer/Kconfig                   |   10 +
 drivers/iio/magnetometer/Makefile                  |    1 +
 drivers/iio/magnetometer/ak09911.c                 |  326 +
 drivers/iio/magnetometer/ak8975.c                  |   58 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |  202 +-
 drivers/iio/magnetometer/st_magn_core.c            |   12 +-
 drivers/iio/magnetometer/st_magn_i2c.c             |   23 +
 drivers/iio/pressure/Kconfig                       |   10 +
 drivers/iio/pressure/Makefile                      |    1 +
 drivers/iio/pressure/st_pressure_core.c            |   27 +-
 drivers/iio/pressure/st_pressure_i2c.c             |   23 +
 drivers/iio/pressure/t5403.c                       |  275 +
 drivers/iio/proximity/as3935.c                     |    2 +-
 drivers/iio/trigger/iio-trig-interrupt.c           |    3 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |    2 +-
 drivers/staging/Kconfig                            |   32 +-
 drivers/staging/Makefile                           |   17 +-
 drivers/staging/android/Kconfig                    |    2 +-
 drivers/staging/android/alarm-dev.c                |    2 +-
 drivers/staging/android/binder.c                   |  225 +-
 drivers/staging/android/ion/Kconfig                |    2 +-
 drivers/staging/android/ion/ion.h                  |    1 -
 drivers/staging/android/ion/ion_chunk_heap.c       |    2 +-
 drivers/staging/android/ion/ion_cma_heap.c         |    9 +-
 drivers/staging/android/ion/ion_system_heap.c      |   71 +-
 drivers/staging/android/logger.c                   |    7 +-
 drivers/staging/android/sync.c                     |    3 +-
 drivers/staging/android/timed_gpio.c               |   15 +-
 drivers/staging/android/timed_output.c             |    4 +-
 drivers/staging/bcm/Bcmchar.c                      |    2 +-
 drivers/staging/bcm/CmHost.c                       |    3 +-
 drivers/staging/bcm/DDRInit.c                      |  338 +-
 drivers/staging/bcm/HandleControlPacket.c          |   24 +-
 drivers/staging/bcm/IPv6Protocol.c                 |  217 +-
 drivers/staging/bcm/InterfaceDld.c                 |    1 +
 drivers/staging/bcm/InterfaceInit.c                |  304 +-
 drivers/staging/bcm/InterfaceMisc.c                |  126 +-
 drivers/staging/bcm/InterfaceRx.c                  |  206 +-
 drivers/staging/bcm/InterfaceTx.c                  |  185 +-
 drivers/staging/bcm/LeakyBucket.c                  |  312 +-
 drivers/staging/bcm/Misc.c                         |   27 +-
 drivers/staging/bcm/PHSModule.c                    | 1099 +--
 drivers/staging/bcm/PHSModule.h                    |   25 +-
 drivers/staging/bcm/Prototypes.h                   |   89 +-
 drivers/staging/bcm/Qos.c                          | 1053 ++-
 drivers/staging/bcm/Queue.h                        |   46 +-
 drivers/staging/bcm/TODO                           |    4 +
 drivers/staging/bcm/Transmit.c                     |   88 +-
 drivers/staging/bcm/hostmibs.c                     |   62 +-
 drivers/staging/bcm/led_control.c                  |  668 +-
 drivers/staging/bcm/led_control.h                  |   16 +-
 drivers/staging/bcm/nvm.c                          |  146 +-
 drivers/staging/board/Kconfig                      |    9 +
 drivers/staging/board/Makefile                     |    2 +
 drivers/staging/board/TODO                         |    2 +
 drivers/staging/board/board.c                      |   41 +
 drivers/staging/board/board.h                      |   20 +
 drivers/staging/board/kzm9d.c                      |   19 +
 drivers/staging/ced1401/Kconfig                    |    6 -
 drivers/staging/ced1401/Makefile                   |    3 -
 drivers/staging/ced1401/TODO                       |   10 -
 drivers/staging/ced1401/ced_ioc.c                  | 1494 ----
 drivers/staging/ced1401/ced_ioctl.h                |  336 -
 drivers/staging/ced1401/machine.h                  |  119 -
 drivers/staging/ced1401/usb1401.c                  | 1582 ----
 drivers/staging/ced1401/usb1401.h                  |  246 -
 drivers/staging/ced1401/use1401.h                  |  288 -
 drivers/staging/ced1401/use14_ioc.h                |  299 -
 drivers/staging/ced1401/userspace/use1401.c        | 3035 --------
 drivers/staging/comedi/Kconfig                     |   24 +-
 drivers/staging/comedi/comedi.h                    |  127 +-
 drivers/staging/comedi/comedi_compat32.c           |   28 +-
 drivers/staging/comedi/comedi_compat32.h           |    3 +-
 drivers/staging/comedi/comedi_fops.c               |   93 +-
 drivers/staging/comedi/comedi_internal.h           |    1 +
 drivers/staging/comedi/comedidev.h                 |  152 +-
 drivers/staging/comedi/drivers.c                   |    9 +-
 drivers/staging/comedi/drivers/8253.h              |    6 +-
 drivers/staging/comedi/drivers/8255.c              |    3 +-
 drivers/staging/comedi/drivers/8255_pci.c          |   27 +-
 drivers/staging/comedi/drivers/Makefile            |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   10 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |   20 -
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    9 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    7 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  321 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   61 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |  228 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  391 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |   11 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |    8 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   84 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  101 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  161 +-
 drivers/staging/comedi/drivers/adq12b.c            |  148 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   22 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    5 +-
 drivers/staging/comedi/drivers/adv_pci1724.c       |   15 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   11 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    3 +-
 drivers/staging/comedi/drivers/amcc_s5933.h        |    8 +-
 drivers/staging/comedi/drivers/amplc_dio200.c      |    3 +-
 drivers/staging/comedi/drivers/amplc_dio200.h      |   13 -
 .../staging/comedi/drivers/amplc_dio200_common.c   |   45 +-
 drivers/staging/comedi/drivers/amplc_dio200_pci.c  |   45 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |  591 +-
 drivers/staging/comedi/drivers/amplc_pc236.h       |   42 +
 .../staging/comedi/drivers/amplc_pc236_common.c    |  206 +
 drivers/staging/comedi/drivers/amplc_pc263.c       |    7 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |   26 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      | 1310 ++--
 drivers/staging/comedi/drivers/amplc_pci236.c      |  161 +
 drivers/staging/comedi/drivers/amplc_pci263.c      |   11 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 -
 drivers/staging/comedi/drivers/cb_pcidas.c         |   24 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  154 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    3 -
 drivers/staging/comedi/drivers/comedi_test.c       |    6 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    4 +-
 drivers/staging/comedi/drivers/daqboard2000.c      |   87 +-
 drivers/staging/comedi/drivers/das08.c             |    3 +-
 drivers/staging/comedi/drivers/das08_pci.c         |    4 +-
 drivers/staging/comedi/drivers/das16.c             |   16 +-
 drivers/staging/comedi/drivers/das16m1.c           |   13 +-
 drivers/staging/comedi/drivers/das1800.c           |  120 +-
 drivers/staging/comedi/drivers/das800.c            |    3 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   13 +-
 drivers/staging/comedi/drivers/dt2801.c            |    5 +-
 drivers/staging/comedi/drivers/dt2811.c            |    4 +-
 drivers/staging/comedi/drivers/dt2814.c            |   12 +-
 drivers/staging/comedi/drivers/dt2815.c            |    5 +-
 drivers/staging/comedi/drivers/dt2817.c            |    4 +-
 drivers/staging/comedi/drivers/dt282x.c            | 1351 ++--
 drivers/staging/comedi/drivers/dt3000.c            |  117 +-
 drivers/staging/comedi/drivers/dt9812.c            |    1 +
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   44 +-
 drivers/staging/comedi/drivers/icp_multi.c         |   94 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   68 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    5 +-
 drivers/staging/comedi/drivers/ke_counter.c        |   66 +-
 drivers/staging/comedi/drivers/me4000.c            |    1 -
 drivers/staging/comedi/drivers/me_daq.c            |   67 +-
 drivers/staging/comedi/drivers/mf6x4.c             |   47 +-
 drivers/staging/comedi/drivers/mite.c              |   46 +-
 drivers/staging/comedi/drivers/mite.h              |  136 +-
 drivers/staging/comedi/drivers/mpc624.c            |    5 +-
 drivers/staging/comedi/drivers/multiq3.c           |    8 +-
 drivers/staging/comedi/drivers/ni_6527.c           |  154 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |  797 ++-
 drivers/staging/comedi/drivers/ni_660x.c           |   67 +-
 drivers/staging/comedi/drivers/ni_670x.c           |   68 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |  254 +-
 drivers/staging/comedi/drivers/ni_atmio.c          |  392 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   14 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   89 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |  231 +-
 drivers/staging/comedi/drivers/ni_labpc.h          |    7 +-
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |    2 +-
 drivers/staging/comedi/drivers/ni_labpc_pci.c      |   51 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     | 5866 +++++++--------
 drivers/staging/comedi/drivers/ni_mio_cs.c         |  107 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |  374 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |  775 +-
 drivers/staging/comedi/drivers/ni_stc.h            |  187 +-
 drivers/staging/comedi/drivers/ni_tio.c            | 1759 ++---
 drivers/staging/comedi/drivers/ni_tio.h            |    4 +-
 drivers/staging/comedi/drivers/ni_tio_internal.h   |  387 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |  140 +-
 drivers/staging/comedi/drivers/pcl711.c            |    2 +-
 drivers/staging/comedi/drivers/pcl724.c            |   11 +-
 drivers/staging/comedi/drivers/pcl730.c            |   21 +-
 drivers/staging/comedi/drivers/pcl812.c            |    2 +-
 drivers/staging/comedi/drivers/pcl816.c            |  118 +-
 drivers/staging/comedi/drivers/pcl818.c            |    9 +-
 drivers/staging/comedi/drivers/pcm3724.c           |   18 +-
 drivers/staging/comedi/drivers/pcmuio.c            |    1 +
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   12 +-
 drivers/staging/comedi/drivers/rtd520.c            |  207 +-
 drivers/staging/comedi/drivers/rti800.c            |    4 +-
 drivers/staging/comedi/drivers/s526.c              |    6 +-
 drivers/staging/comedi/drivers/s626.c              |  890 +--
 drivers/staging/comedi/drivers/s626.h              |   28 +-
 drivers/staging/comedi/drivers/serial2002.c        |  112 +-
 drivers/staging/comedi/drivers/skel.c              |    9 +-
 drivers/staging/comedi/drivers/unioxx5.c           |    3 +-
 drivers/staging/comedi/drivers/usbdux.c            |   12 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    8 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   14 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |    1 -
 drivers/staging/cptm1217/clearpad_tm1217.c         |   15 +-
 drivers/staging/crystalhd/Kconfig                  |    6 -
 drivers/staging/crystalhd/Makefile                 |    6 -
 drivers/staging/crystalhd/TODO                     |   15 -
 drivers/staging/crystalhd/bc_dts_defs.h            |  572 --
 drivers/staging/crystalhd/bc_dts_glob_lnx.h        |  300 -
 drivers/staging/crystalhd/bcm_70012_regs.h         |  758 --
 drivers/staging/crystalhd/crystalhd.h              |   13 -
 drivers/staging/crystalhd/crystalhd_cmds.c         | 1066 ---
 drivers/staging/crystalhd/crystalhd_cmds.h         |   92 -
 drivers/staging/crystalhd/crystalhd_fw_if.h        |  370 -
 drivers/staging/crystalhd/crystalhd_hw.c           | 2458 -------
 drivers/staging/crystalhd/crystalhd_hw.h           |  407 --
 drivers/staging/crystalhd/crystalhd_lnx.c          |  782 --
 drivers/staging/crystalhd/crystalhd_lnx.h          |   93 -
 drivers/staging/crystalhd/crystalhd_misc.c         | 1044 ---
 drivers/staging/crystalhd/crystalhd_misc.h         |  232 -
 drivers/staging/cxt1e1/Kconfig                     |   21 -
 drivers/staging/cxt1e1/Makefile                    |   18 -
 drivers/staging/cxt1e1/comet.c                     |  596 --
 drivers/staging/cxt1e1/comet.h                     |  353 -
 drivers/staging/cxt1e1/comet_tables.c              |  538 --
 drivers/staging/cxt1e1/comet_tables.h              |   61 -
 drivers/staging/cxt1e1/functions.c                 |  318 -
 drivers/staging/cxt1e1/hwprobe.c                   |  382 -
 drivers/staging/cxt1e1/libsbew.h                   |  549 --
 drivers/staging/cxt1e1/linux.c                     | 1142 ---
 drivers/staging/cxt1e1/musycc.c                    | 1720 -----
 drivers/staging/cxt1e1/musycc.h                    |  427 --
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |  532 --
 drivers/staging/cxt1e1/pmc93x6_eeprom.h            |   39 -
 drivers/staging/cxt1e1/pmcc4.h                     |  108 -
 drivers/staging/cxt1e1/pmcc4_cpld.h                |   91 -
 drivers/staging/cxt1e1/pmcc4_defs.h                |   68 -
 drivers/staging/cxt1e1/pmcc4_drv.c                 | 1613 -----
 drivers/staging/cxt1e1/pmcc4_ioctls.h              |   65 -
 drivers/staging/cxt1e1/pmcc4_private.h             |  295 -
 drivers/staging/cxt1e1/pmcc4_sysdep.h              |   63 -
 drivers/staging/cxt1e1/sbe_bid.h                   |   47 -
 drivers/staging/cxt1e1/sbe_promformat.h            |  130 -
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |  193 -
 drivers/staging/cxt1e1/sbecrc.c                    |  133 -
 drivers/staging/cxt1e1/sbeid.c                     |  205 -
 drivers/staging/cxt1e1/sbeproc.c                   |  219 -
 drivers/staging/cxt1e1/sbeproc.h                   |   42 -
 drivers/staging/cxt1e1/sbew_ioc.h                  |   81 -
 drivers/staging/dgap/dgap.c                        |  662 +-
 drivers/staging/dgap/dgap.h                        |    2 -
 drivers/staging/dgnc/Makefile                      |    2 +-
 drivers/staging/dgnc/dgnc_cls.c                    |   14 +-
 drivers/staging/dgnc/dgnc_driver.c                 |   19 +-
 drivers/staging/dgnc/dgnc_driver.h                 |   57 +-
 drivers/staging/dgnc/dgnc_neo.c                    |    1 -
 drivers/staging/dgnc/dgnc_sysfs.c                  |   20 +-
 drivers/staging/dgnc/dgnc_trace.c                  |  185 -
 drivers/staging/dgnc/dgnc_trace.h                  |   44 -
 drivers/staging/dgnc/dgnc_tty.c                    |   53 +-
 drivers/staging/dgnc/digi.h                        |   35 +-
 drivers/staging/dgrp/Kconfig                       |    9 -
 drivers/staging/dgrp/Makefile                      |   12 -
 drivers/staging/dgrp/README                        |    2 -
 drivers/staging/dgrp/TODO                          |   13 -
 drivers/staging/dgrp/dgrp_common.c                 |  169 -
 drivers/staging/dgrp/dgrp_common.h                 |  150 -
 drivers/staging/dgrp/dgrp_dpa_ops.c                |  534 --
 drivers/staging/dgrp/dgrp_driver.c                 |  105 -
 drivers/staging/dgrp/dgrp_mon_ops.c                |  327 -
 drivers/staging/dgrp/dgrp_net_ops.c                | 3666 ----------
 drivers/staging/dgrp/dgrp_ports_ops.c              |  156 -
 drivers/staging/dgrp/dgrp_specproc.c               |  541 --
 drivers/staging/dgrp/dgrp_sysfs.c                  |  558 --
 drivers/staging/dgrp/dgrp_tty.c                    | 3337 ---------
 drivers/staging/dgrp/digirp.h                      |  129 -
 drivers/staging/dgrp/drp.h                         |  693 --
 drivers/staging/emxx_udc/Kconfig                   |   10 +
 drivers/staging/emxx_udc/Makefile                  |    1 +
 drivers/staging/emxx_udc/TODO                      |    4 +
 drivers/staging/emxx_udc/emxx_udc.c                | 3520 +++++++++
 drivers/staging/emxx_udc/emxx_udc.h                |  653 ++
 drivers/staging/et131x/et131x.c                    |   26 +-
 drivers/staging/et131x/et131x.h                    |   46 +-
 drivers/staging/frontier/Kconfig                   |    5 -
 drivers/staging/frontier/Makefile                  |    2 -
 drivers/staging/frontier/README                    |   47 -
 drivers/staging/frontier/TODO                      |    9 -
 drivers/staging/frontier/alphatrack.c              |  849 ---
 drivers/staging/frontier/alphatrack.h              |   78 -
 drivers/staging/frontier/tranzport.c               |  973 ---
 drivers/staging/ft1000/ft1000-pcmcia/Makefile      |    3 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |    2 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    4 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |  211 -
 drivers/staging/ft1000/ft1000-usb/Makefile         |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   25 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |  241 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    8 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    5 +-
 drivers/staging/ft1000/ft1000.h                    |    2 -
 drivers/staging/fwserial/fwserial.c                |    6 +-
 drivers/staging/gdm724x/gdm_lte.c                  |    2 +
 drivers/staging/gdm724x/gdm_tty.c                  |    5 +
 drivers/staging/gdm724x/gdm_usb.c                  |   40 +-
 drivers/staging/gdm724x/netlink_k.c                |    2 +-
 drivers/staging/gdm72xx/Kconfig                    |   19 +-
 drivers/staging/gdm72xx/gdm_qos.c                  |   61 +-
 drivers/staging/gdm72xx/gdm_qos.h                  |   18 +-
 drivers/staging/gdm72xx/gdm_sdio.c                 |  107 +-
 drivers/staging/gdm72xx/gdm_sdio.h                 |    6 +-
 drivers/staging/gdm72xx/gdm_usb.c                  |  121 +-
 drivers/staging/gdm72xx/gdm_usb.h                  |    6 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |  379 +-
 drivers/staging/gdm72xx/gdm_wimax.h                |   17 +-
 drivers/staging/gdm72xx/hci.h                      |   22 +-
 drivers/staging/gdm72xx/netlink_k.h                |    7 +-
 drivers/staging/gdm72xx/sdio_boot.h                |    6 +-
 drivers/staging/gdm72xx/usb_boot.c                 |   10 +-
 drivers/staging/gdm72xx/usb_boot.h                 |    6 +-
 drivers/staging/gdm72xx/usb_ids.h                  |    6 +-
 drivers/staging/gdm72xx/wm_ioctl.h                 |    7 +-
 drivers/staging/goldfish/goldfish_audio.c          |   65 +-
 drivers/staging/iio/Documentation/generic_buffer.c |    9 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |    8 +
 drivers/staging/iio/Documentation/iio_utils.h      |    6 +-
 drivers/staging/iio/Documentation/trigger.txt      |    2 +-
 drivers/staging/iio/accel/adis16201_core.c         |   14 +-
 drivers/staging/iio/accel/adis16203_core.c         |   11 +-
 drivers/staging/iio/accel/adis16204_core.c         |   12 +-
 drivers/staging/iio/accel/adis16209_core.c         |   18 +-
 drivers/staging/iio/accel/adis16240_core.c         |   12 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/accel/sca3000_ring.c           |    6 +
 drivers/staging/iio/adc/Kconfig                    |    9 +-
 drivers/staging/iio/adc/Makefile                   |    1 -
 drivers/staging/iio/adc/ad7606_par.c               |   37 +-
 drivers/staging/iio/adc/mxs-lradc.c                |    2 +-
 drivers/staging/iio/frequency/ad9832.c             |   16 +-
 drivers/staging/iio/frequency/ad9850.c             |    6 -
 drivers/staging/iio/iio_simple_dummy.c             |    2 +
 drivers/staging/iio/magnetometer/Kconfig           |   30 +-
 drivers/staging/iio/magnetometer/Makefile          |    4 +-
 drivers/staging/iio/magnetometer/hmc5843.h         |   59 +
 .../iio/magnetometer/{hmc5843.c => hmc5843_core.c} |  266 +-
 drivers/staging/iio/magnetometer/hmc5843_i2c.c     |  104 +
 drivers/staging/iio/magnetometer/hmc5843_spi.c     |  100 +
 drivers/staging/iio/meter/ade7758_trigger.c        |    2 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   33 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   29 +-
 drivers/staging/imx-drm/imx-drm-core.c             |   57 +-
 drivers/staging/keucr/Kconfig                      |   14 -
 drivers/staging/keucr/Makefile                     |   13 -
 drivers/staging/keucr/TODO                         |   12 -
 drivers/staging/keucr/common.h                     |    7 -
 drivers/staging/keucr/init.c                       |  333 -
 drivers/staging/keucr/init.h                       |  518 --
 drivers/staging/keucr/scsiglue.c                   |  467 --
 drivers/staging/keucr/scsiglue.h                   |   10 -
 drivers/staging/keucr/smcommon.h                   |   29 -
 drivers/staging/keucr/smil.h                       |  288 -
 drivers/staging/keucr/smilecc.c                    |  211 -
 drivers/staging/keucr/smilmain.c                   |  760 --
 drivers/staging/keucr/smilsub.c                    |  679 --
 drivers/staging/keucr/smscsi.c                     |  194 -
 drivers/staging/keucr/transport.c                  |  865 ---
 drivers/staging/keucr/transport.h                  |   73 -
 drivers/staging/keucr/usb.c                        |  642 --
 drivers/staging/keucr/usb.h                        |  240 -
 drivers/staging/line6/driver.c                     |    2 +-
 drivers/staging/lustre/Makefile                    |    2 -
 drivers/staging/lustre/TODO                        |    3 +-
 .../staging/lustre/include/linux/libcfs/bitmap.h   |    1 -
 .../staging/lustre/include/linux/libcfs/curproc.h  |    2 +-
 .../staging/lustre/include/linux/libcfs/libcfs.h   |   55 +-
 .../lustre/include/linux/libcfs/libcfs_debug.h     |   10 +-
 .../lustre/include/linux/libcfs/libcfs_fail.h      |    2 +
 .../lustre/include/linux/libcfs/libcfs_hash.h      |   18 +-
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |   33 +-
 .../include/linux/libcfs/libcfs_kernelcomm.h       |   17 +-
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    4 +-
 .../lustre/include/linux/libcfs/libcfs_private.h   |   43 +-
 .../lustre/include/linux/libcfs/libcfs_time.h      |   29 +-
 .../lustre/include/linux/libcfs/linux/kp30.h       |   93 -
 .../lustre/include/linux/libcfs/linux/libcfs.h     |   67 +-
 .../include/linux/libcfs/linux/linux-bitops.h      |   38 -
 .../lustre/include/linux/libcfs/linux/linux-cpu.h  |   84 -
 .../lustre/include/linux/libcfs/linux/linux-lock.h |  204 -
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   11 +-
 .../lustre/include/linux/libcfs/linux/linux-prim.h |   82 -
 .../include/linux/libcfs/linux/linux-tcpip.h       |   72 -
 .../lustre/include/linux/libcfs/linux/linux-time.h |  149 +-
 .../include/linux/libcfs/linux/linux-types.h       |   36 -
 .../include/linux/libcfs/linux/portals_compat25.h  |   22 +-
 .../staging/lustre/include/linux/libcfs/lucache.h  |   16 +-
 .../lustre/include/linux/libcfs/params_tree.h      |  164 -
 .../lustre/include/linux/lnet/api-support.h        |    8 +-
 drivers/staging/lustre/include/linux/lnet/api.h    |    5 +-
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |   50 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |   23 +-
 .../lustre/include/linux/lnet/linux/api-support.h  |    1 -
 .../lustre/include/linux/lnet/linux/lib-lnet.h     |    5 +-
 .../lustre/include/linux/lnet/lnet-sysctl.h        |    2 -
 drivers/staging/lustre/include/linux/lnet/lnet.h   |    6 +-
 .../staging/lustre/include/linux/lnet/lnetctl.h    |   22 +-
 drivers/staging/lustre/include/linux/lnet/lnetst.h |    6 +-
 drivers/staging/lustre/include/linux/lnet/ptllnd.h |    3 +-
 .../lustre/include/linux/lnet/ptllnd_wire.h        |    3 +-
 .../staging/lustre/include/linux/lnet/socklnd.h    |    4 +-
 drivers/staging/lustre/include/linux/lnet/types.h  |    4 +-
 drivers/staging/lustre/lnet/klnds/o2iblnd/Makefile |    3 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   39 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |   22 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   11 +-
 drivers/staging/lustre/lnet/klnds/socklnd/Makefile |    4 -
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   98 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |   46 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   43 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |    2 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  |    4 +-
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |   12 +-
 drivers/staging/lustre/lnet/lnet/Makefile          |    3 -
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   28 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |   34 +-
 drivers/staging/lustre/lnet/lnet/config.c          |    4 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    4 +-
 drivers/staging/lustre/lnet/lnet/lib-md.c          |   12 +-
 drivers/staging/lustre/lnet/lnet/lib-me.c          |   15 +-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |  108 +-
 drivers/staging/lustre/lnet/lnet/lib-msg.c         |    2 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |   18 +-
 drivers/staging/lustre/lnet/lnet/lo.c              |    2 +-
 drivers/staging/lustre/lnet/lnet/module.c          |    2 +-
 drivers/staging/lustre/lnet/lnet/peer.c            |    2 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   23 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   84 +-
 drivers/staging/lustre/lnet/selftest/Makefile      |    2 -
 drivers/staging/lustre/lnet/selftest/brw_test.c    |    2 +-
 drivers/staging/lustre/lnet/selftest/conctl.c      |    8 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |   16 +-
 drivers/staging/lustre/lnet/selftest/conrpc.h      |   10 +-
 drivers/staging/lustre/lnet/selftest/console.c     |   16 +-
 drivers/staging/lustre/lnet/selftest/console.h     |   10 +-
 drivers/staging/lustre/lnet/selftest/framework.c   |   12 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |   14 +-
 drivers/staging/lustre/lnet/selftest/rpc.h         |    2 +-
 drivers/staging/lustre/lnet/selftest/selftest.h    |   12 +-
 drivers/staging/lustre/lnet/selftest/timer.c       |   16 +-
 drivers/staging/lustre/lnet/selftest/timer.h       |    2 +-
 drivers/staging/lustre/lustre/Kconfig              |    1 +
 drivers/staging/lustre/lustre/fid/Makefile         |    3 -
 drivers/staging/lustre/lustre/fid/fid_internal.h   |    8 +-
 drivers/staging/lustre/lustre/fid/fid_lib.c        |    6 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |   38 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |   32 +-
 drivers/staging/lustre/lustre/fld/Makefile         |    3 -
 drivers/staging/lustre/lustre/fld/fld_cache.c      |   34 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |   12 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |   54 +-
 drivers/staging/lustre/lustre/fld/lproc_fld.c      |   25 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |    8 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    8 +-
 .../staging/lustre/lustre/include/interval_tree.h  |    2 +-
 .../lustre/lustre/include/linux/lprocfs_status.h   |    2 +-
 .../lustre/lustre/include/linux/lustre_acl.h       |    2 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 +-
 .../lustre/lustre/include/linux/lustre_fsfilt.h    |   10 +-
 .../lustre/lustre/include/linux/lustre_lib.h       |    4 +-
 .../lustre/lustre/include/linux/lustre_lite.h      |   10 +-
 drivers/staging/lustre/lustre/include/linux/lvfs.h |    6 +-
 .../lustre/lustre/include/linux/lvfs_linux.h       |    9 +-
 drivers/staging/lustre/lustre/include/linux/obd.h  |    4 +-
 .../lustre/lustre/include/linux/obd_support.h      |   10 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |   21 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |    6 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   17 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   14 +-
 drivers/staging/lustre/lustre/include/lustre_acl.h |    2 +-
 .../staging/lustre/lustre/include/lustre_capa.h    |   14 +-
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    4 +-
 .../staging/lustre/lustre/include/lustre_debug.h   |    4 +-
 .../staging/lustre/lustre/include/lustre_disk.h    |    4 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h |   28 +-
 .../staging/lustre/lustre/include/lustre_export.h  |   16 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 +-
 drivers/staging/lustre/lustre/include/lustre_fld.h |    4 +-
 .../staging/lustre/lustre/include/lustre_fsfilt.h  |    2 +-
 .../staging/lustre/lustre/include/lustre_handles.h |    4 +-
 .../staging/lustre/lustre/include/lustre_idmap.h   |    2 +-
 .../staging/lustre/lustre/include/lustre_import.h  |   10 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |   30 +-
 .../staging/lustre/lustre/include/lustre_lite.h    |   14 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   10 +-
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   16 +-
 drivers/staging/lustre/lustre/include/lustre_mds.h |   12 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |   58 +-
 .../staging/lustre/lustre/include/lustre_quota.h   |    8 +-
 .../lustre/lustre/include/lustre_req_layout.h      |    2 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |   10 +-
 drivers/staging/lustre/lustre/include/lvfs.h       |    6 +-
 drivers/staging/lustre/lustre/include/md_object.h  |    2 +-
 drivers/staging/lustre/lustre/include/obd.h        |   21 +-
 drivers/staging/lustre/lustre/include/obd_cksum.h  |    4 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |   32 +-
 drivers/staging/lustre/lustre/include/obd_ost.h    |    6 +-
 .../staging/lustre/lustre/include/obd_support.h    |   23 +-
 drivers/staging/lustre/lustre/lclient/glimpse.c    |   28 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   37 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |   16 +-
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |    6 +-
 drivers/staging/lustre/lustre/ldlm/l_lock.c        |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |   16 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   14 +-
 .../staging/lustre/lustre/ldlm/ldlm_inodebits.c    |    7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |   46 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   53 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |   15 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_plain.c    |    6 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   38 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |   38 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |   39 +-
 drivers/staging/lustre/lustre/libcfs/Makefile      |    3 -
 drivers/staging/lustre/lustre/libcfs/debug.c       |   10 +-
 drivers/staging/lustre/lustre/libcfs/fail.c        |   12 +-
 drivers/staging/lustre/lustre/libcfs/hash.c        |    2 +-
 drivers/staging/lustre/lustre/libcfs/heap.c        |    2 +-
 .../lustre/lustre/libcfs/kernel_user_comm.c        |    2 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |    2 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_lock.c |    2 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_mem.c  |    2 +-
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |    2 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |    2 +-
 .../lustre/libcfs/linux/linux-crypto-adler.c       |    5 +-
 .../lustre/lustre/libcfs/linux/linux-crypto.c      |    4 +-
 .../linux => lustre}/libcfs/linux/linux-crypto.h   |   20 -
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |    2 +-
 .../lustre/lustre/libcfs/linux/linux-debug.c       |    6 +-
 .../lustre/lustre/libcfs/linux/linux-module.c      |   16 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    6 +-
 .../lustre/lustre/libcfs/linux/linux-proc.c        |   94 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |   31 +-
 .../lustre/lustre/libcfs/linux/linux-tracefile.c   |    6 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |   11 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |    9 +-
 drivers/staging/lustre/lustre/libcfs/prng.c        |    2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    2 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.h   |    2 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |   26 +-
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    2 +-
 drivers/staging/lustre/lustre/llite/Makefile       |    3 -
 drivers/staging/lustre/lustre/llite/dcache.c       |   16 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   62 +-
 drivers/staging/lustre/lustre/llite/file.c         |   24 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |   24 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |    4 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   26 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   52 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |    6 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    2 +-
 drivers/staging/lustre/lustre/llite/llite_rmtacl.c |    4 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    4 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |   79 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   14 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |   14 +-
 drivers/staging/lustre/lustre/llite/rw.c           |   15 +-
 drivers/staging/lustre/lustre/llite/rw26.c         |    4 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |   30 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    8 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |    4 +-
 drivers/staging/lustre/lustre/llite/vvp_internal.h |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   10 +-
 drivers/staging/lustre/lustre/llite/vvp_lock.c     |    4 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |    6 +-
 drivers/staging/lustre/lustre/llite/vvp_page.c     |    4 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   11 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |    8 +-
 drivers/staging/lustre/lustre/lmv/Makefile         |    2 -
 drivers/staging/lustre/lustre/lmv/lmv_fld.c        |   20 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |   17 +-
 drivers/staging/lustre/lustre/lmv/lmv_internal.h   |    6 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   30 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    4 +-
 drivers/staging/lustre/lustre/lov/Makefile         |    4 -
 .../staging/lustre/lustre/lov/lov_cl_internal.h    |    6 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |    4 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |    8 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |    8 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |    6 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c      |   31 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |   52 +-
 drivers/staging/lustre/lustre/lov/lov_offset.c     |    6 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   12 +-
 drivers/staging/lustre/lustre/lov/lov_pool.c       |   10 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |   43 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |    8 +-
 drivers/staging/lustre/lustre/lvfs/Makefile        |    3 -
 drivers/staging/lustre/lustre/lvfs/fsfilt.c        |    4 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c      |    4 +-
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |   18 +-
 drivers/staging/lustre/lustre/mdc/Makefile         |    3 -
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   48 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    6 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    4 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   18 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |    6 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   34 +-
 drivers/staging/lustre/lustre/mgc/Makefile         |    3 -
 drivers/staging/lustre/lustre/mgc/libmgc.c         |   12 +-
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |    4 +-
 drivers/staging/lustre/lustre/mgc/mgc_internal.h   |   16 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   29 +-
 drivers/staging/lustre/lustre/obdclass/Makefile    |    3 -
 drivers/staging/lustre/lustre/obdclass/acl.c       |    8 +-
 drivers/staging/lustre/lustre/obdclass/capa.c      |   23 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |   10 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    8 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |   15 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    8 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   56 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |   24 +-
 drivers/staging/lustre/lustre/obdclass/dt_object.c |   22 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |   16 +-
 drivers/staging/lustre/lustre/obdclass/idmap.c     |    6 +-
 drivers/staging/lustre/lustre/obdclass/linkea.c    |    6 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |   20 +-
 .../lustre/lustre/obdclass/linux/linux-obdo.c      |    8 +-
 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   98 +-
 drivers/staging/lustre/lustre/obdclass/llog.c      |    6 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |    2 +-
 .../staging/lustre/lustre/obdclass/llog_internal.h |    2 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |    4 +-
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |   50 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |    4 +-
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  |   22 +-
 drivers/staging/lustre/lustre/obdclass/llog_swab.c |    6 +-
 drivers/staging/lustre/lustre/obdclass/llog_test.c |   12 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |   10 +-
 .../staging/lustre/lustre/obdclass/local_storage.h |    8 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |   48 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   18 +-
 drivers/staging/lustre/lustre/obdclass/lu_ref.c    |   10 +-
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c  |    8 +-
 .../lustre/lustre/obdclass/lustre_handles.c        |   14 +-
 .../staging/lustre/lustre/obdclass/lustre_peer.c   |   14 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |    6 +-
 drivers/staging/lustre/lustre/obdclass/mea.c       |    6 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   22 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   32 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    8 +-
 .../staging/lustre/lustre/obdclass/statfs_pack.c   |    8 +-
 drivers/staging/lustre/lustre/obdclass/uuid.c      |    6 +-
 drivers/staging/lustre/lustre/obdecho/Makefile     |    3 -
 drivers/staging/lustre/lustre/obdecho/echo.c       |   34 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |   40 +-
 drivers/staging/lustre/lustre/obdecho/lproc_echo.c |   16 +-
 drivers/staging/lustre/lustre/osc/Makefile         |    4 -
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |   12 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   13 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |   14 +-
 drivers/staging/lustre/lustre/osc/osc_dev.c        |   16 +-
 drivers/staging/lustre/lustre/osc/osc_internal.h   |    6 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |    4 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |   17 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |   12 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    6 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |    2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |   93 +-
 drivers/staging/lustre/lustre/ptlrpc/Makefile      |    5 -
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   92 +-
 drivers/staging/lustre/lustre/ptlrpc/connection.c  |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/errno.c       |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |   27 +-
 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile  |    8 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_api.h |  179 -
 .../staging/lustre/lustre/ptlrpc/gss/gss_asn1.h    |   84 -
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |  505 --
 .../lustre/lustre/ptlrpc/gss/gss_cli_upcall.c      |  446 --
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_err.h |  193 -
 .../lustre/lustre/ptlrpc/gss/gss_generic_token.c   |  296 -
 .../lustre/lustre/ptlrpc/gss/gss_internal.h        |  526 --
 .../staging/lustre/lustre/ptlrpc/gss/gss_keyring.c | 1409 ----
 .../staging/lustre/lustre/ptlrpc/gss/gss_krb5.h    |  163 -
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       | 1786 -----
 .../lustre/lustre/ptlrpc/gss/gss_mech_switch.c     |  358 -
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  | 1233 ----
 .../staging/lustre/lustre/ptlrpc/gss/gss_rawobj.c  |  242 -
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      | 1093 ---
 .../staging/lustre/lustre/ptlrpc/gss/lproc_gss.c   |  220 -
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c | 2889 --------
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   89 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |   16 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_client.c |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/llog_net.c    |   10 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   29 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   49 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs_fifo.c    |   14 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   38 +-
 drivers/staging/lustre/lustre/ptlrpc/pers.c        |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   26 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    6 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   19 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   26 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   42 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   40 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |   24 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c      |   16 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_lproc.c   |   20 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    |   21 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   |   22 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   84 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    8 +-
 drivers/staging/media/lirc/lirc_sir.c              |  301 +-
 drivers/staging/media/sn9c102/Kconfig              |    2 +-
 drivers/staging/netlogic/xlr_net.c                 |    1 -
 drivers/staging/nokia_h4p/nokia_core.c             |    1 +
 drivers/staging/nvec/nvec.c                        |   17 +-
 drivers/staging/nvec/nvec_paz00.c                  |    1 +
 drivers/staging/nvec/nvec_power.c                  |    1 +
 drivers/staging/nvec/nvec_ps2.c                    |    2 +
 drivers/staging/octeon-usb/octeon-hcd.c            |   69 +-
 drivers/staging/octeon/ethernet-mdio.c             |   79 +-
 drivers/staging/octeon/ethernet-mem.c              |   11 +-
 drivers/staging/octeon/ethernet-rgmii.c            |   23 +-
 drivers/staging/octeon/ethernet-sgmii.c            |   87 +-
 drivers/staging/octeon/ethernet-xaui.c             |   84 +-
 drivers/staging/octeon/ethernet.c                  |    2 +-
 drivers/staging/octeon/octeon-ethernet.h           |    4 +
 drivers/staging/panel/panel.c                      |    9 +-
 drivers/staging/phison/Kconfig                     |    5 -
 drivers/staging/phison/Makefile                    |    1 -
 drivers/staging/phison/phison.c                    |   94 -
 drivers/staging/quickstart/Kconfig                 |   10 -
 drivers/staging/quickstart/Makefile                |    1 -
 drivers/staging/quickstart/quickstart.c            |  458 --
 drivers/staging/rtl8188eu/Kconfig                  |    8 -
 drivers/staging/rtl8188eu/Makefile                 |    9 -
 drivers/staging/rtl8188eu/core/rtw_ap.c            |   60 +-
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        | 1191 ----
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |  933 +--
 drivers/staging/rtl8188eu/core/rtw_debug.c         |   28 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         | 1509 ++--
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |  262 +-
 drivers/staging/rtl8188eu/core/rtw_io.c            |  301 -
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c     |  480 +-
 drivers/staging/rtl8188eu/core/rtw_iol.c           |   14 -
 drivers/staging/rtl8188eu/core/rtw_led.c           |   52 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |  216 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      | 3330 +--------
 drivers/staging/rtl8188eu/core/rtw_mp.c            |  995 ---
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      | 1430 ----
 drivers/staging/rtl8188eu/core/rtw_p2p.c           | 2041 ------
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |  171 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   80 +-
 drivers/staging/rtl8188eu/core/rtw_security.c      |   59 +-
 drivers/staging/rtl8188eu/core/rtw_sreset.c        |   19 +-
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |   54 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |   19 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  252 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |   10 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf.c           |   49 -
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   99 +-
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c       |    7 +-
 drivers/staging/rtl8188eu/hal/hal_com.c            |   60 -
 drivers/staging/rtl8188eu/hal/hal_intf.c           |   67 -
 drivers/staging/rtl8188eu/hal/odm.c                |   28 +-
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |  107 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |    8 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  | 1395 +---
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c        |  854 ---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   26 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c    |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c    |   80 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c      |   15 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |    6 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |   33 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |  560 +-
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |  684 --
 drivers/staging/rtl8188eu/include/Hal8188EReg.h    |   46 -
 drivers/staging/rtl8188eu/include/HalPhyRf.h       |   30 -
 drivers/staging/rtl8188eu/include/HalPhyRf_8188e.h |    2 +-
 drivers/staging/rtl8188eu/include/cmd_osdep.h      |   32 -
 drivers/staging/rtl8188eu/include/drv_types.h      |   78 +-
 drivers/staging/rtl8188eu/include/hal_com.h        |    4 -
 drivers/staging/rtl8188eu/include/hal_intf.h       |   46 -
 drivers/staging/rtl8188eu/include/ieee80211.h      |   13 -
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    4 +-
 drivers/staging/rtl8188eu/include/osdep_intf.h     |   38 +-
 drivers/staging/rtl8188eu/include/osdep_service.h  |  178 -
 drivers/staging/rtl8188eu/include/recv_osdep.h     |    3 -
 drivers/staging/rtl8188eu/include/rtl8188e_cmd.h   |    5 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |   14 +-
 .../staging/rtl8188eu/include/rtl8188e_sreset.h    |   31 -
 drivers/staging/rtl8188eu/include/rtl8188e_xmit.h  |    1 -
 drivers/staging/rtl8188eu/include/rtw_br_ext.h     |   66 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |  612 +-
 drivers/staging/rtl8188eu/include/rtw_debug.h      |    2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |   51 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         |  343 -
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h  |    8 -
 drivers/staging/rtl8188eu/include/rtw_iol.h        |    2 -
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |   28 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |   93 +-
 drivers/staging/rtl8188eu/include/rtw_mp.h         |  495 --
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h   |  340 -
 drivers/staging/rtl8188eu/include/rtw_p2p.h        |  135 -
 drivers/staging/rtl8188eu/include/rtw_security.h   |    1 -
 drivers/staging/rtl8188eu/include/rtw_sreset.h     |    5 -
 drivers/staging/rtl8188eu/include/rtw_version.h    |    1 -
 drivers/staging/rtl8188eu/include/sta_info.h       |   15 -
 drivers/staging/rtl8188eu/include/usb_ops.h        |  114 -
 drivers/staging/rtl8188eu/include/usb_ops_linux.h  |   42 +-
 drivers/staging/rtl8188eu/include/usb_osintf.h     |   45 -
 drivers/staging/rtl8188eu/include/usb_vendor_req.h |   52 -
 drivers/staging/rtl8188eu/include/wlan_bssdef.h    |    4 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     | 6617 ++---------------
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c      |   64 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |  111 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |  287 +-
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |   28 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  255 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |  646 +-
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |    5 +-
 drivers/staging/rtl8192e/dot11d.c                  |    8 +-
 drivers/staging/rtl8192e/rtllib_module.c           |    5 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    3 +-
 drivers/staging/rtl8192ee/Kconfig                  |    1 -
 drivers/staging/rtl8192ee/base.c                   |    5 +-
 drivers/staging/rtl8192ee/base.h                   |    4 +-
 .../staging/rtl8192ee/btcoexist/halbtc8821a2ant.c  |    2 +-
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h |    2 +-
 drivers/staging/rtl8192ee/pci.c                    |    2 +-
 drivers/staging/rtl8192ee/rtl8192ee/trx.c          |    4 +-
 drivers/staging/rtl8192ee/rtl8192ee/trx.h          |    2 +-
 drivers/staging/rtl8192ee/wifi.h                   |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   10 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    8 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |   15 +-
 drivers/staging/rtl8192u/r8180_93cx6.h             |   11 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |  169 +-
 drivers/staging/rtl8192u/r8192U_core.c             |  548 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |  159 +-
 drivers/staging/rtl8192u/r819xU_phy.c              |   25 +-
 drivers/staging/rtl8712/drv_types.h                |    3 +-
 drivers/staging/rtl8712/hal_init.c                 |    2 -
 drivers/staging/rtl8712/ieee80211.h                |    4 +-
 drivers/staging/rtl8712/mlme_linux.c               |    3 +
 drivers/staging/rtl8712/os_intfs.c                 |    3 +-
 drivers/staging/rtl8712/osdep_service.h            |   82 +-
 drivers/staging/rtl8712/rtl8712_cmd.c              |    6 +-
 drivers/staging/rtl8712/rtl8712_led.c              |    4 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |   57 +-
 drivers/staging/rtl8712/rtl8712_xmit.c             |   20 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |  114 +-
 drivers/staging/rtl8712/rtl871x_cmd.h              |    2 +-
 drivers/staging/rtl8712/rtl871x_io.c               |   12 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   31 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |    6 +-
 drivers/staging/rtl8712/rtl871x_led.h              |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |   64 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |    8 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |   10 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |    4 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |   18 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |   51 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |   56 +-
 drivers/staging/rtl8712/rtl871x_xmit.h             |    6 +-
 drivers/staging/rtl8712/usb_intf.c                 |   40 +-
 drivers/staging/rtl8723au/Makefile                 |    4 +-
 drivers/staging/rtl8723au/core/rtw_ap.c            |  205 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c           |   42 +-
 drivers/staging/rtl8723au/core/rtw_efuse.c         |   31 +-
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |  348 +-
 drivers/staging/rtl8723au/core/rtw_ioctl_set.c     |  425 --
 drivers/staging/rtl8723au/core/rtw_mlme.c          |  541 +-
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      | 1747 ++---
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |   56 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |    8 +-
 drivers/staging/rtl8723au/core/rtw_sreset.c        |   49 +-
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c       |   63 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     |  418 +-
 drivers/staging/rtl8723au/core/rtw_xmit.c          |   12 +-
 drivers/staging/rtl8723au/hal/HalHWImg8723A_BB.c   |  160 -
 drivers/staging/rtl8723au/hal/HalHWImg8723A_RF.c   |    5 +-
 drivers/staging/rtl8723au/hal/hal_com.c            |   36 +-
 drivers/staging/rtl8723au/hal/odm.c                |  429 +-
 drivers/staging/rtl8723au/hal/odm_HWConfig.c       |   68 +-
 drivers/staging/rtl8723au/hal/odm_RegConfig8723A.c |   58 -
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |    5 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       |   89 +-
 drivers/staging/rtl8723au/hal/rtl8723a_dm.c        |   81 +-
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  |  125 +-
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |   28 +-
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c    |   13 +-
 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c    |   19 -
 drivers/staging/rtl8723au/hal/rtl8723a_xmit.c      |   21 -
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  162 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |  317 +-
 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h |    1 -
 .../staging/rtl8723au/include/HalHWImg8723A_BB.h   |    6 -
 drivers/staging/rtl8723au/include/drv_types.h      |   15 +-
 drivers/staging/rtl8723au/include/hal_com.h        |    3 +-
 drivers/staging/rtl8723au/include/hal_intf.h       |    5 +-
 drivers/staging/rtl8723au/include/ieee80211.h      |  109 +-
 drivers/staging/rtl8723au/include/ioctl_cfg80211.h |    3 -
 drivers/staging/rtl8723au/include/odm.h            |  102 +-
 drivers/staging/rtl8723au/include/odm_HWConfig.h   |   17 -
 .../staging/rtl8723au/include/odm_RegConfig8723A.h |    6 -
 .../staging/rtl8723au/include/odm_RegDefine11AC.h  |   49 -
 drivers/staging/rtl8723au/include/odm_interface.h  |   11 +-
 drivers/staging/rtl8723au/include/odm_precomp.h    |    1 -
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h   |    2 +-
 drivers/staging/rtl8723au/include/rtl8723a_dm.h    |    4 -
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |    5 -
 drivers/staging/rtl8723au/include/rtl8723a_spec.h  |   10 -
 .../staging/rtl8723au/include/rtl8723a_sreset.h    |    1 -
 drivers/staging/rtl8723au/include/rtl8723a_xmit.h  |    1 -
 drivers/staging/rtl8723au/include/rtw_ap.h         |    3 +-
 drivers/staging/rtl8723au/include/rtw_debug.h      |    2 +-
 drivers/staging/rtl8723au/include/rtw_event.h      |    2 +-
 drivers/staging/rtl8723au/include/rtw_ht.h         |    4 +-
 drivers/staging/rtl8723au/include/rtw_ioctl_set.h  |   32 -
 drivers/staging/rtl8723au/include/rtw_mlme.h       |   50 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |   37 +-
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h    |   20 -
 drivers/staging/rtl8723au/include/rtw_rf.h         |   11 -
 drivers/staging/rtl8723au/include/rtw_security.h   |    3 -
 drivers/staging/rtl8723au/include/rtw_sreset.h     |   20 -
 drivers/staging/rtl8723au/include/sta_info.h       |    2 +-
 drivers/staging/rtl8723au/include/usb_ops_linux.h  |   14 +-
 drivers/staging/rtl8723au/include/wifi.h           |   71 -
 drivers/staging/rtl8723au/include/wlan_bssdef.h    |    6 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  | 1105 ++-
 drivers/staging/rtl8723au/os_dep/mlme_linux.c      |    1 -
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |   19 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |   97 +-
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |   10 +-
 drivers/staging/rtl8821ae/Kconfig                  |    1 -
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  |   14 +-
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |    2 +-
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.h |    2 +-
 drivers/staging/rtl8821ae/cam.c                    |    7 -
 drivers/staging/rtl8821ae/pci.c                    |    2 +-
 drivers/staging/rtl8821ae/ps.c                     |    6 +-
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      |   17 +-
 drivers/staging/rtl8821ae/rtl8821ae/hw.c           |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/reg.h          |    1 +
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |    4 +-
 drivers/staging/rtl8821ae/wifi.h                   |    2 +-
 drivers/staging/rts5208/debug.h                    |   43 -
 drivers/staging/rts5208/ms.c                       |  126 +-
 drivers/staging/rts5208/rtsx.c                     |    6 +-
 drivers/staging/rts5208/rtsx.h                     |    1 -
 drivers/staging/rts5208/rtsx_card.c                |   73 +-
 drivers/staging/rts5208/rtsx_card.h                |    1 -
 drivers/staging/rts5208/rtsx_chip.c                |  133 +-
 drivers/staging/rts5208/rtsx_chip.h                |    5 +
 drivers/staging/rts5208/rtsx_scsi.c                |   44 +-
 drivers/staging/rts5208/rtsx_scsi.h                |    2 +-
 drivers/staging/rts5208/rtsx_transport.c           |   55 +-
 drivers/staging/rts5208/sd.c                       |  185 +-
 drivers/staging/rts5208/spi.c                      |    7 +-
 drivers/staging/rts5208/trace.h                    |   10 +-
 drivers/staging/rts5208/xd.c                       |  104 +-
 drivers/staging/sep/Kconfig                        |   11 -
 drivers/staging/sep/Makefile                       |    3 -
 drivers/staging/sep/TODO                           |    3 -
 drivers/staging/sep/sep_crypto.c                   | 3962 ----------
 drivers/staging/sep/sep_crypto.h                   |  359 -
 drivers/staging/sep/sep_dev.h                      |  162 -
 drivers/staging/sep/sep_driver_api.h               |  402 --
 drivers/staging/sep/sep_driver_config.h            |  298 -
 drivers/staging/sep/sep_driver_hw_defs.h           |   56 -
 drivers/staging/sep/sep_main.c                     | 4452 ------------
 drivers/staging/sep/sep_trace_events.h             |  193 -
 drivers/staging/serqt_usb2/Kconfig                 |    9 -
 drivers/staging/serqt_usb2/Makefile                |    1 -
 drivers/staging/serqt_usb2/serqt_usb2.c            | 1528 ----
 drivers/staging/silicom/Kconfig                    |   45 -
 drivers/staging/silicom/Makefile                   |    6 -
 drivers/staging/silicom/README                     |   14 -
 drivers/staging/silicom/TODO                       |    8 -
 drivers/staging/silicom/bits.h                     |   56 -
 drivers/staging/silicom/bp_ioctl.h                 |  140 -
 drivers/staging/silicom/bp_mod.h                   |  711 --
 drivers/staging/silicom/bpctl_mod.c                | 7530 --------------------
 drivers/staging/silicom/bypass.h                   |  202 -
 drivers/staging/silicom/bypasslib/Makefile         |    6 -
 drivers/staging/silicom/bypasslib/bp_ioctl.h       |  198 -
 drivers/staging/silicom/bypasslib/bplibk.h         |   36 -
 drivers/staging/silicom/bypasslib/bypass.c         |  536 --
 drivers/staging/silicom/bypasslib/libbp_sd.h       |  532 --
 drivers/staging/silicom/libbp_sd.h                 |  550 --
 drivers/staging/skein/skein_iv.h                   |   26 +-
 drivers/staging/slicoss/slicoss.c                  |   22 +-
 drivers/staging/speakup/TODO                       |    2 +-
 drivers/staging/speakup/main.c                     |    2 +-
 drivers/staging/speakup/speakup_dectlk.c           |    2 +-
 .../staging/tidspbridge/Documentation/CONTRIBUTORS |   45 -
 drivers/staging/tidspbridge/Documentation/README   |   70 -
 .../staging/tidspbridge/Documentation/error-codes  |  157 -
 drivers/staging/tidspbridge/Kconfig                |   69 -
 drivers/staging/tidspbridge/Makefile               |   32 -
 drivers/staging/tidspbridge/TODO                   |   18 -
 drivers/staging/tidspbridge/core/_cmm.h            |   45 -
 drivers/staging/tidspbridge/core/_deh.h            |   35 -
 drivers/staging/tidspbridge/core/_msg_sm.h         |  142 -
 drivers/staging/tidspbridge/core/_tiomap.h         |  382 -
 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   85 -
 drivers/staging/tidspbridge/core/chnl_sm.c         |  907 ---
 drivers/staging/tidspbridge/core/dsp-clock.c       |  391 -
 drivers/staging/tidspbridge/core/io_sm.c           | 2245 ------
 drivers/staging/tidspbridge/core/msg_sm.c          |  564 --
 drivers/staging/tidspbridge/core/sync.c            |  121 -
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1813 -----
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  556 --
 drivers/staging/tidspbridge/core/tiomap_io.c       |  438 --
 drivers/staging/tidspbridge/core/tiomap_io.h       |  104 -
 drivers/staging/tidspbridge/core/ue_deh.c          |  272 -
 drivers/staging/tidspbridge/core/wdt.c             |  143 -
 drivers/staging/tidspbridge/dynload/cload.c        | 1952 -----
 .../staging/tidspbridge/dynload/dload_internal.h   |  344 -
 drivers/staging/tidspbridge/dynload/doff.h         |  354 -
 drivers/staging/tidspbridge/dynload/getsection.c   |  407 --
 drivers/staging/tidspbridge/dynload/header.h       |   49 -
 drivers/staging/tidspbridge/dynload/module_list.h  |  159 -
 drivers/staging/tidspbridge/dynload/params.h       |  226 -
 drivers/staging/tidspbridge/dynload/reloc.c        |  484 --
 drivers/staging/tidspbridge/dynload/reloc_table.h  |  102 -
 .../tidspbridge/dynload/reloc_table_c6000.c        |  257 -
 drivers/staging/tidspbridge/dynload/tramp.c        | 1143 ---
 .../tidspbridge/dynload/tramp_table_c6000.c        |  164 -
 drivers/staging/tidspbridge/gen/gh.c               |  141 -
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 -
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 -
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 -
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 -
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  487 --
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  160 -
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |  177 -
 .../tidspbridge/include/dspbridge/brddefs.h        |   37 -
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   61 -
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   80 -
 .../tidspbridge/include/dspbridge/chnldefs.h       |   63 -
 .../tidspbridge/include/dspbridge/chnlpriv.h       |   85 -
 .../staging/tidspbridge/include/dspbridge/clk.h    |  101 -
 .../staging/tidspbridge/include/dspbridge/cmm.h    |  337 -
 .../tidspbridge/include/dspbridge/cmmdefs.h        |  104 -
 .../staging/tidspbridge/include/dspbridge/cod.h    |  329 -
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |  358 -
 .../tidspbridge/include/dspbridge/dbdcddef.h       |   78 -
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |  488 --
 .../staging/tidspbridge/include/dspbridge/dbll.h   |   56 -
 .../tidspbridge/include/dspbridge/dblldefs.h       |  431 --
 .../staging/tidspbridge/include/dspbridge/dev.h    |  620 --
 .../tidspbridge/include/dspbridge/devdefs.h        |   26 -
 .../staging/tidspbridge/include/dspbridge/disp.h   |  186 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   71 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |  468 --
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |  467 --
 .../staging/tidspbridge/include/dspbridge/dspapi.h |  167 -
 .../tidspbridge/include/dspbridge/dspchnl.h        |   72 -
 .../tidspbridge/include/dspbridge/dspdefs.h        | 1048 ---
 .../staging/tidspbridge/include/dspbridge/dspdeh.h |   43 -
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |   60 -
 .../staging/tidspbridge/include/dspbridge/dspio.h  |   41 -
 .../tidspbridge/include/dspbridge/dspioctl.h       |   68 -
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |   56 -
 .../tidspbridge/include/dspbridge/dynamic_loader.h |  490 --
 .../tidspbridge/include/dspbridge/getsection.h     |  108 -
 drivers/staging/tidspbridge/include/dspbridge/gh.h |   32 -
 .../tidspbridge/include/dspbridge/host_os.h        |   57 -
 drivers/staging/tidspbridge/include/dspbridge/io.h |   80 -
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |  160 -
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |  144 -
 .../tidspbridge/include/dspbridge/memdefs.h        |   30 -
 .../staging/tidspbridge/include/dspbridge/mgr.h    |  205 -
 .../tidspbridge/include/dspbridge/mgrpriv.h        |   45 -
 .../staging/tidspbridge/include/dspbridge/msg.h    |   59 -
 .../tidspbridge/include/dspbridge/msgdefs.h        |   29 -
 .../staging/tidspbridge/include/dspbridge/nldr.h   |   55 -
 .../tidspbridge/include/dspbridge/nldrdefs.h       |  259 -
 .../staging/tidspbridge/include/dspbridge/node.h   |  524 --
 .../tidspbridge/include/dspbridge/nodedefs.h       |   28 -
 .../tidspbridge/include/dspbridge/nodepriv.h       |  181 -
 .../staging/tidspbridge/include/dspbridge/ntfy.h   |  217 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |  591 --
 .../tidspbridge/include/dspbridge/procpriv.h       |   25 -
 .../staging/tidspbridge/include/dspbridge/pwr.h    |  113 -
 .../include/dspbridge/resourcecleanup.h            |   41 -
 .../staging/tidspbridge/include/dspbridge/rmm.h    |  156 -
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |   86 -
 .../tidspbridge/include/dspbridge/rmstypes.h       |   24 -
 .../staging/tidspbridge/include/dspbridge/strm.h   |  306 -
 .../tidspbridge/include/dspbridge/strmdefs.h       |   44 -
 .../staging/tidspbridge/include/dspbridge/sync.h   |  119 -
 .../tidspbridge/include/dspbridge/uuidutil.h       |   24 -
 .../staging/tidspbridge/include/dspbridge/wdt.h    |   79 -
 drivers/staging/tidspbridge/pmgr/chnl.c            |  115 -
 drivers/staging/tidspbridge/pmgr/chnlobj.h         |   46 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |  915 ---
 drivers/staging/tidspbridge/pmgr/cod.c             |  537 --
 drivers/staging/tidspbridge/pmgr/dbll.c            | 1421 ----
 drivers/staging/tidspbridge/pmgr/dev.c             |  969 ---
 drivers/staging/tidspbridge/pmgr/dmm.c             |  487 --
 drivers/staging/tidspbridge/pmgr/dspapi.c          | 1843 -----
 drivers/staging/tidspbridge/pmgr/io.c              |   93 -
 drivers/staging/tidspbridge/pmgr/ioobj.h           |   38 -
 drivers/staging/tidspbridge/pmgr/msg.c             |   91 -
 drivers/staging/tidspbridge/pmgr/msgobj.h          |   38 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c           | 1483 ----
 drivers/staging/tidspbridge/rmgr/disp.c            |  655 --
 drivers/staging/tidspbridge/rmgr/drv.c             |  816 ---
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |  648 --
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |  139 -
 drivers/staging/tidspbridge/rmgr/mgr.c             |  352 -
 drivers/staging/tidspbridge/rmgr/nldr.c            | 1860 -----
 drivers/staging/tidspbridge/rmgr/node.c            | 3029 --------
 drivers/staging/tidspbridge/rmgr/proc.c            | 1833 -----
 drivers/staging/tidspbridge/rmgr/pwr.c             |  176 -
 drivers/staging/tidspbridge/rmgr/rmm.c             |  456 --
 drivers/staging/tidspbridge/rmgr/strm.c            |  733 --
 .../Documentation/ABI/sysfs-platform-visorchipset  |  101 +
 drivers/staging/unisys/Kconfig                     |    2 +-
 drivers/staging/unisys/channels/Kconfig            |    2 +-
 drivers/staging/unisys/channels/Makefile           |    2 -
 drivers/staging/unisys/channels/channel.c          |    8 +-
 drivers/staging/unisys/channels/chanstub.c         |    4 +-
 drivers/staging/unisys/channels/chanstub.h         |    4 +-
 .../unisys/common-spar/include/channels/channel.h  |  158 +-
 .../include/channels/controlframework.h            |   26 +-
 .../include/channels/controlvmchannel.h            |  250 +-
 .../common-spar/include/channels/diagchannel.h     |   62 +-
 .../common-spar/include/channels/iochannel.h       |  160 +-
 .../common-spar/include/channels/vbuschannel.h     |   50 +-
 .../unisys/common-spar/include/vbusdeviceinfo.h    |   42 +-
 .../unisys/common-spar/include/vmcallinterface.h   |   26 +-
 drivers/staging/unisys/include/commontypes.h       |   85 +-
 drivers/staging/unisys/include/guestlinuxdebug.h   |   20 +-
 drivers/staging/unisys/include/uisqueue.h          |   98 +-
 drivers/staging/unisys/include/uisutils.h          |   94 +-
 drivers/staging/unisys/include/vbushelper.h        |    8 +-
 drivers/staging/unisys/uislib/Makefile             |    3 -
 drivers/staging/unisys/uislib/uislib.c             |   86 +-
 drivers/staging/unisys/uislib/uisqueue.c           |   10 +-
 drivers/staging/unisys/uislib/uisutils.c           |   15 +-
 drivers/staging/unisys/virthba/Makefile            |    3 -
 drivers/staging/unisys/virthba/virthba.c           |  222 +-
 drivers/staging/unisys/virtpci/Makefile            |    3 -
 drivers/staging/unisys/virtpci/virtpci.c           |  353 +-
 drivers/staging/unisys/virtpci/virtpci.h           |    6 +-
 drivers/staging/unisys/visorchannel/Makefile       |    2 -
 drivers/staging/unisys/visorchannel/visorchannel.h |   16 +-
 .../unisys/visorchannel/visorchannel_funcs.c       |   34 +-
 drivers/staging/unisys/visorchipset/Makefile       |    5 +-
 drivers/staging/unisys/visorchipset/controlvm.h    |   27 -
 .../staging/unisys/visorchipset/controlvm_direct.c |   62 -
 drivers/staging/unisys/visorchipset/file.c         |    4 +-
 drivers/staging/unisys/visorchipset/parser.c       |    6 +-
 drivers/staging/unisys/visorchipset/parser.h       |    4 +-
 drivers/staging/unisys/visorchipset/visorchipset.h |   90 +-
 .../unisys/visorchipset/visorchipset_main.c        | 1146 +--
 drivers/staging/unisys/visorutil/Makefile          |    1 -
 .../staging/unisys/visorutil/memregion_direct.c    |    2 +-
 drivers/staging/usbip/stub_main.c                  |   10 +-
 drivers/staging/usbip/stub_rx.c                    |    1 -
 .../usbip/userspace/libsrc/usbip_host_driver.c     |    7 +-
 drivers/staging/usbip/vhci_hcd.c                   |    3 +-
 drivers/staging/usbip/vhci_rx.c                    |    2 -
 drivers/staging/vme/devices/vme_pio2_core.c        |   12 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c        |    6 +-
 drivers/staging/vme/devices/vme_user.c             |    4 -
 drivers/staging/vt6655/80211hdr.h                  |    7 -
 drivers/staging/vt6655/80211mgr.c                  |   37 +-
 drivers/staging/vt6655/80211mgr.h                  |   38 -
 drivers/staging/vt6655/IEEE11h.c                   |  175 -
 drivers/staging/vt6655/IEEE11h.h                   |   10 -
 drivers/staging/vt6655/aes_ccmp.c                  |    1 +
 drivers/staging/vt6655/aes_ccmp.h                  |    9 -
 drivers/staging/vt6655/baseband.c                  |  350 +-
 drivers/staging/vt6655/baseband.h                  |   36 +-
 drivers/staging/vt6655/bssdb.c                     |   72 +-
 drivers/staging/vt6655/bssdb.h                     |   28 +-
 drivers/staging/vt6655/card.c                      |   40 +-
 drivers/staging/vt6655/card.h                      |   18 +-
 drivers/staging/vt6655/channel.h                   |    4 -
 drivers/staging/vt6655/country.h                   |    1 -
 drivers/staging/vt6655/datarate.c                  |   37 +-
 drivers/staging/vt6655/datarate.h                  |   28 +-
 drivers/staging/vt6655/desc.h                      |  185 +-
 drivers/staging/vt6655/device.h                    |   78 +-
 drivers/staging/vt6655/device_cfg.h                |    5 +-
 drivers/staging/vt6655/device_main.c               |  772 +-
 drivers/staging/vt6655/dpc.c                       |   48 +-
 drivers/staging/vt6655/dpc.h                       |   10 -
 drivers/staging/vt6655/hostap.c                    |   48 +-
 drivers/staging/vt6655/hostap.h                    |    8 -
 drivers/staging/vt6655/iocmd.h                     |   25 +-
 drivers/staging/vt6655/ioctl.c                     |    8 +-
 drivers/staging/vt6655/ioctl.h                     |    8 -
 drivers/staging/vt6655/iowpa.h                     |   10 -
 drivers/staging/vt6655/iwctl.c                     |  134 +-
 drivers/staging/vt6655/iwctl.h                     |   18 +-
 drivers/staging/vt6655/key.c                       |   33 +-
 drivers/staging/vt6655/key.h                       |   25 +-
 drivers/staging/vt6655/mac.c                       |  104 +-
 drivers/staging/vt6655/mac.h                       |  107 +-
 drivers/staging/vt6655/mib.h                       |   45 +-
 drivers/staging/vt6655/michael.h                   |    6 -
 drivers/staging/vt6655/power.c                     |    9 +-
 drivers/staging/vt6655/power.h                     |    9 -
 drivers/staging/vt6655/rc4.c                       |    1 +
 drivers/staging/vt6655/rf.c                        |   20 +-
 drivers/staging/vt6655/rf.h                        |    8 +-
 drivers/staging/vt6655/rxtx.c                      |   26 +-
 drivers/staging/vt6655/srom.c                      |   24 +-
 drivers/staging/vt6655/srom.h                      |   24 +-
 drivers/staging/vt6655/tcrc.c                      |    2 +-
 drivers/staging/vt6655/upc.h                       |   52 +-
 drivers/staging/vt6655/vntwifi.c                   |   19 +-
 drivers/staging/vt6655/wcmd.c                      |   39 +-
 drivers/staging/vt6655/wcmd.h                      |   15 +-
 drivers/staging/vt6655/wmgr.c                      |   89 +-
 drivers/staging/vt6655/wmgr.h                      |   12 +-
 drivers/staging/vt6655/wpa.c                       |   10 +-
 drivers/staging/vt6655/wpactl.c                    |    5 +-
 drivers/staging/vt6656/80211hdr.h                  |  324 -
 drivers/staging/vt6656/80211mgr.c                  |  861 ---
 drivers/staging/vt6656/80211mgr.h                  |  808 ---
 drivers/staging/vt6656/Kconfig                     |    4 +-
 drivers/staging/vt6656/Makefile                    |   13 -
 drivers/staging/vt6656/baseband.c                  | 1034 +--
 drivers/staging/vt6656/baseband.h                  |   19 +-
 drivers/staging/vt6656/bssdb.c                     | 1466 ----
 drivers/staging/vt6656/bssdb.h                     |  276 -
 drivers/staging/vt6656/card.c                      |  384 +-
 drivers/staging/vt6656/card.h                      |   48 +-
 drivers/staging/vt6656/channel.c                   |  549 +-
 drivers/staging/vt6656/channel.h                   |    9 +-
 drivers/staging/vt6656/country.h                   |  162 -
 drivers/staging/vt6656/datarate.c                  |  364 -
 drivers/staging/vt6656/datarate.h                  |   76 -
 drivers/staging/vt6656/desc.h                      |    2 -
 drivers/staging/vt6656/device.h                    |  544 +-
 drivers/staging/vt6656/dpc.c                       |  999 +--
 drivers/staging/vt6656/dpc.h                       |   11 +-
 drivers/staging/vt6656/firmware.c                  |   78 +-
 drivers/staging/vt6656/firmware.h                  |    6 +-
 drivers/staging/vt6656/int.c                       |  213 +-
 drivers/staging/vt6656/int.h                       |    4 +-
 drivers/staging/vt6656/iocmd.h                     |   38 -
 drivers/staging/vt6656/iowpa.h                     |   75 -
 drivers/staging/vt6656/iwctl.c                     | 1802 -----
 drivers/staging/vt6656/iwctl.h                     |  138 -
 drivers/staging/vt6656/key.c                       |  789 +-
 drivers/staging/vt6656/key.h                       |   79 +-
 drivers/staging/vt6656/mac.c                       |   37 +-
 drivers/staging/vt6656/mac.h                       |  708 +-
 drivers/staging/vt6656/main_usb.c                  | 1608 ++---
 drivers/staging/vt6656/michael.c                   |  167 -
 drivers/staging/vt6656/michael.h                   |   52 -
 drivers/staging/vt6656/power.c                     |  254 +-
 drivers/staging/vt6656/power.h                     |   17 +-
 drivers/staging/vt6656/rc4.c                       |   87 -
 drivers/staging/vt6656/rc4.h                       |   46 -
 drivers/staging/vt6656/rf.c                        | 1303 ++--
 drivers/staging/vt6656/rf.h                        |   11 +-
 drivers/staging/vt6656/rxtx.c                      | 2408 ++-----
 drivers/staging/vt6656/rxtx.h                      |   36 +-
 drivers/staging/vt6656/tether.c                    |   60 -
 drivers/staging/vt6656/tether.h                    |  101 -
 drivers/staging/vt6656/tkip.c                      |  246 -
 drivers/staging/vt6656/tkip.h                      |   45 -
 drivers/staging/vt6656/tmacro.h                    |   52 -
 drivers/staging/vt6656/usbpipe.c                   |  321 +-
 drivers/staging/vt6656/usbpipe.h                   |    7 +-
 drivers/staging/vt6656/vntconfiguration.dat        |    6 -
 drivers/staging/vt6656/wcmd.c                      | 1066 +--
 drivers/staging/vt6656/wcmd.h                      |   91 +-
 drivers/staging/vt6656/wctl.c                      |  244 -
 drivers/staging/vt6656/wctl.h                      |   94 -
 drivers/staging/vt6656/wmgr.c                      | 4362 ------------
 drivers/staging/vt6656/wmgr.h                      |  397 --
 drivers/staging/vt6656/wpa.c                       |  314 -
 drivers/staging/vt6656/wpa.h                       |   72 -
 drivers/staging/vt6656/wpa2.c                      |  235 -
 drivers/staging/vt6656/wpa2.h                      |   53 -
 drivers/staging/vt6656/wpactl.c                    |  247 -
 drivers/staging/vt6656/wpactl.h                    |   47 -
 drivers/staging/winbond/Kconfig                    |   11 -
 drivers/staging/winbond/Makefile                   |   15 -
 drivers/staging/winbond/TODO                       |   12 -
 drivers/staging/winbond/core.h                     |   61 -
 drivers/staging/winbond/localpara.h                |  311 -
 drivers/staging/winbond/mac_structures.h           |   71 -
 drivers/staging/winbond/mds.c                      |  650 --
 drivers/staging/winbond/mds_f.h                    |   22 -
 drivers/staging/winbond/mds_s.h                    |  130 -
 drivers/staging/winbond/mto.c                      |  167 -
 drivers/staging/winbond/mto.h                      |  134 -
 drivers/staging/winbond/phy_calibration.c          | 1317 ----
 drivers/staging/winbond/phy_calibration.h          |   85 -
 drivers/staging/winbond/reg.c                      | 2328 ------
 drivers/staging/winbond/sme_api.h                  |  191 -
 drivers/staging/winbond/wb35reg.c                  |  806 ---
 drivers/staging/winbond/wb35reg_f.h                |   65 -
 drivers/staging/winbond/wb35reg_s.h                |  240 -
 drivers/staging/winbond/wb35rx.c                   |  358 -
 drivers/staging/winbond/wb35rx_f.h                 |   15 -
 drivers/staging/winbond/wb35rx_s.h                 |   44 -
 drivers/staging/winbond/wb35tx.c                   |  290 -
 drivers/staging/winbond/wb35tx_f.h                 |   22 -
 drivers/staging/winbond/wb35tx_s.h                 |   39 -
 drivers/staging/winbond/wbhal.h                    |  513 --
 drivers/staging/winbond/wbusb.c                    |  853 ---
 drivers/staging/wlags49_h2/Kconfig                 |   11 -
 drivers/staging/wlags49_h2/Makefile                |   53 -
 drivers/staging/wlags49_h2/README.ubuntu           |  180 -
 drivers/staging/wlags49_h2/README.wlags49          |  641 --
 drivers/staging/wlags49_h2/TODO                    |   33 -
 drivers/staging/wlags49_h2/WARNING.txt             |    3 -
 drivers/staging/wlags49_h2/ap_h2.c                 | 3337 ---------
 drivers/staging/wlags49_h2/ap_h25.c                | 4094 -----------
 drivers/staging/wlags49_h2/debug.h                 |  199 -
 drivers/staging/wlags49_h2/dhf.c                   |  380 -
 drivers/staging/wlags49_h2/dhf.h                   |  225 -
 drivers/staging/wlags49_h2/dhfcfg.h                |  158 -
 drivers/staging/wlags49_h2/hcf.c                   | 4748 ------------
 drivers/staging/wlags49_h2/hcf.h                   |  394 -
 drivers/staging/wlags49_h2/hcfcfg.h                |  785 --
 drivers/staging/wlags49_h2/hcfdef.h                |  752 --
 drivers/staging/wlags49_h2/man/wlags49.4           |  734 --
 drivers/staging/wlags49_h2/mdd.h                   | 1155 ---
 drivers/staging/wlags49_h2/mmd.c                   |  250 -
 drivers/staging/wlags49_h2/mmd.h                   |   77 -
 drivers/staging/wlags49_h2/sta_h2.c                | 4480 ------------
 drivers/staging/wlags49_h2/sta_h25.c               | 5255 --------------
 drivers/staging/wlags49_h2/wl_cs.c                 |  440 --
 drivers/staging/wlags49_h2/wl_cs.h                 |   89 -
 drivers/staging/wlags49_h2/wl_enc.c                |  217 -
 drivers/staging/wlags49_h2/wl_enc.h                |  118 -
 drivers/staging/wlags49_h2/wl_if.h                 |  221 -
 drivers/staging/wlags49_h2/wl_internal.h           | 1040 ---
 drivers/staging/wlags49_h2/wl_main.c               | 3702 ----------
 drivers/staging/wlags49_h2/wl_main.h               |  138 -
 drivers/staging/wlags49_h2/wl_netdev.c             | 1951 -----
 drivers/staging/wlags49_h2/wl_netdev.h             |  154 -
 drivers/staging/wlags49_h2/wl_priv.c               | 1928 -----
 drivers/staging/wlags49_h2/wl_priv.h               |  127 -
 drivers/staging/wlags49_h2/wl_profile.c            |  995 ---
 drivers/staging/wlags49_h2/wl_profile.h            |   87 -
 drivers/staging/wlags49_h2/wl_util.c               | 1367 ----
 drivers/staging/wlags49_h2/wl_util.h               |   96 -
 drivers/staging/wlags49_h2/wl_version.h            |  146 -
 drivers/staging/wlags49_h2/wl_wext.c               | 3794 ----------
 drivers/staging/wlags49_h2/wl_wext.h               |   88 -
 drivers/staging/wlags49_h25/Kconfig                |   11 -
 drivers/staging/wlags49_h25/Makefile               |   52 -
 drivers/staging/wlags49_h25/README.txt             |   30 -
 drivers/staging/wlags49_h25/TODO                   |   33 -
 drivers/staging/wlags49_h25/ap_h25.c               |    2 -
 drivers/staging/wlags49_h25/debug.h                |    2 -
 drivers/staging/wlags49_h25/dhf.c                  |    2 -
 drivers/staging/wlags49_h25/dhf.h                  |    2 -
 drivers/staging/wlags49_h25/dhfcfg.h               |    2 -
 drivers/staging/wlags49_h25/hcf.c                  |    2 -
 drivers/staging/wlags49_h25/hcf.h                  |    2 -
 drivers/staging/wlags49_h25/hcfcfg.h               |    2 -
 drivers/staging/wlags49_h25/hcfdef.h               |    2 -
 drivers/staging/wlags49_h25/mdd.h                  |    2 -
 drivers/staging/wlags49_h25/mmd.c                  |    2 -
 drivers/staging/wlags49_h25/mmd.h                  |    2 -
 drivers/staging/wlags49_h25/sta_h25.c              |    2 -
 drivers/staging/wlags49_h25/wl_cs.c                |    2 -
 drivers/staging/wlags49_h25/wl_cs.h                |    2 -
 drivers/staging/wlags49_h25/wl_enc.c               |    2 -
 drivers/staging/wlags49_h25/wl_enc.h               |    2 -
 drivers/staging/wlags49_h25/wl_if.h                |    2 -
 drivers/staging/wlags49_h25/wl_internal.h          |    2 -
 drivers/staging/wlags49_h25/wl_main.c              |    2 -
 drivers/staging/wlags49_h25/wl_main.h              |    2 -
 drivers/staging/wlags49_h25/wl_netdev.c            |    2 -
 drivers/staging/wlags49_h25/wl_netdev.h            |    2 -
 drivers/staging/wlags49_h25/wl_priv.c              |    2 -
 drivers/staging/wlags49_h25/wl_priv.h              |    2 -
 drivers/staging/wlags49_h25/wl_profile.c           |    2 -
 drivers/staging/wlags49_h25/wl_profile.h           |    2 -
 drivers/staging/wlags49_h25/wl_util.c              |    2 -
 drivers/staging/wlags49_h25/wl_util.h              |    2 -
 drivers/staging/wlags49_h25/wl_version.h           |    2 -
 drivers/staging/wlags49_h25/wl_wext.c              |    2 -
 drivers/staging/wlags49_h25/wl_wext.h              |    2 -
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |   19 +-
 drivers/staging/wlan-ng/p80211conv.c               |    1 -
 drivers/staging/wlan-ng/p80211netdev.c             |   40 +-
 drivers/staging/wlan-ng/p80211netdev.h             |    1 -
 drivers/staging/wlan-ng/prism2fw.c                 |    2 +
 drivers/staging/wlan-ng/prism2mgmt.c               |   42 +-
 drivers/staging/wlan-ng/prism2mib.c                |    7 +-
 drivers/staging/wlan-ng/prism2sta.c                |    7 +-
 drivers/staging/xillybus/README                    |   23 -
 drivers/staging/xillybus/xillybus.h                |   48 +-
 drivers/staging/xillybus/xillybus_core.c           |  541 +-
 drivers/staging/xillybus/xillybus_of.c             |   72 +-
 drivers/staging/xillybus/xillybus_pcie.c           |   66 +-
 drivers/usb/storage/Kconfig                        |    2 +-
 drivers/usb/storage/ene_ub6250.c                   |    4 +-
 include/linux/component.h                          |    7 +
 include/linux/device.h                             |    4 +
 include/linux/iio/accel/kxcjk_1013.h               |   22 +
 include/linux/iio/common/st_sensors.h              |   12 +-
 include/linux/iio/common/st_sensors_i2c.h          |   11 +
 include/linux/iio/imu/adis.h                       |   33 +-
 include/linux/iio/trigger.h                        |    5 +-
 include/linux/iio/types.h                          |    5 +
 .../adc => include/linux/platform_data}/ad7291.h   |    0
 include/linux/platform_data/dsp-omap.h             |   34 -
 kernel/time/alarmtimer.c                           |    2 +-
 1480 files changed, 39070 insertions(+), 254659 deletions(-)
 rename {drivers/staging/iio/Documentation => Documentation/ABI/testing}/sysfs-bus-iio-trigger-sysfs (100%)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/st-sensors.txt
 delete mode 100644 arch/arm/mach-omap2/dsp.c
 create mode 100644 drivers/iio/accel/kxcjk-1013.c
 rename drivers/{staging => }/iio/adc/ad7291.c (89%)
 create mode 100644 drivers/iio/adc/max1027.c
 create mode 100644 drivers/iio/dac/mcp4922.c
 create mode 100644 drivers/iio/light/isl29125.c
 create mode 100644 drivers/iio/light/tcs3414.c
 create mode 100644 drivers/iio/magnetometer/ak09911.c
 create mode 100644 drivers/iio/pressure/t5403.c
 create mode 100644 drivers/staging/board/Kconfig
 create mode 100644 drivers/staging/board/Makefile
 create mode 100644 drivers/staging/board/TODO
 create mode 100644 drivers/staging/board/board.c
 create mode 100644 drivers/staging/board/board.h
 create mode 100644 drivers/staging/board/kzm9d.c
 delete mode 100644 drivers/staging/ced1401/Kconfig
 delete mode 100644 drivers/staging/ced1401/Makefile
 delete mode 100644 drivers/staging/ced1401/TODO
 delete mode 100644 drivers/staging/ced1401/ced_ioc.c
 delete mode 100644 drivers/staging/ced1401/ced_ioctl.h
 delete mode 100644 drivers/staging/ced1401/machine.h
 delete mode 100644 drivers/staging/ced1401/usb1401.c
 delete mode 100644 drivers/staging/ced1401/usb1401.h
 delete mode 100644 drivers/staging/ced1401/use1401.h
 delete mode 100644 drivers/staging/ced1401/use14_ioc.h
 delete mode 100644 drivers/staging/ced1401/userspace/use1401.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc236.h
 create mode 100644 drivers/staging/comedi/drivers/amplc_pc236_common.c
 create mode 100644 drivers/staging/comedi/drivers/amplc_pci236.c
 delete mode 100644 drivers/staging/crystalhd/Kconfig
 delete mode 100644 drivers/staging/crystalhd/Makefile
 delete mode 100644 drivers/staging/crystalhd/TODO
 delete mode 100644 drivers/staging/crystalhd/bc_dts_defs.h
 delete mode 100644 drivers/staging/crystalhd/bc_dts_glob_lnx.h
 delete mode 100644 drivers/staging/crystalhd/bcm_70012_regs.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd_cmds.c
 delete mode 100644 drivers/staging/crystalhd/crystalhd_cmds.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd_fw_if.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd_hw.c
 delete mode 100644 drivers/staging/crystalhd/crystalhd_hw.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd_lnx.c
 delete mode 100644 drivers/staging/crystalhd/crystalhd_lnx.h
 delete mode 100644 drivers/staging/crystalhd/crystalhd_misc.c
 delete mode 100644 drivers/staging/crystalhd/crystalhd_misc.h
 delete mode 100644 drivers/staging/cxt1e1/Kconfig
 delete mode 100644 drivers/staging/cxt1e1/Makefile
 delete mode 100644 drivers/staging/cxt1e1/comet.c
 delete mode 100644 drivers/staging/cxt1e1/comet.h
 delete mode 100644 drivers/staging/cxt1e1/comet_tables.c
 delete mode 100644 drivers/staging/cxt1e1/comet_tables.h
 delete mode 100644 drivers/staging/cxt1e1/functions.c
 delete mode 100644 drivers/staging/cxt1e1/hwprobe.c
 delete mode 100644 drivers/staging/cxt1e1/libsbew.h
 delete mode 100644 drivers/staging/cxt1e1/linux.c
 delete mode 100644 drivers/staging/cxt1e1/musycc.c
 delete mode 100644 drivers/staging/cxt1e1/musycc.h
 delete mode 100644 drivers/staging/cxt1e1/pmc93x6_eeprom.c
 delete mode 100644 drivers/staging/cxt1e1/pmc93x6_eeprom.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_cpld.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_defs.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_drv.c
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_ioctls.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_private.h
 delete mode 100644 drivers/staging/cxt1e1/pmcc4_sysdep.h
 delete mode 100644 drivers/staging/cxt1e1/sbe_bid.h
 delete mode 100644 drivers/staging/cxt1e1/sbe_promformat.h
 delete mode 100644 drivers/staging/cxt1e1/sbecom_inline_linux.h
 delete mode 100644 drivers/staging/cxt1e1/sbecrc.c
 delete mode 100644 drivers/staging/cxt1e1/sbeid.c
 delete mode 100644 drivers/staging/cxt1e1/sbeproc.c
 delete mode 100644 drivers/staging/cxt1e1/sbeproc.h
 delete mode 100644 drivers/staging/cxt1e1/sbew_ioc.h
 delete mode 100644 drivers/staging/dgnc/dgnc_trace.c
 delete mode 100644 drivers/staging/dgnc/dgnc_trace.h
 delete mode 100644 drivers/staging/dgrp/Kconfig
 delete mode 100644 drivers/staging/dgrp/Makefile
 delete mode 100644 drivers/staging/dgrp/README
 delete mode 100644 drivers/staging/dgrp/TODO
 delete mode 100644 drivers/staging/dgrp/dgrp_common.c
 delete mode 100644 drivers/staging/dgrp/dgrp_common.h
 delete mode 100644 drivers/staging/dgrp/dgrp_dpa_ops.c
 delete mode 100644 drivers/staging/dgrp/dgrp_driver.c
 delete mode 100644 drivers/staging/dgrp/dgrp_mon_ops.c
 delete mode 100644 drivers/staging/dgrp/dgrp_net_ops.c
 delete mode 100644 drivers/staging/dgrp/dgrp_ports_ops.c
 delete mode 100644 drivers/staging/dgrp/dgrp_specproc.c
 delete mode 100644 drivers/staging/dgrp/dgrp_sysfs.c
 delete mode 100644 drivers/staging/dgrp/dgrp_tty.c
 delete mode 100644 drivers/staging/dgrp/digirp.h
 delete mode 100644 drivers/staging/dgrp/drp.h
 create mode 100644 drivers/staging/emxx_udc/Kconfig
 create mode 100644 drivers/staging/emxx_udc/Makefile
 create mode 100644 drivers/staging/emxx_udc/TODO
 create mode 100644 drivers/staging/emxx_udc/emxx_udc.c
 create mode 100644 drivers/staging/emxx_udc/emxx_udc.h
 delete mode 100644 drivers/staging/frontier/Kconfig
 delete mode 100644 drivers/staging/frontier/Makefile
 delete mode 100644 drivers/staging/frontier/README
 delete mode 100644 drivers/staging/frontier/TODO
 delete mode 100644 drivers/staging/frontier/alphatrack.c
 delete mode 100644 drivers/staging/frontier/alphatrack.h
 delete mode 100644 drivers/staging/frontier/tranzport.c
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
 delete mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
 rename drivers/staging/iio/magnetometer/{hmc5843.c => hmc5843_core.c} (73%)
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c
 delete mode 100644 drivers/staging/keucr/Kconfig
 delete mode 100644 drivers/staging/keucr/Makefile
 delete mode 100644 drivers/staging/keucr/TODO
 delete mode 100644 drivers/staging/keucr/common.h
 delete mode 100644 drivers/staging/keucr/init.c
 delete mode 100644 drivers/staging/keucr/init.h
 delete mode 100644 drivers/staging/keucr/scsiglue.c
 delete mode 100644 drivers/staging/keucr/scsiglue.h
 delete mode 100644 drivers/staging/keucr/smcommon.h
 delete mode 100644 drivers/staging/keucr/smil.h
 delete mode 100644 drivers/staging/keucr/smilecc.c
 delete mode 100644 drivers/staging/keucr/smilmain.c
 delete mode 100644 drivers/staging/keucr/smilsub.c
 delete mode 100644 drivers/staging/keucr/smscsi.c
 delete mode 100644 drivers/staging/keucr/transport.c
 delete mode 100644 drivers/staging/keucr/transport.h
 delete mode 100644 drivers/staging/keucr/usb.c
 delete mode 100644 drivers/staging/keucr/usb.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/bitmap.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-bitops.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/linux/linux-types.h
 delete mode 100644 drivers/staging/lustre/include/linux/libcfs/params_tree.h
 rename drivers/staging/lustre/{include/linux => lustre}/libcfs/linux/linux-crypto.h (72%)
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/Makefile
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_api.h
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_asn1.h
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_err.h
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_internal.h
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_keyring.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5.h
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_krb5_mech.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_rawobj.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
 delete mode 100644 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
 delete mode 100644 drivers/staging/phison/Kconfig
 delete mode 100644 drivers/staging/phison/Makefile
 delete mode 100644 drivers/staging/phison/phison.c
 delete mode 100644 drivers/staging/quickstart/Kconfig
 delete mode 100644 drivers/staging/quickstart/Makefile
 delete mode 100644 drivers/staging/quickstart/quickstart.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_br_ext.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_io.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_mp.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
 delete mode 100644 drivers/staging/rtl8188eu/core/rtw_p2p.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalPhyRf.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/rtl8188e_sreset.c
 delete mode 100644 drivers/staging/rtl8188eu/hal/usb_ops_linux.c
 delete mode 100644 drivers/staging/rtl8188eu/include/Hal8188EReg.h
 delete mode 100644 drivers/staging/rtl8188eu/include/HalPhyRf.h
 delete mode 100644 drivers/staging/rtl8188eu/include/cmd_osdep.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtl8188e_sreset.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_br_ext.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_io.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_mp.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_p2p.h
 delete mode 100644 drivers/staging/rtl8188eu/include/rtw_version.h
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_ops.h
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_osintf.h
 delete mode 100644 drivers/staging/rtl8188eu/include/usb_vendor_req.h
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_ioctl_set.c
 delete mode 100644 drivers/staging/rtl8723au/include/odm_RegDefine11AC.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_ioctl_set.h
 delete mode 100644 drivers/staging/rts5208/debug.h
 delete mode 100644 drivers/staging/sep/Kconfig
 delete mode 100644 drivers/staging/sep/Makefile
 delete mode 100644 drivers/staging/sep/TODO
 delete mode 100644 drivers/staging/sep/sep_crypto.c
 delete mode 100644 drivers/staging/sep/sep_crypto.h
 delete mode 100644 drivers/staging/sep/sep_dev.h
 delete mode 100644 drivers/staging/sep/sep_driver_api.h
 delete mode 100644 drivers/staging/sep/sep_driver_config.h
 delete mode 100644 drivers/staging/sep/sep_driver_hw_defs.h
 delete mode 100644 drivers/staging/sep/sep_main.c
 delete mode 100644 drivers/staging/sep/sep_trace_events.h
 delete mode 100644 drivers/staging/serqt_usb2/Kconfig
 delete mode 100644 drivers/staging/serqt_usb2/Makefile
 delete mode 100644 drivers/staging/serqt_usb2/serqt_usb2.c
 delete mode 100644 drivers/staging/silicom/Kconfig
 delete mode 100644 drivers/staging/silicom/Makefile
 delete mode 100644 drivers/staging/silicom/README
 delete mode 100644 drivers/staging/silicom/TODO
 delete mode 100644 drivers/staging/silicom/bits.h
 delete mode 100644 drivers/staging/silicom/bp_ioctl.h
 delete mode 100644 drivers/staging/silicom/bp_mod.h
 delete mode 100644 drivers/staging/silicom/bpctl_mod.c
 delete mode 100644 drivers/staging/silicom/bypass.h
 delete mode 100644 drivers/staging/silicom/bypasslib/Makefile
 delete mode 100644 drivers/staging/silicom/bypasslib/bp_ioctl.h
 delete mode 100644 drivers/staging/silicom/bypasslib/bplibk.h
 delete mode 100644 drivers/staging/silicom/bypasslib/bypass.c
 delete mode 100644 drivers/staging/silicom/bypasslib/libbp_sd.h
 delete mode 100644 drivers/staging/silicom/libbp_sd.h
 delete mode 100644 drivers/staging/tidspbridge/Documentation/CONTRIBUTORS
 delete mode 100644 drivers/staging/tidspbridge/Documentation/README
 delete mode 100644 drivers/staging/tidspbridge/Documentation/error-codes
 delete mode 100644 drivers/staging/tidspbridge/Kconfig
 delete mode 100644 drivers/staging/tidspbridge/Makefile
 delete mode 100644 drivers/staging/tidspbridge/TODO
 delete mode 100644 drivers/staging/tidspbridge/core/_cmm.h
 delete mode 100644 drivers/staging/tidspbridge/core/_deh.h
 delete mode 100644 drivers/staging/tidspbridge/core/_msg_sm.h
 delete mode 100644 drivers/staging/tidspbridge/core/_tiomap.h
 delete mode 100644 drivers/staging/tidspbridge/core/_tiomap_pwr.h
 delete mode 100644 drivers/staging/tidspbridge/core/chnl_sm.c
 delete mode 100644 drivers/staging/tidspbridge/core/dsp-clock.c
 delete mode 100644 drivers/staging/tidspbridge/core/io_sm.c
 delete mode 100644 drivers/staging/tidspbridge/core/msg_sm.c
 delete mode 100644 drivers/staging/tidspbridge/core/sync.c
 delete mode 100644 drivers/staging/tidspbridge/core/tiomap3430.c
 delete mode 100644 drivers/staging/tidspbridge/core/tiomap3430_pwr.c
 delete mode 100644 drivers/staging/tidspbridge/core/tiomap_io.c
 delete mode 100644 drivers/staging/tidspbridge/core/tiomap_io.h
 delete mode 100644 drivers/staging/tidspbridge/core/ue_deh.c
 delete mode 100644 drivers/staging/tidspbridge/core/wdt.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/cload.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/dload_internal.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/doff.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/getsection.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/header.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/module_list.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/params.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/reloc.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/reloc_table.h
 delete mode 100644 drivers/staging/tidspbridge/dynload/reloc_table_c6000.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/tramp.c
 delete mode 100644 drivers/staging/tidspbridge/dynload/tramp_table_c6000.c
 delete mode 100644 drivers/staging/tidspbridge/gen/gh.c
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/_chnl_sm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/brddefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnl.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnldefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/chnlpriv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/clk.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cmmdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cod.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdcddef.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbll.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dev.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/devdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/disp.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/drv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspapi.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdeh.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspio.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dynamic_loader.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/getsection.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/gh.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/host_os.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/io.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/io_sm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/memdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgr.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/mgrpriv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/msg.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/msgdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldr.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/node.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodedefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/ntfy.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/proc.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/procpriv.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/resourcecleanup.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/rms_sh.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/rmstypes.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/strm.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/strmdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/sync.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/wdt.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/chnl.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/chnlobj.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/cmm.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/cod.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dbll.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dev.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dspapi.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/io.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/ioobj.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/msg.c
 delete mode 100644 drivers/staging/tidspbridge/pmgr/msgobj.h
 delete mode 100644 drivers/staging/tidspbridge/rmgr/dbdcd.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/disp.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/drv_interface.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/dspdrv.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/mgr.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/nldr.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/node.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/proc.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/pwr.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/rmm.c
 delete mode 100644 drivers/staging/tidspbridge/rmgr/strm.c
 create mode 100644 drivers/staging/unisys/Documentation/ABI/sysfs-platform-visorchipset
 delete mode 100644 drivers/staging/unisys/visorchipset/controlvm.h
 delete mode 100644 drivers/staging/unisys/visorchipset/controlvm_direct.c
 delete mode 100644 drivers/staging/vt6656/80211hdr.h
 delete mode 100644 drivers/staging/vt6656/80211mgr.c
 delete mode 100644 drivers/staging/vt6656/80211mgr.h
 delete mode 100644 drivers/staging/vt6656/bssdb.c
 delete mode 100644 drivers/staging/vt6656/bssdb.h
 delete mode 100644 drivers/staging/vt6656/country.h
 delete mode 100644 drivers/staging/vt6656/datarate.c
 delete mode 100644 drivers/staging/vt6656/datarate.h
 delete mode 100644 drivers/staging/vt6656/iocmd.h
 delete mode 100644 drivers/staging/vt6656/iowpa.h
 delete mode 100644 drivers/staging/vt6656/iwctl.c
 delete mode 100644 drivers/staging/vt6656/iwctl.h
 delete mode 100644 drivers/staging/vt6656/michael.c
 delete mode 100644 drivers/staging/vt6656/michael.h
 delete mode 100644 drivers/staging/vt6656/rc4.c
 delete mode 100644 drivers/staging/vt6656/rc4.h
 delete mode 100644 drivers/staging/vt6656/tether.c
 delete mode 100644 drivers/staging/vt6656/tether.h
 delete mode 100644 drivers/staging/vt6656/tkip.c
 delete mode 100644 drivers/staging/vt6656/tkip.h
 delete mode 100644 drivers/staging/vt6656/tmacro.h
 delete mode 100644 drivers/staging/vt6656/vntconfiguration.dat
 delete mode 100644 drivers/staging/vt6656/wctl.c
 delete mode 100644 drivers/staging/vt6656/wctl.h
 delete mode 100644 drivers/staging/vt6656/wmgr.c
 delete mode 100644 drivers/staging/vt6656/wmgr.h
 delete mode 100644 drivers/staging/vt6656/wpa.c
 delete mode 100644 drivers/staging/vt6656/wpa.h
 delete mode 100644 drivers/staging/vt6656/wpa2.c
 delete mode 100644 drivers/staging/vt6656/wpa2.h
 delete mode 100644 drivers/staging/vt6656/wpactl.c
 delete mode 100644 drivers/staging/vt6656/wpactl.h
 delete mode 100644 drivers/staging/winbond/Kconfig
 delete mode 100644 drivers/staging/winbond/Makefile
 delete mode 100644 drivers/staging/winbond/TODO
 delete mode 100644 drivers/staging/winbond/core.h
 delete mode 100644 drivers/staging/winbond/localpara.h
 delete mode 100644 drivers/staging/winbond/mac_structures.h
 delete mode 100644 drivers/staging/winbond/mds.c
 delete mode 100644 drivers/staging/winbond/mds_f.h
 delete mode 100644 drivers/staging/winbond/mds_s.h
 delete mode 100644 drivers/staging/winbond/mto.c
 delete mode 100644 drivers/staging/winbond/mto.h
 delete mode 100644 drivers/staging/winbond/phy_calibration.c
 delete mode 100644 drivers/staging/winbond/phy_calibration.h
 delete mode 100644 drivers/staging/winbond/reg.c
 delete mode 100644 drivers/staging/winbond/sme_api.h
 delete mode 100644 drivers/staging/winbond/wb35reg.c
 delete mode 100644 drivers/staging/winbond/wb35reg_f.h
 delete mode 100644 drivers/staging/winbond/wb35reg_s.h
 delete mode 100644 drivers/staging/winbond/wb35rx.c
 delete mode 100644 drivers/staging/winbond/wb35rx_f.h
 delete mode 100644 drivers/staging/winbond/wb35rx_s.h
 delete mode 100644 drivers/staging/winbond/wb35tx.c
 delete mode 100644 drivers/staging/winbond/wb35tx_f.h
 delete mode 100644 drivers/staging/winbond/wb35tx_s.h
 delete mode 100644 drivers/staging/winbond/wbhal.h
 delete mode 100644 drivers/staging/winbond/wbusb.c
 delete mode 100644 drivers/staging/wlags49_h2/Kconfig
 delete mode 100644 drivers/staging/wlags49_h2/Makefile
 delete mode 100644 drivers/staging/wlags49_h2/README.ubuntu
 delete mode 100644 drivers/staging/wlags49_h2/README.wlags49
 delete mode 100644 drivers/staging/wlags49_h2/TODO
 delete mode 100644 drivers/staging/wlags49_h2/WARNING.txt
 delete mode 100644 drivers/staging/wlags49_h2/ap_h2.c
 delete mode 100644 drivers/staging/wlags49_h2/ap_h25.c
 delete mode 100644 drivers/staging/wlags49_h2/debug.h
 delete mode 100644 drivers/staging/wlags49_h2/dhf.c
 delete mode 100644 drivers/staging/wlags49_h2/dhf.h
 delete mode 100644 drivers/staging/wlags49_h2/dhfcfg.h
 delete mode 100644 drivers/staging/wlags49_h2/hcf.c
 delete mode 100644 drivers/staging/wlags49_h2/hcf.h
 delete mode 100644 drivers/staging/wlags49_h2/hcfcfg.h
 delete mode 100644 drivers/staging/wlags49_h2/hcfdef.h
 delete mode 100644 drivers/staging/wlags49_h2/man/wlags49.4
 delete mode 100644 drivers/staging/wlags49_h2/mdd.h
 delete mode 100644 drivers/staging/wlags49_h2/mmd.c
 delete mode 100644 drivers/staging/wlags49_h2/mmd.h
 delete mode 100644 drivers/staging/wlags49_h2/sta_h2.c
 delete mode 100644 drivers/staging/wlags49_h2/sta_h25.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_cs.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_cs.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_enc.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_enc.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_if.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_internal.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_main.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_main.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_netdev.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_netdev.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_priv.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_priv.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_profile.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_profile.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_util.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_util.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_version.h
 delete mode 100644 drivers/staging/wlags49_h2/wl_wext.c
 delete mode 100644 drivers/staging/wlags49_h2/wl_wext.h
 delete mode 100644 drivers/staging/wlags49_h25/Kconfig
 delete mode 100644 drivers/staging/wlags49_h25/Makefile
 delete mode 100644 drivers/staging/wlags49_h25/README.txt
 delete mode 100644 drivers/staging/wlags49_h25/TODO
 delete mode 100644 drivers/staging/wlags49_h25/ap_h25.c
 delete mode 100644 drivers/staging/wlags49_h25/debug.h
 delete mode 100644 drivers/staging/wlags49_h25/dhf.c
 delete mode 100644 drivers/staging/wlags49_h25/dhf.h
 delete mode 100644 drivers/staging/wlags49_h25/dhfcfg.h
 delete mode 100644 drivers/staging/wlags49_h25/hcf.c
 delete mode 100644 drivers/staging/wlags49_h25/hcf.h
 delete mode 100644 drivers/staging/wlags49_h25/hcfcfg.h
 delete mode 100644 drivers/staging/wlags49_h25/hcfdef.h
 delete mode 100644 drivers/staging/wlags49_h25/mdd.h
 delete mode 100644 drivers/staging/wlags49_h25/mmd.c
 delete mode 100644 drivers/staging/wlags49_h25/mmd.h
 delete mode 100644 drivers/staging/wlags49_h25/sta_h25.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_cs.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_cs.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_enc.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_enc.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_if.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_internal.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_main.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_main.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_netdev.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_netdev.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_priv.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_priv.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_profile.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_profile.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_util.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_util.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_version.h
 delete mode 100644 drivers/staging/wlags49_h25/wl_wext.c
 delete mode 100644 drivers/staging/wlags49_h25/wl_wext.h
 create mode 100644 include/linux/iio/accel/kxcjk_1013.h
 rename {drivers/staging/iio/adc => include/linux/platform_data}/ad7291.h (100%)
 delete mode 100644 include/linux/platform_data/dsp-omap.h
