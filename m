Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3JUIuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39252 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876Ab3JUIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:10 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Mon, 21 Oct 2013 09:46:27 +0100
Message-ID: <lsq.1382345187.199780875@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/149] 3.2.52-rc1 review
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.52 release.
There are 149 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Oct 25 08:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.51 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (4):
      USB: OHCI: Allow runtime PM without system sleep
         [69820e01aa756b8d228143d997f71523c1e97984]
      USB: fix PM config symbol in uhci-hcd, ehci-hcd, and xhci-hcd
         [f875fdbf344b9fde207f66b392c40845dd7e5aa6]
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
         [9d8924297cd9c256c23c02abae40202563452453]
      [SCSI] sd: Fix potential out-of-bounds access
         [984f1733fcee3fbc78d47e26c5096921c5d9946a]

Alex Deucher (8):
      drm/edid: add quirk for Medion MD30217PG
         [118bdbd86b39dbb843155054021d2c59058f1e05]
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (v2)
         [91f3a6aaf280294b07c05dfe606e6c27b7ba3c72]
      drm/radeon: disable tests/benchmarks if accel is disabled
         [4a1132a023eb48cf10522d84c5908d43b612c041]
      drm/radeon: fix LCD record parsing
         [95663948ba22a4be8b99acd67fbf83e86ddffba4]
      drm/radeon: fix handling of variable sized arrays for router objects
         [fb93df1c2d8b3b1fb16d6ee9e32554e0c038815d]
      drm/radeon: fix panel scaling with eDP and LVDS bridges
         [855f5f1d882a34e4e9dd27b299737cd3508a5624]
      drm/radeon: fix resume on some rs4xx boards (v2)
         [acf88deb8ddbb73acd1c3fa32fde51af9153227f]
      drm/radeon: update line buffer allocation for dce4.1/5
         [0b31e02363b0db4e7931561bc6c141436e729d9f]

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing
         [3269ee0bd6686baf86630300d528500ac5b516d7]

Alexey Khoroshilov (1):
      [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
         [2e923a0527ac439e135b9961e58d3acd876bba10]

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification
         [d331a415aef98717393dda0be69b7947da08eba3]

Andi Kleen (1):
      perf tools: Handle JITed code in shared memory
         [89365e6c9ad4c0e090e4c6a4b67a3ce319381d89]

Ansis Atteka (1):
      ip: generate unique IP identificator if local  fragmentation is allowed
         [703133de331a7a7df47f31fb9de51dc6f68a9de8]

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA
         [18e391862cceaf43ddb8eb5cca05e1a83abdebaa]

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx
         [230aef7a6a23b6166bd4003bfff5af23c9bd381f]

Ben Hutchings (3):
      Revert "sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()"
         [not upstream; this only caused a regression for <3.7]
      Revert "zram: use zram->lock to protect zram_free_page() in swap free notify path"
         [not upstream; bug was fixed by a much larger change upstream]
      sfc: Fix efx_rx_buf_offset() for recycled pages
         [not upstream; bug was fixed by a much larger change upstream]

Benjamin Tissoires (1):
      HID: validate feature and input report details
         [cc6b54aa54bf40b762cab45a9fc8aa81653146eb]

Chen Gang (1):
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026
         [5676005acf26ab7e924a8438ea4746e47d405762]

Chris Healy (1):
      resubmit bridge: fix message_age_timer calculation
         [9a0620133ccce9dd35c00a96405c8d80938c2cc0]

Christian Lamparter (1):
      p54usb: add USB ID for Corega WLUSB2GTST USB adapter
         [1e43692cdb7cc445d6347d8a5207d9cef0c71434]

Claudiu Manoil (1):
      gianfar: Change default HW Tx queue scheduling mode
         [b98b8babd6e3370fadb7c6eaacb00eb2f6344a6c]

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones
         [6c9a27f5da9609fca46cb2b183724531b48f71ad]

Dan Carpenter (7):
      ASoC: 88pm860x: array overflow in snd_soc_put_volsw_2r_st()
         [d967967e8d1116fb38bad25e58714b5dddd03cca]
      ASoC: max98095: a couple array underflows
         [f8d7b13e14357ed19d2ca2799539600418dc3939]
      USB: mos7720: use GFP_ATOMIC under spinlock
         [d0bd9a41186e076ea543c397ad8a67a6cf604b55]
      cciss: fix info leak in cciss_ioctl32_passthru()
         [58f09e00ae095e46ef9edfcf3a5fd9ccdfad065e]
      cpqarray: fix info leak in ida_locked_ioctl()
         [627aad1c01da6f881e7f98d71fd928ca0c316b1a]
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
         [2c4283ca7cdcc6605859c836fc536fcd83a4525f]
      tun: signedness bug in tun_get_user()
         [15718ea0d844e4816dbd95d57a8a0e3e264ba90e]

Daniel Borkmann (3):
      net: bridge: convert MLDv2 Query MRC into  msecs_to_jiffies for max_delay
         [2d98c29b6fb3de44d9eaa73c09f9cf7209346383]
      net: sctp: fix ipv6 ipsec encryption bug in  sctp_v6_xmit
         [95ee62083cb6453e056562d91f597552021e6ae7]
      net: sctp: fix smatch warning in  sctp_send_asconf_del_ip
         [88362ad8f9a6cea787420b57cc27ccacef000dbe]

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing
         [f375fc520d4df0cd9fcb570f33c103c6c0311f9e]

Daniel Santos (1):
      kernel-doc: bugfix - multi-line macros
         [654784284430bf2739985914b65e09c7c35a7273]

Dave Jones (1):
      caif: Add missing braces to multiline if in  cfctrl_linkup_request
         [0c1db731bfcf3a9fd6c58132134f8b0f423552f0]

David Cohen (1):
      usb: dwc3: add support for Merrifield
         [85601f8cf67c56a561a6dd5e130e65fdc179047d]

David Rientjes (1):
      mm, show_mem: suppress page counts in non-blockable contexts
         [4b59e6c4730978679b414a8da61514a2518da512]

David S. Miller (2):
      esp_scsi: Fix tag state corruption when autosensing.
         [21af8107f27878813d0364733c0b08813c2c192a]
      sparc64: Fix off by one in trampoline TLB mapping  installation loop.
         [63d499662aeec1864ec36d042aca8184ea6a938e]

Eric Dumazet (4):
      fib_trie: remove potential out of bound access
         [aab515d7c32a34300312416c50314e755ea6f765]
      inetpeer: fix a race in inetpeer_gc_worker()
         [55432d2b543a4b6dfae54f5c432a566877a85d90]
      tcp: cubic: fix bug in bictcp_acked()
         [cd6b423afd3c08b27e1fed52db828ade0addbc6b]
      tcp: cubic: fix overflow error in bictcp_update()
         [2ed0edf9090bf4afa2c6fc4f38575a85a80d4b20]

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules
         [0092820407901a0b2c4e343e85f96bb7abfcded1]

Felix Fietkau (3):
      ath9k: always clear ps filter bit on new assoc
         [026d5b07c03458f9c0ccd19c3850564a5409c325]
      ath9k: avoid accessing MRC registers on single-chain devices
         [a1c781bb20ac1e03280e420abd47a99eb8bbdd3b]
      ath9k: fix rx descriptor related race condition
         [e96542e55a2aacf4bdeccfe2f17b77c4895b4df2]

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation
         [526867c3ca0caa2e3e846cb993b0f961c33c2abb]

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening
         [0640332e073be9207f0784df43595c0c39716e42]

Greg Thelen (1):
      memcg: fix multiple large threshold notifications
         [2bff24a3707093c435ab3241c47dcdb5f16e432b]

Greg Ungerer (3):
      m68k: consolidate the vmlinux.lds linker scripts
         [40c1b9cfeedf79b909c961e0e00a13497e80bc82]
      m68k: use non-MMU linker script for ColdFire MMU builds
         [ed865e31a8273be200db9ddcdb6b844e48777abd]
      m68knommu: clean up linker script
         [f84f52a5c15db7d14a534815f27253b001735183]

Hannes Frederic Sowa (4):
      ipv6: don't stop backtracking in fib6_lookup_1 if  subtree does not match
         [3e3be275851bc6fc90bfdcd732cd95563acd982b]
      ipv6: drop packets with multiple fragmentation headers
         [f46078cfcd77fa5165bf849f5e568a7ac5fa569c]
      ipv6: remove max_addresses check from  ipv6_create_tempaddr
         [4b08a8f1bd8cb4541c93ec170027b4d0782dab52]
      ipv6: udp packets following an UFO enqueued packet  need also be handled by UFO
         [2811ebac2521ceac84f2bdae402455baa6a7fb47]

Hans Verkuil (1):
      [media] hdpvr: register the video node at the end of probe
         [280847b532433ffe7a22795f926327805a127162]

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by the device
         [b4f17a488ae2e09bfcf95c0e0b4219c246f1116a]

Heikki Krogerus (1):
      usb: dwc3: pci: add support for BayTrail
         [b62cd96de3161dfb125a769030eec35a4cab3d3a]

Henrik Rydberg (2):
      hwmon: (applesmc) Check key count before proceeding
         [5f4513864304672e6ea9eac60583eeac32e679f2]
      hwmon: (applesmc) Silence uninitialized warnings
         [0fc86eca1b338d06ec500b34ef7def79c32b602b]

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup
         [77dbd7a95e4a4f15264c333a9e9ab97ee27dc2aa]

Ian Abbott (1):
      staging: comedi: ni_65xx: (bug fix) confine insn_bits to one subdevice
         [677a31565692d596ef42ea589b53ba289abf4713]

Jan Kara (1):
      isofs: Refuse RW mount of the filesystem instead of making it RO
         [17b7f7cf58926844e1dd40f5eb5348d481deca6a]

Jani Nikula (2):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER
         [8d16f258217f2f583af1fd57c5144aa4bbe73e48]
      drm/i915: try not to lose backlight CBLV precision
         [cac6a5ae0118832936eb162ec4cedb30f2422bcc]

Jason Wang (1):
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
         [ece793fcfc417b3925844be88a6a6dc82ae8f7c6]

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP
         [28e8be31803b19d0d8f76216cb11b480b8a98bec]

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as  EACCES, not EPROTO
         [61e76b178dbe7145e8d6afa84bb4ccea71918994]

Jiri Kosina (1):
      HID: hidraw: put old deallocation mechanism in place
         [df0cfd6990347c20ae031f3f34137cba274f1972]

Johan Hovold (3):
      USB: mos7720: fix big-endian control requests
         [3b716caf190ccc6f2a09387210e0e6a26c1d81a4]
      serial: pch_uart: fix tty-kref leak in dma-rx path
         [19b85cfb190eb9980eaf416bff96aef4159a430e]
      serial: pch_uart: fix tty-kref leak in rx-error path
         [fc0919c68cb2f75bb1af759315f9d7e2a9443c28]

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386
         [700870119f49084da004ab588ea2b799689efaf7]

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnected
         [481f2d4f89f87a0baa26147f323380e31cfa7c44]

Kees Cook (9):
      HID: LG: validate HID output report details
         [0fb6bd06e06792469acc15bbe427361b56ada528]
      HID: check for NULL field when setting values
         [be67b68d52fa28b9b721c47bb42068f0c1214855]
      HID: logitech-dj: validate output report details
         [297502abb32e225fb23801fcdb0e4f6f8e17099a]
      HID: ntrig: validate feature report details
         [875b4e3763dbc941f15143dd1a18d10bb0be303b]
      HID: pantherlord: validate output report details
         [412f30105ec6735224535791eed5cdc02888ecb4]
      HID: picolcd_core: validate output report details
         [1e87a2456b0227ca4ab881e19a11bb99d164e792]
      HID: provide a helper for validating hid reports
         [331415ff16a12147d57d5c953f3a961b7ede348b]
      HID: validate HID report id size
         [43622021d2e2b82ea03d883926605bdd0525e1d1]
      HID: zeroplus: validate output report details
         [78214e81a1bf43740ce89bb5efda78eac2f8ef83]

Kirill Tkhai (4):
      sparc32: Fix exit flag passed from traced sys_sigreturn
         [7a3b0f89e3fea680f93932691ca41a68eee7ab5e]
      sparc64: Fix ITLB handler of null page
         [1c2696cdaad84580545a2e9c0879ff597880b1a9]
      sparc64: Fix not SRA'ed %o5 in 32-bit traced syscall
         [ab2abda6377723e0d5fbbfe5f5aa16a5523344d1]
      sparc64: Remove RWSEM export leftovers
         [61d9b9355b0d427bd1e732bd54628ff9103e496f]

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit
         [831abf76643555a99b80a3b54adfa7e4fa0a3259]

Lan Tianyu (1):
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT
         [524f42fab787a9510be826ce3d736b56d454ac6d]

Larry Finger (1):
      rtlwifi: Align private space in rtl_priv struct
         [60ce314d1750fef843e9db70050e09e49f838b69]

Li Zefan (1):
      cgroup: fail if monitored file and event_control are in different cgroup
         [f169007b2773f285e098cb84c74aac0154d65ff7]

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference
         [a8f531ebc33052642b4bd7b812eedf397108ce64]

Lino Sanfilippo (1):
      fanotify: dont merge permission events
         [03a1cec1f17ac1a6041996b3e40f96b5a2f90e1b]

Lv Zheng (1):
      ACPI / IPMI: Fix atomic context requirement of ipmi_msg_handler()
         [06a8566bcf5cf7db9843a82cde7a33c7bf3947d9]

Madhavan Srinivasan (1):
      powerpc/sysfs: Disable writing to PURR in guest mode
         [d1211af3049f4c9c1d8d4eb8f8098cc4f4f0d0c7]

Majianpeng (1):
      libceph: unregister request in __map_request failed and nofail == false
         [73d9f7eef3d98c3920e144797cc1894c6b005a1e]

Malcolm Priestley (1):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.
         [e3eb270fab7734427dd8171a93e4946fe28674bc]

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect
         [212a871a3934beccf43431608c27ed2e05a476ec]

Marc Kleine-Budde (1):
      can: flexcan: fix flexcan_chip_start() on imx6
         [0d1862ea1a5bb876cf05555a7307080cb75bf379]

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically
         [4f0acd31c31f03ba42494c8baf6c0465150e2621]

Maxim Patlasov (2):
      fuse: hotfix truncate_pagecache() issue
         [06a7c3c2781409af95000c60a5df743fd4e2f8b4]
      fuse: postpone end_page_writeback() in fuse_writepage_locked()
         [4a4ac4eba1010ef9a804569058ab29e3450c0315]

Michal Malý (1):
      USB: serial: option: Ignore card reader interface on Huawei E1750
         [eb2addd4044b4b2ce77693bde5bc810536dd96ee]

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes
         [85fa532b6ef920b32598df86b194571a7059a77c]

Miklos Szeredi (1):
      fuse: readdir: check for slash in names
         [efeb9e60d48f7778fdcad4a0f3ad9ea9b19e5dfd]

Mikulas Patocka (1):
      dm-snapshot: fix performance degradation due to small hash size
         [60e356f381954d79088d0455e357db48cfdd6857]

Neil Horman (2):
      8139cp: Add dma_mapping_error checking
         [cf3c4c03060b688cbc389ebc5065ebcce5653e96,
          d06f5187469eee1b2932c02fd093d113cfc60d5e]
      bonding: Fix broken promiscuity reference counting  issue
         [5a0068deb611109c5ba77358be533f763f395ee4]

Nikolay Aleksandrov (1):
      netpoll: fix NULL pointer dereference in  netpoll_cleanup
         [d0fe8c888b1fd1a2f84b9962cabcb98a70988aec]

Nishanth Aravamudan (1):
      powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()
         [1cf389df090194a0976dc867b7fffe99d9d490cb]

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
         [776164c1faac4966ab14418bb0922e1820da1d19]

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet
         [6dd433e6cf2475ce8abec1b467720858c24450eb]

Paul E. McKenney (2):
      powerpc: Fix parameter clobber in csum_partial_copy_generic()
         [d9813c3681a36774b254c0cdc9cce53c9e22c756]
      powerpc: Restore registers on error exit from csum_partial_copy_generic()
         [8f21bd0090052e740944f9397e2be5ac7957ded7]

Peng Chen (1):
      Bluetooth: Add a new PID/VID 0cf3/e005 for AR3012.
         [0a3658cccdf5326ea508efeb1879b0e2508bb0c3]

Peter Korsgaard (1):
      dm9601: fix IFF_ALLMULTI handling
         [bf0ea6380724beb64f27a722dfc4b0edabff816e]

Peter Maydell (1):
      ARM: PCI: versatile: Fix SMAP register offsets
         [99f2b130370b904ca5300079243fdbcafa2c708b]

Peter Zijlstra (2):
      perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::unique_pmu
         [3f1f33206c16c7b3839d71372bc2ac3f305aa802]
      perf: Fix perf_cgroup_switch for sw-events
         [95cf59ea72331d0093010543b8951bb43f262cac]

Raphael Kubo da Costa (1):
      Bluetooth: Add support for BCM20702A0 [0b05, 17cb]
         [38a172bef8c93ecbfd69715fd88396988e4073fd]

Ricardo Ribalda (1):
      ll_temac: Reset dma descriptors indexes on ndo_open
         [7167cf0e8cd10287b7912b9ffcccd9616f382922]

Roger Luethi (1):
      via-rhine: fix VLAN priority field (PCP, IEEE 802.1p)
         [207070f5221e2a901d56a49df9cde47d9b716cd7]

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks
         [5f338d9001094a56cf87bd8a280b4e7ff953bb59]

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values
         [5f671d6b4ec3e6d66c2a868738af2cdea09e7509]

Salam Noureddine (2):
      ipv4 igmp: use in_dev_put in timer handlers instead of  __in_dev_put
         [e2401654dd0f5f3fb7a8d80dad9554d73d7ca394]
      ipv6 mcast: use in6_dev_put in timer handlers instead  of __in6_dev_put
         [9260d3e1013701aa814d10c8fc6a9f92bd17d643]

Salman Qazi (1):
      perf: Use css_tryget() to avoid propping up css refcount
         [9c5da09d266ca9b32eb16cf940f8161d949c2fe5]

Sasha Levin (1):
      [SCSI] iscsi: don't hang in endless loop if no targets present
         [46a7c17d26967922092f3a8291815ffb20f6cabe]

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI
         [f936f9b67b7f8c2eae01dd303a0e90bd777c4679]

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers
         [c8476fb855434c733099079063990e5bfa7ecad6]

Stanislaw Gruszka (1):
      rt2800: fix wrong TX power compensation
         [6e956da2027c767859128b9bfef085cf2a8e233b]

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices
         [06bb5219118fb098f4b0c7dcb484b28a52bf1c14]

Steffen Klassert (1):
      inetpeer: Invalidate the inetpeer tree along with the  routing cache
         [5faa5df1fa2024bd750089ff21dcc4191798263d]

Stephen Hemminger (1):
      htb: fix sign extension bug
         [cbd375567f7e4811b1c721f75ec519828ac6583f]

Takashi Iwai (1):
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist
         [83f72151352791836a1b9c1542614cc9bf71ac61]

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()
         [c34ac00caefbe49d40058ae7200bd58725cebb45]

Theodore Ts'o (1):
      ext4: avoid hang when mounting non-journal filesystems  with orphan list
         [0e9a9a1ad619e7e987815d20262d36a2f95717ca]

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour  discovery messages
         [25a6e6b84fba601eff7c28d30da8ad7cfbef0d43]

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen
         [9e0bf92c223dabe0789714f8f85f6e26f8f9cda4]

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments for dirty blocks
         [7f42ec3941560f0902fe3671e36f2c20ffd3af0a]

Ying Xue (1):
      tipc: fix lockdep warning during bearer initialization
         [4225a398c1352a7a5c14dc07277cb5cc4473983b]

 Makefile                                    |   4 +-
 arch/arm/mach-versatile/pci.c               |   6 +-
 arch/arm/mm/init.c                          |   3 +
 arch/ia64/mm/contig.c                       |   2 +
 arch/ia64/mm/discontig.c                    |   2 +
 arch/m68k/kernel/vmlinux.lds.S              |  15 ++-
 arch/m68k/kernel/vmlinux.lds_mm.S           |  10 --
 arch/m68k/kernel/vmlinux.lds_no.S           | 187 ----------------------------
 arch/parisc/mm/init.c                       |   2 +
 arch/powerpc/kernel/align.c                 |  10 ++
 arch/powerpc/kernel/iommu.c                 |   2 +-
 arch/powerpc/kernel/lparcfg.c               |   1 +
 arch/powerpc/kernel/sysfs.c                 |  18 ++-
 arch/powerpc/lib/checksum_64.S              |  58 ++++++---
 arch/sparc/kernel/entry.S                   |   2 +-
 arch/sparc/kernel/ktlb.S                    |   3 +-
 arch/sparc/kernel/syscalls.S                |   8 +-
 arch/sparc/kernel/trampoline_64.S           |   2 -
 arch/sparc/lib/ksyms.c                      |   9 --
 arch/unicore32/mm/init.c                    |   3 +
 arch/x86/kernel/reboot.c                    |  16 +++
 arch/x86/platform/efi/efi.c                 |  11 +-
 crypto/api.c                                |   7 +-
 drivers/acpi/acpi_ipmi.c                    |  24 ++--
 drivers/acpi/ec.c                           |   4 +
 drivers/block/cciss.c                       |   1 +
 drivers/block/cpqarray.c                    |   1 +
 drivers/bluetooth/ath3k.c                   |   2 +
 drivers/bluetooth/btusb.c                   |   2 +
 drivers/gpu/drm/drm_edid.c                  |   3 +
 drivers/gpu/drm/i915/intel_dp.c             |  13 +-
 drivers/gpu/drm/i915/intel_opregion.c       |   2 +-
 drivers/gpu/drm/radeon/atombios_encoders.c  |   8 +-
 drivers/gpu/drm/radeon/evergreen.c          |  25 +++-
 drivers/gpu/drm/radeon/evergreend.h         |   4 +
 drivers/gpu/drm/radeon/radeon_atombios.c    |  13 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |  34 ++++-
 drivers/gpu/drm/radeon/radeon_device.c      |  10 +-
 drivers/gpu/drm/radeon/rs400.c              |   9 +-
 drivers/hid/hid-core.c                      |  84 +++++++++++--
 drivers/hid/hid-ids.h                       |   1 +
 drivers/hid/hid-input.c                     |  11 +-
 drivers/hid/hid-lg2ff.c                     |  19 +--
 drivers/hid/hid-lg3ff.c                     |  29 +----
 drivers/hid/hid-lg4ff.c                     |  20 +--
 drivers/hid/hid-lgff.c                      |  17 +--
 drivers/hid/hid-logitech-dj.c               |   6 +
 drivers/hid/hid-ntrig.c                     |   3 +-
 drivers/hid/hid-picolcd.c                   |   2 +-
 drivers/hid/hid-pl.c                        |  10 +-
 drivers/hid/hid-speedlink.c                 |  11 +-
 drivers/hid/hid-zpff.c                      |  18 +--
 drivers/hid/hidraw.c                        |  51 ++++----
 drivers/hid/usbhid/hid-quirks.c             |   2 +
 drivers/hwmon/applesmc.c                    |  19 ++-
 drivers/iommu/intel-iommu.c                 |  72 ++++++-----
 drivers/md/dm-snap.c                        |   5 +-
 drivers/media/video/hdpvr/hdpvr-core.c      |  22 ++--
 drivers/mmc/host/tmio_mmc_dma.c             |   4 +-
 drivers/net/bonding/bond_main.c             |  13 +-
 drivers/net/can/flexcan.c                   |  12 --
 drivers/net/ethernet/freescale/gianfar.c    |  11 +-
 drivers/net/ethernet/freescale/gianfar.h    |  11 +-
 drivers/net/ethernet/realtek/8139cp.c       |  49 +++++++-
 drivers/net/ethernet/sfc/rx.c               |   3 +-
 drivers/net/ethernet/via/via-rhine.c        |   9 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c |   6 +
 drivers/net/macvtap.c                       |  62 +++++----
 drivers/net/ppp/pptp.c                      |   2 +-
 drivers/net/tun.c                           |   6 +-
 drivers/net/usb/cdc_ether.c                 |   5 +
 drivers/net/usb/dm9601.c                    |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   5 +-
 drivers/net/wireless/ath/ath9k/recv.c       |  17 ++-
 drivers/net/wireless/ath/ath9k/xmit.c       |   1 +
 drivers/net/wireless/p54/p54usb.c           |   1 +
 drivers/net/wireless/rt2x00/rt2800lib.c     |   7 ++
 drivers/net/wireless/rtlwifi/wifi.h         |   2 +-
 drivers/of/base.c                           |   1 +
 drivers/scsi/esp_scsi.c                     |  14 ++-
 drivers/scsi/esp_scsi.h                     |   1 +
 drivers/scsi/scsi_transport_iscsi.c         |   2 +-
 drivers/scsi/sd.c                           |  11 +-
 drivers/staging/comedi/drivers/dt282x.c     |   3 +-
 drivers/staging/comedi/drivers/ni_65xx.c    |  26 ++--
 drivers/staging/vt6656/main_usb.c           |   3 +-
 drivers/staging/zram/zram_drv.c             |   2 -
 drivers/staging/zram/zram_drv.h             |   5 +-
 drivers/tty/serial/pch_uart.c               |   5 +-
 drivers/usb/class/cdc-wdm.c                 |  13 +-
 drivers/usb/core/config.c                   |   3 +-
 drivers/usb/core/devio.c                    |  16 +++
 drivers/usb/core/hub.c                      |   5 +-
 drivers/usb/dwc3/dwc3-pci.c                 |   4 +
 drivers/usb/host/ehci-mxc.c                 |   2 +-
 drivers/usb/host/ehci-pci.c                 |   2 +-
 drivers/usb/host/ohci-pci.c                 |   2 +-
 drivers/usb/host/uhci-pci.c                 |   2 +-
 drivers/usb/host/xhci-pci.c                 |   2 +-
 drivers/usb/host/xhci-ring.c                |   8 +-
 drivers/usb/host/xhci.c                     |  22 ++++
 drivers/usb/serial/mos7720.c                |   6 +-
 drivers/usb/serial/option.c                 |   3 +
 drivers/xen/grant-table.c                   |  13 +-
 fs/debugfs/inode.c                          |  69 ++++------
 fs/ext4/namei.c                             |   3 +-
 fs/fuse/dir.c                               |  13 +-
 fs/fuse/file.c                              |  11 +-
 fs/fuse/fuse_i.h                            |   9 ++
 fs/fuse/inode.c                             |   4 +-
 fs/isofs/inode.c                            |  16 +--
 fs/nilfs2/page.c                            |   2 +
 fs/nilfs2/segment.c                         |  11 +-
 fs/notify/fanotify/fanotify.c               |   6 +
 fs/ocfs2/extent_map.c                       |   1 -
 include/linux/hid.h                         |   8 +-
 include/linux/icmpv6.h                      |   2 +
 include/linux/ipv6.h                        |   1 +
 include/linux/mm.h                          |   3 +-
 include/linux/perf_event.h                  |   2 +-
 include/linux/rculist.h                     |   5 +-
 include/linux/usb/hcd.h                     |   2 +-
 include/net/inetpeer.h                      |   6 +
 include/net/ip.h                            |  12 +-
 include/net/ipip.h                          |   2 +-
 kernel/cgroup.c                             |  11 ++
 kernel/events/core.c                        |  31 +++--
 kernel/sched_fair.c                         |  14 ++-
 lib/show_mem.c                              |   3 +
 mm/huge_memory.c                            |   2 +
 mm/memcontrol.c                             |   8 +-
 mm/page_alloc.c                             |   7 ++
 net/bridge/br_multicast.c                   |   3 +-
 net/bridge/br_stp.c                         |   2 +-
 net/caif/cfctrl.c                           |   3 +-
 net/ceph/osd_client.c                       |   2 +
 net/core/netpoll.c                          |   9 +-
 net/core/sysctl_net_core.c                  |   7 +-
 net/ipv4/fib_trie.c                         |   5 +-
 net/ipv4/igmp.c                             |   8 +-
 net/ipv4/inetpeer.c                         |  92 +++++++++++++-
 net/ipv4/ip_output.c                        |   6 +-
 net/ipv4/ipmr.c                             |   2 +-
 net/ipv4/raw.c                              |   2 +-
 net/ipv4/route.c                            |   1 +
 net/ipv4/tcp_cubic.c                        |  12 +-
 net/ipv4/xfrm4_mode_tunnel.c                |   2 +-
 net/ipv6/addrconf.c                         |  10 +-
 net/ipv6/icmp.c                             |  10 +-
 net/ipv6/ip6_fib.c                          |  16 ++-
 net/ipv6/ip6_output.c                       |  53 ++++----
 net/ipv6/mcast.c                            |   4 +-
 net/ipv6/ndisc.c                            |  16 +--
 net/ipv6/reassembly.c                       |   5 +
 net/netfilter/ipvs/ip_vs_xmit.c             |   2 +-
 net/sched/sch_htb.c                         |   2 +-
 net/sctp/ipv6.c                             |  42 ++-----
 net/sctp/sm_sideeffect.c                    |   3 +-
 net/sctp/socket.c                           |   3 +
 net/tipc/eth_media.c                        |  15 ++-
 scripts/kernel-doc                          |   3 +
 sound/pci/hda/hda_intel.c                   |   1 +
 sound/pci/hda/patch_hdmi.c                  |  11 ++
 sound/soc/codecs/88pm860x-codec.c           |   3 +
 sound/soc/codecs/max98095.c                 |   4 +-
 sound/soc/codecs/wm8960.c                   |   6 +-
 tools/perf/util/map.c                       |   1 +
 168 files changed, 1186 insertions(+), 790 deletions(-)

-- 
Ben Hutchings
All the simple programs have been written, and all the good names taken.

