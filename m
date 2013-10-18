Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3JRSqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:46:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3JRSqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:46:09 -0400
Date: Fri, 18 Oct 2013 11:47:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.6
Message-ID: <20131018184722.GA9129@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.6 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/arc/include/asm/delay.h            |    5=20
 arch/arc/include/asm/spinlock.h         |    9 +
 arch/arc/include/asm/uaccess.h          |    4=20
 arch/arc/kernel/ptrace.c                |    2=20
 arch/arc/kernel/signal.c                |   25 +--
 arch/arc/kernel/unaligned.c             |    6=20
 arch/arm/include/asm/jump_label.h       |    2=20
 arch/mips/include/asm/jump_label.h      |    2=20
 arch/mips/kernel/octeon_switch.S        |    2=20
 arch/mips/kernel/r2300_switch.S         |    2=20
 arch/mips/kernel/r4k_switch.S           |    2=20
 arch/parisc/kernel/traps.c              |    6=20
 arch/powerpc/include/asm/jump_label.h   |    2=20
 arch/powerpc/kvm/book3s_hv_rmhandlers.S |    2=20
 arch/s390/include/asm/jump_label.h      |    2=20
 arch/sparc/include/asm/jump_label.h     |    2=20
 arch/x86/include/asm/cpufeature.h       |    6=20
 arch/x86/include/asm/e820.h             |    2=20
 arch/x86/include/asm/jump_label.h       |    2=20
 arch/x86/kernel/e820.c                  |    5=20
 arch/x86/kernel/setup.c                 |   19 +-
 drivers/char/random.c                   |    3=20
 drivers/gpu/drm/i915/i915_reg.h         |    6=20
 drivers/gpu/drm/i915/intel_display.c    |    8 -
 drivers/gpu/drm/i915/intel_pm.c         |    9 -
 drivers/gpu/drm/radeon/btc_dpm.c        |    6=20
 drivers/gpu/drm/radeon/evergreen.c      |    2=20
 drivers/gpu/drm/radeon/evergreend.h     |    4=20
 drivers/gpu/drm/radeon/r600d.h          |    2=20
 drivers/gpu/drm/radeon/radeon_test.c    |    4=20
 drivers/gpu/drm/radeon/si_dpm.c         |    6=20
 drivers/gpu/drm/radeon/sid.h            |    4=20
 drivers/hwmon/applesmc.c                |   13 +
 drivers/i2c/busses/i2c-omap.c           |    3=20
 drivers/watchdog/kempld_wdt.c           |    2=20
 drivers/watchdog/ts72xx_wdt.c           |    3=20
 fs/btrfs/inode.c                        |    2=20
 fs/ext4/xattr.c                         |    2=20
 fs/statfs.c                             |    2=20
 include/linux/compiler-gcc4.h           |   15 +
 include/linux/ipc_namespace.h           |    2=20
 include/linux/random.h                  |    1=20
 init/main.c                             |    2=20
 ipc/msg.c                               |   25 +--
 ipc/namespace.c                         |    7=20
 ipc/sem.c                               |   82 +++++++---
 ipc/shm.c                               |  255 ++++++++++++++++++---------=
-----
 ipc/util.c                              |   82 +++-------
 ipc/util.h                              |   14 -
 sound/pci/hda/patch_hdmi.c              |   18 +-
 sound/pci/hda/patch_realtek.c           |   37 ++++
 sound/usb/usx2y/usbusx2yaudio.c         |   22 --
 sound/usb/usx2y/usx2yhwdeppcm.c         |    7=20
 54 files changed, 436 insertions(+), 325 deletions(-)

Alex Deucher (1):
      drm/radeon: fix typo in CP DMA register headers

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix channel map switch not taking effect

Chris Wilson (1):
      drm/i915: Only apply DPMS to the encoder if enabled

Christian Ruppert (1):
      ARC: Fix signal frame management for SA_SIGINFO

Dan Carpenter (4):
      watchdog: ts72xx_wdt: locking bug in ioctl
      drm/radeon/dpm/btc: off by one in btc_set_mc_special_registers()
      drm/radeon/dpm: off by one in si_set_mc_special_registers()
      drm/radeon: forever loop on error in radeon_do_test_moves()

Daniel Mack (1):
      ALSA: snd-usb-usx2y: remove bogus frame checks

Dave Jones (1):
      ext4: fix memory leak in xattr

David Henningsson (2):
      ALSA: hda - Fix microphone for Sony VAIO Pro 13 (Haswell model)
      ALSA: hda - Fix mono speakers and headset mic on Dell Vostro 5470

Davidlohr Bueso (15):
      ipc,shm: introduce lockless functions to obtain the ipc object
      ipc,shm: shorten critical region in shmctl_down
      ipc: drop ipcctl_pre_down
      ipc,shm: introduce shmctl_nolock
      ipc,shm: make shmctl_nolock lockless
      ipc,shm: shorten critical region for shmctl
      ipc,shm: cleanup do_shmat pasta
      ipc,shm: shorten critical region for shmat
      ipc: rename ids->rw_mutex
      ipc,msg: drop msg_unlock
      ipc: document general ipc locking scheme
      ipc, shm: guard against non-existant vma in shmdt(2)
      ipc: drop ipc_lock_by_ptr
      ipc, shm: drop shm_lock_check
      ipc: drop ipc_lock_check

Francisco Jerez (1):
      drm/i915/hsw: Disable L3 caching of atomic memory operations.

Greg Kroah-Hartman (1):
      Linux 3.11.6

Helge Deller (1):
      parisc: fix interruption handler to respect pagefault_disable()

Henrik Rydberg (1):
      hwmon: (applesmc) Always read until end of data

Imre Deak (1):
      drm/i915: fix rps.vlv_work initialization

Ingo Molnar (1):
      compiler/gcc4: Add quirk for 'asm goto' miscompilation bug

James Hogan (1):
      MIPS: stack protector: Fix per-task canary switch

Jingoo Han (1):
      watchdog: kempld_wdt: Fix bit mask definition

Josef Bacik (1):
      Btrfs: use right root when checking for hash collision

Linn Crosetto (1):
      x86: avoid remapping data in parse_setup_data()

Linus Torvalds (1):
      vfs: allow O_PATH file descriptors for fstatfs()

Manfred Spraul (3):
      ipc/sem.c: optimize sem_lock()
      ipc/sem.c: synchronize the proc interface
      ipc/sem.c: update sem_otime for all operations

Mischa Jonker (2):
      ARC: Fix __udelay calculation
      ARC: Handle zero-overhead-loop in unaligned access handler

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

Takashi Iwai (1):
      ALSA: hda - Add fixup for ASUS N56VZ

Taras Kondratiuk (1):
      i2c: omap: Clear ARDY bit twice

Theodore Ts'o (1):
      random: run random_int_secret_init() run after all late_initcalls

Vineet Gupta (3):
      ARC: Fix 32-bit wrap around in access_ok()
      ARC: Workaround spinlock livelock in SMP SystemC simulation
      ARC: Ignore ptrace SETREGSET request for synthetic register "stop_pc"

wojciech kapuscinski (1):
      drm/radeon: fix hw contexts for SUMO2 asics


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYYI6AAoJEDjbvchgkmk+EtUP/A73OfuKMp4LnS2J/5sbaGO1
Kmsl4IkhVIDIMQl16JKkkJ6Ycph/SgSU4E2XVB6SkGDxCPvOlnB0plp+Su9dJ5J0
9OS//8KLVx1iFP/6cIfZAfoLBNbYViTVHyYOAhUcZxr46TDM8jqsSlDuel1DKfp4
M8/r90HGpZvQtTU6hdkKv1v+HQrpkWa6iOoXRtogTXtJAfgkDdCbJ7D5z6cFJItA
QaSBqZd/WEh7XQhUhQZs70uIjT6wdI2orFxLtWLEwsQGH4O4QHrzP5Qg1tjvdjmP
BE3yrgSEieRDREu4+J70qKFAd8iWioIgKPf4KXdz+5zs8Ka0WaOTHEr/yD09Ik8N
HoXrin8VYuoNnUarS77/O6eSS+b1mxn7LNiwBf/hI3bkDkMpQ/2JtnMmTC/5I0RF
942tbEAvqBvm06Ecqqp+0hyIan+D+cA+VBAkGqRUKVw45L171w986xFBF13d0O7w
jHzU+jfza62Qq8MQApOy3O08a7Doc8lpVHvMKWDQwFUOs7KSRs+/lCX4TSKZeNhi
0fgFW0LKZtwiQC7Uk05Qr+dT+8xTP891gBedDwR5YgpdqN7c4yU2jPfhwZIizRqh
fr5IpIDXGmkcymwkG/oIEt8U2XMsZtIWPOUMtMpLVRZAxMzBpkO73PCPOyrzOBS7
kmesnC2rOVs1TQKvBcV9
=tN1L
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
