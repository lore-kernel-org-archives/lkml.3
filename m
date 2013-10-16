Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756Ab3JPRqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3JPRqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/50] 3.11.6-stable review
Date: Wed, 16 Oct 2013 10:44:46 -0700
Message-Id: <20131016174358.335646140@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.6 release.
There are 50 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Oct 18 17:43:24 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.6-rc1

Linn Crosetto <linn@hp.com>
    x86: avoid remapping data in parse_setup_data()

Manfred Spraul <manfred@colorfullife.com>
    ipc/sem.c: update sem_otime for all operations

Manfred Spraul <manfred@colorfullife.com>
    ipc/sem.c: synchronize the proc interface

Manfred Spraul <manfred@colorfullife.com>
    ipc/sem.c: optimize sem_lock()

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc: drop ipc_lock_check

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc, shm: drop shm_lock_check

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc: drop ipc_lock_by_ptr

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc, shm: guard against non-existant vma in shmdt(2)

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc: document general ipc locking scheme

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,msg: drop msg_unlock

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc: rename ids->rw_mutex

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: shorten critical region for shmat

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: cleanup do_shmat pasta

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: shorten critical region for shmctl

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: make shmctl_nolock lockless

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: introduce shmctl_nolock

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc: drop ipcctl_pre_down

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: shorten critical region in shmctl_down

Davidlohr Bueso <davidlohr.bueso@hp.com>
    ipc,shm: introduce lockless functions to obtain the ipc object

wojciech kapuscinski <wojtask9@wp.pl>
    drm/radeon: fix hw contexts for SUMO2 asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in CP DMA register headers

Dan Carpenter <dan.carpenter@oracle.com>
    drm/radeon: forever loop on error in radeon_do_test_moves()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/radeon/dpm: off by one in si_set_mc_special_registers()

Imre Deak <imre.deak@intel.com>
    drm/i915: fix rps.vlv_work initialization

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Only apply DPMS to the encoder if enabled

Francisco Jerez <currojerez@riseup.net>
    drm/i915/hsw: Disable L3 caching of atomic memory operations.

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix mono speakers and headset mic on Dell Vostro 5470

Ingo Molnar <mingo@kernel.org>
    compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

Dan Carpenter <dan.carpenter@oracle.com>
    drm/radeon/dpm/btc: off by one in btc_set_mc_special_registers()

James Hogan <james.hogan@imgtec.com>
    MIPS: stack protector: Fix per-task canary switch

Jingoo Han <jg1.han@samsung.com>
    watchdog: kempld_wdt: Fix bit mask definition

Dan Carpenter <dan.carpenter@oracle.com>
    watchdog: ts72xx_wdt: locking bug in ioctl

Vineet Gupta <vgupta@synopsys.com>
    ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

Christian Ruppert <christian.ruppert@abilis.com>
    ARC: Fix signal frame management for SA_SIGINFO

Vineet Gupta <vgupta@synopsys.com>
    ARC: Workaround spinlock livelock in SMP SystemC simulation

Vineet Gupta <vgupta@synopsys.com>
    ARC: Fix 32-bit wrap around in access_ok()

Mischa Jonker <mjonker@synopsys.com>
    ARC: Handle zero-overhead-loop in unaligned access handler

Mischa Jonker <mjonker@synopsys.com>
    ARC: Fix __udelay calculation

Helge Deller <deller@gmx.de>
    parisc: fix interruption handler to respect pagefault_disable()

Paul Mackerras <paulus@samba.org>
    KVM: PPC: Book3S HV: Fix typo in saving DSCR

Dave Jones <davej@redhat.com>
    ext4: fix memory leak in xattr

Josef Bacik <jbacik@fusionio.com>
    Btrfs: use right root when checking for hash collision

Henrik Rydberg <rydberg@euromail.se>
    hwmon: (applesmc) Always read until end of data

Taras Kondratiuk <taras.kondratiuk@linaro.org>
    i2c: omap: Clear ARDY bit twice

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: allow O_PATH file descriptors for fstatfs()

Theodore Ts'o <tytso@mit.edu>
    random: run random_int_secret_init() run after all late_initcalls

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add fixup for ASUS N56VZ

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fix channel map switch not taking effect

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb-usx2y: remove bogus frame checks


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/arc/include/asm/delay.h            |   5 +-
 arch/arc/include/asm/spinlock.h         |   9 +-
 arch/arc/include/asm/uaccess.h          |   4 +-
 arch/arc/kernel/ptrace.c                |   2 +-
 arch/arc/kernel/signal.c                |  25 ++--
 arch/arc/kernel/unaligned.c             |   6 +
 arch/arm/include/asm/jump_label.h       |   2 +-
 arch/mips/include/asm/jump_label.h      |   2 +-
 arch/mips/kernel/octeon_switch.S        |   2 +-
 arch/mips/kernel/r2300_switch.S         |   2 +-
 arch/mips/kernel/r4k_switch.S           |   2 +-
 arch/parisc/kernel/traps.c              |   6 +-
 arch/powerpc/include/asm/jump_label.h   |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |   2 +-
 arch/s390/include/asm/jump_label.h      |   2 +-
 arch/sparc/include/asm/jump_label.h     |   2 +-
 arch/x86/include/asm/cpufeature.h       |   6 +-
 arch/x86/include/asm/e820.h             |   2 +-
 arch/x86/include/asm/jump_label.h       |   2 +-
 arch/x86/kernel/e820.c                  |   5 +-
 arch/x86/kernel/setup.c                 |  19 +--
 drivers/char/random.c                   |   3 +-
 drivers/gpu/drm/i915/i915_reg.h         |   6 +
 drivers/gpu/drm/i915/intel_display.c    |   8 +-
 drivers/gpu/drm/i915/intel_pm.c         |   9 +-
 drivers/gpu/drm/radeon/btc_dpm.c        |   6 +-
 drivers/gpu/drm/radeon/evergreen.c      |   2 +-
 drivers/gpu/drm/radeon/evergreend.h     |   4 +-
 drivers/gpu/drm/radeon/r600d.h          |   2 +-
 drivers/gpu/drm/radeon/radeon_test.c    |   4 +-
 drivers/gpu/drm/radeon/si_dpm.c         |   6 +-
 drivers/gpu/drm/radeon/sid.h            |   4 +-
 drivers/hwmon/applesmc.c                |  13 ++
 drivers/i2c/busses/i2c-omap.c           |   3 +
 drivers/watchdog/kempld_wdt.c           |   2 +-
 drivers/watchdog/ts72xx_wdt.c           |   3 +-
 fs/btrfs/inode.c                        |   2 +-
 fs/ext4/xattr.c                         |   2 +
 fs/statfs.c                             |   2 +-
 include/linux/compiler-gcc4.h           |  15 ++
 include/linux/ipc_namespace.h           |   2 +-
 include/linux/random.h                  |   1 +
 init/main.c                             |   2 +
 ipc/msg.c                               |  25 ++--
 ipc/namespace.c                         |   7 +-
 ipc/sem.c                               |  82 ++++++----
 ipc/shm.c                               | 255 ++++++++++++++++++--------------
 ipc/util.c                              |  82 ++++------
 ipc/util.h                              |  14 +-
 sound/pci/hda/patch_hdmi.c              |  18 +--
 sound/pci/hda/patch_realtek.c           |  37 +++++
 sound/usb/usx2y/usbusx2yaudio.c         |  22 +--
 sound/usb/usx2y/usx2yhwdeppcm.c         |   7 +-
 54 files changed, 437 insertions(+), 326 deletions(-)


