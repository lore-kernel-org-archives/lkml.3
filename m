Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3CQXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:16:57 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36962 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3CQXQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:16:53 -0400
MIME-Version: 1.0
Date: Sun, 17 Mar 2013 16:16:52 -0700
X-Google-Sender-Auth: -LMjpGOj4O_fSkAWLFdpzATJZeA
Message-ID: <CA+55aFwHhJ_M7Oow7yffy4ph7z5c2u8BycM6tzG00mAuEUWccQ@mail.gmail.com>
Subject: Linux 3.9-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not as small as -rc2, but that one really was unusually calm. So there
was clearly some pending stuff that came in for -rc3, with network
drivers and USB leading the charge. But there's other misc drivers,
arch updates, btrfs fixes, etc etc too.

        Linus

---
Aaro Koskinen (3):
      usb: musb: omap2430: fix omap_musb_mailbox glue check again
      usb: musb: omap2430: fix sparse warning
      ARM: OMAP: RX-51: add missing USB phy binding

Al Viro (1):
      vfs: fix pipe counter breakage

Alan Stern (2):
      USB: EHCI: work around silicon bug in Intel's EHCI controllers
      USB: EHCI: don't check DMA values in QH overlays

Alexander Duyck (1):
      igb: Drop BUILD_BUG_ON check from igb_build_rx_buffer

Amir Vadai (1):
      net/mlx4_en: Disable RFS when running in SRIOV mode

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Anatolij Gustschin (1):
      tty: serial: mpc5xxx: fix PSC clock name bug

Andrew Lunn (2):
      gpio: mvebu: Add clk support to prevent lockup
      rtc: rtc-mv: Add support for clk to avoid lockups

Andrew Morton (4):
      usb: dwc3: ep0: fix sparc64 build
      include/linux/res_counter.h needs errno.h
      kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
      mm/fremap.c: fix oops on error path

Arnd Bergmann (4):
      usb: gadget: fix omap_udc build errors
      mfd: ab8500: Kill "reg" property from binding
      ARM: spear3xx: Use correct pl080 header file
      mfd: twl4030-madc: Remove __exit_p annotation

Axel Lin (3):
      mfd: Make AB8500_CORE select POWER_SUPPLY to fix build error
      mfd: ab8500-gpadc: Complain if we fail to enable vtvout LDO
      hwmon: (lineage-pem) Add missing terminating entry for
pem_[input|fan]_attributes

Ben Greear (2):
      mac80211: stop timers before canceling work items
      mac80211: Fix crash due to un-canceled work-items

Ben Hutchings (2):
      sfc: Disable soft interrupt handling during efx_device_detach_sync()
      sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0

Ben Skeggs (1):
      drm/nv50: encoder creation failure doesn't mean full init failure

Bhavesh Davda (1):
      vmxnet3: prevent div-by-zero panic when ring resizing uninitialized dev

Bill Pemberton (1):
      USB: quatech2: only write to the tty if the port is open.

Bjørn Mork (3):
      USB: option: add Huawei E5331
      USB: storage: in-kernel modeswitching is deprecated
      USB: storage: fix Huawei mode switching regression

Bruce Allan (1):
      e1000e: workaround DMA unit hang on I218

Carolyn Wyborny (2):
      igb: Fix link setup for I210 devices
      igb: Fix for lockdep issue in igb_get_i2c_client

Chen Gang (2):
      net/rds: zero last byte for strncpy
      drivers/isdn: checkng length to be sure not memory overflow

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Christoph Paasch (1):
      Fix: sparse warning in inet_csk_prepare_forced_close

Clemens Ladisch (1):
      ALSA: usb-audio: add a workaround for the NuForce UDH-100

Cong Wang (1):
      bridge: add missing vid to br_mdb_get()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Dan Carpenter (3):
      usb: gadget: f_uac1: silence an info leak warning
      usb: gadget: u_uac1: NULL dereference on error path
      sound: sequencer: cap array index in seq_chn_common_event()

Dan Williams (2):
      qcaux: add Franklin U600
      qcserial: bind to DM/DIAG port on Gobi 1K devices

Dave Tubbs (2):
      usb: Correction to c67x00 TD data length mask
      usb: c67x00 RetryCnt value in c67x00 TD should be 3

Dave Turvene (1):
      Input: ALPS - add "Dolphin V1" touchpad support

David Henningsson (1):
      ALSA: hda - Disable IDT eapd_switch if there are no internal speakers

David Howells (5):
      keys: fix race with concurrent install_user_keyrings()
      UAPI: fix endianness conditionals in linux/aio_abi.h
      UAPI: fix endianness conditionals in linux/acct.h
      UAPI: fix endianness conditionals in linux/raid/md_p.h
      UAPI: fix endianness conditionals in M32R's asm/stat.h

David Oostdyk (1):
      rrunner.c: fix possible memory leak in rr_init_one()

David Rientjes (1):
      perf,x86: fix link failure for non-Intel configs

David Ward (1):
      net/ipv4: Timestamp option cannot overflow with prespecified addresses

David Woodhouse (1):
      hwmon: (pmbus) Fix krealloc() misuse in pmbus_add_attribute()

Denis CIOCCA (1):
      iio:common:st_sensors fixed all warning messages about
uninitialized variables

Dor Shaish (3):
      iwlwifi: mvm: Set valid TX antennas value before calib request
      iwlwifi: mvm: Take the phy_cfg from the TLV value
      iwlwifi: mvm: Remove overriding calibrations for the 7000 family

Dylan Reid (3):
      ALSA: hda/ca0132 - Check if dspload_image succeeded.
      ALSA: hda/ca0132 - Check download state of DSP.
      ALSA: hda/ca0132 - Remove extra setting of dsp_state.

Emmanuel Grumbach (5):
      iwlwifi: disable 8K A-MSDU by default
      iwlwifi: mvm: restart the NIC of the cmd queue gets full
      iwlwifi: mvm: ignore STOP_AGG when restarting
      iwlwifi: mvm: update the rssi calculation
      iwlwifi: mvm: don't warn on normal BAR sending

Eric Dumazet (2):
      net: reduce net_rx_action() latency to 2 HZ
      tun: add a missing nf_reset() in tun_net_xmit()

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Eric W. Biederman (3):
      fs: Limit sys_mount to only request filesystem modules. (Part 3)
      fs: Readd the fs module aliases.
      userns: Don't allow CLONE_NEWUSER | CLONE_FS

Fabio Estevam (4):
      ARM: mxs_defconfig: Make USB host functional again
      ARM: mxs: mm: Fix sparse warning
      ARM: mxs: icoll: Fix sparse warning
      ARM: mxs: ocotp: Fix sparse warning

Felipe Balbi (16):
      usb: dwc3: core: don't forget to free coherent memory
      usb: dwc3: omap: fix a typo on of_device_id
      usb: dwc3: glue layers shouldn't know about the core IP
      usb: dwc3: gadget: remove unnecessary code
      usb: chipidea: register debugging sysfs on our device
      usb: gadget: pxa27x: fix gadget->dev registration
      usb: gadget: s3c2410: fix gadget->dev registration
      usb: gadget: pxa25x: fix gadget->dev registration
      usb: gadget: imx_udc: fix gadget->dev registration
      usb: gadget: s3c2410: fix build breakage
      ARM: OMAP2+: mux: fix debugfs file permission
      usb: musb: remove all 'select' from Kconfig
      usb: musb: fix compile warning
      usb: Makefile: fix drivers/usb/phy/ Makefile entry
      usb: gadget: pxa25x: fix disconnect reporting
      usb: musb: core: fix possible build error with randconfig

Felix Fietkau (1):
      mac80211: another fix for idle handling in monitor mode

Florian Fainelli (1):
      arm: mvebu: enable the USB ports on Armada 370 Reference Design board

Gao feng (1):
      netfilter: xt_AUDIT: only generate audit log when audit enabled

Gavin Shan (1):
      benet: Wait f/w POST until timeout

Geert Uytterhoeven (1):
      staging/vt6656: Fix too large integer constant warning on 32-bit

Greg Ungerer (1):
      m68knommu: fix misnamed GPIO pin definition for ColdFire 528x CPU

Guenter Roeck (4):
      iio/imu: inv_mpu6050 depends on IIO_BUFFER
      iio: Fix build error seen if IIO_TRIGGER is defined but IIO_BUFFER is not
      MAINTAINERS: Add maintainer for MAX6697, INA209, and INA2XX drivers
      hwmon: (pmbus/ltc2978) Fix temperature reporting

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses

Heikki Krogerus (1):
      arm: mvebu: Reduce reg-io-width with UARTs

Hiraku Toyooka (1):
      tracing: update documentation of snapshot utility

Ian Abbott (1):
      staging: comedi: dt9812: use CR_CHAN() for channel number

Ian Campbell (1):
      xen: arm: mandate EABI and use generic atomic operations.

Ionut-Gabriel Radu (1):
      reiserfs: Use kstrdup instead of kmalloc/strcpy

J. Bruce Fields (2):
      nfsd: fix krb5 handling of anonymous principals
      sunrpc: don't attempt to cancel unitialized work

Jack Morgenstein (3):
      net/mlx4_core: Disable mlx4_QP_ATTACH calls from guests if the
host uses flow steering
      net/mlx4_core: Turn off device-managed FS bit in dev-cap wrapper
if DMFS is not enabled
      net/mlx4_core: Fix endianness bug in set_param_l

Jan Kara (1):
      ext2: Fix BUG_ON in evict() on inode deletion

Jason Cooper (1):
      ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Jason Wang (1):
      net: docs: document multiqueue tuntap API

Javi Merino (1):
      irqchip: fix typo when moving gic_raise_softirq()

Jean-Francois Moine (1):
      ARM: Dove: add RTC device node

Jeff Mahoney (1):
      quota: add missing use of dq_data_lock in __dquot_initialize

Jiri Slaby (1):
      TTY: disable debugging warning

Joe Perches (1):
      netfilter: nf_ct_helper: Fix logging for dropped packets

Johan Hovold (3):
      ARM: w1-gpio: fix erroneous gpio requests
      w1-gpio: remove erroneous __exit and __exit_p()
      w1-gpio: fix unused variable warning

Johannes Berg (7):
      nl80211: remove channel width and extended capa advertising
      mac80211: really fix monitor mode channel reporting
      iwlwifi: don't map complete commands bidirectionally
      iwlwifi: rename IWL_MAX_CMD_TFDS to IWL_MAX_CMD_TBS_PER_TFD
      iwlwifi: use coherent DMA memory for command header
      nl80211: increase wiphy dump size dynamically
      mac80211: fix VHT MCS calculation

Jon Hunter (1):
      ARM: OMAP2+: Fix broken gpmc support

Jonas Bonn (3):
      openrisc: require gpiolib
      asm-generic: move cmpxchg*_local defs to cmpxchg.h
      openrisc: remove HAVE_VIRT_TO_BUS

Jonas Gorski (1):
      serial: bcm63xx_uart: fix compilation after "TTY: switch
tty_insert_flip_char"

Josef Bacik (1):
      Btrfs: return EIO if we have extent tree corruption

Josh Boyer (1):
      serial: 8250: Keep 8250.<xxxx> module options functional after
driver rename

Junwei Zhang (1):
      afkey: fix a typo

Kamal Mostafa (1):
      Input: cypress_ps2 - fix trackpadi found in Dell XPS12

Kees Cook (2):
      final removal of CONFIG_EXPERIMENTAL
      signal: always clear sa_restorer on execve

Kevin Cernekee (1):
      Input: ALPS - remove unused argument to alps_enter_command_mode()

Kishon Vijay Abraham I (1):
      usb: gadget: make usb functions to load before gadget driver

Konrad Rzeszutek Wilk (2):
      xen/pciback: Don't disable a PCI device that is already disabled.
      acpi: Export the acpi_processor_get_performance_info

Konstantin Khlebnikov (3):
      e1000e: fix pci-device enable-counter balance
      e1000e: fix runtime power management transitions
      e1000e: fix accessing to suspended device

Kumar Amit Mehta (3):
      staging: comedi: drivers: usbdux.c: fix DMA buffers on stack
      staging: comedi: drivers: usbduxfast.c: fix for DMA buffers on stack
      staging: comedi: drivers: usbduxsigma.c: fix DMA buffers on stack

Lars-Peter Clausen (4):
      iio:ad5064: Fix address of the second channel for ad5065/ad5045/ad5025
      iio:ad5064: Fix off by one in DAC value range check
      iio:ad5064: Initialize register cache correctly
      ext3: Fix format string issues

Laxman Dewangan (1):
      mfd: palmas: Provide irq flags through DT/platform data

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Li Zefan (1):
      s390: Fix a header dependencies related build error

Linus Torvalds (2):
      perf,x86: fix wrmsr_on_cpu() warning on suspend/resume
      Linux 3.9-rc3

Liu Bo (4):
      Btrfs: get better concurrency for snapshot-aware defrag work
      Btrfs: remove btrfs_try_spin_lock
      Btrfs: fix warning when creating snapshots
      Btrfs: fix warning of free_extent_map

Liu Jinsong (1):
      xen/acpi: remove redundant acpi/acpi_drivers.h include

Luis Alves (2):
      m68knommu: add CPU_NAME for 68000
      m68knommu: fix MC68328.h defines

Maarten Lankhorst (1):
      drm/nouveau: fix regression in vblanking

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Marc Kleine-Budde (1):
      usb: otg: use try_module_get in all usb_get_phy functions and
add missing module_put

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Marcin Slusarz (2):
      drm/nouveau: idle channel before releasing notify object
      drm/nv50: use correct tiling methods for m2mf buffer moves

Marco Porsch (1):
      mac80211: fix oops on mesh PS broadcast forwarding

Marco Stornelli (1):
      hostfs: fix a not needed double check

Marek Szyprowski (1):
      ARM: DMA-mapping: add missing GFP_DMA flag for atomic buffer allocation

Mark Brown (5):
      Input: ads7864 - check return value of regulator enable
      Input: mms114 - Fix regulator enable and disable paths
      mfd: tps65912: Declare and use tps65912_irq_exit()
      mfd: twl4030-audio: Fix argument type for twl4030_audio_disable_resource()
      mfd: wm831x: Don't forward declare enum wm831x_auxadc

Mathias Krause (3):
      bridge: fix mdb info leaks
      rtnl: fix info leak on RTM_GETLINK request for VF devices
      dcbnl: fix various netlink info leaks

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv,
writev, and security keys

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Maxime Ripard (2):
      ARM: mxs: cfa10049: Fix fb initialisation function
      ARM: multiplatform: Sort the max gpio numbers.

Maxin B. John (1):
      tools: usb: ffs-test: Fix build failure

Michel Lespinasse (1):
      mm/fremap.c: fix possible oops on error path

Nicolas Pitre (1):
      ARM: mach-imx: move early resume code out of the .data section

Nishanth Menon (2):
      ARM: dts: remove generated .dtb files on clean
      usb: gadget: composite: fix kernel-doc warnings

Nithin Sujir (1):
      tg3: Update link_up flag for phylib devices

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Padmavathi Venna (1):
      Arm: socfpga: pl330: Add #dma-cells for generic dma binding support

Paolo Valente (6):
      pkt_sched: sch_qfq: properly cap timestamps in charge_actual_service
      pkt_sched: sch_qfq: fix the update of eligible-group sets
      pkt_sched: sch_qfq: serve activated aggregates immediately if
the scheduler is empty
      pkt_sched: sch_qfq: prevent budget from wrapping around after a dequeue
      pkt_sched: sch_qfq: do not allow virtual time to jump if an
aggregate is in service
      pkt_sched: sch_qfq: remove a useless invocation of qfq_update_eligible

Paul Bolle (8):
      netfilter: nfnetlink: silence warning if CONFIG_PROVE_RCU isn't set
      ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"
      m68k: drop "select EMAC_INC"
      ARM: dove: drop "select COMMON_CLK_DOVE"
      ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"
      tty: serial: fix typo "ARCH_S5P6450"
      tty: serial: fix typo "SERIAL_S3C2412"
      decompressors: fix typo "POWERPC"

Paul Chavent (1):
      net : enable tx time stamping in the vde driver.

Paul E. McKenney (1):
      list: Fix double fetch of pointer in hlist_entry_safe()

Paul Moore (2):
      netlabel: correctly list all the static label mappings
      netlabel: fix build problems when CONFIG_IPV6=n

Peter Hurley (4):
      net/irda: Fix port open counts
      net/irda: Hold port lock while bumping blocked_open
      net/irda: Use barrier to set task state
      net/irda: Raise dtr in non-blocking open

Peter Ujfalusi (1):
      usb: musb: correct Kconfig in order to avoid non compilable selection

Phil Sutter (1):
      mv643xx_eth: fix for disabled autoneg

Philipp Zabel (1):
      staging: imx/drm: request irq only after adding the crtc

Prashant Gaikwad (2):
      ARM: Tegra: Add clock entry for smp_twd clock
      clk: Tegra: Remove duplicate smp_twd clock

Rabin Vincent (1):
      Input: tc3589x-keypad - fix keymap size

Rajendra Nayak (1):
      ARM: OMAP3: board-generic: Add missing omap3_init_late

Randy Dunlap (4):
      net: fix new kernel-doc warnings in net core
      idr: fix new kernel-doc warnings
      signals: fix new kernel-doc warnings
      futex: fix kernel-doc notation and spello

Richard Weinberger (2):
      um: Use tty_port_operations->destruct
      um: Use tty_port in SIGWINCH handler

Roger Quadros (1):
      mfd: omap-usb-host: Actually update hostconfig

Ruslan Bilovol (1):
      ARM: OMAP2+: mux: correct wrong error messages

Sachin Kamat (3):
      usb: phy: samsung: Convert to devm_ioremap_resource()
      usb: phy: omap-usb3: Convert to devm_ioremap_resource()
      usb: phy: omap-control-usb: Convert to devm_ioremap_resource()

Sage Weil (1):
      libceph: fix decoding of pgids

Sam Ravnborg (1):
      kbuild: fix make headers_check with make 3.80

Santosh Shilimkar (1):
      ARM: OMAP2+: Remove duplicate omap4430_init_late() declaration

Sathya Perla (1):
      be2net: use CSR-BAR SEMAPHORE reg for BE2/BE3

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Sean Young (1):
      tty/8250_pnp: serial port detection regression since v3.7

Sebastian Hesselbarth (1):
      ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels

Sergei Trofimovich (2):
      um: add missing declaration of 'getrlimit()' and friends
      um: fix build failure due to mess-up of sig_info protorype

Shawn Guo (2):
      ARM: dts: imx53-mba53: fix fsl,pins for disp1-grp1
      ARM: imx: pll1_sys should be an initial on clk

Sony Chacko (1):
      MAINTAINERS: Update qlcnic maintainers list

Stephan Frank (1):
      Input: wacom - add support for 0x10d

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Stephen Rothwell (1):
      Select VIRT_TO_BUS directly where needed

Stephen Warren (1):
      ARM: bcm2835: fix I2C module clock rate

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Steven Rostedt (Red Hat) (2):
      tracing: Add help of snapshot feature when snapshot is empty
      tracing: Do not return EINVAL in snapshot when not allocated

Takashi Iwai (3):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()
      ALSA: hda - Fix snd_hda_get_num_raw_conns() to return a correct value
      ALSA: hda - Fix missing EAPD/GPIO setup for Cirrus codecs

Tejun Heo (8):
      nfsd: remove unused get_new_stid()
      nfsd: convert to idr_alloc()
      workqueue: convert to idr_alloc()
      mlx4: remove leftover idr_pre_get() call
      zcache: convert to idr_alloc()
      tidspbridge: convert to idr_alloc()
      idr: deprecate idr_pre_get() and idr_get_new[_above]()
      idr: idr_alloc() shouldn't trigger lowmem warning when preloaded

Thadeu Lima de Souza Cascardo (1):
      m68knommu: fix build when CPU is not coldfire

Thomas Petazzoni (3):
      arm: plat-orion: fix address decoding when > 4GB is used
      arm: mvebu: fix address-cells in mpic DT node
      arm: mach-orion5x: fix typo in compatible string of a .dts file

Tony Lindgren (2):
      ARM: OMAP1: Fix build related to kgdb.h no longer including serial_8250.h
      ARM: OMAP2+: Fix unmet direct dependencies for zoom for 8250 serial

Tony Prisk (1):
      tty: serial: vt8500: Unneccessary duplicated clock code removed

Toshi Kani (1):
      mm: remove_memory(): fix end_pfn setting

Veaceslav Falico (1):
      bonding: fire NETDEV_RELEASE event only on 0 slaves

Vlad Yasevich (2):
      team: unsyc the devices addresses when port is removed
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.

Wang Shilong (1):
      Btrfs: return as soon as possible when edquot happens

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos
Technology PCI 9835 Multi-I/O Controller

Wei Yongjun (1):
      ALSA: asihpi - fix potential NULL pointer dereference

YOSHIFUJI Hideaki / 吉藤英明 (1):
      6lowpan: Fix endianness issue in is_addr_link_local().

Yan Burman (2):
      net/mlx4_en: Fix race when setting the device MAC address
      net/mlx4_en: Cleanup MAC resources on module unload or port stop

Yaniv Rosner (2):
      bnx2x: Fix intermittent long KR2 link up time
      bnx2x: Fix SFP+ misconfiguration in iSCSI boot scenario

Zang MingJie (2):
      reset nf before xmit vxlan encapsulated packet
      vxlan: fix oops when delete netns containing vxlan

dave turvene (1):
      Input: ALPS - update documentation for recent touchpad driver mods
