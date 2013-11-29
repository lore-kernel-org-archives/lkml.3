Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3K2Wk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:40:26 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45175 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K2WkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:40:20 -0500
MIME-Version: 1.0
Date: Fri, 29 Nov 2013 14:40:19 -0800
X-Google-Sender-Auth: UotI20u2sRZOyiouWosIPN7jwVU
Message-ID: <CA+55aFxfup6cT5PJF0VwBV3M1d_MM9u7+wejNVCq9xT+=KXYkA@mail.gmail.com>
Subject: Linux 3.13-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're back on the normal weekly schedule, although I'm planning on
eventually slipping back to a Sunday release schedule. In the
meantime, it's like Xmas every Friday! Or, perhaps more appropriately
for the date, Hanukkah.

Anyway, everything looks normal for an -rc2. Nothing hugely alarming,
lots of small fixes all over, and the statistics look normal too (just
over half drivers, the rest is one third arch updates, one third
Documentation, and one third misc - filesystems, kernel, crypto..)

Nothing particularly stands out. If you thought rc1 is too scary to
test, jump on in now. It's all good,

               Linus

---
Adam Borowski (1):
      powerpc/85xx: typo in dts: "interupt" (four devices)

Al Stone (1):
      ACPI / sleep: clean up compiler warning about uninitialized field

Al Viro (1):
      fix bogus path_put() of nd->root after some unlazy_walk() failures

Alex Hung (2):
      dell-wmi: Add KEY_MICMUTE to bios_to_linux_keycode
      hp-wmi: detect "2009 BIOS or later" flag by WMI 0x0d for wireless cmd

Alex Porosanu (7):
      crypto: caam - fix RNG state handle instantiation descriptor
      crypto: caam - fix hash, alg and rng registration if CAAM driver
not initialized
      crypto: caam - fix RNG4 instantiation
      crypto: caam - split RNG4 instantiation function
      crypto: caam - uninstantiate RNG state handle 0 if instantiated
by caam driver
      crypto: caam - fix RNG4 AAI defines
      crypto: caam - enable instantiation of all RNG4 state handles

Alexander Gordeev (1):
      ntb: Fix missed call to pci_enable_msix()

Alexandre Courbot (4):
      Documentation: gpiolib: document new interface
      gpiolib: fix find_chip_by_name()
      gpiolib: use dedicated flags for GPIO properties
      gpiolib: fix of_find_gpio() when OF not defined

Alistair Popple (1):
      ahci: add support for IBM Akebono platform device

Anton Blanchard (1):
      powerpc: allyesconfig should not select CONFIG_CPU_LITTLE_ENDIAN

Ard Biesheuvel (2):
      crypto: create generic version of ablk_helper
      crypto: move x86 to the generic version of ablk_helper

Axel Lin (2):
      gpio: tb10x: Set output value before setting direction to output
      gpio: ucb1400: Add MODULE_ALIAS

Ben Hutchings (1):
      hwrng: via-rng - Mark device ID table as __maybe_unused

Benjamin Herrenschmidt (1):
      powerpc/windfarm: Fix XServe G5 fan control Makefile issue

Benjamin Tissoires (3):
      HID: appleir: force input to be set
      HID: kye: Add report fixup for Genius Manticore Keyboard
      HID: kye: fix unresponsive keyboard

Bob Moore (3):
      ACPICA: Debug output: Do not emit function nesting level for kernel build.
      ACPICA: Add support to delete all objects attached to the root
namespace node.
      ACPICA: Update version to 20131115.

Catalin Marinas (4):
      arm64: dts: Reserve the memory used for secondary CPU release address
      arm64: Unmask asynchronous aborts when in kernel mode
      arm64: Use Normal NonCacheable memory for writecombine
      arm64: Move PTE_PROT_NONE higher up

Chao Bi (1):
      n_gsm: race between ld close and gsmtty open

Charles Keepax (1):
      regulator: arizona-micsupp: Correct wm5110 voltage selection

Chen Gang (1):
      arch/powerpc/kernel: Use %12.12s instead of %12s to avoid memory overflow

Daisuke HATAYAMA (1):
      ACPI / sysfs: Set file size for each exposed ACPI table

Dan Carpenter (7):
      Input: hp_sdc_rtc - unlock on error in hp_sdc_rtc_read_i8042timer()
      gpio: mvebu: make mvchip->irqbase signed for error handling
      gpio: msm: make msm_gpio.summary_irq signed for error handling
      gpio: rcar: NULL dereference on error in probe()
      Staging: comedi: pcl730: fix some bitwise vs logical AND bugs
      Staging: vt6655-6: potential NULL dereference in hostap_disable_hostapd()
      staging: nvec: potential NULL dereference on error path

Dave Airlie (1):
      drm/qxl: fix memory leak in release list handling

Dave Jones (1):
      remove obsolete references to powertweak

Dave Martin (1):
      ARM: vexpress/TC2: Implement MCPM power_down_finish()

David Herrmann (2):
      HID: uhid: fix leak for 64/32 UHID_CREATE
      drm/sysfs: fix OOM verification

Dmitry Torokhov (1):
      Input: atmel-wm97xx - fix compile error

Doug Anderson (1):
      ARM: dts: Add max77686 RTC interrupt to cros5250-common

Fabio Estevam (4):
      crypto: dcp - Use devm_ioremap_resource()
      crypto: dcp - Use devm_request_irq()
      crypto: dcp - Fix the path for releasing the resources
      crypto: dcp - Check the return value from devm_ioremap_resource()

Florian Echtler (1):
      Input: add sur40 driver for Samsung SUR40 (aka MS Surface 2.0/Pixelsense)

Florian Meier (1):
      i2c: bcm2835: Linking platform nodes to adapter nodes

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Geert Uytterhoeven (3):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      TTY: amiserial, add missing platform check
      Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback

Greg Kroah-Hartman (5):
      Revert "staging:media: Use dev_dbg() instead of pr_debug()"
      Staging: go7007: fix up some remaining go->dev issues
      Revert "n_gsm: race between ld close and gsmtty open"
      Staging: tidspbridge: disable driver
      Revert "sysfs: handle duplicate removal attempts in sysfs_remove_group()"

Guennadi Liakhovetski (1):
      regulator: fixed: fix regulator_list_voltage() for regression

Haiyang Zhang (1):
      MAINTAINERS - add keyboard driver to Hyper-V file list

Hans de Goede (12):
      Revert "dell-laptop: Remove rfkill code"
      dell-laptop: Only enable rfkill on Latitudes
      dell-laptop: If there is no hwswitch, then clear all hw-controlled bits
      dell-laptop: Only get status from BIOS once when updating
      dell-laptop: Don't set sw_state from the query callback
      dell-laptop: Don't read-back sw_state on machines with a hardware switch
      dell-laptop: Allow changing the sw_state while the radio is blocked by hw
      dell-laptop: Sync current block state to BIOS on hw switch change
      dell-laptop: Do not skip setting blocked bit rfkill_set while hw-blocked
      dell-laptop: Wait less long before updating rfkill after an
rfkill keypress
      dell-laptop: Add a force_rfkill module parameter
      dell-laptop: Only enable rfkill functionality on laptops with a
hw killswitch

Hari Bathini (1):
      powerpc/kdump: Adding symbols in vmcoreinfo to facilitate dump filtering

Heiko Carstens (2):
      s390/mm: optimize copy_page
      s390/uaccess: add missing page table walk range check

Helge Deller (1):
      kernel/extable: fix address-checks for core_kernel and init areas

Hendrik Brueckner (1):
      s390/signal: always restore saved runtime instrumentation psw bit

Herbert Xu (2):
      crypto: skcipher - Use eseqiv even on UP machines
      crypto: s390 - Fix aes-cbc IV corruption

Hui Wang (1):
      ALSA: hda - Enable mute/mic-mute LEDs for more Thinkpads with
Conexant codec

Ian Abbott (1):
      staging: comedi: s626: fix value written by s626_set_dac()

Ilia Mirkin (1):
      drm/nouveau/hwmon: fix compilation without CONFIG_HWMON

James Yonan (1):
      crypto: crypto_memneq - add equality testing of memory regions
w/o timing leaks

Jeremy Compostella (1):
      ACPI / sysfs: Fix incorrect ACPI tables walk in acpi_tables_sysfs_init()

Jiri Kosina (1):
      Revert "HID: wiimote: add LEGO-wiimote VID"

Joe Perches (1):
      platform:x86: Remove OOM message after input_allocate_device

Joel Fernandes (1):
      crypto: omap-aes - Fix CTR mode counter length

Jon Mason (7):
      NTB: Xeon Doorbell errata workaround
      NTB: Fix NTB-RP Link Up
      NTB: Fix ntb_transport link down race
      NTB: correct dmaengine_get/put usage
      NTB: Document HW errata
      NTB: Enable Snoop on Primary Side
      NTB: Disable interrupts and poll under high load

Joni Lapilainen (1):
      crypto: omap-sham - Add missing modalias

Josh Boyer (1):
      staging: imx-drm: Fix modular build of DRM_IMX_IPUV3

Jussi Kivilinna (2):
      crypto: sha256_ssse3 - use correct module alias for sha224
      crypto: x86 - restore avx2_supported check

KaiChung Cheng (1):
      HID: multicouh: add PID VID to support 1 new Wistron optical touch device

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC231 codec
      ALSA: hda/realtek - Set pcbeep amp for ALC668

Kuppuswamy Sathyanarayanan (4):
      ipc: Added platform data structure
      ipc: Enabled ipc support for additional intel platforms
      ipc: Handle error conditions in ipc command
      ipc: Added support for IPC interrupt mode

LEROY Christophe (1):
      powerpc/8xx: mfspr SPRN_TBRx in lieu of mftb/mftbu is not supported

Larry Finger (1):
      staging: r8188eu: Fix AP mode

Lars-Peter Clausen (1):
      iio: adc: ti_am335x_adc: avoid double free of buffer.

Laurent Pinchart (1):
      regulator: gpio-regulator: Don't oops on missing regulator-type property

Li Bin (2):
      workqueue: fix comment typo for __queue_work()
      workqueue: fix pool ID allocation leakage and remove
BUILD_BUG_ON() in init_workqueues

Li Wang (1):
      ceph: allocate non-zero page to fscache in readpage()

Linus Torvalds (3):
      Revert "ima: define '_ima' as a builtin 'trusted' keyring"
      Revert "KEYS: verify a certificate is signed by a 'trusted' key"
      Linux 3.13-rc2

Linus Walleij (2):
      crypto: tegra - use kernel entropy instead of ad-hoc
      gpio: pl061: move irqdomain initialization

Lv Zheng (3):
      ACPICA: Tests: Add CHECKSUM_ABORT protection for test utilities.
      ACPICA: Resources: Fix loop termination for the get AML length function.
      ACPI: Clean up incorrect inclusions of ACPICA headers

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Marc Zyngier (1):
      arm64: let the core code deal with preempt_count

Markus Mayer (1):
      gpio: bcm281xx: Fix return value of bcm_kona_gpio_get()

Martin Schwidefsky (3):
      s390/time,vdso: convert to the new update_vsyscall interface
      s390,time: revert direct ktime path for s390 clockevent device
      s390/mm: handle asce-type exceptions as normal page fault

Martin Vogt (1):
      i2c: i2c-diolan-u2c: different usb endpoints for DLN-2-U2C

Mathias Krause (6):
      crypto: authenc - Export key parsing helper function
      crypto: authencesn - Simplify key parsing
      crypto: ixp4xx - Simplify and harden key parsing
      crypto: picoxcell - Simplify and harden key parsing
      crypto: talitos - Simplify key parsing
      padata: make the sequence counter an atomic_t

Matthew Leach (2):
      arm64: ptrace: fix compat registes get/set to be endian clean
      arm64: debug: make aarch32 bkpt checking endian clean

Mattia Dongili (2):
      sony-laptop: warn on multiple KBD backlight handles
      sony-laptop: do not scribble keyboard backlight registers on resume

Michael Ellerman (2):
      hwrng: pseries - Use KBUILD_MODNAME in pseries-rng.c
      hwrng: pseries - Return errors to upper levels in pseries-rng.c

Michael Neuling (2):
      powerpc: Fix error when cross building TAGS & cscope
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Michael Opdenacker (2):
      crypto: mv_cesa: remove deprecated IRQF_DISABLED
      NTB: remove duplicate defines

Michal Nazarewicz (3):
      gpio: fix memory leak in error path
      staging: comedi: fix potentially uninitialised variable
      staging: ft1000: fix use of potentially uninitialized variable

Mika Westerberg (1):
      sysfs: handle duplicate removal attempts in sysfs_remove_group()

Milosz Tanski (1):
      ceph: hung on ceph fscache invalidate in some cases

Neil Horman (1):
      crypto: ansi_cprng - Fix off by one error in non-block size request

NeilBrown (3):
      md/raid5: fix new memory-reference bug in alloc_thread_groups.
      md: test mddev->flags more safely in md_check_recovery.
      md/raid5: fix newly-broken locking in get_active_stripe.

Nicolas Dichtel (1):
      doc: fix generation of device-drivers

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oleg Nesterov (1):
      workqueue: swap set_cpus_allowed_ptr() and PF_NO_SETAFFINITY

Oleksij Rempel (1):
      ALSA: hda - limit mic boost on Asus UX31[A,E]

Oliver Neukum (1):
      crypto: sha256_ssse3 - also test for BMI2

Olof Johansson (2):
      platform: add chrome platform directory
      ARM: omap: fix warning with LPAE build

Pali Rohár (1):
      hwrng: OMAP3 ROM Random Number Generator support

Peng Tao (1):
      staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic

Peter Hurley (5):
      n_tty: Ensure reader restarts worker for next reader
      n_tty: Fix echo overrun tail computation
      n_tty: Fix 4096-byte canonical reads
      tty: Reset hupped state on open
      n_tty: Protect minimum_to_wake reset for concurrent readers

Peter Meerwald (5):
      iio: Fix sign extension table in mcp3422 driver
      iio: Fix mag3110 scan_type
      iio: Fix mag3110 Kconfig dependencies
      iio: Fix tcs3472 Kconfig dependencies
      staging:iio: Fix hmc5843 Kconfig dependencies

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Prarit Bhargava (1):
      x86, wmi fix modalias_show return values

Rafael J. Wysocki (1):
      ATA: Fix port removal ordering

Randy Dunlap (2):
      slab.h: remove duplicate kmalloc declaration and fix kernel-doc warnings
      tty/serial/8250: fix typo in help text

Rashika Kheria (1):
      Staging: zram: Fix memory leak by refcount mismatch

Roberto Sassu (3):
      ima: do not include field length in template digest calc for ima template
      ima: do not send field length to userspace for digest of ima template
      ima: make a copy of template_fmt in template_desc_init_fields()

Ruchika Gupta (3):
      crypto: caam - Add Platform driver for Job Ring
      crypto: caam - Add API's to allocate/free Job Rings
      crypto: caam - Modify the interface layers to use JR API's

Sachin Kamat (8):
      crypto: mv_cesa - Staticize local symbols
      crypto: omap-aes - Staticize local symbols
      crypto: tegra-aes - Staticize tegra_aes_cra_exit
      crypto: tegra-aes - Fix NULL pointer dereference
      crypto: tegra-aes - Use devm_clk_get
      crypto: sahara - Remove redundant of_match_ptr
      crypto: mv_cesa - Remove redundant of_match_ptr
      cpufreq: exynos: Remove unwanted EXPORT_SYMBOL

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Scott Wood (1):
      powerpc/booke: Only check for hugetlb in flush if vma != NULL

Shawn Guo (1):
      ARM: dts: imx6qdl: disable spdif "rxtx5" clock option

Srinivas Pandruvada (1):
      iio: hid_Sensors: fix crash during trigger unregister

Stanimir Varbanov (2):
      ARM: DT: msm: Add Qualcomm's PRNG driver binding document
      hwrng: msm - Add PRNG support for MSM SoC's

Stefan Weinhuber (1):
      s390/dasd: validate request size before building CCW/TCW request

Stephen Gildea (1):
      sony-laptop: fixe typos in sony_laptop_input_keycode_map

Stephen Warren (3):
      ARM: tegra: remove tegra_chip_uid()
      cpufreq: tegra: don't error target() when suspended
      ARM: bcm2835: add missing #xxx-cells to I2C nodes

Steve French (4):
      CIFS: Fix SMB2/SMB3 Copy offload support (refcopy) for large files
      Removed duplicated (and unneeded) goto
      Check SMB3 dialects against downgrade attacks
      [CIFS] Do not use btrfs refcopy ioctl for SMB2 copy offload

Steven Rostedt (Red Hat) (2):
      tracing: Allow events to have NULL strings
      ftrace: Fix function graph with loading of modules

Sven Eckelmann (1):
      HID: sony: Send FF commands in non-atomic context

Takashi Iwai (7):
      thinkpad_acpi: Fix build error when CONFIG_SND_MAX_CARDS > 32
      ALSA: hda - Drop bus->avoid_link_reset flag
      ALSA: hda - Create Headhpone Mic Jack Mode when really needed
      ALSA: hda - Fix hp-mic mode without VREF bits
      ALSA: hda - Check leaf nodes to find aamix amps
      ALSA: hda - Initialize missing bass speaker pin for ASUS AIO ET2700
      ALSA: hda - Add LFE chmap to ASUS ET2700

Takashi Sakamoto (1):
      ALSA: firewire-lib: fix wrong value for FDF field as an empty packet

Taras Kondratiuk (1):
      i2c: davinci: raw read and write endian fix

Tejun Heo (4):
      cgroup: use a dedicated workqueue for cgroup destruction
      workqueue: fix ordered workqueues in NUMA setups
      sysfs: use a separate locking class for open files depending on mmap
      cgroup: fix cgroup_subsys_state leak for seq_files

Thierry Reding (1):
      ARM: tegra: Provide dummy powergate implementation

Thomas Pugliese (1):
      ALSA: usb: use multiple packets per urb for Wireless USB inbound audio

Thomas Renninger (2):
      tools: cpupower: Add cpupower-idle-set(1) manpage
      tools: cpupower: fix wrong err msg not supported vs not available

Tiejun Chen (1):
      powerpc/corenet64: compile with CONFIG_E{5,6}500_CPU well

Tim Harvey (1):
      regulator: pfuze100: allow misprogrammed ID

Tim Kryger (1):
      i2c: i2c-bcm-kona: Fix module build

Tomasz Nowicki (1):
      ACPICA: Delete all attached data objects during namespace node deletion.

Tony Lindgren (9):
      i2c: omap: Fix missing device tree flags for omap2
      ARM: OMAP2+: Fix GPMC and simplify bootloader timings for 8250 and smc91x
      ARM: dts: Fix omap2 specific dtsi files by adding the missing entries
      ARM: OMAP2+: More randconfig fixes for reconfigure_io_chain
      gpio: twl4030: Fix regression for twl gpio output
      gpio: twl4030: Fix passing of pdata in the device tree case
      ARM: OMAP2+: Fix undefined reference to set_cntfreq
      ARM: OMAP2+: Remove legacy mux code for display.c
      ARM: OMAP2+: Remove legacy omap4_twl6030_hsmmc_init

Toshi Kani (1):
      ACPI / hotplug: Fix conflicted PCI bridge notify handlers

Victor Kamensky (1):
      i2c: omap: raw read and write endian fix

Wei Yongjun (3):
      iio: at91: fix error return code in at91_adc_probe()
      pata_arasan_cf: add missing clk_disable_unprepare() on error path
      i2c: bcm-kona: remove duplicated include

Will Deacon (1):
      lockref: include mutex.h rather than reinvent arch_mutex_cpu_relax

Xie XiuQi (1):
      Input: cyttsp4 -  remove unnecessary work pending test

Yan, Zheng (7):
      ceph: remove outdated frag information
      ceph: handle frag mismatch between readdir request and reply
      ceph: queue cap release in __ceph_remove_cap()
      ceph: set caps count after composing cap reconnect message
      ceph: handle race between cap reconnect and cap release
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

Yashpal Dutta (1):
      crypto: caam - map src buffer before access

Yijing Wang (1):
      ata: fix acpi_bus_get_device() return value check

kbuild test robot (1):
      crypto: ablk_helper - Replace memcpy with struct assignment
