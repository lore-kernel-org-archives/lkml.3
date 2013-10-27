Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab3J0XbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 19:31:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53470 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J0Xa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 19:30:59 -0400
MIME-Version: 1.0
Date: Sun, 27 Oct 2013 16:30:58 -0700
X-Google-Sender-Auth: FKw7M2Z1bzXyAJ4QFcLNNUgW-nU
Message-ID: <CA+55aFxnWMaVt3uDK6A_pK7uSbov2v=nz+-rfReVkoAMAc3cvA@mail.gmail.com>
Subject: Linux 3.12-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KS week is over, and thus the seventh - and likely the last - rc
for 3.12 is out, and I'm back on the normal Sunday schedule.

The slowdown in -rc sizes sadly reversed itself here, mostly due to
the networking updates that hadn't come in for rc5-rc6. You can see
that in the diffstat, with more than 50% being networking (both driver
and core) patches. The rest is generally other drivers (gpu, media,
scsi, thermal, HID) and some smaller arch updates (s390, parisc, x86).

Nothing looks particularly shocking, though, so we're still on track
for 3.12.  Which does mean, that with me having more travel coming up,
the 3.13 merge window will likely end up being a bit messed up.

I can usually schedule around these kinds of things, but with two
different trips and just a week in between, I have the choice of
either just delaying 3.12 for no good reason, or just saying "ok,
we'll just keep the merge window open a bit longer because I won't be
able to be as responsive as I should be".

But who knows. If something particularly worrisome comes up during the
upcoming week, I might just say "Ok, we'll do an rc8 instead". So I'm
keeping my options open.

                  Linus

---

Aaron Lu (1):
      [SCSI] sd: call blk_pm_runtime_init before add_disk

AceLan Kao (2):
      HID: usbhid: quirk for Synaptics Large Touchccreen
      HID: usbhid: quirk for SiS Touchscreen

Al Viro (1):
      nfsd regression since delayed fput()

Alan Ott (5):
      6lowpan: Only make 6lowpan links to IEEE802154 devices
      6lowpan: Sync default hardware address of lowpan links to their wpan
      mrf24j40: Move INIT_COMPLETION() to before packet transmission
      mrf24j40: Use threaded IRQ handler
      mrf24j40: Use level-triggered interrupts

Alex Deucher (6):
      drm/radeon/atom: workaround vbios bug in transmitter table on rs780
      drm/radeon: make missing smc ucode non-fatal (r7xx-SI)
      drm/radeon: make missing smc ucode non-fatal (CI)
      drm/radeon/audio: don't set speaker allocation on DCE3.2
      drm/radeon: rework audio option
      drm/radeon/audio: don't set speaker allocation on DCE4+

Alexander Bondar (1):
      iwlwifi: mvm: Disable uAPSD for D3 image

Alexandre Belloni (1):
      mac802154: correct a typo in ieee802154_alloc_device() prototype

Alexei Starovoitov (1):
      net: fix unsafe set_memory_rw from softirq

Amir Vadai (2):
      net/mlx4_en: Rename name of mlx4_en_rx_alloc members
      net/mlx4_en: Fix pages never dma unmapped on rx

Amitkumar Karwar (1):
      mwifiex: fix SDIO interrupt lost issue

Andi Kleen (2):
      igb: Avoid uninitialized advertised variable in eee_set_cur
      tcp: Always set options to 0 before calling tcp_established_options

Andreas Matthies (1):
      [media] tda10071: change firmware download condition

Andy Gospodarek (1):
      bonding: update MAINTAINERS

Anjana V Kumar (1):
      cgroup: fix to break the while loop in cgroup_attach_task() correctly

Antti Palosaari (3):
      [media] e4000: fix PLL calc bug on 32-bit arch
      [media] msi3101: Kconfig select VIDEOBUF2_VMALLOC
      [media] msi3101: correct max videobuf2 alloc

Ariel Elior (3):
      bnx2x: Unlock VF-PF channel on MAC/VLAN config error
      bnx2x: Fix config when SR-IOV and iSCSI are enabled
      bnx2x: Lock DMAE when used by statistic flow

Arnaldo Carvalho de Melo (1):
      perf scripting perl: Fix build error on Fedora 12

Avinash Patil (2):
      mwifiex: inform cfg80211 about disconnect if device is removed
      mwifiex: inform cfg80211 about disconnect for P2P client interface

Axel Lin (3):
      ASoC: pcm1681: Fix max_register setting
      ASoC: pcm1681: Fix max_register setting
      ASoC: pcm1792a: Fix max_register setting

Ben Hutchings (1):
      sfc: Only bind to EF10 functions with the LinkCtrl and Trusted flags

Ben Widawsky (2):
      drm/i915: Make PTE valid encoding optional
      drm/i915: Disable GGTT PTEs on GEN6+ suspend

Bian Yu (1):
      md: avoid deadlock when md_set_badblocks.

Brennan Shacklett (1):
      intel_pstate: Improve accuracy by not truncating until final result

Bruno Randolf (1):
      cfg80211: fix warning when using WEXT for IBSS

Chad Dupuis (1):
      [SCSI] qla2xxx: Fix request queue null dereference.

Chris Wilson (2):
      drm: Prevent overwriting from userspace underallocating core ioctl structs
      drm: Pad drm_mode_get_connector to 64-bit boundary

Christian König (2):
      drm/radeon: stop the leaks in cik_ib_test
      drm/radeon/uvd: revert lower msg&fb buffer requirements on UVD3

Christophe Gouault (1):
      vti: get rid of nf mark rule in prerouting

Chun-Yeow Yeoh (1):
      mac80211: fix the setting of extended supported rate IE

Claudiu Manoil (3):
      gianfar: Enable eTSEC-A002 erratum w/a for all parts
      gianfar: Use mpc85xx support for errata detection
      gianfar: Enable eTSEC-20 erratum w/a for P2020 Rev1

Colin Ian King (1):
      eCryptfs: fix 32 bit corruption issue

Dan Carpenter (5):
      [media] sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
      [media] mx3-camera: locking cleanup in mx3_videobuf_queue()
      net: heap overflow in __audit_sockaddr()
      yam: integer underflow in yam_ioctl()
      yam: remove a no-op in yam_ioctl()

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Dave Jiang (1):
      MAINTAINERS: add to ioatdma maintainer list

Dave Kleikamp (1):
      jfs: fix error path in ialloc

David Herrmann (1):
      HID: wiimote: add LEGO-wiimote VID

David S. Miller (1):
      l2tp: Fix build warning with ipv6 disabled.

David Vrabel (1):
      xen-netback: transition to CLOSED when removing a VIF

David Woodhouse (1):
      mtd: gpmi: fix ECC regression

Dirk Brandewie (1):
      intel_pstate: Correct calculation of min pstate value

Dmitry Kravkov (2):
      bnx2x: Fix Coalescing configuration
      bnx2x: Don't pretend during register dump

Eduardo Valentin (1):
      drivers: thermal: allow ti-soc-thermal run without pcb zone

Edward Cree (3):
      sfc: Fix internal indices of ethtool stats for EF10
      sfc: Refactor EF10 stat mask code to allow for more conditional stats
      sfc: Add PM and RXDP drop counters to ethtool stats

Emmanuel Grumbach (6):
      iwlwifi: pcie: don't reset the TX queue counter
      iwlwifi: don't WARN on host commands sent when firmware is dead
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
      iwlwifi: mvm: call ieee80211_scan_completed when needed
      mac80211: correctly close cancelled scans
      cfg80211: don't add p2p device while in RFKILL

Enrico Mioso (1):
      net: qmi_wwan: Olivetti Olicard 200 support

Eric Dumazet (8):
      net: do not call sock_put() on TIMEWAIT sockets
      tcp: do not forget FIN in tcp_shifted_skb()
      pkt_sched: fq: fix typo for initial_quantum
      pkt_sched: fq: fix non TCP flows pacing
      l2tp: must disable bh before calling l2tp_xmit_skb()
      bnx2x: record rx queue for LRO packets
      tcp: must unclone packets before mangling them
      tcp: remove the sk_can_gso() check from tcp_set_skb_tso_segs()

Eric W. Biederman (1):
      net: Update the sysctl permissions handler to test effective uid/gid

Ezequiel Garcia (1):
      mtd: nand: pxa3xx: Fix registered MTD name

Fabio Estevam (1):
      net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET
are not selected

Fan Du (2):
      xfrm: Guard IPsec anti replay window against replay bitmap
      sctp: Use software crc32 checksum when xfrm transform will happen.

Felix Fietkau (5):
      mac80211: drop spoofed packets in ad-hoc mode
      mac80211: use sta_info_get_bss() for nl80211 tx and client probing
      mac80211: update sta->last_rx on acked tx frames
      ath9k: fix powersave response handling for BA session packets
      ath9k: fix tx queue scheduling after channel changes

Fengguang Wu (1):
      [media] msi3101: msi3101_ioctl_ops can be static

François Cachereul (1):
      l2tp: fix kernel panic when using IPv4-mapped IPv6 addresses

Freddy Xin (2):
      ax88179_178a: Correct the RX error definition in RX header
      ax88179_178a: Add VID:DID for Samsung USB Ethernet Adapter

Geyslan G. Bem (1):
      ecryptfs: Fix memory leakage in keystore.c

Gianluca Gennari (4):
      [media] adv7842: fix compilation with GCC < 4.4.6
      [media] adv7511: fix compilation with GCC < 4.4.6
      [media] ad9389b: fix compilation with GCC < 4.4.6
      [media] ths8200: fix compilation with GCC < 4.4.6

Gregor Jasny (1):
      [media] Add HCL T12Rg-H to STK webcam upside-down table

Gu Zheng (1):
      seq_file: always update file->f_pos in seq_lseek()

Guenter Roeck (1):
      ASoC: fsl_ssi: Fix irq_of_parse_and_map() return value check

Gwendal Grignou (1):
      libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Hannes Frederic Sowa (1):
      ipv6: probe routes asynchronous in rt6_probe

Heiko Carstens (2):
      s390/compat,signal: fix return value of copy_siginfo_(to|from)_user32()
      s390/vmlogrdr: fix array access in vmlogrdr_open()

Heiko Stuebner (1):
      MAINTAINERS: Add maintainers entry for Rockchip SoCs

Helge Deller (3):
      Revert "parisc: Export flush_cache_page() (needed by lustre)"
      parisc: enable DEVTMPFS, DEVTMPFS_MOUNT and BLK_DEV_INITRD in defconfigs
      parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

Himanshu Madhani (1):
      qlcnic: Validate Tx queue only for 82xx adapters.

Jacek Anaszewski (1):
      [media] s5p-jpeg: Initialize vfd_decoder->vfl_dir field

Jarkko Nikula (1):
      ASoC: omap: Fix incorrect ARM dependency

Jason Cooper (1):
      MAINTAINERS: ARM: mvebu: add Sebastian Hesselbarth

Jason Wang (2):
      virtio-net: don't respond to cpu hotplug notifier if we're not ready
      virtio-net: refill only when device is up during setting queues

Jesse Barnes (1):
      drm/i915: disable LVDS clock gating on CPT v2

Jingoo Han (2):
      ahci: use dev_info() instead of printk()
      ahci_platform: use dev_info() instead of printk()

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Jiri Pirko (3):
      udp6: respect IPV6_DONTFRAG sockopt in case there are pending frames
      ip6_output: do skb ufo init for peeked non ufo skb as well
      ip_output: do skb ufo init for peeked non ufo skb as well

Johannes Berg (4):
      cfg80211: fix sysfs registration race
      iwlwifi: pcie: fix merge damage
      wireless: radiotap: fix parsing buffer overrun
      mac80211: fix crash if bitrate calculation goes wrong

Jon Cooper (1):
      sfc: Add rmb() between reading stats and generation count to
ensure consistency

Joseph Salisbury (1):
      [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor

Jouni Malinen (1):
      mac80211: Run deferred scan if last roc_list item is not started

Julian Anastasov (3):
      ipv6: always prefer rt6i_gateway if present
      ipv6: fill rt6i_gateway with nexthop address
      netfilter: nf_conntrack: fix rt6i_gateway checks for H.323 helper

Kent Overstreet (1):
      bcache: Fixed incorrect order of arguments to bio_alloc_bioset()

Khalid Aziz (1):
      [SCSI] BusLogic: Fix an oops when intializing multimaster adapter

Kuninori Morimoto (1):
      ASoC: rcar: fixup generation checker

Laurent Pinchart (1):
      [media] uvcvideo: quirk PROBE_DEF for Microsoft Lifecam NX-3000

Linus Lüssing (1):
      Revert "bridge: only expire the mdb entry when query is received"

Linus Torvalds (1):
      Linux 3.12-rc7

Linus Walleij (1):
      ARM: integrator: deactivate timer0 on the Integrator/CP

Luciano Coelho (1):
      cfg80211: use the correct macro to check for active monitor support

Lukasz Dorau (2):
      libahci: fix turning on LEDs in ahci_start_port()
      md: Fix skipping recovery for read-only arrays.

Lukasz Majewski (3):
      thermal: exynos: Remove check for thermal device pointer at
exynos_report_trigger()
      thermal: exynos: Provide separate TMU data for Exynos4412
      thermal: exynos: Provide initial setting for TMU's test MUX
address at Exynos4412

Marc Kleine-Budde (5):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()
      can: flexcan: flexcan_chip_start: fix regression, mark one MB
for TX and abort pending TX
      can: flexcan: fix mx28 detection by rearanging OF match table
      can: at91-can: fix device to driver data mapping for platform devices

Marek Szyprowski (1):
      [media] videobuf2-dc: Fix support for mappings without struct
page in userptr mode

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mark Brown (1):
      ALSA: Add MAINTAINERS entry for dmaengine helpers

Mark Cave-Ayland (1):
      rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Markus Pargmann (3):
      net: ethernet: cpsw: Search childs for slave nodes
      net/ethernet: cpsw: DT read bool dual_emac
      net/ethernet: cpsw: Bugfix interrupts before enabling napi

Martin Schwidefsky (2):
      s390/mm,kvm: fix software dirty bits vs. kvm for old machines
      s390/time: correct use of store clock fast

Masami Hiramatsu (1):
      perf probe: Fix to initialize fname always before use it

Mathias Krause (5):
      proc connector: fix info leaks
      connector: use nlmsg_len() to check message length
      connector: use 'size' everywhere in cn_netlink_send()
      connector - documentation: simplify netlink message length assignment
      unix_diag: fix info leak

Matthew Slattery (1):
      sfc: Add definitions for new stats counters and capability flag

Matthias Schiffer (1):
      batman-adv: set up network coding packet handlers during module init

Matti Gottlieb (1):
      iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series

Mattia Dongili (1):
      sony-laptop: don't change keyboard backlight settings

Merav Sicron (1):
      bnx2x: Set NETIF_F_HIGHDMA unconditionally

Michael Abbott (1):
      dm9000: Implement full reset of DM9000 network device

Michael S. Tsirkin (2):
      netif_set_xps_queue: make cpu mask const
      tun: don't look at current when non-blocking

Mugunthan V N (1):
      drivers: net: cpsw: fix kernel warn during iperf test with
interrupt pacing

Neal Cardwell (1):
      tcp: initialize passive-side sk_pacing_rate after 3WHS

Nguyen Hong Ky (1):
      net: sh_eth: Fix RX packets errors on R8A7740

Nicholas Bellinger (7):
      target: Make target_do_xcopy failures return INVALID_PARAMETER_LIST
      target: Allow non zero ListID in EXTENDED_COPY parameter list
      target: Reject EXTENDED_COPY when emulate_3pc is disabled
      target: Add missing XCOPY I/O operation sense_buffer
      target: Generate failure for XCOPY I/O with non-zero scsi_status
      target: Fail XCOPY for non matching source + destination block_size
      vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter

Nikita Kiryanov (3):
      dm9000: during init reset phy only for dm9000b
      dm9000: take phy out of reset during init
      dm9000: report the correct LPA

Nikolai Kondrashov (1):
      HID: Fix unit exponent parsing again

Ondrej Zary (1):
      pata_isapnp: Don't use invalid I/O ports

Oussama Ghorbel (3):
      ipv6: Allow the MTU of ipip6 tunnel to be set below 1280
      ipv6: Fix the upper MTU limit in GRE tunnel
      ipv6: Initialize ip6_tnl.hlen in gre tunnel even if no route is found

Peter Ujfalusi (1):
      ASoC: tlv320aic3x: Connect 'Left Line1R Mux' and 'Right Line1L Mux'

Philippe Rétornaz (2):
      ASoC: fsl: Fix sound on mx31moboard
      ASoC: fsl: imx-ssi: fix probe on imx31

Rafael J. Wysocki (1):
      acpi-cpufreq: Fail initialization if driver cannot be registered

Randy Dunlap (3):
      fs/namei.c: fix new kernel-doc warning
      vfs: fix new kernel-doc warnings
      platform/x86: fix asus-wmi build error

Rob Herring (3):
      net: calxedaxgmac: fix clearing of old filter addresses
      net: calxedaxgmac: add uc and mc filter addresses in promiscuous mode
      net: calxedaxgmac: determine number of address filters at runtime

Roland Dreier (2):
      target: Fix assignment of LUN in tracepoints
      target: Return an error for WRITE SAME with ANCHOR==1

Russ Dill (1):
      PM / hibernate: Move software_resume to late_initcall_sync

Salva Peiró (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sebastian Hesselbarth (3):
      net: mv643xx_eth: update statistics timer from timer context only
      net: mv643xx_eth: fix orphaned statistics timer crash
      net: mv643xx_eth: fix missing device_node for port devices

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Shaohua Li (2):
      raid5: set bio bi_vcnt 0 for discard request
      raid5: avoid finding "discard" stripe

Simon Farnsworth (1):
      [media] saa7134: Fix crash when device is closed before streamoff

Simon Horman (1):
      net: sh_eth: Correct fix for RX packet errors on R8A7740

Solomon Peachy (1):
      wireless: cw1200: acquire hwbus lock around cw1200_irq_handler() call.

Srinivas Pandruvada (1):
      Thermal: x86_pkg_temp: change spin lock

Stanislaw Gruszka (1):
      Revert "rt2x00pci: Use PCI MSIs whenever possible"

Stefan Haberland (1):
      s390/dasd: check for availability of prefix command during format

Steffen Klassert (5):
      xfrm: Fix replay size checking on async events
      xfrm: Decode sessions with output interface.
      ipsec: Don't update the pmtu on ICMPV6_DEST_UNREACH
      xfrm: Add refcount handling to queued policies
      xfrm: check for a vaild skb in xfrm_policy_queue_process

Stephane Eranian (1):
      perf: Disable PERF_RECORD_MMAP2 support

Stephen Warren (1):
      MAINTAINERS: Tegra updates, and driver ownership

Sylwester Nawrocki (1):
      [media] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'

Tejun Heo (1):
      cgroup: fix cgroup post-order descendant walk of empty subtree

Tetsuo Handa (1):
      mutex: Avoid gcc version dependent __builtin_constant_p() usage

Thomas Egerer (1):
      xfrm: Fix aevent generation for each received packet

Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion

Thomas Hellstrom (2):
      drm/vmwgfx: Don't put resources with invalid id's on lru list
      drm/vmwgfx: Don't kill clients on VT switch

Toshiaki Makita (4):
      bridge: Don't use VID 0 and 4095 in vlan filtering
      bridge: Apply the PVID to priority-tagged frames
      bridge: Fix the way the PVID is referenced
      bridge: Fix updating FDB entries when the PVID is applied

Valentin Ilie (1):
      dma: edma: Fix memory leak

Vasundhara Volam (1):
      be2net: pass if_id for v1 and V2 versions of TX_CREATE cmd

Vinod Koul (2):
      MAINTAINERS: add the new dmaengine mailing list
      dmaengine: edma: fix another memory leak

Vlad Yasevich (4):
      bridge: update mdb expiration timer upon reports.
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.
      bridge: Correctly clamp MAX forward_delay when enabling STP

Vu Pham (1):
      iser-target: check device before dereferencing its variable

Wei Yongjun (5):
      moxa: fix the error handling in moxart_mac_probe()
      qlcnic: add missing destroy_workqueue() on error path in qlcnic_probe()
      [media] adv7511: fix error return code in adv7511_probe()
      usbnet: fix error return code in usbnet_probe()
      target/pscsi: fix return value check

Will Deacon (1):
      net: smc91x: dont't use SMC_outw for fixing up halfword-aligned data

Yann Droneaud (1):
      IB/core: Temporarily disable create_flow/destroy_flow uverbs

Yuchung Cheng (1):
      tcp: fix incorrect ca_state in tail loss probe

Yuval Mintz (3):
      bnx2x: Fix Maximum CoS estimation for VFs
      bnx2x: Prevent an illegal pointer dereference during panic
      bnx2x: Prevent null pointer dereference on error flow

Zhang Rui (1):
      Revert "drivers: thermal: parent virtual hwmon with thermal zone"

stephen hemminger (3):
      tc: export tc_defact.h to userspace
      netem: update backlog after drop
      netem: free skb's in tree on reset
