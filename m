Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaFCFqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 01:46:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46020 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCFqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:46:36 -0400
Date: Mon, 2 Jun 2014 22:46:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.16-rc1
Message-ID: <20140603054632.GA14798@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.16-rc1

for you to fetch changes up to 7eb843aa5050a395bc922db1b41b7237f238d2ba:

  staging: skein: fix sparse warning for static declarations (2014-06-01 16:58:59 -0700)

----------------------------------------------------------------
Staging driver patches for 3.16-rc1

Here is the big staging driver pull request for 3.16-rc1.

Lots of stuff here, tons of cleanup patches, a few new drivers, and some
removed as well, but I think we are still adding a few thousand more
lines than we remove, due to the new drivers being bigger than the ones
deleted.

One notible bit of work did stand out, Jes Sorensen has gone on a tear,
fixing up a wireless driver to be "more sane" than it originally was
from the vendor, with over 500 patches merged here.  Good stuff, and a
number of users laptops are better off for it.

All of this has been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (2):
      staging: octeon-usb: delete redudant prefetches
      staging: octeon-usb: use generic prefetch

Alan (6):
      goldfish: Add a 64bit write helper
      goldfish: Allow 64bit builds
      goldfish: clean up staging ifdefs
      goldfish: clean up tty 64bit support
      goldfish: clean up the checkpatch warnings
      goldfish: clean up the pipe driver 64bit ifdefs

Alan Cox (2):
      goldfish bus: don't call request_mem_region
      goldfish: fix >> 32 warning

Alexandr Terekhov (1):
      staging: lustre: fix integer as NULL pointer warnings

Anders Darander (3):
      staging/rtl8821ae: fix sparse address space warning
      Staging: ft1000-usb: wrap macros in do while
      Staging: ft1000-usb: use netdev_warn

Andreas Dilger (4):
      staging/lustre/ptlrpc: don't try to recover no_recov connection
      staging/lustre: quiet console permission error messages
      staging/lustre: shrink lu_object_header by 8 bytes on x86_64
      staging/lustre: pass fsync() range through RPC/IO stack

Andreas Platschek (1):
      staging: lustre: check length of char array

Andriy Skulysh (1):
      staging/lustre/ptlrpc: add rpc_cache

Angelo Compagnucci (1):
      Add support for Microchip Technology's MCP3426/7/8 ADC

Angus Gibson (1):
      staging: ft1000: remove explicit static initialisation

Anil Belur (1):
      staging: ozwpan: ozproto.c fix for "WARNING: Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)"

Ann Koehler (1):
      staging/lustre: restore __GFP_WAIT flag to memalloc calls

Antoine Schweitzer-Chaput (1):
      Staging: imx-drm: Fix some lines over 80 characters

Antoine Sirinelli (1):
      staging: dgnc: cleanup dgnc_finalize_board_init()

Anton Saraev (5):
      staging: crypto: skein: rename camelcase functions
      staging: crypto: skein: rename camelcase vars
      staging: crypto: skein: rename skein1024_ctx to skein_1024_ctx
      staging: crypto: skein: rename enums
      staging: crypto: skein: rename macros

Archana Patni (1):
      iio: hid-sensors: Set default unit of measure for report interval

Arnd Bergmann (2):
      iio: always select ANON_INODES
      iio:adc: at91 requires the input subsystem

Artem Fetishev (5):
      drivers: staging: ft1000: Fix indentation
      drivers: staging: ft1000: Fix IOCTL_FT1000_* marcos
      drivers: staging: ft1000: Use pr_info instead of printk
      drivers: staging: ft1000: Remove typedefs
      drivers: staging: ft1000: Fix lines over 80 characters

Bastien Armand (4):
      staging: panel: fix sparse warnings in lcd_write
      staging: panel: fix sparse warnings in keypad_read
      staging: panel: add blank lines after declarations
      staging: panel: fix regression in lcd_write

Ben Hutchings (1):
      Staging: rtl8192e: Remove built-in firmware images

Benjamin Romer (9):
      staging: unisys: fix copyright notices
      staging: unisys: Replace GUID with uuid_le
      staging: unisys: remove testing proc interfaces from uislib
      staging: unisys: move uislib/platform proc entry to debugfs
      staging: unisys: move uislib/cycles_before_wait proc entry to debugfs
      staging: unisys: move uislib/smart_wakeup proc entry to debugfs
      staging: unisys: remove functions made redundant in uislib.c
      staging: unisys: move uislib/info proc entry to debugfs
      staging: unisys: remove remaining proc directory entries

Benoit Taine (3):
      staging: rtl8723au: Use kmemdup() instead of memcpy() to duplicate memory
      staging/rtl8192u: Put EXPORT_SYMBOL just after the exported function
      staging: rts5208: Use pci_device_id rather than DEFINE_PCI_DEVICE_TABLE

Bintian Wang (1):
      staging/android: Remove ram_console.h

Bob Glossman (1):
      staging/lustre/lloop: avoid panic during blockdev_info

Bobi Jam (3):
      staging/lustre/llite: issue OST_SYNC for fsync()
      staging/lustre/llite: deadlock taking lli_trunc_sem during file write
      staging/lustre/llite: prevent buffer overflow in fiemap

Bojan Prtvar (2):
      staging: vme: Fix a small coding style issue in vme_user.c
      staging: vme: Simplfy string usage in vme_user_probe()

Brian Behlendorf (1):
      staging/lustre: Limit reply buffer size

Brilliantov Kirill Vladimirovich (1):
      staging/lustre: fix sparse warning: Using plain integer as NULL pointer

Camille Bordignon (1):
      staging: sep: Fix coding style

Chaitanya Hazarey (7):
      Staging: xgifb: Fixed a code-style warning
      Staging: rtl8192u: r819xU_firmware_img.c Fixed checkpatch.pl ERRORs
      Staging: Silicom: bpctl_mod.c & bypass.c: Adding blank lines
      Staging: rtl8192u: r8180_93cx6.c Added missing spaces
      Staging: rtl8192u: r8192U_wx.c Added missing spaces
      Staging: rtl8192u: r8192U_wx.c Added {} braces and newlines
      Staging: rtl8192u: r8192U_wx.c Fixed a misplaced brace

Chase Southwood (20):
      staging: comedi: s626: use comedi_timeout() on remaining loops
      staging: comedi: addi_apci_1564: remove use of devpriv->iobase
      staging: comedi: addi_apci_1564: tidy up apci1564_reset()
      staging: comedi: addi_apci_1564: separate from addi_common.c
      staging: comedi: addi_apci_1564: board does not have analog inputs
      staging: comedi: addi_apci_1564: board does not have analog outputs
      staging: comedi: addi_apci_1564: remove eeprom support code
      staging: comedi: addi_apci_1564: remove unnecessary include
      staging: comedi: addi_apci_1564: board has 32 digital inputs
      staging: comedi: addi_apci_1564: simplify the PCI bar reading and don't read the unused bars
      staging: comedi: addi_apci_1564: remove unnecessary info from boardinfo
      staging: comedi: addi_apci_1564: remove use of devpriv->s_EeParameters
      staging: comedi: addi_apci_1564: board has 32 digital outputs
      staging: comedi: addi_apci_1564: don't allocate unused subdevices
      staging: comedi: addi_apci_1564: absorb apci1564_reset()
      staging: comedi: addi_apci_1564: call apci1564_interrupt() directly
      staging: comedi: addi_apci_1564: remove check for timer subdevice
      staging: comedi: addi_apci_1564: remove boardinfo
      staging: comedi: addi_apci_1564: move apci1564_di_insn_bits() to addi_apci_1564.c
      staging: comedi: addi_apci_1564: move apci1564_do_insn_bits() to addi_apci_1564.c

Cheng Shao (1):
      staging/lustre/ptlrpc: Remove log message about export timer update

Christian Engelmayer (19):
      staging: comedi: remove duplicate pointer assignments in attach functions
      staging: rtl8723au: fix potential leak in update_bcn_wps_ie()
      staging: rtl8723au: Remove unused pointer in rtw_wdev_free()
      staging: vt6656: fix potential leak in vt6656_hostap_ioctl()
      staging: silicom: Remove needless calls of get_status_port_fn()
      staging: silicom: Remove unused pointer in bypass_init_module()
      staging: binder: fix usage of uninit scalar in binder_transaction()
      staging: comedi: ii_pci20kc: fix usage of uninit scalar in ii20k_attach()
      staging: rtl8188eu: fix potential leak in rtw_wx_read32()
      staging: rtl8188eu: fix potential leak in rtw_wx_set_enc_ext()
      staging: rtl8188eu: fix potential leak in rtw_mp_QueryDrv()
      staging: rtl8188eu: fix potential leak in rtw_mp_SetRFPath()
      staging: rtl8188eu: fix potential leak in rtw_mp_pwrtrk()
      staging: rtl8188eu: fix potential leak in update_bcn_wps_ie()
      staging: rtl8188eu: fix potential leak in rtw_set_key()
      staging: rtl8188eu: fix usage of uninit scalar in rtw_drv_init()
      staging: rtl8188eu: remove dead code in rtw_drv_init()
      staging: rtl8712: fix potential leak in r871x_wx_set_enc_ext()
      staging: rtl8712: fix potential leaks in r8712_set_key()

Christoph Jaeger (1):
      staging: lustre: use __func__ instead of __FUNCTION__

Christopher J. Morrone (2):
      staging/lustre/llite: Avoid statahead thread start/stop deadlocks
      stagaing/lustre: Improve statahead debug messages

Cédric Cabessa (1):
      staging: vt6655,vt6656: fix sparse error "unexpected unlock"

Daeseok Youn (14):
      staging: lustre: use NULL instead of 0 for pointer
      staging: cxt1e1: replace OS_kmalloc/OS_kfree with kzalloc/kfree
      staging: silicom: remove redundant pci_get_drvdata() call
      staging: cxt1e1: Fix no spaces at the start of a line in musycc.c
      staging: cxt1e1: remove dead code in musycc.c
      staging: cxt1e1: remove redundant curly braces in musycc.c
      staging: cxt1e1: Fix line length over 80 characters in musycc.c
      staging: cxt1e1: remove set a value to static variable
      staging: bcm: use kzalloc instead of kmalloc/memset
      staging: ozwpan: remove redundant NULL check for devs
      staging: dgap: implement error handling in dgap_tty_register()
      staging: dgap: remove unneeded kfree() for ttys in tty_driver
      staging: dgap: remove unneeded kfree() in dgap_tty_register_ports()
      staging: dgap: move tty_port_init() for serial_ports.

Dan Carpenter (13):
      staging: comedi: remove an unneeded variable
      staging: lustre: improve length checks in ioctls
      Staging: rtl8188eu: overflow in update_sta_support_rate()
      staging: iio: ad799x: remove some unneeded IS_ERR() checks
      staging: lustre: integer overflow in obd_ioctl_is_invalid()
      staging: r8188eu: cleanup by using "len" consistently
      staging: r8188eu: indent for loop body
      staging: frontier: fix some indenting
      staging: rtl8192u: cleanup a switch statement
      iio: hid-sensors: typo leads to potential forever loop
      staging: rtl8723au: fix some confusing indenting
      staging: dgnc: UART_IIR_XOFF code is buggy
      staging: lustre: info leak in lnet_ping()

Daniele Forsi (1):
      staging: et131x: Remove empty file Module.symvers

David Matlack (12):
      staging: slicoss: fix use-after-free in slic_entry_probe
      staging: slicoss: fix multiple free-after-free in slic_entry_remove
      staging: slicoss: remove unused members of struct adapter
      staging: slicoss: remove gratuitous debug infrastructure
      staging: slicoss: fix dma memory leak
      staging: slicoss: fix 64-bit isr address bug
      staging: slicoss: fix use-after-free bug in slic_entry_remove
      staging: slicoss: fix eeprom checksum code
      staging: slicoss: fail on corrupt eeprom
      staging: slicoss: handle errors from slic_config_get
      staging: slicoss: remove private netdev list
      staging: slicoss: clean up use of dev_err

Davide Gianforte (1):
      staging: gdm72xx: code cleanup

Denis Carikli (1):
      imx-drm: match ipu_di_signal_cfg's clk_pol with its description.

Denis Pithon (12):
      staging/lustre: fix sparse warning
      staging/wlan-ng: improve readability of usb_prism_tbl[]
      staging/wlan-ng: remove obsolete comments
      staging/wlan-ng: fix small coding style issues
      staging/wlan-ng: update function header comment
      staging/wlan-ng: remove function declaration
      staging/wlan-ng: code refactoring
      staging/wlan-ng: add prefix to function name
      staging/wlan-ng: compare using ether_addr_equal_unaligned
      staging/wlan-ng: multicast address checking
      staging/wlan-ng: rearrange comments
      staging/wlan-ng: log with netdev_xxx and dev_xxx

Djordje Zekovic (1):
      staging: usbip: use kcalloc instead of kzalloc for array allocations

Dmitry Eremin (8):
      staging/lustre/gss: fix few issues found by Klocwork Insight tool
      staging/lustre/ldlm: fix NULL pointer dereference
      staging/lustre/mdc: fix issue found by Klocwork Insight tool
      staging/lustre/libcfs: fix issues found by Klocwork Insight tool
      staging/lustre: replace semaphores with mutexes
      staging/lustre/clio: replace semaphore with mutex
      staging/lustre/lnet: remove unused variable in lnet_destroy_remote_nets_table
      staging/lustre/lnet: fix potential null pointer dereference in kiblnd_rejected

Dominique van den Broeck (9):
      fwserial: (coding style) open parenthesis alignments
      fwserial: (coding style) if/else bracket matching
      fwserial: (coding style) useless "extern" & space
      fwserial: (coding style) removing FSF postal address
      staging/rtl8192e: Erroneous return codes (types and values)
      staging/rtl8192e: userspace ptr deref + incorrect declarations
      staging: panel: (coding style) Matching braces
      staging: panel: (coding style) Line alignments and malloc sizeof
      staging: panel: (coding style) Multiple assignments

Eli Billauer (2):
      staging: xillybus: Use devm_ API on probe and remove
      devres: Add devm_get_free_pages API

Emil Renner Berthing (2):
      staging: imx-drm: add LVDS666 support for parallel display
      staging: imx-drm: imx-hdmi: clean up hdmi_phy_wait_i2c_done

Fabian Mewes (1):
      staging: line6: Add blank lines after declarations

Fabio Estevam (2):
      imx-hdmi: Propagate the real error code on platform_get_irq() failure
      imx-hdmi: Make checkpatch happy

Fabio Falzoi (9):
      Staging: lustre: Avoid using 0 instead of NULL
      Staging: lustre: ops structs should be declared static
      Staging: lustre: gfp_mask should be of gfp_t type
      Staging: rts5139: Camel case labels replaced
      Staging: rts5139: Fixed multi-line code alignment
      Staging: rts5139: Splitted one-line multiple assignment
      Staging: rts5139: Use standard pr_<level> prefixing
      Staging: rts5139: Removed OOM messages
      Staging: rts5139: More appropriate use of sizeof operand

Fernando Apesteguia (1):
      staging: silicom: add blank line after declarations

Fredrick John Berchmans (2):
      staging: lustre use kernel socket sockopt apis
      staging: lustre: fix unused variable warnings

Garret Kelly (1):
      staging: goldfish: Fix missing blank lines

Gary Rookard (1):
      Staging: bcm: CmHost: remove temp bracing from switch/cases.

Geert Uytterhoeven (4):
      staging/lustre/libcfs: Fix build errors for !CONFIG_SMP
      staging: lustre: Use %zd to format ssize_t
      staging/lustre/llite: Fix unused variable warning if !CONFIG_FS_POSIX_ACL
      staging: rts5139: Make variables inside #ifdef CONFIG_PM

Gengis Dave (1):
      staging: gdm72xx: return values cleanup

Georg Gast (1):
      staging: comedi: more descriptive names for addi-data drivers

Gioh Kim (1):
      Staging: android: ion: duplicated clearing of sg_table

Greg DeAngelis (2):
      staging: bcm: fix lines over 80 characters
      staging: lustre: Fixed warnings about using 0 as NULL ptr

Greg Kroah-Hartman (12):
      Merge 3.15-rc2 into staging-next
      staging: remove sbe-2t3e3 driver.
      Merge tag 'iio-for-3.16a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.15-rc3 into staging-next
      Merge tag 'iio-for-3.16b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge branch 'imx-drm-fixes' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-next
      Merge 3.15-rc6 into staging-next.
      staging: remove rts5139 driver code
      Revert "staging: r8188eu: Add support for Dlink DWA-121 802.11n Wireless N 150 Pico Adapter"
      Merge tag 'iio-for-3.16c' of git://git.kernel.org/.../jic23/iio into staging-next
      Revert "staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP"
      Revert "staging: dgap: remove unneeded kfree() in dgap_tty_register_ports()"

Guido Martínez (4):
      staging: vt6655: fix DBG_PRT and PRINT_K macros
      staging: vt6655: remove mention of nonexistent function CARDbSetBasicRate
      staging: vt6655: remove dead code
      staging: vt6655: fix checkpatch bracing issues

Gulsah Kose (1):
      staging: sbe-2t3e3: Fix line over 80 characters in cpld.c

H Hartley Sweeten (190):
      staging: comedi: adl_pci9111: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: amplc_pci224: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: amplc_pci230: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: cb_pcidas: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: cb_pcidas64: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: das16: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: das16m1: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: das1800: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: das800: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: dmm32at: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: gsc_hpdi: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: ni_at_a2150: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: ni_mio_common: factor out chanlist checking from (*do_cmdtest)
      staging: comedi: me4000: tidy up the chanlist checking
      staging: comedi: ni_labpc: tidy up the chanlist checking
      staging: comedi: drivers: core validates chanlist_len max
      staging: comedi: drivers: properly validate cmd->scan_end_arg
      staging: comedi: addi_apci_3xxx: fix ai subdevice 'len_chanlist'
      staging: comedi: adl_pci9111: rename local var in pci9111_ai_do_cmd_test()
      staging: comedi: comedi_test: ao subdevice does not support async commands
      staging: comedi: hwdrv_apci3200: properly validata the ai cmd->start_arg
      staging: comedi: adl_pci9118: fix the ai cmd->start_arg validation and use
      staging: comedi: amplc_dio200_common: fix the cmd->start_arg use
      staging: comedi: amplc_pci224: fix the ao cmd->start_arg use
      staging: comedi: amplc_pci230: fix the ai/ao cmd->start_arg use for TRIG_INT
      staging: comedi: cb_pcidas: clarify the ai cmd->start_arg validation
      staging: comedi: cb_pcidas: fix the ao cmd->start_arg use for TRIG_INT
      staging: comedi: cb_pcidas64: validate the ai/ao cmd->start_arg
      staging: comedi: dt282x: fix the ao cmd->start_arg use for TRIG_INT
      staging: comedi: gsc_hpdi: validate the cmd->start_arg
      staging: comedi: me4000: validate the cmd->start_arg
      staging: comedi: ni_pcidio: fix the cmd->start_arg use for TRIG_INT
      staging: comedi: ni_tiocmd: clarify the cmd->start_arg validation and use
      staging: comedi: ni_labpc: clarify the cmd->start_arg validation
      staging: comedi: pcmmio: fix the cmd->start_arg use for TRIG_INT
      staging: comedi: pcmuio: fix the cmd->start_arg use for TRIG_INT
      staging: comedi: s626: clarify the cmd->start_arg validation and use
      staging: comedi: usbduxsigma: fix the ai/ao cmd->start_arg use for TRIG_INT
      staging: comedi: usbduxfast: fix the cmd->start_arg validation and use
      staging: comedi: usbdux: fix the cmd->start_arg use
      staging: comedi: ni_mio_common: clarify the cmd->start_arg validation and use
      staging: comedi: adl_pci9111: clarify Step 2b of the (*do_cmdtest)
      staging: comedi: cb_pcidas64: remove unnecessary Step 2b test in (*do_cmdtest)
      staging: comedi: me4000: remove unnecessary Step 2b test in (*do_cmdtest)
      staging: comedi: amplc_pci224: remove pci224_cascade_ns_to_timer()
      staging: comedi: amplc_pci224: factor out the 'start pacer' code
      staging: comedi: amplc_pci224: always cascade the 8254 timers
      staging: comedi: amplc_pci224: only calc the pacer divisors once
      staging: comedi: adv_pci1710: remove 'ai_timer2' from private data
      staging: comedi: adv_pci1710: remove 'ai_timer1' from private data
      staging: comedi: adv_pci1710: remove 'ai_flags' from private data
      staging: comedi: adv_pci1710: remove 'ai_chanlist' from private data
      staging: comedi: adv_pci1710: remove 'ai_n_chan' from private data
      staging: comedi: adv_pci1710: remove 'ai_scans' from private data
      staging: comedi: adv_pci1710: remove 'ai_data_len' from private data
      staging: comedi: adv_pci1710: cmd->scan_begin_src can only be TRIG_FOLLOW
      staging: comedi: adv_pci1710: absorb pci171x_ai_docmd_and_mode()
      staging: comedi: adv_pci1710: remove 'ai_do' from private data
      staging: comedi: adv_pci1710: rename check_channel_list()
      staging: comedi: adv_pci1710: tidy up pci171x_ai_check_chanlist()
      staging: comedi: adv_pci1710: don't check the chanlist twice
      staging: comedi: adv_pci1710: remove 'neverending_ai' from private data
      staging: comedi: adv_pci1710: remove 'ai_buf_ptr' from private data
      staging: comedi: adv_pci1710: remove 'ai_eos' from private data
      staging: comedi: adv_pci1710: only calc the pacer divisors once
      staging: comedi: adv_pci1710: remove local var in pci171x_ai_cmd()
      staging: comedi: adv_pci1710: tidy up start_pacer()
      staging: comedi: adv_pci1710: rename interrupt helper functions
      staging: comedi: adv_pci1710: always enable PCI171x_PARANOIDCHECK code
      staging: comedi: adv_pci1710: remove 'i8254_osc_base' from private data
      staging: comedi: adv_pci1710: remove 'ai_act_chan' from private data
      staging: comedi: cb_pcidas: don't calc ai pacer divisors twice
      staging: comedi: cb_pcidas: don't calc ao pacer divisors twice
      staging: comedi: das16m1: don't calc pacer divisors twice
      staging: comedi: das1800: refactor Step 4 of das1800_ai_do_cmdtest()
      staging: comedi: das1800: don't calc pacer divisors twice
      staging: comedi: 8253.h: rename i8253_cascade_ns_to_timer_2div()
      staging: comedi: 8253.h: remove the unused i8253_cascade_ns_to_timer_*()
      staging: comedi: adl_pci9111: tidy up (*do_cmdtest) Step 4
      staging: comedi: addi_apci_2032: tidy up cmd use in apci2032_interrupt()
      staging: comedi: amplc_pci224: remove 'ai_stop_continuous' from private data
      staging: comedi: amplc_pci230: remove 'ai_continuous' from private data
      staging: comedi: amplc_pci230: remove 'ao_continuous' from private data
      staging: comedi: addi_common.h: remove 'ui_AiFlags' from private data
      staging: comedi: addi_common.h: remove 'ui_AiScanLength' from private data
      staging: comedi: addi_common.h: remove 'pui_AiChannelList' from private data
      staging: comedi: addi_common.h: remove 'ui_AiTimer0' from private data
      staging: comedi: addi_common.h: remove 'ui_AiTimer1' from private data
      staging: comedi: addi_common.h: remove 'ui_AiDataLength' from private data
      staging: comedi: addi_common.h: remove 'ui_AiNbrofScans' from private data
      staging: comedi: addi_common.h: remove 'b_AiContinuous' from private data
      staging: comedi: hwdrv_apci3120: cmd->convert_src is always TRIG_TIMER
      staging: comedi: hwdrv_apci3120: fix 'b_AiCyclicAcquisition' usage
      staging: comedi: hwdrv_apci3120: remove clearing of 'b_OutputMemoryStatus'
      staging: comedi: pcl711: fix 8254 timer programming
      staging: comedi: ni_at_ao: fix 8254 timer programming
      staging: comedi: me4000: fix 8254 timer programming
      staging: comedi: amplc_pci244: clarify 8254 timer programming
      staging: comedi: das800: clarify 8254 timer programming
      staging: comedi: ni_labpc: fix 8254 timer programming
      staging: comedi: ni_at_a2150: clarify 8254 timer programming
      staging: comedi: das16m1: clarify 8254 timer programming
      staging: comedi: das16: clarify 8254 timer programming
      staging: comedi: adl_pci9118: remove 'ai_n_chan' from private data
      staging: comedi: adl_pci9118: remove 'ai_chanlist' from private data
      staging: comedi: adl_pci9118: remove 'ai_data_len' from private data
      staging: comedi: adl_pci9118: remove 'ai_timer1' from private data
      staging: comedi: adl_pci9118: remove 'ai_timer2' from private data
      staging: comedi: adl_pci9118: remove 'ai_n_scanlen' from private data
      staging: comedi: adl_pci9118: remove 'i8254_osc_base' from private data
      staging: comedi: adl_pci9118: remove 'ai_scans' from private data
      staging: comedi: adl_pci9118: remove 'usessh' from private data
      staging: comedi: adl_pci9118: cmd->stop_src == TRIG_INT is not supported
      staging: comedi: adl_pci9118: remove 'ai_buf_ptr' from private data
      staging: comedi: adl_pci9118: remove 'valid' from private data
      staging: comedi: adl_pci9118: remove 'cnt0_users' from private data
      staging: comedi: adl_pci9118: remove 'useeoshandle' from private data
      staging: comedi: adl_pci9118: remove 'ai16bits' from private data
      staging: comedi: adl_pci9118: remove 'int_ai_func' from private data
      staging: comedi: adl_pci9118: tidy up interrupt_pci9118()
      staging: comedi: adl_pci9118: tidy up start_pacer()
      staging: comedi: adl_pci9118: remove 'cnt0_divisor' from private data
      staging: comedi: adl_pci9118: remove 'dmabuf_samples' from private data
      staging: comedi: adl_pc19111: remove 'stop_is_none' from private data
      staging: comedi: adl_pc19111: rename 'async_cmd' variable in (*do_cmd)
      staging: comedi: adl_pc19111: remove 'chanlist_len' from private data
      staging: comedi: amplc_dio200_common: remove 'continuous' from subdevice private data
      staging: comedi: amplc_pci224: use comedi_fc helpers to validate timer args
      staging: comedi: pcl730: add support for Diamond Systems PC/104 modules
      staging: comedi: TODO: remove item "reserve major number"
      staging: comedi: adl_pci9111: use comedi_fc helpers to validate timer args
      staging: comedi: adv_pci1710: use comedi_fc helpers to validate timer args
      staging: comedi: dt3000: use comedi_fc helpers to validate timer args
      staging: comedi: adl_pci9118: use comedi_fc helpers to validate timer args
      staging: comedi: cb_pcidas: use comedi_fc helpers to validate timer args
      staging: comedi: comedi_test: use comedi_fc helpers to validate timer args
      staging: comedi: das16: use comedi_fc helpers to validate timer args
      staging: comedi: das16m1: use comedi_fc helpers to validate timer args
      staging: comedi: das800: use comedi_fc helpers to validate timer args
      staging: comedi: dmm32at: use comedi_fc helpers to validate timer args
      staging: comedi: dt2814: use comedi_fc helpers to validate timer arg
      staging: comedi: dt282x: use comedi_fc helpers to validate timer args
      staging: comedi: ni_at_a2150: use comedi_fc helpers to validate timer arg
      staging: comedi: ni_pcidio: use comedi_fc helpers to validate timer arg
      staging: comedi: pcl711: use comedi_fc helpers to validate timer arg
      staging: comedi: pcl812: use comedi_fc helpers to validate timer arg
      staging: comedi: pcl816: use comedi_fc helpers to validate timer arg
      staging: comedi: pcl818: use comedi_fc helpers to validate timer arg
      staging: comedi: quatech_daqp_cs: use comedi_fc helpers to validate timer args
      staging: comedi: rtd520: use comedi_fc helpers to validate timer args
      staging: comedi: s626: use comedi_fc helpers to validate timer args
      staging: comedi: skel: use comedi_fc helpers to validate timer args
      staging: comedi: addi_apci_3xxx: use comedi_fc helpers to validate timer arg
      staging: comedi: usbdux: remove 'ai_continuous' from private data
      staging: comedi: usbdux: remove 'ao_continuous' from private data
      staging: comedi: usbduxfast: remove 'ai_continuous' from private data
      staging: comedi: usbduxsigma: remove 'ai_continuous' from private data
      staging: comedi: usbduxsigma: remove 'ao_continuous' from private data
      staging: comedi: usbdux: remove 'ao_chanlist' from private data
      staging: comedi: usbdux: use 'cmd' pointer in usbduxsub_ai_isoc_irq()
      staging: comedi: usbduxsigma: remove 'ao_chanlist' from private data
      staging: comedi: das800: add a local var for the comedi_cmd pointer
      staging: comedi: das800: remove 'forever' from private data
      staging: comedi: amplc_dio200_common: use comedi_cmd pointer
      staging: comedi: amplc_pci224: use comedi_cmd pointer
      staging: comedi: amplc_pci230: use comedi_cmd pointer
      staging: comedi: cb_pcidas: use comedi_cmd pointer
      staging: comedi: das1800: use comedi_cmd pointer
      staging: comedi: mite: tidy up local variables in mite_sync_output_dma()
      staging: comedi: ni_65xx: remove commented out local variable
      staging: comedi: usbduxsigma: use comedi_cmd pointer
      staging: comedi: pcmuio: tidy up local variables in pcmuio_handle_intr_subdev()
      staging: comedi: pcmmio: use comedi_cmd pointer
      staging: comedi: pcmmio: remove 'continuous' from private data
      staging: comedi: pcl816: fix DMA 'bytes' calculation
      staging: comedi: pcl711: use comedi_cmd pointer
      staging: comedi: ni_mio_common: use comedi_cmd pointer
      staging: comedi: ni_labpc_isadma: use comedi_cmd pointer
      staging: comedi: ni_labpc: use comedi_cmd pointer
      staging: comedi: cb_pcidas64: use comedi_cmd pointer
      staging: comedi: cb_pcidas64: change params to external_ai_queue_in_use()
      staging: comedi: comedi_fc: use comedi_cmd pointer
      staging: comedi: amplc_pci224: use cfc_bytes_per_scan()
      staging: comedi: amplc_pci230: use cfc_bytes_per_scan()
      staging: comedi: das16: use cfc_bytes_per_scan()
      staging: comedi: pcl812: use cfc_bytes_per_scan()
      staging: comedi: pcl816: use cfc_bytes_per_scan()
      staging: comedi: pcl818: use cfc_bytes_per_scan()
      staging: comedi: usbduxfast: remove unreachable code in usbduxfast_ai_cmd()
      staging: comedi: adl_pci9111: factor fifo handling out of pci9111_interrupt()

Hayato Suzuki (1):
      staging: speakup: fix typo in kobjects.c

Heesub Shin (5):
      staging: ion: tidy up a bit
      staging: ion: simplify ion_page_pool_total()
      staging: ion: remove struct ion_page_pool_item
      staging: ion: use compound pages on high order pages for system heap
      staging: ion: shrink highmem pages on kswapd

Hongchao Zhang (1):
      staging/lustre/osc: don't activate deactivated obd_import

Ian Abbott (25):
      staging: comedi: drivers: correct mode check for i8254_set_mode()
      staging: comedi: amplc_dio200_common: correct bound on counter mode
      staging: comedi: remove redundant pointer dereference in comedi_poll()
      staging: comedi: remove async parameter from resize_async_buffer()
      staging: comedi: pass subdevice to comedi_buf_put()
      staging: comedi: pass subdevice to comedi_buf_get()
      staging: comedi: pass subdevice to comedi_buf_memcpy_to()
      staging: comedi: pass subdevice to comedi_buf_memcpy_from()
      staging: comedi: ni_tiocmd: pass subdevice to command setup functions
      staging: comedi: pass subdevice to comedi_buf_write_alloc()
      staging: comedi: pass subdevice to comedi_buf_write_free()
      staging: comedi: pass subdevice to comedi_buf_write_n_allocated()
      staging: comedi: pass subdevice to comedi_buf_read_alloc()
      staging: comedi: pass subdevice to comedi_buf_read_free()
      staging: comedi: pass subdevice to comedi_buf_read_n_available()
      staging: comedi: pass subdevice to comedi_buf_reset()
      staging: comedi: pass subdevice to comedi_buf_is_mmapped()
      staging: comedi: pass subdevice to comedi_buf_munge()
      staging: comedi: pass subdevice to __comedi_buf_write_alloc()
      staging: comedi: pass subdevice to comedi_buf_write_n_available()
      staging: comedi: mite: pass subdevice to mite_buf_change()
      staging: comedi: mite: pass subdevice to mite_sync_input_dma()
      staging: comedi: mite: pass subdevice to mite_sync_output_dma()
      staging: comedi: remove subdevice member of struct comedi_async
      staging: comedi: remove in_request_module

Ioana Ileana (1):
      staging: vt6655: fix sparse warning

Jake Edge (6):
      staging/bcm fix hostmibs.c checkpatch problems
      staging/rtl8187se fix sparse complaints
      staging/skein: rename files and clean up directory structure
      staging/skein: move all threefish block functions to one file
      staging/skein: comment typos
      staging/skein: variable/member name cleanup

James A Shackleford (3):
      staging: ozwpan: Add missing blanklines after declarations
      staging: silicom: fix sparse warning for static variable
      staging: skein: fix sparse warning for static declarations

James Nunez (1):
      staging/lustre/hsm: HSM requests not delivered

Jan Moskyto Matejka (1):
      rtl8821ae: fixed defined-not-used warning

Jason Cooper (22):
      staging: crypto: skein: import code from Skein3Fish.git
      staging: crypto: skein: allow building statically
      staging: crypto: skein: remove brg_*.h includes
      staging: crypto: skein: remove skein_port.h
      staging: crypto: skein: remove __cplusplus and an unneeded stddef.h
      staging: crypto: skein: remove unneeded typedefs
      staging: crypto: skein: remove all typedef {struct, enum}
      staging: crypto: skein: use u8, u64 vice uint*_t
      staging: crypto: skein: fixup pointer whitespace
      staging: crypto: skein: cleanup whitespace around operators/punc.
      staging: crypto: skein: dos2unix, remove executable perms
      staging: crypto: skein: fix leading whitespace
      staging: crypto: skein: remove trailing whitespace
      staging: crypto: skein: cleanup >80 character lines
      staging: crypto: skein: fix do/while brace formatting
      staging: crypto: skein: fix brace placement errors
      staging: crypto: skein: wrap multi-line macros in do-while loops
      staging: crypto: skein: remove externs from .c files
      staging: crypto: skein: remove braces from single-statement block
      staging: crypto: skein: remove unnecessary line continuation
      staging: crypto: skein: add TODO file
      staging: crypto: skein: depend upon CRYPTO

Jean Delvare (1):
      iio: adc: Fix exynos_adc dependencies

Jerry Snitselaar (2):
      staging/line6: blank line after declaration cleanup
      staging: binder: cleanup dereference of noderef expressions

Jes Sorensen (522):
      staging: rtl8723au: Remove a bunch of calls via indirect HAL interface and call functions directly
      staging: rtl8723au: This gets rid of the last HW_VAR_BCN_VALID usage
      staging: rtl8723au: Remove HW_VAR_MEDIA_STATUS* usage
      staging: rtl8723au: Eliminate HW_VAR_SET_OPMODE usage
      staging: rtl8723au: Eliminate usage of HW_VAR_BASIC_RATE
      staging: rtl8723au: Eliminate HW_VAR_MAC_ADDR usage
      staging: rtl8723au: Eliminate HW_VAR_BSSID usage
      staging: rtl8723au: Eliminate HW_VAR_MLME_SITESURVEY usage
      staging: rtl8723au: Eliminate HW_VAR_CHECK_BSSID and HW_VAR_MLME_JOIN
      staging: rtl8723au: Eliminate HW_VAR_BEACON_INTERVAL
      staging: rtl8723au: Eliminate HW_VAR_SLOT_TIME
      staging: rtl8723au: Eliminate HW_VAR_RESP_SIFS
      staging: rtl8723au: Eliminate HW_VAR_ACK_PREAMBLE
      staging: rtl8723au: Eliminate HW_VAR_SEC_CFG usage
      staging: rtl8723au: Kill off HW_VAR_CAM_EMPTY_ENTRY and some function layers wrapping it
      staging: rtl8723au: Eliminate HW_VAR_CAM_WRITE and clean up all the wrapping around it
      staging: rtl8723au: Eiminate the use of HW_VAR_AC_PARAM_{VO,VI,BE,BK}
      staging: rtl8723au: Kill off HW_VAR_ACM_CTRL
      staging: rtl8723au: Make direct calls for HW_VAR_AMPDU_{MIN_SPACE,FACTOR}
      staging: rtl8723au: Kill off HW_VAR_INITIAL_GAIN
      staging: rtl8723au: Nuke HW_VAR_BCN_FUNC
      staging: rtl8723au: Nuke HW_VAR_CHECK_TXBUF, which was also a no-op
      staging: rtl8723au: Make direct calls for HW_VAR_TXDMA_AGG_PG_TH
      staging: rtl8723au: Make direct calls for HW_VAR_H2C_FW_{PWRMODE,JOINBSSRPT}
      staging: rtl8723au: Make direct calls for HW_VAR_H2C_P2P_PS_OFFLOAD
      staging: rtl8723au: Make direct calls for HW_VAR_SET_RPWM
      staging: rtl8723au: Remove commented out set_hwreg calls
      staging: rtl8723au: Make direct calls for HW_VAR_NAV_UPPER
      staging: rtl8723au: Eliminate HW_VAR_DM_FUNC_OP calls
      staging: rtl8723au: Eliminate HW_VAR_DM_FUNC_{SET,CLR}
      staging: rtl8723au: Eliminate HW_VAR_DM_FLAG
      staging: rtl8723au: Remove HW_VAR_APFM_ON_MAC
      staging: rtl8723au: Remove HW_VAR_EFUSE_{BT_,}BYTES
      staging: rtl8723au: Remove HW_VAR_TXPAUSE
      staging: rtl8723au: Eliminate unused HW_VAR_TRIGGER_GPIO_0
      staging: rtl8723au: Remove calls to HW_VAR_H2C_MEDIA_STATUS
      staging: rtl8723au: Remove SetHwReg*() related code
      staging: rtl8723au: Remove empty function rtw_stassoc_hw_rpt23a()
      staging: rtl8723au: Improve some bad switch() formatting
      staging: rtl8723au: Eliminate HW_VAR_RF_TYPE usage
      staging: rtl8723au: Eliminate HW_VAR_FWLPS_RF_ON usage
      staging: rtl8723au: Eliminate HW_WAR_CHK_HI_QUEUE_EMPTY usage
      staging: rtl8723au: Kill off ugly GetHwReg*() interface
      staging: rtl8723au: Remove obsolete HW_VARIABLES enum
      staging: rtl8723au: Remove unused is_boot_from_eeprom() macro
      staging: rtl8723au: Remove #ifdef CONFIG_DEBUG_CFG80211
      staging: rtl8723au: Remove two layers of wrappers around rtw_cfg80211_indicate_scan_done()
      staging: rtl8723au: Don't wrap kill_pid() in an unnecessary macro
      staging: rtl8723au: rtw_os_indicate_connect23a() is only called from one place - fold it in
      staging: rtl8723au: Remove unnecessary memset() followed by a memcpy() into the same space
      staging: rtl8723au: Fix hopeless brackets for declaring a variable mid-function
      staging: rtl8723au: Remove unused functions rtw_indicate_sta_{dis,}assoc_event23a()
      staging: rtl8723au: rtw_report_sec_ie23a() is only called from rtw_mlme.c
      staging: rtl8723au: Remove last remnants of CONFIG_BR_EXT
      staging: rtl8723au: Fold rtw_remainder_len23a() into _rtw_open_pktfile23a()
      staging: rtl8723au: Use proper ETH_P_* types instead of hard coded constants in rtw_xmit.c
      staging: rtl8723au: Fix update_attrib() and set_qos() to not use pktfile nonsense
      staging: rtl8723au: Make rtw_xmitframe_coalesce23a() more readable
      staging: rtl8723au: Don't use pktfile interface in rtw_xmitframe_coalesce23a()
      staging: rtl8723au: Remove ugly pktfile interface
      staging: rtl8723au: Remove unnecessary forward struct declarations from xmit_osdep.h
      staging: rtl8723au: No need to include header files for unused circ_buf and old iwpriv bits
      staging: rtl8723au: Remove a couple of unused prototypes
      staging: rtl8723au: Remove unused bitshift() function
      staging: rtl8723au: Call do_div() directly and get rid of unnecessary wrapper functions
      staging: rtl8723au: Use proper ETH_P_* types in rtw_recv.c
      staging: rtl8723au: Fix case where ethtype was never obtained and always be checked against 0
      staging: rtl8723au: Calling rtw_get_stainfo() with a NULL sta_addr will return NULL
      staging: rtl8723au: Simplify retrieving the ether_type in portctrl()
      staging: rtl8723au: Fix buffer overflow in rtw_get_wfd_ie()
      staging: rtl8723au: Remove duplicate #defines for WLAN_EID_VENDOR_SPECIFIC
      staging: rtl8723au: rtw_security.h - remove some unused macros
      staging: rtl8723au: make source * argument const
      staging: rtl8723au: rtw_mlme_ext.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_mlme.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_ap.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_p2p.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_ieee80211.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_wlan_util.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtl8723a_cmd.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_xmit.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: rtw_recv.c: Use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: Fixup last users to use the kernel's WLAN_EID_* definitions
      staging: rtl8723au: Remove obsolete local defines matching WLAN_EID_*
      staging: rtl8723au: Remove P2P/WiFiDirect/WiFiDisplay code
      staging: rtl8723au: Remove another stack of unused P2P related #defines
      staging: rtl8723au: rtw_restructure_ht_ie23a(): use cfg80211_find_ie()
      staging: rtl8723au: rtw_update_ht_ie23a(): use cfg80211_find_ie()
      staging: rtl8723au: OnProbeReq23a() Use cfg80211_find_ie()
      staging: rtl8723au: OnAuth23() Use cfg80211_find_ie()
      staging: rtl8723au: OnAuth23aClient23a() Use cfg80211_find_ie()
      staging: rtl8723au: OnAssocRsp23a() use ieee80211 header defines
      staging: rtl8723au: OnDeAuth23a() use ieee80211 header defines
      staging: rtl8723au: OnDisassoc23(): Use ieee80211_mgmt
      staging: rtl8723au: OnAction23_back23a() Use ieee80211_mgmt and bug fixes
      staging: rtl8723au: process_80211d() use cfg80211_find_ie()
      staging: rtl8723au: collect_bss_info23a(): Convert to use cfg80211_fine_ie()
      staging: rtl8723au: issue_action_BSSCoexistPacket(): Clean + use cfg80211_find_ie()
      staging: rtl8723au: issue_assocreq23a(): General cleanups and use cfg80211_find_ie()
      staging: rtl8723au: issue_asocrsp23a(): Use cfg80211_find_ie() and cleanups
      staging: rtl8723au: issue_probersp23a(): various cleanups
      staging: rtl8723au: OnAssocReq23a(): Clean up and use more ieee80211.h
      staging: rtl8723au: Make mlme_handlers and action_handlers return int
      staging: rtl8723au: rtw_update_protection23a(): Use cfg80211_find_ie()
      staging: rtl8723au: rtw_get_cur_max_rate23a(): use cfg80211_find_ie()
      staging: rtl8723au: OnBeacon23a(): Use struct ieee80211_mgmt
      staging: rtl8723au: OnBeacon23a(): Use ieee80211_mgmt to calculate ie location
      staging: rtl8723au: Make rtw_check_bcn_info23() take a ieee80211_mgmt pointer
      staging: rtl8723au: rtw_check_bcn_info23a(): Use cfg80211_find_ie()
      staging: rtl8723au: rtw_check_bcn_info23a(): Clean up code obfuscation
      staging: rtl8723au: update_sta_support_rate23a(): Use cfg80211_find_ie()
      staging: rtl8723au: start_bss_network(): Use cfg80211_find_ie()
      staging: rtl8723au: Use const * for parsing wpa IEs
      staging: rtl8723au: rtw_get_cipher_info(): Convert to use cfg80211_* API
      staging: rtl8723au: rtw_check_bcn_info23a(): Remove excessive brackets
      staging: rtl8723au: rtw_check_bcn_info23a(): Use cfg80211 to find WPA info
      staging: rtl8723au: rtw_cfg80211_set_wpa_ie(): Use cfg80211_ API
      staging: rtl8723au: rtw_cfg80211_set_wpa_ie(): Remove unused variable 'pos'
      staging: rtl8723au: Remove obsolete rtw_get_wpa{2,}_ie23a() functions
      staging: rtl8723au: Remove unused for_each_ie() and dump_ies23a()
      staging: rtl8723au: Remove multiple duplicate defines of the WPA OUI
      staging: rtl8723au: update_bcn_vendor_spec_ie(): Go easy on those brackets
      staging: rtl8723au: OnAssocReq23a(): Simplify parsing crypto info from the IE
      staging: rtl8723au: OnAssocReq23a(): Don't check for presence of BSSID twice
      staging: rtl8723au: OnAssocReq23a(): Use cfg80211_find_ie() to locate HT caps
      staging: rtl8723au: Remove struct rtw_ieee802_11_elems and related code
      staging: rtl8723au: Remove unused dump_wpsie23a()
      staging: rtl8723au: Remove unused ieee880211_is_empty_essid()
      staging: rtl8723au: Remove some unused ieee80211 structs
      staging: rtl8723au: ioctl_cfg80211.c: Use eth_{zero,broadcast},addr()
      staging: rtl8723au: OnAssocReq23a(): use ieee80211_mgmt to calculate offset
      staging: rtl8723au: OnProbeReq23a(): Use struct ieee80211_mgmt
      staging: rtl8723au: OnProbeReq23a(): is_valid_p2p_probereq is always false
      staging: rtl8723au: Remove buggy function _rtw_report_sec_ie()
      staging: rtl8723au: rtw_mlme.c: remove commented out debug code
      staging: rtl8723au: OnBeacon23a() tidy up code
      staging: rtl8723au: clean up update_TSF()
      staging: rtl8723au: update_TSF() remove unused argument and move to rtw_mlme_ext.c
      staging: rtl8723au: OnAction23a(): Use struct ieee80211_mgmt instead of hardcoded offsets
      staging: rtl8723au: OnAction23a_back23a(): Use struct ieee8011_mgmt to parse action frames
      staging: rtl8723au: OnAssocRsp23a() use ieee80211_mgmt to obtain DA
      staging: rtl8723au: OnAuth23aClient23a(): Clean up using struct ieee80211_mgmt
      staging: rtl8723au: OnAuth23a(): ieee80211.h-ify
      staging: rtl8723au: mgmt_dispatcher23a(): Use struct ieee80211_mgmt
      staging: rtl8723au: init_channel_set(): Restructure variable names
      staging: rtl8723au: os_intfs.c: Declare a couple of local variables static
      staging: rtl8188eu: usb_intf.c: No point processing an empty table
      staging: rtl8188eu: os_intfs.c: Mark a couple of variables static
      staging: rtl8723au: Clean up namespace clashes with rtl8188eu driver
      staging: rtl8723au: Remove unused function rtw_os_read_port23a()
      staging: rtl8723au: Remove unnecessary abstraction rtw_os_recv_resource_alloc23a()
      staging: rtl8723au: Fold some resource allocation abstraction into their callers
      staging: rtl8723au: Remove another unused prototype
      staging: rtl8723au: Remove dummy function rtw_hostapd_mlme_rx23a()
      staging: rtl8723au: rtw_mlme.c: Clean up mess
      staging: rtl8723au: Fold rtw_to_roaming() into the code
      staging: rtl8723au: Fold _rtw_free_mlme_priv23a() into rtw_free_mlme_priv23a()
      staging: rtl8723au: Remove unused function rtw_get_timestampe_from_ie23a()
      staging: rtl8723au: collect_bss_info23a(): Use struct ieee80211_mgmt
      staging: rtl8723au: Move rtw23a_roaming() so we can declare _rtw_roaming() static
      staging: rtl8723au: Remove bogus inline from rtw_set_roaming() prototype
      staging: rtl8723au: Make _rtw_free_network23() static
      staging: rtl8723au: Add MAINTAINERS entry
      staging: rtl8723au: Check kmalloc return value and fix size of memcpy()
      staging: rtl8723au: Fix incorrect pointer test introduced in previous commit
      staging: rtl8723au: collect_bss_info23a(): Eliminate smatch warning
      staging: rtl8723au: process_80211d(): Fix order of advancing array pos
      staging: rtl8723au: rtw_check_beacon_data23a(): Make len unsigned int
      staging: rtl8723au: c2h_wk_callback(): Use GFP_KERNEL, and check return value
      staging: rtl8723au: rtw_cfg80211_inform_bss() fix Smatch warning
      staging: rtl8723au: cfg80211_rtw_add_key() return -ENOMEM on kmalloc failure
      staging: rtl8723au: Use a workqueue for command handling
      staging: rtl8723au: Remove obsolete hal thread handling code
      staging: rtl8723au: Fold _rtw_free_cmd_priv23a() into rtw_free_cmd_priv23a()
      staging: rtl8723au: Fold _rtw_free_evt_priv23a() into rtw_free_evt_priv23a()
      staging: rtl8723au: Fold _rtw_init_evt_priv23a() into rtw_init_evt_priv23a()
      staging: rtl8723au: Remove obsolete header file cmd_osdep.h
      staging: rtl8723au: Remove unused list_head from struct cmd_obj
      staging: rtl8723au: Remove unused #define FREE_CMDOBJ_SZ
      staging: rtl8723au: Make cmd handlers take a const u8 * as their data argument
      staging: rtl8723au: Preserve const attribute of cmd handler argument
      staging: rtl8723au: rtw_joinbss_cmd23a(): Remove unnecessary typecast
      staging: rtl8723au: rtw_createbss_cmd23a(): Remove unnecessary typecast
      staging: rtl8723au: Remove unnecessary typecasts of struct wlan_bssid_ex objects
      staging: rtl8723au: rtw_set_802_11_infrastructure_mode23a(): Make it readable
      staging: rtl8723au: Make some of the bt-coexist code less unreadable
      staging: rtl8723au: Remove unused usb write_async calls
      staging: rtl8723au: Remove wrapper around rtl8723au_set_intf_ops()
      staging: rtl8723au: Fold rtw_init_io_priv23a() into rtl8723au_set_intf_ops()
      staging: rtl8723au: Remove unused ioreq_* prototypes
      staging: rtl8723au: Not sure what a write_scsi function is doing in a WiFi driver
      staging: rtl8723au: Remove _rtw_write_port_and_wait() functions
      staging: rtl8723au: Remove all references to unused io_queue
      staging: rtl8723au: Remove some leftover pointers from struct rtw_adapter
      staging: rtl8723au: bRxRSSIDisplay is always set to zero
      staging: rtl8723au: Remove unused struct rtw_adapter * from struct io_priv
      staging: rtl8723au: Get rid of struct io_priv
      staging: rtl8723au: Remove unused pintf_dev entry from struct intf_hdl
      staging: rtl8723au: Pass a struct rtw_adapter * to the USB functions
      staging: rtl8723au: Remove unused rtw_adapter * from struct intf_hdl
      staging: rtl8723au: Remove another two unused prototypes
      staging: rtl8723au: Eliminate struct intf_hdl
      staging: rtl8723au: Remove unused entries from struct dvobj_priv
      staging: rtl8723au: Remove unused struct specific_device_id
      staging: rtl8723au: Remove another pile of unused entries from struct rtw_adapter
      staging: rtl8723au: from hal_ops 'interface_ps_func'
      staging: rtl8723au: struct pwrctrl_priv remove unused entry b_hw_radio_off
      staging: rtl8723au: Remove unused hal interface for accessing bb regs
      staging: rtl8723au: Make rtw_get_capability23a_from_ie() return __le 16 *
      staging: rtl8723au: Make sparse happy - make rtw_get_beacon_interval23a_from_ie return __le16 *
      staging: rtl8723au: Eliminate the 217th copy of the microsoft OUI
      staging: rtl8723au: Remove redundant checks of WPA OUI
      staging: rtl8723au: Fold _rtw_init_mlme_priv23a() into rtw_init_mlme_priv23a()
      staging: rtl8723au: Fold _rtw_free_network23a_queue23a() into rtw_free_network_queue23a()
      staging: rtl8723au: Fold _rtw_find_network23a() into rtw_find_network23a()
      staging: rtl8723au: _rtw_free_network23a(): Remove write-only variable 'lifetime'
      staging: rtl8723au: _rtw_free_network23a(): Remove unused argument 'isfreeall'
      staging: rtl8723au: rtw_free_network_queue23a() eliminate unused argument 'isfreeall'
      staging: rtl8723au: Get rid of _rtw_free_network23a_nolock23a()
      staging: rtl8723au: rtw_ieee80211.c mark a couple of function static
      staging: rtl8723au: rtw_ieee80211.c: Reduce some excessive parenthesis usage
      staging: rtl8723au: pass the cmd parm buffer directly to the cmd handler
      staging: rtl8723au: rsp_buf wasn't used for anything - don't allocate it
      staging: rtl8723au: Remove rtw_free_cmd_priv23a()
      staging: rtl8723au: Name cmd workqueue appropriately to allow for more workqueues
      staging: rtl8723au: Use workqueue to handle interrupt complete processing
      staging: rtl8723au: Get rid of ugly cbuf interface
      staging: rtl8723au: Remove unused + write-only entries from struct evt_priv
      staging: rtl8723au: Fix endian abnormality in mlme_evt_hdl23a()
      staging: rtl8723au: Make event callbacks take a const u8 *
      staging: rtl8723au: rtw_event.h remove some unused structs and random blank lines
      staging: rtl8723au: Eliminate struct qos_priv
      staging: rtl8723au: Remove unused rtw_ioctl.h
      staging: rtl8723au: rtw_ioctl_set.h: Remove unused struct bssid_info
      staging: rtl8723au: Remove a pile of unused firmware image file names
      staging: rtl8723au: Remove a bunch of always true #ifdefs
      staging: rtl8723au: rtl8723a_recv.h: Don't put parenthesis around constants
      staging: rtl8723au: rtw_wlan_util.c: Clean up the code
      staging: rtl8723au: Remove redundant check
      staging: rtl8723au: Declare validate_recv_*_frame() static
      staging: rtl8723au: Remove to_fr_ds packet attribute
      staging: rtl8723au: validate_recv_data_frame() use fctl knowledge to obtain bssid
      staging: rtl8723au: update_recvframe_phyinfo(): Don't set variables twice
      staging: rtl8723au: Fold get_hdr_bssid() into update_recvframe_phyinfo()
      staging: rtl8723au: Use struct ieee80211_pspoll to obtain 'aid'
      staging: rtl8723au: wifi.h: remove more unused #defines
      staging: rtl8723au: Use random ethaddr if EEPROM address is corrupted
      staging: rtl8723au: Remove unused ODM malloc/free functions
      staging: rtl8723au: Remove unused ODM spin lock functions
      staging: rtl8723au: Remove a bunch of unused clutter from the ODM code
      staging: rtl8723au: Remove unused struct rtl8723a_priv
      staging: rtl8723au: Remove some unused clutter from odm_types.h
      staging: rtl8723au: Get rid of second set of custom error codes
      staging: rtl8723au: rtw_sta_mgt.c: Fix some formatting badness
      staging: rtl8723au: rtw_alloc_stainfo23a(): Remove unused variable tmp_aid
      staging: rtl8723au: rtw_createbss_cmd23a_callback(): Relax holding of pmlmepriv->lock
      staging: rtl8723au: add GFP argument to rtw_alloc_network()
      staging: rtl8723au: Eliminate stainfo_by_offset spaghetti
      staging: rtl8723au: Use kernel memory allocator for sta_priv allocations
      staging: rtl8723au: Add GFP argument to rtw_alloc_stainfo23a()
      staging: rtl8723au: Declare rtw_alloc_xmitframe() static
      staging: rtl8723au: Use kmalloc() rather than vmalloc() to allocate xmit_frames
      stating: rtl8723au: Use kmalloc instead of vmalloc to allocate pool of xmit_frame_ext
      staging: rtl723au: Remove some obsolete misleading comments
      staging: rtl8723au: Use kmalloc instead of vmalloc to allocate recv_frame pool
      staging: rtl8723au: Remove ugly vmalloc() wrappers
      staging: rtl8723au: Remove unused semaphore 'allrxreturnevt'
      staging: rtl8723au: rtw_free_recvframe23a() is always passed precvpriv->free_recv_queue
      staging: rtl8723au: Eliminate _rtw_queue_empty23a()
      staging: rtl8723au: Eliminate RTW_STATUS_CODE23a()
      staging: rtl8723au: Remove some unused prototypes
      staging: rtl8723au: Get rid of NDEV_FMT/NDEV_ARG macros
      staging: rtl8723au: Remove FUNC_ADPT_{FMT,ARG}
      staging: rtl8723au: Get rid of FUNC_NDEV_{FMT,ARG}
      staging: rtl8723au: Remove unused ADPT_{FMT,AGR} macros
      staging: rtl8723au: Move REALTEK96B_IE23A to rtw_mlme_ext.c and mark it static
      staging: rtl8723au: Move {WPA,RSN}_TKIP_CIPHER23A to rtw_wlan_util.c and mark them static
      staging: rtl8723au: Move rtw_do_join23a() prototype to rtw_ioctl_set.h
      staging: rtl8723au: Declare c2h_evt_hdl static
      staging: rtl8723au: c2h_evt_hdl() is always called with 3rd argument = NULL
      staging: rtl8723au: The driver only has one c2h_id_filter
      staging: rtl8723au: Call c2h_handler_8723a() directly instead of via HAL interface
      staging: rtl8723au: Remove local #define BIT()
      staging: rtl8723au: tid is 4 bits, so we need a 16 bit value to hold a bitmap
      staging: rtl8723au: No need for CHKBIT since 16 + 12 is still < 32
      staging: rtl8723au: 'keyid' is always 0-3, no need for CHKBIT()
      staging: rtl8723au: Another case of missing 'tid' bounds checking.
      staging: rtl8723au: set_qos() keep userpriority in a u8
      staging: rtl8723au: qos_asm23a(): Don't pass through an invalid priority
      staging: rtl8723au: pattrib->priority can't be > 15, no need for CHKBIT()
      staging: rtl8723au: rtw_pwrctrl.c: Reduce spaghettification
      staging: rtl8723au: Remove some unused lists from struct sta_priv
      staging: rtl8723au: Remove another unused queue from struct recv_priv
      staging: rtl8723au: Eliminate no-op function rtl8723au_init_recvbuf()
      staging: rtl8723au: Remove empty *_free_xmit_priv() and friends
      staging: rtl8723au: struct phy_info and struct odm_phy_info are identical
      staging: rtl8723au: struct odm_mac_info isn't used
      staging: rtl8723au: Remove unused variable IOTPeer
      staging: rtl8723au: Since struct odm_sta_info isn't used, remove it completely
      staging: rtl8723au: Remove unused struct odm_ra_info
      staging: rtl8723au: rtl8723a_spec.h: Use BIT() instead of BITx macros
      staging: rtl8723au: rtl8723a_bt-coexist.h: Be consistent and use BIT()
      staging: rtl8723au: Hal8723APhyCfg.h: Use BIT() instead of BITx
      staging: rtl8723au: Hal8723PwrSeq.h: Use BIT() instead of BITx
      staging: rtl8723au: hal_intf.h: Be consistent and use BIT() instead of BITx
      staging: rtl8723au: odm.h: Use BIT() instead of BITx
      staging: rtl8723au: odm_debug.h: Use BIT() instead of BITx
      staging: rtl8723au: odm_reg.h: Use BIT() instead of BITx
      staging: rtl8723au: rtw_sreset.h: Use BIT() instead of BITx
      staging: rtl8723au: rtl8723au_led.c: Use BIT() instead of BITx
      staging: rtl8723au: usb_halinit.c: Use BIT() instead of BITx
      staging: rtl8723au: rtl8723a_bt-coexist.c: Be consistent in use of BIT()
      staging: rtl8723au: hal_com.c: Use BIT() consistently instead of BITx
      staging: rtl8723au: HalDMOutSrt8723A_CE.c: Use BIT() instead of BITx
      staging: rtl8723au: rtl8723a_phycfg.c: Use BIT() instead of BITx
      staging: rtl8723au: rtl8723a_hal_init.c: Use BIT() consistently
      staging: rtl8723au: odm.c: Use BIT() instead of BITx
      staging: rtl8723au: odm_HWConfig.c: Use BIT() consistently
      staging: rtl8723au: Remove obsolete BITx #defines
      staging: rtl8723au: osdep_service.h: Reduce excessive header inclusion
      staging: rtl8723au: Remove unused bBTFWReady from struct rtw_adapter
      staging: rtl8723au: Remove unused rtl8723a_clone_haldata()
      staging: rtl8723au: Remove unused hal_data_sz from struct rtw_adapter
      staging: rtl8723au: Call rtl8723a_init_default_value_directly()
      staging: rtl8723au: Remove some more HAL clutter
      staging: rtl8723au: Get rid of rtw_hal_dm_* clutter
      staging: rtl8723au: Get rid of sreset related HAL clutter
      staging: rtl8723au: Remove unused hal_reset_security_engine code
      staging: rtl8723au: Remove HAL notch_filter wrappers
      staging: rtl8723au: Remove unused HAL wrappers around PHY register read/write calls
      staging: rtl8723au: Remove HAL wrappers around read_chip_version
      staging: rtl8723au: Remove HAL wrappers about USB init/deinit
      staging: rtl8723au: We love wrappers!
      staging: rtl8723au: Disentangle chip_configure from HAL wrappers
      staging: rtl8723au: Call bandwidth and channel setting handlers directly
      staging: rtl8732au: Remove some unused hal data pointers
      staging: rtl8723au: Disentangle beacon register settings from the HAL wrappers
      staging: rtl8723au: Disentangle rtl8723a_add_rateatid() from HAL
      staging: rtl8723au: Get rid of unused rtw_hal_get_odm_var23()
      staging: rtl8723au: Disentangle set_odm_var() from the HAL wrappers
      staging: rtl8723au: Remove first half of EFUSE functions from HAL wrappers
      staging: rtl8723au: Remove a pile of unused EFUSE read/write functionality
      staging: rtl8723au: Pull hal_init/deinit out of HAL wrapper layer
      staging: rtl8723au: Disentangle recv/xmit_priv init/free from HAL wrappers
      staging: rtl8723au: Call xmit/recv handlers directly instead of via HAL wrappers
      staging: rtl8723au: Pull update_ramask call out of HAL wrapper layer
      staging: rtl8723au: Make direct calls to GetHalDefVar8192CUsb()
      staging: rtl8723au: Remove unused hal_power_on() wrapper
      staging: rtl8723au: Remove unused HAL interrupt function wrappers
      staging: rtl8723au: Remove sw led hal ops
      staging: rtl8723au: Get rid of rtl8723au_set_hal_ops() and get rid of hal_ops.h
      staging: rtl8723au: usb_osintf.h isn't used for anything - get rid of it
      staging: rtl8723au: usb_vendor_req.h isn't used - remove it
      staging: rtl8723au: Remove unused mp_custom_oid.h
      staging: rtl8723au: Make cmd and event handlers return int instead of u8
      staging: rtl8723au: Clean up error code mess in rtw_efuse.c
      staging: rtl8723au: Remove unused rtw_is_wps_ie23a()
      staging: rtl8723au: Clean up error codes in IO functions
      staging: rtl8723au: Remove unused usb_read_mem/usb_write_mem stubs
      staging: rtl8723au: rtw_ioctl_set.c: Fix up messy error code handling
      staging: rtl8723au: rtw_mlme_ext.c: Use int to return error codes
      staging: rtl8723au: Don't return true/false in unsigned int
      staging: rtl8723au: decryptor() use int to store error codes
      staging: rtl8723au: rtw_security.c: Clean up mess of error return code types
      staging: rtl8723au: rtw_sta_mgt.c: Clean up messy usage of return types
      staging: rtl8723au: rtw_wlan_util.c: Fix up random mixing of bool vs int
      staging: rtl8723au: rtw_xmit.c: Be consistent in using int for error return type
      staging: rtl8732au: ioctl_cfg80211.c: Fix another case of u8 abuse for error return
      staging: rtl8723au: os_intfs.c: Fixup more u8/uint abuse for error return codes
      staging: rtl8723au: usb_intf.c: Fixup yet another round of u8 abuse for error type
      staging: rtl8723au: usb_halinit.c: Another u8 error code case
      staging: rtl8723au: rtl8723au_xmit_tasklet(): Remove unnecessary variable init
      staging: rtl8723au: rtl8723au_xmit.c: Fixup messy return type usage
      staging: rtl8723au: rtl8723a_phycfg.c: Use int for error return codes
      staging: rtl8723au: rtl8723a_hal_init.c: Fix more messy return type abuse
      staging: rtl8723au: rtl8723a_cmd.c: Fix up bad return types
      staging: rtl8723au: hal_com.c: Fix one case of returning status in an s32
      staging: rtl8723au: odm_precomp.h: Remove unused #define TEST_FALG__
      staging: rtl8723au: hal/usb_ops_linux.c: Various cleanups
      staging: rtl8723au: os_dep/usb_ops_linux.c: More bad parenthesis cleanup
      staging: rtl8723au: os_intfs.c: Various cosmetic cleanups
      staging: rtl8723au: Move last utility function from osdep_service.c to os_intfs.c
      staging: rtl8723au: Remove unused usb_suspend_sema
      staging: rtl8723au: Call rtl8723au_set_hw_type() directly
      staging: rtl8723au: Call usb_intf_{start,stop} directly
      staging: rtl8723au: Don't wrap calls to usb_control_msg()
      staging: rtl8723au: Remove unused USB bulk related macros and variables
      staging: rtl8723au: Remove nasty wrappers used to hide wrong function types
      staging: rtl8723au: usb_ops_linux.h: Remove some unused #defines
      staging: rtl8723au: Clean up mess of parenthesis abuse
      staging: rtl8723au: Use correct pipe type for USB interrupts
      staging: rtl8723au: Clean up usb_{read,write}_port() usage
      staging: rtl8723au: Call usb_{read,write}_port() functions directly
      staging: rtl8723au: Call usb_read_interrupt() directly instead of via HAL layer
      staging: rtl8723au: Call usb_read*() functions directly
      staging: rtl8723au: Call usb_write*() functions directly
      staging: rtl8723au: Name port vs register access functions consistently
      staging: rtl8723au: Remove some leftover obsolete prototypes
      staging: rtl8723au: The DBG_IO code is all gone
      staging: rtl8723au: Remove some unused ODM dynamic TX power functionality
      staging: rtl8723au: Do not reset wdev->iftype in netdev_close()
      staging: rtl8723au: Fix compiling with CONFIG_8723AU_BT_COEXIST=n
      staging: rtl8723au: Use nl80211_iftype instead of driver's own custom types
      staging: rtl8723au: Get rid of write only NetworkTypeInUse and matching enum
      staging: rtl8723au: HalEEValueCheck(): content of a u8 is always >= 0
      staging: rtl8723au: Fix up some random bit-flag handling
      staging: rtl8723au: Add -Wtype-limits to CFLAGS
      staging: rtl8723au: Store algorithm type in a u32
      staging: rtl8723au: We don't support SMS4 or WEP+WPA mixed encryption
      staging: rtl8723au: Remove unused enum odm_security
      staging: rtl8723au: Use WLAN_CIPHER_SUITE_* to mark crypto type
      staging: rtl8723au: Introduce struct rtw_wep_key to store our wep keys
      staging: rtl8723au: Move rtw_set_802_11_add_wep23a() to ioctl_cfg80211.c
      staging: rtl8723au: rtw_cfg80211_add_wep(): Get rid of unused keyindex flags
      staging: rtl8723au: Make rtw_cfg80211_add_wep() take a struct rtw_wep_key
      staging: rtl8723au: Get rid of unused struct ndis_802_11_configuration_fh
      staging: rtl8723au: Get rid of struct ndis_802_11_config
      staging: rtli8723au: Get rid of struct ndis_802_11_fixed_ies
      staging: rtl8723au: Get rid of struct ndis_802_11_var_ies
      staging: rtl8723au: wlan_bssdef.h: Remove some more unused #defines
      staging: rtl8723au: Get rid of ClearMFrag/SetMFrag
      staging: rtl8723au: wifi.h: Remove unused SetRetry() + SetAMsdu() macros
      staging: rtl8723au: Use kernel provided WLAN_CAPABILITY_* definitions
      staging: rtl8723au: Use kernel provided IEEE80211_HT_OP_MODE_* defines
      staging: rtl8723au: Use kernel provided IEEE80211_HT_PARAM_* defines
      staging: rtl8723au: Remove unused enum WIFI_REG_DOMAIN
      staging: rtl8723au: wifi.h: Remove a pile of unused WDS_ defines
      staging: rtl8723au: Get rid of last HT OP mode duplicate defines
      staging: rtl8723au: cfg80211_rtw_mgmt_tx(): type is always -1
      staging: rtl8723au: ioctl_cfg80211.c: Rip out < 3.14 kernel support
      staging: rtl8723au: rtw_cfg80211_inform_bss(): Use get_unaligned_le16()
      staging: rtl8723au: ioctl_cfg80211.c: Properly initialize seq_ctrl
      staging: rtl8723au: rtl8723a_cmd.c: Properly initialize seq_ctrl
      staging: rtl8723au: rtw_make_wlanhdr23a(): Use IEEE80211_SN_TO_SEQ() to set seq_ctrl
      staging: rtl8723au: Declare rtw_make_wlanhdr() static
      staging: rtl8723au: Get rid of SetSeqNum()
      staging: rtl8723au: wifi.h: Remove unused SetFragNum() macro
      staging: rtl8723au: Get rid of ugly SetDuration() macro usage
      staging: rtl8723au: Get rid of SetPrivacy()/SetPwrMgt()/SetMData() macros
      staging: rtl8723au: rtl8723a_update_ramask(): Get rid of annoying debug message
      staging: rtl8723au: rtl8723a_cmd.c: Use ieee80211.h defines to set qos_ctrl
      staging: rl8723au: rtw_make_wlanhdr(): Use ieee80211_qos_hdr
      staging: rtl8723au: _issue_qos_nulldata23a(): Use struct ieee80211_qos_hdr
      staging: rtl8723au: Get rid of obsolete SetPriority()/SetEOSP()/SetAckpolicy()
      staging: rtl8723au: Remove unused SetFrameType() macro
      staging: rtl8723au: rtw_xmit.c: Use IEEE80211_[FS]TYPE_ defines
      staging: rtl8723au: rtl8723a_cmd.c: Use ieee80211.h provided fctl bits
      staging: rtl8723au: ioctl_cfg80211.c: Use ieee80211.h provided fctl bits
      staging: rtl8723au: rtw_mlme_ext.c: Get rid of most WIFI_* frame type usage
      staging: rtl8723au: Declare issue_asocrsp() static
      staging: rtl8723au: Fix issue_assocrsp() to use IEEE80211_STYPE_* defines
      staging: rtl8723au: Get rid of duplicate ieee80211 frame_control defines
      staging: rtl8723au: rtw_mlme_ext.c: Get rid of SetToDs()/SetFrDs() usage
      staging: rtl8723au: rtw_xmit.c: Get rid of SetToDs()/SetFrDs() usage
      staging: rtl8723au: rtl8723a_cmd.c: Get rid of SetToDs()/SetFrDs() usage
      staging: rtl8723au: wifi.h: Get rid of last ugly frame_control manipulation macros
      staging: rtl8723au: rtw_mlme_ext.c: Declare a number of functions static
      staging: rtl8723au: rtw_mlme_ext.c: Fix compile warnings
      staging: rtl8723au: Don't compile rtw_ap.c when CONFIG_8723AU_AP_MODE=n
      staging: rtl8723au: Declare SetBWMode23a() static
      staging: rtl8723au: Get rid of unused get_bsstype23a()
      staging: rtl8723au: Move dummy_event_callback() to rtw_mlme_ext.c
      staging: rtl8723au: Get rid of some unused tdls definitions
      staging: rtl8723au: rtw_cmd.h: Remove some more unused #defines
      staging: rtl8723au: rtw_ieee80211.c: Remove a number of unused functions
      staging: rtl8723au: rtw_get_bcn_info23a(): Use cfg80211_find_ie()
      staging: rtl8723au: rtw_get_bcn_info23a(): Don't zero variables unncessarily
      staging: rtl8723au: rtw_cfg80211_monitor_if_xmit_entry() use struct ieee80211_mgmt
      staging: rtl8723au: rtw_cfg80211_rx_action(): Use ieee80211_mgmt to parse action frame
      staging: rtl8723au: Remove obsolete rtw_action_frame_parse23a()
      staging: rtl8723au: Declare rtw_site_survey() static
      staging: rtl8723au: rtw_mlme_ext.c: Improve bad formatting in event handlers
      staging: rtl8723au: rtw_mlme_ext.c: Fixup some more unreadable formatting
      staging: rtl8188eu: Do not byteswap half initialized variable
      staging: rtl8723au: ieee80211.h: Remove some unused #defines
      staging: rtl8723au: Use ieee80211.h defines for IV/ICV len values
      staging: rtl8723au: rtw_xmit.c: Use ether_addr_copy()
      staging: rtl8723au: Don't explicitly check check_fwstate() == true
      staging: rtl8723au: Make check_fwstate() return bool
      staging: rtl8723au: Don't check check_fwstate() == false
      staging: rtl8723au: Remove unused enum SCAN_RESULT_TYPE
      staging: rtl8723au: rtw_mlme.h: Remove a bunch of unused structs
      staging: rtl8723au: Remove unused struct hostapd_priv
      staging: rtl8723au: Do not call netdev_open23a() from cfg80211_rtw_change_iface()
      staging: rtl8723au: ioctl_cfg80211.c: Use ether_addr_copy()
      staging: rtl8723au: ioctl_cfg80211.c: Use ether_addr_equal()
      staging: rtl8723au: Delete unused rtw_cfg80211_set_mgnt_wpsp2pie()
      staging: rtl8723au: _cfg80211_rtw_mgmt_tx() clean up checking function return values
      staging: rtl8723au: Get rid of unused struct rtw_wdev_invit_info
      staging: rtl8723au: struct rtw_wdev_priv: Remove some never 'true' variables
      staging: rtl8723au: Remove some pointless cfg80211_* wrapper macros
      staging: rtl8723au: rtw_wdev_alloc(): Don't register wiphy before kmalloc() completed
      staging: rtl8723au: Remove unused prototype rtw_cfg80211_issue_p2p_provision_request23a()
      staging: rtl8723au: bInternalAutoSuspend is always false
      staging: rtl8723au: _rtw_pwr_wakeup23a(): Do not mix _FAIL/false as return value
      staging: rtl8723au: PS_RDY_CHECK() return bools in 'bool'
      staging: rtl8723au: Create rtl8723au_bt_intf.h
      staging: rtl8723au: Convert BT_IsBtDisabled() into rtl8723a_BT_enabled()
      staging: rtl8723au: Introduce rtl8723a_BT_coexist() - and use it!
      staging: rtl8723au: Remove some CONFIG_8723AU_BT_COEXIST clutter
      staging: rtl8723au: Rename BTDM_Coexist() to rtl8723a_BT_do_coexist()
      staging: rtl8723au: Rename BT_WifiScanNotify() rtl8723a_BT_wifiscan_notify()
      staging: rtl8723au: Rename BT_WifiMediaStatusNotify() rtl8723a_BT_mediastatus_notify()
      staging: rtl8723au: Rename BTDM_ForDhcp() to rtl8723a_BT_specialpacket_notify()
      staging: rtl8723au: Rename BT_LpsLeave() rtl8723a_BT_lps_leave()
      staging: rtl8723au: rtw_cmd.c: Remove last #ifdef CONFIG_8723AU_BT_COEXIST usage
      staging: rtl8723au: rtw_pwrctrl.c: Remove an unnecessary COEXIST #ifdef
      staging: rtl8723au: rtw_pwrctrl.c: Eliminate CONFIG_8723AU_BT_COEXIST #ifdefs
      staging: rtl8723au: rtw_mlme_ext.c: Remove CONFIG_8723AU_BT_COEXIST #ifdefs
      staging: rtl8723au: rtw_mlme_ext.c: Sanitize calls to alloc_mgtxmitframe23a()
      staging: rtl8723au: odm.c: Rename BTDM_DisableEDCATurbo() to rtl8723a_BT_disable_EDCA_turbo()
      staging: rtl8723au: Move rtl8723a_dual_antenna_detection() to rtl8723a_bt-coexist.c
      staging: rtl8723au: Rename HALBT_InitHwConfig() rtl8723a_BT_init_hwconfig()
      staging: rtl8723au: usb_halinit.c: Remove no-op HAL_INIT_PROFILE_TAG()
      staging: rtl8723au: rtl8732au_hal_init.c: Use rtl8723au_BT_coexist() to pick firmware image
      staging: rtl8723au: Rename BT_WifiAssociateNotify() rtl8723a_BT_wifiassociate_notify()
      staging: rtl8723au: Make rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd() a no-op when no co-exist enabled
      staging: rtl8723au: Rename HALBT_InitBTVars8723A() rtl8723a_BT_init_hal_vars()
      staging: rtl8723au: rtl8723a_bt-coexist.c: Remove unnecessary #ifdef CONFIG_8723AU_BT_COEXIST
      staging: rtl8723au: Rename BTDM_FwC2hBtInfo8723A() to rtl8723a_fw_c2h_BT_info()
      staging: rtl8723au: Remove unused struct btdata_info
      staging: rtl8723au: _InitQueueReservedPage(): Remove pointless brackets

Jimmy Li (1):
      Staging: vt6655: iwctl.c: fix a sparse warning

Jinshan Xiong (3):
      staging/lustre/lov: to not hold sub locks at initialization
      staging/lustre/llite: access layout version under a lock
      staging/lustre/clio: Solve a race in cl_lock_put

Joe Perches (2):
      staging: realtek: Convert /n to \n
      staging: Convert __FUNCTION__ to __func__

Joel Pelaez Jorge (2):
      Staging: rtl8192e: Fix declaration of symbols
      Staging: rtl8192u: Remove old WIRELESS_EXT support

Joel Porquet (2):
      staging: iio: fix coding style
      staging: silicom/bypasslib/bp_ioctl.h: Fix erroneous global variable definitions

John Church (1):
      staging : android: Fixes a coding style issue in timed_gpio.c

John L. Hammond (4):
      staging/lustre/lov: remove unused lov llog code
      staging/lustre/obdclass: remove uses of lov_stripe_md
      staging/lustre: remove lustre/include/ioctl.h
      staging/lustre/llite: remove dead code

John de la Garza (1):
      drivers:staging:lustre Fixed sparse warning: plain integer as NULL pointer

Jonas Hahnfeld (2):
      staging: rtl8187se: Fix warning symbol should be static
      staging: keucr: Fix warning about missing blank lines after declarations

Jonathan Cameron (9):
      iio:core: Fix bug in length of event info_mask and catch unhandled bits set in masks.
      iio:gyro:itg3200 - drop unreachable return ret. Highlighted by smatch
      staging:iio:adc:spear adc - prefix defines to avoid namespace clashes.
      staging:iio:adc:spear_adc drop initialization of unused scan_type
      staging:iio:adc:spear_adc use info_mask_shared_by_all for samp freq
      staging:iio:adc:spear rename device specific state structure to _state
      staging:iio:adc:spear rename iodev -> indio_dev to fit with current convention
      staging:iio:adc:spear rename spear_read_raw to spear_adc_read_raw
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max11610 and max11611.

Josep Puigdemont (1):
      staging: lustre: Fix coding style

Joshua Baldock (3):
      Staging: lustre: Fixed errors reported by checkpatch.pl script for file ptllnd.h
      Staging: lustre: Corrected styling errors reported by checkpatch.pl script on file ptllnd_wire.h
      Staging: lustre: Fixed syntax errors reported by checkpatch.pl script for file types.h

Julia Lawall (3):
      staging: panel: replace del_timer by del_timer_sync
      staging: wlags49_h2: make return of 0 explicit
      staging: rtl8192e: make return of 0 explicit

Julian Gindi (1):
      bcm: Fixing a few checkpatch issues in InterfaceMisc.h

Jun Tian (5):
      goldfish: 64-bit audio driver for goldfish platform
      goldfish: 64-bit nand driver for goldfish platform
      goldfish: 64-bit pipe driver for goldfish platform
      goldfish: fix kernel panic when using multiple adb connection
      goldfish: enable 64-bit tty driver

Karim Raslan (1):
      staging: rtl8723au: rtw_sta_mgt: change rtw_alloc_stainfo23a to use gfp_t instead if int

Kees Cook (2):
      iio: force snprintf for PAGE_SIZE bufs
      staging/rtl8821ae: avoid format string leak to thread name

Ken Cox (8):
      Staging: unisys: virthba: add MODULE_DEVICE_TABLE
      Staging: unisys: detect s-Par firmware
      Staging: unisys: visorutil: Add MODULE_LICENSE("GPL")
      Staging: unisys: Fix sparse warnings
      Staging: unisys: virthba: declare virthba_queue_command as static
      Staging: unisys: Remove unused macros from visorchannel/visorchannel.h
      Staging: unisys: Fixup sparse warnings for dereferencing noderef types.
      Staging: unisys: visorchipset: Remove filexfer.c

Kim Nylund (1):
      staging: r8188eu: Add support for Dlink DWA-121 802.11n Wireless N 150 Pico Adapter

Konrad Zapalowicz (12):
      staging: rtl8188eu: fix spaces instead of tabs for rtw_p2p.c
      staging: rtl8188eu: fix spaces instead of tabs for rtw_recv.c
      staging: rtl8821ae: fix double const in sw.c
      staging: rtl8821ae: fix not declared symbols should be static in sw.c
      staging: rtl8821ae: add static for local symbols in halbtc8723b1ant.c
      staging: rtl8821ae: deal with unused functions in halbtc8723b1ant.c
      staging: rtl8821ae: add static for local symbols in halbtc8723b2ant.c
      staging: rtl8821ae: deal with unused functions in halbtc8723b2ant.c
      staging: rtl8821ae: add static for local symbols in halbtcoutsrc.c
      staging: rtl8821ae: deal with unused functions in halbtcoutsrc.c
      staging: rtl8821ae: add static for local symbols in rtl_btc.c
      staging: vt6655: refactor iwctl_giwaplist() to avoid -Wframe-larger-than warn.

Kristina Martšenko (1):
      staging: goldfish: switch from spinlock to mutex

Kumar Amit Mehta (1):
      staging: comedi: drivers: pcl812.c: add curly braces for checkpatch

L. Alberto Giménez (1):
      staging/line6: Fix kzalloc coding style issue

Larry Finger (18):
      staging: rtl8723au: Fix build error due to bad commit 6c89f82
      staging: r8723au: Fix sparse errors in os_dep/osdep_service.c
      staging: r8723au: Fix sparse warning in os_dep/os_intfs.c
      staging: r8723au: Fix endian issues with TX and RX descriptors
      staging: r8723au: Fix endian issues in hal/rtl8723au_recv.c
      staging: r8723au: Fix endian errors in descriptor get and set macros
      staging: r8723au: Set undeclared routines to static
      staging: r8723au: Fix sparse warnings in core/rtw_ap.c
      staging: r8723au: Fix endian errors for frame control
      staging: rtl8723au: Move data byte-swap closer to register access
      staging: r8192ee: Add source files for core driver
      staging: r8192ee: Add code for Bluetooth coexistence
      staging: r8192ee: Add the files in the rtl8192ee directory
      staging: r8192ee: Turn on build of the new driver
      staging: r8188eu: Fix some sparse warnings
      staging: r8192ee: Fix kernel WARN splat associated with rate control
      staging: r8192ee: Fix build errors when PCI is not available
      staging: r8821ae: Fix potential problem with rate control registration

Lars-Peter Clausen (2):
      staging:iio:ad799x: Move ring functions to the main file
      staging:iio: Move ad799x driver out of staging

Levente Kurusa (1):
      staging: rtl8821ae: fix pointer coding style

Li Xi (4):
      staging/lustre/ldlm: Hold lock when clearing flag
      staging/lustre: fix permission problem of setfacl
      staging/lustre/libcfs: add CPU table functions for uniprocessor
      staging/lustre: remove assertion of spin_is_locked()

Liang Zhen (1):
      staging/lustre/lnet: NI shutdown may loop forever

Linus Walleij (2):
      iio: st_sensors: announce registered sensors
      iio: st_sensors: move regulator retrieveal to core

Loïc Pellegrino (1):
      staging: rtl8192u: Fix indentation problems

Lubomir Rintel (4):
      staging: xgifb: Eliminate useless ifndefs
      staging: xgifb: Initialize Part0Port
      staging: xgifb: Drop some more useless defines
      staging: xgifb: Update TODO

Luca Ellero (1):
      staging: comedi: fix checkpatch warnings

Luis Ortega (1):
      Staging: bcm: Qos: fixed braces' coding style

Maarten de Jonge (1):
      staging: et131x: add blank lines after declarations

Malcolm Priestley (138):
      staging: vt6656: rxtx.c: s_vFillTxKey Replace dwRevIVCounter
      staging: vt6656: rxtx s_vFillTxKey Fix pdwIV base type
      staging: vt6656: rxtx: s_vFillTxKey Fix base type pdwExtIV
      staging: vt6656: rxtx: s_vFillTxKey fix pMACHeader sparse warning
      staging: vt6656: rxtx Replace struct vnt_tx_fifo_head wTimeStamp
      staging: vt6656: rxtx struct vnt_tx_buffer Replace wTxByteCount
      staging : vt6656: rxtx struct vnt_beacon_buffer Replace wTxByteCount
      staging: vt6656: rxtx Replace vnt_tx_fifo_head wReserved
      staging: vt6656: vnt_fill_ieee80211_rts replace TYPE_CTL_RTS macro
      staging: vt6656: rxtx s_vFillCTSHead replace TYPE_CTL_CTS macro
      staging: vt6656: rxtx: Remove unused uDMAIdx from driver.
      staging: vt6656: desh.h Remove unused macros and structures.
      staging: vt6656: nsDMA_tx_packet Move pContext later.
      staging: vt6656: struct vnt_usb_send_context remove camel case.
      staging: vt6656: lock changes: Remove spin locks.
      staging: vt6656: lock changes: vRunCommand remove locks.
      staging: vt6656: lock changes: RXvMngWorkItem.
      staging: vt6656: lock changes: csMgmt_xmit.
      staging: vt6656: lock changes: vDMA0_tx_80211
      staging: vt6656: lock changes: bMgrPrepareBeaconToSend add lock.
      staging: vt6656: lock changes: vRunCommand nsDMA_tx_packet
      staging: vt6656: lock changes: usbpipe.c add mutex lock.
      staging: vt6656: lock changes: s_nsBulkInUsbIoCompleteRead.
      staging: vt6656: lock changes device_xmit
      staging: vt6656: usbpipe.c PIPEnsControlOut use usb_control_msg
      staging: vt6656: PIPEnsControlIn use usb_control_msg
      staging: vt6656: Remove PIPEnsControlOutAsyn/CONTROLnsRequestOutAsyn
      staging: vt6656: rf.c additional power.
      staging: vt6656: usbpipe: get rid of in/out debug messages.
      staging: vt6656: usbpipe: replace debug messsages.
      staging: vt6656: PIPEnsControlOut remove camel case.
      staging: vt6656: PIPEnsControlIn remove camel case.
      staging: vt6656: device_cfg.h remove dead code.
      staging: vt6656: device_cfg.h Move macros to device.h
      staging: vt6656: device.h remove dead macros
      staging: vt6656: desc.h Remove unused macros
      staging: vt6656: srom.h : Remove dead code.
      staging: vt6656: srom.h move all macros to device.h
      staging: vt6656: rndis.h remove dead code.
      staging: vt6656: rndis.h move all to device.h
      staging: vt6656: Remove unused variable byRevId.
      staging: vt6656: Remove unused variable ulTxPower.
      staging: vt6656: Remove dead variable bCCK.
      staging: vt6656: Remove unused variable uScanTime.
      staging: vt6656: Remove unused variable byACKRate.
      staging: vt6656: vnt_private remove dead variables.
      staging: vt6656: vnt_private remove dead variables
      staging: vt6656: vnt_private remove dead variables.
      staging: vt6656: Remove always true bUpdateBBVGA
      staging: vt6656: Remove dead code hostap.
      staging: vt6656: Remove hostapd functions.
      staging: vt6656: dpc.c remove hostapd
      staging: vt6656: dead code bRelayPacketSend
      staging; vt6656: dead code aes_ccmp.
      staging: vt6656: checkpatch cleanup BBuGetFrameTime.
      staging: vt6656: BBuGetFrameTime remove uRateIdx
      staging: vt6656: BBuGetFrameTime remove camel case.
      staging: vt6656: checkpatch cleanup BBvCalculateParameter.
      staging: vt6656: BBvCalculateParameter remove camel case
      staging: vt6656: clean up BBvSetAntennaMode.
      staging: vt6656: BBvSetAntennaMode remove camel case.
      staging: vt6656: BBvSetShortSlotTime remove camel case.
      staging: vt6656: BBvSetVGAGainOffset remove camel case
      staging: vt6656: BBvSetDeepSleep remove camel case
      staging: vt6656: BBvExitDeepSleep remove camel case.
      staging: vt6656: BBvUpdatePreEDThreshold replace debug messages.
      staging: vt6656: BBvUpdatePreEDThreshold reorganize ControlvWriteByte.
      staging: vt6656: BBvUpdatePreEDThreshold change byBBPreEDIndex
      staging: vt6656: clean up BBvUpdatePreEDThreshold
      staging: vt6656: iocmd.h remove dead code.
      staging: vt6656: iowpa.h removed dead code.
      staging: vt6656: ETHbIsBufferCrc32Ok replace CRCdwGetCrc32
      staging: vt6656: s_vSWencryption replace CRCdwGetCrc32Ex
      staging: vt6656: remove dead code tcrc.c/h
      staging: vt6656: dead code remove diversity code
      staging: vt6656: remove camel case MACvWriteMultiAddr
      staging: vt6656: remove camel case MACbShutdown
      staging: vt6656: camel case clean up MACvSetBBType
      staging: vt6656: MACvDisableKeyEntry fix sizeof uEntryIdx to u8
      staging: vt6656: camel case clean up MACvDisableKeyEntry
      staging: vt6656: camel case cleanup MACvRegBitsOff
      staging: vt6656: camel case clean up MACvRegBitsOn
      staging: vt6656: camel case cleanup MACvWriteWord
      staging: vt6656: MACvWriteBSSIDAddress remove pbyData
      staging: vt6656: camel case clean up MACvWriteBSSIDAddress
      staging: vt6656: camel case clean up MACvEnableProtectMD
      staging: vt6656: camel case clean up MACvDisableProtectMD
      staging: vt6656: camel case clean up MACvEnableBarkerPreambleMd
      staging: vt6656: camel case clean up MACvDisableBarkerPreambleMd
      staging: vt6656: camel case clean up MACvWriteBeaconInterval
      staging: vt6656: camel case clean up CARDvCalculateOFDMRParameter
      staging: vt6656: camel case cleanup CARDvSetRSPINF
      staging: vt6656: camel case cleanup vUpdateIFS
      staging: vt6656: camel case clean up CARDvUpdateBasicTopRate
      staging: vt6656: camel case cleanup CARDbAddBasicRate
      staging: vt6656: Convert remaining locks to spin_lock_irqsave.
      staging: vt6656: camel case clean up CARDbIsOFDMinBasicRate
      staging: vt6656: camel case and cleanup CARDbyGetPktType
      staging: vt6656: CARDqGetTSFOffset remove camel case
      staging: vt6656: camel case and clean up CARDvAdjustTSF
      staging: vt6656: CARDbGetCurrentTSF remove camel case
      staging: vt6656: CARDbClearCurrentTSF remove camel case
      staging: vt6656: CARDqGetNextTBTT remove camel case
      staging: vt6656: camel case and clean up CARDvSetFirstNextTBTT
      staging: vt6656: camel case clean up CARDvUpdateNextTBTT
      staging: vt6656: camel case clean up CARDbRadioPowerOff
      staging: vt6656: camel case clean up CARDbRadioPowerOn
      staging: vt6656: camel case and clean up CARDvSetBSSMode
      staging: vt6656: CARDvCalculateOFDMRParameter fix indentation rsv_time
      staging: vt6656: swGetOFDMControlRate remove camel case
      staging; vt6656: swGetCCKControlRate remove camel case
      staging: vt6656: card.c replace DBG_PRT debug messages.
      staging: vt6656: baseband.c replace DBG_PRT debug messages
      staging: vt6656: BBbVT3184Init fix word lenght
      staging: vt6656: s_uGetRTSCTSRsvTime fix word lenght
      staging: vt6656: s_vFillTxKey fix indentation of memcpy
      staging: vt6656: MACvSetKeyEntry create structure to write key
      staging: vt6656: MACvSetKeyEntry change u32 pdwKey to u8 pointer
      staging: vt6656: MACvSetKeyEntry remove camel case.
      staging: vt6656: mac.c remove DBG_PRT debug message.
      staging: vt6656: rename PIPEnsControlOut/CONTROLnsRequestOut to vnt_control_out
      staging: vt6656: rename PIPEnsControlIn/CONTROLnsRequestIn with vnt_control_in
      staging: vt6656: replace ControlvWriteByte with vnt_control_out_u8
      staging: vt6656: Create new function to set led state.
      staging: vt6656: remove dead code ControlvMaskByte
      staging: vt6656: create vnt_control_in_u8 to replace ControlvReadByte
      staging: vt6656: dead code remove control.c/h
      staging: vt6656: Fix CARDvCalculateOFDMRParameter static warning
      staging: vt6656: WCTLbIsDuplicate fix PSCacheEntry base types and warnings
      staging: vt6656: IFRFbWriteEmbedded use ARRAY_SIZE
      staging: vt6656: IFRFbWriteEmbedded remove camel case
      staging: vt6656: rf.c: rename IFRFbWriteEmbedded to vnt_rf_write_embedded
      staging: vt6656: rf.c/h rename RFbSetPower to vnt_rf_setpower
      staging: vt6656: rf.c/h rename RFbRawSetPower to vnt_rf_set_txpower
      staging: vt6656: rf.c/h rename RFvRSSITodBm to vnt_rf_rssi_to_dbm
      staging: vt6656: rf.c rename RFbRFTableDownload to vnt_rf_table_download.
      staging: vt6656: rf.c Fix typo error at3226*
      staging: vt6656: rf.c replace DBG_PRT debug messages

Manuel Schölling (3):
      staging: lustre: Use time_before()
      staging: rtl8188eu: use time_before/time_after and change type of ips_deny_time
      staging: dgnc: Use time_after_eq()

Marcin Kostrzewa (1):
      Staging: comedi: addi-data: clean up formatting of the else statement

Marcos A. Di Pietro (1):
      Staging:bcm: Fixes coding style issues in drivers/staging/bcm/Qos.c

Marcus Farkas (3):
      staging: rtl8712: fix missing blank lines after declarations
      staging: rtl8712: fix unnecessary parentheses
      staging: rtl8712: fix unnecessary line continuations

Mark Einon (12):
      staging: rtl8821ae: Fix whitespace in rtl8821ae/hw.h
      staging: rtl8821ae: Remove FSF mailing address from rtl8821ae/hw.h header
      staging: rtl8821ae: Fix rtl8821ae/hw.h pointer declaration style
      staging: rtl8821ae: Remove file #if 1
      staging: rtl8821ae: Remove unused functions
      staging: rtl8821ae: Fix halbtc8192e2ant.c 'should it be static?' sparse warnings
      staging: rtl8821ae: Fix halbtc8192e2ant.c 'defined but not used' sparse warnings
      staging: rtl8821ae: Remove declaration assignment to zero
      staging: rtl8821ae: Fix checkpatch whitespace issues
      staging: rtl8821ae: halbtc8192e2ant.c fix checkpatch leading spaces/tabs issues
      staging: rtl8821ae: Fix indetentation of switch case statements
      staging: rtl8821ae: don't initialise statics to 0 or NULL in halbtc8192e2ant.c

Mark Hounschell (41):
      staging: dgap: Remove some unused code in dgap.c
      staging: dgap: Remove some unneeded comments
      staging: dgap: fix some whitespace warnings in dgap.h
      staging: dgap: Fix several 80+ line warnings in dgap.h
      staging: dgap: remove some unused code in dgap.h
      staging: dgap: Removes excessive empty lines from dgap.h
      staging: dgap: Only read config file dgap.conf once
      staging: dgap: Macros with complex values should be enclosed in parenthesis
      staging: dgap: remove volatiles from dgap.h
      staging: dgap: fix/change a pr_info
      staging: dgap: rename and fixup dgap_wait_for_xxx functions
      staging: dgap: remove uchar typedef and replace use with u8
      staging: dgap: Add Mark Hounschell to maintainers list for dgap
      staging: dgap: Add Mark Hounschell to maintainers list for dgap
      staging: dgap: Fix how we insure config data is a string
      staging: dgap: Fix BUG in processing config file
      staging: dgap: fix sparse warnings for re_map_membase and re_map_port
      staging: dgap: fix sparse warnings for the entire bs_t structure
      staging: dgap: fix sparse warnings for the entire cm_t structure
      staging: dgap: fix a few misc sparse warnings
      staging: dgap: fix sparse warning about dgap_poll_lock
      staging: dgap: fix sparse warnings Using plain integer as NULL pointer
      staging: dgap: fix a few more sparse warnings
      staging: dgap: check unchecked return values
      staging: dgap: remove two unnecessary conditionals
      staging: dgap: Add check for MAXBOARDS in .probe (dgap_init_one)
      staging: dgap: refactor ugly dgap_init_one function
      staging: dgap: Get rid of CamelCase
      staging: dgap: fix smatch warn: unsigned var is never less than zero
      staging: dgap: Remove dead sniff buffer code
      staging: dgap: Remove erroneous comment
      staging: dgap: Remove unnecessary test on count
      staging: dgap: replace dgap_savestring function with kstrdup
      staging: dgap: Remove unnecessary initialization of variables in declarations
      staging: dgap: Remove more extra white space and tabs
      staging: dgap: Replace double negative conditionals
      staging: dgap: Simplify get_altpin and get_useintr functions
      staging: dgap: Change GFP_ATOMICs to GFP_KERNEL
      staging: dgap: misc cleanup of NULL conditionals
      staging: dgap: Simplify dgap_find_config
      staging: dgap: Use EIO instead of ENXIO

Martin Kepplinger (4):
      staging: rtl8187se: fix pointer and return statement's syntax
      staging: vt6656: make spin_lock_irq() human readable
      staging: dgnc: use dev_err() instead of printk()
      staging: winbond: use dev_err() instead of printk()

Masanari Iida (8):
      staging: lustre: Fix typo in lustre/include
      staging: iio: Fix typo in iio
      staging: unisys: Fix format string mismatch in virthba.c
      staging: unisys: Fix typo in comment and printk
      staging: rtl8192e: A word in printk is split into 2 lines
      staging: rtl8192e: Fix typo in rtl8192e
      staging: iio: Fix format string mismatch in ad7280a.c
      staging: ft1000: Convert printk to dev_err in ft1000_cs.c

Masaru Nomura (11):
      staging: unisys: visorutil: Add a blank line
      staging: dgnc: Put else statements on the right line
      staging: dgnc: dgnc_neo: Clean up if statement
      staging: dgnc: Remove extra curly braces
      staging: lustre: socklnd: Remove unnecessary () from return statement
      staging: lustre: socklnd: Add a required space
      staging: lustre: socklnd: Fix indenting
      staging: lustre: socklnd: Remove unnecessary line continuation
      staging: lustre: socklnd: Remove unnecessary return brackets
      staging: dgnc: dgnc_tty: Add a required space
      staging: dgnc: dgnc_tty: Remove a prohibited space

Matei Oprea (1):
      staging: cxt1e1: hwprobe: fix incorrect type in assignment

Mathieu Maret (1):
      staging: binder: add __user annotation in binder.c

Matt Ezell (1):
      staging/lustre/lnet: Dropped messages are not accounted correctly

Matt Ranostay (2):
      iio:as3935: Add DT binding docs for AS3935 driver
      iio: Add AS3935 lightning sensor support

Matthias Beyer (31):
      Staging: bcm: Fixed line lengths
      Staging: bcm: Outsourced cmd handling to function
      Staging: bcm: Outsourced IsFlash2x() handling
      Staging: bcm: Indentation fixes in Bcmchar.c
      Staging: bcm: Shortened code by using variable
      Staging: bcm: Shortened lines in OverrideServiceFlowParams()
      Staging: bcm: Shortened lines in get_dsx_sf_data_to_application()
      Staging: bcm: Outsourced restoring of endianess for ip adresses
      Staging: bcm: Simplified by using variables
      Staging: bcm: Shortened line
      Staging: bcm: Shortenend lines in GetNextTargetBufferLocation()
      Staging: bcm: Shortened lines in SetupTargetDsxBuffers()
      Staging: bcm: Shortened lines in RestoreCmControlResponseMessage()
      Staging: bcm: Shortened lines in StoreCmControlResponseMessage()
      Staging: bcm: Shortened lines in StoreSFParam()
      Staging: bcm: Shortened lines in RestoreSFParam()
      Staging: bcm: Replaced long member-accessing
      Staging: bcm: Shortened some lines in DumpCmControlPacker()
      Staging: bcm: Outsourced PHS rule applying
      Staging: bcm: Replaced struct member accessing with variable
      Staging: bcm: Shortened lines in CopyToAdapter()
      Staging: bcm: Shortened line in DeleteAllClassifiersForSF()
      Staging: bcm: Shortened lines in DeleteClassifierRuleFromSF()
      Staging: bcm: Replaced member accessing with variable
      Staging: bcm: Shortened lines in CopyClassifierRuleToSF()
      Staging: bcm: Shortened lines and replaced member accessing in CopyIpAddrToClassifier()
      Staging: bcm: Replaced member accessing by variable
      Staging: bcm: Shortened lines in CopyIpAddrToClassifier()
      Staging: bcm: Shortened lines in deleteSFBySfid()
      Staging: bcm: Shortened lines in SearchClsid()
      Staging: bcm: Shortened prototype for GetNextTargetBufferLocation()

Michael Welling (13):
      Staging:iio:tsl2583 Removes unwanted space before semicolon
      Staging:iio:tsl2583 Remove quoted string split across lines warnings
      Staging:iio:tsl2583 Switch from msleep to usleep range per timers-howto.txt
      Staging: iio: Removes unwanted space before semicolon
      Staging: iio: Remove quoted string split across lines warnings
      Staging: iio: Switch from msleep to usleep range per timers-howto.txt
      STAGING: cxt1e1: Remove sparse warnings
      STAGING: cxt1e1: Indentation fixes
      STAGING: cxt1e1: Fixes comment blocks
      STAGING: cxt1e1: Remove volatile variable
      STAGING: cxt1e1: Formatting fixes checkpatch issues
      STAGING: cxt1e1: More formatting fixes
      STAGING: cxt1e1: Remove curly braces

Michalis Pappas (10):
      staging: gdm72xx: Remove unnecessary extern declarations from header files
      staging: gdm72xx: Replace comparisons on jiffies values with wrap-safe functions
      staging: gdm72xx: Modify a struct allocation to match coding standards
      staging: gdm72xx: Move logical continuation to previous line to conform to coding style
      staging: gdm72xx: Fix some camel-case variables
      staging: gdm72xx: Fix braces to conform with coding style
      staging: gdm72xx: Removed commented-out code
      staging: gdm72xx: Whitespace fixes to conform to coding standards
      staging: gdm72xx: Indentation and other whitespace fixes
      staging: gdm72xx: Remove task from TODO list

Michele CURTI (1):
      staging/winbond: fix a style error

Michele Curti (1):
      staging: comedi: declare das6402_boards as static

Micky Ching (1):
      staging: rts5208: fix static checker warnings

Mike Sampson (1):
      Staging: lustre: mark a variable static in workitem.c

Mitchel Humpherys (1):
      staging: ion: WARN when the handle kmap_cnt is going to wrap around

Monam Agarwal (2):
      drivers/staging: Use RCU_INIT_POINTER(x, NULL) in fwserial/fwserial.c
      Staging: slicoss: Fix smatch warning in slicoss.c

Naveen Krishna Ch (1):
      iio: exynos_adc: rearrange clk and regulator enable/disable calls

Naveen Krishna Chatradhi (3):
      iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
      iio: exynos_adc: do a soft reset in case of timeout
      iio: exynos_adc: do a reinit_completion before the conversion

Neil Armstrong (4):
      staging: vt6656: fix bad symbol declaration
      Staging: silicom: fix dangerous if condition in bpctl_mod.c
      staging: wlan-ng: fix bad symbol declaration
      staging: rts5139: fix bad symbol declaration

Nick Kralevich (1):
      goldfish_nand.c: remove length restrictions

Nicolas Del Piano (1):
      Staging: vt6655: tether: fixed a brace coding style issue

Nicolas Joseph (1):
      staging/olpc_dcon: fix checkpatch warnings

Niu Yawei (1):
      staging/lustre/clio: clear nowait flag agl lock re-enqueue

Niv Yehezkel (1):
      staging: android: describe use of memory barrier on sync.c

Octavian Purdila (3):
      goldfish: add support for 64bit to the virtual bus
      goldfish: bus: fix warnings for 32bit builds
      goldfish: pipe: fix warnings for 32bit builds

Oleg Drokin (5):
      staging/lustre: Fix unsafe userspace access in many proc files
      staging/lustre/llite: Fix a compile warning.
      staging/lustre: Replace jobid acquiring with per node setting
      staging/lustre/lnet: Drop useless LASSERT in ksocknal_select_ips
      staging/lustre/lnet: fix potential null pointer dereference

Pascal COMBES (4):
      Staging: crystalhd: Fix alignement in crystalhd_lnx.c
      Staging: crystalhd: Removed cast in crystalhd_lnx.c
      Staging: crystalhd: Improve kzalloc calls in crystalhd_lnx.c
      Staging: dgap: Fixed iomem accesses in dgap.c

Patrick Farrell (1):
      staging/lustre/ptlrpc: Fix assertion failure of null_alloc_rs()

Paul Bolle (7):
      staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP
      staging: tidspbridge: check for CONFIG_SND_OMAP_SOC_MCBSP
      staging: rtl8192u: remove checks for CONFIG_RTL8192_PM
      staging: lirc: remove checks for CONFIG_LIRC_SERIAL_NSLU2
      staging: ctx1e1: remove checks for three macros
      staging: comedi: remove check for CONFIG_KMOD
      rtl8192ee: btcoexist: remove undefined Kconfig macros

Paul Davies C (2):
      staging: octeon-usb: Add blank line after all declarations in octeon-hcd.c
      staging: octeon-usb: Fix lines with more than 80 chars in octeon-hcd.c

Paul McQuade (3):
      Staging:rtl8192e:rtl819x_BAProc:Remove whitespaces
      Staging:ft1000_debug.c:Renaming __FUNCTION__
      Staging:Octeon-usb:octeon-hcd.c return value

Pawel Lebioda (2):
      Staging: usbip: missing a blank lines after declarations
      staging: usbip: Fix bad fuction definitions in usbip

Peng Tao (2):
      staging/lustre/hsm: count NULL terminator in hai_zero/hal_size
      staging/lustre: remove Peng Tao from Lustre contact list

Peter Meerwald (10):
      iio:magnetometer:mag3110: Fix initialization of ctrl_reg1
      iio:magnetometer:mag3110: Enable user offset calibration
      iio: Add Freescale MPL115A2 pressure / temperature sensor driver
      iio: Add TEMP_AMBIENT and TEMP_OBJECT channel modifiers
      iio: Add ABI documentation for object and ambient modifiers
      iio: Add Melexis mlx90614 contact-less infrared temperature sensor driver
      iio: Add intensity including ir and both modifiers to ABI documentation ex-post
      iio: Add ABI documentation for illuminance
      iio: Fix spelling of illuminance in gp2ap020a00f driver
      iio: Add Freescale MMA8452Q 3-axis accelerometer driver

Peter Senna Tschudin (7):
      staging: et131x: Remove useless return variables
      staging: ozwpan: Remove useless return variables
      staging: vt6655: Remove useless return variables
      staging: wlags49_h2: wl_priv: Remove useless return variables
      staging: ft1000: Remove useless return variables
      staging: r8712u: Remove useless return variables
      drivers/staging: Remove useless return variables

Philipp Zabel (9):
      imx-drm: imx-drm-core: Fix imx_drm_encoder_get_mux_id
      imx-drm: ipu-common: add ipu_map_irq to request non-IDMAC interrupts
      imx-drm: ipu-common: add helpers to check for a busy IDMAC channel and to busywait for an interrupt
      imx-drm: ipu-dmfc: wait for FIFOs to run empty before disabling
      imx-drm: ipu-dc: wait for DC_FC_1 / DP_SF_END interrupt
      imx-drm: ipu-dp: split disabling the DP foreground channel from disabling the DP module
      imx-drm: imx-dp: when disabling the DP foreground channel, wait until the DP background channel is finished before disabling the IDMAC channel
      imx-drm: ipuv3-crtc: change display enable/disable order
      imx-drm: ipu-dc: disable DC module when not in use

Raghavendra Ganiga (4):
      staging: comedi: fix coding style issues in comedi_fops.c
      Staging: comedi: fixed warnings reported by checkpatch tool on comedi_test.c file
      Staging: comedi: fixed warning shown by checkpatch tool on cb_das16_cs.c file
      staging: comedi: removing warnings reported by checkpatch tool on cb_pcimdas.c

Remi Pommarel (1):
      Staging: rtl8188eu: Fixed prohibited spaces after open '('

Richard Leitner (1):
      staging: comedi: adl_pci9118: fix whitespace issues

Rickard Strandqvist (5):
      staging: lustre: lustre: lov: lov_obd.c: Fix for possible null pointer dereference
      staging: lustre: lustre: ptlrpc: sec_config.c: Fix for possible null pointer dereference
      staging: rtl8192u: r8192U_core.c: Fix to remove null pointer checks that could never happen
      staging: rtl8188eu: os_dep: usb_intf.c: Fix to remove null pointer checks that could never happen
      staging: rtl8712: usb_intf.c: Fix for possible null pointer dereference

Robin Schroer (1):
      Staging/frontier/tranzport: coding style fixes

Rocco Folino (1):
      staging: gs_fpgaboot: Fixed code style issues

Rui Miguel Silva (2):
      staging: keucr: fix sparse warning
      staging: rtl8192u: fix checkpatch braces warning

Rupesh Gujare (1):
      staging: ozwpan: Change Maintainer

Russell King (1):
      imx-drm: fix hdmi hotplug detection initial state

Rusty Russell (1):
      drivers/staging/speakup/: avoid world-writable sysfs files.

Ryan Haasken (2):
      staging/lustre/llite: Do not rate limit dirty page discard warning
      staging/lustre: Always clamp cdls_delay between min and max

Sachin Kamat (30):
      staging: rtl8192ee: Fix build error
      staging: rtl8192ee: Remove unneeded version.h inclusion
      staging: rtl8723au: Remove unneeded version.h inclusion in osdep_service.h
      staging: rtl8723au: Remove unneeded version.h inclusion in os_intfs.c
      staging: rtl8723au: Remove unneeded version.h inclusion in ioctl_cfg80211.c
      staging: rtl8821ae: base.c: Remove version specific code
      staging: rtl8821ae: cam.c: Remove version specific code
      staging: rtl8821ae: compat.h: Remove version specific code
      staging: rtl8821ae: core.c: Remove version specific code
      staging: rtl8821ae: debug.c: Remove version specific code
      staging: rtl8821ae: efuse.c: Remove version specific code
      staging: rtl8821ae: pci.c: Remove version specific code
      staging: rtl8821ae: pci.h: Remove version specific code
      staging: rtl8821ae: ps.c: Remove version specific code
      staging: rtl8821ae: rc.c: Remove version specific code
      staging: rtl8821ae: regd.c: Remove version specific code
      staging: rtl8821ae: regd.h: Remove version specific code
      staging: rtl8821ae: sw.c: Remove version specific code
      staging: rtl8821ae: trx.c: Remove version specific code
      staging: rtl8821ae: trx.h: Remove version specific code
      staging: rtl8821ae: stats.c: Remove version specific code
      staging: rtl8188eu: Remove unneeded version.h inclusion
      staging: rtl8723au: Remove duplicate inclusion of wlan_bssdef.h
      staging: rtl8723au: Remove redundant casting in rtw_mlme.c
      staging: rtl8723au: Remove redundant casting in rtw_recv.c
      staging: rtl8723au: Remove redundant casting in rtw_sta_mgt.c
      staging: rtl8723au: Remove redundant casting in rtw_wlan_util.c
      staging: rtl8723au: Remove redundant casting in rtw_xmit.c
      staging: rtl8723au: Remove redundant casting in rtl8723a_hal_init.c
      staging: rtl8723au: Remove redundant casting in usb_ops_linux.c

Sarath Lakshman (1):
      staging: nokia_h4p: Fix a coding style problem

Sasha Levin (1):
      Staging: speakup: don't die if accessing sysfs without synth

Sebastian Reichel (2):
      iio: documentation: Add ABI documentation for *_mean_raw
      iio: inkern: add iio_read_channel_average_raw

SeongJae Park (1):
      staging: silicom: remove BP_PROC_SUPPORT dependant code

Seunghun Lee (2):
      staging: android: uapi: fix coding style
      staging: android: fix missing a blank line after declarations

Sheetal Tigadoli (1):
      staging: comedi: Fixes Coding Style Warning in file das08.h

Sherif Shehab Aldin (10):
      driver: staging: wlan-ng: Fixed Breaking long lines and strings style rule
      driver: staging: wlan-ng: Removed unnecessary typedefs from hfa384x_usb.c
      driver: staging: wlan-ng: switched to pr_warn
      driver: staging: wlan-ng: Setting character pointers as const
      driver: staging: wlan-ng: Removed Unnecessary space after function pointer name
      driver: staging: wlan-ng: Fixed Alignment to match open parenthesis
      driver: staging: wlan-ng: Fixed white spaces issues
      driver: staging: wlan-ng: Removed multiple assignments
      driver: staging: wlan-ng: Removed #if 0 lines from hfa384x_usb.c
      driver: staging: wlan-ng: Removed unnecessary spaces after cast from hfa384x_usb.c

Silvio Fricke (2):
      staging: vt6655: removed incorrect casting in wpactl.c
      staging: vt6655: removed incorrect casting in ioctl.c

Simon Boulay (1):
      staging/mt29f_spinand: coding style fixes

Son P. Nguyen (1):
      Staging: dgnc: dgnc_driver: fixed incorrect braces

Srinivas Pandruvada (26):
      iio: ak8975 : Add AK8963 compatibility mode support
      iio: ak8975: Added ACPI enumeration
      iio: imu: inv_mpu6050: Add compatibity with MPU6500
      devres: introduce API "devm_kmemdup
      IIO: core: Introduce read_raw_multi
      IIO: core: Modify scan element type
      IIO: core: Add quaternion modifier
      iio: hid-sensors: Added device rotation support
      iio: Added ABI description for quaternion
      iio: ak8975: Fix issue with the name
      iio: hid-sensors: Convert units and exponent
      iio: hid-sensors: Add api to get poll value
      iio: hid-sensors: Accelerometer 3D: adjust scale and offset
      iio: hid-sensors: Gyro 3D : adjust scale and offset
      iio: hid-sensors: ALS: adjust scale and offset
      iio: hid-sensors: Compass 3D: adjust scale and offset
      iio: hid-sensors: Inclinometer 3D: adjust scale and offset
      iio: hid-sensors: Pressure: adjust scale and offset
      iio: hid-sensors: Add API to power on/off
      iio: hid-sensors: Accelerometer 3D: Raw read support
      iio: hid-sensors: Gyro 3D: Raw read support
      iio: hid-sensors: ALS: Raw read support
      iio: hid-sensors: Proximity: Raw read support
      iio: hid-sensors: Compass 3D: Raw read support
      iio: hid-sensors: Inclinometer 3D: Raw read support
      iio: hid-sensors: Pressure: Raw read support

Stephen Boyd (1):
      staging/mt29f_spinand: Terminate of match table

Swapnil Pimpale (1):
      staging/lustre/osc: Update inode timestamp for lockless IO as well

Tair Rzayev (2):
      staging: keucr: smilmain.c: cosmetic updates
      staging: android: binder.c: Use more appropriate functions for euid retrieval

Thomas Tanaka (1):
      staging: rts5139: fixed coding style

Thomas Vegas (4):
      staging: cxt1e1: Avoid using 0 instead of NULL
      staging: serqt_usb2: Remove useless variable
      staging: serqt_usb2: Add blank line after declaration
      staging: serqt_usb2: Clean up initializations of variables

Tobias Klauser (3):
      staging: vt6656: Remove unnecesssary NULL check
      staging: vt6656: Use proper target pointer in memcpy()
      staging/lustre/llite: Remove unnecessary check for NULL before iput()

Toby Smith (3):
      staging: netlogic: fix missing a blank line after declarations
      staging: lustre: fix sparse warning "unexpected unlock"
      staging: lustre: fix sparse warning "should it be static"

Toralf Förster (1):
      fix format string missmatch in staging/iio/Documentation/iio_utils.h

Tuomas Tynkkynen (1):
      staging: lirc: Fix sparse warnings

Vitaly Osipov (8):
      staging:lustre: use gfp_t instead of int
      staging: lustre: check for integer overflow
      staging: dgnc: redundant NULL checks before kfree()
      staging: lustre: return -EFAULT instead of bytes remaining
      staging: wlan-ng: use netdev_() instead of printk()
      staging: rtl8712: remove _malloc()
      staging: rtl8712: fix kmalloc parameters
      staging: rtl8712: return -ENOMEM instead of -1

Vitor Braga (1):
      staging: xgifb coding style cleanup

Yves Deweerdt (2):
      staging: comedi: comedy_fops.c: fix line over 80, characters warnings
      staging: comedi: drivers.c: Fix missing a blank line, after declarations warning

Zi Shen Lim (1):
      staging/lustre: fix sparse warnings in o2iblnd_cb.c

huanqi chi (1):
      staging rtl8188eu: add a blank line after declarations

navin patidar (105):
      staging: rtl8188eu: Remove empty header file
      staging: rtl8188eu: Remove rtw_led_blink_cmd() function.
      staging: rtl8188eu: Remove _ReadLEDSetting() function.
      staging: rtl8188eu: Remove _InitHWLed() function.
      staging: rtl8188eu: Simplify led blinking strategy code.
      staging: rtl8188eu: Remove enum LED_STRATEGY_871x .
      staging: rtl8188eu: refactor led related structures.
      staging: rtl8188eu: Remove unused macros.
      staging: rtl8188eu: Remove unused enum LED_STATE_871x members.
      staging: rtl8188eu: Remove unused enum LED_CTL_MODE members.
      staging: rtl8188eu: Remove debugging messages from usb_dvobj_init()
      staging: rtl8188eu: Use USB subsystem functions to check endpoint type
      staging: rtl8188eu: Remove function rtw_dequeue_recvbuf()
      staging: rtl8188eu: Remove function rtw_enqueue_recvbuf_to_head()
      staging: rtl8188eu: Remove function rtw_enqueue_recvbuf()
      staging: rtl8188eu: Remove 'struct list_head list' from struct recv_buf
      staging: rtl8188eu: Remove 'spinlock_t recvbuf_lock' from struct recv_buf
      staging: rtl8188eu: Remove 'dma_addr_t dma_transfer_addr' from struct recv_buf
      staging: rtl8188eu: Remove 'int transfer_len' from struct recv_buf
      staging: rtl8188eu: Remove pdata, phead, ptail and pend from struct recv_buf
      staging: rtl8188eu: Remove 'irp_pending' from struct recv_buf
      staging: rtl8188eu: Remove 'pallocated_buf' from struct recv_buf
      staging: rtl8188eu: Remove 'alloc_sz' from struct recv_buf
      staging: rtl8188eu: Remove 'u32 len' from struct recv_buf
      staging: rtl8188eu: Remove 'u32 ref_cnt' from struct recv_buf
      staging: rtl8188eu: Remove rtl8188eu_init_recvbuf() function
      staging: rtl8188eu: Remove 'u8 *pbuf' from struct recv_buf
      staging: rtl8188eu: Remove 'semaphore allrxreturnevt' from struct recv_priv
      staging: rtl8188eu: Remove unused member variables of struct recv_priv
      staging: rtl8188eu: Remove 'spinlock_t lock' from struct recv_priv
      staging: rtl8188eu: Remove struct zero_bulkout_context
      staging: rtl8188eu: Remove function rtw_os_recv_resource_init()
      staging: rtl8188eu: Remove function rtw_os_recv_resource_free()
      staging: rtl8188eu: Remove function rtw_hostapd_mlme_rx()
      staging: rtl8188eu: Remove function rtw_os_recvbuf_resource_free()
      staging: rtl8188eu: Remove unused inline function recvframe_push()
      staging: rtl8188eu: Remove unused inline function get_rx_status()
      staging: rtl8188eu: Remove 'void *precvbuf' from struct recv_frame
      staging: rtl8188eu: Remove 'int frame_tag' from struct recv_frame
      staging: rtl8188eu: Remove 'u8 fragcnt' from struct recv_frame
      staging: rtl8188eu: Remove function with empty definition _InitBeaconMaxError().
      staging: rtl8188eu: Remove function with empty definition _InitOperationMode()
      staging: rtl8188eu: Remove function with empty definition _ps_open_RF()
      staging: rtl8188eu: Remove unused function _ps_close_RF()
      staging:rtl8188eu:Remove funtion Hal_CustomizeByCustomerID_8188EU()
      staging: rtl8188eu: Remove unused function rtl8188e_PHY_ConfigRFWithParaFile()
      staging: rtl8188eu: Remove unused function rtl8192c_PHY_GetHWRegOriginalValue()
      staging: rtl8188eu: Remove unused function PHY_UpdateTxPowerDbm8188E()
      staging:rtl8188eu: Remove unused function phy_DbmToTxPwrIdx()
      staging: rtl8188eu: Remove unused funtion PHY_GetTxPowerLevel8188E()
      staging: rtl8188eu: Remove unused funtion phy_TxPwrIdxToDbm()
      staging: rtl8188eu: Remove unused funtion PHY_ScanOperationBackup8188E()
      staging: rtl8188eu: Remove unused structure rf_shadow
      staging: rtl8188eu: Remove unused function rtl8188e_RF_ChangeTxPath()
      staging: rtl8188eu: Remove unused function odm_DIGbyRSSI_LPS()
      staging: rtl8188eu: Remove function odm_DynamicBBPowerSaving()
      staging: rtl8188eu: Remove unused function odm_DynamicBBPowerSavingInit()
      staging:rtl8188eu: Remove unused function iodm_1R_CCA()
      staging: rtl8188eu: Remove unused function odm_RefreshRateAdaptiveMaskMP()
      staging: rtl8188eu: Remove unused function odm_RefreshRateAdaptiveMaskAPADSL()
      staging: rtl8188eu: Remove unused funtion odm_DynamicTxPowerNIC()
      staging: rtl8188eu: Remove unused function odm_SwAntDivChkAntSwitchCallback()
      staging: rtl8188eu: Remove unused function ConvertTo_dB()
      staging: rtl8188eu: Remove function with empty defination ODM_CheckPowerStatus()
      staging: rtl8188eu: Remove unused function DM_DIG_LowerBound_88E()
      staging: rtl8188eu: Remove unused function ODM_DynamicPrimaryCCA_DupRTS()
      staging: rtl8188eu:Remove function with empty defination odm_DynamicPrimaryCCA()
      staging: rtl8188eu: Remove unused function rtw_interface_ps_func()
      staging: rtl8188eu: Remove unused function rtw_hal_intf_ps_func()
      staging: rtl8188eu: Remove unused function pointer ->interface_ps_func
      staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()
      staging: rtl8188eu: Remove unused function ODM_MacStatusQuery()
      staging: rtl8188eu: Remove unused function odm_Init_RSSIForDM()
      staging: rtl8188eu: Remove function with empty defination dm_CheckStatistics()
      staging: rtl8188eu: Remove function rtw_hal_dm_deinit()
      staging: rtl8188eu: Remove unused function pointer ->dm_init
      staging: rtl8188eu: Remove unused function rtl8188e_deinit_dm_priv()
      staging: rtl8188eu: remove unused header inclusion from rtw_mp.c
      staging: rtl8188eu: Remove unused macros and enum defined in odm_types.h
      staging: rtl8188eu: Remove unused structure "rtl8192cd_priv"
      staging: rtl8188eu: Remove unused macros in odm_interface.h
      staging: rtl8188eu: Remove unused function pointer declaration.
      staging: rtl8188eu: Remove unused function declaration.
      staging: rtl8188eu: Use "ODM_REG_CCK_CCA_11N" in ODM_Write_CCK_CCA_Thres()
      staging: rtl8188eu: Use ODM_REG_IGI_A_11N and ODM_BIT_IGI_11N in odm_DIGInit()
      staging: rtl8188eu: Remove unnecessary debugging message from ODM_Write_DIG()
      staging: rtl8188eu: Use ODM_REG_IGI_A_11N and ODM_BIT_IGI_11N in ODM_Write_DIG()
      staging: rtl8188eu: Remove unused macros defined in odm_interface.h
      staging: rtl8188eu: Remove unused function declaration.
      staging: rtl8188eu: Remove unused enum odm_h2c_cmd.
      staging: rtl8188eu: Remove empty file odm_interface.h
      staging: rtl8188eu:Remove function rtw_set_tx_chksum_offload()
      staging:rtl8188eu:Remove code specific to kernel version < 2.6.35
      staging: rtl8188eu:Assign RTL8188E to padapter->chip_type directly
      staging: rtl8188eu:Remove unused function chip_by_usb_id()
      staging: rtl8188eu:Remove unused function rtl8188eu_set_hw_type()
      staging: rtl8188eu:Drop rtw_handle_dualmac() function calls in rtw_usb_if1_init()
      staging: rtl8188eu:Drop rtw_handle_dualmac() function calls in rtw_usb_if1_deinit()
      staging: rtl8188eu:Remove unused function rtw_handle_dualmac()
      staging: rtl8188eu:Remove unused variable struct adapter *pbuddy_padapter
      staging: rtl8188eu:Remove inline function rtw_netif_wake_queue()
      staging: rtl8188eu:Remove inline function rtw_netif_start_queue()
      staging: rtl8188eu:Remove inline function rtw_netif_stop_queue()
      staging: rtl8188eu:Remove unused inline function res_to_status()
      staging: rtl8188eu:Remove unused macros defined in osdep_service.h

wang di (1):
      staging/lustre/mdc: use cl_max_mds_md to pack getattr RPC

 Documentation/ABI/testing/sysfs-bus-iio            |   46 +-
 .../ABI/testing/sysfs-bus-iio-proximity-as3935     |   16 +
 .../devicetree/bindings/iio/proximity/as3935.txt   |   28 +
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    1 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/driver-model/devres.txt              |    3 +
 MAINTAINERS                                        |   11 +-
 arch/x86/Kconfig                                   |    1 -
 drivers/base/devres.c                              |   97 +
 drivers/iio/Kconfig                                |    2 +
 drivers/iio/Makefile                               |    1 +
 drivers/iio/accel/Kconfig                          |   12 +
 drivers/iio/accel/Makefile                         |    1 +
 drivers/iio/accel/hid-sensor-accel-3d.c            |   45 +-
 drivers/iio/accel/mma8452.c                        |  439 ++
 drivers/iio/accel/st_accel_core.c                  |    7 +
 drivers/iio/adc/Kconfig                            |   21 +-
 drivers/iio/adc/Makefile                           |    1 +
 .../iio/adc/ad799x_core.c => iio/adc/ad799x.c}     |  160 +-
 drivers/iio/adc/exynos_adc.c                       |  131 +-
 drivers/iio/adc/max1363.c                          |   16 +-
 drivers/iio/adc/mcp3422.c                          |   33 +-
 .../iio/common/hid-sensors/hid-sensor-attributes.c |  151 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   17 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.h    |    1 +
 drivers/iio/common/st_sensors/st_sensors_core.c    |   37 +
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |   45 +-
 drivers/iio/gyro/itg3200_core.c                    |    2 -
 drivers/iio/gyro/st_gyro_core.c                    |    7 +
 drivers/iio/iio_core.h                             |    2 +-
 drivers/iio/imu/inv_mpu6050/Kconfig                |    2 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |    1 +
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |    1 +
 drivers/iio/industrialio-buffer.c                  |   41 +-
 drivers/iio/industrialio-core.c                    |   74 +-
 drivers/iio/industrialio-event.c                   |   10 +-
 drivers/iio/inkern.c                               |   34 +-
 drivers/iio/light/gp2ap020a00f.c                   |    8 +-
 drivers/iio/light/hid-sensor-als.c                 |   48 +-
 drivers/iio/light/hid-sensor-prox.c                |   25 +-
 drivers/iio/magnetometer/Kconfig                   |    3 +-
 drivers/iio/magnetometer/ak8975.c                  |   71 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |   40 +-
 drivers/iio/magnetometer/mag3110.c                 |   19 +-
 drivers/iio/magnetometer/st_magn_core.c            |    7 +
 drivers/iio/orientation/Kconfig                    |   12 +
 drivers/iio/orientation/Makefile                   |    1 +
 drivers/iio/orientation/hid-sensor-incl-3d.c       |   37 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |  346 +
 drivers/iio/pressure/Kconfig                       |   10 +
 drivers/iio/pressure/Makefile                      |    1 +
 drivers/iio/pressure/hid-sensor-press.c            |   41 +-
 drivers/iio/pressure/mpl115.c                      |  211 +
 drivers/iio/pressure/st_pressure_core.c            |   42 +-
 drivers/iio/proximity/Kconfig                      |   19 +
 drivers/iio/proximity/Makefile                     |    6 +
 drivers/iio/proximity/as3935.c                     |  456 ++
 drivers/iio/temperature/Kconfig                    |   10 +
 drivers/iio/temperature/Makefile                   |    1 +
 drivers/iio/temperature/mlx90614.c                 |  150 +
 drivers/platform/goldfish/goldfish_pipe.c          |   34 +-
 drivers/platform/goldfish/pdev_bus.c               |   11 +-
 drivers/staging/Kconfig                            |    8 +-
 drivers/staging/Makefile                           |    4 +-
 drivers/staging/android/alarm-dev.c                |    1 +
 drivers/staging/android/binder.c                   |   55 +-
 drivers/staging/android/ion/ion.c                  |   14 +
 drivers/staging/android/ion/ion_carveout_heap.c    |    2 +-
 drivers/staging/android/ion/ion_chunk_heap.c       |    2 +-
 drivers/staging/android/ion/ion_heap.c             |    2 +
 drivers/staging/android/ion/ion_page_pool.c        |   49 +-
 drivers/staging/android/ion/ion_priv.h             |    3 +-
 drivers/staging/android/ion/ion_system_heap.c      |   68 +-
 drivers/staging/android/logger.c                   |    3 +
 drivers/staging/android/ram_console.h              |   22 -
 drivers/staging/android/sw_sync.c                  |    2 +
 drivers/staging/android/sync.c                     |   12 +
 drivers/staging/android/timed_gpio.c               |    5 +-
 drivers/staging/android/uapi/ion.h                 |   12 +-
 drivers/staging/bcm/Bcmchar.c                      |  447 +-
 drivers/staging/bcm/CmHost.c                       | 1231 +--
 drivers/staging/bcm/InterfaceDld.c                 |    6 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |    3 +-
 drivers/staging/bcm/InterfaceMisc.h                |   12 +-
 drivers/staging/bcm/PHSModule.c                    |    9 +-
 drivers/staging/bcm/Qos.c                          |  203 +-
 drivers/staging/bcm/Transmit.c                     |   19 +-
 drivers/staging/bcm/hostmibs.c                     |   51 +-
 drivers/staging/comedi/Kconfig                     |   22 +-
 drivers/staging/comedi/TODO                        |    1 -
 drivers/staging/comedi/comedi_buf.c                |   66 +-
 drivers/staging/comedi/comedi_fops.c               |   93 +-
 drivers/staging/comedi/comedi_internal.h           |    6 +-
 drivers/staging/comedi/comedidev.h                 |   21 +-
 drivers/staging/comedi/drivers.c                   |    2 +-
 drivers/staging/comedi/drivers/8253.h              |  109 +-
 drivers/staging/comedi/drivers/8255.c              |    5 +-
 drivers/staging/comedi/drivers/8255.h              |    4 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |   10 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  130 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  169 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |   50 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    6 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c    |    7 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  180 +-
 drivers/staging/comedi/drivers/addi_apci_2032.c    |   26 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |    2 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   55 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  338 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |  433 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |  509 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |   56 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |    5 +-
 drivers/staging/comedi/drivers/amplc_pci224.c      |  325 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |  388 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    1 +
 drivers/staging/comedi/drivers/cb_pcidas.c         |  174 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |  144 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   11 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |   22 +-
 drivers/staging/comedi/drivers/comedi_parport.c    |    5 +-
 drivers/staging/comedi/drivers/comedi_test.c       |   28 +-
 drivers/staging/comedi/drivers/das08.h             |    4 +-
 drivers/staging/comedi/drivers/das16.c             |   93 +-
 drivers/staging/comedi/drivers/das16m1.c           |  106 +-
 drivers/staging/comedi/drivers/das1800.c           |  188 +-
 drivers/staging/comedi/drivers/das6402.c           |    2 +-
 drivers/staging/comedi/drivers/das800.c            |  117 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   88 +-
 drivers/staging/comedi/drivers/dt2801.c            |    2 +-
 drivers/staging/comedi/drivers/dt2814.c            |    9 +-
 drivers/staging/comedi/drivers/dt282x.c            |   28 +-
 drivers/staging/comedi/drivers/dt3000.c            |   31 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          |   36 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |    1 +
 drivers/staging/comedi/drivers/me4000.c            |  100 +-
 drivers/staging/comedi/drivers/mite.c              |   38 +-
 drivers/staging/comedi/drivers/mite.h              |    6 +-
 drivers/staging/comedi/drivers/ni_6527.c           |    5 +-
 drivers/staging/comedi/drivers/ni_65xx.c           |    6 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    6 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   89 +-
 drivers/staging/comedi/drivers/ni_at_ao.c          |    8 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |    2 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |  189 +-
 drivers/staging/comedi/drivers/ni_labpc_isadma.c   |    7 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |  142 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   28 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |   10 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c         |   42 +-
 drivers/staging/comedi/drivers/pcl711.c            |   35 +-
 drivers/staging/comedi/drivers/pcl726.c            |    5 +-
 drivers/staging/comedi/drivers/pcl730.c            |   36 +
 drivers/staging/comedi/drivers/pcl812.c            |   28 +-
 drivers/staging/comedi/drivers/pcl816.c            |   17 +-
 drivers/staging/comedi/drivers/pcl818.c            |   19 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   61 +-
 drivers/staging/comedi/drivers/pcmuio.c            |   32 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |   20 +-
 drivers/staging/comedi/drivers/rtd520.c            |   42 +-
 drivers/staging/comedi/drivers/s626.c              |   92 +-
 drivers/staging/comedi/drivers/skel.c              |   29 +-
 drivers/staging/comedi/drivers/usbdux.c            |   58 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |   40 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   40 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |   29 +-
 drivers/staging/cxt1e1/functions.c                 |   18 -
 drivers/staging/cxt1e1/hwprobe.c                   |   16 +-
 drivers/staging/cxt1e1/linux.c                     |   38 +-
 drivers/staging/cxt1e1/musycc.c                    | 2678 +++----
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |  550 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   47 +-
 drivers/staging/cxt1e1/pmcc4_private.h             |    2 +-
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |   23 +-
 drivers/staging/cxt1e1/sbecrc.c                    |    5 +-
 drivers/staging/cxt1e1/sbeproc.c                   |    2 +-
 drivers/staging/dgap/dgap.c                        | 1326 ++--
 drivers/staging/dgap/dgap.h                        |  461 +-
 drivers/staging/dgnc/dgnc_cls.c                    |    4 -
 drivers/staging/dgnc/dgnc_cls.h                    |    1 -
 drivers/staging/dgnc/dgnc_driver.c                 |   43 +-
 drivers/staging/dgnc/dgnc_neo.c                    |  115 +-
 drivers/staging/dgnc/dgnc_sysfs.c                  |    2 +-
 drivers/staging/dgnc/dgnc_tty.c                    |  152 +-
 drivers/staging/et131x/Module.symvers              |    0
 drivers/staging/et131x/et131x.c                    |    5 +-
 drivers/staging/frontier/tranzport.c               |   10 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   15 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |   12 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    3 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |  142 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   25 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   37 +-
 drivers/staging/ft1000/ft1000.h                    |    7 +-
 drivers/staging/fwserial/dma_fifo.c                |   32 +-
 drivers/staging/fwserial/dma_fifo.h                |   22 +-
 drivers/staging/fwserial/fwserial.c                |   42 +-
 drivers/staging/gdm72xx/TODO                       |    1 -
 drivers/staging/gdm72xx/gdm_qos.c                  |  100 +-
 drivers/staging/gdm72xx/gdm_qos.h                  |   17 -
 drivers/staging/gdm72xx/gdm_sdio.c                 |   27 +-
 drivers/staging/gdm72xx/gdm_sdio.h                 |   29 +-
 drivers/staging/gdm72xx/gdm_usb.c                  |   64 +-
 drivers/staging/gdm72xx/gdm_usb.h                  |   11 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |  104 +-
 drivers/staging/gdm72xx/gdm_wimax.h                |   29 +-
 drivers/staging/gdm72xx/hci.h                      |   87 +-
 drivers/staging/gdm72xx/netlink_k.c                |   11 +-
 drivers/staging/gdm72xx/netlink_k.h                |    4 +-
 drivers/staging/gdm72xx/sdio_boot.c                |    4 +-
 drivers/staging/gdm72xx/sdio_boot.h                |    2 +-
 drivers/staging/gdm72xx/usb_boot.c                 |   39 +-
 drivers/staging/gdm72xx/usb_boot.h                 |    4 +-
 drivers/staging/gdm72xx/usb_ids.h                  |    2 +-
 drivers/staging/gdm72xx/wm_ioctl.h                 |   22 +-
 drivers/staging/goldfish/README                    |    1 -
 drivers/staging/goldfish/goldfish_audio.c          |   22 +-
 drivers/staging/goldfish/goldfish_nand.c           |   26 +-
 drivers/staging/goldfish/goldfish_nand_reg.h       |    3 +-
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c          |    2 +-
 drivers/staging/gs_fpgaboot/io.c                   |    6 +
 drivers/staging/iio/Documentation/iio_utils.h      |    4 +-
 drivers/staging/iio/adc/Kconfig                    |   20 -
 drivers/staging/iio/adc/Makefile                   |    4 -
 drivers/staging/iio/adc/ad7280a.c                  |    4 +-
 drivers/staging/iio/adc/ad7606.h                   |    4 +-
 drivers/staging/iio/adc/ad7816.c                   |    2 +-
 drivers/staging/iio/adc/ad799x.h                   |  121 -
 drivers/staging/iio/adc/ad799x_ring.c              |   84 -
 drivers/staging/iio/adc/spear_adc.c                |  315 +-
 drivers/staging/iio/addac/adt7316.c                |    4 +-
 drivers/staging/iio/cdc/ad7152.c                   |    2 +-
 drivers/staging/iio/cdc/ad7746.c                   |    2 +-
 drivers/staging/iio/light/tsl2583.c                |   38 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |    3 +-
 drivers/staging/imx-drm/imx-hdmi.c                 |   20 +-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |    5 +
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        |   47 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |   97 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |   25 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |   71 +-
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h           |    3 +
 drivers/staging/imx-drm/ipuv3-crtc.c               |   16 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |    4 +
 drivers/staging/imx-drm/parallel-display.c         |    2 +
 drivers/staging/keucr/init.c                       |    1 +
 drivers/staging/keucr/init.h                       |    5 -
 drivers/staging/keucr/scsiglue.c                   |    2 +-
 drivers/staging/keucr/smil.h                       |    3 +-
 drivers/staging/keucr/smilmain.c                   |   34 +-
 drivers/staging/keucr/smilsub.c                    |    1 +
 drivers/staging/keucr/transport.c                  |    1 +
 drivers/staging/line6/capture.c                    |    3 +
 drivers/staging/line6/driver.c                     |    1 +
 drivers/staging/line6/midi.c                       |    2 +
 drivers/staging/line6/pcm.c                        |    2 +-
 drivers/staging/line6/playback.c                   |   11 +-
 drivers/staging/line6/pod.c                        |    5 +
 drivers/staging/line6/toneport.c                   |    3 +
 drivers/staging/line6/variax.c                     |    2 +
 drivers/staging/lustre/TODO                        |    5 +-
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    1 +
 .../lustre/include/linux/libcfs/libcfs_cpu.h       |    9 +-
 .../lustre/include/linux/libcfs/libcfs_crypto.h    |    2 +-
 .../lustre/include/linux/libcfs/libcfs_debug.h     |    4 +-
 .../lustre/include/linux/libcfs/libcfs_hash.h      |    8 +-
 .../lustre/include/linux/libcfs/libcfs_private.h   |    4 +-
 .../lustre/include/linux/libcfs/linux/linux-lock.h |    2 +-
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |    5 +
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    2 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    6 +-
 drivers/staging/lustre/include/linux/lnet/lnetst.h |    2 +-
 drivers/staging/lustre/include/linux/lnet/ptllnd.h |    2 +-
 .../lustre/include/linux/lnet/ptllnd_wire.h        |   14 +-
 drivers/staging/lustre/include/linux/lnet/types.h  |    8 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   68 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   78 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |    4 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   82 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |   73 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |   16 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    3 +-
 drivers/staging/lustre/lnet/lnet/router.c          |    2 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |   41 +-
 drivers/staging/lustre/lustre/include/dt_object.h  |    9 +-
 drivers/staging/lustre/lustre/include/ioctl.h      |  106 -
 drivers/staging/lustre/lustre/include/linux/obd.h  |    6 +-
 .../staging/lustre/lustre/include/lprocfs_status.h |    5 +-
 drivers/staging/lustre/lustre/include/lu_object.h  |    8 +-
 drivers/staging/lustre/lustre/include/lu_ref.h     |    4 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   28 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |    5 +-
 .../staging/lustre/lustre/include/lustre_debug.h   |    1 -
 drivers/staging/lustre/lustre/include/lustre_dlm.h |   12 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |   34 +-
 drivers/staging/lustre/lustre/include/lustre_log.h |   10 -
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   23 +-
 drivers/staging/lustre/lustre/include/lustre_net.h |    4 +-
 drivers/staging/lustre/lustre/include/obd.h        |   24 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |   19 +-
 drivers/staging/lustre/lustre/include/obd_lov.h    |  116 -
 .../staging/lustre/lustre/include/obd_support.h    |   10 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |   17 +-
 .../staging/lustre/lustre/lclient/lcommon_misc.c   |   15 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_extent.c   |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_internal.h |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c      |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   10 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |   16 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    6 +-
 drivers/staging/lustre/lustre/libcfs/libcfs_cpu.c  |   23 +
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |   18 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  152 -
 .../lustre/lustre/libcfs/linux/linux-module.c      |   15 +-
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |   43 +-
 drivers/staging/lustre/lustre/libcfs/module.c      |    3 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |   12 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |   14 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.h   |    2 +-
 drivers/staging/lustre/lustre/libcfs/workitem.c    |    2 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |   26 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   15 +-
 drivers/staging/lustre/lustre/llite/file.c         |  152 +-
 drivers/staging/lustre/lustre/llite/llite_capa.c   |    4 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |  177 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  138 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |   23 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    8 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |   10 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |  155 +-
 drivers/staging/lustre/lustre/llite/namei.c        |   40 +-
 drivers/staging/lustre/lustre/llite/remote_perm.c  |    2 +-
 drivers/staging/lustre/lustre/llite/rw.c           |    7 -
 drivers/staging/lustre/lustre/llite/rw26.c         |   19 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |   68 +-
 drivers/staging/lustre/lustre/llite/super25.c      |    9 +-
 drivers/staging/lustre/lustre/llite/symlink.c      |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_dev.c      |   10 +-
 drivers/staging/lustre/lustre/llite/vvp_internal.h |    2 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |    4 +-
 drivers/staging/lustre/lustre/llite/vvp_object.c   |   35 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |    7 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |    4 +-
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |   25 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |   16 +-
 drivers/staging/lustre/lustre/lov/Makefile         |    2 +-
 drivers/staging/lustre/lustre/lov/lov_dev.c        |    6 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |   14 +-
 drivers/staging/lustre/lustre/lov/lov_internal.h   |   37 +-
 drivers/staging/lustre/lustre/lov/lov_lock.c       |   42 +-
 drivers/staging/lustre/lustre/lov/lov_log.c        |  272 -
 drivers/staging/lustre/lustre/lov/lov_merge.c      |    6 +-
 drivers/staging/lustre/lustre/lov/lov_obd.c        |   31 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |    3 +-
 drivers/staging/lustre/lustre/lov/lov_offset.c     |    1 -
 drivers/staging/lustre/lustre/lov/lov_pack.c       |   10 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |    1 -
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |    2 +-
 drivers/staging/lustre/lustre/lov/lovsub_lock.c    |    2 +-
 drivers/staging/lustre/lustre/lov/lovsub_object.c  |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |   23 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |   11 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   49 +-
 drivers/staging/lustre/lustre/mgc/lproc_mgc.c      |   22 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    8 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |   16 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |    6 +-
 drivers/staging/lustre/lustre/obdclass/cl_page.c   |    4 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |   50 +-
 drivers/staging/lustre/lustre/obdclass/debug.c     |   12 -
 drivers/staging/lustre/lustre/obdclass/genops.c    |    6 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |   42 +-
 .../staging/lustre/lustre/obdclass/llog_ioctl.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/llog_obd.c  |   29 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |   22 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |   11 +-
 drivers/staging/lustre/lustre/obdecho/lproc_echo.c |    4 +-
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |   84 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |    4 +-
 .../staging/lustre/lustre/osc/osc_cl_internal.h    |    9 +
 drivers/staging/lustre/lustre/osc/osc_dev.c        |    6 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   28 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |    3 +-
 drivers/staging/lustre/lustre/osc/osc_object.c     |    2 +-
 drivers/staging/lustre/lustre/osc/osc_request.c    |    1 -
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   50 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_bulk.c    |   12 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   38 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |    2 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    1 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |    2 +-
 .../staging/lustre/lustre/ptlrpc/ptlrpc_internal.h |    4 +
 .../staging/lustre/lustre/ptlrpc/ptlrpc_module.c   |   32 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   24 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |   10 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   20 +-
 drivers/staging/media/lirc/lirc_bt829.c            |    6 +-
 drivers/staging/media/lirc/lirc_parallel.c         |   26 +-
 drivers/staging/media/lirc/lirc_serial.c           |   92 +-
 drivers/staging/media/lirc/lirc_sir.c              |   33 +-
 drivers/staging/media/lirc/lirc_zilog.c            |   23 +-
 drivers/staging/mt29f_spinand/mt29f_spinand.c      |    3 +
 drivers/staging/netlogic/xlr_net.c                 |    1 +
 drivers/staging/nokia_h4p/nokia_fw-bcm.c           |    3 +-
 drivers/staging/octeon-usb/octeon-hcd.c            |  130 +-
 drivers/staging/olpc_dcon/olpc_dcon.c              |    8 +-
 drivers/staging/ozwpan/TODO                        |    2 +-
 drivers/staging/ozwpan/ozhcd.c                     |   21 +-
 drivers/staging/ozwpan/ozproto.c                   |    4 +-
 drivers/staging/panel/panel.c                      |  310 +-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |    8 +-
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        |    1 +
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |   35 -
 drivers/staging/rtl8188eu/core/rtw_led.c           | 1415 +---
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |   19 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |   13 +-
 drivers/staging/rtl8188eu/core/rtw_mp.c            |    1 -
 drivers/staging/rtl8188eu/core/rtw_p2p.c           |    6 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |   18 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |   72 +-
 drivers/staging/rtl8188eu/core/rtw_security.c      |    2 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |   30 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |    2 -
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   14 -
 drivers/staging/rtl8188eu/hal/hal_intf.c           |   16 -
 drivers/staging/rtl8188eu/hal/odm.c                |  174 +-
 drivers/staging/rtl8188eu/hal/odm_HWConfig.c       |   12 -
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |   24 -
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |   14 -
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    1 -
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |  208 -
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   45 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_led.c      |   43 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |   22 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   66 -
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |   26 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    1 -
 drivers/staging/rtl8188eu/include/drv_types.h      |    1 -
 drivers/staging/rtl8188eu/include/hal_intf.h       |    8 -
 drivers/staging/rtl8188eu/include/odm.h            |    8 -
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h   |    2 -
 drivers/staging/rtl8188eu/include/odm_debug.h      |    6 +-
 drivers/staging/rtl8188eu/include/odm_interface.h  |   91 -
 drivers/staging/rtl8188eu/include/odm_precomp.h    |    1 -
 drivers/staging/rtl8188eu/include/odm_types.h      |   25 -
 drivers/staging/rtl8188eu/include/osdep_service.h  |   59 -
 drivers/staging/rtl8188eu/include/recv_osdep.h     |    4 -
 drivers/staging/rtl8188eu/include/rtl8188e_dm.h    |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |    1 -
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h  |    1 -
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |    1 -
 drivers/staging/rtl8188eu/include/rtw_led.h        |  119 +-
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h    |    4 +-
 drivers/staging/rtl8188eu/include/rtw_recv.h       |   53 -
 drivers/staging/rtl8188eu/include/usb_ops.h        |    1 -
 drivers/staging/rtl8188eu/include/xmit_osdep.h     |    6 -
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   69 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   16 +-
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |   40 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  259 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |    7 -
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |   10 -
 drivers/staging/rtl8192e/rtl8192e/Kconfig          |    1 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c  |    2 +-
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |   95 +-
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.h    |    5 -
 drivers/staging/rtl8192e/rtl8192e/r8192E_hwimg.c   | 2771 -------
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |    5 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |   10 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h       |    1 -
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |   20 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.h         |    3 +-
 drivers/staging/rtl8192e/rtl819x_BAProc.c          |   14 +-
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |    2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    5 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    5 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |    4 +-
 drivers/staging/rtl8192ee/Kconfig                  |   15 +
 drivers/staging/rtl8192ee/Makefile                 |   40 +
 drivers/staging/rtl8192ee/TODO                     |   12 +
 drivers/staging/rtl8192ee/base.c                   | 1852 +++++
 drivers/staging/rtl8192ee/base.h                   |  163 +
 .../staging/rtl8192ee/btcoexist/halbt_precomp.h    |   50 +
 .../staging/rtl8192ee/btcoexist/halbtc8192e2ant.c  | 4110 ++++++++++
 .../staging/rtl8192ee/btcoexist/halbtc8192e2ant.h  |  161 +
 .../staging/rtl8192ee/btcoexist/halbtc8723b1ant.c  | 3146 ++++++++
 .../staging/rtl8192ee/btcoexist/halbtc8723b1ant.h  |  160 +
 .../staging/rtl8192ee/btcoexist/halbtc8723b2ant.c  | 3929 ++++++++++
 .../staging/rtl8192ee/btcoexist/halbtc8723b2ant.h  |  145 +
 .../staging/rtl8192ee/btcoexist/halbtc8821a1ant.c  | 2780 +++++++
 .../staging/rtl8192ee/btcoexist/halbtc8821a1ant.h  |  158 +
 .../staging/rtl8192ee/btcoexist/halbtc8821a2ant.c  | 3438 ++++++++
 .../staging/rtl8192ee/btcoexist/halbtc8821a2ant.h  |  179 +
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c | 1297 +++
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h |  537 ++
 drivers/staging/rtl8192ee/btcoexist/rtl_btc.c      |  194 +
 drivers/staging/rtl8192ee/btcoexist/rtl_btc.h      |   62 +
 drivers/staging/rtl8192ee/cam.c                    |  337 +
 drivers/staging/rtl8192ee/cam.h                    |   52 +
 drivers/staging/rtl8192ee/compat.h                 |   70 +
 drivers/staging/rtl8192ee/core.c                   | 1600 ++++
 drivers/staging/rtl8192ee/core.h                   |   39 +
 drivers/staging/rtl8192ee/debug.c                  |  978 +++
 drivers/staging/rtl8192ee/debug.h                  |  221 +
 drivers/staging/rtl8192ee/efuse.c                  | 1233 +++
 drivers/staging/rtl8192ee/efuse.h                  |  127 +
 drivers/staging/rtl8192ee/pci.c                    | 2397 ++++++
 drivers/staging/rtl8192ee/pci.h                    |  342 +
 drivers/staging/rtl8192ee/ps.c                     |  983 +++
 drivers/staging/rtl8192ee/ps.h                     |   52 +
 drivers/staging/rtl8192ee/rc.c                     |  288 +
 drivers/staging/rtl8192ee/rc.h                     |   47 +
 drivers/staging/rtl8192ee/regd.c                   |  448 ++
 drivers/staging/rtl8192ee/regd.h                   |   63 +
 drivers/staging/rtl8192ee/rtl8192ee/def.h          |  106 +
 drivers/staging/rtl8192ee/rtl8192ee/dm.c           | 1258 +++
 drivers/staging/rtl8192ee/rtl8192ee/dm.h           |  343 +
 drivers/staging/rtl8192ee/rtl8192ee/fw.c           |  945 +++
 drivers/staging/rtl8192ee/rtl8192ee/fw.h           |  213 +
 drivers/staging/rtl8192ee/rtl8192ee/hw.c           | 2544 ++++++
 drivers/staging/rtl8192ee/rtl8192ee/hw.h           |   67 +
 drivers/staging/rtl8192ee/rtl8192ee/led.c          |  134 +
 drivers/staging/rtl8192ee/rtl8192ee/led.h          |   37 +
 drivers/staging/rtl8192ee/rtl8192ee/phy.c          | 3282 ++++++++
 drivers/staging/rtl8192ee/rtl8192ee/phy.h          |  154 +
 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.c       |  108 +
 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.h       |  355 +
 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c    |  139 +
 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.h    |   69 +
 drivers/staging/rtl8192ee/rtl8192ee/reg.h          | 2240 ++++++
 drivers/staging/rtl8192ee/rtl8192ee/rf.c           |  150 +
 drivers/staging/rtl8192ee/rtl8192ee/rf.h           |   39 +
 drivers/staging/rtl8192ee/rtl8192ee/sw.c           |  428 +
 .../drv_types_linux.h => rtl8192ee/rtl8192ee/sw.h} |   25 +-
 drivers/staging/rtl8192ee/rtl8192ee/table.c        |  882 +++
 drivers/staging/rtl8192ee/rtl8192ee/table.h        |   48 +
 drivers/staging/rtl8192ee/rtl8192ee/trx.c          | 1286 +++
 drivers/staging/rtl8192ee/rtl8192ee/trx.h          |  877 +++
 drivers/staging/rtl8192ee/stats.c                  |  290 +
 drivers/staging/rtl8192ee/stats.h                  |   43 +
 drivers/staging/rtl8192ee/wifi.h                   | 2644 +++++++
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   16 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c      |    2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c      |    2 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c       |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   45 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   84 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |   46 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    5 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |   45 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |   22 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |   16 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |   10 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |   46 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |    6 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   18 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |   18 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |  246 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |    3 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   12 +-
 drivers/staging/rtl8192u/r819xU_firmware_img.c     | 1042 +--
 drivers/staging/rtl8192u/r819xU_phy.c              |    6 +-
 drivers/staging/rtl8712/hal_init.c                 |    2 +-
 drivers/staging/rtl8712/ieee80211.c                |    8 +-
 drivers/staging/rtl8712/mlme_linux.c               |    3 +-
 drivers/staging/rtl8712/osdep_service.h            |    5 -
 drivers/staging/rtl8712/rtl8712_cmd.c              |    3 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |   13 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |  123 +-
 drivers/staging/rtl8712/rtl871x_io.c               |   11 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |   47 +-
 drivers/staging/rtl8712/rtl871x_mlme.c             |   48 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |   13 +-
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         |   49 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |   10 +-
 drivers/staging/rtl8712/rtl871x_security.c         |    9 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |    4 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |   16 +-
 drivers/staging/rtl8712/usb_intf.c                 |    2 +-
 drivers/staging/rtl8712/usb_ops_linux.c            |    4 +-
 drivers/staging/rtl8723au/Kconfig                  |    8 -
 drivers/staging/rtl8723au/Makefile                 |   10 +-
 drivers/staging/rtl8723au/core/rtw_ap.c            |  439 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c           |  734 +-
 drivers/staging/rtl8723au/core/rtw_efuse.c         |  363 +-
 drivers/staging/rtl8723au/core/rtw_ieee80211.c     |  961 +--
 drivers/staging/rtl8723au/core/rtw_io.c            |  266 -
 drivers/staging/rtl8723au/core/rtw_ioctl_set.c     |  250 +-
 drivers/staging/rtl8723au/core/rtw_led.c           |   48 +-
 drivers/staging/rtl8723au/core/rtw_mlme.c          | 1568 ++--
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c      | 6741 ++++------------
 drivers/staging/rtl8723au/core/rtw_p2p.c           | 4001 ----------
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c       |  342 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |  313 +-
 drivers/staging/rtl8723au/core/rtw_security.c      |   61 +-
 drivers/staging/rtl8723au/core/rtw_sreset.c        |   79 +-
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c       |  127 +-
 drivers/staging/rtl8723au/core/rtw_wlan_util.c     | 1015 ++-
 drivers/staging/rtl8723au/core/rtw_xmit.c          |  523 +-
 .../staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c    |  133 +-
 drivers/staging/rtl8723au/hal/HalPwrSeqCmd.c       |    8 +-
 drivers/staging/rtl8723au/hal/hal_com.c            |  276 +-
 drivers/staging/rtl8723au/hal/hal_intf.c           |  384 +-
 drivers/staging/rtl8723au/hal/odm.c                |  181 +-
 drivers/staging/rtl8723au/hal/odm_HWConfig.c       |   43 +-
 drivers/staging/rtl8723au/hal/odm_interface.c      |  121 +-
 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |  647 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c       |  291 +-
 drivers/staging/rtl8723au/hal/rtl8723a_dm.c        |   33 +-
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c  | 1381 +---
 drivers/staging/rtl8723au/hal/rtl8723a_phycfg.c    |   89 +-
 drivers/staging/rtl8723au/hal/rtl8723a_rf6052.c    |   22 +-
 drivers/staging/rtl8723au/hal/rtl8723a_sreset.c    |   11 +-
 drivers/staging/rtl8723au/hal/rtl8723au_led.c      |   27 +-
 drivers/staging/rtl8723au/hal/rtl8723au_recv.c     |   76 +-
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c     |   69 +-
 drivers/staging/rtl8723au/hal/usb_halinit.c        |  641 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c      |  310 +-
 drivers/staging/rtl8723au/include/Hal8723APhyCfg.h |   14 +-
 drivers/staging/rtl8723au/include/Hal8723PwrSeq.h  |  104 +-
 drivers/staging/rtl8723au/include/cmd_osdep.h      |   26 -
 drivers/staging/rtl8723au/include/drv_types.h      |   81 -
 drivers/staging/rtl8723au/include/ethernet.h       |   22 -
 drivers/staging/rtl8723au/include/hal_com.h        |   13 +-
 drivers/staging/rtl8723au/include/hal_intf.h       |  305 +-
 drivers/staging/rtl8723au/include/ieee80211.h      |  256 +-
 drivers/staging/rtl8723au/include/ioctl_cfg80211.h |   50 -
 drivers/staging/rtl8723au/include/mlme_osdep.h     |    4 -
 drivers/staging/rtl8723au/include/mp_custom_oid.h  |  342 -
 drivers/staging/rtl8723au/include/odm.h            |  227 +-
 drivers/staging/rtl8723au/include/odm_HWConfig.h   |   16 +-
 drivers/staging/rtl8723au/include/odm_debug.h      |   42 +-
 drivers/staging/rtl8723au/include/odm_interface.h  |   57 -
 drivers/staging/rtl8723au/include/odm_precomp.h    |    4 -
 drivers/staging/rtl8723au/include/odm_reg.h        |    5 +-
 drivers/staging/rtl8723au/include/odm_types.h      |   36 -
 drivers/staging/rtl8723au/include/osdep_intf.h     |   12 +-
 drivers/staging/rtl8723au/include/osdep_service.h  |  119 -
 drivers/staging/rtl8723au/include/recv_osdep.h     |    9 -
 .../rtl8723au/include/rtl8723a_bt-coexist.h        |  122 +-
 .../staging/rtl8723au/include/rtl8723a_bt_intf.h   |   69 +
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h   |   18 +-
 drivers/staging/rtl8723au/include/rtl8723a_dm.h    |    2 -
 drivers/staging/rtl8723au/include/rtl8723a_hal.h   |   60 +-
 drivers/staging/rtl8723au/include/rtl8723a_recv.h  |   21 +-
 drivers/staging/rtl8723au/include/rtl8723a_spec.h  |  314 +-
 drivers/staging/rtl8723au/include/rtl8723a_xmit.h  |   10 +-
 drivers/staging/rtl8723au/include/rtw_ap.h         |    4 +-
 drivers/staging/rtl8723au/include/rtw_cmd.h        |  144 +-
 drivers/staging/rtl8723au/include/rtw_efuse.h      |   11 +-
 drivers/staging/rtl8723au/include/rtw_event.h      |   60 +-
 drivers/staging/rtl8723au/include/rtw_ht.h         |    4 +-
 drivers/staging/rtl8723au/include/rtw_io.h         |  193 +-
 drivers/staging/rtl8723au/include/rtw_ioctl.h      |   26 -
 drivers/staging/rtl8723au/include/rtw_ioctl_set.h  |   23 +-
 drivers/staging/rtl8723au/include/rtw_mlme.h       |  272 +-
 drivers/staging/rtl8723au/include/rtw_mlme_ext.h   |  192 +-
 drivers/staging/rtl8723au/include/rtw_p2p.h        |  158 -
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h    |    4 -
 drivers/staging/rtl8723au/include/rtw_qos.h        |   26 -
 drivers/staging/rtl8723au/include/rtw_recv.h       |   26 +-
 drivers/staging/rtl8723au/include/rtw_security.h   |   61 +-
 drivers/staging/rtl8723au/include/rtw_sreset.h     |   28 +-
 drivers/staging/rtl8723au/include/rtw_xmit.h       |   34 +-
 drivers/staging/rtl8723au/include/sta_info.h       |   34 +-
 drivers/staging/rtl8723au/include/usb_hal.h        |   20 -
 drivers/staging/rtl8723au/include/usb_ops.h        |   31 +-
 drivers/staging/rtl8723au/include/usb_ops_linux.h  |   37 +-
 drivers/staging/rtl8723au/include/usb_osintf.h     |   24 -
 drivers/staging/rtl8723au/include/usb_vendor_req.h |   31 -
 drivers/staging/rtl8723au/include/wifi.h           |  552 --
 drivers/staging/rtl8723au/include/wlan_bssdef.h    |   83 +-
 drivers/staging/rtl8723au/include/xmit_osdep.h     |   19 -
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  | 1996 ++---
 drivers/staging/rtl8723au/os_dep/mlme_linux.c      |  109 +-
 drivers/staging/rtl8723au/os_dep/os_intfs.c        |  255 +-
 drivers/staging/rtl8723au/os_dep/osdep_service.c   |  175 -
 drivers/staging/rtl8723au/os_dep/recv_linux.c      |   66 +-
 drivers/staging/rtl8723au/os_dep/usb_intf.c        |  110 +-
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c   |   89 +-
 drivers/staging/rtl8723au/os_dep/xmit_linux.c      |   41 -
 drivers/staging/rtl8821ae/base.c                   |   49 +-
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  |  506 +-
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.h  |    2 -
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  |  402 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  |  147 +-
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c |  127 +-
 drivers/staging/rtl8821ae/btcoexist/rtl_btc.c      |    2 +-
 drivers/staging/rtl8821ae/cam.c                    |    2 -
 drivers/staging/rtl8821ae/compat.h                 |   57 -
 drivers/staging/rtl8821ae/core.c                   |  156 +-
 drivers/staging/rtl8821ae/debug.c                  |    5 -
 drivers/staging/rtl8821ae/efuse.c                  |    2 -
 drivers/staging/rtl8821ae/pci.c                    |  134 +-
 drivers/staging/rtl8821ae/pci.h                    |    5 -
 drivers/staging/rtl8821ae/ps.c                     |   26 -
 drivers/staging/rtl8821ae/rc.c                     |   20 +-
 drivers/staging/rtl8821ae/regd.c                   |   52 -
 drivers/staging/rtl8821ae/regd.h                   |    8 -
 drivers/staging/rtl8821ae/rtl8821ae/hw.h           |   35 +-
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |   33 +-
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          |   45 -
 drivers/staging/rtl8821ae/rtl8821ae/trx.h          |   11 -
 drivers/staging/rtl8821ae/stats.c                  |    2 -
 drivers/staging/rtl8821ae/wifi.h                   |    4 +-
 drivers/staging/rts5139/Kconfig                    |   16 -
 drivers/staging/rts5139/Makefile                   |   43 -
 drivers/staging/rts5139/TODO                       |    9 -
 drivers/staging/rts5139/debug.h                    |   46 -
 drivers/staging/rts5139/ms.c                       | 4185 ----------
 drivers/staging/rts5139/ms.h                       |  261 -
 drivers/staging/rts5139/ms_mg.c                    |  643 --
 drivers/staging/rts5139/ms_mg.h                    |   41 -
 drivers/staging/rts5139/rts51x.c                   |  857 --
 drivers/staging/rts5139/rts51x.h                   |  194 -
 drivers/staging/rts5139/rts51x_card.c              |  940 ---
 drivers/staging/rts5139/rts51x_card.h              |  870 ---
 drivers/staging/rts5139/rts51x_chip.c              | 1014 ---
 drivers/staging/rts5139/rts51x_chip.h              |  821 --
 drivers/staging/rts5139/rts51x_fop.c               |  292 -
 drivers/staging/rts5139/rts51x_fop.h               |   57 -
 drivers/staging/rts5139/rts51x_scsi.c              | 2135 -----
 drivers/staging/rts5139/rts51x_scsi.h              |  154 -
 drivers/staging/rts5139/rts51x_transport.c         |  736 --
 drivers/staging/rts5139/rts51x_transport.h         |   67 -
 drivers/staging/rts5139/sd.c                       | 3274 --------
 drivers/staging/rts5139/sd.h                       |  275 -
 drivers/staging/rts5139/sd_cprm.c                  | 1056 ---
 drivers/staging/rts5139/sd_cprm.h                  |   54 -
 drivers/staging/rts5139/trace.h                    |   95 -
 drivers/staging/rts5139/xd.c                       | 2145 -----
 drivers/staging/rts5139/xd.h                       |  191 -
 drivers/staging/rts5208/rtsx.c                     |    2 +-
 drivers/staging/rts5208/rtsx_chip.c                |    2 +-
 drivers/staging/sbe-2t3e3/2t3e3.h                  |  889 ---
 drivers/staging/sbe-2t3e3/Kconfig                  |   13 -
 drivers/staging/sbe-2t3e3/Makefile                 |    4 -
 drivers/staging/sbe-2t3e3/TODO                     |    6 -
 drivers/staging/sbe-2t3e3/cpld.c                   |  351 -
 drivers/staging/sbe-2t3e3/ctrl.c                   |  350 -
 drivers/staging/sbe-2t3e3/ctrl.h                   |  131 -
 drivers/staging/sbe-2t3e3/dc.c                     |  460 --
 drivers/staging/sbe-2t3e3/exar7250.c               |  185 -
 drivers/staging/sbe-2t3e3/exar7300.c               |  165 -
 drivers/staging/sbe-2t3e3/intr.c                   |  579 --
 drivers/staging/sbe-2t3e3/io.c                     |  330 -
 drivers/staging/sbe-2t3e3/main.c                   |  172 -
 drivers/staging/sbe-2t3e3/maps.c                   |  101 -
 drivers/staging/sbe-2t3e3/module.c                 |  208 -
 drivers/staging/sbe-2t3e3/netdev.c                 |  143 -
 drivers/staging/sep/sep_crypto.c                   |   10 +
 drivers/staging/sep/sep_dev.h                      |    1 +
 drivers/staging/sep/sep_main.c                     |    3 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   25 +-
 drivers/staging/silicom/bpctl_mod.c                |  191 +-
 drivers/staging/silicom/bypasslib/bp_ioctl.h       |    4 +-
 drivers/staging/silicom/bypasslib/bypass.c         |   53 +-
 drivers/staging/skein/Kconfig                      |   32 +
 drivers/staging/skein/Makefile                     |    9 +
 drivers/staging/skein/TODO                         |    8 +
 drivers/staging/skein/skein.c                      |  883 +++
 drivers/staging/skein/skein.h                      |  346 +
 drivers/staging/skein/skein_api.c                  |  239 +
 drivers/staging/skein/skein_api.h                  |  230 +
 drivers/staging/skein/skein_block.c                |  777 ++
 drivers/staging/skein/skein_block.h                |   22 +
 drivers/staging/skein/skein_iv.h                   |  186 +
 drivers/staging/skein/threefish_api.c              |   77 +
 drivers/staging/skein/threefish_api.h              |  170 +
 drivers/staging/skein/threefish_block.c            | 8258 ++++++++++++++++++++
 drivers/staging/slicoss/TODO                       |    1 -
 drivers/staging/slicoss/slic.h                     |   13 -
 drivers/staging/slicoss/slicoss.c                  |  657 +-
 drivers/staging/speakup/kobjects.c                 |   64 +-
 drivers/staging/speakup/speakup_acntpc.c           |   14 +-
 drivers/staging/speakup/speakup_acntsa.c           |   14 +-
 drivers/staging/speakup/speakup_apollo.c           |   16 +-
 drivers/staging/speakup/speakup_audptr.c           |   16 +-
 drivers/staging/speakup/speakup_bns.c              |   14 +-
 drivers/staging/speakup/speakup_decext.c           |   16 +-
 drivers/staging/speakup/speakup_decpc.c            |   16 +-
 drivers/staging/speakup/speakup_dectlk.c           |   16 +-
 drivers/staging/speakup/speakup_dtlk.c             |   20 +-
 drivers/staging/speakup/speakup_dummy.c            |   14 +-
 drivers/staging/speakup/speakup_keypc.c            |   10 +-
 drivers/staging/speakup/speakup_ltlk.c             |   20 +-
 drivers/staging/speakup/speakup_soft.c             |   22 +-
 drivers/staging/speakup/speakup_spkout.c           |   16 +-
 drivers/staging/speakup/speakup_txprt.c            |   14 +-
 drivers/staging/speakup/synth.c                    |    3 +
 drivers/staging/tidspbridge/core/dsp-clock.c       |    4 +-
 drivers/staging/unisys/channels/channel.c          |    2 +-
 drivers/staging/unisys/channels/chanstub.c         |    5 +-
 drivers/staging/unisys/channels/chanstub.h         |    2 +-
 .../unisys/common-spar/include/channels/channel.h  |   47 +-
 .../common-spar/include/channels/channel_guid.h    |   30 +-
 .../include/channels/controlframework.h            |    2 +-
 .../include/channels/controlvmchannel.h            |   21 +-
 .../common-spar/include/channels/diagchannel.h     |   14 +-
 .../common-spar/include/channels/iochannel.h       |   14 +-
 .../common-spar/include/channels/vbuschannel.h     |   12 +-
 .../include/controlvmcompletionstatus.h            |    2 +-
 .../include/diagnostics/appos_subsystems.h         |    2 +-
 .../unisys/common-spar/include/iovmcall_gnuc.h     |    2 +-
 .../unisys/common-spar/include/vbusdeviceinfo.h    |    2 +-
 .../staging/unisys/common-spar/include/version.h   |    2 +-
 .../unisys/common-spar/include/vmcallinterface.h   |    2 +-
 drivers/staging/unisys/include/commontypes.h       |   51 +-
 drivers/staging/unisys/include/guestlinuxdebug.h   |    6 +-
 drivers/staging/unisys/include/guidutils.h         |  203 -
 drivers/staging/unisys/include/periodic_work.h     |    2 +-
 drivers/staging/unisys/include/procobjecttree.h    |    2 +-
 drivers/staging/unisys/include/sparstop.h          |    2 +-
 drivers/staging/unisys/include/timskmod.h          |    2 +-
 drivers/staging/unisys/include/timskmodutils.h     |    4 +-
 drivers/staging/unisys/include/uisqueue.h          |   15 +-
 drivers/staging/unisys/include/uisthread.h         |    2 +-
 drivers/staging/unisys/include/uisutils.h          |   44 +-
 drivers/staging/unisys/include/uniklog.h           |    2 +-
 drivers/staging/unisys/uislib/uislib.c             |  935 +--
 drivers/staging/unisys/uislib/uisqueue.c           |    2 +-
 drivers/staging/unisys/uislib/uisthread.c          |    2 +-
 drivers/staging/unisys/uislib/uisutils.c           |   55 +-
 drivers/staging/unisys/virthba/virthba.c           |   21 +-
 drivers/staging/unisys/virthba/virthba.h           |    2 +-
 drivers/staging/unisys/virtpci/virtpci.c           |   19 +-
 drivers/staging/unisys/virtpci/virtpci.h           |    5 +-
 drivers/staging/unisys/visorchannel/globals.h      |    2 +-
 drivers/staging/unisys/visorchannel/visorchannel.h |   48 +-
 .../unisys/visorchannel/visorchannel_funcs.c       |   45 +-
 .../unisys/visorchannel/visorchannel_main.c        |    7 +-
 drivers/staging/unisys/visorchipset/Makefile       |    2 +-
 drivers/staging/unisys/visorchipset/controlvm.h    |    2 +-
 .../staging/unisys/visorchipset/controlvm_direct.c |    2 +-
 drivers/staging/unisys/visorchipset/file.c         |    2 +-
 drivers/staging/unisys/visorchipset/file.h         |    2 +-
 drivers/staging/unisys/visorchipset/filexfer.c     |  506 --
 drivers/staging/unisys/visorchipset/filexfer.h     |  147 -
 drivers/staging/unisys/visorchipset/globals.h      |    2 +-
 drivers/staging/unisys/visorchipset/parser.c       |    7 +-
 drivers/staging/unisys/visorchipset/parser.h       |    6 +-
 drivers/staging/unisys/visorchipset/testing.h      |    7 +-
 drivers/staging/unisys/visorchipset/visorchipset.h |   18 +-
 .../unisys/visorchipset/visorchipset_main.c        |   28 +-
 .../unisys/visorchipset/visorchipset_umode.h       |    2 +-
 drivers/staging/unisys/visorutil/charqueue.c       |    4 +-
 drivers/staging/unisys/visorutil/charqueue.h       |    2 +-
 drivers/staging/unisys/visorutil/easyproc.c        |    8 +-
 drivers/staging/unisys/visorutil/easyproc.h        |    2 +-
 drivers/staging/unisys/visorutil/memregion.h       |    4 +-
 .../staging/unisys/visorutil/memregion_direct.c    |    8 +-
 drivers/staging/unisys/visorutil/periodic_work.c   |    3 +-
 drivers/staging/unisys/visorutil/procobjecttree.c  |    8 +-
 drivers/staging/unisys/visorutil/visorkmodutils.c  |   57 +-
 drivers/staging/usbip/stub_dev.c                   |    1 +
 drivers/staging/usbip/stub_tx.c                    |    3 +-
 drivers/staging/usbip/usbip_common.h               |    2 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |    4 +-
 .../staging/usbip/userspace/libsrc/usbip_common.h  |    2 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |    2 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |    1 +
 drivers/staging/usbip/userspace/src/usbip_port.c   |    2 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |   10 +-
 drivers/staging/usbip/vhci_hcd.c                   |    2 +
 drivers/staging/vme/devices/vme_user.c             |    9 +-
 drivers/staging/vt6655/IEEE11h.c                   |    6 -
 drivers/staging/vt6655/baseband.c                  |  101 +-
 drivers/staging/vt6655/bssdb.c                     |    6 +-
 drivers/staging/vt6655/bssdb.h                     |    2 -
 drivers/staging/vt6655/card.c                      |  195 +-
 drivers/staging/vt6655/card.h                      |    1 -
 drivers/staging/vt6655/channel.c                   |   80 +-
 drivers/staging/vt6655/datarate.c                  |   24 +-
 drivers/staging/vt6655/desc.h                      |   47 -
 drivers/staging/vt6655/device.h                    |   19 +-
 drivers/staging/vt6655/device_main.c               |  298 +-
 drivers/staging/vt6655/dpc.c                       |  142 +-
 drivers/staging/vt6655/hostap.c                    |   73 +-
 drivers/staging/vt6655/ioctl.c                     |    7 +-
 drivers/staging/vt6655/ioctl.h                     |    9 -
 drivers/staging/vt6655/iowpa.h                     |    7 -
 drivers/staging/vt6655/iwctl.c                     |  474 +-
 drivers/staging/vt6655/key.c                       |   55 +-
 drivers/staging/vt6655/key.h                       |    2 -
 drivers/staging/vt6655/mac.c                       |   96 +-
 drivers/staging/vt6655/mac.h                       |    1 -
 drivers/staging/vt6655/mib.c                       |   81 +-
 drivers/staging/vt6655/mib.h                       |    8 -
 drivers/staging/vt6655/michael.c                   |   33 +-
 drivers/staging/vt6655/power.c                     |   36 +-
 drivers/staging/vt6655/power.h                     |    3 -
 drivers/staging/vt6655/rf.c                        |   69 +-
 drivers/staging/vt6655/rxtx.c                      |  329 +-
 drivers/staging/vt6655/rxtx.h                      |   11 -
 drivers/staging/vt6655/tether.c                    |    4 +-
 drivers/staging/vt6655/tkip.c                      |    7 +-
 drivers/staging/vt6655/vntwifi.c                   |  115 +-
 drivers/staging/vt6655/vntwifi.h                   |   14 -
 drivers/staging/vt6655/wcmd.c                      |  126 +-
 drivers/staging/vt6655/wctl.c                      |    9 +-
 drivers/staging/vt6655/wmgr.c                      |  410 +-
 drivers/staging/vt6655/wmgr.h                      |   30 -
 drivers/staging/vt6655/wpa.c                       |    8 +-
 drivers/staging/vt6655/wpa2.c                      |   41 +-
 drivers/staging/vt6655/wpactl.c                    |   95 +-
 drivers/staging/vt6655/wroute.c                    |    1 -
 drivers/staging/vt6656/Makefile                    |    4 -
 drivers/staging/vt6656/aes_ccmp.c                  |  373 -
 drivers/staging/vt6656/aes_ccmp.h                  |   35 -
 drivers/staging/vt6656/baseband.c                  | 1494 ++--
 drivers/staging/vt6656/baseband.h                  |   22 +-
 drivers/staging/vt6656/bssdb.c                     |   61 +-
 drivers/staging/vt6656/card.c                      | 1045 ++-
 drivers/staging/vt6656/card.h                      |    8 +-
 drivers/staging/vt6656/control.c                   |   79 -
 drivers/staging/vt6656/control.h                   |   54 -
 drivers/staging/vt6656/datarate.c                  |    1 -
 drivers/staging/vt6656/desc.h                      |   68 -
 drivers/staging/vt6656/device.h                    |  241 +-
 drivers/staging/vt6656/device_cfg.h                |   87 -
 drivers/staging/vt6656/dpc.c                       |  471 +-
 drivers/staging/vt6656/firmware.c                  |   12 +-
 drivers/staging/vt6656/hostap.c                    |  779 --
 drivers/staging/vt6656/hostap.h                    |   58 -
 drivers/staging/vt6656/int.c                       |    5 +-
 drivers/staging/vt6656/iocmd.h                     |  387 -
 drivers/staging/vt6656/iowpa.h                     |   53 -
 drivers/staging/vt6656/iwctl.c                     |   64 +-
 drivers/staging/vt6656/key.c                       |   42 +-
 drivers/staging/vt6656/mac.c                       |  328 +-
 drivers/staging/vt6656/mac.h                       |   16 +-
 drivers/staging/vt6656/main_usb.c                  |  193 +-
 drivers/staging/vt6656/power.c                     |    7 +-
 drivers/staging/vt6656/rf.c                        |  137 +-
 drivers/staging/vt6656/rf.h                        |   12 +-
 drivers/staging/vt6656/rndis.h                     |  151 -
 drivers/staging/vt6656/rxtx.c                      |  753 +-
 drivers/staging/vt6656/rxtx.h                      |   12 +-
 drivers/staging/vt6656/srom.h                      |  112 -
 drivers/staging/vt6656/tcrc.c                      |  183 -
 drivers/staging/vt6656/tcrc.h                      |   38 -
 drivers/staging/vt6656/tether.c                    |    7 +-
 drivers/staging/vt6656/tether.h                    |    4 -
 drivers/staging/vt6656/usbpipe.c                   |  329 +-
 drivers/staging/vt6656/usbpipe.h                   |   11 +-
 drivers/staging/vt6656/wcmd.c                      |   92 +-
 drivers/staging/vt6656/wctl.c                      |    2 +-
 drivers/staging/vt6656/wmgr.c                      |   76 +-
 drivers/staging/vt6656/wpactl.c                    |    5 +-
 drivers/staging/winbond/wb35tx.c                   |    6 +-
 drivers/staging/winbond/wb35tx_s.h                 |    2 +-
 drivers/staging/wlags49_h2/wl_priv.c               |   14 +-
 drivers/staging/wlags49_h2/wl_wext.c               |   11 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |  227 +-
 drivers/staging/wlan-ng/p80211conv.c               |   31 +-
 drivers/staging/wlan-ng/p80211netdev.c             |  139 +-
 drivers/staging/wlan-ng/p80211req.c                |    9 +-
 drivers/staging/wlan-ng/prism2fw.c                 |  101 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |  123 +-
 drivers/staging/wlan-ng/prism2mgmt.h               |    5 +
 drivers/staging/wlan-ng/prism2mib.c                |    4 +-
 drivers/staging/wlan-ng/prism2sta.c                |   25 +-
 drivers/staging/wlan-ng/prism2usb.c                |  164 +-
 drivers/staging/xgifb/TODO                         |    3 +-
 drivers/staging/xgifb/XGI_main.h                   |    4 -
 drivers/staging/xgifb/XGI_main_26.c                |    3 +
 drivers/staging/xgifb/vb_def.h                     |    2 -
 drivers/staging/xgifb/vb_init.c                    |    2 +
 drivers/staging/xgifb/vb_setmode.c                 |    3 +
 drivers/staging/xgifb/vgatypes.h                   |    2 -
 drivers/staging/xillybus/xillybus.h                |    1 -
 drivers/staging/xillybus/xillybus_core.c           |    2 +-
 drivers/staging/xillybus/xillybus_of.c             |   47 +-
 drivers/staging/xillybus/xillybus_pcie.c           |   65 +-
 drivers/tty/goldfish.c                             |   68 +-
 include/linux/device.h                             |    6 +
 include/linux/goldfish.h                           |   15 +
 include/linux/hid-sensor-hub.h                     |    8 +-
 include/linux/hid-sensor-ids.h                     |    1 +
 include/linux/iio/common/st_sensors.h              |    4 +
 include/linux/iio/consumer.h                       |   13 +
 include/linux/iio/iio.h                            |   24 +
 include/linux/iio/types.h                          |    4 +
 994 files changed, 86457 insertions(+), 77562 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935
 create mode 100644 Documentation/devicetree/bindings/iio/proximity/as3935.txt
 create mode 100644 drivers/iio/accel/mma8452.c
 rename drivers/{staging/iio/adc/ad799x_core.c => iio/adc/ad799x.c} (80%)
 create mode 100644 drivers/iio/orientation/hid-sensor-rotation.c
 create mode 100644 drivers/iio/pressure/mpl115.c
 create mode 100644 drivers/iio/proximity/Kconfig
 create mode 100644 drivers/iio/proximity/Makefile
 create mode 100644 drivers/iio/proximity/as3935.c
 create mode 100644 drivers/iio/temperature/mlx90614.c
 delete mode 100644 drivers/staging/android/ram_console.h
 delete mode 100644 drivers/staging/et131x/Module.symvers
 delete mode 100644 drivers/staging/iio/adc/ad799x.h
 delete mode 100644 drivers/staging/iio/adc/ad799x_ring.c
 delete mode 100644 drivers/staging/lustre/lustre/include/ioctl.h
 delete mode 100644 drivers/staging/lustre/lustre/include/obd_lov.h
 delete mode 100644 drivers/staging/lustre/lustre/lov/lov_log.c
 delete mode 100644 drivers/staging/rtl8188eu/include/odm_interface.h
 create mode 100644 drivers/staging/rtl8192ee/Kconfig
 create mode 100644 drivers/staging/rtl8192ee/Makefile
 create mode 100644 drivers/staging/rtl8192ee/TODO
 create mode 100644 drivers/staging/rtl8192ee/base.c
 create mode 100644 drivers/staging/rtl8192ee/base.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbt_precomp.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8192e2ant.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8192e2ant.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b1ant.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b1ant.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b2ant.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8723b2ant.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a1ant.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a1ant.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a2ant.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtc8821a2ant.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/rtl_btc.c
 create mode 100644 drivers/staging/rtl8192ee/btcoexist/rtl_btc.h
 create mode 100644 drivers/staging/rtl8192ee/cam.c
 create mode 100644 drivers/staging/rtl8192ee/cam.h
 create mode 100644 drivers/staging/rtl8192ee/compat.h
 create mode 100644 drivers/staging/rtl8192ee/core.c
 create mode 100644 drivers/staging/rtl8192ee/core.h
 create mode 100644 drivers/staging/rtl8192ee/debug.c
 create mode 100644 drivers/staging/rtl8192ee/debug.h
 create mode 100644 drivers/staging/rtl8192ee/efuse.c
 create mode 100644 drivers/staging/rtl8192ee/efuse.h
 create mode 100644 drivers/staging/rtl8192ee/pci.c
 create mode 100644 drivers/staging/rtl8192ee/pci.h
 create mode 100644 drivers/staging/rtl8192ee/ps.c
 create mode 100644 drivers/staging/rtl8192ee/ps.h
 create mode 100644 drivers/staging/rtl8192ee/rc.c
 create mode 100644 drivers/staging/rtl8192ee/rc.h
 create mode 100644 drivers/staging/rtl8192ee/regd.c
 create mode 100644 drivers/staging/rtl8192ee/regd.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/def.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/dm.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/dm.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/fw.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/fw.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/hw.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/hw.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/led.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/led.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/phy.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/phy.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseq.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/pwrseqcmd.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/reg.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/rf.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/rf.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/sw.c
 rename drivers/staging/{rtl8188eu/include/drv_types_linux.h => rtl8192ee/rtl8192ee/sw.h} (51%)
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/table.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/table.h
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/trx.c
 create mode 100644 drivers/staging/rtl8192ee/rtl8192ee/trx.h
 create mode 100644 drivers/staging/rtl8192ee/stats.c
 create mode 100644 drivers/staging/rtl8192ee/stats.h
 create mode 100644 drivers/staging/rtl8192ee/wifi.h
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_io.c
 delete mode 100644 drivers/staging/rtl8723au/core/rtw_p2p.c
 delete mode 100644 drivers/staging/rtl8723au/include/cmd_osdep.h
 delete mode 100644 drivers/staging/rtl8723au/include/ethernet.h
 delete mode 100644 drivers/staging/rtl8723au/include/mp_custom_oid.h
 delete mode 100644 drivers/staging/rtl8723au/include/odm_types.h
 create mode 100644 drivers/staging/rtl8723au/include/rtl8723a_bt_intf.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_ioctl.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_p2p.h
 delete mode 100644 drivers/staging/rtl8723au/include/rtw_qos.h
 delete mode 100644 drivers/staging/rtl8723au/include/usb_hal.h
 delete mode 100644 drivers/staging/rtl8723au/include/usb_osintf.h
 delete mode 100644 drivers/staging/rtl8723au/include/usb_vendor_req.h
 delete mode 100644 drivers/staging/rtl8723au/os_dep/osdep_service.c
 delete mode 100644 drivers/staging/rts5139/Kconfig
 delete mode 100644 drivers/staging/rts5139/Makefile
 delete mode 100644 drivers/staging/rts5139/TODO
 delete mode 100644 drivers/staging/rts5139/debug.h
 delete mode 100644 drivers/staging/rts5139/ms.c
 delete mode 100644 drivers/staging/rts5139/ms.h
 delete mode 100644 drivers/staging/rts5139/ms_mg.c
 delete mode 100644 drivers/staging/rts5139/ms_mg.h
 delete mode 100644 drivers/staging/rts5139/rts51x.c
 delete mode 100644 drivers/staging/rts5139/rts51x.h
 delete mode 100644 drivers/staging/rts5139/rts51x_card.c
 delete mode 100644 drivers/staging/rts5139/rts51x_card.h
 delete mode 100644 drivers/staging/rts5139/rts51x_chip.c
 delete mode 100644 drivers/staging/rts5139/rts51x_chip.h
 delete mode 100644 drivers/staging/rts5139/rts51x_fop.c
 delete mode 100644 drivers/staging/rts5139/rts51x_fop.h
 delete mode 100644 drivers/staging/rts5139/rts51x_scsi.c
 delete mode 100644 drivers/staging/rts5139/rts51x_scsi.h
 delete mode 100644 drivers/staging/rts5139/rts51x_transport.c
 delete mode 100644 drivers/staging/rts5139/rts51x_transport.h
 delete mode 100644 drivers/staging/rts5139/sd.c
 delete mode 100644 drivers/staging/rts5139/sd.h
 delete mode 100644 drivers/staging/rts5139/sd_cprm.c
 delete mode 100644 drivers/staging/rts5139/sd_cprm.h
 delete mode 100644 drivers/staging/rts5139/trace.h
 delete mode 100644 drivers/staging/rts5139/xd.c
 delete mode 100644 drivers/staging/rts5139/xd.h
 delete mode 100644 drivers/staging/sbe-2t3e3/2t3e3.h
 delete mode 100644 drivers/staging/sbe-2t3e3/Kconfig
 delete mode 100644 drivers/staging/sbe-2t3e3/Makefile
 delete mode 100644 drivers/staging/sbe-2t3e3/TODO
 delete mode 100644 drivers/staging/sbe-2t3e3/cpld.c
 delete mode 100644 drivers/staging/sbe-2t3e3/ctrl.c
 delete mode 100644 drivers/staging/sbe-2t3e3/ctrl.h
 delete mode 100644 drivers/staging/sbe-2t3e3/dc.c
 delete mode 100644 drivers/staging/sbe-2t3e3/exar7250.c
 delete mode 100644 drivers/staging/sbe-2t3e3/exar7300.c
 delete mode 100644 drivers/staging/sbe-2t3e3/intr.c
 delete mode 100644 drivers/staging/sbe-2t3e3/io.c
 delete mode 100644 drivers/staging/sbe-2t3e3/main.c
 delete mode 100644 drivers/staging/sbe-2t3e3/maps.c
 delete mode 100644 drivers/staging/sbe-2t3e3/module.c
 delete mode 100644 drivers/staging/sbe-2t3e3/netdev.c
 create mode 100644 drivers/staging/skein/Kconfig
 create mode 100644 drivers/staging/skein/Makefile
 create mode 100644 drivers/staging/skein/TODO
 create mode 100644 drivers/staging/skein/skein.c
 create mode 100644 drivers/staging/skein/skein.h
 create mode 100644 drivers/staging/skein/skein_api.c
 create mode 100644 drivers/staging/skein/skein_api.h
 create mode 100644 drivers/staging/skein/skein_block.c
 create mode 100644 drivers/staging/skein/skein_block.h
 create mode 100644 drivers/staging/skein/skein_iv.h
 create mode 100644 drivers/staging/skein/threefish_api.c
 create mode 100644 drivers/staging/skein/threefish_api.h
 create mode 100644 drivers/staging/skein/threefish_block.c
 delete mode 100644 drivers/staging/unisys/include/guidutils.h
 delete mode 100644 drivers/staging/unisys/visorchipset/filexfer.c
 delete mode 100644 drivers/staging/unisys/visorchipset/filexfer.h
 delete mode 100644 drivers/staging/vt6656/aes_ccmp.c
 delete mode 100644 drivers/staging/vt6656/aes_ccmp.h
 delete mode 100644 drivers/staging/vt6656/control.c
 delete mode 100644 drivers/staging/vt6656/control.h
 delete mode 100644 drivers/staging/vt6656/device_cfg.h
 delete mode 100644 drivers/staging/vt6656/hostap.c
 delete mode 100644 drivers/staging/vt6656/hostap.h
 delete mode 100644 drivers/staging/vt6656/rndis.h
 delete mode 100644 drivers/staging/vt6656/srom.h
 delete mode 100644 drivers/staging/vt6656/tcrc.c
 delete mode 100644 drivers/staging/vt6656/tcrc.h
 create mode 100644 include/linux/goldfish.h
