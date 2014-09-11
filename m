Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaIKNAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51471 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.176537304@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/131] 3.2.63-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.63 release.
There are 131 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Sep 13 12:32:13 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.62 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe
         [608308682addfdc7b8e2aee88f0e028331d88e4d]

Alan Stern (1):
      USB: OHCI: don't lose track of EDs when a controller dies
         [977dcfdc60311e7aa571cabf6f39c36dde13339e]

Alex Deucher (1):
      drm/radeon: load the lm63 driver for an lm64 thermal chip.
         [5dc355325b648dc9b4cf3bea4d968de46fd59215]

Alex Williamson (1):
      iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains
         [c875d2c1b8083cd627ea0463e20bf22c2d7421ee]

Andi Kleen (1):
      slab/mempolicy: always use local policy from interrupt context
         [e7b691b085fda913830e5280ae6f724b2a63c824]

Andrey Ryabinin (1):
      net: sendmsg: fix NULL pointer dereference
         [40eea803c6b2cfaab092f053248cbeab3f368412]

Andrey Utkin (2):
      arch/sparc/math-emu/math_32.c: drop stray break  operator
         [093758e3daede29cb4ce6aedb111becf9d4bfc57]
      powerpc/mm/numa: Fix break placement
         [b00fc6ec1f24f9d7af9b8988b6a198186eb3408c]

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen
         [7209a75d2009dbf7745e2fd354abf25c3deb3ca3]

Aneesh Kumar K.V (2):
      powerpc/mm: Use read barrier when creating real_pte
         [85c1fafd7262e68ad821ee1808686b1392b1167d]
      powerpc: Fix build errors STRICT_MM_TYPECHECKS
         [83d5e64b7efa7f39b10ff5e92792e807a720289c]

Antti Palosaari (1):
      [media] tda10071: force modulation to QPSK on DVB-S
         [db4175ae2095634dbecd4c847da439f9c83e1b3b]

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset
         [4dc7c76cd500fa78c64adfda4b070b870a2b993c]

Axel Lin (6):
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
         [56de1377ad92f72ee4e5cb0faf7a9b6048fdf0bf]
      hwmon: (ads1015) Fix out-of-bounds array access
         [e981429557cbe10c780fab1c1a237cb832757652]
      hwmon: (amc6821) Fix possible race condition bug
         [cf44819c98db11163f58f08b822d626c7a8f5188]
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
         [2565fb05d1e9fc0831f7b1c083bcfcb1cba1f020]
      hwmon: (lm92) Prevent overflow problem when writing large limits
         [5b963089161b8fb244889c972edf553b9d737545]
      hwmon: (sis5595) Prevent overflow problem when writing large limits
         [cc336546ddca8c22de83720632431c16a5f9fe9a]

Ben Hutchings (1):
      bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address
         [03a6c3ff3282ee9fa893089304d951e0be93a144]

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown
         [5abfe85c1d4694d5d4bbd13ecc166262b937adf0]

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt  page tables
         [8762e5092828c4dc0f49da5a47a644c670df77f3]

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id
         [d77302739d900bbca5e901a3b7ac48c907ee6c93]

Christian Borntraeger (1):
      s390/locking: Reenable optimistic spinning
         [36e7fdaa1a04fcf65b864232e1af56a51c7814d6]

Christian König (1):
      drm/radeon: fix irq ring buffer overflow handling
         [e8c214d22e76dd0ead38f97f8d2dc09aac70d651]

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host
         [d45b3279a5a2252cafcd665bbf2db8c9b31ef783]

Christoph Paasch (2):
      tcp: Fix integer-overflow in TCP vegas
         [1f74e613ded11517db90b2bd57e9464d9e0fb161]
      tcp: Fix integer-overflows in TCP veno
         [45a07695bc64b3ab5d6d2215f9677e5b8c05a7d0]

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for non-PCI cards
         [cbace46a9710a480cae51e4611697df5de41713e]

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
         [5cdceab3d5e02eb69ea0f5d8fa9181800baf6f77]
      sunsab: Fix detection of BREAK on sunsab serial console
         [fe418231b195c205701c0cc550a03f6c9758fd9e]

Clemens Ladisch (1):
      ALSA: virtuoso: add Xonar Essence STX II support
         [f42bb22243d2ae264d721b055f836059fe35321f]

Dan Carpenter (1):
      netlabel: use GFP flags from caller instead of GFP_ATOMIC
         [64b5fad526f63e9b56752a7e8e153b99ec0ddecd]

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions
         [1be9a950c646c9092fb3618197f7b6bfb50e82aa]

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE
         [9301503af016eb537ccce76adec0c1bb5c84871e]

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches
         [b76fc285337b6b256e9ba20a40cfd043f70c27af]

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions
         [b104a35d32025ca740539db2808aa3385d0f30eb]

David S. Miller (8):
      sparc64: Add membar to Niagara2 memcpy code.
         [5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa]
      sparc64: Do not insert non-valid PTEs into the TSB hash  table.
         [18f38132528c3e603c66ea464727b29e9bbcb91b]
      sparc64: Don't bark so loudly about 32-bit tasks  generating 64-bit fault addresses.
         [e5c460f46ae7ee94831cb55cb980f942aa9e5a85]
      sparc64: Fix argument sign extension for  compat_sys_futex().
         [aa3449ee9c87d9b7660dd1493248abcc57769e31]
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III  cpus.
         [b18eb2d779240631a098626cb6841ee2dd34fda0]
      sparc64: Fix top-level fault handling bugs.
         [70ffc6ebaead783ac8dafb1e87df0039bb043596]
      sparc64: Guard against flushing openfirmware mappings.
         [4ca9a23765da3260058db3431faf5b4efd8cf926]
      sparc64: Handle 32-bit tasks properly in  compute_effective_address().
         [d037d16372bbe4d580342bebbb8826821ad9edf0]

David Vrabel (1):
      x86/xen: resume timer irqs early
         [8d5999df35314607c38fbd6bdd709e25c3a4eeab]

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
         [73f156a6e8c1074ac6327e0abd1169e95eb66463]
      ip: make IP identifiers less predictable
         [04ca6973f7c1a0d8537f2d9906a0cf8e69886d75]
      sctp: fix possible seqlock seadlock in  sctp_packet_transmit()
         [757efd32d5ce31f67193cc0e6a56e4dffcc42fb1]

Eric W. Biederman (1):
      mnt: Change the default remount atime from relatime to the existing value
         [ffbc6f0ead47fa5a1dc9642b0331cb75c20a640e]

Filipe Manana (1):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums
         [27b9a8122ff71a8cadfbffb9c4f0694300464f3b]

Florian Fainelli (1):
      MIPS: perf: Fix build error caused by unused counters_per_cpu_to_total()
         [6c37c9580409af7dc664bb6af0a85d540d63aeea]

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device
         [91fcb1ce420e0a5f8d92d556d7008a78bc6ce1eb]

Guenter Roeck (3):
      hwmon: (lm78) Fix overflow problems seen when writing large temperature limits
         [1074d683a51f1aded3562add9ef313e75d557327]
      hwmon: (lm85) Fix various errors on attribute writes
         [3248c3b771ddd9d31695da17ba350eb6e1b80a53]
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations
         [043572d5444116b9d9ad8ae763cf069e7accbc30]

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit  segments a runtime option"
         [7ed6fb9b5a5510e4ef78ab27419184741169978a]
      x86, espfix: Fix broken header guard
         [20b68535cd27183ebd3651ff313afb2b97dac941]
      x86, espfix: Make espfix64 a Kconfig option, fix UML
         [197725de65477bc8509b41388157c1a2283542bb]
      x86, espfix: Make it possible to disable 16-bit support
         [34273f41d57ee8d854dcd2a1d754cbb546cb548f]
      x86, espfix: Move espfix definitions into a separate  header file
         [e1fe9ed8d2a4937510d0d60e20705035c2609aea]
      x86-64, espfix: Don't leak bits 31:16 of %esp returning  to 16-bit stack
         [3891a04aafd668686239349ea58f3314ea2af86b]

Hans de Goede (2):
      [media] gspca_pac7302: Add new usb-id for Genius i-Look 317
         [242841d3d71191348f98310e2d2001e1001d8630]
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL
         [9a54886342e227433aebc9d374f8ae268a836475]

Huacai Chen (1):
      MIPS: tlbex: Fix a missing statement for HUGETLB
         [8393c524a25609a30129e4a8975cf3b91f6c16a5]

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk
         [2597fe99bb0259387111d0431691f5daac84f5a5]

James Bottomley (1):
      scsi: handle flush errors properly
         [89fb4cd1f717a871ef79fa7debbe840e3225cd54]

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response
         [6817ae225cd650fb1c3295d769298c38b1eba818]

Jan Kara (2):
      isofs: Fix unbounded recursion when processing relocated directories
         [410dd3cf4c9b36f27ed4542ee18b1af5e68645a4]
      reiserfs: Fix use after free in journal teardown
         [01777836c87081e4f68c4a43c9abe6114805f91e]

Jason Gunthorpe (1):
      tpm: Provide a generic means to override the chip returned timeouts
         [8e54caf407b98efa05409e1fee0e5381abd2b088]

Jaša Bartelj (1):
      USB: ftdi_sio: Added PID for new ekey device
         [646907f5bfb0782c731ae9ff6fb63471a3566132]

Jeffrey Deans (1):
      MIPS: GIC: Prevent array overrun
         [ffc8415afab20bd97754efae6aad1f67b531132b]

Jeremy Vial (1):
      ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.
         [9b5f7428f8b16bd8980213f2b70baf1dd0b9e36c]

Jiri Kosina (4):
      HID: fix a couple of off-by-ones
         [4ab25786c87eb20857bbb715c3ae34ec8fd6a214]
      HID: logitech: perform bounds checking on device_id early enough
         [ad3e14d7c5268c2e24477c6ef54bbdf88add5d36]
      HID: magicmouse: sanity check report size in raw_event() callback
         [c54def7bd64d7c0b6993336abcffb8444795bf38]
      HID: picolcd: sanity check report size in raw_event() callback
         [844817e47eef14141cf59b8d5ac08dd11c0a9189]

Joerg Roedel (1):
      iommu/amd: Fix cleanup_domain for mass device removal
         [9b29d3c6510407d91786c1cf9183ff4debb3473a]

Johan Hovold (3):
      USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID
         [6552cc7f09261db2aeaae389aa2c05a74b3a93b4]
      USB: serial: fix potential heap buffer overflow
         [5654699fb38512bdbfc0f892ce54fce75bdc2bab]
      USB: serial: fix potential stack buffer overflow
         [d979e9f9ecab04c1ecca741370e30a8a498893f5]

Jonas Bonn (1):
      openrisc: include export.h for EXPORT_SYMBOL
         [abdf8b5e07884a183938969253770164d60b87cb]

K. Y. Srinivasan (1):
      Drivers: scsi: storvsc: Implement a eh_timed_out handler
         [56b26e69c8283121febedd12b3cc193384af46b9]

Kevin Hao (1):
      mtd/ftl: fix the double free of the buffers allocated in build_maps()
         [a152056c912db82860a8b4c23d0bd3a5aa89e363]

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw
         [49b6c01f4c1de3b5e5427ac5aba80f9f6d27837a]

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance()  in scheduler
         [2062afb4f804afef61cbe62a30cac9a46e58e067]

Lv Zheng (1):
      ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set
         [3afcf2ece453e1a8c2c6de19cdf06da3772a1b08]

Malcolm Priestley (2):
      staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
         [6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5]
      staging: vt6655: Fix disassociated messages every 10 seconds
         [4aa0abed3a2a11b7d71ad560c1a3e7631c5a31cd]

Mark Rutland (2):
      ARM: 8128/1: abort: don't clear the exclusive monitors
         [85868313177700d20644263a782351262d2aff84]
      ARM: 8129/1: errata: work around Cortex-A15 erratum 830321 using dummy strex
         [2c32c65e3726c773760038910be30cce1b4d4149]

Mathias Nyman (1):
      xhci: rework cycle bit checking for new dequeue pointers
         [365038d83313951d6ace15342eb24624bbef1666]

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)
         [350b8bdd689cd2ab2c67c8a86a0be86cfa0751a7]

Michal Simek (1):
      microblaze: Fix makefile to work with latest toolchain
         [00708d421a22a0f82de2dbb91ca6213b3dcc5267]

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket
         [4c63f83c2c2e16a13ce274ee678e28246bd33645]

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted
         [9e8919ae793f4edfaa29694a70f71a515ae9942a]

NeilBrown (2):
      md/raid1,raid10: always abort recover on write error.
         [2446dba03f9dabe0b477a126cbeb377854785b47]
      md/raid6: avoid data corruption during recovery of double-degraded RAID6
         [9c4bdf697c39805078392d5ddbbba5ae5680e0dd]

Oliver Neukum (1):
      usbcore: don't log on consecutive debounce failures of the same port
         [5ee0f803cc3a0738a63288e4a2f453c85889fbda]

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Add support for new Xsens devices
         [4bdcde358b4bda74e356841d351945ca3f2245dd]
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
         [9273b8a270878906540349422ab24558b9d65716]

Paul Burton (1):
      MIPS: Prevent user from setting FCSR cause bits
         [b1442d39fac2fcfbe6a4814979020e993ca59c9e]

Paul Moore (1):
      netlabel: fix a problem when setting bits below the previously lowest bit
         [41c3bd2039e0d7b3dc32313141773f20716ec524]

Pavel Shilovsky (1):
      CIFS: Fix wrong directory attributes after rename
         [b46799a8f28c43c5264ac8d8ffa28b311b557e03]

Peter Hurley (1):
      serial: core: Preserve termios c_cflag for console resume
         [ae84db9661cafc63d179e1d985a2c5b841ff0ac4]

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices
         [a40178b2fa6ad87670fb1e5fa4024db00c149629]

Ralf Baechle (1):
      MIPS: Fix accessing to per-cpu data when flushing the cache
         [ff522058bd717506b2fa066fa564657f2b86477e]

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)
         [b32bfc06aefab61acc872dec3222624e6cd867ed]

Ronald Wahl (1):
      carl9170: fix sending URBs with wrong type when using full-speed
         [671796dd96b6cd85b75fba9d3007bcf7e5f7c309]

Sachin Kamat (1):
      hwmon: (amc6821) Fix return value
         [3499e5b2e14b792fe411302fea3b6fcc4ba40ef2]

Sam Ravnborg (1):
      sparc: use asm-generic version of types.h
         [cbf1ef6b3345d2cc7e62407eec6a6f72a8b1346f]

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in  memcpy_fromiovecend
         [06ebb06d49486676272a3c030bfeef4bd969a8e6]

Sergiu Giurgiu (1):
      ALSA: virtuoso: Xonar DSX support
         [4492363251235c4499a2d073c5f09121ea23d39d]

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when  handshake is in progress.
         [4ec1b01029b4facb651b8ef70bc20a4be4cebc63]

Stefan Kristiansson (1):
      openrisc: add missing header inclusion
         [160d83781a32e94a1e337efd6722939001e62398]

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video
         [5b6b80aeb21091ed3030b9b6aae597d81326f1aa]

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl
         [0758f4f732b08b6ef07f2e5f735655cf69fea477]

Steve Wise (1):
      RDMA/iwcm: Use a default listen backlog if needed
         [2f0304d21867476394cd51a54e97f7273d112261]

Steven Rostedt (3):
      debugfs: Fix corrupted loop in debugfs_remove_recursive
         [485d44022a152c0254dd63445fdb81c4194cbf0e]
      ring-buffer: Always reset iterator to reader page
         [651e22f2701b4113989237c3048d17337dd2185c]
      ring-buffer: Up rb_iter_peek() loop count to 3
         [021de3d904b88b1771a3a2cfc5b75023c391e646]

Sylwester Nawrocki (1):
      ASoC: samsung: Correct I2S DAI suspend/resume ops
         [d3d4e5247b013008a39e4d5f69ce4c60ed57f997]

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co
         [f3ee07d8b6e061bf34a7167c3f564e8da4360a99]

Tetsuo Handa (1):
      drm/ttm: Fix possible stack overflow by recursive shrinker calls.
         [71336e011d1d2312bcbcaa8fcec7365024f3a95d]

Theodore Ts'o (1):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct
         [86f0afd463215fc3e58020493482faa4ac3a4d69]

Trond Myklebust (1):
      NFSv4: Fix problems with close in the presence of a delegation
         [aee7af356e151494d5014f57b33460b162f181b5]

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload  support.
         [081e83a78db9b0ae1f5eabc2dedecc865f509b98]
      net: Correctly set segment mac_len in skb_segment().
         [fcdfe3a7fa4cb74391d42b6a26dc07c20dab1d82]

Vladimir Davydov (1):
      Bluetooth: never linger on process exit
         [093facf3634da1b0c2cc7ed106f1983da901bbab]

Zheng Liu (1):
      ext4: cleanup in ext4_discard_allocated_blocks()
         [400db9d30146dc062aaba97a6301b425eb6015bc]

 Documentation/sound/alsa/ALSA-Configuration.txt |   4 +-
 Documentation/stable_kernel_rules.txt           |   3 +
 Documentation/x86/x86_64/mm.txt                 |   2 +
 Makefile                                        |   6 +-
 arch/arm/kernel/entry-header.S                  |  29 +++----
 arch/arm/mach-omap2/control.c                   |   3 +-
 arch/arm/mm/abort-ev6.S                         |   6 --
 arch/arm/mm/abort-ev7.S                         |   6 --
 arch/microblaze/boot/Makefile                   |   2 +-
 arch/mips/cavium-octeon/setup.c                 |  18 +++--
 arch/mips/kernel/irq-gic.c                      |   6 +-
 arch/mips/kernel/perf_event_mipsxx.c            |   5 --
 arch/mips/kernel/ptrace.c                       |   3 +-
 arch/mips/mm/c-r4k.c                            |   5 ++
 arch/mips/mm/tlbex.c                            |   1 +
 arch/openrisc/kernel/head.S                     |   1 +
 arch/openrisc/kernel/init_task.c                |   1 +
 arch/openrisc/kernel/irq.c                      |   1 +
 arch/powerpc/include/asm/pte-hash64-64k.h       |  32 ++++++--
 arch/powerpc/kernel/pci-common.c                |   5 +-
 arch/powerpc/mm/init_64.c                       |   3 +-
 arch/powerpc/mm/numa.c                          |   2 +-
 arch/s390/Kconfig                               |   1 +
 arch/sparc/include/asm/Kbuild                   |   1 +
 arch/sparc/include/asm/pgtable_64.h             |   6 +-
 arch/sparc/include/asm/tlbflush_64.h            |  12 +--
 arch/sparc/include/asm/types.h                  |  23 ------
 arch/sparc/kernel/ldc.c                         |   2 +-
 arch/sparc/kernel/smp_64.c                      |   6 +-
 arch/sparc/kernel/sys32.S                       |   2 +-
 arch/sparc/kernel/unaligned_64.c                |  12 ++-
 arch/sparc/lib/NG2memcpy.S                      |   1 +
 arch/sparc/math-emu/math_32.c                   |   2 +-
 arch/sparc/mm/fault_64.c                        | 102 +++++++++++++-----------
 arch/sparc/mm/init_64.c                         |  27 +++++++
 arch/sparc/mm/tsb.c                             |  14 +++-
 arch/x86/Kconfig                                |  25 +++++-
 arch/x86/include/asm/irqflags.h                 |   2 +-
 arch/x86/include/asm/pgtable_64_types.h         |   2 +
 arch/x86/include/asm/setup.h                    |   2 +
 arch/x86/kernel/Makefile                        |   1 +
 arch/x86/kernel/entry_32.S                      |  12 +++
 arch/x86/kernel/entry_64.S                      |  80 ++++++++++++++++---
 arch/x86/kernel/ldt.c                           |  10 +--
 arch/x86/kernel/paravirt_patch_64.c             |   2 -
 arch/x86/kernel/resource.c                      |   8 +-
 arch/x86/kernel/smpboot.c                       |   7 ++
 arch/x86/kvm/emulate.c                          |   4 +
 arch/x86/mm/dump_pagetables.c                   |  39 ++++++---
 arch/x86/pci/i386.c                             |   4 +
 arch/x86/vdso/vdso32-setup.c                    |   8 --
 arch/x86/xen/time.c                             |   2 +-
 block/blk-tag.c                                 |  33 ++------
 crypto/af_alg.c                                 |   2 +
 drivers/acpi/ec.c                               |  17 +++-
 drivers/ata/ahci.c                              |   1 +
 drivers/ata/pata_scc.c                          |  15 ++--
 drivers/char/tpm/tpm.c                          |  62 +++++++++-----
 drivers/char/tpm/tpm.h                          |   3 +
 drivers/char/tpm/tpm_tis.c                      |  31 +++++++
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/gpu/drm/radeon/r600.c                   |   1 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |   4 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |  13 ++-
 drivers/hid/hid-cherry.c                        |   2 +-
 drivers/hid/hid-kye.c                           |   2 +-
 drivers/hid/hid-lg.c                            |   4 +-
 drivers/hid/hid-logitech-dj.c                   |  54 +++++++------
 drivers/hid/hid-logitech-dj.h                   |   1 +
 drivers/hid/hid-magicmouse.c                    |  10 +++
 drivers/hid/hid-monterey.c                      |   2 +-
 drivers/hid/hid-petalynx.c                      |   2 +-
 drivers/hid/hid-picolcd.c                       |   6 ++
 drivers/hid/hid-sunplus.c                       |   2 +-
 drivers/hwmon/ads1015.c                         |   4 +-
 drivers/hwmon/amc6821.c                         |  17 ++--
 drivers/hwmon/gpio-fan.c                        |   2 +-
 drivers/hwmon/lm78.c                            |   2 +-
 drivers/hwmon/lm85.c                            |  14 +++-
 drivers/hwmon/lm92.c                            |  13 ++-
 drivers/hwmon/sis5595.c                         |   2 +-
 drivers/hwmon/smsc47m192.c                      |  10 ++-
 drivers/infiniband/core/iwcm.c                  |  34 ++++++++
 drivers/iommu/amd_iommu.c                       |  10 ++-
 drivers/iommu/intel-iommu.c                     |  40 +++++++---
 drivers/md/raid1.c                              |   8 +-
 drivers/md/raid10.c                             |   8 +-
 drivers/md/raid5.c                              |   2 +
 drivers/media/dvb/frontends/tda10071.c          |   6 +-
 drivers/media/video/gspca/pac7302.c             |   1 +
 drivers/mtd/ftl.c                               |   1 -
 drivers/net/macvlan.c                           |   1 +
 drivers/net/ppp/pptp.c                          |   2 +-
 drivers/net/wireless/ath/carl9170/carl9170.h    |   1 +
 drivers/net/wireless/ath/carl9170/usb.c         |  31 ++++++-
 drivers/sbus/char/bbc_envctrl.c                 |   6 ++
 drivers/sbus/char/bbc_i2c.c                     |  11 ++-
 drivers/scsi/bfa/bfa_ioc.h                      |   2 +-
 drivers/scsi/hpsa.c                             |   2 +-
 drivers/scsi/scsi_lib.c                         |   8 ++
 drivers/staging/hv/storvsc_drv.c                |  12 +++
 drivers/staging/vt6655/bssdb.c                  |   2 +-
 drivers/staging/vt6655/device_main.c            |   7 +-
 drivers/tty/serial/serial_core.c                |   3 +
 drivers/tty/serial/sunsab.c                     |   9 +++
 drivers/usb/core/hub.c                          |  45 ++++++++++-
 drivers/usb/host/ohci-q.c                       |  46 +++++++----
 drivers/usb/host/xhci-pci.c                     |   4 +
 drivers/usb/host/xhci-ring.c                    |  79 +++++++++---------
 drivers/usb/host/xhci.c                         |   3 +
 drivers/usb/misc/sisusbvga/sisusb.c             |   1 +
 drivers/usb/serial/ftdi_sio.c                   |   5 ++
 drivers/usb/serial/ftdi_sio_ids.h               |  20 +++--
 drivers/usb/serial/option.c                     |   5 ++
 drivers/usb/serial/pl2303.c                     |   1 +
 drivers/usb/serial/pl2303.h                     |   1 +
 drivers/usb/serial/usb-serial.c                 |  37 ++++++---
 drivers/usb/serial/whiteheat.c                  |   7 +-
 fs/btrfs/file-item.c                            |   2 +-
 fs/cifs/inode.c                                 |   6 ++
 fs/debugfs/inode.c                              |  34 ++++++--
 fs/ext4/mballoc.c                               |  25 ++++--
 fs/isofs/inode.c                                |  15 ++--
 fs/isofs/isofs.h                                |  23 +++++-
 fs/isofs/rock.c                                 |  39 ++++++---
 fs/namespace.c                                  |   8 ++
 fs/nfs/nfs4proc.c                               |  17 ++--
 fs/reiserfs/journal.c                           |  21 +++--
 include/linux/mempolicy.h                       |   2 +-
 include/linux/mount.h                           |   1 +
 include/net/inetpeer.h                          |  14 +---
 include/net/ip.h                                |  31 ++++---
 include/net/ipip.h                              |   2 +-
 include/net/ipv6.h                              |   9 ++-
 include/net/netlabel.h                          |   8 +-
 include/net/secure_seq.h                        |   2 -
 init/main.c                                     |   4 +
 kernel/trace/ring_buffer.c                      |  29 +++----
 mm/mempolicy.c                                  |   8 +-
 mm/page_alloc.c                                 |  16 ++--
 mm/slab.c                                       |   4 +-
 mm/slub.c                                       |   2 +-
 net/bluetooth/l2cap_sock.c                      |   3 +-
 net/bluetooth/rfcomm/sock.c                     |   3 +-
 net/bluetooth/sco.c                             |   6 +-
 net/compat.c                                    |   9 ++-
 net/core/iovec.c                                |  10 ++-
 net/core/secure_seq.c                           |  23 ------
 net/core/skbuff.c                               |   2 +-
 net/ipv4/cipso_ipv4.c                           |   6 +-
 net/ipv4/igmp.c                                 |   4 +-
 net/ipv4/inetpeer.c                             |  18 -----
 net/ipv4/ip_output.c                            |   7 +-
 net/ipv4/ipmr.c                                 |   2 +-
 net/ipv4/raw.c                                  |   2 +-
 net/ipv4/route.c                                |  78 ++++++++++--------
 net/ipv4/tcp_vegas.c                            |   3 +-
 net/ipv4/tcp_veno.c                             |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                    |   2 +-
 net/ipv6/ip6_output.c                           |  25 +++---
 net/netfilter/ipvs/ip_vs_xmit.c                 |   2 +-
 net/netlabel/netlabel_kapi.c                    |  26 ++++--
 net/sctp/associola.c                            |   1 +
 net/sctp/output.c                               |   2 +-
 security/smack/smack_lsm.c                      |   2 +-
 sound/pci/Kconfig                               |   4 +-
 sound/pci/hda/patch_realtek.c                   |  17 ++--
 sound/pci/oxygen/virtuoso.c                     |   2 +
 sound/pci/oxygen/xonar_pcm179x.c                |  12 ++-
 sound/pci/oxygen/xonar_wm87x6.c                 |   6 +-
 sound/soc/pxa/pxa-ssp.c                         |   4 +-
 sound/soc/samsung/i2s.c                         |  16 ++--
 virt/kvm/iommu.c                                |  19 ++---
 173 files changed, 1308 insertions(+), 688 deletions(-)

-- 
Ben Hutchings
It is easier to change the specification to fit the program than vice versa.

