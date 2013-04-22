Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3DVOyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:54:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab3DVO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.151900666@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/75] 3.2.44-rc1 review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.44 release.
There are 75 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Apr 24 15:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.43 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running
         [f1ca493b0b5e8f42d3b2dc8877860db2983f47b6]

Andrew Honig (1):
      KVM: Allow cross page reads and writes from cached translations.
         [8f964525a121f2ff2df948dac908dcc65be21b5b]

Andy Honig (3):
      KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
         [a2c118bfab8bc6b8bb213abfc35201e441693d55]
      KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functions (CVE-2013-1797)
         [0b79459b482e85cb7426aa7da683a9f2c97aeae1]
      KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
         [c300aa64ddf57d9c5d9c898a64b36877345dd4a9]

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store
         [c678ef5286ddb5cf70384ad5af286b0afc9b73e1]

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
         [511ba86e1d386f671084b5d0e6f110bb30b8eeb2]

Carsten Emde (3):
      drm/i915: panel: invert brightness acer aspire 5734z
         [5a15ab5b93e4a3ebcd4fa6c76cf646a45e9cf806]
      drm/i915: panel: invert brightness via parameter
         [7bd90909bbf9ce7c40e1da3d72b97b93839c188a]
      drm/i915: panel: invert brightness via quirk
         [4dca20efb1a9c2efefc28ad2867e5d6c3f5e1955]

Chris Mason (1):
      Btrfs: fix race between mmap writes and compression
         [4adaa611020fa6ac65b0ac8db78276af4ec04e63]

Christoph Fritz (1):
      can: sja1000: fix handling on dt properties on little endian systems
         [0443de5fbf224abf41f688d8487b0c307dc5a4b4]

Dave Airlie (1):
      fbcon: fix locking harder
         [054430e773c9a1e26f38e30156eff02dedfffc17]

David Henningsson (1):
      ALSA: hda - fix typo in proc output
         [aeb3a97222832e5457c4b72d72235098ce4bfe8d]

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems
         [f5cf8f07423b2677cebebcebc863af77223a4972]

Egbert Eich (1):
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
         [5f85f176c2f1c9d2a23f60ca0b99e4d0aa5a26a7]

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
         [889d66848b12d891248b03abcb2a42047f8e172a]

Emese Revfy (1):
      kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
         [b9e146d8eb3b9ecae5086d373b50fa0c1f3e7f0f]

Felix Fietkau (2):
      ath9k_htc: accept 1.x firmware newer than 1.3
         [319e7bd96aca64a478f3aad40711c928405b8b77]
      ath9k_hw: change AR9580 initvals to fix a stability issue
         [f09a878511997c25a76bf111a32f6b8345a701a5]

Hayeswang (1):
      r8169: fix auto speed down issue
         [e2409d83434d77874b461b78af6a19cd6e6a1280]

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()
         [6f389a8f1dd22a24f3d9afc2812b30d639e94625]

Illia Ragozin (1):
      ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
         [cd272d1ea71583170e95dde02c76166c7f9017e6]

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling
         [5000c418840b309251c5887f0b56503aae30f84c]

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on Packard Bell NCL20
         [5559ecadad5a73b27f863e92f4b4f369501dce6f]
      drm/i915: add quirk to invert brightness on eMachines G725
         [1ffff60320879830e469e26062c18f75236822ba]
      drm/i915: add quirk to invert brightness on eMachines e725
         [01e3a8feb40e54b962a20fa7eb595c5efef5e109]

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources
         [aa8b4be3ac049c8b1df2a87e4d1d902ccfc1f7a9]

Jean-Christophe PLAGNIOL-VILLARD (1):
      of: introduce helper to manage boolean
         [fa4d34ccd0914ac87336ea2c17e9370dfecef286]

Johan Hovold (15):
      USB: ark3116: fix use-after-free in TIOCMIWAIT
         [5018860321dc7a9e50a75d5f319bc981298fb5b7]
      USB: ch341: fix use-after-free in TIOCMIWAIT
         [fa1e11d5231c001c80a479160b5832933c5d35fb]
      USB: cypress_m8: fix use-after-free in TIOCMIWAIT
         [356050d8b1e526db093e9d2c78daf49d6bf418e3]
      USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
         [71ccb9b01981fabae27d3c98260ea4613207618e]
      USB: io_edgeport: fix use-after-free in TIOCMIWAIT
         [333576255d4cfc53efd056aad438568184b36af6]
      USB: io_ti: fix use-after-free in TIOCMIWAIT
         [7b2459690584f239650a365f3411ba2ec1c6d1e0]
      USB: mct_u232: fix use-after-free in TIOCMIWAIT
         [cf1d24443677a0758cfa88ca40f24858b89261c0]
      USB: mos7840: fix broken TIOCMIWAIT
         [e670c6af12517d08a403487b1122eecf506021cf]
      USB: mos7840: fix use-after-free in TIOCMIWAIT
         [a14430db686b8e459e1cf070a6ecf391515c9ab9]
      USB: oti6858: fix use-after-free in TIOCMIWAIT
         [8edfdab37157d2683e51b8be5d3d5697f66a9f7b]
      USB: pl2303: fix use-after-free in TIOCMIWAIT
         [40509ca982c00c4b70fc00be887509feca0bff15]
      USB: serial: add modem-status-change wait queue
         [e5b33dc9d16053c2ae4c2c669cf008829530364b]
      USB: spcp8x5: fix use-after-free in TIOCMIWAIT
         [dbcea7615d8d7d58f6ff49d2c5568113f70effe9]
      USB: ssu100: fix use-after-free in TIOCMIWAIT
         [43a66b4c417ad15f6d2f632ce67ad195bdf999e8]
      USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
         [fc98ab873aa3dbe783ce56a2ffdbbe7c7609521a]

Josef Bacik (1):
      Btrfs: make sure nbytes are right after log replay
         [4bc4bee4595662d8bff92180d5c32e3313a704b0]

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment
         [d3dde52209ab571e4e2ec26c66f85ad1355f7475]

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path
         [c10b90d85a5126d25c89cbaa50dc9fdd1c4d001a]

Linus Torvalds (3):
      kobject: fix kset_find_obj() race with concurrent last kobject_put()
         [a49b7e82cab0f9b41f483359be83f44fbb6b4979]
      net: fix incorrect credentials passing
         [83f1b4ba917db5dc5a061a44b3403ddb6e783494]
      spinlocks and preemption points need to be at least compiler barriers
         [386afc91144b36b42117b0092893f15bc8798a80]

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak
         [51c94491c82c3d9029f6e87a1a153db321d88e35]

Michael Bohan (1):
      hrtimer: Don't reinitialize a cpu_base lock on CPU_UP
         [84cc8fd2fe65866e49d70b38b3fdf7219dd92fe0]

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test
         [9fb2640159f9d4f5a2a9d60e490482d4cbecafdb]

Ming Lei (1):
      USB: serial: fix hang when opening port
         [eba0e3c3a0ba7b96f01cbe997680f6a4401a0bfc]

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
         [83e03b3fe4daffdebbb42151d5410d730ae50bd1]
      tracing: Fix possible NULL pointer dereferences
         [6a76f8c0ab19f215af2a3442870eeb5f0e81998d]

Naoya Horiguchi (1):
      hugetlbfs: add swap entry check in follow_hugetlb_page()
         [9cc3a5bd40067b9a0fbd49199d0780463fc2140f]

Nicholas Bellinger (2):
      target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 bits
         [ba539743b70cd160c84bab1c82910d0789b820f8]
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs
         [30f359a6f9da65a66de8cadf959f0f4a0d498bba]

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec
         [1d87caa69c04008e09f5ff47b5e6acb6116febc7]

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class
         [da28d966f6aa942ae836d09729f76a1647932309]

Russell King (1):
      ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly
         [b6c7aabd923a17af993c5a5d5d7995f0b27c000a]

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates
         [1160c2779b826c6f5c08e5cc542de58fd1f667d5]

Shan Hai (2):
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive
         [a32450e127fc6e5ca6d958ceb3cfea4d30a00846]
      libata: Use integer return value for atapi_command_packet_set
         [d8668fcb0b257d9fdcfbe5c172a99b8d85e1cd82]

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb
         [5b55d708335a9e3e4f61f2dadf7511502205ccd1]

Tejun Heo (1):
      sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s
         [383efcd00053ec40023010ce5034bd702e7ab373]

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems
         [a1cbcaa9ea87b87a96b9fc465951dcf36e459ca2]

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3
         [4b20db3de8dab005b07c74161cb041db8c5ff3a7]

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once
         [83589b30f1e1dc9898986293c9336b8ce1705dec]

Vyacheslav Dubeyko (1):
      hfsplus: fix potential overflow in hfsplus_file_truncate()
         [12f267a20aecf8b84a2a9069b9011f1661c779b4]

Wei Yongjun (1):
      can: gw: use kmem_cache_free() instead of kfree()
         [3480a2125923e4b7a56d79efc76743089bf273fc]

Will Deacon (1):
      ARM: 7698/1: perf: fix group validation when using enable_on_exec
         [cb2d8b342aa084d1f3ac29966245dec9163677fb]

Wu Fengguang (1):
      writeback: fix dirtied pages accounting on redirty
         [2f800fbd777b792de54187088df19a7df0251254]

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms
         [b55f84e2d527182e7c611d466cd0bb6ddce201de]

 Documentation/kernel-parameters.txt                |   14 +++++
 Makefile                                           |    4 +-
 arch/alpha/kernel/sys_nautilus.c                   |    5 ++
 arch/arm/kernel/perf_event.c                       |    5 +-
 arch/arm/mm/cache-feroceon-l2.c                    |    1 +
 arch/arm/mm/proc-arm920.S                          |    2 +-
 arch/arm/mm/proc-arm926.S                          |    2 +-
 arch/arm/mm/proc-sa1100.S                          |    2 +-
 arch/arm/mm/proc-v6.S                              |    2 +-
 arch/arm/mm/proc-xsc3.S                            |    2 +-
 arch/arm/mm/proc-xscale.S                          |    2 +-
 arch/powerpc/platforms/pseries/lpar.c              |    8 ++-
 arch/x86/include/asm/kvm_host.h                    |    4 +-
 arch/x86/include/asm/paravirt.h                    |    5 +-
 arch/x86/include/asm/paravirt_types.h              |    2 +
 arch/x86/kernel/paravirt.c                         |   25 ++++-----
 arch/x86/kvm/x86.c                                 |   43 +++++++--------
 arch/x86/lguest/boot.c                             |    1 +
 arch/x86/mm/fault.c                                |    6 ++-
 arch/x86/xen/mmu.c                                 |    1 +
 block/blk-sysfs.c                                  |    2 +
 crypto/gcm.c                                       |   17 ++++--
 drivers/ata/ata_piix.c                             |   14 ++++-
 drivers/ata/libata-core.c                          |    4 ++
 drivers/gpu/drm/i915/i915_drv.h                    |    1 +
 drivers/gpu/drm/i915/intel_display.c               |   55 ++++++++++++++++++++
 drivers/gpu/drm/i915/intel_panel.c                 |   24 +++++++++
 drivers/gpu/vga/vga_switcheroo.c                   |    3 ++
 drivers/hwspinlock/hwspinlock_core.c               |    2 +
 drivers/mtd/mtdchar.c                              |    6 ++-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   31 ++++++-----
 drivers/net/ethernet/realtek/r8169.c               |   28 ++++++++--
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    4 +-
 drivers/platform/x86/msi-wmi.c                     |    4 +-
 drivers/target/target_core_alua.c                  |    9 ++--
 drivers/target/target_core_transport.c             |    3 +-
 drivers/thermal/thermal_sys.c                      |    1 +
 drivers/usb/serial/ark3116.c                       |   10 ++--
 drivers/usb/serial/ch341.c                         |   11 ++--
 drivers/usb/serial/cypress_m8.c                    |   14 ++---
 drivers/usb/serial/ftdi_sio.c                      |   19 +++----
 drivers/usb/serial/io_edgeport.c                   |   12 +++--
 drivers/usb/serial/io_ti.c                         |   12 ++---
 drivers/usb/serial/mct_u232.c                      |   13 ++---
 drivers/usb/serial/mos7840.c                       |   16 +++---
 drivers/usb/serial/oti6858.c                       |   10 ++--
 drivers/usb/serial/pl2303.c                        |   11 ++--
 drivers/usb/serial/spcp8x5.c                       |    9 ++--
 drivers/usb/serial/ssu100.c                        |   12 +++--
 drivers/usb/serial/ti_usb_3410_5052.c              |   10 ++--
 drivers/usb/serial/usb-serial.c                    |    1 +
 drivers/video/console/fbcon.c                      |   11 ++--
 drivers/video/fbmem.c                              |    2 +
 fs/btrfs/extent_io.c                               |   33 ++++++++++++
 fs/btrfs/extent_io.h                               |    2 +
 fs/btrfs/inode.c                                   |   14 +++++
 fs/btrfs/tree-log.c                                |   48 ++++++++++++++---
 fs/hfsplus/extents.c                               |    2 +-
 fs/inode.c                                         |    2 +-
 include/linux/ata.h                                |    2 +-
 include/linux/kref.h                               |   21 ++++++++
 include/linux/kvm_host.h                           |    2 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/libata.h                             |    1 +
 include/linux/of.h                                 |   16 ++++++
 include/linux/preempt.h                            |   18 ++++---
 include/linux/socket.h                             |    1 +
 include/linux/spinlock_up.h                        |   29 +++++++----
 include/linux/usb/serial.h                         |    2 +
 include/linux/writeback.h                          |    2 +
 include/net/scm.h                                  |    2 +-
 kernel/hrtimer.c                                   |    3 +-
 kernel/sched.c                                     |    6 ++-
 kernel/sched_clock.c                               |   26 +++++++++
 kernel/signal.c                                    |    2 +-
 kernel/sys.c                                       |    3 +-
 kernel/trace/ftrace.c                              |   19 +++----
 lib/kobject.c                                      |    9 +++-
 mm/hugetlb.c                                       |   12 ++++-
 mm/page-writeback.c                                |   19 +++++++
 net/can/gw.c                                       |    6 +--
 net/core/sock.c                                    |   14 +++++
 sound/pci/hda/hda_codec.c                          |    2 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/soc/codecs/wm8903.c                          |    2 +
 sound/usb/mixer_quirks.c                           |    4 +-
 sound/usb/quirks.c                                 |    2 +-
 virt/kvm/ioapic.c                                  |    7 ++-
 virt/kvm/kvm_main.c                                |   47 +++++++++++++----
 91 files changed, 679 insertions(+), 227 deletions(-)

-- 
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others.

