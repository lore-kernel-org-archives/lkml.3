Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3ERCcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3ERCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:43 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=ieeK8MO8WKkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bLFOEYoiK7IA:10 a=Za-v_TxjEwRqeyIWP4AA:9 a=KFsoNBzS6jZ9nuGw:21 a=x0UfuYbdnbL9AFoO:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021557.139113314@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:15:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 000/136 ] 3.6.11.4-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for 3.6.11.4 release.
There are 136 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon May 20 2013.
Anything received after that time might be too late.

Aaron Lu (1):
      acpi: make ata_ap_acpi_handle not block
         [d66af4df0837f21bf267305dc5ccab2d29e24d86]

Adrian Thomasset (2):
      USB: ftdi_sio: enable two UART ports on ST Microconnect Lite
         [71d9a2b95fc9c9474d46d764336efd7a5a805555]
      USB: ftdi_sio: correct ST Micro Connect Lite PIDs
         [9f06d15f8db6946e41f73196a122b84a37938878]

Alex A. Mihaylov (1):
      rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
         [7e9dafd873034dd64ababcb858be424c4780ae13]

Alex Deucher (16):
      drm/radeon: fix handling of v6 power tables
         [441e76ca83ac604eaf0f046def96d8e3a27eea28]
      drm/radeon: add new richland pci ids
         [62d1f92e06aef9665d71ca7e986b3047ecf0b3c7]
      drm/radeon: fix possible segfault when parsing pm tables
         [f8e6bfc2ce162855fa4f9822a45659f4b542c960]
      drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
         [beb71fc61c2cad64e347f164991b8ef476529e64]
      drm/radeon: fix typo in si_select_se_sh()
         [79b52d6a7085a3e430c6de450a5847fdbe04159b]
      drm/radeon: fix hdmi mode enable on RS600/RS690/RS740
         [dcb852905772416e322536ced5cb3c796d176af5]
      drm/radeon: cleanup properly if mmio mapping fails
         [0cd9cb76ae26a19df21abc6f94f5fff141e689c7]
      drm/radeon/evergreen+: don't enable HPD interrupts on eDP/LVDS
         [2e97be73e5f74a317232740ae82eb8f95326a660]
      drm/radeon: add some new SI PCI ids
         [18932a28419596bc9403770f5d8a108c5433fe59]
      drm/radeon: disable the crtcs in mc_stop (evergreen+) (v2)
         [abf1457bbbe4c62066bd03c6d31837dea28644dc]
      drm/radeon: update wait_for_vblank for r1xx-r4xx
         [2b48b968c0d00aa5ab520b65a15a4f374cda7dda]
      drm/radeon: update wait_for_vblank for evergreen+
         [10257a6d8359c41407eb26b7ad7bf710a7e00155]
      drm/radeon: update wait_for_vblank for r5xx-r7xx
         [bea5497bfc1067620c8c8e9d37a42e0bb6d7d7fa]
      drm/radeon/dce6: add missing display reg for tiling setup
         [7c1c7c18fc752b2a1d07597286467ef186312463]
      drm/radeon: use frac fb div on RS780/RS880
         [411678288d61ba17afe1f8afed92200be6bbc65d]
      drm/radeon: don't use get_engine_clock() on APUs
         [bf05d9985111f85ed6922c134567b96eb789283b]

Anisse Astier (1):
      drm/gma500: fix backlight hotkeys behaviour on netbooks
         [e127dc28cc3057575da0216cde85687153ca180f]

Anton Blanchard (1):
      powerpc: Emulate non privileged DSCR read and write
         [73d2fb758e678c93bc76d40876c2359f0729b0ef]

Anurup m (1):
      fs/fscache/stats.c: fix memory leak
         [ec686c9239b4d472052a271c505d04dae84214cc]

Ben Jencks (1):
      usb/misc/appledisplay: Add 24" LED Cinema display
         [e7d3b6e22c871ba36d052ca99bc8ceca4d546a60]

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address
         [13f85203e1060da83d9ec1c1c5a63343eaab8de4]

Bjørn Mork (1):
      USB: option: add a D-Link DWM-156 variant
         [a2a2d6c7f93e160b52a4ad0164db1f43f743ae0f]

Bryan Schumaker (1):
      nfsd: Decode and send 64bit time values
         [bf8d909705e9d9bac31d9b8eac6734d2b51332a7]

Calvin Owens (1):
      ALSA: usb: Add quirk for 192KHz recording on E-Mu devices
         [1539d4f82ad534431cc67935e8e442ccf107d17d]

Catalin Marinas (1):
      arm: set the page table freeing ceiling to TASK_SIZE
         [104ad3b32d7a71941c8ab2dee78eea38e8a23309]

Chen Gang (1):
      kernel/audit_tree.c: tree will leak memory when failure occurs in audit_trim_trees()
         [12b2f117f3bf738c1a00a6f64393f1953a740bd4]

Chris Wilson (3):
      drm/i915: Use MLC (l3$) for context objects
         [4615d4c9e27eda42c3e965f208a4b4065841498c]
      drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
         [25ff1195f8a0b3724541ae7bbe331b4296de9c06]
      drm/i915: Fix detection of base of stolen memory
         [e12a2d53ae45a69aea499b64f75e7222cca0f12f]

Christian Lamparter (1):
      drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900
         [9e9dd0e889c76c786e8f2e164c825c3c06dea30c]

Clemens Ladisch (1):
      ALSA: usb-audio: disable autopm for MIDI devices
         [cbc200bca4b51a8e2406d4b654d978f8503d430b]

Daniel Lezcano (1):
      ARM: omap3: cpuidle: enable time keeping
         [0d97558901c446a989de202a5d9ae94ec53644e5]

Daniel Mack (1):
      ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT
         [ebfc594c02148b6a85c2f178cf167a44a3c3ce10]

Dave Airlie (4):
      drm/ast: deal with bo reserve fail in dirty update path
         [306373b645d80625335b8e684fa09b14ba460cec]
      drm/prime: keep a reference from the handle to exported dma-buf (v6)
         [219b47339ced80ca580bb6ce7d1636166984afa7]
      drm/mgag200: deal with bo reserve fail in dirty update path
         [641719599528d806e00de8ae8c8453361266a312]
      drm/cirrus: deal with bo reserve fail in dirty update path
         [f3b2bbdc8a87a080ccd23d27fca4b87d61340dd4]

David Engraf (1):
      hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
         [51fd36f3fad8447c487137ae26b9d0b3ce77bb25]

David Jeffery (1):
      autofs - remove autofs dentry mount check
         [ce8a5dbdf9e709bdaf4618d7ef8cceb91e8adc69]

David Müller (ELSOFT AG) (1):
      drm/i915: Fall back to bit banging mode for DVO transmitter detection
         [e4bfff54ed3f5de88f5358504c78c2cb037813aa]

Derek Basehore (1):
      drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
         [e005715efaf674660ae59af83b13822567e3a758]

Dmitry Monakhov (3):
      ext4: fix big-endian bug in metadata checksum calculations
         [171a7f21a76a0958c225b97c00a97a10390d40ee]
      ext4: fix journal callback list traversal
         [5d3ee20855e28169d711b394857ee608a5023094]
      jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback
         [794446c6946513c684d448205fbd76fa35f38b72]

Duncan Laurie (1):
      TPM: Retry SaveState command in suspend path
         [32d33b29ba077d6b45de35f2181e0a7411b162f4]

Dylan Reid (1):
      ASoC: max98088: Fix logging of hardware revision.
         [98682063549bedd6e2d2b6b7222f150c6fbce68c]

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't send zeroed LQ cmd
         [63b77bf489881747c5118476918cc8c29378ee63]

Federico Vaga (1):
      serial_core.c: add put_device() after device_find_child()
         [5a65dcc04cda41f4122aacc37a5a348454645399]

Filippo Turato (1):
      USB: serial: option: Added support Olivetti Olicard 145
         [d19bf5cedfd7d53854a3bd699c98b467b139833b]

Florian Westphal (3):
      netfilter: xt_rpfilter: skip locally generated broadcast/multicast, too
         [f83a7ea2075ca896f2dbf07672bac9cf3682ff74]
      netfilter: ctnetlink: don't permit ct creation with random tuple
         [442fad9423b78319e0019a7f5047eddf3317afbc]
      netfilter: nf_ct_helper: don't discard helper if it is actually the same
         [6e2f0aa8cf8892868bf2c19349cb5d7c407f690d]

Gleb Natapov (1):
      KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions
         [660696d1d16a71e15549ce1bf74953be1592bcd3]

Greg Thelen (1):
      fs/dcache.c: add cond_resched() to shrink_dcache_parent()
         [421348f1ca0bf17769dee0aed4d991845ae0536d]

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value
         [f7a1dd6e3ad59f0cfd51da29dfdbfd54122c5916]

Hans de Goede (1):
      usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep
         [1361bf4b9f9ef45e628a5b89e0fd9bedfdcb7104]

Heiko Carstens (1):
      s390/memory hotplug: prevent offline of active memory increments
         [94c163663fc1dcfc067a5fb3cc1446b9469975ce]

Hugh Dickins (1):
      mm: allow arch code to control the user page table ceiling
         [6ee8630e02be6dd89926ca0fbc21af68b23dc087]

J. Bruce Fields (1):
      nfsd4: don't close read-write opens too soon
         [0c7c3e67ab91ec6caa44bdf1fc89a48012ceb0c5]

Jacob Keller (1):
      ixgbe: fix EICR write in ixgbe_msix_other
         [d87d830720a1446403ed38bfc2da268be0d356d1]

Jan-Simon Möller (1):
      perf/x86/intel: Fix unintended variable name reuse
         [1b0dac2ac6debdbf1541e15f2cede03613cf4465]

Jerome Marchand (1):
      swap: redirty page if page write fails on swap file
         [2d30d31ea3c5be426ce25607b9bd1835acb85e0a]

Jerry Hoemann (1):
      x86/mm: account for PGDIR_SIZE alignment

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
         [91cf54feecf815bec0b6a8d6d9dbd0e219f2f2cc]

Johannes Berg (1):
      wireless: regulatory: fix channel disabling race condition
         [990de49f74e772b6db5208457b7aa712a5f4db86]

Josef Bacik (1):
      Btrfs: compare relevant parts of delayed tree refs
         [41b0fc42800569f63e029549b75c4c9cb63f2dfd]

Jozsef Kadlecsik (2):
      netfilter: ipset: "Directory not empty" error message
         [dd82088dab3646ed28e4aa43d1a5b5d5ffc2afba]
      netfilter: ipset: list:set: fix reference counter update
         [02f815cb6d3f57914228be84df9613ee5a01c2e6]

Konrad Rzeszutek Wilk (3):
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline
         [66ff0fe9e7bda8aec99985b24daad03652f7304e]
      xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.
         [888b65b4bc5e7fcbbb967023300cd5d44dba1950]
      xen/time: Fix kasprintf splat when allocating timer%d IRQ line.
         [7918c92ae9638eb8a6ec18e2b4a0de84557cccc8]

Konstantin Khlebnikov (1):
      e1000e: fix runtime power management transitions
         [66148babe728f3e00e13c56f6b0ecf325abd80da]

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume
         [c6cc25fda58da8685ecef3f179adc7b99c8253b2]

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat
         [f7b0e1055574ce06ab53391263b4e205bf38daf3]

Li Zefan (1):
      cgroup: fix an off-by-one bug which may trigger BUG_ON()
         [3ac1707a13a3da9cfc8f242a15b2fae6df2c5f88]

Linus Torvalds (2):
      s390: move dummy io_remap_pfn_range() to asm/pgtable.h
         [4f2e29031e6c67802e7370292dd050fd62f337ee]
      tty: fix up atime/mtime mess, take three
         [b0b885657b6c8ef63a46bc9299b2a7715d19acde]

Linus Walleij (1):
      ARM: u300: fix ages old copy/paste bug
         [0259d9eb30d003af305626db2d8332805696e60d]

Maxime Ripard (1):
      ARM: at91: Fix typo in restart code panic message
         [e7619459d47a673af3433208a42f583af920e9db]

Mel Gorman (1):
      mm: swap: mark swap pages writeback before queueing for direct IO
         [0cdc444a67ccdbd58bfbcba865cb17a9f17a7691]

Michael Ellerman (1):
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
         [6747e83235caecd30b186d1282e4eba7679f81b7]

Michael Grzeschik (2):
      usb: chipidea: udc: fix memory leak in _ep_nuke
         [7ca2cd291fd84ae499390f227a255ccba2780a81]
      usb: chipidea: udc: fix memory access of shared memory on armv5 machines
         [a9c174302b1590ef3ead485d804a303c5f89174b]

Michael Neuling (1):
      powerpc: Add isync to copy_and_flush
         [29ce3c5073057991217916abc25628e906911757]

Ming Lei (1):
      sysfs: fix use after free in case of concurrent read/write and readdir
         [f7db5e7660b122142410dcf36ba903c73d473250]

Namhyung Kim (3):
      tracing: Reset ftrace_graph_filter_enabled if count is zero
         [9f50afccfdc15d95d7331acddcb0f7703df089ae]
      tracing: Check return value of tracing_init_dentry()
         [ed6f1c996bfe4b6e520cf7a74b51cd6988d84420]
      tracing: Fix off-by-one on allocating stat->pages
         [39e30cd1537937d3c00ef87e865324e981434e5b]

NeilBrown (1):
      md: bad block list should default to disabled.
         [486adf72ccc0c235754923d47a2270c5dcb0c98b]

Oleg Nesterov (1):
      exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
         [e56fb2874015370e3b7f8d85051f6dce26051df9]

Patrick McHardy (1):
      netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet
         [3a7b21eaf4fb3c971bdb47a98f570550ddfe4471]

Paulo Zanoni (1):
      drm/i915: set CPT FDI RX polarity bits based on VBT
         [3f704fa2778d3fe45e6529825a5c7a8bcbc686f4]

Peter Zijlstra (2):
      perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
         [7cc23cd6c0c7d7f4bee057607e7ce01568925717]
      perf/x86/intel/lbr: Fix LBR filter
         [6e15eb3ba6c0249c9e8c783517d131b47db995ca]

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards
         [836dc2fe89c968c10cada87e0dfae6626f8f9da3]

Prarit Bhargava (1):
      hrtimer: Add expiry time overflow check in hrtimer_interrupt
         [8f294b5a139ee4b75e890ad5b443c93d1e558a8b]

Rafael J. Wysocki (2):
      PCI/PM: Clear state_saved during suspend
         [82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765]
      PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
         [769ba7212f2059ca9fe0c73371e3d415c8c1c529]

Richard Cochran (1):
      gianfar: do not advertise any alarm capability.
         [cd4baaaa04b4aaa3b0ec4d13a6f3d203b92eadbd]

Robin Holt (1):
      ipc: sysv shared memory limited to 8TiB
         [d69f3bad4675ac519d41ca2b11e1c00ca115cecd]

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.
         [a83d6755814e4614ba77e15d82796af0f695c6b8]

Shaohua Li (1):
      MD: ignore discard request for hard disks of hybid raid1/raid10 array
         [32f9f570d04461a41bdcd5c1d93b41ebc5ce182a]

Shengzhou Liu (1):
      usb: remove redundant tdi_reset
         [61ac6ac8d662ac7ac67c864954d39d1b19948354]

Stanislaw Gruszka (1):
      iwlwifi: fix freeing uninitialized pointer
         [3309ccf7fcebceef540ebe90c65d2f94d745a45b]

Stefan Bader (1):
      r8169: fix 8168evl frame padding.
         [e5195c1f31f399289347e043d6abf3ffa80f0005]

Stefani Seibold (1):
      USB: add ftdi_sio USB ID for GDM Boost V1.x
         [58f8b6c4fa5a13cb2ddb400e26e9e65766d71e38]

Stephan Schreiber (2):
      Wrong asm register contraints in the kvm implementation
         [de53e9caa4c6149ef4a78c2f83d7f5b655848767]
      Wrong asm register contraints in the futex implementation
         [136f39ddc53db3bcee2befbe323a56d4fbf06da8]

Steven A. Falco (1):
      i2c: xiic: must always write 16-bit words to TX_FIFO
         [c39e8e4354ce4daf23336de5daa28a3b01f00aa6]

Steven Rostedt (Red Hat) (4):
      tracing: Fix ftrace_dump()
         [7fe70b579c9e3daba71635e31b6189394e7b79d3]
      tracing: Remove most or all of stack tracer stack size from stack_max_size
         [4df297129f622bdc18935c856f42b9ddd18f9f28]
      tracing: Fix stack tracer with fentry use
         [d4ecbfc49b4b1d4b597fb5ba9e4fa25d62f105c5]
      tracing: Use stack of calling function for stack tracer
         [87889501d0adfae10e3b0f0e6f2d7536eed9ae84]

Takashi Iwai (2):
      ALSA: usb-audio: Fix autopm error during probing
         [60af3d037eb8c670dcce31401501d1271e7c5d95]
      ALSA: usb-audio: Fix missing autopm for MIDI input
         [f5f165418cabf2218eb466c0e94693b8b1aee88b]

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors
         [bdbc5d0c60f3e9de3eeccf1c1a18bdc11dca62cc]

Theodore Ts'o (4):
      ext4: add check for inodes_count overflow in new resize ioctl
         [3f8a6411fbada1fa482276591e037f3b1adcf55b]
      ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
         [7f3e3c7cfcec148ccca9c0dd2dbfd7b00b7ac10f]
      ext4: fix online resizing for ext3-compat file systems
         [c5c72d814cf0f650010337c73638b25e6d14d2d4]
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
         [d76a3a77113db020d9bb1e894822869410450bd9]

Thomas Gleixner (1):
      clockevents: Set dummy handler on CPU_DEAD shutdown
         [6f7a05d7018de222e40ca003721037a530979974]

Tony Luck (1):
      Fix initialization of CMCI/CMCP interrupts
         [d303e9e98fce56cdb3c6f2ac92f626fc2bd51c77]

Tormod Volden (1):
      usb-storage: CY7C68300A chips do not support Cypress ATACB
         [671b4b2ba9266cbcfe7210a704e9ea487dcaa988]

Trond Myklebust (2):
      NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall
         [8b6cc4d6f841d31f72fe7478453759166d366274]
      LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot
         [1dfd89af8697a299e7982ae740d4695ecd917eef]

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree
         [7122beeee7bc1757682049780179d7c216dd1c83]

Vince Weaver (1):
      perf/x86/intel: Add support for IvyBridge model 58 Uncore
         [9a6bc14350b130427725f33e371e86212fa56c85]

Yinghai Lu (1):
      PCI / ACPI: Don't query OSC support with all possible controls
         [545d6e189a41c94c11f55045a771118eccc9d9eb]

Yogesh Ashok Powar (2):
      mwifiex: Call pci_release_region after calling pci_disable_device
         [5b0d9b218b74042ff72bf4bfda6eeb2e4bf98397]
      mwifiex: Use pci_release_region() instead of a pci_release_regions()
         [c380aafb77b7435d010698fe3ca6d3e1cd745fde]

Zhao Hongjiang (1):
      inotify: invalid mask should return a error number but not set it
         [04df32fa10ab9a6f0643db2949d42efc966bc844]

fanchaoting (1):
      nfsd: don't run get_file if nfs4_preprocess_stateid_op return error
         [b022032e195ffca83d7002d6b84297d796ed443b]

----
 arch/arm/configs/at91sam9g45_defconfig        |    1 -
 arch/arm/include/asm/pgtable.h                |    9 +++
 arch/arm/mach-at91/setup.c                    |    2 +-
 arch/arm/mach-omap2/cpuidle34xx.c             |    5 +-
 arch/arm/mach-u300/include/mach/u300-regs.h   |    2 +-
 arch/avr32/configs/favr-32_defconfig          |    1 -
 arch/avr32/configs/merisc_defconfig           |    1 -
 arch/ia64/include/asm/futex.h                 |    5 +-
 arch/ia64/include/asm/mca.h                   |    1 +
 arch/ia64/kernel/irq.c                        |    8 +++
 arch/ia64/kernel/mca.c                        |   37 +++++++----
 arch/ia64/kvm/vtlb.c                          |    2 +-
 arch/powerpc/include/asm/ppc-opcode.h         |    4 ++
 arch/powerpc/kernel/head_64.S                 |    1 +
 arch/powerpc/kernel/traps.c                   |   10 ++-
 arch/powerpc/mm/numa.c                        |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c     |    1 +
 arch/s390/include/asm/pgtable.h               |    4 ++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c    |   27 +++++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   17 +++---
 arch/x86/kernel/irq.c                         |    4 --
 arch/x86/kvm/emulate.c                        |    4 ++
 arch/x86/mm/init.c                            |    5 ++
 arch/x86/xen/enlighten.c                      |    5 +-
 arch/x86/xen/smp.c                            |    2 +
 arch/x86/xen/time.c                           |    6 +-
 drivers/acpi/pci_root.c                       |    4 +-
 drivers/ata/libata-acpi.c                     |   45 ++++++++------
 drivers/char/tpm/tpm.c                        |   32 ++++++++--
 drivers/char/tpm/tpm.h                        |    2 +
 drivers/gpu/drm/ast/ast_drv.h                 |    2 +
 drivers/gpu/drm/ast/ast_fb.c                  |   43 ++++++++++++-
 drivers/gpu/drm/ast/ast_ttm.c                 |    2 +-
 drivers/gpu/drm/cirrus/cirrus_drv.h           |    2 +
 drivers/gpu/drm/cirrus/cirrus_fbdev.c         |   38 +++++++++++-
 drivers/gpu/drm/cirrus/cirrus_ttm.c           |    2 +-
 drivers/gpu/drm/drm_gem.c                     |    4 +-
 drivers/gpu/drm/drm_prime.c                   |   76 ++++++++++++-----------
 drivers/gpu/drm/gma500/psb_irq.c              |    2 +-
 drivers/gpu/drm/i915/i915_drv.h               |    2 +
 drivers/gpu/drm/i915/i915_gem.c               |   28 +++++++--
 drivers/gpu/drm/i915/i915_gem_context.c       |    7 +++
 drivers/gpu/drm/i915/i915_gem_stolen.c        |   81 +++++++++++++------------
 drivers/gpu/drm/i915/i915_reg.h               |    1 +
 drivers/gpu/drm/i915/intel_bios.c             |    6 +-
 drivers/gpu/drm/i915/intel_bios.h             |    4 +-
 drivers/gpu/drm/i915/intel_dvo.c              |   13 +++-
 drivers/gpu/drm/i915/intel_lvds.c             |    8 +++
 drivers/gpu/drm/i915/intel_pm.c               |    9 ++-
 drivers/gpu/drm/mgag200/mgag200_drv.h         |    2 +
 drivers/gpu/drm/mgag200/mgag200_fb.c          |   43 ++++++++++++-
 drivers/gpu/drm/mgag200/mgag200_ttm.c         |    4 +-
 drivers/gpu/drm/radeon/atom.c                 |    6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |    3 +
 drivers/gpu/drm/radeon/evergreen.c            |   66 +++++++++++++++++---
 drivers/gpu/drm/radeon/ni.c                   |    8 ++-
 drivers/gpu/drm/radeon/nid.h                  |    4 ++
 drivers/gpu/drm/radeon/r100.c                 |   77 +++++++++++++++--------
 drivers/gpu/drm/radeon/r600_hdmi.c            |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c      |   21 ++++---
 drivers/gpu/drm/radeon/radeon_kms.c           |    4 ++
 drivers/gpu/drm/radeon/radeon_pm.c            |    6 +-
 drivers/gpu/drm/radeon/rs600.c                |   54 ++++++++++++++---
 drivers/gpu/drm/radeon/si.c                   |    3 +-
 drivers/gpu/drm/radeon/sid.h                  |    2 +
 drivers/i2c/busses/i2c-xiic.c                 |    6 +-
 drivers/md/md.c                               |    9 +--
 drivers/md/raid1.c                            |    7 ++-
 drivers/md/raid10.c                           |    6 ++
 drivers/mfd/adp5520.c                         |    8 ++-
 drivers/mmc/core/mmc.c                        |    2 +-
 drivers/mmc/host/Kconfig                      |   10 ---
 drivers/mmc/host/atmel-mci.c                  |   16 +++--
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    3 +-
 drivers/net/ethernet/ibm/ibmveth.c            |   23 +++----
 drivers/net/ethernet/intel/e1000e/netdev.c    |   78 ++++++------------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   10 +++
 drivers/net/ethernet/realtek/r8169.c          |    9 +++
 drivers/net/wireless/iwlwifi/dvm/debugfs.c    |   16 ++---
 drivers/net/wireless/iwlwifi/dvm/sta.c        |    5 +-
 drivers/net/wireless/mwifiex/pcie.c           |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c       |   10 ++-
 drivers/pci/pci-driver.c                      |    4 ++
 drivers/pci/pci.c                             |   12 ++--
 drivers/rtc/rtc-cmos.c                        |    4 +-
 drivers/s390/char/sclp_cmd.c                  |    4 +-
 drivers/tty/pty.c                             |    3 +
 drivers/tty/serial/serial_core.c              |    4 ++
 drivers/tty/tty_io.c                          |    4 +-
 drivers/usb/chipidea/udc.c                    |    8 +++
 drivers/usb/chipidea/udc.h                    |    4 +-
 drivers/usb/core/devio.c                      |    2 +
 drivers/usb/host/ehci-hcd.c                   |    3 -
 drivers/usb/host/xhci-ring.c                  |   23 ++++---
 drivers/usb/misc/appledisplay.c               |    1 +
 drivers/usb/serial/ftdi_sio.c                 |   23 ++++---
 drivers/usb/serial/ftdi_sio_ids.h             |    4 +-
 drivers/usb/serial/option.c                   |    8 +++
 drivers/usb/storage/cypress_atacb.c           |   16 ++++-
 fs/autofs4/expire.c                           |    9 ---
 fs/btrfs/delayed-ref.c                        |   24 +++++---
 fs/dcache.c                                   |    4 +-
 fs/exec.c                                     |    7 ++-
 fs/ext4/Kconfig                               |    3 +-
 fs/ext4/ext4_jbd2.h                           |    6 +-
 fs/ext4/fsync.c                               |    3 +-
 fs/ext4/inode.c                               |   11 ++--
 fs/ext4/mballoc.c                             |    8 +--
 fs/ext4/mmp.c                                 |    2 +-
 fs/ext4/resize.c                              |    6 ++
 fs/ext4/super.c                               |    7 ++-
 fs/fscache/stats.c                            |    2 +-
 fs/jbd2/commit.c                              |   50 ++++++++-------
 fs/jbd2/journal.c                             |   31 ++++++++++
 fs/lockd/clntlock.c                           |    3 +
 fs/nfs/nfs4proc.c                             |    6 ++
 fs/nfsd/nfs4proc.c                            |    8 +--
 fs/nfsd/nfs4state.c                           |    8 +--
 fs/nfsd/nfs4xdr.c                             |   19 ++----
 fs/notify/inotify/inotify_user.c              |    6 +-
 fs/sysfs/dir.c                                |   15 +++--
 include/asm-generic/pgtable.h                 |   10 +++
 include/drm/drmP.h                            |    5 +-
 include/drm/drm_pciids.h                      |    5 ++
 include/linux/ipc_namespace.h                 |    2 +-
 include/linux/jbd2.h                          |    2 +
 include/linux/sched.h                         |   18 ++----
 ipc/shm.c                                     |    2 +-
 kernel/audit_tree.c                           |    2 +-
 kernel/cgroup.c                               |    2 +-
 kernel/hrtimer.c                              |    6 ++
 kernel/time/tick-broadcast.c                  |    4 ++
 kernel/time/tick-common.c                     |    1 +
 kernel/trace/ftrace.c                         |    5 +-
 kernel/trace/trace.c                          |   64 +++++++++----------
 kernel/trace/trace_selftest.c                 |    9 +--
 kernel/trace/trace_stack.c                    |   76 ++++++++++++++++++++---
 kernel/trace/trace_stat.c                     |    2 +
 mm/mmap.c                                     |    4 +-
 mm/page_io.c                                  |   17 ++++++
 net/ipv4/netfilter/ipt_rpfilter.c             |    8 ++-
 net/ipv6/netfilter/ip6t_rpfilter.c            |    8 ++-
 net/netfilter/ipset/ip_set_core.c             |    3 +-
 net/netfilter/ipset/ip_set_list_set.c         |   10 ++-
 net/netfilter/ipvs/ip_vs_pe_sip.c             |    6 +-
 net/netfilter/nf_conntrack_helper.c           |    4 +-
 net/netfilter/nf_conntrack_netlink.c          |    3 +
 net/netfilter/nf_conntrack_sip.c              |    2 +-
 net/wireless/reg.c                            |    2 +-
 sound/soc/codecs/max98088.c                   |    2 +-
 sound/usb/card.c                              |    4 +-
 sound/usb/card.h                              |    1 +
 sound/usb/midi.c                              |   69 +++++++++++----------
 sound/usb/pcm.c                               |    2 +-
 sound/usb/quirks.c                            |    1 +
 sound/usb/stream.c                            |    9 +++
 156 files changed, 1246 insertions(+), 597 deletions(-)
