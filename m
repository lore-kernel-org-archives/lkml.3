Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBPWA4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 17:00:56 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:44847 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaBPWAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 17:00:52 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyvQ4ko4J2oLbyVEZjb9=TvjcCF_PV-jGDZTR8_D+zseQ@mail.gmail.com>
References: <CA+55aFyvQ4ko4J2oLbyVEZjb9=TvjcCF_PV-jGDZTR8_D+zseQ@mail.gmail.com>
Date: Sun, 16 Feb 2014 14:00:51 -0800
X-Google-Sender-Auth: fu23LGJbsPrFv7CGuICeJ8PSm98
Message-ID: <CA+55aFyL8UhBT8O2B-mE9PKALG+tzBchCB-eGVf2G+R_AJRTzg@mail.gmail.com>
Subject: Re: Linux 3.14-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here's the promised shortlog.

Of course, I hope people are using git, and these are all totally
redundant, but maybe some people are more interested in hearing about
the statistics than actually getting the updates.

You really should compile and test it, though. By -rc3, the scary
stuff should have all been fixed. Not that there really was that much
scary stuff this time around, I think.

                   Linus

---

Adam Thomson (1):
      regulator: da9055: Remove use of regmap_irq_get_virq()

Alan Cox (1):
      xlr_net: Fix missing trivial allocation check

Alan Stern (3):
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: enable multi-LUN scanning when needed

Alex Deucher (5):
      drm/radeon: fix UVD IRQ support on 7xx
      drm/radeon/dpm: use the driver state for dpm debugfs
      drm/radeon/dpm: use stored max_vddc rather than looking it up
      drm/radeon: remove useless return
      drm/radeon: add missing include in btc_dpm.c

Alexander Shiyan (1):
      net: irda: ep7211-sir: Remove driver

Alexander Usyskin (2):
      mei: clear write cb from waiting list on reset
      mei: don't unset read cb ptr on reset

Alexandre Belloni (2):
      iio: mxs-lradc: fix buffer overflow
      iio: mxs-lradc: remove useless scale_available files

Alexey Dobriyan (1):
      netfilter: nf_nat_h323: fix crash in nf_ct_unlink_expect_report()

Alexey Khoroshilov (2):
      staging: gdm72xx: fix leaks at failure path in gdm_usb_probe()
      drivers/message/i2o/i2o_config.c: fix deadlock in compat_ioctl(I2OGETIOPS)

Alistair Strachan (1):
      staging: sync: Fix a race condition between release_obj and print_obj

Anand Jain (1):
      btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105

Andre Heider (1):
      usb: dwc2: bail out early when booting with "nousb"

Andrew Lunn (3):
      drivers: phy: Make NULL a valid phy reference
      drivers: phy: Add support for optional phys
      ata: sata_mv: Fix probe failures with optional phys

Andrey Vagin (1):
      netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get

Andy Zhou (2):
      openvswitch: Fix kernel panic on ovs_flow_free
      openvswitch: Suppress error messages on megaflow updates

Anshuman Khandual (1):
      powerpc/perf: Configure BHRB filter before enabling PMU interrupts

Anton Blanchard (1):
      powerpc: Fix endian issues in kexec and crash dump code

Arnd Bergmann (1):
      can: flexcan: fix flexcan driver build for big endian on ARM and
little endian on PowerPc

Arturo Borrero (1):
      netfilter: nft_ct: fix unconditional dump of 'dir' attr

Axel Lin (3):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if
hw->pdata->lsb is true
      gpio: clps711x: Add module alias to support module auto loading
      gpio: tb10x: GPIO_TB10X needs to select GENERIC_IRQ_CHIP

Baruch Siach (4):
      spi: spi.h: clarify the documentation of transfer_one
      spi: document the transfer_one spi_master callback
      spi: correct the transfer_one_message documentation wording
      gpio: xtensa: fix build when XCHAL_HAVE_CP is 0

Benjamin Herrenschmidt (1):
      powerpc/powernv: Add iommu DMA bypass support for IODA2

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit

Bjørn Mork (3):
      usb: ftdi_sio: add Mindstorms EV3 console adapter
      net: qmi_wwan: add Netgear Aircard 340U
      usb: qcserial: add Netgear Aircard 340U

Bo Shen (1):
      ARM: at91: enable USB host on at91sam9n12ek board

Boris BREZILLON (3):
      ARM: at91/dt: fix sama5d3 ohci hclk clock reference
      mmc: atmel-mci: document clock properties
      spi/atmel: document clock properties

Borislav Petkov (4):
      gitignore: add all.config
      x86/efi: Fix 32-bit fallout
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

Chen Gang (1):
      drivers: staging: android: ion: ion_dummy_driver: include "linux/io.h"

Chris Mason (1):
      Revert "btrfs: add ioctl to export size of global metadata reservation"

Christian Engelmayer (6):
      usb: core: Fix potential memory leak adding dyn USBdevice IDs
      misc: genwqe: Fix potential memory leak when pinning memory
      6lowpan: Remove unused pointer in lowpan_header_create()
      wan: dlci: Remove unused netdev_priv pointer
      3c59x: Remove unused pointer in vortex_eisa_cleanup()
      net: vxge: Remove unused device pointer

Christian König (1):
      drm/radeon: fix UVD IRQ support on SI

Christoffer Dall (1):
      arm64: KVM: Add VGIC device control for arm64

Christoph Hellwig (10):
      blk-mq: support at_head inserations for blk_execute_rq
      blk-mq: divert __blk_put_request for MQ ops
      blk-mq: handle dma_drain_size
      blk-mq: initialize sg_reserved_size
      blk-mq: rework I/O completions
      virtio_blk: use blk_mq_complete_request
      null_blk: use blk_complete_request and blk_mq_complete_request
      blk-mq: rework flush sequencing logic
      blk-mq: dont assume rq->errors is set when returning an error
from ->queue_rq
      blk-mq: pair blk_mq_start_request / blk_mq_requeue_request

Colin Cross (1):
      staging: ion: Fix overflow and list bugs in system heap

Cong Wang (1):
      bridge: fix netconsole setup over bridge

Craig Markwardt (1):
      iio: Fix a buffer overflow in iio_utils.h example code

Cédric Dufour - Idiap Research Institute (1):
      staging: lustre: fix quotactl permission denied (LU-4530)

Dan Carpenter (11):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()
      tg3: cleanup an error path in tg3_phy_reset_5703_4_5()
      isdn/hisax: hex vs decimal typo in prfeatureind()
      hso: remove some dead code
      staging: r8188eu: memory corruption handling long ssids
      staging: android: ion: dummy: fix an error code
      gpu: ion: dereferencing an ERR_PTR
      staging: r8188eu: array overflow in rtw_mp_ioctl_hdl()
      staging: r8188eu: overflow in rtw_p2p_get_go_device_address()
      drivers/misc/sgi-gru/grukdump.c: unlocking should be conditional
in gru_dump_context()
      IB/iser: Fix use after free in iser_snd_completion()

Daniel Baluta (1):
      vxlan: remove extra newline after function definition

Daniel Vetter (3):
      MAINTAINERS: Update drm/i915 git repo
      drm/i915: Disable dp aux irq on g4x
      drm/i915: Fix intel_pipe_to_cpu_transcoder for UMS

Daniele Di Proietto (1):
      openvswitch: Fix ovs_dp_cmd_msg_size()

Darrick J. Wong (1):
      bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED

Dave Jones (1):
      drm/radeon/dpm: fix uninitialized read from stack in kv_dpm_late_enable

David Daney (1):
      staging: octeon-usb: Probe via device tree populated platform device.

David Henningsson (1):
      ALSA: hda - Add a headset quirk for Dell XPS 13

David Rientjes (1):
      mm/slub.c: list_lock may not be held in some circumstances

David Spinadel (1):
      iwlwifi: mvm: notify match found without filtering

David Vrabel (4):
      xen-netfront: handle backend CLOSED without CLOSING
      xen-blkfront: handle backend CLOSED without CLOSING
      xen/events: bind all new interdomain events to VCPU0
      xen: install xen/gntdev.h and xen/gntalloc.h

Denis Carikli (1):
      video: Kconfig: Allow more broad selection of the imxfb
framebuffer driver.

Devesh Sharma (2):
      RDMA/ocrdma: Fix traffic class shift
      RDMA/ocrdma: Fix load time panic during GID table init

Dirk Brandewie (1):
      intel_pstate: Remove energy reporting from pstate_sample tracepoint

Dmitry Eremin-Solenikov (1):
      serial: 8250_pci: unbreak last serial ports on NetMos 9865 cards

Dmitry Kravkov (1):
      bnx2x: fix L2-GRE TCP issues

Doug Anderson (1):
      hwmon: (ntc_thermistor) Avoid math overflow

Edgar E. Iglesias (1):
      microblaze: Fix a typo when disabling stack protection

Eli Cohen (4):
      IB/mlx5: Fix RC transport send queue overhead computation
      IB/mlx5: Fix binary compatibility with libmlx5
      IB/mlx5: Don't set "block multicast loopback" capability
      IB/mlx5: Remove dependency on X86

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emilio López (1):
      of: add vendor prefix for Allwinner Technology

Emmanuel Grumbach (6):
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: don't leak a station when we drain
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan
      iwlwifi: mvm: don't allow A band if SKU forbids it
      mac80211: avoid deadlock revealed by lockdep
      mac80211: release the channel in error path in start_ap

Eric Dumazet (4):
      ip_tunnel: fix panic in ip_tunnel_xmit()
      net: use __GFP_NORETRY for high order allocations
      tcp: remove 1ms offset in srtt computation
      6lowpan: fix lockdep splats

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

FX Le Bail (1):
      ipv6: icmp6_send: fix Oops when pinging a not set up IPv6 peer
on a sit tunnel

Fernando Luis Vazquez Cao (1):
      rtnetlink: fix oops in rtnl_link_get_slave_info_data_size

Filipe David Borba Manana (1):
      Btrfs: use right clone root offset for compressed extents

Florian Fainelli (1):
      net: phy: ensure Gigabit features are masked off if requested

Fu Wei (3):
      Documentation:Chinese translation of
Documentation/arm64/tagged-pointers.txt
      Documentation:Update Documentation/zh_CN/arm64/booting.txt
      Documentation:Update Documentation/zh_CN/arm64/memory.txt

Geert Uytterhoeven (6):
      spi: Fix crash with double message finalisation on error handling
      spi: rspi: Document support for Renesas QSPI in Kconfig
      of/device: Nullify match table in of_match_device() for CONFIG_OF=n
      DT: Add vendor prefix for Spansion Inc.
      ipv4: Fix runtime WARNING in rtmsg_ifa()
      drivers/md/bcache/extents.c: use %zi to format size_t

Gerald Schaefer (1):
      s390/appldata: restore missing init_virt_timer()

Greg Hackmann (1):
      staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC

Greg Kroah-Hartman (3):
      Revert "Staging: dgrp: Refactor the function dgrp_receive() in
drrp_net_ops.c"
      Revert "ARM: sunxi: dt: Convert to the new SID compatibles"
      Revert "misc: eeprom: sunxi: Add new compatibles"

Greg Pearson (1):
      vmcore: prevent PT_NOTE p_memsz overflow during header update

Guenter Roeck (1):
      iio: max1363: Use devm_regulator_get_optional for optional regulator

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hartmut Knaack (2):
      staging:iio:ad799x fix error_free_irq which was freeing an irq
that may not have been requested
      staging:iio:ad799x fix typo in ad799x_events[]

Heiko Stuebner (1):
      dt-bindings: add vendor-prefix for neonode

Heinrich Schuchardt (1):
      usbip/userspace/libsrc/names.c: memory leak

Henrik Austad (1):
      Documentation/: update 00-INDEX files

Ian Abbott (2):
      staging: comedi: fix too early cleanup in comedi_auto_config()
      staging: comedi: usbduxsigma: fix unaligned dereferences

Imre Deak (1):
      drm/i915: vlv: fix DP PHY lockup due to invalid PP sequencer setup

Ira W. Snyder (1):
      can: janz-ican3: fix uninitialized variable warnings

Ivaylo Dimitrov (1):
      iio: tsl2563: Use the correct channel2 member

J. Bruce Fields (1):
      nfsd4: fix acl buffer overrun

James M Leddy (1):
      bnx2[x]: Make module parameters readable

Jan Moskyto Matejka (2):
      inet: defines IPPROTO_* needed for module alias generation
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jani Nikula (2):
      drm: add DRM_INFO_ONCE() to print a one-time DRM_INFO() message
      drm/i915: demote opregion excessive timeout WARN_ONCE to DRM_INFO_ONCE

Jean-Francois Moine (6):
      drm/i2c: tda998x: fix bad value in the AIF
      drm/i2c: tda998x: check the CEC device creation
      drm/i2c: tda998x: free the CEC device on encoder_destroy
      drm/i2c: tda998x: force the page register at startup time
      drm/i2c: tda998x: set the PLL division factor in range 0..3
      drm/i2c: tda998x: fix the ENABLE_SPACE register

Jean-Jacques Hiblot (1):
      ARM: at91/dt: sam9263: fix compatibility string for the I2C

Jeff Layton (1):
      cifs: use a flexarray in cifs_writedata

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard loop

Jesper Juhl (1):
      tcp: correct code comment stating 3 min timeout for FIN_WAIT2,
we only do 1 min

Jingoo Han (1):
      IB/srpt: replace strict_strtoul() with kstrtoul()

Joe Schultz (1):
      serial: 8250: Support XR17V35x fraction divisor

Johannes Berg (7):
      iwlwifi: mvm: make local pointer non-static
      iwlwifi: mvm: disable scheduled scan
      cfg80211: re-enable 5/10 MHz support
      cfg80211: fix scan done race
      cfg80211: send scan results from work queue
      mac80211: fix fragmentation code, particularly for encryption
      mac80211: fix virtual monitor interface iteration

John Greene (1):
      alx: add missing stats_lock spinlock init

John Ogness (1):
      tcp: tsq: fix nonagle handling

John Stultz (1):
      staging: ion: Fix build warning

Jonathan Cameron (1):
      staging:iio:ad799x fix incorrect endianness specification for
buffer elements

Jose Alonso (1):
      s390/qdio: for_each macro correctness

Josef Bacik (1):
      Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol

Josh Boyer (1):
      usb: phy: move some error messages to debug

Julia Lawall (3):
      staging:iio:impedance:ad5933: correct error check
      RDMA/nes: Fix error return code
      RDMA/amso1100: Fix error return code

Junxiao Bi (1):
      ocfs2: update inode size after zeroing the hole

K. Y. Srinivasan (2):
      Drivers: hv: vmbus: Specify the target CPU that should receive
notification
      Drivers: hv: vmbus: Don't timeout during the initial connection with host

Kent Overstreet (3):
      bcache: Minor fixes from kbuild robot
      block: Explicitly handle discard/write same segments
      block: Fix cloning of discard/write same bios

Kevin Hao (3):
      powerpc/ppc32: Fix the bug in the init of non-base exception stack for UP
      Revert "OF: base: match each node compatible against all given
matches first"
      of: search the best compatible match first in __of_match_node()

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Kristóf Ralovich (1):
      USB: simple: add Dynastream ANT USB-m Stick device support

Krzysztof Kozlowski (2):
      power: max17040: Fix NULL pointer dereference when there is no
platform_data
      regulator: max14577: Add missing of_node_put

Kumar Gala (1):
      of: Update qcom vendor prefix description

Kumar Sanghvi (1):
      RDMA/cxgb4: Add missing neigh_release in LE-Workaround path

Larry Finger (1):
      staging: r8188eu: Fix typo in USB_DEVICE list

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Lars-Peter Clausen (1):
      gpio: consumer.h: Move forward declarations outside #ifdef

Laura Abbott (1):
      staging: ion: Fix ION_IOC_FREE compat ioctl

Laurent Dufour (1):
      powerpc/relocate fix relocate processing in LE mode

Linus Torvalds (1):
      Linux 3.14-rc3

Linus Walleij (3):
      ARM: pxa: fix compilation problem on AM300EPD board
      ARM: pxa: fix various compilation problems
      ARM: ux500: disable msp2 device tree node

Liu Bo (1):
      Btrfs: fix a lockdep warning when cleaning up aborted transaction

Liu Junliang (1):
      USB2NET : SR9800 : One chip USB2.0 USB2NET SR9800 Device Driver Support

Maciej Żenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Mahesh Salgaonkar (2):
      powerpc/pseries: Disable relocation on exception while going
down during crash.
      powerpc: Fix kdump hang issue on p8 with relocation on exception enabled.

Marcus Folkesson (1):
      iio: adis16400: Set timestamp as the last element in chan_spec

Marek Belisko (1):
      of: add vendor prefix for Honeywell

Marek Szyprowski (1):
      staging: lustre: fix GFP_ATOMIC macro usage

Markus Mayer (1):
      gpio: bcm281xx: Update MODULE_AUTHOR

Markus Pargmann (1):
      serial: omap-serial: Move info message to probe function

Martin K. Petersen (1):
      block: Fix nr_vecs for inline integrity vectors

Martin Kepplinger (1):
      ALSA: Revert "ALSA: hda/realtek - Avoid invalid COEFs for ALC271X"

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Masanari Iida (1):
      block: Fix type mismatch in ssize_t_blk_mq_tag_sysfs_show

Matan Barak (1):
      IB/mlx4: Don't allocate range of steerable UD QPs for Ethernet-only device

Matija Glavinic Pecotic (1):
      net: sctp: fix initialization of local source address on
accepted ipv6 sockets

Matt Fleming (1):
      x86/efi: Check status field to validate BGRT header

Matt Rushton (1):
      xen-blkback: fix memory leak when persistent grants are used

Matthias Brugger (1):
      power: ds2782_battery: Typo in comment

Maurizio Lombardi (1):
      wlags49_h2: Fix overflow in wireless_set_essid()

Max Filippov (6):
      net: ethoc: implement basic ethtool operations
      net: ethoc: implement ethtool get/set settings
      net: ethoc: implement ethtool get registers
      net: ethoc: implement ethtool get/set ring parameters
      net: ethoc: don't advertise gigabit speed on attached PHY
      net: ethoc: set up MII management bus clock

Maxime Ripard (5):
      net: ethernet: sunxi: Add new compatibles
      net: phy: sunxi: Add new compatibles
      ARM: sunxi: dt: Convert to the new net compatibles
      misc: eeprom: sunxi: Add new compatibles
      ARM: sunxi: dt: Convert to the new SID compatibles

Mel Gorman (1):
      xen: properly account for _PAGE_NUMA during xen pte translations

Michael Ellerman (5):
      powerpc/perf: Add Power8 cache & TLB events
      powerpc/pseries: Select ARCH_RANDOM on pseries
      powerpc/xmon: Don't loop forever in get_output_lock()
      powerpc/xmon: Fix timeout loop in get_output_lock()
      powerpc/xmon: Don't signal we've entered until we're finished printing

Michael Grzeschik (1):
      serial: omap: fix rs485 probe on defered pinctrl

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Michal Kubecek (1):
      ipvs: fix AF assignment in ip_vs_conn_new()

Michal Simek (3):
      microblaze: Fix missing HZ macro
      microblaze: Define readq and writeq IO helper function
      ARM: zynq: Reserve not DMAable space in front of the kernel

Michele Baldessari (1):
      e100: Fix "disabling already-disabled device" warning

Mika Kuoppala (1):
      drm/i915: Pair va_copy with va_end in i915_error_vprintf

Mika Westerberg (2):
      ACPI / hotplug / PCI: Relax the checking of _STA return values
      serial: 8250_dw: fix compilation warning when !CONFIG_PM_SLEEP

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Mitch Harder (1):
      Btrfs: fix max_inline mount option

Moni Shoua (6):
      IB/mlx4: Make sure GID index 0 is always occupied
      IB/mlx4: Move rtnl locking to the right place
      IB/mlx4: Do IBoE locking earlier when initializing the GID table
      IB/mlx4: Do IBoE GID table resets per-port
      IB/mlx4: Build the port IBoE GID table properly under bonding
      IB: Report using RoCE IP based gids in port caps

Naoya Horiguchi (1):
      mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

Nathan Fontenot (1):
      crypto/nx/nx-842: Fix handling of vmalloc addresses

NeilBrown (2):
      md/raid1: restore ability for check and repair to fix read errors.
      lockd: send correct lock when granting a delayed lock.

Nicholas Bellinger (5):
      blk-mq: Add bio_integrity setup to blk_mq_make_request
      target: Fix free-after-use regression in PR unregister
      target: Fix 32-bit + CONFIG_LBDAF=n link error w/ sector_div
      iscsi-target: Fix SNACK Type 1 + BegRun=0 handling
      iser-target: Fix leak on failure in isert_conn_create_fastreg_pool

Nicholas Swenson (1):
      bcache: bugfix - gc thread now gets woken when cache is full

Nicolas Ferre (1):
      ARM: at91: add Atmel's SAMA5D3 Xplained board

Nishanth Menon (1):
      ARM: multi_v7_defconfig: Select CONFIG_SOC_DRA7XX

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oleg Drokin (5):
      staging/lustre: fix compile warning with is_vmalloc_addr
      staging/lustre/lnet: Fix use after free in ksocknal_send
      lustre: Account for changelog_ext_rec in CR_MAXSIZE
      lustre: Correct KUC code max changelog msg size
      lustre: add myself to list of people to CC on lustre patches

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (2):
      ath9k_htc: Do not support PowerSave by default
      ar5523: fix usb id for Gigaset.

Oliver Hartkopp (1):
      can: add destructor for self generated skbs

Olof Johansson (1):
      dma: mv_xor: Silence a bunch of LPAE-related warnings

Or Gerlitz (2):
      net/ipv4: Use non-atomic allocation of udp offloads structure instance
      net/vxlan: Go over all candidate streams for GRO matching

Oren Givon (1):
      iwlwifi: add more 7265 HW IDs

Pablo Neira Ayuso (5):
      netfilter: nf_conntrack: don't release a conntrack with non-zero refcnt
      netfilter: nf_tables: fix racy rule deletion
      netfilter: nf_tables: do not allow NFT_SET_ELEM_INTERVAL_END flag and data
      netfilter: nft_rbtree: fix data handling of end interval elements
      netfilter: nf_tables: fix loop checking with end interval elements

Patrick McHardy (9):
      netfilter: nf_tables: fix oops when deleting a chain with references
      netfilter: nf_tables: fix overrun in nf_tables_set_alloc_name()
      netfilter: nf_tables: fix potential oops when dumping sets
      netfilter: nft_ct: fix missing NFT_CT_L3PROTOCOL key in validity checks
      netfilter: nf_tables: add AF specific expression support
      netfilter: nft_reject: split up reject module into IPv4 and IPv6
specifc parts
      netfilter: nf_tables: add reject module for NFPROTO_INET
      netfilter: nf_tables: fix log/queue expressions for NFPROTO_INET
      netfilter: nf_tables: unininline nft_trace_packet()

Paul Bolle (3):
      raw: test against runtime value of max_raw_minors
      raw: set range for MAX_RAW_DEVS
      ia64/xen: Remove Xen support for ia64 even more

Paul Gortmaker (6):
      drivers/net: fix build warning in ethernet/sfc/tx.c
      drivers/tty/hvc: don't use module_init in non-modular hyp. console code
      staging: don't use module_init in non-modular ion_dummy_driver.c
      smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls
      powerpc: Fix build failure in sysdev/mpic.c for MPIC_WEIRD=y
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=n

Paul Zimmerman (2):
      usb: dwc2: fix role switch breakage
      usb: dwc2: fix memory corruption in dwc2 driver

Peter Hurley (2):
      n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
      n_tty: Fix stale echo output

Peter Meerwald (3):
      iio:magnetometer:mag3110: Report busy in _read_raw() /
write_raw() when buffer is enabled
      iio:magnetometer:mag3110: Fix output of decimal digits in
show_int_plus_micros()
      iio:accel:bma180: Use modifier instead of index in channel specification

Petr Písař (1):
      vt: Fix secure clear screen

Philipp Zabel (1):
      ARM: imx6: Initialize low-power mode early again

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Prakash Kamliya (1):
      staging: android: sync: Signal pt before sync_timeline object
gets destroyed

Prarit Bhargava (1):
      drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Pravin B Shelar (1):
      openvswitch: Fix ovs_flow_free() ovs-lock assert.

Qipan Li (1):
      serial: sirf: fix kernel panic caused by unpaired spinlock

Rafael Aquini (1):
      mm: fix page leak at nfs_symlink()

Rafael J. Wysocki (2):
      ACPI / dock: Use acpi_device_enumerated() to check if dock is present
      ACPI / container: Fix error code path in container_device_attach()

Randy Dunlap (1):
      staging/rtl8821ae: fix build, depends on MAC80211

Rashika Kheria (14):
      fs: Mark function as static in fs/bio-integrity.c
      fs: Add prototype declaration to appropriate header file
include/linux/bio.h
      net: Mark function as static in 9p/client.c
      net: Include appropriate header file in caif/caif_dev.c
      net: Include appropriate header file in caif/cfsrvl.c
      net: Mark functions as static in core/dev.c
      net: Move prototype declaration to appropriate header file from
decnet/af_decnet.c
      net: Move prototype declaration to header file include/net/dn.h
from net/decnet/af_decnet.c
      net: Move prototype declaration to include/net/ipx.h from
net/ipx/ipx_route.c
      net: Move prototype declaration to header file include/net/ipx.h
from net/ipx/af_ipx.c
      net: Move prototype declaration to header file
include/net/datalink.h from net/ipx/af_ipx.c
      net: Move prototype declaration to header file
include/net/net_namespace.h from net/ipx/af_ipx.c
      net: Include appropriate header file in netfilter/nft_lookup.c
      net: Mark functions as static in net/sunrpc/svc_xprt.c

Raymond Wanyoike (2):
      net: qmi_wwan: add ZTE MF667
      usb: option: blacklist ZTE MF667 net interface

Richard Genoud (2):
      get_maintainer: fix detection of git repository
      checkpatch: fix detection of git repository

Richard Weinberger (2):
      staging:iio:spear_adc: Add dependency on HAS_IOMEM
      staging:iio:lpc32xx_adc: Add dependency on HAS_IOMEM

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Rob Clark (6):
      drm/msm: fix inconsequential typo
      drm/msm/mdp5: fix ref leaks in error paths
      drm/msm/mdp4: pageflip fixes
      drm/msm/mdp4: cursor fixes
      drm/msm: fix deadlock in bo create fail path
      drm/msm: bigger synchronization hammer

Rob Herring (4):
      ARM: hisi: fix kconfig warning on HAVE_ARM_TWD
      ARM: moxart: move DMA_OF selection to driver
      ARM: fix HAVE_ARM_TWD selection for OMAP and shmobile
      of: restructure for_each macros to fix compile warnings

Roger Pau Monne (4):
      xen-blkback: fix memory leaks
      xen-blkback: fix shutdown race
      xen-blkif: drop struct blkif_request_segment_aligned
      xen-blkback: init persistent_purge_work work_struct

Roi Dayan (1):
      IB/iser: Avoid dereferencing iscsi_iser conn object when not
bound to iser connection

Roland Dreier (4):
      qla2xxx: Remove last vestiges of qla_tgt_cmd.cmd_list
      target: Fix missing length check in spc_emulate_evpd_83()
      target: Simplify command completion by removing CMD_T_FAILED flag
      mlx5: Add include of <linux/slab.h> because of kzalloc()/kfree() use

Rostislav Lisovy (1):
      can: Propagate SO_PRIORITY of raw sockets to skbs

Russell King (4):
      imx-drm: imx-drm-core: use the crtc drm device for vblank
      imx-drm: imx-drm-core: avoid going the long route round for drm_device
      imx-drm: imx-drm-core: merge imx_drm_crtc_register() into
imx_drm_add_crtc()
      drivers/base: fix devres handling for master device

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Sachin Kamat (6):
      staging: imx-drm: Fix build error
      drm/exynos: Fix freeing issues in exynos_drm_drv.c
      drm/exynos: Remove unnecessary semicolon
      drm/exynos: Fix trivial typo
      drm/exynos: Convert to use the standard hdmi.h header
      video: exynos: Fix S6E8AX0 LCD driver build error

Sagi Grimberg (1):
      Target/sbc: Fix protection copy routine

Salym Senyonga (1):
      Staging: ozwpan: Fix null dereference

Sarah Sharp (8):
      xhci: Fix resume issues on Renesas chips in Samsung laptops
      Revert "usbcore: set lpm_capable field for LPM capable root hubs"
      Revert "xhci: replace xhci_write_64() with writeq()"
      Revert "xhci: replace xhci_read_64() with readq()"
      xhci 1.0: Limit arbitrarily-aligned scatter gather.
      Revert "xhci: Set scatter-gather limit to avoid failed block writes."
      Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
      Revert "usb: xhci: Link TRB must not occur within a USB payload burst"

Sebastian Ott (1):
      s390/cio: improve cio_commit_config

Sebastian Reichel (1):
      dt: binding documentation for bq2415x charger

Shaohua Li (2):
      percpu_ida: fix a live lock
      blk-mq: Don't reserve a tag for flush request

Shlomo Pongratz (2):
      net/ipv4: Use proper RCU APIs for writer-side in udp_offload.c
      block/null_blk: Fix completion processing from LIFO to FIFO

Shuah Khan (1):
      staging/usbip: Fix vhci_hcd attach failure error message to be informative

Stanislaw Gruszka (4):
      ath9k_htc: make ->sta_rc_update atomic for most calls
      rt2800: disable PS by default on USB
      rt2500: disable PS by default
      ath9k_htc: avoid scheduling while atomic on sta_rc_update

Stefan Roese (1):
      net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver

Stefan Sørensen (4):
      net:phy:dp83640: Declare that TX timestamping possible
      net:phy:dp83640: Do not hardcode timestamping event edge
      net:phy:dp83640: Initialize PTP clocks at device init.
      ptp: Allow selecting trigger/event index in testptp

Stephen Boyd (1):
      genirq: Add devm_request_any_context_irq()

Steve French (3):
      Add protocol specific operation for CIFS xattrs
      retrieving CIFS ACLs when mounted with SMB2 fails dropping session
      [CIFS] clean up page array when uncached write send fails

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (2):
      x86: Use preempt_disable_notrace() in cycles_2_ns()
      slub: do not assert not having lock in removing freed partial

Steven Rostedt (Red Hat) (2):
      ring-buffer: Fix first commit on sub-buffer having non-zero delta
      ftrace/x86: Use breakpoints for converting function graph caller

Sudeep Dutt (1):
      misc: mic: fix possible signed underflow (undefined behavior) in
userspace API

Sudeep Holla (1):
      MAINTAINERS / cpufreq: update Sudeep's email address

Sujith Manoharan (4):
      ath9k: Fix build error on ARM
      ath9k: Do not support PowerSave by default
      ath9k: Fix TX power calculation
      mac80211: Fix IBSS disconnect

Surendra Patil (1):
      staging: rtl8821ae: Fixed the size of array to macro as discussed by Linus

Takashi Iwai (4):
      ALSA: hda - Fix leftover ifdef checks after modularization
      ALSA: hda - Fix inconsistent Mic mute LED
      ALSA: hda - Fix mic capture on Sony VAIO Pro 11
      ALSA: hda - Fix undefined symbol due to builtin/module mixup

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypassing

Thadeu Lima de Souza Cascardo (1):
      powerpc/eeh: Drop taken reference to driver on eeh_rmv_device

Thomas Gleixner (1):
      tick: Clear broadcast pending bit when switching to oneshot

Thomas Graf (1):
      openvswitch: Pad OVS_PACKET_ATTR_PACKET if linear copy was performed

Tim Kryger (1):
      clocksource: Kona: Print warning rather than panic

Todd Poynor (1):
      staging: ashmem: Avoid deadlock between read and mmap calls

Tomas Winkler (1):
      ion: dummy driver: use ARRAY_SIZE for nr of heaps

Tomi Valkeinen (2):
      OMAPDSS: DISPC: decimation rounding fix
      OMAPDSS: fix fck field types

Toshiaki Makita (9):
      bridge: Fix the way to find old local fdb entries in br_fdb_changeaddr
      bridge: Fix the way to insert new local fdb entries in br_fdb_changeaddr
      bridge: Fix the way to find old local fdb entries in
br_fdb_change_mac_address
      bridge: Change local fdb entries whenever mac address of bridge
device changes
      bridge: Fix the way to check if a local fdb entry can be deleted
      bridge: Properly check if local fdb entry can be deleted in
br_fdb_change_mac_address
      bridge: Properly check if local fdb entry can be deleted in
br_fdb_delete_by_port
      bridge: Properly check if local fdb entry can be deleted when
deleting vlan
      bridge: Prevent possible race condition in br_fdb_change_mac_address

Tushar Behera (1):
      drm/exynos: Fix multiplatform breakage for ipp/gsc

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Upinder Malhi (1):
      IB/usnic: Fix smatch endianness error

Ursula Braun (1):
      s390/qdio: correct program-controlled interruption checking

Venkat Venkatsubra (1):
      rds: The maintainer needs to be updated.

Wei Yongjun (1):
      isp1704_charger: remove useless check in isp1704_charger_probe()

Wolfram Sang (3):
      i2c: mv64xxx: refactor message start to ensure proper initialization
      Documentation: i2c: describe devicetree method for instantiating devices
      Documentation: i2c: mention ACPI method for instantiating devices

Xue jiufei (1):
      ocfs2: check existence of old dentry in ocfs2_link()

Younger Liu (2):
      ocfs2: fix ocfs2_sync_file() if filesystem is readonly
      ocfs2: fix issue that ocfs2_setattr() does not deal with
new_i_size==i_size

Yuval Mintz (1):
      bnx2x: Allow VF rss on higher PFs

Zoltan Kiss (1):
      xen-netback: Fix Rx stall due to race condition

andrea.merello (2):
      rtl8180: Add error check for pci_map_single return value in RX path
      rtl8180: Add error check for pci_map_single return value in TX path

dingtianhong (3):
      bonding: fail_over_mac should only affect AB mode at enslave and
removal processing
      bonding: fail_over_mac should only affect AB mode in
bond_set_mac_address()
      bonding: remove unwanted bond lock for enslave processing

hayeswang (1):
      r8152: fix the submission of the interrupt transfer

xinhui.pan (1):
      gpio: intel-mid: fix the incorrect return of idle callback
