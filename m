Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3EJOx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:53:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56829 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263Ab3EJOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Fri, 10 May 2013 14:39:39 +0100
Message-ID: <lsq.1368193179.973009354@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [000/118] 3.2.45-rc1 review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.45 release.
There are 118 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon May 13 12:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.44 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Adrian Thomasset (2):
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
         [9f06d15f8db6946e41f73196a122b84a37938878]
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite
         [71d9a2b95fc9c9474d46d764336efd7a5a805555]

Alex Deucher (8):
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
         [2e97be73e5f74a317232740ae82eb8f95326a660]
      drm/radeon: cleanup properly if mmio mapping fails
         [0cd9cb76ae26a19df21abc6f94f5fff141e689c7]
      drm/radeon: don't use get_engine_clock() on APUs
         [bf05d9985111f85ed6922c134567b96eb789283b]
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
         [beb71fc61c2cad64e347f164991b8ef476529e64]
      drm/radeon: fix handling of v6 power tables
         [441e76ca83ac604eaf0f046def96d8e3a27eea28]
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
         [dcb852905772416e322536ced5cb3c796d176af5]
      drm/radeon: fix possible segfault when parsing pm tables
         [f8e6bfc2ce162855fa4f9822a45659f4b542c960]
      drm/radeon: use frac fb div on RS780/RS880
         [411678288d61ba17afe1f8afed92200be6bbc65d]

Anurup m (1):
      fs/fscache/stats.c: fix memory leak
         [ec686c9239b4d472052a271c505d04dae84214cc]

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after  loopback down-up
         [25fb6ca4ed9cad72f14f61629b68dc03c0d9713f]

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display
         [e7d3b6e22c871ba36d052ca99bc8ceca4d546a60]

Benjamin Poirier (1):
      ixgbe: add missing rtnl_lock in PM resume path
         [34948a947d1a576c10afee6d14792fd237549577]

Bjørn Mork (1):
      USB: option: add a D-Link DWM-156 variant
         [a2a2d6c7f93e160b52a4ad0164db1f43f743ae0f]

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values
         [bf8d909705e9d9bac31d9b8eac6734d2b51332a7]

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
         [1539d4f82ad534431cc67935e8e442ccf107d17d]

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
         [12b2f117f3bf738c1a00a6f64393f1953a740bd4]

Chris Wilson (2):
      drm/i915: Fix detection of base of stolen memory
         [e12a2d53ae45a69aea499b64f75e7222cca0f12f]
      drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
         [25ff1195f8a0b3724541ae7bbe331b4296de9c06]

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900
         [9e9dd0e889c76c786e8f2e164c825c3c06dea30c]

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices
         [cbc200bca4b51a8e2406d4b654d978f8503d430b]

Daniel Borkmann (1):
      net: sctp: sctp_auth_key_put: use kzfree instead of  kfree
         [586c31f3bf04c290dc0a0de7fc91d20aa9a5ee53]

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT
         [ebfc594c02148b6a85c2f178cf167a44a3c3ce10]

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
         [51fd36f3fad8447c487137ae26b9d0b3ce77bb25]

David Müller (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection
         [e4bfff54ed3f5de88f5358504c78c2cb037813aa]

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.
         [f36391d2790d04993f48da6a45810033a2cdf847,
          f0af97070acbad5d6a361f485828223a4faaa0ee]

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
         [e005715efaf674660ae59af83b13822567e3a758]

Dmitry Monakhov (1):
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
         [794446c6946513c684d448205fbd76fa35f38b72]

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under  synflood
         [d66954a066158781ccf9c13c91d0316970fe57b6]

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.
         [98682063549bedd6e2d2b6b7222f150c6fbce68c]

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd
         [63b77bf489881747c5118476918cc8c29378ee63]

Eric Dumazet (2):
      net: drop dst before queueing fragments
         [97599dc792b45b1669c3cdb9a4b365aad0232f65]
      tcp: call tcp_replace_ts_recent() from tcp_ack()
         [12fb3dd9dc3c64ba7d64cec977cca9b5fb7b1d4e]

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce  all messages
         [0e82e7f6dfeec1013339612f74abc2cdd29d43d2]

Fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error
         [b022032e195ffca83d7002d6b84297d796ed443b]

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()
         [5a65dcc04cda41f4122aacc37a5a348454645399]

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145
         [d19bf5cedfd7d53854a3bd699c98b467b139833b]

Francois Romieu (1):
      r8169: fix 8168evl frame padding.
         [e5195c1f31f399289347e043d6abf3ffa80f0005]

FrançOis Romieu (1):
      r8169: fix vlan tag read ordering.
         [ce11ff5e5963e441feb591e76278528f876c332d]

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()
         [421348f1ca0bf17769dee0aed4d991845ae0536d]

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of  wrong ip length fields
         [31d1670e73f4911fe401273a8f576edc9c2b5fea]

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep
         [1361bf4b9f9ef45e628a5b89e0fd9bedfdcb7104]

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments
         [94c163663fc1dcfc067a5fb3cc1446b9469975ce]

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon
         [0c7c3e67ab91ec6caa44bdf1fc89a48012ceb0c5]

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other
         [d87d830720a1446403ed38bfc2da268be0d356d1]

Jani Nikula (1):
      drm/i915: ensure single initialization and cleanup of backlight device
         [dc652f90e088798bfa31f496ba994ddadd5d5680]

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment
         [not needed upstream as function was removed]

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
         [b0de59b5733d18b0d1974a060860a8b5c1b36a2e]
      TTY: fix atime/mtime regression
         [37b7f3c76595e23257f61bd80b223de8658617ee]

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition
         [990de49f74e772b6db5208457b7aa712a5f4db86]

Konrad Rzeszutek Wilk (3):
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
         [66ff0fe9e7bda8aec99985b24daad03652f7304e]
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
         [888b65b4bc5e7fcbbb967023300cd5d44dba1950]
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
         [7918c92ae9638eb8a6ec18e2b4a0de84557cccc8]

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()
         [3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88]

Linus Torvalds (6):
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h
         [4f2e29031e6c67802e7370292dd050fd62f337ee]
      tty: fix up atime/mtime mess, take three
         [b0b885657b6c8ef63a46bc9299b2a7715d19acde]
      vm: add vm_iomap_memory() helper function
         [b4cbb197c7e7a68dbad0d491242e3ca67420c13e]
      vm: convert HPET mmap to vm_iomap_memory() helper
         [2323036dfec8ce3ce6e1c86a49a31b039f3300d1]
      vm: convert fb_mmap to vm_iomap_memory() helper
         [fc9bbca8f650e5f738af8806317c0a041a48ae4a]
      vm: convert snd_pcm_lib_mmap_iomem() to vm_iomap_memory() helper
         [0fe09a45c4848b5b5607b968d959fdc1821c161d]

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug
         [0259d9eb30d003af305626db2d8332805696e60d]

Mathias Krause (12):
      Bluetooth: RFCOMM - Fix missing msg_namelen update in  rfcomm_sock_recvmsg()
         [e11e0455c0d7d3d62276a0c55d9dfbc16779d691]
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
         [4683f42fde3977bdb4e8a09622788cc8b5313778]
      atm: update msg_namelen in vcc_recvmsg()
         [9b3e617f3df53822345a8573b6d358f6b9e5ed87]
      ax25: fix info leak via msg_name in ax25_recvmsg()
         [ef3313e84acbf349caecae942ab3ab731471f1a1]
      caif: Fix missing msg_namelen update in  caif_seqpkt_recvmsg()
         [2d6fbfe733f35c6b355c216644e08e149c61b271]
      crypto: algif - suppress sending source address information in recvmsg
         [72a763d805a48ac8c0bf48fdb510e84c12de51fe]
      irda: Fix missing msg_namelen update in  irda_recvmsg_dgram()
         [5ae94c0d2f0bed41d6718be743985d61b7f5c47d]
      iucv: Fix missing msg_namelen update in  iucv_sock_recvmsg()
         [a5598bd9c087dc0efc250a5221e5d0e6f584ee88]
      llc: Fix missing msg_namelen update in  llc_ui_recvmsg()
         [c77a4b9cffb6215a15196ec499490d116dfad181]
      netrom: fix info leak via msg_name in nr_recvmsg()
         [3ce5efad47b62c57a4f5c54248347085a750ce0e,
          c802d759623acbd6e1ee9fbdabae89159a513913]
      rose: fix info leak via msg_name in rose_recvmsg()
         [4a184233f21645cf0b719366210ed445d1024d72]
      tipc: fix info leaks via msg_name in  recv_msg/recv_stream
         [60085c3d009b0df252547adb336d1ccca5ce52ec]

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
         [6747e83235caecd30b186d1282e4eba7679f81b7]

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush
         [29ce3c5073057991217916abc25628e906911757]

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header  length
         [88c5b5ce5cb57af6ca2a7cf4d5715fa320448ff9]

Mika Kuoppala (1):
      fbcon: when font is freed, clear also vc_font.data
         [e6637d5427d2af9f3f33b95447bfc5347e5ccd85]

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdir
         [f7db5e7660b122142410dcf36ba903c73d473250]

Namhyung Kim (3):
      tracing: Check return value of tracing_init_dentry()
         [ed6f1c996bfe4b6e520cf7a74b51cd6988d84420]
      tracing: Fix off-by-one on allocating stat->pages
         [39e30cd1537937d3c00ef87e865324e981434e5b]
      tracing: Reset ftrace_graph_filter_enabled if count is zero
         [9f50afccfdc15d95d7331acddcb0f7703df089ae]

NeilBrown (1):
      md: bad block list should default to disabled.
         [486adf72ccc0c235754923d47a2270c5dcb0c98b]

Nikolay@Redhat.Com (2):
      bonding: IFF_BONDING is not stripped on enslave  failure
         [b6a5a7b9a528a8b4c8bec940b607c5dd9102b8cc]
      bonding: fix bonding_masters race condition in bond  unloading
         [69b0216ac255f523556fa3d4ff030d857eaaa37f]

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()
         [124dff01afbdbff251f0385beca84ba1b9adda68]

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt
         [8f294b5a139ee4b75e890ad5b443c93d1e558a8b]

Rafael J. Wysocki (1):
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
         [769ba7212f2059ca9fe0c73371e3d415c8c1c529]

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.
         [cd4baaaa04b4aaa3b0ec4d13a6f3d203b92eadbd]

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB
         [d69f3bad4675ac519d41ca2b11e1c00ca115cecd]

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x
         [58f8b6c4fa5a13cb2ddb400e26e9e65766d71e38]

Stephan Schreiber (2):
      Wrong asm register contraints in the futex implementation
         [136f39ddc53db3bcee2befbe323a56d4fbf06da8]
      Wrong asm register contraints in the kvm implementation
         [de53e9caa4c6149ef4a78c2f83d7f5b655848767]

Stephane Eranian (1):
      perf/x86: Fix offcore_rsp valid mask for SNB/IVB
         [f1923820c447e986a9da0fc6bf60c1dccdf0408e]

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO
         [c39e8e4354ce4daf23336de5daa28a3b01f00aa6]

Steven Rostedt (4):
      tracing: Fix ftrace_dump()
         [7fe70b579c9e3daba71635e31b6189394e7b79d3]
      tracing: Fix stack tracer with fentry use
         [d4ecbfc49b4b1d4b597fb5ba9e4fa25d62f105c5]
      tracing: Remove most or all of stack tracer stack size from stack_max_size
         [4df297129f622bdc18935c856f42b9ddd18f9f28]
      tracing: Use stack of calling function for stack tracer
         [87889501d0adfae10e3b0f0e6f2d7536eed9ae84]

Takashi Iwai (1):
      ALSA: usb-audio: Fix autopm error during probing
         [60af3d037eb8c670dcce31401501d1271e7c5d95]

Theodore Ts'o (2):
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
         [d76a3a77113db020d9bb1e894822869410450bd9]
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
         [7f3e3c7cfcec148ccca9c0dd2dbfd7b00b7ac10f]

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown
         [6f7a05d7018de222e40ca003721037a530979974]

Tommi Rantala (1):
      perf: Treat attr.config as u64 in perf_swevent_init()
         [8176cced706b5e5d15887584150764894e94e02f]

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts
         [d303e9e98fce56cdb3c6f2ac92f626fc2bd51c77]

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB
         [671b4b2ba9266cbcfe7210a704e9ea487dcaa988]

Trond Myklebust (1):
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot
         [1dfd89af8697a299e7982ae740d4695ecd917eef]

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree
         [7122beeee7bc1757682049780179d7c216dd1c83]

Vasily Averin (1):
      cbq: incorrect processing of high limits
         [f0f6ee1f70c4eaab9d52cf7d255df4bd89f8d1c2]

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works  properly.
         [4543fbefe6e06a9e40d9f2b28d688393a299f079]

Wei Yongjun (3):
      esp4: fix error return code in esp_output()
         [06848c10f720cbc20e3b784c0df24930b7304b93]
      netrom: fix invalid use of sizeof in nr_recvmsg()
         [c802d759623acbd6e1ee9fbdabae89159a513913]
      perf: Fix error return code
         [c481420248c6730246d2a1b1773d5d7007ae0835]

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls
         [545d6e189a41c94c11f55045a771118eccc9d9eb]

Yogesh Ashok Powar (2):
      mwifiex: Call pci_release_region after calling pci_disable_device
         [5b0d9b218b74042ff72bf4bfda6eeb2e4bf98397]
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
         [c380aafb77b7435d010698fe3ca6d3e1cd745fde]

Zhao Hongjiang (2):
      aio: fix possible invalid memory access when DEBUG is enabled
         [91d80a84bbc8f28375cca7e65ec666577b4209ad]
      inotify: invalid mask should return a error number but not set it
         [04df32fa10ab9a6f0643db2949d42efc966bc844]

 Makefile                                        |    4 +-
 arch/arm/mach-u300/include/mach/u300-regs.h     |    2 +-
 arch/ia64/include/asm/futex.h                   |    5 +-
 arch/ia64/include/asm/mca.h                     |    1 +
 arch/ia64/kernel/irq.c                          |    8 ++
 arch/ia64/kernel/mca.c                          |   37 ++++---
 arch/ia64/kvm/vtlb.c                            |    2 +-
 arch/powerpc/kernel/head_64.S                   |    1 +
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |    1 +
 arch/sparc/include/asm/pgtable_64.h             |    1 +
 arch/sparc/include/asm/system_64.h              |    3 +-
 arch/sparc/include/asm/tlbflush_64.h            |   37 +++++--
 arch/sparc/kernel/smp_64.c                      |   41 +++++++-
 arch/sparc/mm/tlb.c                             |   39 +++++++-
 arch/sparc/mm/tsb.c                             |   57 ++++++++---
 arch/sparc/mm/ultra.S                           |  119 ++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event_intel.c          |   15 ++-
 arch/x86/mm/init.c                              |    5 +
 arch/x86/xen/enlighten.c                        |    5 +-
 arch/x86/xen/smp.c                              |    2 +
 arch/x86/xen/time.c                             |    6 +-
 crypto/algif_hash.c                             |    2 +
 crypto/algif_skcipher.c                         |    1 +
 drivers/acpi/pci_root.c                         |    4 +-
 drivers/char/hpet.c                             |   14 +--
 drivers/gpu/drm/i915/i915_dma.c                 |   81 +++++++--------
 drivers/gpu/drm/i915/i915_drv.h                 |    1 +
 drivers/gpu/drm/i915/i915_gem.c                 |   16 +++
 drivers/gpu/drm/i915/intel_display.c            |    3 +
 drivers/gpu/drm/i915/intel_dp.c                 |    5 -
 drivers/gpu/drm/i915/intel_dvo.c                |   13 ++-
 drivers/gpu/drm/i915/intel_lvds.c               |   10 +-
 drivers/gpu/drm/i915/intel_panel.c              |    7 +-
 drivers/gpu/drm/radeon/atom.c                   |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c          |    3 +
 drivers/gpu/drm/radeon/evergreen.c              |   10 ++
 drivers/gpu/drm/radeon/r600_hdmi.c              |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c        |   21 ++--
 drivers/gpu/drm/radeon/radeon_kms.c             |    4 +
 drivers/gpu/drm/radeon/radeon_pm.c              |    6 +-
 drivers/i2c/busses/i2c-xiic.c                   |    6 +-
 drivers/md/md.c                                 |    9 +-
 drivers/net/bonding/bond_main.c                 |   10 ++
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c    |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |   12 +++
 drivers/net/ethernet/realtek/r8169.c            |   22 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c      |    5 +-
 drivers/net/wireless/mwifiex/pcie.c             |    4 +-
 drivers/pci/pci.c                               |   12 +--
 drivers/rtc/rtc-cmos.c                          |    4 +-
 drivers/s390/char/sclp_cmd.c                    |    4 +-
 drivers/tty/pty.c                               |    3 +
 drivers/tty/serial/serial_core.c                |    4 +
 drivers/tty/tty_io.c                            |   16 ++-
 drivers/usb/core/devio.c                        |    2 +
 drivers/usb/misc/appledisplay.c                 |    1 +
 drivers/usb/serial/ftdi_sio.c                   |   23 +++--
 drivers/usb/serial/ftdi_sio_ids.h               |    4 +-
 drivers/usb/serial/option.c                     |    8 ++
 drivers/usb/storage/cypress_atacb.c             |   16 ++-
 drivers/video/console/fbcon.c                   |    2 +
 drivers/video/fbmem.c                           |   40 +++-----
 fs/aio.c                                        |    2 +-
 fs/dcache.c                                     |    4 +-
 fs/ext4/Kconfig                                 |    3 +-
 fs/ext4/fsync.c                                 |    3 +-
 fs/ext4/inode.c                                 |    3 +-
 fs/fscache/stats.c                              |    2 +-
 fs/jbd2/commit.c                                |   50 +++++-----
 fs/jbd2/journal.c                               |   31 ++++++
 fs/lockd/clntlock.c                             |    3 +
 fs/lockd/clntproc.c                             |    3 -
 fs/nfsd/nfs4proc.c                              |    8 +-
 fs/nfsd/nfs4state.c                             |    8 +-
 fs/nfsd/nfs4xdr.c                               |   19 +---
 fs/notify/inotify/inotify_user.c                |    6 +-
 fs/sysfs/dir.c                                  |   15 ++-
 include/linux/ipc_namespace.h                   |    2 +-
 include/linux/jbd2.h                            |    2 +
 include/linux/mm.h                              |    2 +
 include/linux/netdevice.h                       |    2 +-
 include/linux/skbuff.h                          |    7 ++
 ipc/shm.c                                       |    2 +-
 kernel/audit_tree.c                             |    2 +-
 kernel/cgroup.c                                 |    2 +-
 kernel/events/core.c                            |    3 +-
 kernel/hrtimer.c                                |    6 ++
 kernel/time/tick-broadcast.c                    |    4 +
 kernel/time/tick-common.c                       |    1 +
 kernel/trace/ftrace.c                           |    5 +-
 kernel/trace/trace.c                            |   65 ++++++-------
 kernel/trace/trace_selftest.c                   |    9 +-
 kernel/trace/trace_stack.c                      |   76 +++++++++++++--
 kernel/trace/trace_stat.c                       |    2 +
 mm/memory.c                                     |   47 +++++++++
 net/atm/common.c                                |    2 +
 net/ax25/af_ax25.c                              |    1 +
 net/bluetooth/af_bluetooth.c                    |    4 +-
 net/bluetooth/rfcomm/sock.c                     |    1 +
 net/caif/caif_socket.c                          |    2 +
 net/core/dev.c                                  |    1 +
 net/core/dev_addr_lists.c                       |    6 +-
 net/core/rtnetlink.c                            |    4 +-
 net/ipv4/esp4.c                                 |    6 +-
 net/ipv4/ip_fragment.c                          |   15 ++-
 net/ipv4/syncookies.c                           |    4 +-
 net/ipv4/tcp_input.c                            |   65 ++++++-------
 net/ipv6/addrconf.c                             |   27 +++++
 net/ipv6/reassembly.c                           |   13 ++-
 net/irda/af_irda.c                              |    2 +
 net/iucv/af_iucv.c                              |    2 +
 net/llc/af_llc.c                                |    2 +
 net/netrom/af_netrom.c                          |    1 +
 net/rose/af_rose.c                              |    1 +
 net/sched/sch_cbq.c                             |    5 +-
 net/sctp/auth.c                                 |    2 +-
 net/tipc/socket.c                               |    7 ++
 net/unix/af_unix.c                              |    2 +-
 net/wireless/reg.c                              |    2 +-
 sound/core/pcm_native.c                         |   12 +--
 sound/soc/codecs/max98088.c                     |    2 +-
 sound/usb/card.c                                |    4 +-
 sound/usb/card.h                                |    1 +
 sound/usb/endpoint.c                            |    3 +-
 sound/usb/midi.c                                |   13 +--
 sound/usb/quirks.c                              |    1 +
 sound/usb/stream.c                              |    8 ++
 130 files changed, 1007 insertions(+), 430 deletions(-)

-- 
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

