Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaCCDPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 22:15:00 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:53077 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaCCDO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 22:14:58 -0500
MIME-Version: 1.0
Date: Sun, 2 Mar 2014 19:14:57 -0800
X-Google-Sender-Auth: ehyAutKfK5lPvtjqSWWoNoCdK74
Message-ID: <CA+55aFx1vhJPMwPiK8mr1U5oyv=nYkNAZLvCJpxY7HJDdzom+Q@mail.gmail.com>
Subject: Linux 3.14-rc5
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another rc.

Things were fairly calm, and fairly normal. Drivers account for just
under 60% of the patch (sound dominates due to a couple of patches
that are larger but trivial, but there's various misc oneliners all
over). The rest is mostly arch updates (mainly powerpc and xtensa),
and then there's a smattering of small stuff elsewhere.

Not a lot. Which is just how I like it.

Go verify that it all works for you..

                   Linus

---

Alex Deucher (7):
      MAINTAINERS: add entry for drm radeon driver
      MAINTAINERS: update drm git tree entry
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1
      drm/radeon: fix audio disable on dce6+
      drm/radeon: change audio enable logic
      drm/radeon: enable speaker allocation setup on dce3.2

Alexey Khoroshilov (1):
      drm/vmwgfx: avoid null pointer dereference at failure paths

Andi Kleen (1):
      perf tools: fix BFD detection on opensuse

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Benjamin Herrenschmidt (2):
      powerpc/powernv: Fix opal_xscom_{read,write} prototype
      powerpc/powernv: Fix indirect XSCOM unmangling

Beomho Seo (2):
      iio: cm36651: Fix read/write integration time function.
      iio: cm32181: Change cm32181 ambient light sensor driver

Brian Norris (1):
      mtd: nand: fix off-by-one read retry mode counting

Catalin Marinas (1):
      arm64: Fix !CONFIG_SMP kernel build

Charles Keepax (3):
      ASoC: dapm: Correct regulator bypass error messages
      Input - arizona-haptics: Fix double lock of dapm_mutex
      ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin functions

Chris Zankel (2):
      xtensa: fix fast_syscall_spill_registers
      xtensa: fix fast_syscall_spill_registers

Christian Engelmayer (1):
      pwm: lp3943: Fix potential memory leak during request

Christian König (1):
      drm/radeon: fix missing bo reservation

Dan Carpenter (1):
      UBI: fix some use after free bugs

Dan Williams (1):
      ioat: fix tasklet tear down

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis CIOCCA (1):
      iio:gyro: bug on L3GD20H gyroscope support

Dirk Brandewie (1):
      intel_pstate: Change busy calculation to use fixed point math.

Dmitry Osipenko (1):
      drm/tegra: Add guard to avoid double disable/enable of RGB outputs

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Erik Faye-Lund (1):
      gpu: host1x: do not check previously handled gathers

Eugene Surovegin (1):
      x86, kaslr: export offset in VMCOREINFO ELF notes

Fathi Boudra (1):
      Makefile: fix extra parenthesis typo when
CC_STACKPROTECTOR_REGULAR is enabled

Gavin Shan (2):
      powerpc/powernv: Dump PHB diag-data immediately
      powerpc/powernv: Refactor PHB diag-data dump

Geert Uytterhoeven (3):
      m68k: Sort arch/m68k/include/asm/Kbuild
      m68k: Switch to asm-generic/barrier.h
      m68k: Wire up sched_setattr and sched_getattr

Gerald Schaefer (1):
      s390/pci/dma: use correct segment boundary size

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Heiko Carstens (1):
      s390/compat: fix sys_sched_getattr compat wrapper

Heinz Mauelshagen (1):
      dm cache: fix truncation bug when mapping I/O to >2TB fast device

Ingo Tuchscherer (1):
      s390/zcrypt: additional check to avoid overflow in msg-type 6 requests

James Hogan (2):
      asm-generic: add sched_setattr/sched_getattr syscalls
      irq-metag*: stop set_affinity vectoring to offline cpus

Jan Beulich (1):
      Makefile: fix build with make 3.80 again

Jan Kara (7):
      inotify: Fix reporting of cookies for inotify events
      udf: Fix data corruption on file type conversion
      quota: Fix race between dqput() and dquot_scan_active()
      Revert "writeback: do not sync data dirtied after sync start"
      fsnotify: Fix detection whether overflow event is queued
      fanotify: Handle overflow in case of permission events
      fsnotify: Allocate overflow events with proper type

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jerome Glisse (1):
      drm/radeon: free uvd ring on unload

Jiri Olsa (1):
      perf tools: Fix strict alias issue for find_first_bit

Joe Perches (3):
      drivers/iommu/omap-iommu-debug.c: fix decimal permissions
      drivers/fmc/fmc-write-eeprom.c: fix decimal permissions
      MAINTAINERS: update L: misuses

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Juergen Beisert (1):
      staging:iio:adc:MXS:LRADC: fix touchscreen statemachine

Kailang Yang (2):
      ALSA: hda/realtek - Add more entry for enable HP mute led
      ALSA: hda/realtek - Add more entry for enable HP mute led

Kees Cook (1):
      x86, kaslr: add missed "static" declarations

Kirill A. Shutemov (2):
      mm, hwpoison: release page on PageHWPoison() in __do_fault()
      mm, thp: fix infinite loop on memcg OOM

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (2):
      ASoC: sta32x: Fix cache sync
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Li Zefan (1):
      sysfs: fix namespace refcnt leak

Linus Torvalds (1):
      Linux 3.14-rc5

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Liu Ping Fan (1):
      powerpc/ftrace: bugfix for test_24bit_addr

Manu Gupta (1):
      staging: r8188eu: Add new device ID

Marc Zyngier (1):
      arm/arm64: KVM: detect CPU reset on CPU_PM_EXIT

Marcelo Tosatti (1):
      KVM: MMU: drop read-only large sptes when creating lower level sptes

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Markus Pargmann (1):
      dma: sdma: Add imx25 compatible

Max Filippov (10):
      xtensa: fix warning '"CONFIG_OF" is not defined'
      xtensa: export ccount_freq
      xtensa: introduce spill_registers_kernel macro
      xtensa: save current register frame in fast_syscall_spill_registers_fixup
      xtensa: don't pass high memory to bootmem allocator
      xtensa: fsf: drop nonexistent GPIO32 support
      xtensa: support common clock framework
      xtensa: xtfpga: use common clock framework
      xtensa: xtfpga: set ethoc clock frequency
      xtensa: wire up sched_setattr and sched_getattr syscalls

Michal Hocko (1):
      memcg: change oom_info_lock to mutex

Mike Snitzer (5):
      dm cache: move hook_info into common portion of per_bio_data structure
      dm cache: do not add migration to completed list before unhooking bio
      dm thin: avoid metadata commit if a pool's thin devices haven't changed
      dm thin: fix the error path for the thin device constructor
      dm thin: allow metadata space larger than supported to go unused

Mikulas Patocka (2):
      dm io: fix I/O to multiple destinations
      dm raid1: fix immutable biovec related BUG when retrying read bio

Namhyung Kim (2):
      perf annotate: Check availability of annotate when processing samples
      perf symbols: Destroy unused symsrcs

Nicholas Bellinger (7):
      qla2xxx: Fix qlt_lport_register base_vha callback race
      qla2xxx: Check + fail when npiv_vports_inuse exists in shutdown
      tcm_qla2xxx: Add NPIV specific enable/disable attribute logic
      tcm_qla2xxx: Perform configfs depend/undepend for base_tpg
      tcm_qla2xxx: Fix NAA formatted name for NPIV WWPNs
      target/sbc: Fix sbc_dif_copy_prot addr offset bug
      target: Add DIF sense codes in transport_generic_request_failure

Olof Johansson (1):
      ARM64: unwind: Fix PC calculation

Paolo Bonzini (1):
      kvm, vmx: Really fix lazy FPU on nested guest

Paul Bolle (2):
      drm/tegra: fix typo 'CONFIG_TEGRA_DRM_FBDEV'
      xtensa: no need to select USE_GENERIC_SMP_HELPERS

Paul Mackerras (1):
      powerpc: Increase stack redzone for 64-bit userspace to 512 bytes

Pekon Gupta (3):
      mtd: nand: omap: fix ecclayout to be in sync with u-boot NAND driver
      mtd: nand: omap: fix ecclayout->oobfree->offset
      mtd: nand: omap: fix ecclayout->oobfree->length

Peter Oberparleiter (1):
      s390/cio: Fix missing subchannels after CHPID configure on

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Russell King (1):
      MAINTAINERS: add maintainer entry for Armada DRM driver

Sagi Grimberg (1):
      Target/sbc: Don't use sg as iterator in sbc_verify_read

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

Stanislaw Gruszka (1):
      usb: ehci: fix deadlock when threadirqs option is used

Steve Capper (1):
      arm64: mm: Add double logical invert to pte accessors

Takashi Iwai (9):
      ASoC: sta32x: Fix array access overflow
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: wm8900: Fix the wrong number of enum items
      ASoC: wm8994: Fix the wrong number of enum items
      ASoC: ad1980: Fix wrong number of items for capture source
      ASoC: isabelle: Fix the wrong number of items in enum ctls
      ASoC: wm8400: Fix the wrong number of enum items
      ALSA: hda - Add a fixup for HP Folio 13 mute LED
      ASoC: sta32x: Fix wrong enum for limiter2 release rate

Thomas Hellstrom (2):
      drm/vmwgfx: Remove some unused surface formats
      drm/vmwgfx: Make sure backing mobs are cleared when allocated.
Update driver date.

Tobias Klauser (1):
      MAINTAINERS: change mailing list address for Altera UART drivers

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

Venkatesh Srinivas (1):
      vhost/scsi: Check LUN structure byte 0 is set to 1, per spec
