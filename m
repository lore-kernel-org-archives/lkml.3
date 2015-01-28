Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbbA2Jq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:46:57 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44823 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752527AbbA2JEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/176] 3.12.37-stable review
Date: Wed, 28 Jan 2015 15:29:35 +0100
Message-Id: <cover.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.37 release.
There are 176 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 30 15:29:12 CET 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.37-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Ahmed S. Darwish (3):
  can: kvaser_usb: Don't free packets when tight on URBs
  can: kvaser_usb: Reset all URB tx contexts upon channel close
  can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels

Akash Goel (1):
  drm/i915: Resolving the memory region conflict for Stolen area

Al Viro (2):
  move d_rcu from overlapping d_child to overlapping d_alias
  deal with deadlock in d_walk()

Alan Stern (1):
  USB: EHCI: fix initialization bug in iso_stream_schedule()

Alex Deucher (5):
  drm/radeon: fix typo in CI dpm disable
  drm/radeon: work around a hw bug in MGCG on CIK
  drm/radeon: check the right ring in radeon_evict_flags()
  drm/radeon: properly filter DP1.2 4k modes on non-DP1.2 hw
  drm/radeon: add si dpm quirk list

Alex Williamson (1):
  driver core: Fix unbalanced device reference in drivers_probe

Alexandre Demers (1):
  x86/tsc: Change Fast TSC calibration failed from error to info

Amit Virdi (2):
  usb: dwc3: gadget: Fix TRB preparation during SG
  usb: dwc3: gadget: Stop TRB preparation after limit is reached

Andrew Jackson (1):
  ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Andrew Lunn (1):
  bus: mvebu-mbus: fix support of MBus window 13

Andy Lutomirski (5):
  x86_64, vdso: Fix the vdso address randomization algorithm
  x86, vdso: Use asm volatile in __getcpu
  x86, tls, ldt: Stop checking lm in LDT_empty
  x86, tls: Interpret an all-zero struct user_desc as "no segment"
  x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and
    sync_regs

Andy Shevchenko (1):
  sata_dwc_460ex: fix resource leak on error path

Anton Blanchard (1):
  powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Arik Nemtsov (1):
  cfg80211: avoid mem leak on driver hint set

Arseny Solokha (1):
  OHCI: add a quirk for ULi M5237 blocking on reset

Benjamin Coddington (1):
  nfsd4: fix xdr4 inclusion of escaped char

Brian King (1):
  ipr: wait for aborted command responses

Brian Norris (1):
  mtd: tests: abort torturetest on erase errors

Bryan O'Donoghue (1):
  x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

Chris Wilson (3):
  drm/i915: Invalidate media caches on gen7
  drm/i915: Force the CS stall for invalidate flushes
  drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Christian Riesch (1):
  n_tty: Fix read_buf race condition, increment read_head after pushing
    data

Dan Carpenter (7):
  HID: roccat: potential out of bounds in pyra_sysfs_write_settings()
  ALSA: hda - using uninitialized data
  ceph: do_sync is never initialized
  netfilter: ipset: small potential read beyond the end of buffer
  decompress_bunzip2: off by one in get_next_block()
  ipvs: uninitialized data with IP_VS_IPV6
  USB: adutux: NULL dereferences on disconnect

Daniel Borkmann (1):
  x86, um: actually mark system call tables readonly

Daniel Mack (1):
  ALSA: snd-usb: re-order some quirk entries

Daniel Vetter (1):
  drm/i915: Don't complain about stolen conflicts on gen3

David Jeffery (1):
  libata: prevent HSM state change race between ISR and PIO

David Miller (1):
  netlink: Always copy on mmap TX.

David Peterson (1):
  USB: cp210x: add IDs for CEL USB sticks and MeshWorks devices

Dmitry Torokhov (1):
  Input: I8042 - add Acer Aspire 7738 to the nomux list

Dmitry Voytik (1):
  ARM: imx6q: drop unnecessary semicolon

Dominique Leuenberger (1):
  hp_accel: Add support for HP ZBook 15

Eduard Gilmutdinov (1):
  ALSA: usb-audio: Add support for Focusrite Saffire 6 USB

Eric Dumazet (1):
  alx: fix alx_poll()

Fabio Estevam (2):
  ARM: dts: imx25: Fix the SPI1 clocks
  ARM: dts: imx25: Fix PWM "per" clocks

Felipe Balbi (1):
  net: ethernet: cpsw: fix hangs with interrupts

Felix Fietkau (3):
  ath9k_hw: fix hardware queue allocation
  ath9k: fix BE/BK queue order
  ath5k: fix hardware queue index assignment

Frank Schaefer (1):
  af9005: fix kernel panic on init if compiled without IR

Gary Bisson (1):
  ARM: clk-imx6q: fix video divider for rev T0 1.0

Geert Uytterhoeven (1):
  ARM: shmobile: sh73a0 legacy: Set .control_parent for all irqpin
    instances

Giedrius Statkevičius (1):
  HID: Add a new id 0x501a for Genius MousePen i608X

Govindarajulu Varadarajan (1):
  enic: fix rx skb checksum

Greg Kroah-Hartman (1):
  USB: cdc-acm: check for valid interfaces

Guo Zeng (1):
  drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in
    probe

Gwendal Grignou (1):
  HID: i2c-hid: prevent buffer overflow in early IRQ

Hans Holmberg (1):
  gpiolib: of: Correct error handling in of_get_named_gpiod_flags

Herbert Xu (1):
  tcp: Do not apply TSO segment limit to non-TSO packets

Jarkko Nikula (1):
  ASoC: max98090: Fix ill-defined sidetone route

Jason Lee Cragg (1):
  ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210

Jay Vosburgh (1):
  net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jean-Baptiste Maneyrol (1):
  HID: i2c-hid: fix race condition reading reports

Jens Axboe (1):
  genhd: check for int overflow in disk_expand_part_tbl()

Jerry Hoemann (1):
  fsnotify: next_i is freed during fsnotify_unmount_inodes.

Jesper Dangaard Brouer (1):
  ipvs: correct usage/allocation of seqadj ext in ipvs

Jiang Liu (1):
  iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Jim Lin (1):
  pinctrl: Fix two deadlocks

Jiri Jaburek (1):
  ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Jiri Olsa (3):
  perf/x86/intel/uncore: Make sure only uncore events are collected
  perf: Fix events installation during moving group
  perf session: Do not fail on processing out of order event

Jiri Pirko (1):
  team: avoid possible underflow of count_pending value for notify_peers
    and mcast_rejoin

Joe Thornber (2):
  dm cache: share cache-metadata object across inactive and active DM
    tables
  dm cache: fix problematic dual use of a single migration count
    variable

Johan Hovold (6):
  gpio: fix memory and reference leaks in gpiochip_add error path
  USB: keyspan: fix null-deref at probe
  USB: console: fix uninitialised ldisc semaphore
  USB: console: fix potential use after free
  gpio: sysfs: fix gpio-chip device-attribute leak
  gpio: sysfs: fix gpio device-attribute leak

Johannes Berg (1):
  scripts/kernel-doc: don't eat struct members with __aligned

Junxiao Bi (1):
  ocfs2: fix journal commit deadlock

Jussi Kivilinna (1):
  crypto: sha256_ssse3 - use correct module alias for sha224

K. Y. Srinivasan (1):
  x86, hyperv: Mark the Hyper-V clocksource as being continuous

Karl Relton (1):
  HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO
    keyboard

Kees Cook (3):
  x86, boot: Skip relocs when load address unchanged
  crypto: prefix module autoloading with "crypto-"
  crypto: include crypto- module prefix in template

Kent Overstreet (1):
  bcache: Make sure to pass GFP_WAIT to mempool_alloc()

Konstantin Khlebnikov (1):
  ACPI / osl: speedup grace period in acpi_os_map_cleanup

Krzysztof Kozlowski (1):
  mmc: sdhci: Fix sleep in atomic after inserting SD card

Lars Ellenberg (1):
  drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Lars-Peter Clausen (1):
  ASoC: sigmadsp: Refuse to load firmware files with a non-supported
    version

Lennart Sorensen (1):
  ARM: omap5/dra7xx: Fix frequency typos

Linus Torvalds (2):
  mm: propagate error from stack expansion even for guard page
  mm: Don't count the stack guard page towards RLIMIT_STACK

Long Li (1):
  storvsc: ring buffer failures may result in I/O freeze

Martin K. Petersen (1):
  scsi: blacklist RSOC for Microsoft iSCSI target devices

Mathias Krause (1):
  crypto: add missing crypto module aliases

Mauro Carvalho Chehab (2):
  sound: simplify au0828 quirk table
  sound: Update au0828 quirks table

Michael Karcher (1):
  scripts/recordmcount.pl: There is no -m32 gcc option on Super-H
    anymore

Michal Hocko (1):
  mm: get rid of radix tree gfp mask for pagecache_get_page

Mugunthan V N (1):
  drivers: net: cpsw: fix multicast flush in dual emac mode

Myron Stowe (1):
  PCI: Restore detection of read-only BARs

NeilBrown (1):
  md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying
    wants.

Nicholas Bellinger (2):
  iscsi-target: Fail connection on short sendmsg writes
  vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion

Nishanth Menon (1):
  ARM: OMAP4: PM: Only do static dependency configuration in
    omap4_init_static_deps

Oliver Hartkopp (1):
  can: dev: fix crtlmode_supported check

Oliver Neukum (1):
  cdc-acm: memory leak in error case

Paolo Bonzini (1):
  kvm: x86: drop severity of "generation wraparound" message

Paul Mackerras (1):
  powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle
    mode

Pavel Machek (1):
  Revert "ARM: 7830/1: delay: don't bother reporting bogomips in
    /proc/cpuinfo"

Prashant Sreedharan (1):
  tg3: tg3_disable_ints using uninitialized mailbox value to disable
    interrupts

Preston Fick (1):
  USB: cp210x: fix ID for production CEL MeshConnect USB Stick

Rasmus Villemoes (2):
  fs: nfsd: Fix signedness bug in compare_blob
  usb: musb: Fix a few off-by-one lengths

Richard Weinberger (3):
  UBI: Fix invalid vfree()
  UBI: Fix double free after do_sync_erase()
  um: Skip futex_atomic_cmpxchg_inatomic() test

Rob Herring (1):
  pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
  serial: samsung: wait for transfer completion before clock disable

Ryusuke Konishi (1):
  nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Sagi Grimberg (6):
  iscsi,iser-target: Initiate termination only once
  iser-target: Fix flush + disconnect completion handling
  iser-target: Parallelize CM connection establishment
  iser-target: Fix connected_handler + teardown flow race
  iser-target: Handle ADDR_CHANGE event for listener cm_id
  iser-target: Fix implicit termination of connections

Sakari Ailus (2):
  smiapp-pll: Correct clock debug prints
  smiapp: Take mutex during PLL update in sensor initialisation

Sasha Levin (3):
  time: settimeofday: Validate the values of tv from user
  time: adjtimex: Validate the ADJ_FREQUENCY values
  KEYS: close race between key lookup and freeing

Sebastian Andrzej Siewior (1):
  usb: musb: stuff leak of struct usb_hcd

Sjoerd Simons (1):
  mmc: sdhci: Don't signal the sdio irq if it's not setup

Sreekanth Reddy (2):
  Revert "[SCSI] mpt2sas: Remove phys on topology change."
  Revert "[SCSI] mpt3sas: Remove phys on topology change"

Srihari Vijayaraghavan (1):
  Input: i8042 - reset keyboard to fix Elantech touchpad detection

Steev Klimaszewski (1):
  Add USB_EHCI_EXYNOS to multi_v7_defconfig

Stefan Roese (1):
  spi: fsl: Fix problem with multi message transfers

Stephane Grosjean (2):
  can: peak_usb: fix cleanup sequence order in case of error during init
  can: peak_usb: fix memset() usage

Steven Rostedt (Red Hat) (1):
  ftrace/jprobes/x86: Fix conflict between jprobes and function graph
    tracing

Takashi Iwai (2):
  ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC
    codecs
  uvcvideo: Fix destruction order in uvc_delete()

Tejun Heo (1):
  writeback: fix a subtle race condition in I_DIRTY clearing

Tetsuo Handa (1):
  drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Gleixner (2):
  tick/powerclamp: Remove tick_nohz_idle abuse
  genirq: Prevent proc race against freeing of irq descriptors

Thomas Graf (2):
  netlink: Don't reorder loads/stores before marking mmap netlink frame
    as available
  net: Reset secmark when scrubbing packet

Thomas Hellstrom (1):
  drm/vmwgfx: Fix fence event code

Thomas Petazzoni (1):
  ARM: mvebu: disable I/O coherency on non-SMP situations on Armada
    370/375/38x/XP

Tobias Jakobi (1):
  clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

Tomi Valkeinen (1):
  video/logo: prevent use of logos after they have been freed

Tony Lindgren (1):
  pstore-ram: Allow optional mapping with pgprot_noncached

Toshiaki Makita (1):
  net: Fix stacked vlan offload features computation

Trond Myklebust (2):
  NFSv4.1: Fix client id trunking on Linux
  LOCKD: Fix a race when initialising nlmsvc_timeout

Vitaly Kuznetsov (1):
  Drivers: hv: vmbus: Fix a race condition when unregistering a device

Vlastimil Babka (1):
  mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled
    process being killed

Wei Yang (1):
  vfio-pci: Fix the check on pci device type in vfio_pci_probe()

stephen hemminger (1):
  in6: fix conflict with glibc

 Documentation/kernel-parameters.txt             |   1 +
 Documentation/ramoops.txt                       |  13 +-
 arch/arm/boot/dts/imx25.dtsi                    |  10 +-
 arch/arm/configs/multi_v7_defconfig             |   1 +
 arch/arm/crypto/aes_glue.c                      |   4 +-
 arch/arm/crypto/sha1_glue.c                     |   2 +-
 arch/arm/kernel/setup.c                         |   9 +
 arch/arm/kernel/smp.c                           |  13 +-
 arch/arm/mach-imx/clk-imx6q.c                   |   4 +-
 arch/arm/mach-mvebu/coherency.c                 |  26 ++
 arch/arm/mach-omap2/pm44xx.c                    |  29 +-
 arch/arm/mach-omap2/timer.c                     |   8 +-
 arch/arm/mach-shmobile/setup-sh73a0.c           |   3 +
 arch/powerpc/crypto/sha1.c                      |   3 +-
 arch/powerpc/include/asm/reg.h                  |   1 +
 arch/powerpc/kernel/idle_power7.S               |  16 ++
 arch/powerpc/kernel/udbg_16550.c                |   6 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |   2 +-
 arch/s390/crypto/aes_s390.c                     |   2 +-
 arch/s390/crypto/des_s390.c                     |   4 +-
 arch/s390/crypto/ghash_s390.c                   |   2 +-
 arch/s390/crypto/sha1_s390.c                    |   2 +-
 arch/s390/crypto/sha256_s390.c                  |   4 +-
 arch/s390/crypto/sha512_s390.c                  |   4 +-
 arch/sparc/crypto/aes_glue.c                    |   2 +-
 arch/sparc/crypto/camellia_glue.c               |   2 +-
 arch/sparc/crypto/crc32c_glue.c                 |   2 +-
 arch/sparc/crypto/des_glue.c                    |   2 +-
 arch/sparc/crypto/md5_glue.c                    |   2 +-
 arch/sparc/crypto/sha1_glue.c                   |   2 +-
 arch/sparc/crypto/sha256_glue.c                 |   4 +-
 arch/sparc/crypto/sha512_glue.c                 |   4 +-
 arch/um/Kconfig.common                          |   1 +
 arch/x86/Kconfig                                |   6 +-
 arch/x86/boot/compressed/misc.c                 |   9 +-
 arch/x86/crypto/aes_glue.c                      |   4 +-
 arch/x86/crypto/aesni-intel_glue.c              |   2 +-
 arch/x86/crypto/blowfish_glue.c                 |   4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c      |   4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c       |   4 +-
 arch/x86/crypto/camellia_glue.c                 |   4 +-
 arch/x86/crypto/cast5_avx_glue.c                |   2 +-
 arch/x86/crypto/cast6_avx_glue.c                |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c             |   4 +-
 arch/x86/crypto/crc32c-intel_glue.c             |   4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c         |   4 +-
 arch/x86/crypto/fpu.c                           |   3 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c      |   2 +-
 arch/x86/crypto/salsa20_glue.c                  |   4 +-
 arch/x86/crypto/serpent_avx2_glue.c             |   4 +-
 arch/x86/crypto/serpent_avx_glue.c              |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c             |   2 +-
 arch/x86/crypto/sha1_ssse3_glue.c               |   2 +-
 arch/x86/crypto/sha256_ssse3_glue.c             |   4 +-
 arch/x86/crypto/sha512_ssse3_glue.c             |   4 +-
 arch/x86/crypto/twofish_avx_glue.c              |   2 +-
 arch/x86/crypto/twofish_glue.c                  |   4 +-
 arch/x86/crypto/twofish_glue_3way.c             |   4 +-
 arch/x86/include/asm/desc.h                     |  20 +-
 arch/x86/include/asm/vsyscall.h                 |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                  |   1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c   |  22 +-
 arch/x86/kernel/kprobes/core.c                  |  20 +-
 arch/x86/kernel/tls.c                           |  25 +-
 arch/x86/kernel/traps.c                         |   4 +-
 arch/x86/kernel/tsc.c                           |   2 +-
 arch/x86/kvm/mmu.c                              |   2 +-
 arch/x86/um/sys_call_table_32.c                 |   2 +-
 arch/x86/um/sys_call_table_64.c                 |   2 +-
 arch/x86/vdso/vma.c                             |  43 ++-
 block/genhd.c                                   |  11 +-
 crypto/842.c                                    |   1 +
 crypto/aes_generic.c                            |   3 +-
 crypto/algapi.c                                 |   4 +-
 crypto/ansi_cprng.c                             |   3 +-
 crypto/anubis.c                                 |   1 +
 crypto/api.c                                    |   4 +-
 crypto/arc4.c                                   |   1 +
 crypto/authenc.c                                |   1 +
 crypto/authencesn.c                             |   1 +
 crypto/blowfish_generic.c                       |   3 +-
 crypto/camellia_generic.c                       |   3 +-
 crypto/cast5_generic.c                          |   3 +-
 crypto/cast6_generic.c                          |   3 +-
 crypto/cbc.c                                    |   1 +
 crypto/ccm.c                                    |   5 +-
 crypto/chainiv.c                                |   1 +
 crypto/cmac.c                                   |   1 +
 crypto/crc32.c                                  |   1 +
 crypto/crct10dif_generic.c                      |   3 +-
 crypto/cryptd.c                                 |   1 +
 crypto/crypto_null.c                            |   6 +-
 crypto/ctr.c                                    |   3 +-
 crypto/cts.c                                    |   1 +
 crypto/deflate.c                                |   2 +-
 crypto/des_generic.c                            |   7 +-
 crypto/ecb.c                                    |   1 +
 crypto/eseqiv.c                                 |   1 +
 crypto/fcrypt.c                                 |   1 +
 crypto/gcm.c                                    |   7 +-
 crypto/ghash-generic.c                          |   3 +-
 crypto/hmac.c                                   |   1 +
 crypto/khazad.c                                 |   1 +
 crypto/krng.c                                   |   3 +-
 crypto/lrw.c                                    |   1 +
 crypto/lz4.c                                    |   1 +
 crypto/lz4hc.c                                  |   1 +
 crypto/lzo.c                                    |   1 +
 crypto/md4.c                                    |   2 +-
 crypto/md5.c                                    |   1 +
 crypto/michael_mic.c                            |   1 +
 crypto/pcbc.c                                   |   1 +
 crypto/pcrypt.c                                 |   1 +
 crypto/rmd128.c                                 |   1 +
 crypto/rmd160.c                                 |   1 +
 crypto/rmd256.c                                 |   1 +
 crypto/rmd320.c                                 |   1 +
 crypto/salsa20_generic.c                        |   3 +-
 crypto/seed.c                                   |   1 +
 crypto/seqiv.c                                  |   1 +
 crypto/serpent_generic.c                        |   5 +-
 crypto/sha1_generic.c                           |   3 +-
 crypto/sha256_generic.c                         |   6 +-
 crypto/sha512_generic.c                         |   6 +-
 crypto/tea.c                                    |   5 +-
 crypto/tgr192.c                                 |   5 +-
 crypto/twofish_generic.c                        |   3 +-
 crypto/vmac.c                                   |   1 +
 crypto/wp512.c                                  |   5 +-
 crypto/xcbc.c                                   |   1 +
 crypto/xts.c                                    |   1 +
 crypto/zlib.c                                   |   1 +
 drivers/acpi/osl.c                              |   2 +-
 drivers/ata/libata-sff.c                        |  12 +
 drivers/ata/sata_dwc_460ex.c                    |  26 +-
 drivers/base/bus.c                              |   8 +-
 drivers/block/drbd/drbd_req.c                   |   1 +
 drivers/bus/mvebu-mbus.c                        |  13 +
 drivers/clocksource/exynos_mct.c                |   4 +-
 drivers/crypto/padlock-aes.c                    |   2 +-
 drivers/crypto/padlock-sha.c                    |   8 +-
 drivers/crypto/ux500/cryp/cryp_core.c           |   4 +-
 drivers/crypto/ux500/hash/hash_core.c           |   8 +-
 drivers/gpio/gpiolib-of.c                       |  10 +-
 drivers/gpio/gpiolib.c                          |  56 ++--
 drivers/gpu/drm/i915/i915_gem.c                 |   2 +-
 drivers/gpu/drm/i915/i915_gem_stolen.c          |  23 +-
 drivers/gpu/drm/i915/i915_reg.h                 |   1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c         |   3 +
 drivers/gpu/drm/radeon/atombios_dp.c            |   4 +
 drivers/gpu/drm/radeon/ci_dpm.c                 |   2 +-
 drivers/gpu/drm/radeon/cik.c                    |   3 +-
 drivers/gpu/drm/radeon/radeon_ttm.c             |   2 +-
 drivers/gpu/drm/radeon/si_dpm.c                 |  39 +++
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |  26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c        |  25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c           |  17 +-
 drivers/hid/hid-core.c                          |   1 +
 drivers/hid/hid-ids.h                           |   1 +
 drivers/hid/hid-input.c                         |   3 +
 drivers/hid/hid-kye.c                           |   4 +
 drivers/hid/hid-roccat-pyra.c                   |   8 +-
 drivers/hid/i2c-hid/i2c-hid.c                   |  14 +-
 drivers/hid/usbhid/hid-quirks.c                 |   1 +
 drivers/hv/channel_mgmt.c                       |  11 +-
 drivers/infiniband/ulp/isert/ib_isert.c         | 342 +++++++++++++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h         |   7 +-
 drivers/input/serio/i8042-x86ia64io.h           |  39 +++
 drivers/input/serio/i8042.c                     |  14 +
 drivers/iommu/intel-iommu.c                     |   8 +-
 drivers/md/bcache/btree.c                       |   2 +-
 drivers/md/dm-cache-metadata.c                  | 101 ++++++-
 drivers/md/dm-cache-target.c                    |  87 +++---
 drivers/md/raid5.c                              |   3 +-
 drivers/media/i2c/smiapp-pll.c                  |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c          |   2 +
 drivers/media/usb/au0828/au0828-cards.c         |   5 +
 drivers/media/usb/dvb-usb/af9005.c              |   3 +
 drivers/media/usb/uvc/uvc_driver.c              |   6 +-
 drivers/mmc/host/sdhci.c                        |  10 +-
 drivers/mtd/tests/torturetest.c                 |   4 +-
 drivers/mtd/ubi/upd.c                           |  10 +-
 drivers/mtd/ubi/wl.c                            |  10 +-
 drivers/net/can/dev.c                           |   8 +-
 drivers/net/can/usb/kvaser_usb.c                |  20 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c    |  17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c     |   3 +-
 drivers/net/ethernet/atheros/alx/main.c         |  24 +-
 drivers/net/ethernet/broadcom/tg3.c             |  34 +--
 drivers/net/ethernet/cisco/enic/enic_main.c     |  12 +-
 drivers/net/ethernet/ti/cpsw.c                  |  28 +-
 drivers/net/ethernet/ti/cpsw_ale.c              |  10 +-
 drivers/net/ethernet/ti/cpsw_ale.h              |   2 +-
 drivers/net/team/team.c                         |  16 +-
 drivers/net/wireless/ath/ath5k/qcu.c            |   8 +-
 drivers/net/wireless/ath/ath9k/hw.h             |   4 +-
 drivers/net/wireless/ath/ath9k/mac.c            |   9 +-
 drivers/pci/probe.c                             |   3 +
 drivers/pinctrl/core.c                          |   5 +-
 drivers/platform/x86/hp_accel.c                 |   1 +
 drivers/rtc/rtc-sirfsoc.c                       |  16 +-
 drivers/s390/crypto/ap_bus.c                    |   3 +-
 drivers/scsi/ipr.c                              |  92 +++++++
 drivers/scsi/ipr.h                              |   1 +
 drivers/scsi/mpt2sas/mpt2sas_transport.c        |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c        |   5 +-
 drivers/scsi/scsi_devinfo.c                     |   1 +
 drivers/scsi/storvsc_drv.c                      |   7 +-
 drivers/spi/spi-fsl-spi.c                       |  20 +-
 drivers/staging/lustre/lustre/llite/dcache.c    |   2 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
 drivers/staging/lustre/lustre/llite/namei.c     |   8 +-
 drivers/target/iscsi/iscsi_target_login.c       |   3 +
 drivers/target/iscsi/iscsi_target_util.c        |  26 +-
 drivers/thermal/intel_powerclamp.c              |   2 -
 drivers/tty/n_tty.c                             |   3 +-
 drivers/tty/serial/samsung.c                    |   4 +
 drivers/usb/class/cdc-acm.c                     |  10 +-
 drivers/usb/dwc3/gadget.c                       |   6 +-
 drivers/usb/host/ehci-sched.c                   |   8 +-
 drivers/usb/host/pci-quirks.c                   |  18 +-
 drivers/usb/misc/adutux.c                       |   5 -
 drivers/usb/musb/musb_cppi41.c                  |   4 +-
 drivers/usb/musb/musb_debugfs.c                 |  16 +-
 drivers/usb/musb/musb_host.c                    |   1 -
 drivers/usb/serial/console.c                    |  16 +-
 drivers/usb/serial/cp210x.c                     |   4 +-
 drivers/usb/serial/keyspan.c                    |  20 +-
 drivers/vfio/pci/vfio_pci.c                     |   4 +-
 drivers/vhost/scsi.c                            |  23 +-
 drivers/video/logo/logo.c                       |  17 +-
 fs/affs/amigaffs.c                              |   2 +-
 fs/autofs4/expire.c                             |  12 +-
 fs/autofs4/root.c                               |   2 +-
 fs/ceph/addr.c                                  |   2 +-
 fs/ceph/dir.c                                   |   8 +-
 fs/ceph/inode.c                                 |   6 +-
 fs/cifs/inode.c                                 |   2 +-
 fs/coda/cache.c                                 |   2 +-
 fs/dcache.c                                     |  83 +++---
 fs/debugfs/inode.c                              |   4 +-
 fs/exportfs/expfs.c                             |   2 +-
 fs/fs-writeback.c                               |  29 +-
 fs/libfs.c                                      |  12 +-
 fs/lockd/svc.c                                  |   8 +-
 fs/ncpfs/dir.c                                  |   2 +-
 fs/ncpfs/ncplib_kernel.h                        |   4 +-
 fs/nfs/getroot.c                                |   2 +-
 fs/nfs/nfs4client.c                             |  17 +-
 fs/nfsd/nfs4state.c                             |  15 +-
 fs/nfsd/nfs4xdr.c                               |   3 +
 fs/nilfs2/inode.c                               |  32 ++-
 fs/nilfs2/namei.c                               |  15 +-
 fs/notify/fsnotify.c                            |   4 +-
 fs/notify/inode_mark.c                          |  17 +-
 fs/ocfs2/aops.c                                 |  16 +-
 fs/ocfs2/dcache.c                               |   2 +-
 fs/proc/stat.c                                  |   2 +-
 fs/pstore/ram.c                                 |  13 +-
 fs/pstore/ram_core.c                            |  31 ++-
 include/linux/crypto.h                          |  13 +
 include/linux/dcache.h                          |   8 +-
 include/linux/kernel_stat.h                     |   1 +
 include/linux/mm.h                              |   2 +-
 include/linux/pagemap.h                         |  13 +-
 include/linux/pstore_ram.h                      |   4 +-
 include/linux/time.h                            |  13 +
 include/uapi/linux/in6.h                        |   3 +-
 include/uapi/linux/libc-compat.h                |   3 +
 kernel/cgroup.c                                 |   2 +-
 kernel/events/core.c                            |   4 +-
 kernel/irq/internals.h                          |   8 +
 kernel/irq/irqdesc.c                            |  52 ++++
 kernel/irq/proc.c                               |  22 +-
 kernel/time.c                                   |   4 +
 kernel/time/ntp.c                               |   7 +
 kernel/time/tick-sched.c                        |   2 -
 kernel/trace/trace.c                            |   4 +-
 kernel/trace/trace_events.c                     |   2 +-
 lib/decompress_bunzip2.c                        |   2 +-
 mm/filemap.c                                    |  20 +-
 mm/memory.c                                     |   4 +-
 mm/mmap.c                                       |   7 +-
 mm/vmscan.c                                     |  24 +-
 net/core/dev.c                                  |  14 +-
 net/core/skbuff.c                               |   1 +
 net/ipv4/tcp_output.c                           |   4 +-
 net/netfilter/ipset/ip_set_core.c               |   6 +
 net/netfilter/ipvs/ip_vs_ftp.c                  |  10 +-
 net/netfilter/ipvs/ip_vs_nfct.c                 |   6 +
 net/netlink/af_netlink.c                        |  54 ++--
 net/wireless/reg.c                              |   6 +-
 scripts/kernel-doc                              |   2 +-
 scripts/recordmcount.pl                         |   1 -
 security/keys/gc.c                              |   4 +-
 security/selinux/selinuxfs.c                    |   6 +-
 sound/pci/hda/hda_codec.c                       |   4 +-
 sound/pci/hda/patch_sigmatel.c                  |   4 +-
 sound/soc/codecs/max98090.c                     |   4 +-
 sound/soc/codecs/sigmadsp.c                     |   7 +
 sound/soc/dwc/designware_i2s.c                  |  14 +
 sound/usb/mixer.c                               |   1 +
 sound/usb/mixer_maps.c                          |  15 +-
 sound/usb/quirks-table.h                        | 326 ++++++++++------------
 sound/usb/quirks.c                              |   9 +-
 tools/perf/util/hist.h                          |   1 +
 tools/perf/util/session.c                       |   5 +-
 307 files changed, 2122 insertions(+), 1090 deletions(-)

-- 
2.2.2

