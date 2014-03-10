Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaCJEUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:20:09 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:57875 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaCJEUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:20:05 -0400
MIME-Version: 1.0
Date: Sun, 9 Mar 2014 21:20:03 -0700
X-Google-Sender-Auth: FHsnTEIBrviKKXvJsvxYRYiV8H4
Message-ID: <CA+55aFyJG1X_N6FjwC6qH9G-f6Y7FpX7+=rc3DQCnObtVqtuvg@mail.gmail.com>
Subject: Linux 3.14-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting closer to the end of the rc cycle, and I have to admit
that I would have wished for a less bumpy ride.

There haven't been any huge problems, but there's been quite a few
small bumps that shouldn't happen this late in the release cycle. And
rc6 is noticeably bigger than rc5 was, as well.

So I'm really hoping that the upcoming week will be calmer, because
otherwise I'll start thing rc8 and even rc9..

That said, there's nothing really fundamentally scary here. Small
stupid mistakes, and a few late reverts of commits that turned out to
not be so great, but the bulk is trivial fixes. So I'm still
reasonably optimistic.

             Linus

---

Aaron Plattner (1):
      cpufreq: use cpufreq_cpu_get() to avoid cpufreq_get() race conditions

Akash Goel (1):
      drm/i915: Resolving the memory region conflict for Stolen area

Alex Deucher (4):
      drm/radeon: resume old pm late
      drm/radeon/cik: fix typo in documentation
      drm/radeon/dpm: fix typo in EVERGREEN_SMC_FIRMWARE_HEADER_softRegisters
      drm/radeon/atom: select the proper number of lanes in transmitter setup

Alexander Stein (2):
      spi/topcliff-pch: Fix DMA channel
      spi-topcliff-pch: Fix probing when DMA mode is used

Alexandre Bounine (1):
      rapidio/tsi721: fix tasklet termination in dma channel release

Amir Vadai (1):
      net,IB/mlx: Bump all Mellanox driver versions

Amitkumar Karwar (3):
      mwifiex: add NULL check for PCIe Rx skb
      mwifiex: fix cmd and Tx data timeout issue for PCIe cards
      NFC: NCI: Fix NULL pointer dereference

Andrew Bresticker (3):
      clk: tegra: fix sdmmc clks on Tegra1x4
      clk: tegra: cclk_lp has a pllx/2 divider
      clk: tegra: use max divider if divider overflows

Andy Adamson (1):
      NFSv4.1 Fail data server I/O if stateid represents a lost lock

Andy Honig (1):
      kallsyms: fix absolute addresses for kASLR

Anton Blanchard (1):
      powerpc: Align p_dyn, p_rela and p_st symbols

Arend van Spriel (1):
      brcmfmac: fix txglomming scatter-gather packet transfers

Arik Nemtsov (1):
      mac80211: fix sched_scan restart on recovery

Asai Thambi S P (1):
      mtip32xx: Reduce the number of unaligned writes to 2

Avinash Patil (1):
      mwifiex: clean pcie ring only when device is present

Axel Lin (2):
      spi: fsl-dspi: Fix getting correct address for master
      spi: coldfire-qspi: Fix getting correct address for *mcfqspi

Barry Song (1):
      pinctrl: sirf: fix kernel panic in gpio_lock_as_irq

Benoit Cousson (1):
      clk: shmobile: rcar-gen2: Use kick bit to allow Z clock frequency change

Bing Zhao (2):
      mwifiex: rename usb driver name registerring to usb core
      mwifiex: do not advertise usb autosuspend support

Borislav Petkov (2):
      MAINTAINERS: EDAC: add Mauro and Borislav as interim patch collectors
      x86/efi: Quirk out SGI UV

Chen-Yu Tsai (1):
      pinctrl: sunxi: use chained_irq_{enter, exit} for GIC compatibility

Christian Daudt (1):
      pinctrl: refer to updated dt binding string.

Christoph Hellwig (3):
      blk-mq: remove blk_mq_alloc_rq
      blk-mq: merge blk_mq_insert_request and blk_mq_run_request
      blk-mq: support partial I/O completions

Chuansheng Liu (1):
      genirq: Remove racy waitqueue_active check

Cristian Bercaru (1):
      phy: unmask link partner capabilities

Dan Carpenter (2):
      hsr: off by one sanity check in hsr_register_frame_in()
      qlcnic: dcb: a couple off by one bugs

Dan Williams (1):
      dma debug: account for cachelines and read-only mappings in
overlap tracking

Daniel Borkmann (2):
      net: sctp: rework multihoming retransmission path selection to rfc4960
      net: sctp: fix sctp_sf_do_5_1D_ce to verify if we/peer is AUTH capable

Daniel M. Weeks (1):
      scripts/gen_initramfs_list.sh: fix flags for initramfs LZ4 compression

Dave Airlie (1):
      MAINTAINERS: update AGP tree to point at drm tree

David A. Long (1):
      ARM: 7964/1: Detect section mismatches in thumb relocations

David Howells (1):
      KEYS: Make the keyring cycle detector ignore other keyrings of
the same name

David Rientjes (1):
      mm: close PageTail race

David S. Miller (1):
      ip_tunnel: Move ip_tunnel_get_stats64 into ip_tunnel_core.c

David Ung (1):
      clk: tegra: PLLD2 fixes for hdmi

Ditang Chen (1):
      SUNRPC: Fix oops when trace sunrpc_task events in nfs client

Duan Fugang-B38611 (1):
      net: fec: fix potential issue to avoid fec interrupt lost and crc error

Duan Jiong (1):
      neigh: recompute reachabletime before returning from neigh_periodic_work()

Edward Cree (1):
      sfc: check for NULL efx->ptp_data in efx_ptp_event

Emmanuel Grumbach (2):
      mac80211: fix AP powersave TX vs. wakeup race
      iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails

Eric Dumazet (3):
      net-tcp: fastopen: fix high order allocations
      tcp: reduce the bloat caused by tcp_is_cwnd_limited()
      net: tcp: use NET_INC_STATS()

Eytan Lifshitz (1):
      mac80211: fix memory leak

FX Le Bail (1):
      netfilter: nf_nat_snmp_basic: fix duplicates in if/else branches

Felix Fietkau (4):
      mac80211: send control port protocol frames to the VO queue
      ath9k: fix ps-poll responses under a-mpdu sessions
      ath9k: reduce baseband hang detection false positive rate
      ath9k: fix invalid descriptor discarding

Fernando Luis Vazquez Cao (1):
      tun: remove bogus hardware vlan acceleration flags from vlan_features

Filipe Brandenburger (1):
      memcg: reparent charges of children before processing parent

Florian Westphal (1):
      netfilter: nf_tables: fix nf_trace always-on with XT_TRACE=n

Freddy Xin (1):
      AX88179_178A: Add VID:DID for Lenovo OneLinkDock Gigabit LAN

Gabe Black (1):
      clk: tegra: Fix PLLP rate table

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

Geert Uytterhoeven (1):
      sh: prefix sh-specific "CCR" and "CCR2" by "SH_"

George McCollister (1):
      sched: Fix double normalization of vruntime

Gerd Hoffmann (1):
      drm: fix bochs kconfig dependencies

Gerry Demaret (1):
      USB AX88179/178A: Support D-Link DUB-1312

H. Peter Anvin (1):
      x86: Ignore NMIs that come in during early boot

Hannes Frederic Sowa (2):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data
      ipv4: ipv6: better estimate tunnel header cut for correct ufo handling

Hans Schillstrom (1):
      ipv6: ipv6_find_hdr restore prev functionality

Hans de Goede (2):
      pinctrl: sunxi: Fix masking when setting irq type
      pinctrl: sunxi: Fix interrupt register offset calculation

Hauke Mehrtens (2):
      b44: add calls to phy_{start,stop}
      b44: always set duplex mode why phy changes

Heinz Mauelshagen (1):
      dm cache mq: fix memory allocation failure for large cache devices

Hiroaki SHIMODA (1):
      sch_tbf: Fix potential memory leak in tbf_change().

Hugh Dickins (2):
      lib/radix-tree.c: swapoff tmpfs radix_tree: remember to rcu_read_unlock
      memcg: fix endless loop in __mem_cgroup_iter_next()

Hui Wang (1):
      ALSA: hda - add automute fix for another dell AIO model

Illia Smyrnov (1):
      ARM: OMAP4: hwmod: Fix SOFTRESET logic for OMAP4

Imre Deak (2):
      drm/i915: fix pch pci device enumeration
      drm/i915: vlv: reserve GT power context early

Inbal Hacohen (1):
      cfg80211: bugfix in regulatory user hint process

Ira W. Snyder (3):
      tools/liblockdep: Fix initialization code path
      tools/liblockdep: Fix include of asm/hash.h
      tools/liblockdep: Add include directory to allow tests to compile

Ivan Khoronzhuk (2):
      clk: keystone: gate: fix clk_init_data initialization
      ARM: keystone: dts: fix clkvcp3 control register address

Ivan Vecera (1):
      bna: fix vlan tag stripping and implement its toggling

James Cameron (1):
      libertas: fix scan result loss if SSID IE len 0

Jan Kara (1):
      ocfs2: fix quota file corruption

Jani Nikula (1):
      drm/i915: use backlight legacy combination mode also for i915gm/i945gm

Janusz Dziedzic (1):
      cfg80211: regulatory: reset regdomain in case of error

Jason Wang (1):
      virtio-net: alloc big buffers also when guest can receive UFO

Javier Martinez Canillas (1):
      ARM: dts: omap3-igep: fix boot fail due wrong compatible match

Jean Delvare (2):
      x86_pkg_temp_thermal: Do not expose as a hwmon device
      x86_pkg_temp_thermal: Fix the thermal zone type

Jiri Bohac (1):
      bonding: disallow enslaving a bond to itself

Jiri Olsa (1):
      x86, trace: Fix CR2 corruption when tracing page faults

Jiri Pirko (1):
      neigh: fix setting of default gc_* values

Joe Perches (3):
      MAINTAINERS: Intel nic drivers
      MAINTAINERS: use tab for separator
      MAINTAINERS: add and correct types of some "T:" entries

Joe Thornber (4):
      dm thin: fix out of data space handling
      dm thin: fix deadlock in __requeue_bio_list
      dm thin: fix noflush suspend IO queueing
      dm space map metadata: fix refcount decrement below 0 which
caused corruption

Johannes Berg (5):
      mac80211: insert stations before adding to driver
      mac80211: fix station wakeup powersave race
      mac80211: don't validate unchanged AP bandwidth while tracking
      iwlwifi: fix TX status for aggregated packets
      mac80211: fix association to 20/40 MHz VHT networks

Johannes Weiner (1):
      mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness

Josh Cartwright (1):
      pinctrl: msm: make PINCTRL_MSM bool instead of tristate

Julius Werner (2):
      usb: Add device quirk for Logitech HD Pro Webcams C920 and C930e
      usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests

Juri Lelli (2):
      sched/deadline: Switch CPU's presence test order
      sched/deadline: Prevent rt_time growth to infinity

Kees Cook (1):
      ARM: 7963/1: mm: report both sections from PMD

Kieran Clancy (1):
      ACPI / EC: Clear stale EC events on Samsung systems

Kirill Tkhai (2):
      hostap: Do not free priv until timer handler has actually stopped using it
      sched/deadline: Cleanup RT leftovers from {inc/dec}_dl_migration

Kyle McMartin (1):
      r8169: initialize rtl8169_stats seqlock

Laurent Pinchart (5):
      clk: shmobile: rcar-gen2: Fix clock parent all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: rcar-gen2: Fix clock parent for all non-PLL clocks
      clk: shmobile: rcar-gen2: Fix qspi divisor
      clk: shmobile: Fix typo in MSTP clock DT bindings

Lauri Kasanen (1):
      drm/radeon: TTM must be init with cpu-visible VRAM, v2

Li Zefan (2):
      cpuset: fix a locking issue in cpuset_migrate_mm()
      cpuset: fix a race condition in __cpuset_node_allowed_softwall()

Li, Aubrey (1):
      ACPI / sleep: pm_power_off needs more sanity checks to be installed

Linus Torvalds (2):
      x86: fix compile error due to X86_TRAP_NMI use in asm files
      Linux 3.14-rc6

Linus Walleij (2):
      clk: nomadik: fix multiplatform problem
      ARM: 7991/1: sa1100: fix compile problem on Collie

Liu Ping Fan (1):
      mm: numa: bugfix for LAST_CPUPID_NOT_IN_PAGE_FLAGS

Lorenzo Colitti (1):
      net: ipv6: ping: Use socket mark in routing lookup

Magnus Damm (1):
      pinctrl: sh-pfc: r8a7791: SD1_CLK fix

Marc Kleine-Budde (7):
      can: flexcan: fix shutdown: first disable chip, then all interrupts
      can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
      can: flexcan: fix transition from and to low power mode in
chip_{en,dis}able
      can: flexcan: factor out transceiver {en,dis}able into seperate functions
      can: flexcan: fix transition from and to freeze mode in chip_{,un}freeze
      can: flexcan: flexcan_remove(): add missing netif_napi_del()
      can: flexcan: factor out soft reset into seperate funtion

Marek Belisko (1):
      ARM: dts: omap3-gta04: Add ti,omap36xx to compatible property to
avoid problems with booting

Marios Andreopoulos (1):
      libata: disable queued TRIM for Crucial M500 mSATA SSDs

Marius Knaust (1):
      ALSA: hda - Added inverted digital-mic handling for Acer TravelMate 8371

Mark Rutland (1):
      ARM: 7992/1: boot: compressed: ignore bswapsdi2.S

Mark Salter (1):
      c6x: fix build failure caused by cache.h

Mark Zhang (1):
      clk: tegra: fix host1x clock on Tegra124

Markus Pargmann (2):
      regulator: core: Replace direct ops->enable usage
      regulator: core: Replace direct ops->disable usage

Masanari Iida (1):
      clk:at91: Fix memory leak in of_at91_clk_master_setup()

Mathias Nyman (2):
      Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."
      Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"

Matija Glavinic Pecotic (1):
      net: sctp: Potentially-Failed state should not be reached from
unconfirmed state

Max Filippov (1):
      net: ethoc: document OF bindings

Max Stepanov (1):
      iwlwifi: mvm: change of listen interval from 70 to 10

Maxime Ripard (2):
      ARM: sun7i: dt: Fix interrupt trigger types
      ARM: sunxi: dt: Change the touchscreen compatibles

Michael Chan (1):
      tg3: Don't check undefined error bits in RXBD

Michael Neuling (1):
      powerpc/tm: Fix crash when forking inside a transaction

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate
Momentus SpinPoint M8 (2BA30001)

Mike Galbraith (1):
      rt,blk,mq: Make blk_mq_cpu_notify_lock a raw spinlock

Mike Pecovnik (1):
      net: Fix permission check in netlink_connect()

Mike Snitzer (4):
      dm: fix Kconfig indentation
      dm thin: synchronize the pool mode during suspend
      dm thin: ensure user takes action to validate data and metadata
consistency
      dm thin: fix Documentation for held metadata root feature

Mikulas Patocka (1):
      dm snapshot: fix metadata corruption

Minchan Kim (1):
      zram: avoid null access when fail to alloc meta

Ni Wade (1):
      Thermal: Allow first update of cooling device state

Nicholas Bellinger (7):
      bio-integrity: Drop bio_integrity_verify BUG_ON in post
bip->bip_iter world
      iscsi-target: Fix iscsit_get_tpg_from_np tpg_state bug
      iscsi/iser-target: Use list_del_init for ->i_conn_node
      iscsi/iser-target: Fix isert_conn->state hung shutdown issues
      iser-target: Fix post_send_buf_count for RDMA READ/WRITE
      iser-target: Ignore completions for FRWRs in isert_cq_tx_work
      iser-target: Fix command leak for tx_desc->comp_llnode_batch

Nicolas Dichtel (1):
      sit: fix panic with route cache in ip tunnels

Nikolay Aleksandrov (2):
      netfilter: nf_tables: check if payload length is a power of 2
      bonding: fix a div error caused by the slave release path

Oliver Hartkopp (1):
      can: remove CAN FD compatibility for CAN 2.0 sockets

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: force null nat binding on insert

Patrick McHardy (1):
      netfilter: nft_reject_inet: fix unintended fall-through in
switch-statatement

Paul Bolle (2):
      netfilter: nft_meta: fix typo "CONFIG_NET_CLS_ROUTE"
      drm/radeon: silence GCC warning on 32 bit

Paulo Zanoni (1):
      drm/i915: fix assert_cursor on BDW

Peter De Schrijver (3):
      clk: tegra: Add missing Tegra20 fuse clks
      clk: tegra: Fix vic03 mux index
      clk: tegra124: remove gr2d and gr3d clocks

Peter Zijlstra (1):
      x86, trace: Further robustify CR2 handling vs tracing

Philippe De Muyter (1):
      spi: spi-imx: spi_imx_remove: do not disable disabled clocks

Rafael J. Wysocki (1):
      Revert "ACPI / sleep: pm_power_off needs more sanity checks to
be installed"

Rajesh Borundia (1):
      qlcnic: Fix number of rings when we fall back from msix to legacy.

Rashika Kheria (1):
      genirq: Include missing header file in irqdomain.c

Rhyland Klein (1):
      clk: tegra: Fix PLLD mnp table

Richard Weinberger (1):
      thermal,rcar_thermal: Add dependency on HAS_IOMEM

Russell King (3):
      DRM: armada: fix use of kfifo_put()
      MAINTAINERS: add maintainer entry for TDA998x driver
      ARM: fix noMMU kallsyms symbol filtering

Sagi Grimberg (1):
      Target/sbc: Fix sbc_copy_prot for offset scatters

Salva Peiró (1):
      staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl()

Santosh Shilimkar (1):
      ARM: OMAP: Kill warning in CPUIDLE code with !CONFIG_SMP

Sasha Levin (2):
      tools/liblockdep: Mark runtests.sh as executable
      tools/liblockdep: Add a stub for new rcu_is_watching

Schuyler Patton (1):
      net: cpsw: fix cpdma rx descriptor leak on down interface

Sebastian Hesselbarth (4):
      clk: mvebu: armada-370: maintain clock init order
      clk: mvebu: armada-xp: maintain clock init order
      clk: mvebu: dove: maintain clock init order
      clk: mvebu: kirkwood: maintain clock init order

Sebastian Reichel (1):
      ARM: OMAP2+: Add support for thumb mode on DT booted N900

Shahed Shaikh (2):
      qlcnic: Fix function return error check
      qlcnic: Fix usage of use_msi and use_msi_x module parameters

Shaohua Li (1):
      blk-mq: add REQ_SYNC early

Sherman Yin (2):
      Update dtsi with new pinctrl compatible string
      pinctrl: Rename Broadcom Capri pinctrl binding

Somnath Kotur (1):
      be2net: Fix to reset transparent vlan tagging

Somnath kotur (1):
      be2net: clear promiscuous bits in adapter->flags while disabling
promiscuous mode

Stanislaw Gruszka (1):
      ath9k: protect tid->sched check

Stefan Richter (2):
      firewire: net: fix use after free
      firewire: ohci: fix probe failure with Agere/LSI controllers

Steffen Klassert (5):
      ip6_vti: Fix build when NET_IP_TUNNEL is not set.
      xfrm: Fix NULL pointer dereference on sub policy usage
      xfrm: Take xfrm_state_lock in xfrm_migrate_state_find
      xfrm: Clone states properly on migration
      xfrm: Fix unlink race when policies are deleted.

Stephen Warren (1):
      ARM: tegra: add LED options back into tegra_defconfig

Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

Sucheta Chakraborty (1):
      qlcnic: Allow any VLAN to be configured from VF.

Sujith Manoharan (1):
      ath9k: Fix ETSI compliance for AR9462 2.0

Suman Anna (1):
      ARM: DRA7: hwmod data: correct the sysc data for spinlock

Sylwester Nawrocki (1):
      clk: Correct handling of NULL clk in __clk_{get, put}

Takashi Iwai (3):
      ALSA: hda - Add missing loopback merge path for AD1884/1984 codecs
      ALSA: hda - Use analog beep for Thinkpads with AD1984 codecs
      ALSA: usb-audio: Add quirk for Logitech Webcam C500

Tejun Heo (1):
      firewire: don't use PREPARE_DELAYED_WORK

Thadeu Lima de Souza Cascardo (1):
      net/cxgb4: use remove handler as shutdown handler

Thierry Reding (1):
      clk: tegra: Correct clock number for UARTE

Thomas Petazzoni (1):
      ARM: 7980/1: kernel: improve error message when LPAE config
doesn't match CPU

Tobias Klauser (1):
      net: stmmac: Check return value of alloc_dma_desc_resources()

Tomi Valkeinen (1):
      ARM: OMAP2+: clock: fix clkoutx2 with CLK_SET_RATE_PARENT

Tony Lindgren (1):
      ARM: OMAP3: Fix pinctrl interrupts for core2

Toshiaki Makita (1):
      veth: Fix vlan_features so as to be able to use stacked vlan interfaces

Trond Myklebust (5):
      NFSv4: Fix another nfs4_sequence corruptor
      NFS: Fix a delegation callback race
      NFSv4: nfs4_stateid_is_current should return 'true' for an invalid stateid
      NFSv4: Fix the return value of nfs4_select_rw_stateid
      NFSv4: Fail the truncate() if the lock/open stateid is invalid

Ursula Braun (1):
      qeth: postpone freeing of qdio memory

Uwe Kleine-König (1):
      ARM: XEN depends on having a MMU

Vaibhav Bedia (1):
      ARM: OMAP5: PRM: Fix reboot handling

Vasundhara Volam (2):
      be2net: Fix skb double free in be_xmit_wrokarounds() failure path
      be2net: isolate TX workarounds not applicable to Skyhawk-R

Vikas Sajjan (1):
      drivers/rtc/rtc-s3c.c: fix incorrect way of save/restore of
S3C2410_TICNT for TYPE_S3C64XX

Ville Syrjälä (1):
      drm/i915: Reject >165MHz modes w/ DVI monitors

Vineet Gupta (1):
      ARC: Use correct PTAG register for icache flush

Viresh Kumar (2):
      cpufreq: Initialize policy before making it available for others to use
      cpufreq: Initialize governor for a new policy under policy->rwsem

Vlad Yasevich (1):
      macvlan: Add support for 'always_on' offload features

Vlastimil Babka (1):
      mm: include VM_MIXEDMAP flag in the VM_SPECIAL list to avoid m(un)locking

Vyacheslav Dubeyko (1):
      hfsplus: fix remount issue

Wang Nan (1):
      tools/liblockdep: Use realpath for srctree and objtree

Wei Liu (1):
      xen-netfront: reset skb network header before checksum

Wenyou Yang (1):
      spi: atmel: add missing spi_master_{resume,suspend} calls to PM callbacks

Xin Long (1):
      ip_tunnel:multicast process cause panic due to skb->_skb_refdst
NULL pointer

Ying Xue (2):
      tipc: remove all enabled flags from all tipc components
      tipc: make bearer set up in module insertion stage

Yuchung Cheng (1):
      tcp: fix bogus RTT on special retransmission

Yuval Mintz (1):
      bnx2x: Add missing bit in default Tx switching

Zhang Rui (3):
      ACPI / resources: ignore invalid ACPI device resources
      Thermal: update INT3404 thermal driver help text
      Thermal: thermal zone governor fix

dingtianhong (2):
      bonding: Fix RTNL: assertion failed at net/core/rtnetlink.c for
802.3ad mode
      bonding: Fix RTNL: assertion failed at net/core/rtnetlink.c for
ab arp monitor
