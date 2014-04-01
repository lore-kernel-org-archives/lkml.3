Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaDASqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 14:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaDASp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 14:45:57 -0400
Date: Tue, 1 Apr 2014 11:48:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver patches for 3.15-rc1
Message-ID: <20140401184817.GA21855@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.15-rc1

for you to fetch changes up to 94debda32429e1a348fec8543245f1190a92d68c:

  staging: xillybus: XILLYBUS_PCIE depends on PCI_MSI (2014-03-21 12:24:09 -0700)

----------------------------------------------------------------
Staging driver pull request for 3.15-rc1

Here's the huge drivers/staging/ update for 3.15-rc1.

Loads of cleanup fixes, a few drivers removed, and some new ones added.

All have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (6):
      staging: octeon-ethernet: drop CONFIG_CAVIUM_OCTEON_NUM_PACKET_BUFFERS
      staging: octeon-ethernet: make num_packet_buffers static
      staging: octeon-ethernet: make cvm_oct_free_tx_skbs static
      staging: octeon-ethernet: make global_register_lock static
      staging: octeon-ethernet: add missing include
      staging: octeon-usb: prevent memory corruption

Alan (1):
      staging: et131x: fix allocation failures

Alexandre Belloni (1):
      iio: mxs-lradc: remove useless check

Alexey Khoroshilov (2):
      staging: dgap: remove unneeded status variables
      staging: dgap: implement proper error handling in dgap_start()

Alexey Lyashkov (1):
      lustre/mdc: use ibits_known mask for lock match

Ana Rey (93):
      staging: rtl8187se: Deleted rtl8180_len2duration functions in r8180_core.c
      staging: rtl8187se: Convert CHANNEL_LIST typedef into a struct.
      staging: rtl8187se: Clean-up comment line style in r8180_core.c
      staging: rtl8187se: Fixed whitespaces and indentations in r8180.h
      staging: rtl8187se: Clean-up comment line style in r8180.h
      staging: rtl8187se: Fixed open brace in r8180.h
      staging: rtl8187se: Fixed a pointer declaration error in r8180.h
      staging: rtl8187se: Added parenthesis in a macro in r8180.h
      staging: rtl8187se: Convert ChnlAccessSetting typedef into a struct.
      staging: rtl8187se: Convert Stats typedef into a struct
      staging: rtl8187se: Convert _link_detect_t typedef into a struct.
      staging: rtl8187se: Fix whitespaces in ieee80211/dot11d.h
      staging: rtl8187se: Convert buffer typedef into a struct
      staging: rtl8187se: Convert r8180_priv typedef into a struct
      staging: rtl8187se: Delete typedef _ThreeWire
      staging: rtl8187se: Convert _WIRELESS_MODE into a enum.
      staging: rtl8187se: Convert nic_t typedef into an enum
      staging: rtl8187se: Convert _LED_STRATEGY_8185 typedef into an enum
      staging: rtl8187se: Convert _RT_RF_POWER_STATE typedef into an enum
      staging: rtl8187se: Delete typedef _LED_CTL_MODE
      staging: rtl8187se: Convert _RT_PS_MODE typedef into an enum
      staging: rtl8187se: Delete commented code in r8180.h
      staging: rtl8187se: Deleted rtl8225z2_rf_set_mode function
      staging: rtl8187se: Fix whitespaces in ieee80211/ieee80211_crypt_tkip.c
      staging: rtl8187se: Fix braces in ieee80211/ieee80211_crypt_tkip.c
      staging: rtl8192u: make in r8192U_core.c the local functions static
      staging: rtl8192u: make in r8180_93cx6.c some local functions static
      staging: rts5139: make the local variable static
      staging: rts5139: Added in ms_mg.c an include to fix a sparse warning
      staging: rts5139: make thrts5139_usb_idse local variable static in rts51x.c
      staging: rts5139: Added in sd_cprm.c an include to fix a sparse warning
      staging: rtl8192u: Deleted 'alloc_tx_beacon_desc_ring' function in r8192U_core.c
      staging: rtl8192u: make in ieee80211/rtl819x_TSProc.c some local functions static
      staging: rtl8192u: make in ieee80211/rtl819x_HTProc.c some local functions static
      staging: rtl8192u: make in ieee80211/rtl819x_BAProc.c some local functions static
      staging: rtl8192u: Deleted 'rtl819xU_cmd_isr' function in r8192U_core.c
      staging: rtl8192u: Deleted 'rtl8192_set_mode' function in r8192U_core.c
      staging: rtl8192u: Deleted 'rtl8192_proc_module_remove' function in r8192U_core.c
      staging: rtl8192u: Deleted 'rtl8192_beacon_stop' function in r8192U_core.c
      staging: rtl8192u: Added in r819xU_firmware_img.c an include to fix a sparse warning
      staging: rtl8192u: make in ieee80211/ieee80211_tx.c some local functions static
      staging: rtl8192u: make in ieee80211/ieee80211_softmac.c some local functions static
      staging: rtl8192u: make in ieee80211/ieee80211_rx.c some local functions static
      staging: rtl8192u: Deleted 'HTUseDefaultSetting' function in ieee80211/rtl819x_HTProc.c
      staging: rtl8192u: make in r819xU_phy.c some local functions static
      staging: rtl8187se: Delete commented code
      staging: rtl8187se: Remove unnecessary blank lines
      staging: rtl8187se: Clean-up comment line style
      staging: rtl8187se: Re-write if statement with comment lines inside.
      staging: rtl8187se: Remove unused functions 'rsn_authen_cipher_suite' and 'ext_ieee80211_send_beacon_wq'
      staging: rtl8187se: Fix whitespaces in if-statement.
      staging: rtl8187se: Fix whitespace around else-statements
      staging: rtl8187se: Add necessary whitespaces in while and do-while statements.
      staging: rtl8187se: Delete braces are not necessary in ieee80211/ieee80211_softmac.c
      staging: rtl8187se: Add whitespaces between 'if' and the condition.
      staging: rtl8187se: Add whitespaces in while and for structures.
      staging: rtl8187se: Delete space prohibited between function name and open parenthesis
      staging: rtl8187se: Delete space prohibited after open parenthesis.
      staging: rtl8187se: Delete spaces prohibited around semicolons, colons and exclamations
      staging: rtl8187se: Add whitespaces around '+', '-' and '='
      staging: rtl8187se: Add whitespaces around commas
      staging: rtl8187se: Fix "code indent should use tabs where possible" error
      staging: rtl8187se: Add whitespaces around '+=' and '=='
      staging: rtl8187se: Add whitespaces around '&', '||' and '&&'
      staging: rtl8187se: Delete some innecesary whitespaces
      staging: rtl8187se: Move trailing statement to next line
      staging: rtl8187se: Fix pointer declarations in ieee80211/ieee80211_softmac.c
      staging: rtl8187se: Remove initialization of static variable in ieee80211/ieee80211_softmac.c
      staging: rtl8187se: Delete commented code
      staging: rtl8187se: Fix commend line
      staging: rtl8187se: Fix indent in switch statement.
      staging: rtl8187se: Convert from printk into netdev_err or netdev_info
      staging: rtl8187se: Use ether_addr_copy function
      staging: rtl8187se: Use min_t instead of min
      staging: rtl8187se: Delete unnecessary comment in r8180_core.c
      staging: rtl8187se: Delete commented code and whiteline
      staging: rtl8187se: Clean-up comment line style in r8180_rtl8225.h
      staging: rtl8192u: Delete commented code in ieee80211/dot11d.c
      staging: rtl8192u: Clean-up comment line style in ieee80211/dot11d.c
      staging: rtl8192u: Move open brace on the previous line
      staging: rtl8192u: Delete unnecesary braces in ieee80211/dot11d.c
      staging: rtl8192u: Add whitespace in ieee80211/dot11d.c
      staging: rtl8192u: fix coding style in function definition
      staging: rtl8192u: Move export_symbol below its function
      staging: rtl8192u: Convert from printk into netdev_err or netdev_info
      staging: rtl8192u: Fix whitespaces in function declarations in r8192U_dm.h
      staging: rtl8192u: Delete 'dm_change_fsync_setting' function in r8192U_dm.c
      staging: rtl8192u: Delete 'DM_CTSToSelfSetting' function in r8192U_dm.c
      staging: rtl8192u: Delete duplicate function declarations and extern keyword
      staging: rtl8192u: make in r819xU_firmware.c some local functions static
      staging: rtl8192u: Delete 'fwSendNullPacket' function in r819xU_firmware.c
      staging: rtl8192u: make in ieee80211/ieee80211_wx.c a local variable static
      staging: rtl8192u: make in r819xU_cmdpkt.c some local functions static

Andreas Dilger (2):
      staging/lustre/idl: remove LASSERT/CLASSERT from lustre_idl.h
      staging/lustre/llite: fix O_TMPFILE/O_LOV_DELAY_CREATE conflict

Andreea-Cristina Bernat (13):
      /drivers/staging/sbe2t3e3: Fixed left brace to be on the previous line
      drivers/staging/crystalhd/bcm_70012_regs.h: Fix line over 80 characters.
      /drivers/staging/dgrp: Fixed warning unchecked sscanf return value
      /dgrp: Fixed warning by adding fallthrough comment
      staging/media/solo6x10: Fix coding-style error
      /staging/vt6656: Delete extra paranthesis from macro definition
      staging: rtl8712: Delete space before semicolon
      staging: lirc: Add fallthrough comment
      staging: sep: Add fallthrough comment
      Staging: solo6x10: Replace expressions that don't use ALIGN macro
      Staging: unisys: Replace kmalloc/memset with kzalloc
      Staging: rtl8187se: Fix warning symbol should be static
      Staging: lirc: Fix warning: assignment of bool to 0/1

Andrew Perepechko (1):
      lustre/xattr: separate ACL and XATTR caches

Andriy Skulysh (1):
      staging/lustre/ptlrpc: flock deadlock detection does not work

Ann Koehler (1):
      lustre/osc: Don't flush active extents.

Archana Patni (2):
      iio: hid-sensors: Added Proximity Sensor Driver
      iio: hid-sensors: Added Pressure Sensor driver

Artem Blagodarenko (1):
      staging/lustre/mgs: set_param -P option that sets value permanently

Arve Hjønnevåg (1):
      staging: binder: Support concurrent 32 bit and 64 bit processes.

Ashley Smith (3):
      staging: vt6655 : Fix placement of open brace
      staging: bcm: Replace <asm/uaccess.h> by <linux/uaccess.h>
      staging: lustre: Remove extern keyword from function prototypes

Axel Rasmussen (9):
      drivers: staging: rtl8187se: use netdev_* instead of prink
      drivers: staging: rtl8187se: refactor/clean signal smoothing
      drivers: staging: rtl8187se: wrap excessively long lines
      drivers: staging: rtl8187se: wrap excessively long lines
      drivers: staging: rtl8187se: wrap excessively long lines
      drivers: staging: rtl8187se: fixed broken indentation
      drivers: staging: rtl8187se: fixed checkpatch.pl errors
      drivers: staging: rtl8187se: wrap excessively long lines
      drivers: staging: rtl8187se: refactor wmm_param_update

Aybuke Ozdemir (30):
      drivers/staging/rts5139:xd.c: Fix line over 80 characters.
      staging: solo6x10: solo6x10-v4l2-enc.c: Fix line over 80 characters.
      staging: core: tiomap3430.c Fix line over 80 characters.
      drivers/staging/crystalhd:crystalhd_lnx.c: Fix line over 80 characters.
      staging: gdm724x: gdm_usb.c: Fix line over 80 characters.
      staging: octeon: ethernet-mdio.c Fix line over 80 characters.
      staging: go7007: go7007-v4l2.c Fix line over 80 characters.
      staging: nokia_h4p: nokia_fw-bcm.c Fix line over 80 characters.
      staging: vt6656: power.c Fix line over 80 characters.
      staging: bcm: Typedefs.h Fix do not use // c99 comments.
      staging: bcm: Typedefs.h Fix "foo * bar" warning.
      staging: iio: addac: adt7316.h Fix Unnecessary space after function pointer name
      staging: iio: light: Checkpatch fixes tsl2x7x_core.c
      staging: octeon: octeon-ethernet.h Fix Unnecessary space after function pointer name
      drivers/staging/dgrp:dgrp_tty.c: Fix line over 80 characters.
      staging: media: omap24xx: tcm825x.c Fix that open brace { should be on the previous line
      drivers/staging/serqt_usb2:serqt_usb2.c Fix line over 80 characters.
      staging: imx-drm: imx-ldb.c Fix line over 80 characters.
      staging/silicom/bypasslib/bp_ioctl.h Fix do not add new typedefs.
      staging/rtl8712/osdep_service.h Fix line over 80 characters.
      staging: addac: adt7316.c: Fix line over 80 characters
      staging/speakup:speakup_dectlk.c Fix line over 80 characters.
      staging/octeon:ethernet-rgmii.c: Fix line over 80 characters.
      staging:lustre:lnet: lib-types.h Fix unnecessary space func. pointer name.
      staging:lustre:lnet: lib-types.h Fix open brace '{' err.
      staging/tidspbridge/rmgr/mgr.c Fix quoted string split across lines
      staging: adc: mxs-lradc.c Fix line over 80 characters.
      staging: as102: as10x_handle.h .Fix Unnecessary space after function pointer name
      staging/media/davinci_vpfe/vpfe_video.h Fix missing space after return type
      staging/media/davinci_vpfe/vpfe_video.h Unnecessary space after function pointer name

Benjamin Romer (1):
      staging: unisys: update MAINTAINERS and TODO

Beomho Seo (1):
      iio: ak8975: Add device name

Bobi Jam (1):
      lustre/lov: avoid subobj's coh_parent race

Boris BREZILLON (1):
      iio: at91: document ADC clock properties

Bruno Faccini (1):
      lustre/ldlm: set l_lvb_type coherent when layout is returned

Chase Southwood (27):
      Staging: comedi: remove unnecessary braces in pcl711.c
      Staging: comedi: convert while loop to timeout in ni_mio_common.c
      Staging: comedi: fix memory leak in comedi_bond.c
      Staging: comedi: Correct a few printf format codes
      Staging: comedi: clean up conditional statement in addi_apci_3xxx.c
      Staging: comedi: kcomedilib: replace deprecated simple_strtoul() with kstrtouint()
      Staging: comedi: addi-data: fix brace-related coding style issues in hwdrv_apci035.c
      Staging: comedi: addi-data: cleanup comments in hwdrv_apci035.c
      Staging: comedi: addi-data: convert printk() to dev_err()
      Staging: comedi: addi-data: do not initialize statics to 0 in hwdrv_apci035.c
      Staging: comedi: addi-data: cleanup comments in hwdrv_apci1564.c
      Staging: comedi: addi-data: cleanup brace usage in hwdrv_apci1564.c
      Staging: comedi: addi-data: replace printk() with dev_err() in hwdrv_apci1564.c
      Staging: comedi: addi-data: don't initialize a static variable to 0
      Staging: comedi: addi-data: comment cleanup in hwdrv_apci035.c
      Staging: comedi: addi-data: cleanup conditional blocks in hwdrv_apci035.c
      Staging: comedi: addi-data: fix a couple of lines that are too long
      Staging: comedi: addi-data: clean-up variable use in hwdrv_apci035.c
      Staging: comedi: addi-data: remove unnecessary variable initializations in hwdrv_apci035.c
      Staging: comedi: addi-data: tidy up digital input register map defines in hwdrv_apci1564.c
      Staging: comedi: addi-data: tidy up digital output register map defines in hwdrv_apci1564.c
      Staging: comedi: addi-data: tidy up watchdog register
      Staging: comedi: addi-data: tidy up timer register map defines in hwdrv_apci1564.c
      Staging: comedi: addi-data: tidy up counter register map defines in hwdrv_apci1564.c
      Staging: comedi: convert while loops to timeouts in s626.c
      Staging: comedi: propagate timeout errors in s626.c
      Staging: comedi: addi-data: style cleanups in hwdrv_apci1564.c

Chi Pham (10):
      staging:rtl8187se: Removed assignments from if statements in ieee80211/ieee80211_softmac.c.
      staging:vt6656: Removed assignment in if statement.
      staging:wlags49_h2: Removed assignments from if statements.
      staging: rtl8192u: Removed assignments from if statements.
      staging: cxt1e1: Removed assignments from if statements.
      staging:dgnc: Removed assignments from if statements.
      staging:rtl8188eu: Removed assignments in if statements.
      staging:lustre: Removed assignments from if statements.
      staging:media: Removed assignments from if statements.
      staging: rtl8188eu: Reduced nesting and improved coding style.

Colin Cross (5):
      staging: android: Split uapi out of android_alarm.h
      staging: android: Split uapi out of ashmem.h
      staging: android: split uapi out of sync.h and sw_sync.h
      staging: android: Split uapi out of binder.h
      staging: ion: Move shrinker out of heaps

Conrad Meyer (4):
      Staging: comedi: Fix 80-char line limit style issue in addi_apci_1500.c
      Staging: comedi: Fix some raw printks with dev_warn()
      Staging: comedi: Kill comment art in hwdrv_apci1500.c
      Staging: comedi: do not initialize statics to 0 (apci1500)

Cédric Cabessa (2):
      staging: usbip: fix quoted string split across lines
      staging: usbip: fix line over 80 characters

Daeseok Youn (25):
      staging : ion : Fix some checkpatch warnings and an error
      staging: android: timed_output: fix a checkpatch warning
      staging : android : sync : fix a checkpatch warning
      staging: ced401: fix double unlock bug
      staging: bcm: Remove unneeded set a variable
      staging: bcm: fix checkpatch error 'assignment in if condition'
      staging: lustre: make functions as static
      staging: cxt1e1: remove unused variable
      staging: cxt1e1: remove space between function name and parenthesis
      staging: cxt1e1: Fix no spaces at the start of a line in hwprobe.c
      Staging: cxt1e1: Fix line length over 80 characters in hwprobe.c
      staging: cxt1e1: fix checkpatch error 'assignment in if condition'
      staging: cxt1e1: fix checkpatch errors with open brace '{'
      staging: cxt1e1: remove space between function name and parenthesis
      staging: cxt1e1: Fix no spaces at the start of a line in linux.c
      staging: cxt1e1: Fix line length over 80 characters in linux.c
      staging: cxt1e1: fix checkpatch error 'assignment in if condition'
      staging: cxt1e1: fix checkpatch errors with open brace '{'
      staging: frontier: fix memory leak in usb_alphatrack_probe()
      staging: cxt1e1: remove redundant memset() call
      staging: cxt1e1: remove redundant memset() call
      staging: dgnc: replace unnecessary while() with if()
      staging: unisys: remove incorrect error handling after queue_delayed_work
      staging: cxt1e1: remove unneeded mkret() calls
      staging: unisys: replace kzalloc/kfree with UISMALLOC/UISFREE

Dan Carpenter (10):
      iio:imu:adis16400 remove an unneeded check
      iio: dac: ad7303: remove an unneeded check
      staging: cxt1e1: cleanup mfg_template[] a bit
      staging: rtl8821ae: a couple macro expansion bugs
      staging: gdm724x: cleanup alloc_tx_sdu_struct()
      staging/bcm: two information leaks in ioctl
      staging/bcm: integer underflow leads to Oom
      staging: rtl8712: fix some confusing indenting
      Staging: rtl8712: fix an error test in start_drv_threads()
      staging: unisys/uislib: kthread_create() returns an ERR_PTR

Daniel Ngu (2):
      Staging: gdm724x: netlink_k.c: fixed coding style
      Staging: gdm724x: gdm_mux.c: fixed coding style

Dave Hansen (1):
      staging: rtl8192u: remove unused files

Dave Jones (39):
      staging: lustre: remove unnecessary 'magic' from lustre_pack_request
      staging/bcm: move IOCTL_BCM_REGISTER_READ_PRIVATE case out to its own function.
      staging/bcm: move IOCTL_BCM_REGISTER_WRITE_PRIVATE case out to its own function.
      staging/bcm: move IOCTL_BCM_EEPROM_REGISTER_READ case out to its own function.
      staging/bcm: move IOCTL_BCM_EEPROM_REGISTER_WRITE case out to its own function.
      staging/bcm: move IOCTL_BCM_GPIO_SET_REQUEST case out to its own function.
      staging/bcm: move BCM_LED_THREAD_STATE_CHANGE_REQ case out to its own function.
      staging/bcm: move IOCTL_BCM_GPIO_STATUS_REQUEST case out to its own function.
      staging/bcm: move IOCTL_BCM_GPIO_MULTI_REQUEST case out to its own function.
      staging/bcm: move IOCTL_BCM_GPIO_MODE_REQUEST case out to its own function.
      staging/bcm: move several request ioctl cases out to its own function.
      staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD_START case out to its own function.
      staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD case out to its own function.
      staging/bcm: move IOCTL_BCM_BUFFER_DOWNLOAD_STOP case out to its own function.
      staging/bcm: move IOCTL_CHIP_RESET case out to its own function.
      staging/bcm: move IOCTL_QOS_THRESHOLD case out to its own function.
      staging/bcm: move IOCTL_BCM_SWITCH_TRANSFER_MODE case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_DRIVER_VERSION case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_CURRENT_STATUS case out to its own function.
      staging/bcm: move IOCTL_BCM_SET_MAC_TRACING case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_DSX_INDICATION case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_HOST_MIBS case out to its own function.
      staging/bcm: move IOCTL_BCM_BULK_WRM case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_NVM_SIZE case out to its own function.
      staging/bcm: move IOCTL_BCM_CAL_INIT case out to its own function.
      staging/bcm: move IOCTL_BCM_SET_DEBUG case out to its own function.
      staging/bcm: move IOCTL_BCM_NVM_[READ|WRITE] cases out to their own function.
      staging/bcm: move IOCTL_BCM_FLASH2X_SECTION_READ case out to its own function.
      staging/bcm: move IOCTL_BCM_FLASH2X_SECTION_WRITE case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_FLASH2X_SECTION_BITMAP case out to its own function.
      staging/bcm: move IOCTL_BCM_SET_ACTIVE_SECTION case out to its own function.
      staging/bcm: formatting cleaning for IOCTL_BCM_IDENTIFY_ACTIVE_SECTION
      staging/bcm: move IOCTL_BCM_COPY_SECTION case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_FLASH_CS_INFO case out to its own function.
      staging/bcm: move IOCTL_BCM_SELECT_DSD case out to its own function.
      staging/bcm: move IOCTL_BCM_NVM_RAW_READ case out to its own function.
      staging/bcm: move IOCTL_BCM_CNTRLMSG_MASK case out to its own function.
      staging/bcm: move IOCTL_BCM_GET_DEVICE_DRIVER_INFO case out to its own function.
      staging/bcm: move IOCTL_BCM_TIME_SINCE_NET_ENTRY case out to its own function.

Davide Berardi (1):
      staging: line6: long line fixes

Denis CIOCCA (1):
      iio:pressure: Add support for LPS25H pressure sensor

Ebru Akagunduz (20):
      Staging:media: Fix Sparse Warnings "symbol was not declared. Should it be static?"
      Staging:media: Fix Sparse warnings incorrect type in lirc_sasem.c
      Staging:wlan-ng: no space before tabs in p80211mgmt.h
      Staging:rtl8188eu: fix kfree(NULL) is safe this check is probably not required in rtw_ap.c
      Staging:wlags49_h25: Fix sparse warning for static declarations
      Staging:dgap: Fix open brace '{' following struct go on the same line in dgap.h
      Staging:dgap: Fix "foo * bar" should be "foo *bar" in dgap.h
      Staging:nvec: fix quoted string split across lines
      Staging:winbond: Fix line over 80 characters in wb35rx.c
      Staging:ft1000: Fix __packed is preferred over __attribute__((packed)) in ft1000_ioctl.h
      Staging:frontier: Fix quoted string split across lines
      Staging:dgap: Fix Macros with complex values should be enclosed in dgap.h
      Staging: wlan-ng: Fix do not add new typedefs in p80211mgmt.h
      Staging: bcm: fix line over 80 characters in Bcmchar.c
      Staging: bcm: Removed unreachable code line in Bcmchar.c
      Staging: winbond: Fix printk() should include KERN_ facility level in wb35rx.c
      Staging: comedi: Fix missing space after return type in s626.c
      Staging: comedi: Fix line over 80 characters in s626.c
      Staging: cxt1e1: Fix use of volatile is usually wrong in comet.c
      Staging: cxt1e1: Fix externs should be avoided in .c files in comet.c

Elena Oat (28):
      Staging: usbip: Fix the warning of unchecked sscanf return value.
      Staging: sbe-2t3e3: Fix the error of (foo*) should be (foo *).
      Staging: rtl8188eu: Fix the warning of space before parenthesis.
      Staging: rtl8188eu: Fix warning of no space before tabs.
      Staging: rtl8188eu: Fix warning of kfree check is not required.
      Staging: rtl8188eu: Fix warning of braces {} are not necessary.
      Staging: rtl8188eu: Fix warning of prefer ether_addr_copy().
      Staging: rtl8188eu: Fix warning of printk should include KERN_.
      Staging: rtl8188eu: Fix warning braces {} are not necessary.
      Staging: rtl8188eu: Fix warning of spaces at the start of a line.
      Staging: rtl8188eu: Fix warning of space before tabs.
      Staging: rtl8188eu: Fix warning of unnecessary parentheses.
      Staging: rtl8188eu: Fix warning of space prohibited before semicolon.
      Staging: rtl8188eu: Fix warning of suspect code indent.
      Staging: rtl8188eu: Fix warning of prefer ether_addr_copy.
      Staging: rtl8188eu: Fix warning of unchecked sscanf return value.
      Staging: rtl8188eu: Fix sparse warnings.
      Staging: rtl8188eu: Replace rtw_zmalloc with kzalloc.
      Staging: rtl8188eu: Fix warning of unchecked sscanf return value.
      Staging: rtl8188eu: Fix warning of printk() should include KERN_ facility level.
      Staging: rtl8188eu: Fix warning of braces {} are not necessary.
      Staging: rtl8188eu: Fix warnings of space prohibited.
      Staging: rtl8188eu: Fix warnings of no space before tabs.
      Staging: rtl8188eu: Fix warning of space prohibited.
      Staging: rtl8188eu: Fix warnings of no space before tabs.
      Staging: rtl8188eu: Fix warning of braces not necessary.
      Staging: rtl8188eu: Fix warning of space prohibited.
      Staging: rtl8188eu: Fix warning of braces are not necessary.

Eli Billauer (2):
      staging: xillybus: Added "select CRC32" for XILLYBUS in Kconfig
      staging: xillybus: XILLYBUS_PCIE depends on PCI_MSI

Fabio Estevam (9):
      imx-drm: imx-hdmi: Remove parentheses from returns
      iio: mxs-lradc: Propagate the real error code on platform_get_irq() failure
      staging: ion: ion_cma_heap: Remove '0x' when using %pa format
      imx-drm: imx-ldb: Check 'mode' pointer first
      imx-drm: parallel-display: Check 'mode' pointer first
      imx-drm: ipuv3-plane: Use %pad to print 'dma_addr_t'
      imx-drm: imx-drm-core: Staticize imx_drm_find_crtc()
      imx-drm: ipu-dmfc: Remove unneeded 'dmfc' check
      imx-drm: imx-ldb: Use snprintf()

Fengguang Wu (4):
      staging: fpgaboot: fix coccinelle warnings
      staging: fpgaboot: fix coccinelle warnings
      staging/lustre: fix coccinelle warnings
      staging: r8188eu: fix coccinelle warnings

Fred Akers (4):
      Staging: comedi: range: tidy up comedi_check_chanlist()
      Staging: comedi: range: remove unnecessary sanity check
      Staging: comedi: addi-data: Fix long CamelCase function names
      Staging: Comedi: addi-data: Clean up function comments

Fugang Duan (2):
      iio:adc:imx: add Freescale Vybrid vf610 adc driver
      Documentation: add the binding file for Freescale vf610 ADC driver

Gary Rookard (8):
      Staging: bcm: DDRInit: fix up spacing issues.
      Staging: rtl8821ae: fix up some spacing issues.
      Staging: bcm: DDRInit: fix up indentation issues.
      Staging: lustre: fid: fix split strings.
      Staging: lustre: fld: fix split string.
      Staging: lustre: fld: fix spacing issue.
      Staging: lustre: fld: fix split strings.
      Staging: bcm: CmHost: moved and removed declarations and tmp bracing.

Gary Servin (1):
      staging: olpc_dcon: Trivial: Remove space before indentation.

Georgiana Rodica Chelu (7):
      staging/rts5208/rtsx_scsi.c: Remove unnecessary parentheses
      staging: rts5139: Fix quoted string split across lines
      staging: android: Use devm_kzalloc instead of kzalloc
      Staging: crystalhd: prefer pr_warn to printk(KERN_WARNING)
      staging: android: Remove whitespace issue
      staging: luster: do not combine value 0 with |
      staging: lustre: add an extra line

Gokulnath A (1):
      staging:rtl8821ae: trailing whitespace cleanup in pci.c

Greg Kroah-Hartman (15):
      staging: vt6656: fix indentation in if statement
      Merge branch 'staging-linus' into staging-work
      Merge tag 'iio-for-3.15a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.14-rc3 into staging-next
      Merge tag 'iio-for-3.15b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.14-rc4 into staging-next.
      Merge branch 'imx-drm-staging' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-next
      staging: sm7xxfb: remove driver
      staging: echo: move to drivers/misc/
      staging: sb105x: delete the driver
      Merge 3.14-rc5 into staging-next
      Merge tag 'iio-for-3.15c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge branch 'imx-drm-staging' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-next
      Merge branch 'for-greg' of git://git.kernel.org/.../ppwaskie/staging into opw
      Merge 3.14-rc7 into staging-next

Gulsah Kose (32):
      staging: rtl8712: Remove unnecessary parentheses.
      staging: rts5208: Fix line over 80 characters.
      staging: rts5208: Remove unnecessary parentheses.
      staging: slicoss: Fix unnecessary line continuations
      staging: gdm724x: Fix line over 80 characters.
      staging: vt6655: Fix line over 80 characters.
      staging: silicom: Fix line over 80 characters.
      staging: frontier: Fix quoted string split across lines
      staging: nokia_h4p: Fix quoted string split across lines
      staging: crystalhd: Fix no space before tabs
      staging: line6: Fix line over 80 characters
      staging: dgnc: Fix quoted string split across lines warning
      staging: cxt1e1: Fix space prohibited between function name and open parenthesis
      staging: winbond: Moved trailing statement to next line
      staging: cxt1e1: Fix line over 80 characters.
      staging: cxt1e1: Fix do not use // c99 comments
      staging: nokia_h4p: Fix line over 80 characters.
      staging: rtl8821ae: Fix code indent should use tabs where possible
      staging: rtl8821ae: Fix unnecessary whitespace before a quoted newline
      staging: rtl8821ae: Fix do not use C99 // comments
      staging: rtl8821ae: Fix space required before the open parenthesis '('
      staging: rtl8821ae: Fix quoted string split across lines
      staging: rtl8821ae: Fix no space before tabs.
      staging:imx-drm: Fix line over 80 characters.
      staging: rts5208: Fix line over 80 characters.
      staging: rtl8712: Fix multiple spaces after return type
      staging: rtl8192e: Fix quoted string split across lines
      staging: rtl8821ae: Fix suspect code indent for conditional statements
      staging: rtl8821ae: Fix braces {} are not necessary.
      staging: winbond: Fix line over 80 characters.
      staging: ft1000: Fix line over 80 characters.
      staging: nokia_h4p: Fix quoted string split across lines

H Hartley Sweeten (335):
      staging: comedi: drivers: propogate errno from subdev_8255_init()
      staging: comedi: amplc_pc236: remove dev_err() message due to allocation failure
      staging: comedi: amplc_pci230: standardize error handling of subdev_8255_init()
      staging: comedi: drivers: remove final 'attach' messages
      staging: comedi: drivers: return '0' for successful attach
      staging: comedi: introduce comedi_timeout()
      staging: comedi: skel: use comedi_timeout()
      staging: comedi: adl_pci6208x: use comedi_timeout()
      staging: comedi: das16: use comedi_timeout()
      staging: comedi: das800: use comedi_timeout()
      staging: comedi: ii_pci20kc: use comedi_timeout()
      staging: comedi: mf6x4: use comedi_timeout()
      staging: comedi: ni_labpc: use comedi_timeout()
      staging: comedi: pcl711: use comedi_timeout()
      staging: comedi: pcmad: use comedi_timeout()
      staging: comedi: pcmmio: use comedi_timeout()
      staging: comedi: dt2815: use comedi_timeout()
      staging: comedi: rti800: use comedi_timeout()
      staging: comedi: aio_aio12_8: use comedi_timeout()
      staging: comedi: cb_das16_cs: use comedi_timeout()
      staging: comedi: cb_pcidas: use comedi_timeout()
      staging: comedi: cb_pcidas64: use comedi_timeout()
      staging: comedi: cb_pcimdas: use comedi_timeout()
      staging: comedi: das08: use comedi_timeout()
      staging: comedi: das16m1: use comedi_timeout()
      staging: comedi: dt2811: use comedi_timeout()
      staging: comedi: me_daq: use comedi_timeout()
      staging: comedi: mpc624: use comedi_timeout()
      staging: comedi: s526: use comedi_timeout()
      staging: comedi: addi_apci_3xx: use comedi_timeout()
      staging: comedi: ni_at_a2150: use comedi_timeout()
      staging: comedi: ni_atmio16d: use comedi_timeout()
      staging: comedi: adl_pci9111: use comedi_timeout()
      staging: comedi: adl_pci9118: use comedi_timeout()
      staging: comedi: adv_pci1710: use comedi_timeout()
      staging: comedi: adq12b: use comedi_timeout()
      staging: comedi: amplc_pci230: use comedi_timeout()
      staging: comedi: dyna_pci10xx: use comedi_timeout()
      staging: comedi: icp_multi: use comedi_timeout()
      staging: comedi: multiq3: use comedi_timeout()
      staging: comedi: ni_daq_700: use comedi_timeout()
      staging: comedi: rtd520: use comedi_timeout()
      staging: comedi: s626: use comedi_timeout()
      staging: comedi: dt282x: use comedi_timeout()
      staging: comedi: daqboard2000: use comedi_timeout()
      staging: comedi: pcl812: use comedi_timeout()
      staging: comedi: pcl816: use comedi_timeout()
      staging: comedi: pcl818: use comedi_timeout()
      staging: comedi: dt2814: use comedi_timeout()
      staging: comedi: dmm32at: use comedi_timeout()
      staging: comedi: move (*insn_{read, write}) timeout debug messages to core
      staging: comedi: don't clear 'data' on (*insn_read) timeout
      staging: comedi: usbduxfast: 'cmd->chanlist_len' was already validataed
      staging: comedi: usbduxfast: remove TRIG_TIMER from scan_begin_src
      staging: comedi: adl_pci9111: trigger sources are validated in (*do_cmdtest)
      staging: comedi: cb_das16_cs: remove incomplete async command support
      staging: comedi: cb_pcidas: trigger sources are validated in (*do_cmdtest)
      staging: comedi: comedi_test: trigger sources are validated in (*do_cmdtest)
      staging: comedi: das800: trigger sources are validated in (*do_cmdtest)
      staging: comedi: pcl812: trigger sources were validated in (*do_cmdtest)
      staging: comedi: pcl816: trigger sources were validated in (*do_cmdtest)
      staging: comedi: pcl812: convert boardinfo declaration to C99 format
      staging: comedi: pcl816: convert boardinfo declaration to C99 format
      staging: comedi: pcl818: convert boardinfo declaration to C99 format
      staging: comedi: pcl812: remove 0/NULL initialzation in boardinfo
      staging: comedi: pcl818: remove 0/NULL initialzation in boardinfo
      staging: comedi: pcl812: remove 'io_range' from boardinfo
      staging: comedi: pcl816: remove 'io_range' from boardinfo
      staging: comedi: pcl818: remove 'io_range' from boardinfo
      staging: comedi: pcl812: remove 'i8254_osc_base' from boardinfo
      staging: comedi: pcl816: remove 'i8254_osc_base' from boardinfo
      staging: comedi: pcl812: remove 'rangelist_ao' from boardinfo
      staging: comedi: pcl816: remove 'rangelist_ao' from boardinfo
      staging: comedi: pcl818: remove 'rangelist_ao' from boardinfo
      staging: comedi: pcl812: clarify dma channel request in pcl812_attach()
      staging: comedi: pcl816: clarify dma channel request in pcl816_attach()
      staging: comedi: pcl818: clarify dma channel request in pcl818_attach()
      staging: comedi: pcl812: rename 'haveMPC508' in boardinfo
      staging: comedi: pcl818: change 'is_818' in boardinfo to a bit-field
      staging: comedi: pcl812: tidy up digital subdevice boardinfo
      staging: comedi: pcl818: all board types have digital inputs and outputs
      staging: comedi: pcl816: all board types have digital inputs and outputs
      staging: comedi: pcl812: factor analog input range selection out of (*attach)
      staging: comedi: pcl818: factor analog input range selection out of (*attach)
      staging: comedi: pcl812: all board types have analog inputs
      staging: comedi: pcl816: all board types have 16 analog inputs
      staging: comedi: pcl818: all board types have analog inputs
      staging: comedi: pcl812: tidy up differential ai user option
      staging: comedi: pcl816: remove 'n_ranges' from boardinfo
      staging: comedi: pcl818: remove 'n_ranges' from boardinfo
      staging: comedi: pcl816: remove 'ao_chanlist' from boardinfo
      staging: comedi: pcl816: remove 'ai_range_type' from boardinfo
      staging: comedi: pcl818: clarify irq request in pcl818_attach()
      staging: comedi: pcl818: remove 'ai_maxdata' from boardinfo
      staging: comedi: pcl818: remove 'ao_maxdata' from boardinfo
      staging: comedi: pcl812: remove 'ai_maxdata' from boardinfo
      staging: comedi: pcl812: introduce pcl812_ai_get_sample()
      staging: comedi: pcl816: introduce pcl816_ai_get_sample()
      staging: comedi: pcl818: introduce pcl818_ai_get_sample()
      staging: comedi: pcl812: remove 'ai_is16b' from private data
      staging: comedi: pcl812: remove acl8216_ai_insn_read()
      staging: comedi: pcl812: remove 'valid' from private data
      staging: comedi: pcl812: remove 'ai_scans' from private data
      staging: comedi: pcl816: remove 'ai_scans' from private data
      staging: comedi: pcl818: remove 'ai_scans' from private data
      staging: comedi: pcl812: remove 'ai_n_chan' from private data
      staging: comedi: pcl816: remove 'ai_n_chan' from private data
      staging: comedi: pcl818: remove 'ai_n_chan' from private data
      staging: comedi: pcl812: remove 'ai_flags' from private data
      staging: comedi: pcl818: remove 'ai_flags' from private data
      staging: comedi: pcl812: tidy up dma buffer allocation
      staging: comedi: pcl816: tidy up dma buffer allocation
      staging: comedi: pcl818: tidy up dma buffer allocation
      staging: comedi: pcl816: remove 'last_int_sub' from private data
      staging: comedi: pcl818: remove 'last_int_sub' from private data
      staging: comedi: pcl812: use 8253.h helpers
      staging: comedi: pcl816: use 8253.h helpers
      staging: comedi: pcl818: use 8253.h helpers
      staging: comedi: pcl816: remove unneeded forward declarations
      staging: comedi: pcl812: don't calc the timer divisors twice
      staging: comedi: pcl818: don't calc the timer divisors twice
      staging: comedi: pcl812: use subdevice (*cancel)
      staging: comedi: pcl818: use subdevice (*cancel)
      staging: comedi: pcl818: remove analog output interrupt code
      staging: comedi: pcl818: remove 'ai_timer[12]' from private data
      staging: comedi: pcl812: remove 'ai_chanlist' from private data
      staging: comedi: pcl818: remove 'ai_chanlist' from private data
      staging: comedi: pcl812: convert private data flags to bit-fields
      staging: comedi: pcl818: convert private data flags to bit-fields
      staging: comedi: pcl818: rename 'irq_blocked' in private data
      staging: comedi: pcl812: remove unnecessary function separation comments
      staging: comedi: pcl818: remove unnecessary function separation comments
      staging: comedi: pcl818: tidy up pcl818_check()
      staging: comedi: pcl812: allocate private data before requesting the I/O region
      staging: comedi: pcl818: kzalloc'ed memory does not need to be cleared
      staging: comedi: pcl816: remove 'ai_ns_min' from boardinfo
      staging: comedi: pcl816: remove 'n_aochan' from boardinfo
      staging: comedi: pcl816: clarify irq request in pcl816_attach()
      staging: comedi: pcl816: don't calc the timer divisors twice
      staging: comedi: pcl816: use subdevice (*cancel)
      staging: comedi: pcl816: remove 'ai_act_chanlist_{len, pos}' from private data
      staging: comedi: pcl816: convert private data flags to bit-fields
      staging: comedi: pcl816: kzalloc'ed memory does not need to be cleared
      staging: comedi: pcl816: rename 'irq_blocked' in private data
      staging: comedi: pcl816: remove unnecessary 'dev->irq' check
      staging: comedi: pcl816: remove unnecessary function separation comments
      staging: comedi: pcl816: tidy up pcl818_check()
      staging: comedi: ke_counter: remove CNT_CARD_DEVICE_ID
      staging: comedi: ke_counter: define the register map
      staging: comedi: ke_counter: tidy up the subdevice init
      staging: comedi: ke_counter: fix ke_counter_insn_write()
      staging: comedi: ke_counter: fix ke_counter_insn_read()
      staging: comedi: ke_counter: rename cnt_auto_attach()
      staging: comedi: ke_counter: add digital output support
      staging: comedi: ke_counter: tidy up multi-line comments
      staging: comedi: ke_counter: update the MODULE_DESCRIPTION
      staging: comedi: pcl816: remove pcl816_check()
      staging: comedi: pcl818: remove pcl818_check()
      staging: comedi: pcl818: fix board resource region request
      staging: comedi: pcl812: remove 'ai_neverending' from private data
      staging: comedi: pcl816: remove 'ai_neverending' from private data
      staging: comedi: pcl818: remove 'neverending_ai' from private data
      staging: comedi: pcl812: factor out dma setup to helper functions
      staging: comedi: pcl816: factor out dma setup to helper functions
      staging: comedi: pcl818: factor out dma setup to helper functions
      staging: comedi: pcl812: remove 'ai_data_len' from private data
      staging: comedi: pcl816: remove 'dmasamplesize' from private data
      staging: comedi: pcl812: interrupt handlers should not busywait
      staging: comedi: pcl818: interrupt handlers should not busywait
      staging: comedi: pcl816: remove unreachable interrupt handler code
      staging: comedi: pcl816: only hook up async command support if DMA is available
      staging: comedi: pcl812: factor out the common "next ai chan" code
      staging: comedi: pcl816: factor out the "next ai chan" code
      staging: comedi: pcl818: factor out the common "next ai chan" code
      staging: comedi: pcl818: fix PCL818_FI_DATAHI
      staging: comedi: pcl818: introduce pcl818_ai_get_fifo_sample()
      staging: comedi: pcl818: factor out the common "dropout" detect code
      staging: comedi: pcl816: reduce indent level in pcl816_ai_cancel()
      staging: comedi: pcl818: reduce indent level in pcl818_ai_cancel()
      staging: comedi: pcl816: clarify 'irq_was_now_closed' flag in private data
      staging: comedi: pcl818: fix (*cancel) when cmd->stop_src == TRIG_NONE
      staging: comedi: pcl812: remove "spurious interrupt" noise
      staging: comedi: pcl816: exit interrupt quick when there is nothing to do
      staging: comedi: pcl818: exit interrupt quick when there is nothing to do
      staging: comedi: pcl816: remove 'int816_mode' from private data
      staging: comedi: pcl818: remove 'ai_mode' from private data
      staging: comedi: pcl812: consolidate the common interrupt code
      staging: comedi: pcl816: consolidate the interrupt code
      staging: comedi: pcl818: consolidate the common interrupt code
      staging: comedi: pcl812: tidy up the digital subdevices
      staging: comedi: pcl816: add support for digital subdevices
      staging: comedi: pcl818: tidy up the digital subdevices
      staging: comedi: pcl816: move pcl816_reset()
      staging: comedi: pcl812: tidy up the analog output subdevice
      staging: comedi: pcl818: tidy up the analog output subdevice
      staging: comedi: pcl818: tidy up the analog input (*insn_read)
      staging: comedi: pcl816: tidy up the analog input (*insn_read)
      staging: comedi: pcl812: tidy up the analog input (*insn_read)
      staging: comedi: pcl812: introduce pcl812_ai_clear_eoc()
      staging: comedi: pcl816: introduce pcl816_ai_clear_eoc()
      staging: comedi: pcl818: introduce pcl818_ai_clear_eoc()
      staging: comedi: pcl818: introduce pcl818_ai_soft_trig()
      staging: comedi: pcl816: introduce pcl816_ai_soft_trig()
      staging: comedi: pcl812: introduce pcl812_ai_soft_trig()
      staging: comedi: pcl812: tidy up analog input registers
      staging: comedi: pcl816: tidy up analog input registers
      staging: comedi: pcl818: tidy up analog input registers
      staging: comedi: pcl818: define the status register bits
      staging: comedi: pcl816: define the status register bits
      staging: comedi: pcl812: define the status register bits
      staging: comedi: pcl812: cleanup setup_range_channel()
      staging: comedi: pcl816: cleanup setup_channel_list()
      staging: comedi: pcl818: cleanup setup_channel_list()
      staging: comedi: pcl812: define the mode register bits
      staging: comedi: pcl816: define the mode register bits
      staging: comedi: pcl818: define the mode register bits
      staging: comedi: pcl818: absorb pcl818_ai_mode13dma_int()
      staging: comedi: pcl818: cleanup ai_cmd()
      staging: comedi: pcl812: tidy up the remaining register defines
      staging: comedi: pcl816: tidy up the remaining register defines
      staging: comedi: pcl818: tidy up the remaining register defines
      staging: comedi: pcl812: clarify pcl812_reset()
      staging: comedi: pcl818: clarify pcl818_reset()
      staging: comedi: comedi_fops: introduce __comedi_get_user_cmd()
      staging: comedi: comedi_fops: introduce __comedi_get_user_chanlist()
      staging: comedi: jr3_pci: tidy up subdevice init
      staging: comedi: jr3_pci: use comedi_alloc_spriv()
      staging: comedi: jr3_pci: factor subdevice private data init out of (*attach)
      staging: comedi: jr3_pci: rename some local vars in the (*attach)
      staging: comedi: jr3_pci: tidy up jr3_pci_poll_dev()
      staging: comedi: jr3_pci: tidy up jr3_pci_poll_subdevice()
      staging: comedi: jr3_pci: tidy up jr3_download_firmware()
      staging: comedi: jr3_pci: tidy up jr3_pci_open()
      staging: comedi: jr3_pci: tidy up jr3_pci_ai_insn_read()
      staging: comedi: jr3_pci: introduce boardinfo for the supported boards
      staging: comedi: jr3_pci: remove 'n_channels' from private data
      staging: comedi: jr3_pci: rename struct transform_t
      staging: comedi: jr3_pci: rename struct poll_delay_t
      staging: comedi: jr3_pci: remove 'channel_no' from subdevice private data
      staging: comedi: comedi_fc: tidy up module init
      staging: comedi: comedi_fc: tidy up multi-line comment
      staging: comedi: comedi_fc: rename comedi_subdevice variables
      staging: comedi: comedi_fc: remove unnecessary prefix in dev_warn() message
      staging: comedi: comedi_fc: tidy up multi-line comment in header
      staging: comedi: comedi_fc: remove 'extern' from function prototypes
      staging: comedi: comedi_fc: rename comedi_subdevice variables in header
      staging: comedi: comedi_fc: tidy up cfc_bytes_per_scan()
      staging: comedi: comedi_fc: export cfc_bytes_per_scan()
      staging: comedi: comedi_fc: export increment_scan_progress()
      staging: comedi: mite: use cfc_inc_scan_progress()
      staging: comedi: adl_pci9118: use cfc_handle_events()
      staging: comedi: adl_pci9111: use cfc_handle_events()
      staging: comedi: adv_pci1710: use cfc_handle_events()
      staging: comedi: das16m1: use cfc_handle_events()
      staging: comedi: das800: use cfc_handle_events()
      staging: comedi: das1800: use cfc_handle_events()
      staging: comedi: dt282x: use cfc_handle_events()
      staging: comedi: ni_at_a2150: use cfc_handle_events()
      staging: comedi: ni_mio_common: use cfc_handle_events()
      staging: comedi: amplc_pci224: use cfc_handle_events()
      staging: comedi: cb_pcidas: use cfc_handle_events()
      staging: comedi: pcl812: use cfc_handle_events()
      staging: comedi: pcl816: use cfc_handle_events()
      staging: comedi: pcl818: use cfc_handle_events()
      staging: comedi: ni_660x: use cfc_handle_events()
      staging: comedi: dt3000: use cfc_handle_events()
      staging: comedi: ni_labpc: use cfc_handle_events()
      staging: comedi: ni_pcidio: use cfc_handle_events()
      staging: comedi: quatech_daqp_cs: use cfc_handle_events()
      staging: comedi: drivers should not clear the async->events
      staging: comedi: c6xdigio: remove ReadByteFromHwPort()
      staging: comedi: c6xdigio: remove WriteByteToHwPort()
      staging: comedi: c6xdigio: remove C6XDIGIO_SIZE
      staging: comedi: c6xdigio: factor out status check busywait
      staging: comedi: c6xdigio: tidy up C6X_pwmInit()
      staging: comedi: c6xdigio: tidy up C6X_encResetAll()
      staging: comedi: c6xdigio: tidy up C6X_pwmOutput()
      staging: comedi: c6xdigio: tidy up C6X_encInput()
      staging: comedi: c6xdigio: change first param to c6xdigio_chk_status()
      staging: comedi: c6xdigio: introduce c6xdigio_write_data()
      staging: comedi: c6xdigio: define the register map
      staging: comedi: c6xdigio: introduce c6xdigio_get_encoder_bits()
      staging: comedi: c6xdigio: tidy up c6xdigio_pwm_write()
      staging: comedi: c6xdigio: define the data register bits
      staging: comedi: c6xdigio: tidy up subdevice 0 init
      staging: comedi: c6xdigio: tidy up subdevice 1 init
      staging: comedi: c6xdigio: consolidate the board_init()
      staging: comedi: c6xdigio: use comedi_offset_munge()
      staging: comedi: c6xdigio: add readback of last pwm channel values
      staging: comedi: c6xdigio: tidy up the multi-line comments
      staging: comedi: c6xdigio: update the MODULE_DESCRIPTION
      staging: comedi: dac02: introduce comedi driver for DAC02 boards
      staging: comedi: fl512: tidy up subdevice init
      staging: comedi: fl512: rename the subdevice (*insn_{read, write}) functions
      staging: comedi: fl512: remove Fl512_SIZE define
      staging: comedi: fl512: tidy up fl512_ao_insn_read()
      staging: comedi: fl512: define the register map
      staging: comedi: fl512: tidy up fl512_ao_insn_write()
      staging: comedi: fl512: tidy up fl512_ao_insn_read()
      staging: comedi: fl512: tidy up the multi-line comments
      staging: comedi: gsc_hpdi: move the (*auto_attach) and (*detach) functions
      staging: comedi: gsc_hpdi: absorb setup_subdevices()
      staging: comedi: gsc_hpdi: move the (*auto_attach) helper functions
      staging: comedi: gsc_hpdi: tidy up dio_config_insn()
      staging: comedi: gsc_hpdi: tidy up setup_dma_descriptors()
      staging: comedi: gsc_hpdi: tidy up hpdi_cmd()
      staging: comedi: gsc_hpdi: tidy up hpdi_cmd_test()
      staging: comedi: gsc_hpdi: rename hpdi_cancel()
      staging: comedi: gsc_hpdi: rename abort_dma()
      staging: comedi: gsc_hpdi: rename handle_interrupt()
      staging: comedi: gsc_hpdi: rename drain_dma_buffers()
      staging: comedi: gsc_hpdi: rename the (*auto_attach) and (*detach) functions
      staging: comedi: gsc_hpdi: rename hpdi_find_board()
      staging: comedi: gsc_hpdi: rename init_plx9080()
      staging: comedi: gsc_hpdi: rename init_hpdi()
      staging: comedi: gsc_hpdi: remove disable_plx_interrupts()
      staging: comedi: gsc_hpdi: remove hpdi_writel()
      staging: comedi: gsc_hpdi: remove 'volatile' from the private data members
      staging: comedi: gsc_hpdi: tidy up gsc_hpdi_drain_dma()
      staging: comedi: gsc_hpdi: rename 'plx9080_iobase' in private data
      staging: comedi: gsc_hpdi: rename 'hpdi_iobase' in private data
      staging: comedi: gsc_hpdi: tidy up the register map
      staging: comedi: gsc_hpdi: tidy up the boardinfo
      staging: comedi: gsc_hpdi: convert comedi_error() messages to dev_err()
      staging: comedi: gsc_hpdi: remove pr_fmt() define
      staging: comedi: gsc_hpdi: tidy up multi-line comment
      staging: comedi: rti802: remove RTI802_SIZE define
      staging: comedi: rti802: tidy up rti802_ao_insn_read()
      staging: comedi: rti802: tidy up rti802_ao_insn_write()
      staging: comedi: rti802: tidy up the subdevice init
      staging: comedi: rti802: tidy up the register map defines
      staging: comedi: rti802: tidy up the multi-line comments
      staging: comedi: rti802: update the MODULE_DESCRIPTION
      staging: comedi: das6402: rewrite broken driver
      staging: comedi: poc: remove obsolete driver

Hartmut Knaack (5):
      staging:iio:ad799x Move to devm_request_threaded_irq to make device-removal simpler.
      staging:iio:ad799x fix typo in copyright message
      staging:iio:ad799x use regulator for vref
      iio:max1363 fix typos of int_vref_mv
      iio get rid of unneccessary error_ret

Heena Sirwani (1):
      staging: bcm: Fix line over 80 characters.

Heinrich Schuchardt (1):
      staging: usbip: userspace: Memory leak in usbip_exported_device_new

Himangi Saraogi (56):
      Staging : rts5208: Fix code indent issue
      Staging: bcm: Replace bcm functions with equivalents
      staging: lustre: remove assignment in if condition
      staging:lustre: Fix sparse warnings of Using plain integer as NULL pointer
      staging:lustre: Fix sparse warning of incorrect argument type
      staging:media: remove assignment in if condition
      staging: silicom : remove assignment in if condition
      Staging:cxt1e1:musycc:remove assignment in if condition
      staging:sbe-2t3e3: remove assignment in if condition
      staging:wlan-ng:Fix sparse warning cast to restricted __le16
      staging:octeon: remove space after opening parentheses
      staging:octeon: Replace pr_warning by preferred pr_warn
      staging:wlags49_h2: change comment style
      staging:wlags49_h2:change include path for uaccess.h
      staging:wlags49_h2:fix conditional statement warnings
      staging:wlags49_h2: Remove unnecessary spaces around parentheses
      staging:wlags49_h2: Remove unnecessary braces in if statements
      staging:nvec: Introduce the use of the managed version of kzalloc
      staging:serqt_usb2: Fix sparse warning restricted __le16 degrades to integer
      staging:rtl8187se:ieee80211: Fix incorrect type in assignment
      staging:rtl8187se:ieee80211: Fix Sparse Warning for Static Declarations
      staging:android: Introduce the use of the managed version of kzalloc
      staging:gdm72xx: Fix unnecessary brace errors
      staging:netlogic: Shorten line to 80 characters
      staging:rtl8712: Fix sparse warning incorrect type in assignment
      Staging:rtl8192:ieee80211: Fix sparse warning cast to restricted __le32
      staging:rtl8187se: Change argument type in function to bool
      staging:dgnc: Replace printk by pr_warn
      staging:rtl8192u: Fix smatch warning of function definition with external linkage
      staging:rtl8192u:ieee80211: Fix smatch warning of function definition with external linkage
      staging:rtl8821ae:btcoexist: Fix non-ANSI sparse warnings
      staging:line6: Fix use of variable length arrays
      staging:nokia_h4p:Replace __attribute__((packed)) by __packed
      staging:rtl8192u: Remove unused variable
      staging:rtl8187se: Remove unused variable
      staging:rtl8821ae:Fix sparse warning of static function declaration
      staging:comedi: Fix sparse warnings
      staging:wlan-ng:Fix sparse warning
      staging:cxt1e1:remove unused code with #if 0
      staging:rtl8187se:ieee80211: Fix sparse warning of cast to restricted __le16
      staging:rtl8187se: Fix sparse warning in right shift
      staging:comedi: Fix sparse warnings of incorrect type in assignment
      staging:lustre: Fix Sparse Warning for Static Declarations in console.c
      staging:lustre: Fix sparse warning of plain integer as NULL
      staging: dgap: Fix mismatch in function argument types
      static: keucr: Fix sparse warning of static declarations
      staging:keucr: Remove typedefs
      staging:rtl8187se: Fix sparse warning restricted __le16 degrades to integer
      staging: cxt1e1: Fix Sparse Warning for Static Declarations in linux.c
      staging:rtl8188eu: Remove unnecessary variable assignments
      staging:vt6655: Fix sparse warnings of using plain integer as NULL pointer
      staging: vt6656: Fix sparse warnings
      staging:rtl8192u: drop explicit externs
      staging:rtl8821ae: Fix sparse warnings of cast truncates bits from constant value
      staging:ozwpan:Fix sparse warning of incorrect argument type
      staging:ozwpan:Fix sparse warning of cast to restricted __le16

Hongchao Zhang (1):
      lustre/recovery: free open/close request promptly

Ian Abbott (1):
      staging: comedi: 8255_pci: initialize MITE data window

Insop Song (1):
      staging: fpgaboot: Xilinx FPGA firmware download driver

Iulia Manda (13):
      Staging:netlogic: Correct double assignment in xlr_net.c
      Staging:rtl8821ae: Drop memory allocation cast for kmalloc in hal_btc.c
      Staging:vt6656: Replace some kzalloc calls with kcalloc in iwctl.c
      Staging:dgnc: Fixed else not following close brace error
      Stagind:dgnc: Fixed unnecessary braces for single statement blocks
      Staging:dgnc: Use uaccess.h header from linux dir instead of asm
      Staging:dgnc: Fixed space prohibited between function name and '('
      Staging: dgnc: fix indentation in dgnc_mgmt.c
      staging: android: ion: Fix quoted string split across lines
      staging: android: ion: Replace seq_printf with seq_puts
      staging: android: ion: Use ERR_CAST instead of ERR_PTR
      staging: unisys: visorutil: Use kzalloc instead of kmalloc with memset
      staging: vt6656: Use __releases/__acquires annotations

JC Lafoucriere (1):
      staging/lustre/lustre_user.h: remove obsolete comments

Jade Bilkey (10):
      staging: silicom: fix trailing whitespace in libbp_sd.h
      staging: silicom: 80 character and tab formatting in libbp_sd.h
      staging: bcm: Fix checkpatch errors
      staging: bcm: Cleanup real_int_callback()
      staging: bcm: Cleanup switch statement
      staging: bcm: Cleanup CreateInterruptUrb() and StartInterruptUrb()
      staging: bcm: Cleanup unneeded boolean comparisons
      staging: bcm: Fix lines over 80 characters
      staging: bcm: Fix space before semicolon
      staging: bcm: Remove unneeded boolean comparisons and reflow lines

Jelena Bjelja (7):
      staging:ozwpan: Fixed trailing whitespace in ozpd.h
      staging:vt6655: Fix open brace placement related error
      staging: vt6655: Remove unnecessary braces in aes_ccmp.c
      staging: wlags49_h2: Fix sparse warning for static declaration
      staging: wlags49_h2: Enclose macro in a do-while loop
      staging: wlags49_h2: Do not use assignment in if condition
      staging: wlags49_h2: Delete unnecessary braces

Jingoo Han (1):
      Staging: rtl8812ae: replace strict_strtoul() with kstrtoul()

Jinshan Xiong (1):
      staging/lustre/llite: remove lustre_generic_file_{read,write}

Joe Perches (2):
      staging: ced1401: Fix dev_<level> messages
      staging: slicoss: Add MAINTAINERS entry, break README into TODO & README

Johannes Thumshirn (1):
      iio: adc: viperboard: Drop platform_set_drvdata call

John L. Hammond (5):
      staging/lustre/llite: pass correct pointer to obd_iocontrol()
      lustre: don't leak llog handle in llog_cat_process_cb()
      staging/lustre/llite: fix open lock matching in ll_md_blocking_ast()
      lustre/clio: honor O_NOATIME
      lustre/mdc: fix bad ERR_PTR usage in mdc_locks.c

John Stultz (2):
      staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT
      staging: Fix build issues with new binder API

John de la Garza (3):
      staging: usbip: vhci_sysfs.c: check return value of sscanf
      comedi:drivers:poc.c: unnecessary space before function pointer arguments
      usbip:usbip_common.c: check return value of sscanf

Jon Mason (1):
      staging/rtl8192e: Remove unused code

Jonathan Cameron (2):
      iio:drop IIO_ST macro
      iio:adc:vf610 ensure correct handing of interruption of wait for completion

Joshua Baldock (1):
      Staging: bcm: fixed parentheses and quoted string across lines coding style in CmHost.c

Julia Lawall (1):
      staging: r8712u: delete unnecessary field initialization

Jérôme Pinot (3):
      staging/ozwpan: coding style __constant_
      staging/ozwpan: formatting coding style
      staging/ozwpan: coding style ether_addr_copy

Keerthimai Janarthanan (4):
      staging: rts5139: Unnecessary space between function pointer name.
      staging: rts5208: Fixed line over 80 characters.
      staging: speakup: Prefer pr_err instead of printk(KERN_ERR)
      staging: usbip: Fix quoted string split across lines.

Ken Cox (28):
      staging: visorutil driver to provide common functionality to other s-Par drivers
      staging: visorchannel module
      staging: visorchipset driver to provide registration and other services
      staging: visorchannelstub driver to provide channel support routines
      staging: visoruislib driver used to handle requests from virtpci
      staging: virtpci driver
      staging: virthba driver to access shared SCSI hba
      staging: s-Par driver documentation
      staging: unisys: remove unreferenced utility functions.
      staging: unisys: Give exported symbols unique names
      Staging: unisys: virthba: Add dependency on SCSI
      Staging: unisys: virthba: Fix variable length array
      Staging: unisys: uislib: Fix locking in info_proc_read_helper()
      Staging: unisys: Fix multiple variable length array declarations
      Staging: unisys: channels: Cleanup sparse warnings
      Staging: unisys: Clean multiple sparse warnings
      Staging: unisys: uislib: Cleanup sparse warnings in uislib
      Staging: unisys: visorchannel: Clean up sparse warnings in visorchannel code
      Staging: unisys: visorchipset: Clean up sparse warnings in visorchipset code.
      Staging: unisys: visorutil: Clean up sparse warnings in visorutil code
      Staging: unisys: include: Remove unused macros from timskmod.h
      Staging: unisys: Cleanup macros to get rid of goto statements
      Staging: unisys: Remove FAIL_WPOSTCODE_1 macro
      Staging: unisys: Remove RETBOOL macro
      Staging: unisys: Remove RETPTR macro
      Staging: unisys: Remove RETVOID macro
      Staging: unisys: Remove FAIL macro
      Staging: unisys: Remove RETINT macro

Kirill Tkhai (2):
      staging: slicoss: Fix possible reuse of freed memory in timer function
      staging: sbe-2t3e3: Fix possible reuse of freed memory in timer function

Kristina Martšenko (12):
      staging: sbe-2t3e3: remove t3e3_rx_desc_t typedef
      staging: sbe-2t3e3: remove t3e3_tx_desc_t typedef
      staging: sbe-2t3e3: remove t3e3_param_t typedef
      staging: sbe-2t3e3: remove t3e3_stats_t typedef
      staging: sbe-2t3e3: remove t3e3_resp_t typedef
      staging: rtl8188eu: explicitly convert from __le16 to integer
      staging: dt3155v4l: make q_ops static
      staging: gdm72xx: use print_hex_dump_debug and remove debug macros
      staging: gdm72xx: replace printk() and debug macros with dynamic debugging
      staging: gdm72xx: remove completed TODO item
      staging: nokia_h4p: move firmware macros to firmware part
      staging: slicoss: free IO remapping on failure

Kumar Amit Mehta (1):
      staging: comedi: drivers: fix for a potential NULL pointer dereference

Lai Siyao (3):
      staging/lustre/llite: remove ll_d_root_ops
      staging/lustre/llite: don't d_add for create only files
      lustre/llite: simplify dentry revalidate

Larry Finger (33):
      staging: r8188eu: Remove ODM_Read1Byte
      staging: r8188eu: Remove ODM_Read2Byte
      staging: r8188eu: Remove ODM_Read4Byte
      staging: r8188eu: Remove ODM_Write1Byte
      staging: r8188eu: Remove ODM_Write2Byte
      staging: r8188eu: Remove ODM_Write4Byte
      staging: r8188eu: Remove wrappers around vmalloc and vzalloc
      staging: r8188eu: Remove wrappers around vfree
      staging: r8188eu: Remove ODM_AllocateMemory
      staging: r8188eu: Remove ODM_CompareMemory
      staging: r8188eu: Remove ODM_SetTimer
      staging: r8188eu: Remove ODM_InitializeTimer
      staging: r8188eu: Fix missing header
      staging: r8188eu: Replace wrapper around _rtw_memcmp()
      staging: r8188eu: Remove dead file
      staging: r8188eu: Remove some dead code from headers
      staging: r8188eu: Replace misspelled local container macro
      staging: r8188eu: Eliminate macro to get next list item
      staging: r8188eu: Remove _func_enter and _func_exit macros
      staging: rtl8821ae: Fix potential infinite loop
      staging: r8188eu: Fix more Smatch warnings and errors
      staging: r8188eu: Fix Smatch warnings
      staging: r8188eu: Remove unnecessary list_head entry from recv_frame union
      staging: r8188eu: Remove pointless "alignment" entry in recv_frame
      staging: r8188eu: Remove union wrapping of recv_frame
      staging: r8188eu: Remove pkt_to_recv{frame, data, mem} routines
      staging: r8188eu: Remove unused get_rxbuf_desc()
      staging: r8188eu: Remove get_recvframe_len()
      staging: r8188eu: Remove get_recvframe_data()
      staging: r8188eu: Remove unused union
      staging: r8188eu: Remove wrapper _exit_critical_mutex()
      staging: r8188eu: Remove wrapper routine _init_workitem()
      staging: r8188eu: Remove wrapper routine _set_workitem()

Lars-Peter Clausen (5):
      iio: Don't include extended name in shared attributes
      iio: Avoid unnecessary kasprintf
      iio:event: Fix and cleanup locking
      devicetree: Add Xilinx XADC binding documentation
      iio:adc: Add Xilinx XADC driver

Laura Abbott (1):
      staging: ion: Fix debugfs handling of multiple kernel clients

Levente Kurusa (1):
      staging: rtl8821ae: fix invalid bit mask on MSR_AP check

Liang Zhen (2):
      lustre/ptlrpc: re-enqueue ptlrpcd worker
      lustre/ptlrpc: rq_commit_cb is called for twice

Lidza Louina (2):
      staging: dgap: removes KERNEL_VERSION conditionals
      staging: dgap: removes version.h dependency

Malcolm Priestley (71):
      staging: vt6656: device_set_multi: covert mc_filter to u64
      staging: vt6656: device_set_multi: set filter off with MACvWriteMultiAddr
      staging: vt6656: camel case and clean up devie_set_multi
      staging: vt6656: Replace typedef enum _CARD_OP_MODE
      staging: vt6656: remove typedef VIA_PKT_TYPE.
      staging: vt6656: Remove typedef _VIA_BB_TYPE
      staging: vt6656: int.h correct endian type
      staging: vt6656: int : Replace typedef struct tagSINTData.
      staging: vt6656: Clean up and remove camel case INTnsProcessData.
      staging: vt6656: s_nsInterruptUsbIoCompleteRead set intBuf.bInUse to true
      staging: vt6656: s_nsInterruptUsbIoCompleteRead add urb status returns
      staging: vt6656: s_nsInterruptUsbIoCompleteRead remove usb_fill_bulk_urb
      staging: vt6656: Remove variable fKillEventPollingThread
      staging: vt6656: clean up s_nsInterruptUsbIoCompleteRead
      staging: vt6656: PIPEnsInterruptRead use usb_fill_int_urb
      staging: vt6656: PIPEnsInterruptRead set intBuf.bInUse to false.
      staging: vt6656: clean up PIPEnsInterruptRead.
      staging: vt6656: Replace typedef struct INT_BUFFER, *PINT_BUFFER
      staging: vt6656: Move device_set_multi code call to vRunCommand
      staging: vt6656: vRunCommand remove multi calls to s_bCommandComplete.
      staging: vt6656: s_nsBulkOutIoCompleteWrite reorganise variable order.
      staging: vt6656: s_nsBulkOutIoCompleteWrite add error handling,
      staging: vt6656: clean up s_nsBulkOutIoCompleteWrite.
      staging: vt6656: Remove typedef enum _CONTEXT_TYPE
      staging: vt6656: PIPEnsSendBulkOut reverse if statement
      staging: vt6656: usb_fill_bulk_urb get rid of void* cast.
      staging: vt6656: clean up PIPEnsSendBulkOut.
      staging: vt6656: s_nsBulkInUsbIoCompleteRead get rid of status.
      staging: vt6656: s_nsBulkInUsbIoCompleteRead Remove bytesRead/bIndicateReceive.
      staging: vt6656: s_nsBulkInUsbIoCompleteRead Replace error handling.
      staging: vt6656: clean up s_nsBulkInUsbIoCompleteRead
      staging: vt6656: Cleanup PIPEnsBulkInUsbRead
      staging: vt6656: Remove pointer cast to urb->context.
      staging: vt6656: struct vnt_usb_send_context struct size optimization.
      staging: vt6656: Remove all variables ulBulk*
      staging: vt6656: Remove all variables ulInt*
      staging: vt6656: struct vnt_usb_send_context remove sEthHeader.
      staging: vt6656: Remove unused variable bEventAvailable.
      staging: vt6656: Remove unused variables packets*
      staging: vt6656: s_nsBulkOutIoCompleteWrite remove buf_len.
      staging: vt6656: s_nsBulkOutIoCompleteWrite Remove variable status.
      staging: vt6656: Clean up RXvWorkItem
      staging: vt6656: Clean up RXvFreeRCB.
      staging: vt6656: Replace dev_alloc_skb with netdev_alloc_skb.
      staging: vt6656: Clean up device_alloc_bufs
      staging: vt6656: clean up device_free_rx_bufs.
      staging: vt6656: clean up device_free_tx_bufs
      staging: vt6656: clean up device_free_int_bufs.
      staging: vt6656: dead code removetypedef struct tagSQuietControl
      staging: vt6656: Remove unused tasklets tasklet_struct CmdWorkItem and EventWorkItem are not used.
      staging: vt6655: 64 bit Correct alignment of tx/rx structures.
      staging: vt6655: 64 bit fixes: MACvSetKeyEntry correct sizeof long,
      staging: vt6655: 64 bit fixes :TKIP mode micheal.c sizeof long.
      staging: vt6655: 64 bit fixes TKIP mic correct sizeof long.
      staging: vt6655: 64 bit fix sizeof long TKIP mic
      staging: vt6656: [BUG] set usb_fill_int_urb interval to 1
      staging: vt6656: [BUG] Fix Warning BOGUS urb xfer, pipe 3 != type 1
      staging: vt6656: rxtx Replace wDuration* variables.
      staging: vt6656: rxtx: Replace wRTSDuration* variables
      staging: vt6656: rxtx: Replace wRTSTxRrvTime*
      staging: vt6656: rxtx: Replace wTxRrvTime*
      staging: vt6656: rxtx: Replace wCTSDuration*
      staging: vt6656: rxtx Replace wCTSTxRrvTime_ba
      staging: vt6656: rxtx Replace wTimeStampOff* variables
      staging: vt6656: struct vnt_tx_short_buf_head correct base types
      staging: vt6656: vnt_time_stamp_off fix return to __le16
      staging: vt6656: rxtx endian correct return duration
      staging: vt6656: Correct return type s_uGetRTSCTSDuration.
      staging: vt6656: s_uGetDataDuration use __le16.
      staging: vt6656: vnt_rxtx_rsvtime_le16 fix return.
      staging: vt6656: s_uGetRTSCTSRsvTime fix return.

Manuel Stahl (3):
      iio: imu: mpu6050: Move config entry into IMU menu
      iio: imu: inv_mpu6050: Fix typo and formatting
      staging: iio: Add tool to list IIO devices and triggers

Mark Asselstine (1):
      staging: usbip: prevent possible buffer overflow reading port records

Mark Hounschell (63):
      staging: dgap: Remove CVS ID tags
      staging: dgap: Remove userland source code files
      staging: dgap: Merge dgap_tty.c into dgap_driver.c
      staging: dgap: Merge dgap_fep5.c into dgap_driver.c
      staging: dgap: Merge dgap_sysfs.c into dgap_driver.c
      staging: dgap: Merge dgap_parses.c into dgap_driver.c
      staging: dgap: Remove unneeded dgap_trace.c and dgap_trace.h
      staging: dgap: Merge dgap_tty.h into dgap_driver.c
      staging: dgap: Merge dgap_sysfs.h into dgap_driver.c
      staging: dgap: Merge dgap_fep5.h into dgap_driver.h
      staging: dgap: Merge dgap_pci.h into dgap_driver.h
      staging: dgap: Merge dgap_conf.h into dgap_driver.h
      staging: dgap: Merge dgap_parse.h into dgap_driver.h
      staging: dgap: Merge dgap_kcompat.h into dgap_driver.h
      staging: dgap: Merge dgap_types.h into dgap_driver.h
      staging: dgap: Merge digi.h into dgap_driver.h
      staging: dgap: Make merged and local functions and variables static
      staging: dgap: Rename driver
      staging: dgap: Add in-kernel firmware loading support
      staging: dgap: fix compile warnings by remove dead code
      staging: dgap: fix kernel oops on port open
      staging:dgap: remove digi debug and tracing code
      staging: dgap: Fix all return statments in err as reported by checkpatch
      staging: dgap: Fix indent errs as reported by checkpatch
      staging: dgap: Fix foo* bar should be foo *bar as reported by checkpatch
      staging: dgap: Fix include errs reported by checkpatch
      staging: dgap: Fix bracing errors reported by checkpatch
      staging: dgap: Fix white space errors as reported by checkpatch
      staging: dgap: fix do not use assignment in if condition as reported by checkpatch
      staging:dgap: Fix externs should be avoided in .c files as reported by checkpatch
      staging: dgap: Fix printk related errors as reported by checkpatch
      staging: dgap: Fix various previously missed checkpatch errors
      staging: dgap: Remove more degug/tracing code
      staging: dgap: get rid of nasty DGAP_VERIFY_BOARD macro
      staging: dgap: Add curly braces back in for Multi-line indent block
      staging: dgap: fix some pr_warns with new lines in the string
      staging: dgap: Don't remove sysfs group we failed to create
      staging: dgap: remove unnecessary dgap_global_lock
      staging: dgap: Remove module param and sysfs var rawreadok
      staging: dgap: fix checkpatch warning on sscanf usage
      staging: dgap: fix suspect code indent for conditional statements checkpatch warning
      staging: dgap: fix a few 80+ char lines as reported by checkpatch
      staging: dgap: fix a few more 80+ lines as reported by checkpatch
      staging: dgap: fix a few more 80+ lines as reported by checkpatch
      staging: dgap: fix a few more 80+ lines as reported by checkpatch
      staging: dgap: Remove some dead code
      staging: dgap: Remove printks associated with sysfile creation
      staging: dgap: Simplify and cleanup dgap_init_module function
      staging: dgap: fix a few 80+ char lines
      staging: dgap: fix a few more 80+ char lines (01/02)
      staging: dgap: fix a few more 80+ char lines (02/02)
      staging: dgap: remove some unused defines in dgap.h
      staging: dgap: Remove unneeded code from dgap.c
      staging: dgap: Remove unused DGAP_TRYLOCK macro
      staging: dgap: Replace/remove DGAP_SPINLOCK_INIT macro
      staging: dgap: remove unneeded dgap_driver_states
      staging: dgap: remove unused brd->state states
      staging: dgap: remove more unneeded brd-state states
      staging: dgap: Add a pr_info per board info
      staging: dgap: re-factor some code for 80+ lines as reported by checkpatch
      staging: dgap: get rid of DGAP_LOCK and DGAP_UNLOCK macros
      staging: dgap: re-factor some more code for 80+ lines
      staging: dgap: fix the rest of the checkpatch warnings in dgap.c

Masanari Iida (28):
      staging: lustre: Fix typo in client.c
      staging: lustre: Fix typo in service.c
      staging: lustre: Fix typo in sec.c
      staging: lustre: Fix typo in sec_gss.c
      staging: lustre: Fix typo in lustre/ptlrpc/gss
      staging: lustre: Fix typo in lustre/ptlrpc
      staging: dgap: Fix trailing whitespace in digi.h
      staging: dgap: Fix trailing whitespace in dgap_sysfs.c
      staging: dgap: Fix trailing whitespace in dgap_parse.c
      staging: dgap: Fix trailing whitespace in dgap_driver.c
      staging: dgap: Fix trailing whitespace in dgap_downld.h
      staging: dgap: Fix trailing whitespace in dgap_driver.h
      staging: dgap: Fix trailing whitespace in dgap_sysfs.h
      staging: dgap: Fix trailing whitespace in dgap_fep5.h
      staging:lustre: Fix typo in comment and printk within lustre/obdclass
      staging: rtl8821ae: Fix typo in comment and printk in rtl8821ae
      staging: rtl8821ae: Fix typo in rtl8821ae/rtl8821ae.
      staging: rtl8821ae: Fix typo in rtl8821ae/btcoexist
      staging: rtl8821ae: Fix C99 style comments in efuse.c
      staging: rtl8821ae: Fix C99 style comments in pci.c and pci.h
      staging: rtl8188eu: Fix typo in rtl8188eu/core
      staging: usbip: Fix format string mismatch in usbip_vhci_attach_device2
      staging: luster: Fix format string mismatch in workitem.c
      staging: luster: Fix typo in lustre/llite
      staging: lustre: Fix typo in lustre/include part1
      staging: lustre: Fix typo in lustre/include part2
      staging: luster: Fix spelling typo in lustre/include/lustre
      staging: lustre: Fix spelling typo in various part of luster

Masood Mehmood (3):
      staging: tidspbridge: fixed space coding style
      Staging:tidspbridge: Fixed braces, spaces and long line coding style
      staging: dgap: Fixed sparse error: same symbol redeclared with different type

Matei Oprea (1):
      Staging: comedi: ni_daq_dio24: fix a line over 80 characters

Mathieu Maret (3):
      staging: wlags49_h2: reindent wl_netdev.c
      staging: wlags49_h2: remove commented code in wl_netdev.c
      staging: wlags49_h2: Correct comment style in wl_netdev.c

Michael Welling (2):
      STAGING: comedi: style and checkpatch fixes
      Staging: comedi: proc: title block update

Mikhail Boiko (1):
      staging: line6: Fix coding style problem

Mitchel Humpherys (4):
      staging: ion: Create separate heap and client debugfs directories
      staging: ion: Store a copy of the client name on client creation
      staging: ion: Make sure all clients are exposed in debugfs
      staging: ion: Add private buffer flag to skip page pooling on free

Monam Agarwal (47):
      Staging: comedi: Fix line length exceeding 80 characters
      Staging: comedi: Fix unnecessary space after function pointer
      Staging: cxt1e1: Fix no spaces at the start of a line in functions.c
      Staging: cxt1e1: Fix space prohibited between function name and open parenthesis '('
      Staging: cxt1e1: Fix line length over 80 characters in functions.c
      Staging: panel: Fix space prohibited between function name and open paranthesis
      Staging: panel: Fix quoted string split across line in panel.c
      Staging: sep: Fix missing space after return type in sep_crypto.c
      Staging: sep: Fix quoted string split across lines in sep_main.c
      Staging: sep: Fix line length over 80 characters in sep_main.c
      Staging: sm7xxfb: Fix quoted string split across lines in sm7xxfb.c
      Staging: slicoss: Fix line over 80 characters in slic.h
      Staging: line6: Fix unnecessary space after function pointer in driver.c
      Staging: line6: Fix unnecessary space after function pointer in driver.h
      Staging: line6: Fix no space before tabs in usbdefs.h
      Staging: slicoss: Fix quoted string split across lines
      Staging: slicoss: Fix unnecessary whitespace before a quoted newline in slicoss.c
      Staging: xgifb: Fix quoted string split across lines in XGI_main_26.c
      Staging : lustre/lustre/lov: Fix Statements terminations use 1 semicolon in lov_ea.c
      Staging: media/cxd2099: Fix line length over 80 characters
      Staging: dgnc: Fix struct file_operations should normally be const
      Staging: gs_gpgaboot: Fix Bad function definition in io.c
      Staging: ced1401: Fix do not add new typedefs
      Staging: ced1401: Fix removed unused structs
      Staging: rtl8188eu: Fix sparse warning cast to restricted __le16
      Staging: iio/resolver: Fix prefer pr_warn over pr_warning in ad2s1210.c
      Staging: iio/accel: Fix Prefer netdev_warn(netdev, ...then dev_warn(dev, ... then pr_warn(... to printk(KERN_INFO ... in sca3000_ring.c
      Staging: wlags49_h2: Fix sparse warnings in sta_h2.c
      Staging: wlags49_h2: Fix Remove unused functions in wl_util.c
      Staging: wlags49_h2: Fix Sparse Warning for Static Declarations in hcf.c
      Staging: wlags49_h2: Fix Sparse Warning for Static Declarations in dhf.c
      Staging: wlags49_h2: Fix incorrect type in assignment in wl_wext.c
      Staging: crystalhd: Fix different address spaces warning from sparse in crystalhd_misc.c
      Staging: crystalhd: Fix different address spaces warning
      Staging: rts5139: Fix incorrect type in assignment in rts51x_fop.c
      Staging: rts5139: Fix Sparse Warning for Static Declarations
      Staging: rts5139: Fix Sparse Warning for Static Declarations in rts51x.c
      Staging: gdm72xx: Fix incorrect type in assignment in gdm_wimax.c
      Staging: rtl8192e: Fix Sparse Warning of invalid assignment in rtllib_tx.c
      Staging: et131x: Fix warning of prefer ether_addr_copy() in et131x.c
      Staging: slicoss: Removal of unused macros in slicoss.c
      Staging: ft1000-usb: Fix Smatch Warning in ft1000_hw.c
      Staging: slicoss: Replace macro with inline defination in slicoss.c
      Staging: iio/light: Fix return values in tsl2583.c
      Staging: gdm724x: Fix unchecked sscanf values in gdm_lte.c
      Staging: ced1401: Fix typedef warnings in ced_ioctl.h
      Staging: ced1401: Fix no new typedef warning in ced_ioctl.h

Nick Davies (1):
      Staging: comedi: ni_tio Fixed whitespace coding style warnings

Niu Yawei (1):
      lustre/quota: improper assert in osc_quota_chkdq()

Oleg Drokin (3):
      lustre/mdc: Check for all attributes validity in revalidate
      lustre/llite: Do not send parent dir fid in getattr by fid
      lustre/libcfs: warn if all HTs in a core are gone

Paul Bolle (3):
      staging: r8188eu: default to "y" in Kconfig
      Staging: rtl8812ae: remove undefined Kconfig macros
      staging: r8188eu: Remove dead code

Paul E. McKenney (1):
      staging: Additional item for rtl8188eu TODO list

Paul Gortmaker (1):
      iio: delete non-required instances of include <linux/init.h>

Pavel Machek (1):
      staging/bluetooth: Add hci_h4p driver

Peng Tao (20):
      staging/lustre/o2iblnd: fix is_vmalloc_addr build warning
      staging/lustre/libcfs: remove cfs_curproc_groups_nr
      staging/lustre/libcfs: remove cfs_curproc_cap_unpack
      staging/lustre/libcfs: remove cfs_cap_{un}pack
      staging/lustre/libcfs: remove CAPABILITY_VERSION tests
      staging/lustre/libcfs: remove cfs_capable
      staging/lustre/libcfs: remove user space code from kernel_user_comm.c
      staging/lustre/libcfs: remove cfs_hash_long
      lustre/ptlrpc: skip rpcs that fail ptl_send_rpc
      staging/lustre/lnet: remove kiblnd_debug_conn/rx/tx
      staging/lustre/libcfs: remove cfs_strncasecmp
      staging/lustre/libcfs_string.h: don't export internal functions
      staging/lustre/libcfs: remove cfs_iswhite
      staging/lustre/libcfs: remove obsolete function declaration
      staging/lustre/libcfs: remove NIDSTR_LOCK/UNLOCK
      staging/lustre/libcfs: remove init_waitqueue_entry_current
      staging/lustre/libcfs: remove waitq_wait
      staging/lustre/libcfs: remove waitq_timedwait
      staging/lustre/libcfs: remove schedule_timeout_and_set_state
      staging/lustre/libcfs: remove cfs_pause

Peter Meerwald (14):
      iio: Add si7005 relative humidity and temperature sensor driver
      iio: Remove obsolete variable in adjd_s311 driver
      iio: Remove obsolete variable in tcs3472 driver
      iio:pressure:mpl3115: Fix sparse cast to restricted __be32 warning
      iio: Add Lite-On ltr501 ambient light / proximity sensor driver
      staging:iio:accel:sca3000: Fix kerneldoc
      staging:iio:accel:sca3000: Fix format of comments
      staging:iio:accel:sca3000: Event_attribute_group seems to be missing for _info_with_temp
      staging:iio:accel:sca3000: Channels missing in temp_output case
      staging:iio:accel:sca3000: Move temperature attribute to channels
      staging:iio:accel:sca3000: Cleanup sca3000.h
      iio:magnetometer:mag3110: Scale factor missing for temperature
      iio:accel:bma180: Make LOW_PASS_FILTER_3DB_FREQUENCY shared_by_type
      iio:magnetometer:mag3110: Fix unreachable code

Philipp Zabel (21):
      imx-drm: Move IPU_PIX_FMT_GBR24 definition into imx-ipu-v3.h
      imx-drm: ipu-dc: Use usleep_range instead of msleep
      imx-drm: parallel-display: Add drm_panel support
      [media] of: move graph helpers from drivers/media/v4l2-core to drivers/of
      Documentation: of: Document graph bindings
      of: Warn if of_graph_get_next_endpoint is called with the root node
      of: Reduce indentation in of_graph_get_next_endpoint
      [media] of: move common endpoint parsing to drivers/of
      of: Warn if of_graph_parse_endpoint is called with the root node
      of: Fix of_graph_parse_endpoint stub for !CONFIG_OF builds
      staging: imx-drm-core: Use OF graph to find components and connections between encoder and crtcs
      staging: imx-drm-core: use of_graph_parse_endpoint
      staging: imx-drm: Document updated imx-drm device tree bindings
      staging: imx-drm: Document imx-hdmi device tree bindings
      imx-drm: imx-hdmi: Fix DDC I2C bus property
      imx-drm: imx-tve: Fix DDC I2C bus property
      ARM: dts: imx53-mba53: Fix TVE DDC I2C bus property
      ARM: dts: imx51: Add IPU ports and endpoints, move imx-drm node to dtsi
      ARM: dts: imx53: Add IPU DI ports and endpoints, move imx-drm node to dtsi
      ARM: dts: imx6qdl: Add IPU DI ports and endpoints, move imx-drm node to dtsi
      staging: imx-drm: Update TODO

Raluca Oncioiu (2):
      Staging: octeon-usb: Break up long lines
      Staging: octeon-usb: Remove unnecessary brackets

Rashika Kheria (1):
      drivers: staging: Mark functions as static and remove unused function in bpctl_mod.c

Richard Weinberger (2):
      staging: tidspbridge: Remove OMAP_PM_SRF
      staging/xillybus: Handle OOM in xillybus_init()

Russell King (30):
      imx-drm: imx-hdmi: convert HDMI clock settings to tabular form
      imx-drm: imx-hdmi: clean up setting CSC registers
      imx-drm: imx-hdmi: provide register modification function
      imx-drm: imx-hdmi: clean up setting of vp_conf
      imx-drm: imx-hdmi: fix CTS/N setup at init time
      imx-drm: ipu-v3: more inteligent DI clock selection
      imx-drm: ipu-v3: don't use clk_round_rate() before clk_set_rate()
      imx-drm: ipu-v3: more clocking fixes
      imx-drm: add imx6 DT configuration for HDMI
      imx-drm: update and fix imx6 DT descriptions for v3 HDMI driver
      imx-drm: imx-drm-core: sanitise imx_drm_encoder_get_mux_id()
      imx-drm: imx-drm-core: use array instead of list for CRTCs
      imx-drm: provide common connector mode validation function
      imx-drm: simplify setup of panel format
      imx-drm: convert to componentised device support
      imx-drm: delay publishing sysfs connector entries
      imx-drm: remove separate imx-fbdev
      imx-drm: remove imx-fb.c
      imx-drm: use supplied drm_device where possible
      imx-drm: imx-drm-core: provide helper function to parse possible crtcs
      imx-drm: imx-drm-core: provide common connector and encoder cleanup functions
      imx-drm: initialise drm components directly
      imx-drm: imx-drm-core: remove imx_drm_connector and imx_drm_encoder code
      imx-drm: imx-drm-core: get rid of drm_mode_group_init_legacy_group()
      imx-drm: imx-drm-core: kill off mutex
      imx-drm: imx-drm-core: move allocation of imxdrm device to driver load function
      imx-drm: imx-drm-core: various cleanups
      imx-drm: imx-drm-core: add core hotplug connector support
      imx-drm: imx-hdmi: add hotplug support to HDMI component
      Merge branch 'topic/of-graph' of git://git.pengutronix.de/git/pza/linux into imx-drm-staging

Sachin Kamat (3):
      staging: ion: Use PTR_ERR_OR_ZERO
      staging: lustre: Remove duplicate inclusion of crypto.h
      staging: rtl8821ae: Remove duplicate include

Salym Senyonga (3):
      Staging: ozwpan: Fix null dereference
      Staging: ozwpan: reduce indent levels in oz_binding_add().
      Staging: ozwpan: Change kmalloc() to kzalloc()

Sebastien Buisson (1):
      lustre/ptlrpc: fix 'data race condition' issues

SeongJae Park (4):
      staging: crystalhd: enclose multi statements macro
      staging: crystalhd: remove unnecessary parenthesis
      staging: cxt1e1: remove unnecessary function, VMETRO_TRACE
      staging: android: binder: use whitespace consistently

Serban Constantinescu (1):
      staging: binder: Fix ABI for 64bit Android

Shaun Laing (3):
      staging: cxt1e1: Add extern keyword for sparse 'static' warning
      staging: cxt1e1: removed version string declaration
      staging: cxt1e1: change declaration of TWV_table

Shuah Khan (7):
      staging/usbip: remove vhci_hcd vhci_hub_status change message
      staging/usbip: Change vhci_hcd store_attach() device information message to include speed string
      staging/usbip: simplify usbip_dump_usb_device() udev->speed handling
      staging/usbip: userspace to use linux header for usb_device_speed enum, missing speeds to speed_strings array
      staging/usbip: add uapi header to export usbip kernel interfaces
      staging/usbip: change usbip to include new uapi usbip.h
      staging/usbip: change usbip userspace to include new uapi usbip.h

Silvan Jegen (1):
      Staging: rtl8192e: Replace min macro with min_t

Silvio F (1):
      staging: unisys: kmalloc/memset to kzalloc conversation

Stas Sergeev (1):
      staging: r8188eu: Make firmware buffer persistent

Surendra Patil (4):
      drivers:staging:rtl8821ae: Fixed few coding style erors and warnings
      drivers:staging:silicom Fixed extern warnings reported by checkpatch
      drivers:staging:silicom fixed checkpatch coding style error on macros
      drivers:staging:ozwpan Replaced wrapper functions with actual spin lock function

Swapnil Pimpale (1):
      lustre: Unsafe error handling around ll_splice_alias

Tobias Klauser (1):
      staging: lustre: storage class should be before const qualifier

Tugce Sirin (9):
      Staging: wlan-ng: Fix Sparse warning should it be static?
      Staging: wlan-ng: Fix sparse non-static symbol warning
      Staging: bcm: Fix sparse non-static symbol warning
      Staging: wlan-ng: Fix prefer netdev_err to printk
      Staging: wlan-ng: Fix prefer netdev_info to printk
      Staging: wlan-ng: Fix quoted string split across lines
      Staging: lustre: Fix space required before the open parenthesis
      Staging: wlan-ng: Fix smatch warning potential null reference
      Staging: bcm: Remove unnecessary parentheses

Uma Sharma (3):
      staging: removed space after return function in gdm_lte.h
      staging: media/msi3101/sdr-msi3101.c removed warning
      staging: media/omap24xx/tcm825x.h removed warning

Valentina Manea (20):
      staging: usbip: convert usbip-host driver to usb_device_driver
      staging: usbip: userspace: migrate usbip_bind to libudev
      staging: usbip: userspace: remove useless libsysfs includes
      staging: usbip: userspace: migrate usbip_unbind to libudev
      staging: usbip: userspace: migrate usbip_list to libudev
      staging: usbip: userspace: re-add interface information listing
      staging: usbip: userspace: add new list API
      staging: usbip: userspace: move sysfs_utils to libsrc
      staging: usbip: userspace: migrate usbip_host_driver to libudev
      staging: usbip: userspace: remove class device infrastructure in vhci_driver
      staging: usbip: userspace: migrate vhci_driver to libudev
      staging: usbip: userspace: remove libsysfs flag and autoconf check
      staging: usbip: userspace: update dependencies in README
      staging: usbip: userspace: increase version to 2.0
      staging: usbip: let client choose device configuration
      staging: usbip: trigger driver probing after unbinding from usbip-host
      staging: usbip: claim ports used by shared devices
      staging: usbip: userspace: don't throw error when trying to read configuration specific attributes
      staging: usbip: userspace: add hwdata as optional dependency in README
      usbcore: rename struct dev_state to struct usb_dev_state

Vinayak Menon (1):
      staging: android: lowmemorykiller: neglect swap cached pages in other_file

Vivien Didelot (1):
      iio:adc:max1363 clear list of missing features

Wei Yongjun (1):
      ion: Fix sparse non static symbol warnings

Weijie Yang (1):
      staging: android: lowmemorykiller: set TIF_MEMDIE before send kill sig

Zhao, Gang (3):
      staging: et131x: stop read when hit max delay in et131x_phy_mii_read
      staging: et131x: remove spinlock adapter->lock
      staging: wlan-ng: replace function ieee80211_dsss_chan_to_freq()

bahar sahin (1):
      Staging: octeon: Fix coding style

navin patidar (4):
      staging: rtl8188eu: remove header file if_ether.h
      staging: rtl8188eu: remove header file ip.h
      staging: rtl8188eu: remove header file ethernet.h
      staging: rtl8188eu: remove unused header files

wang di (1):
      lustre/mdc: comments on LOOKUP and PERM lock

yang sheng (1):
      lustre: instantiate negative dentry

 .../devicetree/bindings/arm/atmel-adc.txt          |    5 +
 Documentation/devicetree/bindings/graph.txt        |  129 +
 .../devicetree/bindings/iio/adc/vf610-adc.txt      |   22 +
 .../devicetree/bindings/iio/adc/xilinx-xadc.txt    |  113 +
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |   48 +-
 .../devicetree/bindings/staging/imx-drm/hdmi.txt   |   58 +
 .../devicetree/bindings/staging/imx-drm/ldb.txt    |   20 +-
 MAINTAINERS                                        |   13 +
 arch/arm/boot/dts/imx51-apf51dev.dts               |   11 +-
 arch/arm/boot/dts/imx51-babbage.dts                |   26 +-
 arch/arm/boot/dts/imx51.dtsi                       |   22 +-
 arch/arm/boot/dts/imx53-m53evk.dts                 |   13 +-
 arch/arm/boot/dts/imx53-mba53.dts                  |   13 +-
 arch/arm/boot/dts/imx53-qsb.dts                    |   13 +-
 arch/arm/boot/dts/imx53.dtsi                       |   64 +-
 arch/arm/boot/dts/imx6dl.dtsi                      |   17 +-
 arch/arm/boot/dts/imx6q.dtsi                       |  123 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |  137 +-
 drivers/iio/accel/bma180.c                         |    4 +-
 drivers/iio/adc/Kconfig                            |   23 +
 drivers/iio/adc/Makefile                           |    3 +
 drivers/iio/adc/max1363.c                          |   16 +-
 drivers/iio/adc/ti_am335x_adc.c                    |    1 -
 drivers/iio/adc/twl6030-gpadc.c                    |    1 -
 drivers/iio/adc/vf610_adc.c                        |  711 ++
 drivers/iio/adc/viperboard_adc.c                   |    2 -
 drivers/iio/adc/xilinx-xadc-core.c                 | 1333 ++++
 drivers/iio/adc/xilinx-xadc-events.c               |  254 +
 drivers/iio/adc/xilinx-xadc.h                      |  209 +
 drivers/iio/buffer_cb.c                            |    7 +-
 drivers/iio/dac/ad7303.c                           |    2 +-
 drivers/iio/dac/max517.c                           |    1 -
 drivers/iio/dac/mcp4725.c                          |    1 -
 drivers/iio/humidity/Kconfig                       |   10 +
 drivers/iio/humidity/Makefile                      |    1 +
 drivers/iio/humidity/si7005.c                      |  189 +
 drivers/iio/imu/Kconfig                            |    4 +-
 drivers/iio/imu/adis16400_core.c                   |    2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |    3 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h          |   38 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |    1 -
 drivers/iio/industrialio-buffer.c                  |   16 +-
 drivers/iio/industrialio-core.c                    |   51 +-
 drivers/iio/industrialio-event.c                   |  100 +-
 drivers/iio/industrialio-trigger.c                 |   11 +-
 drivers/iio/light/Kconfig                          |   26 +
 drivers/iio/light/Makefile                         |    2 +
 drivers/iio/light/adjd_s311.c                      |    3 -
 drivers/iio/light/hid-sensor-prox.c                |  375 +
 drivers/iio/light/ltr501.c                         |  445 ++
 drivers/iio/light/tcs3472.c                        |    2 -
 drivers/iio/magnetometer/ak8975.c                  |    1 +
 drivers/iio/magnetometer/mag3110.c                 |   17 +-
 drivers/iio/pressure/Kconfig                       |   16 +-
 drivers/iio/pressure/Makefile                      |    1 +
 drivers/iio/pressure/hid-sensor-press.c            |  376 +
 drivers/iio/pressure/mpl3115.c                     |    2 +-
 drivers/iio/pressure/st_pressure.h                 |    1 +
 drivers/iio/pressure/st_pressure_core.c            |   87 +-
 drivers/iio/pressure/st_pressure_i2c.c             |    1 +
 drivers/iio/pressure/st_pressure_spi.c             |    1 +
 drivers/media/i2c/adv7343.c                        |    4 +-
 drivers/media/i2c/mt9p031.c                        |    4 +-
 drivers/media/i2c/s5k5baf.c                        |    3 +-
 drivers/media/i2c/tvp514x.c                        |    3 +-
 drivers/media/i2c/tvp7002.c                        |    3 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |    6 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   13 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |    5 +-
 drivers/media/v4l2-core/v4l2-of.c                  |  133 +-
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/{staging => misc}/echo/Kconfig             |    0
 drivers/{staging => misc}/echo/Makefile            |    0
 drivers/{staging => misc}/echo/echo.c              |    0
 drivers/{staging => misc}/echo/echo.h              |    0
 drivers/{staging => misc}/echo/fir.h               |    0
 drivers/{staging => misc}/echo/oslec.h             |    0
 drivers/of/base.c                                  |  151 +
 drivers/staging/Kconfig                            |   12 +-
 drivers/staging/Makefile                           |    6 +-
 drivers/staging/android/Kconfig                    |   13 +
 drivers/staging/android/android_alarm.h            |   44 +-
 drivers/staging/android/ashmem.h                   |   30 +-
 drivers/staging/android/binder.c                   |  268 +-
 drivers/staging/android/binder.h                   |  308 +-
 drivers/staging/android/binder_trace.h             |   14 +-
 drivers/staging/android/ion/ion.c                  |  156 +-
 drivers/staging/android/ion/ion_cma_heap.c         |    2 +-
 drivers/staging/android/ion/ion_dummy_driver.c     |   12 +-
 drivers/staging/android/ion/ion_heap.c             |   67 +-
 drivers/staging/android/ion/ion_page_pool.c        |    8 +-
 drivers/staging/android/ion/ion_priv.h             |   89 +-
 drivers/staging/android/ion/ion_system_heap.c      |   84 +-
 drivers/staging/android/ion/tegra/tegra_ion.c      |   10 +-
 drivers/staging/android/lowmemorykiller.c          |    5 +-
 drivers/staging/android/sw_sync.h                  |   20 +-
 drivers/staging/android/sync.h                     |   88 +-
 drivers/staging/android/timed_gpio.c               |    8 +-
 drivers/staging/android/timed_output.h             |    4 +-
 drivers/staging/android/uapi/android_alarm.h       |   62 +
 drivers/staging/android/uapi/ashmem.h              |   47 +
 drivers/staging/android/uapi/binder.h              |  351 +
 drivers/staging/android/uapi/sw_sync.h             |   32 +
 drivers/staging/android/uapi/sync.h                |   97 +
 drivers/staging/bcm/Adapter.h                      |    6 +-
 drivers/staging/bcm/Bcmchar.c                      | 3503 +++++----
 drivers/staging/bcm/CmHost.c                       |   61 +-
 drivers/staging/bcm/DDRInit.c                      |   32 +-
 drivers/staging/bcm/InterfaceInit.c                |  416 +-
 drivers/staging/bcm/InterfaceIsr.c                 |  223 +-
 drivers/staging/bcm/Qos.c                          |   35 +-
 drivers/staging/bcm/Typedefs.h                     |   22 +-
 drivers/staging/bcm/headers.h                      |    2 +-
 drivers/staging/bcm/hostmibs.c                     |    8 +-
 drivers/staging/bcm/nvm.c                          |   30 +-
 drivers/staging/ced1401/ced_ioc.c                  |  163 +-
 drivers/staging/ced1401/ced_ioctl.h                |   31 +-
 drivers/staging/ced1401/usb1401.c                  |  195 +-
 drivers/staging/ced1401/usb1401.h                  |    6 +-
 drivers/staging/ced1401/use14_ioc.h                |    5 +-
 drivers/staging/ced1401/userspace/use1401.c        |   10 +-
 drivers/staging/comedi/Kconfig                     |   24 +-
 drivers/staging/comedi/comedi_fops.c               |  191 +-
 drivers/staging/comedi/comedidev.h                 |   56 +-
 drivers/staging/comedi/drivers.c                   |   30 +
 drivers/staging/comedi/drivers/8255_pci.c          |   37 +-
 drivers/staging/comedi/drivers/Makefile            |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |  597 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 1187 +--
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  857 +--
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |  106 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |   73 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |   24 +-
 drivers/staging/comedi/drivers/addi_apci_035.c     |   14 +-
 drivers/staging/comedi/drivers/addi_apci_1500.c    |   24 +-
 drivers/staging/comedi/drivers/addi_apci_1564.c    |   16 +-
 drivers/staging/comedi/drivers/addi_apci_3120.c    |   26 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c    |   36 +-
 drivers/staging/comedi/drivers/addi_apci_3501.c    |    6 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c    |   57 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |   22 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c       |    3 -
 drivers/staging/comedi/drivers/adl_pci9111.c       |   73 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   92 +-
 drivers/staging/comedi/drivers/adq12b.c            |   31 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   67 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    2 -
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   10 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |   31 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    2 +-
 .../staging/comedi/drivers/amplc_dio200_common.c   |    2 +-
 drivers/staging/comedi/drivers/amplc_pc236.c       |   35 +-
 drivers/staging/comedi/drivers/amplc_pc263.c       |    2 -
 drivers/staging/comedi/drivers/amplc_pci224.c      |   29 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |   42 +-
 drivers/staging/comedi/drivers/amplc_pci263.c      |    2 -
 drivers/staging/comedi/drivers/c6xdigio.c          |  491 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |  150 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   51 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   59 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 -
 drivers/staging/comedi/drivers/cb_pcimdas.c        |   41 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c        |    4 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    5 +-
 drivers/staging/comedi/drivers/comedi_fc.c         |   99 +-
 drivers/staging/comedi/drivers/comedi_fc.h         |   84 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    7 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c    |    2 -
 drivers/staging/comedi/drivers/dac02.c             |  172 +
 drivers/staging/comedi/drivers/daqboard2000.c      |   85 +-
 drivers/staging/comedi/drivers/das08.c             |   35 +-
 drivers/staging/comedi/drivers/das16.c             |   19 +-
 drivers/staging/comedi/drivers/das16m1.c           |   38 +-
 drivers/staging/comedi/drivers/das1800.c           |   10 +-
 drivers/staging/comedi/drivers/das6402.c           |  672 +-
 drivers/staging/comedi/drivers/das800.c            |   43 +-
 drivers/staging/comedi/drivers/dmm32at.c           |   83 +-
 drivers/staging/comedi/drivers/dt2811.c            |   23 +-
 drivers/staging/comedi/drivers/dt2814.c            |   29 +-
 drivers/staging/comedi/drivers/dt2815.c            |   39 +-
 drivers/staging/comedi/drivers/dt282x.c            |   73 +-
 drivers/staging/comedi/drivers/dt3000.c            |    8 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c      |   40 +-
 drivers/staging/comedi/drivers/fl512.c             |  207 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c          | 1099 ++-
 drivers/staging/comedi/drivers/icp_multi.c         |  109 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   20 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |  891 ++-
 drivers/staging/comedi/drivers/jr3_pci.h           |    6 +-
 drivers/staging/comedi/drivers/ke_counter.c        |  209 +-
 drivers/staging/comedi/drivers/me4000.c            |    3 -
 drivers/staging/comedi/drivers/me_daq.c            |   36 +-
 drivers/staging/comedi/drivers/mf6x4.c             |   23 +-
 drivers/staging/comedi/drivers/mite.c              |   11 +-
 drivers/staging/comedi/drivers/mite.h              |    6 +-
 drivers/staging/comedi/drivers/mpc624.c            |   30 +-
 drivers/staging/comedi/drivers/multiq3.c           |   38 +-
 drivers/staging/comedi/drivers/ni_660x.c           |   11 +-
 drivers/staging/comedi/drivers/ni_670x.c           |    3 -
 drivers/staging/comedi/drivers/ni_at_a2150.c       |   55 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c       |   61 +-
 drivers/staging/comedi/drivers/ni_daq_700.c        |   56 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c      |    4 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   33 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |   78 +-
 drivers/staging/comedi/drivers/ni_pcidio.c         |   16 +-
 drivers/staging/comedi/drivers/ni_pcimio.c         |    2 +-
 drivers/staging/comedi/drivers/ni_tio.h            |    8 +-
 drivers/staging/comedi/drivers/pcl711.c            |   26 +-
 drivers/staging/comedi/drivers/pcl812.c            | 1484 ++--
 drivers/staging/comedi/drivers/pcl816.c            | 1045 ++-
 drivers/staging/comedi/drivers/pcl818.c            | 1523 ++--
 drivers/staging/comedi/drivers/pcm3724.c           |    6 +-
 drivers/staging/comedi/drivers/pcmad.c             |   21 +-
 drivers/staging/comedi/drivers/pcmmio.c            |   42 +-
 drivers/staging/comedi/drivers/plx9080.h           |    8 +-
 drivers/staging/comedi/drivers/poc.c               |  157 -
 drivers/staging/comedi/drivers/quatech_daqp_cs.c   |    5 +-
 drivers/staging/comedi/drivers/rtd520.c            |   86 +-
 drivers/staging/comedi/drivers/rti800.c            |   29 +-
 drivers/staging/comedi/drivers/rti802.c            |  127 +-
 drivers/staging/comedi/drivers/s526.c              |   34 +-
 drivers/staging/comedi/drivers/s626.c              |  174 +-
 drivers/staging/comedi/drivers/skel.c              |   43 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |    3 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |   51 +-
 .../staging/comedi/kcomedilib/kcomedilib_main.c    |    3 +-
 drivers/staging/comedi/proc.c                      |   48 +-
 drivers/staging/comedi/range.c                     |   37 +-
 drivers/staging/crystalhd/bcm_70012_regs.h         |    3 +-
 drivers/staging/crystalhd/crystalhd_hw.c           |    8 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |   21 +-
 drivers/staging/crystalhd/crystalhd_lnx.h          |    4 +-
 drivers/staging/crystalhd/crystalhd_misc.c         |    2 +-
 drivers/staging/crystalhd/crystalhd_misc.h         |    2 +-
 drivers/staging/cxt1e1/Makefile                    |    1 -
 drivers/staging/cxt1e1/comet.c                     |   44 +-
 drivers/staging/cxt1e1/comet_tables.c              |    1 +
 drivers/staging/cxt1e1/functions.c                 |  373 +-
 drivers/staging/cxt1e1/hwprobe.c                   |  598 +-
 drivers/staging/cxt1e1/libsbew.h                   |   56 +-
 drivers/staging/cxt1e1/linux.c                     | 1643 +++--
 drivers/staging/cxt1e1/musycc.c                    |   43 +-
 drivers/staging/cxt1e1/ossiRelease.c               |   29 -
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |    6 +-
 drivers/staging/cxt1e1/pmcc4.h                     |    1 -
 drivers/staging/cxt1e1/pmcc4_drv.c                 |  116 +-
 drivers/staging/cxt1e1/pmcc4_private.h             |    1 -
 drivers/staging/cxt1e1/pmcc4_sysdep.h              |    1 +
 drivers/staging/cxt1e1/sbeproc.c                   |    4 +-
 drivers/staging/dgap/Makefile                      |    6 -
 drivers/staging/dgap/dgap.c                        | 7675 ++++++++++++++++++++
 drivers/staging/dgap/dgap.h                        | 1322 ++++
 drivers/staging/dgap/dgap_conf.h                   |  290 -
 drivers/staging/dgap/dgap_downld.h                 |   69 -
 drivers/staging/dgap/dgap_driver.c                 | 1030 ---
 drivers/staging/dgap/dgap_driver.h                 |  620 --
 drivers/staging/dgap/dgap_fep5.c                   | 1938 -----
 drivers/staging/dgap/dgap_fep5.h                   |  253 -
 drivers/staging/dgap/dgap_kcompat.h                |   64 -
 drivers/staging/dgap/dgap_parse.c                  | 1374 ----
 drivers/staging/dgap/dgap_parse.h                  |   35 -
 drivers/staging/dgap/dgap_pci.h                    |   92 -
 drivers/staging/dgap/dgap_sysfs.c                  |  793 --
 drivers/staging/dgap/dgap_sysfs.h                  |   48 -
 drivers/staging/dgap/dgap_trace.c                  |  186 -
 drivers/staging/dgap/dgap_trace.h                  |   36 -
 drivers/staging/dgap/dgap_tty.c                    | 3580 ---------
 drivers/staging/dgap/dgap_tty.h                    |   39 -
 drivers/staging/dgap/dgap_types.h                  |   36 -
 drivers/staging/dgap/digi.h                        |  376 -
 drivers/staging/dgap/downld.c                      |  798 --
 drivers/staging/dgnc/dgnc_cls.c                    |   11 +-
 drivers/staging/dgnc/dgnc_driver.c                 |    4 +-
 drivers/staging/dgnc/dgnc_mgmt.c                   |   27 +-
 drivers/staging/dgnc/dgnc_neo.c                    |    3 +-
 drivers/staging/dgnc/dgnc_tty.c                    |   53 +-
 drivers/staging/dgrp/dgrp_sysfs.c                  |    4 +-
 drivers/staging/dgrp/dgrp_tty.c                    |   22 +-
 drivers/staging/echo/TODO                          |    5 -
 drivers/staging/et131x/et131x.c                    |   23 +-
 drivers/staging/frontier/alphatrack.c              |   11 +-
 drivers/staging/frontier/tranzport.c               |   12 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |    8 +-
 drivers/staging/ft1000/ft1000.h                    |  156 +-
 drivers/staging/gdm724x/gdm_lte.c                  |  187 +-
 drivers/staging/gdm724x/gdm_lte.h                  |    2 +-
 drivers/staging/gdm724x/gdm_mux.c                  |   26 +-
 drivers/staging/gdm724x/gdm_usb.c                  |   56 +-
 drivers/staging/gdm724x/netlink_k.c                |    3 +-
 drivers/staging/gdm72xx/TODO                       |    2 -
 drivers/staging/gdm72xx/gdm_sdio.c                 |   50 +-
 drivers/staging/gdm72xx/gdm_usb.c                  |   37 +-
 drivers/staging/gdm72xx/gdm_wimax.c                |   77 +-
 drivers/staging/gdm72xx/gdm_wimax.h                |   20 -
 drivers/staging/gs_fpgaboot/Kconfig                |    8 +
 drivers/staging/gs_fpgaboot/Makefile               |    4 +
 drivers/staging/gs_fpgaboot/README                 |   71 +
 drivers/staging/gs_fpgaboot/TODO                   |    7 +
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c          |  422 ++
 drivers/staging/gs_fpgaboot/gs_fpgaboot.h          |   56 +
 drivers/staging/gs_fpgaboot/io.c                   |  294 +
 drivers/staging/gs_fpgaboot/io.h                   |   90 +
 drivers/staging/iio/Documentation/iio_utils.h      |   22 +
 drivers/staging/iio/Documentation/lsiio.c          |  157 +
 drivers/staging/iio/accel/sca3000.h                |   26 +-
 drivers/staging/iio/accel/sca3000_core.c           |  172 +-
 drivers/staging/iio/accel/sca3000_ring.c           |    2 +-
 drivers/staging/iio/adc/ad799x.h                   |   10 +-
 drivers/staging/iio/adc/ad799x_core.c              |   56 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   15 +-
 drivers/staging/iio/addac/adt7316.c                |   21 +-
 drivers/staging/iio/addac/adt7316.h                |    8 +-
 drivers/staging/iio/light/tsl2583.c                |    6 +-
 drivers/staging/iio/light/tsl2x7x_core.c           |    8 +-
 drivers/staging/iio/resolver/ad2s1210.c            |    4 +-
 drivers/staging/imx-drm/Kconfig                    |    1 +
 drivers/staging/imx-drm/Makefile                   |    3 +-
 drivers/staging/imx-drm/TODO                       |    5 -
 drivers/staging/imx-drm/imx-drm-core.c             |  859 +--
 drivers/staging/imx-drm/imx-drm.h                  |   44 +-
 drivers/staging/imx-drm/imx-fb.c                   |   47 -
 drivers/staging/imx-drm/imx-fbdev.c                |   74 -
 drivers/staging/imx-drm/imx-hdmi.c                 |  695 +-
 drivers/staging/imx-drm/imx-ldb.c                  |  150 +-
 drivers/staging/imx-drm/imx-tve.c                  |  137 +-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |    2 +
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |  317 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |    3 -
 drivers/staging/imx-drm/ipuv3-crtc.c               |   93 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |    4 +-
 drivers/staging/imx-drm/parallel-display.c         |  127 +-
 drivers/staging/keucr/common.h                     |    8 -
 drivers/staging/keucr/init.c                       |   16 +-
 drivers/staging/keucr/init.h                       |    6 +-
 drivers/staging/keucr/smil.h                       |  112 +-
 drivers/staging/keucr/smilecc.c                    |   58 +-
 drivers/staging/keucr/smilmain.c                   |   82 +-
 drivers/staging/keucr/smilsub.c                    |  170 +-
 drivers/staging/keucr/smscsi.c                     |   28 +-
 drivers/staging/keucr/transport.c                  |    8 +-
 drivers/staging/keucr/transport.h                  |    6 +-
 drivers/staging/keucr/usb.c                        |    6 +-
 drivers/staging/keucr/usb.h                        |   86 +-
 drivers/staging/line6/capture.c                    |    1 +
 drivers/staging/line6/driver.c                     |   56 +-
 drivers/staging/line6/driver.h                     |    2 +-
 drivers/staging/line6/midi.c                       |    5 +-
 drivers/staging/line6/usbdefs.h                    |    8 +-
 .../staging/lustre/include/linux/libcfs/curproc.h  |    9 -
 .../lustre/include/linux/libcfs/libcfs_hash.h      |    2 -
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    8 +-
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    9 -
 .../lustre/include/linux/libcfs/libcfs_string.h    |   30 -
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    2 +-
 .../staging/lustre/include/linux/lnet/lib-types.h  |   16 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |  132 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   10 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    6 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   15 +-
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |    3 +-
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |    6 +-
 drivers/staging/lustre/lnet/lnet/acceptor.c        |    3 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    5 +-
 drivers/staging/lustre/lnet/lnet/config.c          |   12 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    7 +-
 drivers/staging/lustre/lnet/lnet/lib-ptl.c         |    2 +-
 drivers/staging/lustre/lnet/lnet/peer.c            |    3 +-
 drivers/staging/lustre/lnet/lnet/router.c          |   12 +-
 drivers/staging/lustre/lnet/lnet/router_proc.c     |    4 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c      |    3 +-
 drivers/staging/lustre/lnet/selftest/console.c     |   24 +-
 drivers/staging/lustre/lnet/selftest/rpc.c         |    3 +-
 drivers/staging/lustre/lnet/selftest/selftest.h    |    6 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |   34 +-
 drivers/staging/lustre/lustre/fld/fld_cache.c      |    6 +-
 drivers/staging/lustre/lustre/fld/fld_internal.h   |    2 +-
 drivers/staging/lustre/lustre/fld/fld_request.c    |   15 +-
 drivers/staging/lustre/lustre/include/cl_object.h  |   14 +-
 drivers/staging/lustre/lustre/include/ioctl.h      |    2 +-
 drivers/staging/lustre/lustre/include/lclient.h    |    4 +-
 .../lustre/lustre/include/linux/lustre_acl.h       |    2 +-
 drivers/staging/lustre/lustre/include/linux/obd.h  |    3 +-
 .../lustre/lustre/include/lustre/lustre_idl.h      |   85 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   22 +-
 drivers/staging/lustre/lustre/include/lustre_cfg.h |    2 +
 .../staging/lustre/lustre/include/lustre_disk.h    |    2 +
 drivers/staging/lustre/lustre/include/lustre_dlm.h |    4 +-
 .../lustre/lustre/include/lustre_dlm_flags.h       |   18 +-
 .../staging/lustre/lustre/include/lustre_export.h  |   21 +-
 drivers/staging/lustre/lustre/include/lustre_fid.h |   12 +-
 .../staging/lustre/lustre/include/lustre_import.h  |   21 +-
 drivers/staging/lustre/lustre/include/lustre_lib.h |    8 +-
 .../staging/lustre/lustre/include/lustre_linkea.h  |    2 +-
 drivers/staging/lustre/lustre/include/lustre_mdc.h |   11 +
 drivers/staging/lustre/lustre/include/lustre_net.h |   26 +-
 .../staging/lustre/lustre/include/lustre_quota.h   |    2 +-
 drivers/staging/lustre/lustre/include/lustre_sec.h |    4 +-
 drivers/staging/lustre/lustre/include/md_object.h  |    2 +-
 drivers/staging/lustre/lustre/include/obd.h        |   11 +-
 drivers/staging/lustre/lustre/include/obd_class.h  |   15 +-
 .../staging/lustre/lustre/include/obd_support.h    |    2 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   41 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    5 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    4 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |    4 +-
 drivers/staging/lustre/lustre/libcfs/fail.c        |    4 +-
 .../lustre/lustre/libcfs/kernel_user_comm.c        |  102 -
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   54 +-
 .../staging/lustre/lustre/libcfs/linux/linux-cpu.c |   19 +-
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   65 +-
 .../lustre/lustre/libcfs/linux/linux-module.c      |    4 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   38 -
 drivers/staging/lustre/lustre/libcfs/nidstrings.c  |    7 +-
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    5 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |    5 +-
 drivers/staging/lustre/lustre/libcfs/workitem.c    |   10 +-
 drivers/staging/lustre/lustre/llite/dcache.c       |  328 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   35 +-
 drivers/staging/lustre/lustre/llite/file.c         |  105 +-
 drivers/staging/lustre/lustre/llite/llite_close.c  |    2 +-
 .../staging/lustre/lustre/llite/llite_internal.h   |   42 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   30 +-
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |    4 +-
 drivers/staging/lustre/lustre/llite/llite_nfs.c    |    6 +-
 drivers/staging/lustre/lustre/llite/lloop.c        |    6 +-
 drivers/staging/lustre/lustre/llite/namei.c        |  124 +-
 drivers/staging/lustre/lustre/llite/rw.c           |   10 +-
 drivers/staging/lustre/lustre/llite/statahead.c    |   14 +-
 drivers/staging/lustre/lustre/llite/vvp_io.c       |   37 +-
 drivers/staging/lustre/lustre/llite/xattr.c        |   31 +-
 drivers/staging/lustre/lustre/llite/xattr_cache.c  |  125 +-
 drivers/staging/lustre/lustre/lmv/lmv_intent.c     |    1 -
 drivers/staging/lustre/lustre/lmv/lmv_obd.c        |    5 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |    5 +-
 drivers/staging/lustre/lustre/lov/lov_ea.c         |    2 +-
 drivers/staging/lustre/lustre/lov/lov_io.c         |    1 +
 drivers/staging/lustre/lustre/lov/lov_obd.c        |    6 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |   16 +-
 drivers/staging/lustre/lustre/lov/lov_pack.c       |    3 +-
 drivers/staging/lustre/lustre/lov/lov_request.c    |    2 +-
 drivers/staging/lustre/lustre/lov/lovsub_dev.c     |    4 +
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_internal.h   |    4 +-
 drivers/staging/lustre/lustre/mdc/mdc_lib.c        |    2 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |  117 +-
 drivers/staging/lustre/lustre/mdc/mdc_reint.c      |    3 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   74 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |   92 +-
 drivers/staging/lustre/lustre/obdclass/cl_io.c     |    2 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    4 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/genops.c    |   12 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |    2 +-
 drivers/staging/lustre/lustre/obdclass/llog_cat.c  |    6 +-
 drivers/staging/lustre/lustre/obdclass/llog_lvfs.c |    2 +-
 drivers/staging/lustre/lustre/obdclass/llog_osd.c  |    6 +-
 .../staging/lustre/lustre/obdclass/local_storage.c |    2 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    2 +
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   10 +-
 drivers/staging/lustre/lustre/obdclass/md_attrs.c  |    6 +-
 .../staging/lustre/lustre/obdclass/obd_config.c    |   54 +-
 drivers/staging/lustre/lustre/obdclass/obd_mount.c |    4 +-
 drivers/staging/lustre/lustre/obdclass/obdo.c      |    6 +-
 drivers/staging/lustre/lustre/obdecho/echo.c       |    3 +-
 .../staging/lustre/lustre/obdecho/echo_client.c    |   20 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c      |   12 +-
 drivers/staging/lustre/lustre/osc/osc_io.c         |   16 +-
 drivers/staging/lustre/lustre/osc/osc_page.c       |    2 +-
 drivers/staging/lustre/lustre/osc/osc_quota.c      |   20 +-
 drivers/staging/lustre/lustre/ptlrpc/client.c      |  187 +-
 drivers/staging/lustre/lustre/ptlrpc/events.c      |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_cli_upcall.c      |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_generic_token.c   |   36 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_keyring.c |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_krb5_mech.c       |    4 +-
 .../staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c  |    4 +-
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c |   14 +-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |   37 +-
 drivers/staging/lustre/lustre/ptlrpc/layout.c      |    5 +-
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |    8 +-
 drivers/staging/lustre/lustre/ptlrpc/nrs.c         |    4 +-
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |   14 +-
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |    4 +-
 drivers/staging/lustre/lustre/ptlrpc/recover.c     |   57 +-
 drivers/staging/lustre/lustre/ptlrpc/sec.c         |   18 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    6 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c  |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c     |   12 +-
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    2 +
 drivers/staging/media/as102/as10x_handle.h         |   14 +-
 drivers/staging/media/cxd2099/cxd2099.c            |   12 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |    2 +-
 drivers/staging/media/go7007/go7007-loader.c       |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |   20 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c      |    2 +-
 drivers/staging/media/lirc/lirc_imon.c             |    4 +
 drivers/staging/media/lirc/lirc_parallel.c         |   26 +-
 drivers/staging/media/lirc/lirc_sasem.c            |   13 +-
 drivers/staging/media/msi3101/sdr-msi3101.c        |    2 +-
 drivers/staging/media/omap24xx/tcm825x.c           |    8 +-
 drivers/staging/media/omap24xx/tcm825x.h           |    2 +-
 drivers/staging/media/sn9c102/sn9c102_core.c       |   85 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131d.c    |   15 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c    |   15 +-
 drivers/staging/media/sn9c102/sn9c102_ov7630.c     |   24 +-
 drivers/staging/media/sn9c102/sn9c102_ov7660.c     |   24 +-
 drivers/staging/media/sn9c102/sn9c102_pas106b.c    |   18 +-
 drivers/staging/media/sn9c102/sn9c102_pas202bcb.c  |   15 +-
 drivers/staging/media/solo6x10/solo6x10-core.c     |    2 +-
 drivers/staging/media/solo6x10/solo6x10-tw28.c     |    2 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |   44 +-
 drivers/staging/netlogic/xlr_net.c                 |    5 +-
 drivers/staging/nokia_h4p/Kconfig                  |    9 +
 drivers/staging/nokia_h4p/Makefile                 |    6 +
 drivers/staging/nokia_h4p/TODO                     |  132 +
 drivers/staging/nokia_h4p/hci_h4p.h                |  222 +
 drivers/staging/nokia_h4p/nokia_core.c             | 1206 +++
 drivers/staging/nokia_h4p/nokia_fw-bcm.c           |  148 +
 drivers/staging/nokia_h4p/nokia_fw-csr.c           |  149 +
 drivers/staging/nokia_h4p/nokia_fw-ti1273.c        |  110 +
 drivers/staging/nokia_h4p/nokia_fw.c               |  208 +
 drivers/staging/nokia_h4p/nokia_uart.c             |  199 +
 drivers/staging/nvec/nvec.c                        |    3 +-
 drivers/staging/nvec/nvec_ps2.c                    |    2 +-
 drivers/staging/octeon-usb/octeon-hcd.c            |  752 +-
 drivers/staging/octeon/ethernet-defines.h          |    4 -
 drivers/staging/octeon/ethernet-mdio.c             |   20 +-
 drivers/staging/octeon/ethernet-mem.c              |   11 +-
 drivers/staging/octeon/ethernet-rgmii.c            |   23 +-
 drivers/staging/octeon/ethernet-tx.c               |    2 +-
 drivers/staging/octeon/ethernet.c                  |   10 +-
 drivers/staging/octeon/octeon-ethernet.h           |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon.h              |    2 +-
 drivers/staging/ozwpan/ozcdev.c                    |    4 +-
 drivers/staging/ozwpan/ozhcd.c                     |    8 +-
 drivers/staging/ozwpan/ozpd.c                      |   31 +-
 drivers/staging/ozwpan/ozpd.h                      |    5 +
 drivers/staging/ozwpan/ozproto.c                   |   57 +-
 drivers/staging/ozwpan/ozproto.h                   |    2 -
 drivers/staging/ozwpan/ozprotocol.h                |    6 +-
 drivers/staging/ozwpan/ozusbif.h                   |    2 +-
 drivers/staging/ozwpan/ozusbsvc1.c                 |    2 +-
 drivers/staging/panel/panel.c                      |   41 +-
 drivers/staging/rtl8187se/Module.symvers           |    0
 drivers/staging/rtl8187se/ieee80211/dot11d.h       |   11 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |   12 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     |    2 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_tkip.c     |   14 +-
 .../rtl8187se/ieee80211/ieee80211_crypt_wep.c      |   15 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        | 1203 ++-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |  151 +-
 drivers/staging/rtl8187se/r8180.h                  |  750 +-
 drivers/staging/rtl8187se/r8180_core.c             |  894 +--
 drivers/staging/rtl8187se/r8180_dm.c               |    6 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   21 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |   59 +-
 drivers/staging/rtl8187se/r8180_wx.c               |   10 +-
 drivers/staging/rtl8187se/r8185b_init.c            |   62 +-
 drivers/staging/rtl8188eu/Kconfig                  |    4 +-
 drivers/staging/rtl8188eu/Makefile                 |    1 -
 drivers/staging/rtl8188eu/TODO                     |    5 +
 drivers/staging/rtl8188eu/core/rtw_ap.c            |   81 +-
 drivers/staging/rtl8188eu/core/rtw_br_ext.c        |   13 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c           |  220 +-
 drivers/staging/rtl8188eu/core/rtw_debug.c         |   12 +-
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |   59 +-
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |   58 +-
 drivers/staging/rtl8188eu/core/rtw_io.c            |   28 -
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c     |   52 +-
 drivers/staging/rtl8188eu/core/rtw_led.c           |    4 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c          |  303 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      |  302 +-
 drivers/staging/rtl8188eu/core/rtw_mp.c            |   16 +-
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      |   78 -
 drivers/staging/rtl8188eu/core/rtw_p2p.c           |   50 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |   27 +-
 drivers/staging/rtl8188eu/core/rtw_recv.c          |  502 +-
 drivers/staging/rtl8188eu/core/rtw_security.c      |   93 +-
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c       |   87 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |   46 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c          |  129 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |   13 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   37 +-
 drivers/staging/rtl8188eu/hal/hal_intf.c           |    4 -
 drivers/staging/rtl8188eu/hal/odm.c                |   15 +-
 drivers/staging/rtl8188eu/hal/odm_RegConfig8188E.c |    4 +-
 drivers/staging/rtl8188eu/hal/odm_interface.c      |  101 -
 drivers/staging/rtl8188eu/hal/rtl8188e_cmd.c       |   12 -
 drivers/staging/rtl8188eu/hal/rtl8188e_dm.c        |    2 -
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |   87 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_mp.c        |   10 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rxdesc.c    |   37 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c     |    3 -
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c     |    6 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   10 -
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |   63 +-
 drivers/staging/rtl8188eu/include/drv_types.h      |    6 +
 drivers/staging/rtl8188eu/include/ethernet.h       |   42 -
 drivers/staging/rtl8188eu/include/h2clbk.h         |   35 -
 drivers/staging/rtl8188eu/include/if_ether.h       |  111 -
 drivers/staging/rtl8188eu/include/ioctl_cfg80211.h |  107 -
 drivers/staging/rtl8188eu/include/ip.h             |  126 -
 drivers/staging/rtl8188eu/include/nic_spec.h       |   44 -
 drivers/staging/rtl8188eu/include/odm_interface.h  |   23 -
 drivers/staging/rtl8188eu/include/osdep_service.h  |   34 -
 drivers/staging/rtl8188eu/include/recv_osdep.h     |   10 +-
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |   11 -
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h  |    7 +-
 drivers/staging/rtl8188eu/include/rtw_debug.h      |   24 -
 drivers/staging/rtl8188eu/include/rtw_io.h         |   44 -
 drivers/staging/rtl8188eu/include/rtw_ioctl.h      |    2 -
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |   32 -
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |   49 +-
 drivers/staging/rtl8188eu/include/rtw_pwrctrl.h    |    4 -
 drivers/staging/rtl8188eu/include/rtw_recv.h       |  139 +-
 drivers/staging/rtl8188eu/include/rtw_xmit.h       |    5 -
 drivers/staging/rtl8188eu/include/wifi.h           |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |  242 +-
 drivers/staging/rtl8188eu/os_dep/mlme_linux.c      |    9 +-
 drivers/staging/rtl8188eu/os_dep/os_intfs.c        |   10 +-
 drivers/staging/rtl8188eu/os_dep/osdep_service.c   |   35 +-
 drivers/staging/rtl8188eu/os_dep/recv_linux.c      |   44 +-
 drivers/staging/rtl8188eu/os_dep/rtw_android.c     |    1 -
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   19 +-
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c   |    5 -
 drivers/staging/rtl8188eu/os_dep/xmit_linux.c      |   17 +-
 drivers/staging/rtl8192e/dot11d.c                  |    9 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.h        |   52 -
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |    2 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |    4 +-
 drivers/staging/rtl8192u/ieee80211/EndianFree.h    |  194 -
 drivers/staging/rtl8192u/ieee80211/aes.c           |  468 --
 drivers/staging/rtl8192u/ieee80211/arc4.c          |  103 -
 drivers/staging/rtl8192u/ieee80211/autoload.c      |   40 -
 drivers/staging/rtl8192u/ieee80211/cipher.c        |  298 -
 drivers/staging/rtl8192u/ieee80211/compress.c      |   64 -
 drivers/staging/rtl8192u/ieee80211/crypto_compat.h |   58 -
 drivers/staging/rtl8192u/ieee80211/digest.c        |  108 -
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |  173 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   22 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |  107 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    5 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/internal.h      |   81 -
 drivers/staging/rtl8192u/ieee80211/michael_mic.c   |  194 -
 drivers/staging/rtl8192u/ieee80211/proc.c          |  112 -
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |   12 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |   70 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |   39 +-
 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |  398 -
 drivers/staging/rtl8192u/ieee80211/scatterwalk.c   |  117 -
 drivers/staging/rtl8192u/ieee80211/scatterwalk.h   |   51 -
 drivers/staging/rtl8192u/r8180_93cx6.c             |   10 +-
 drivers/staging/rtl8192u/r8192U_core.c             |  138 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |   99 +-
 drivers/staging/rtl8192u/r8192U_dm.h               |   40 +-
 drivers/staging/rtl8192u/r819xU_HTGen.h            |   12 -
 drivers/staging/rtl8192u/r819xU_HTType.h           |  379 -
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   50 +-
 drivers/staging/rtl8192u/r819xU_firmware_img.c     |    1 +
 drivers/staging/rtl8192u/r819xU_phy.c              |   29 +-
 drivers/staging/rtl8712/drv_types.h                |    2 +-
 drivers/staging/rtl8712/ieee80211.c                |    6 +-
 drivers/staging/rtl8712/os_intfs.c                 |    2 +-
 drivers/staging/rtl8712/osdep_service.h            |    5 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 -
 drivers/staging/rtl8712/rtl871x_cmd.c              |   11 +-
 drivers/staging/rtl8712/rtl871x_security.c         |   13 +-
 drivers/staging/rtl8821ae/base.c                   |  199 +-
 .../staging/rtl8821ae/btcoexist/HalBtc8812a1Ant.c  |    2 +-
 .../staging/rtl8821ae/btcoexist/habtc8723a1ant.c   |    2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8192e1ant.c  |    2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8192e2ant.c  |    2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723a2ant.c  |    2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723b1ant.c  |    2 +-
 .../staging/rtl8821ae/btcoexist/halbtc8723b2ant.c  |    2 +-
 drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c |   12 +-
 drivers/staging/rtl8821ae/core.c                   |   12 +-
 drivers/staging/rtl8821ae/core.h                   |    8 +-
 drivers/staging/rtl8821ae/debug.c                  |   10 +-
 drivers/staging/rtl8821ae/debug.h                  |   12 +-
 drivers/staging/rtl8821ae/efuse.c                  |   26 +-
 drivers/staging/rtl8821ae/pci.c                    |  274 +-
 drivers/staging/rtl8821ae/pci.h                    |    8 +-
 drivers/staging/rtl8821ae/ps.c                     |    2 +-
 drivers/staging/rtl8821ae/regd.c                   |    4 +-
 drivers/staging/rtl8821ae/regd.h                   |    4 +-
 drivers/staging/rtl8821ae/rtl8821ae/dm.c           |   24 +-
 drivers/staging/rtl8821ae/rtl8821ae/fw.c           |    8 +-
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.h   |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c      |    6 +-
 drivers/staging/rtl8821ae/rtl8821ae/hw.c           |   13 +-
 drivers/staging/rtl8821ae/rtl8821ae/phy.c          |    8 +-
 drivers/staging/rtl8821ae/rtl8821ae/phy.h          |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/pwrseq.h       |   10 +-
 drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.c    |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/reg.h          |   28 +-
 drivers/staging/rtl8821ae/rtl8821ae/sw.c           |    4 +-
 drivers/staging/rtl8821ae/rtl8821ae/trx.c          |   10 +-
 drivers/staging/rtl8821ae/wifi.h                   |  486 +-
 drivers/staging/rts5139/ms.c                       |   21 +-
 drivers/staging/rts5139/ms_mg.c                    |    1 +
 drivers/staging/rts5139/rts51x.c                   |    6 +-
 drivers/staging/rts5139/rts51x_fop.c               |   10 +-
 drivers/staging/rts5139/rts51x_fop.h               |    4 +-
 drivers/staging/rts5139/rts51x_scsi.c              |    4 +-
 drivers/staging/rts5139/rts51x_transport.c         |    4 +-
 drivers/staging/rts5139/sd.c                       |    4 +-
 drivers/staging/rts5139/sd_cprm.c                  |    1 +
 drivers/staging/rts5139/xd.c                       |   18 +-
 drivers/staging/rts5208/ms.c                       |    2 +-
 drivers/staging/rts5208/rtsx.c                     |    6 +-
 drivers/staging/rts5208/rtsx_card.c                |   71 +-
 drivers/staging/rts5208/rtsx_scsi.c                |    8 +-
 drivers/staging/rts5208/rtsx_transport.c           |    4 +-
 drivers/staging/sb105x/Kconfig                     |    9 -
 drivers/staging/sb105x/Makefile                    |    3 -
 drivers/staging/sb105x/sb_mp_register.h            |  295 -
 drivers/staging/sb105x/sb_pci_mp.c                 | 3189 --------
 drivers/staging/sb105x/sb_pci_mp.h                 |  291 -
 drivers/staging/sb105x/sb_ser_core.h               |  368 -
 drivers/staging/sbe-2t3e3/2t3e3.h                  |   21 +-
 drivers/staging/sbe-2t3e3/ctrl.c                   |   17 +-
 drivers/staging/sbe-2t3e3/ctrl.h                   |   16 +-
 drivers/staging/sbe-2t3e3/dc.c                     |    7 +-
 drivers/staging/sbe-2t3e3/intr.c                   |    4 +-
 drivers/staging/sbe-2t3e3/maps.c                   |    9 +-
 drivers/staging/sbe-2t3e3/module.c                 |    2 +-
 drivers/staging/sbe-2t3e3/netdev.c                 |    6 +-
 drivers/staging/sep/sep_crypto.c                   |    2 +-
 drivers/staging/sep/sep_main.c                     |   94 +-
 drivers/staging/serqt_usb2/serqt_usb2.c            |   18 +-
 drivers/staging/silicom/bp_mod.h                   |   25 +-
 drivers/staging/silicom/bpctl_mod.c                |  629 +-
 drivers/staging/silicom/bypasslib/bp_ioctl.h       |    8 +-
 drivers/staging/silicom/bypasslib/libbp_sd.h       |  313 +-
 drivers/staging/slicoss/README                     |   40 -
 drivers/staging/slicoss/TODO                       |   38 +
 drivers/staging/slicoss/slic.h                     |    9 +-
 drivers/staging/slicoss/slicoss.c                  |   73 +-
 drivers/staging/sm7xxfb/Kconfig                    |   13 -
 drivers/staging/sm7xxfb/Makefile                   |    1 -
 drivers/staging/sm7xxfb/TODO                       |    9 -
 drivers/staging/sm7xxfb/sm7xx.h                    |  779 --
 drivers/staging/sm7xxfb/sm7xxfb.c                  | 1028 ---
 drivers/staging/speakup/serialio.c                 |    4 +-
 drivers/staging/speakup/speakup_dectlk.c           |    6 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/core/io_sm.c           |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   23 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   15 +-
 drivers/staging/tidspbridge/dynload/tramp.c        |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    4 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |    8 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    5 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   20 +-
 drivers/staging/unisys/Documentation/overview.txt  |  174 +
 .../staging/unisys/Documentation/proc-entries.txt  |   93 +
 drivers/staging/unisys/Kconfig                     |   20 +
 drivers/staging/unisys/MAINTAINERS                 |    6 +
 drivers/staging/unisys/Makefile                    |   10 +
 drivers/staging/unisys/TODO                        |   21 +
 drivers/staging/unisys/channels/Kconfig            |   10 +
 drivers/staging/unisys/channels/Makefile           |   13 +
 drivers/staging/unisys/channels/channel.c          |  219 +
 drivers/staging/unisys/channels/chanstub.c         |   70 +
 drivers/staging/unisys/channels/chanstub.h         |   23 +
 .../unisys/common-spar/include/channels/channel.h  |  661 ++
 .../common-spar/include/channels/channel_guid.h    |   64 +
 .../include/channels/controlframework.h            |   77 +
 .../include/channels/controlvmchannel.h            |  619 ++
 .../common-spar/include/channels/diagchannel.h     |  427 ++
 .../common-spar/include/channels/iochannel.h       |  933 +++
 .../common-spar/include/channels/vbuschannel.h     |  135 +
 .../include/controlvmcompletionstatus.h            |   92 +
 .../include/diagnostics/appos_subsystems.h         |  310 +
 .../unisys/common-spar/include/iovmcall_gnuc.h     |   53 +
 .../unisys/common-spar/include/vbusdeviceinfo.h    |  209 +
 .../staging/unisys/common-spar/include/version.h   |   46 +
 .../unisys/common-spar/include/vmcallinterface.h   |  167 +
 drivers/staging/unisys/include/commontypes.h       |  170 +
 drivers/staging/unisys/include/guestlinuxdebug.h   |  182 +
 drivers/staging/unisys/include/guidutils.h         |  203 +
 drivers/staging/unisys/include/periodic_work.h     |   40 +
 drivers/staging/unisys/include/procobjecttree.h    |   48 +
 drivers/staging/unisys/include/sparstop.h          |   30 +
 drivers/staging/unisys/include/timskmod.h          |  324 +
 drivers/staging/unisys/include/timskmodutils.h     |   75 +
 drivers/staging/unisys/include/uisqueue.h          |  440 ++
 drivers/staging/unisys/include/uisthread.h         |   46 +
 drivers/staging/unisys/include/uisutils.h          |  348 +
 drivers/staging/unisys/include/uniklog.h           |  193 +
 drivers/staging/unisys/include/vbushelper.h        |   47 +
 drivers/staging/unisys/uislib/Kconfig              |   10 +
 drivers/staging/unisys/uislib/Makefile             |   17 +
 drivers/staging/unisys/uislib/uislib.c             | 2421 ++++++
 drivers/staging/unisys/uislib/uisqueue.c           |  160 +
 drivers/staging/unisys/uislib/uisthread.c          |   85 +
 drivers/staging/unisys/uislib/uisutils.c           |  350 +
 drivers/staging/unisys/virthba/Kconfig             |   10 +
 drivers/staging/unisys/virthba/Makefile            |   16 +
 drivers/staging/unisys/virthba/virthba.c           | 1823 +++++
 drivers/staging/unisys/virthba/virthba.h           |   31 +
 drivers/staging/unisys/virtpci/Kconfig             |   10 +
 drivers/staging/unisys/virtpci/Makefile            |   13 +
 drivers/staging/unisys/virtpci/virtpci.c           | 1771 +++++
 drivers/staging/unisys/virtpci/virtpci.h           |  104 +
 drivers/staging/unisys/visorchannel/Kconfig        |   10 +
 drivers/staging/unisys/visorchannel/Makefile       |   14 +
 drivers/staging/unisys/visorchannel/globals.h      |   29 +
 drivers/staging/unisys/visorchannel/visorchannel.h |  106 +
 .../unisys/visorchannel/visorchannel_funcs.c       |  674 ++
 .../unisys/visorchannel/visorchannel_main.c        |   49 +
 drivers/staging/unisys/visorchipset/Kconfig        |   10 +
 drivers/staging/unisys/visorchipset/Makefile       |   18 +
 drivers/staging/unisys/visorchipset/controlvm.h    |   27 +
 .../staging/unisys/visorchipset/controlvm_direct.c |   62 +
 drivers/staging/unisys/visorchipset/file.c         |  226 +
 drivers/staging/unisys/visorchipset/file.h         |   26 +
 drivers/staging/unisys/visorchipset/filexfer.c     |  506 ++
 drivers/staging/unisys/visorchipset/filexfer.h     |  147 +
 drivers/staging/unisys/visorchipset/globals.h      |   45 +
 drivers/staging/unisys/visorchipset/parser.c       |  474 ++
 drivers/staging/unisys/visorchipset/parser.h       |   45 +
 drivers/staging/unisys/visorchipset/testing.h      |   41 +
 drivers/staging/unisys/visorchipset/visorchipset.h |  307 +
 .../unisys/visorchipset/visorchipset_main.c        | 2945 ++++++++
 .../unisys/visorchipset/visorchipset_umode.h       |   37 +
 drivers/staging/unisys/visorutil/Kconfig           |   10 +
 drivers/staging/unisys/visorutil/Makefile          |   11 +
 drivers/staging/unisys/visorutil/charqueue.c       |  141 +
 drivers/staging/unisys/visorutil/charqueue.h       |   37 +
 drivers/staging/unisys/visorutil/easyproc.c        |  371 +
 drivers/staging/unisys/visorutil/easyproc.h        |   92 +
 drivers/staging/unisys/visorutil/memregion.h       |   43 +
 .../staging/unisys/visorutil/memregion_direct.c    |  223 +
 drivers/staging/unisys/visorutil/periodic_work.c   |  236 +
 drivers/staging/unisys/visorutil/procobjecttree.c  |  348 +
 drivers/staging/unisys/visorutil/visorkmodutils.c  |   71 +
 drivers/staging/usbip/stub.h                       |    3 +-
 drivers/staging/usbip/stub_dev.c                   |  164 +-
 drivers/staging/usbip/stub_main.c                  |   45 +-
 drivers/staging/usbip/stub_rx.c                    |   28 +-
 drivers/staging/usbip/stub_tx.c                    |   16 +-
 drivers/staging/usbip/uapi/usbip.h                 |   26 +
 drivers/staging/usbip/usbip_common.c               |   35 +-
 drivers/staging/usbip/usbip_common.h               |   19 +-
 drivers/staging/usbip/userspace/README             |    8 +-
 drivers/staging/usbip/userspace/configure.ac       |   12 +-
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    3 +-
 drivers/staging/usbip/userspace/libsrc/list.h      |  136 +
 .../staging/usbip/userspace/libsrc/sysfs_utils.c   |   31 +
 .../staging/usbip/userspace/libsrc/sysfs_utils.h   |    8 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |   93 +-
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   41 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  303 +-
 .../usbip/userspace/libsrc/usbip_host_driver.h     |    7 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  397 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   14 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |    1 -
 drivers/staging/usbip/userspace/src/usbip_attach.c |    1 -
 drivers/staging/usbip/userspace/src/usbip_bind.c   |  195 +-
 drivers/staging/usbip/userspace/src/usbip_detach.c |    2 -
 drivers/staging/usbip/userspace/src/usbip_list.c   |  146 +-
 .../staging/usbip/userspace/src/usbip_network.h    |    1 -
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  129 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |   21 +-
 drivers/staging/usbip/userspace/src/utils.c        |   48 +-
 drivers/staging/usbip/vhci_hcd.c                   |   44 +-
 drivers/staging/usbip/vhci_sysfs.c                 |   15 +-
 drivers/staging/vt6655/80211mgr.c                  |  331 +-
 drivers/staging/vt6655/aes_ccmp.c                  |   36 +-
 drivers/staging/vt6655/desc.h                      |   15 +-
 drivers/staging/vt6655/dpc.c                       |   36 +-
 drivers/staging/vt6655/key.c                       |    8 +-
 drivers/staging/vt6655/mac.c                       |   10 +-
 drivers/staging/vt6655/mac.h                       |    2 +-
 drivers/staging/vt6655/michael.c                   |   14 +-
 drivers/staging/vt6655/michael.h                   |    6 +-
 drivers/staging/vt6655/rxtx.c                      |   62 +-
 drivers/staging/vt6655/wmgr.c                      |   30 +-
 drivers/staging/vt6656/80211hdr.h                  |    2 +-
 drivers/staging/vt6656/aes_ccmp.c                  |    6 +-
 drivers/staging/vt6656/card.h                      |    7 -
 drivers/staging/vt6656/device.h                    |   85 +-
 drivers/staging/vt6656/dpc.c                       |   92 +-
 drivers/staging/vt6656/int.c                       |  150 +-
 drivers/staging/vt6656/int.h                       |   45 +-
 drivers/staging/vt6656/iwctl.c                     |   10 +-
 drivers/staging/vt6656/mac.c                       |   16 +-
 drivers/staging/vt6656/mac.h                       |    2 +-
 drivers/staging/vt6656/main_usb.c                  |  350 +-
 drivers/staging/vt6656/power.c                     |   50 +-
 drivers/staging/vt6656/rxtx.c                      |  185 +-
 drivers/staging/vt6656/rxtx.h                      |   92 +-
 drivers/staging/vt6656/usbpipe.c                   |  451 +-
 drivers/staging/vt6656/wcmd.c                      |   77 +-
 drivers/staging/vt6656/wcmd.h                      |    4 +-
 drivers/staging/vt6656/wmgr.c                      |    8 +-
 drivers/staging/winbond/localpara.h                |   84 +-
 drivers/staging/winbond/wb35reg.c                  |  140 +-
 drivers/staging/winbond/wb35rx.c                   |   27 +-
 drivers/staging/wlags49_h2/dhf.c                   |   10 +-
 drivers/staging/wlags49_h2/hcf.c                   |   16 +-
 drivers/staging/wlags49_h2/sta_h2.c                |    2 +-
 drivers/staging/wlags49_h2/wl_main.c               |  311 +-
 drivers/staging/wlags49_h2/wl_netdev.c             | 1992 ++---
 drivers/staging/wlags49_h2/wl_util.c               |   37 -
 drivers/staging/wlags49_h2/wl_wext.c               |    6 +-
 drivers/staging/wlan-ng/cfg80211.c                 |   11 +-
 drivers/staging/wlan-ng/hfa384x.h                  |    4 +-
 drivers/staging/wlan-ng/p80211mgmt.h               |  172 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    4 +-
 drivers/staging/wlan-ng/prism2fw.c                 |    2 +-
 drivers/staging/wlan-ng/prism2sta.c                |  100 +-
 drivers/staging/xgifb/XGI_main_26.c                |   15 +-
 drivers/staging/xillybus/Kconfig                   |    3 +-
 drivers/staging/xillybus/xillybus_core.c           |    6 +-
 drivers/usb/core/devio.c                           |  112 +-
 drivers/usb/core/generic.c                         |    1 +
 drivers/usb/core/hub.c                             |   14 +-
 drivers/usb/core/hub.h                             |    2 +-
 drivers/usb/core/message.c                         |    1 +
 drivers/usb/core/usb.h                             |    8 +-
 include/linux/hid-sensor-ids.h                     |   10 +
 include/linux/iio/iio.h                            |   16 +-
 include/linux/of_graph.h                           |   66 +
 include/linux/platform_data/bt-nokia-h4p.h         |   38 +
 include/linux/usb.h                                |   11 +
 include/media/v4l2-of.h                            |   33 +-
 943 files changed, 61729 insertions(+), 47873 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/graph.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
 create mode 100644 Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
 create mode 100644 Documentation/devicetree/bindings/staging/imx-drm/hdmi.txt
 create mode 100644 drivers/iio/adc/vf610_adc.c
 create mode 100644 drivers/iio/adc/xilinx-xadc-core.c
 create mode 100644 drivers/iio/adc/xilinx-xadc-events.c
 create mode 100644 drivers/iio/adc/xilinx-xadc.h
 create mode 100644 drivers/iio/humidity/si7005.c
 create mode 100644 drivers/iio/light/hid-sensor-prox.c
 create mode 100644 drivers/iio/light/ltr501.c
 create mode 100644 drivers/iio/pressure/hid-sensor-press.c
 rename drivers/{staging => misc}/echo/Kconfig (100%)
 rename drivers/{staging => misc}/echo/Makefile (100%)
 rename drivers/{staging => misc}/echo/echo.c (100%)
 rename drivers/{staging => misc}/echo/echo.h (100%)
 rename drivers/{staging => misc}/echo/fir.h (100%)
 rename drivers/{staging => misc}/echo/oslec.h (100%)
 create mode 100644 drivers/staging/android/uapi/android_alarm.h
 create mode 100644 drivers/staging/android/uapi/ashmem.h
 create mode 100644 drivers/staging/android/uapi/binder.h
 create mode 100644 drivers/staging/android/uapi/sw_sync.h
 create mode 100644 drivers/staging/android/uapi/sync.h
 create mode 100644 drivers/staging/comedi/drivers/dac02.c
 delete mode 100644 drivers/staging/comedi/drivers/poc.c
 delete mode 100644 drivers/staging/cxt1e1/ossiRelease.c
 create mode 100644 drivers/staging/dgap/dgap.c
 create mode 100644 drivers/staging/dgap/dgap.h
 delete mode 100644 drivers/staging/dgap/dgap_conf.h
 delete mode 100644 drivers/staging/dgap/dgap_downld.h
 delete mode 100644 drivers/staging/dgap/dgap_driver.c
 delete mode 100644 drivers/staging/dgap/dgap_driver.h
 delete mode 100644 drivers/staging/dgap/dgap_fep5.c
 delete mode 100644 drivers/staging/dgap/dgap_fep5.h
 delete mode 100644 drivers/staging/dgap/dgap_kcompat.h
 delete mode 100644 drivers/staging/dgap/dgap_parse.c
 delete mode 100644 drivers/staging/dgap/dgap_parse.h
 delete mode 100644 drivers/staging/dgap/dgap_pci.h
 delete mode 100644 drivers/staging/dgap/dgap_sysfs.c
 delete mode 100644 drivers/staging/dgap/dgap_sysfs.h
 delete mode 100644 drivers/staging/dgap/dgap_trace.c
 delete mode 100644 drivers/staging/dgap/dgap_trace.h
 delete mode 100644 drivers/staging/dgap/dgap_tty.c
 delete mode 100644 drivers/staging/dgap/dgap_tty.h
 delete mode 100644 drivers/staging/dgap/dgap_types.h
 delete mode 100644 drivers/staging/dgap/digi.h
 delete mode 100644 drivers/staging/dgap/downld.c
 delete mode 100644 drivers/staging/echo/TODO
 create mode 100644 drivers/staging/gs_fpgaboot/Kconfig
 create mode 100644 drivers/staging/gs_fpgaboot/Makefile
 create mode 100644 drivers/staging/gs_fpgaboot/README
 create mode 100644 drivers/staging/gs_fpgaboot/TODO
 create mode 100644 drivers/staging/gs_fpgaboot/gs_fpgaboot.c
 create mode 100644 drivers/staging/gs_fpgaboot/gs_fpgaboot.h
 create mode 100644 drivers/staging/gs_fpgaboot/io.c
 create mode 100644 drivers/staging/gs_fpgaboot/io.h
 create mode 100644 drivers/staging/iio/Documentation/lsiio.c
 delete mode 100644 drivers/staging/imx-drm/imx-fb.c
 delete mode 100644 drivers/staging/imx-drm/imx-fbdev.c
 create mode 100644 drivers/staging/nokia_h4p/Kconfig
 create mode 100644 drivers/staging/nokia_h4p/Makefile
 create mode 100644 drivers/staging/nokia_h4p/TODO
 create mode 100644 drivers/staging/nokia_h4p/hci_h4p.h
 create mode 100644 drivers/staging/nokia_h4p/nokia_core.c
 create mode 100644 drivers/staging/nokia_h4p/nokia_fw-bcm.c
 create mode 100644 drivers/staging/nokia_h4p/nokia_fw-csr.c
 create mode 100644 drivers/staging/nokia_h4p/nokia_fw-ti1273.c
 create mode 100644 drivers/staging/nokia_h4p/nokia_fw.c
 create mode 100644 drivers/staging/nokia_h4p/nokia_uart.c
 create mode 100644 drivers/staging/rtl8187se/Module.symvers
 delete mode 100644 drivers/staging/rtl8188eu/hal/odm_interface.c
 delete mode 100644 drivers/staging/rtl8188eu/include/ethernet.h
 delete mode 100644 drivers/staging/rtl8188eu/include/h2clbk.h
 delete mode 100644 drivers/staging/rtl8188eu/include/if_ether.h
 delete mode 100644 drivers/staging/rtl8188eu/include/ioctl_cfg80211.h
 delete mode 100644 drivers/staging/rtl8188eu/include/ip.h
 delete mode 100644 drivers/staging/rtl8188eu/include/nic_spec.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/EndianFree.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/aes.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/arc4.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/autoload.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/cipher.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/compress.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/crypto_compat.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/digest.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/internal.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/michael_mic.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/proc.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/scatterwalk.c
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/scatterwalk.h
 delete mode 100644 drivers/staging/rtl8192u/r819xU_HTGen.h
 delete mode 100644 drivers/staging/rtl8192u/r819xU_HTType.h
 delete mode 100644 drivers/staging/sb105x/Kconfig
 delete mode 100644 drivers/staging/sb105x/Makefile
 delete mode 100644 drivers/staging/sb105x/sb_mp_register.h
 delete mode 100644 drivers/staging/sb105x/sb_pci_mp.c
 delete mode 100644 drivers/staging/sb105x/sb_pci_mp.h
 delete mode 100644 drivers/staging/sb105x/sb_ser_core.h
 create mode 100644 drivers/staging/slicoss/TODO
 delete mode 100644 drivers/staging/sm7xxfb/Kconfig
 delete mode 100644 drivers/staging/sm7xxfb/Makefile
 delete mode 100644 drivers/staging/sm7xxfb/TODO
 delete mode 100644 drivers/staging/sm7xxfb/sm7xx.h
 delete mode 100644 drivers/staging/sm7xxfb/sm7xxfb.c
 create mode 100644 drivers/staging/unisys/Documentation/overview.txt
 create mode 100644 drivers/staging/unisys/Documentation/proc-entries.txt
 create mode 100644 drivers/staging/unisys/Kconfig
 create mode 100644 drivers/staging/unisys/MAINTAINERS
 create mode 100644 drivers/staging/unisys/Makefile
 create mode 100644 drivers/staging/unisys/TODO
 create mode 100644 drivers/staging/unisys/channels/Kconfig
 create mode 100644 drivers/staging/unisys/channels/Makefile
 create mode 100644 drivers/staging/unisys/channels/channel.c
 create mode 100644 drivers/staging/unisys/channels/chanstub.c
 create mode 100644 drivers/staging/unisys/channels/chanstub.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/channel.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/channel_guid.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/controlframework.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/diagchannel.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/iochannel.h
 create mode 100644 drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
 create mode 100644 drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h
 create mode 100644 drivers/staging/unisys/common-spar/include/diagnostics/appos_subsystems.h
 create mode 100644 drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
 create mode 100644 drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
 create mode 100644 drivers/staging/unisys/common-spar/include/version.h
 create mode 100644 drivers/staging/unisys/common-spar/include/vmcallinterface.h
 create mode 100644 drivers/staging/unisys/include/commontypes.h
 create mode 100644 drivers/staging/unisys/include/guestlinuxdebug.h
 create mode 100644 drivers/staging/unisys/include/guidutils.h
 create mode 100644 drivers/staging/unisys/include/periodic_work.h
 create mode 100644 drivers/staging/unisys/include/procobjecttree.h
 create mode 100644 drivers/staging/unisys/include/sparstop.h
 create mode 100644 drivers/staging/unisys/include/timskmod.h
 create mode 100644 drivers/staging/unisys/include/timskmodutils.h
 create mode 100644 drivers/staging/unisys/include/uisqueue.h
 create mode 100644 drivers/staging/unisys/include/uisthread.h
 create mode 100644 drivers/staging/unisys/include/uisutils.h
 create mode 100644 drivers/staging/unisys/include/uniklog.h
 create mode 100644 drivers/staging/unisys/include/vbushelper.h
 create mode 100644 drivers/staging/unisys/uislib/Kconfig
 create mode 100644 drivers/staging/unisys/uislib/Makefile
 create mode 100644 drivers/staging/unisys/uislib/uislib.c
 create mode 100644 drivers/staging/unisys/uislib/uisqueue.c
 create mode 100644 drivers/staging/unisys/uislib/uisthread.c
 create mode 100644 drivers/staging/unisys/uislib/uisutils.c
 create mode 100644 drivers/staging/unisys/virthba/Kconfig
 create mode 100644 drivers/staging/unisys/virthba/Makefile
 create mode 100644 drivers/staging/unisys/virthba/virthba.c
 create mode 100644 drivers/staging/unisys/virthba/virthba.h
 create mode 100644 drivers/staging/unisys/virtpci/Kconfig
 create mode 100644 drivers/staging/unisys/virtpci/Makefile
 create mode 100644 drivers/staging/unisys/virtpci/virtpci.c
 create mode 100644 drivers/staging/unisys/virtpci/virtpci.h
 create mode 100644 drivers/staging/unisys/visorchannel/Kconfig
 create mode 100644 drivers/staging/unisys/visorchannel/Makefile
 create mode 100644 drivers/staging/unisys/visorchannel/globals.h
 create mode 100644 drivers/staging/unisys/visorchannel/visorchannel.h
 create mode 100644 drivers/staging/unisys/visorchannel/visorchannel_funcs.c
 create mode 100644 drivers/staging/unisys/visorchannel/visorchannel_main.c
 create mode 100644 drivers/staging/unisys/visorchipset/Kconfig
 create mode 100644 drivers/staging/unisys/visorchipset/Makefile
 create mode 100644 drivers/staging/unisys/visorchipset/controlvm.h
 create mode 100644 drivers/staging/unisys/visorchipset/controlvm_direct.c
 create mode 100644 drivers/staging/unisys/visorchipset/file.c
 create mode 100644 drivers/staging/unisys/visorchipset/file.h
 create mode 100644 drivers/staging/unisys/visorchipset/filexfer.c
 create mode 100644 drivers/staging/unisys/visorchipset/filexfer.h
 create mode 100644 drivers/staging/unisys/visorchipset/globals.h
 create mode 100644 drivers/staging/unisys/visorchipset/parser.c
 create mode 100644 drivers/staging/unisys/visorchipset/parser.h
 create mode 100644 drivers/staging/unisys/visorchipset/testing.h
 create mode 100644 drivers/staging/unisys/visorchipset/visorchipset.h
 create mode 100644 drivers/staging/unisys/visorchipset/visorchipset_main.c
 create mode 100644 drivers/staging/unisys/visorchipset/visorchipset_umode.h
 create mode 100644 drivers/staging/unisys/visorutil/Kconfig
 create mode 100644 drivers/staging/unisys/visorutil/Makefile
 create mode 100644 drivers/staging/unisys/visorutil/charqueue.c
 create mode 100644 drivers/staging/unisys/visorutil/charqueue.h
 create mode 100644 drivers/staging/unisys/visorutil/easyproc.c
 create mode 100644 drivers/staging/unisys/visorutil/easyproc.h
 create mode 100644 drivers/staging/unisys/visorutil/memregion.h
 create mode 100644 drivers/staging/unisys/visorutil/memregion_direct.c
 create mode 100644 drivers/staging/unisys/visorutil/periodic_work.c
 create mode 100644 drivers/staging/unisys/visorutil/procobjecttree.c
 create mode 100644 drivers/staging/unisys/visorutil/visorkmodutils.c
 create mode 100644 drivers/staging/usbip/uapi/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/list.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/sysfs_utils.h
 create mode 100644 include/linux/of_graph.h
 create mode 100644 include/linux/platform_data/bt-nokia-h4p.h
