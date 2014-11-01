Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaKAW4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59997 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Phil Jensen <pjensen@evernote.com>,
        akpm@linux-foundation.org
Date: Sat, 01 Nov 2014 22:28:02 +0000
Message-ID: <lsq.1414880882.522510247@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/102] 3.2.64-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.64 release.
There are 102 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Nov 04 00:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.63 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Al Viro (2):
      be careful with nd->inode in path_init() and follow_dotdot_rcu()
         [4023bfc9f351a7994fb6a7d515476c320f94a574]
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
         [7bd88377d482e1eae3c5329b12e33cfd664fa6a9]

Alban Crequy (1):
      cgroup: reject cgroup names with '\n'
         [71b1fb5c4473a5b1e601d41b109bdfe001ec82e0]

Alex Deucher (1):
      drm/radeon: add connector quirk for fujitsu board
         [1952f24d0fa6292d65f886887af87ba8ac79b3ba]

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()
         [56d7acc792c0d98f38f22058671ee715ff197023]

Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies
         [d78c9300c51d6ceed9f6d078d4e9366f259de28c]

Andy Honig (1):
      KVM: x86: Improve thread safety in pit
         [2febc839133280d5a5e8e1179c94ea674489dae2]

Andy Lutomirski (1):
      x86,kvm,vmx: Preserve CR4 across VM entry
         [d974baa398f34393db76be45f7d4d04fbdbb4a0a]

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.
         [f2d5a94436cc7cc0221b9a81bba2276a25187dd3]

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include
         [29593fd5a8149462ed6fad0d522234facdaee6c8]

Ben Hutchings (1):
      vfs: Fold follow_mount_rcu() into follow_dotdot_rcu()
         [b37199e626b31e1175fb06764c5d1d687723aac2]

Bjørn Mork (2):
      USB: sierra: add 1199:68AA device ID
         [5b3da69285c143b7ea76b3b9f73099ff1093ab73]
      USB: sierra: avoid CDC class functions on "68A3" devices
         [049255f51644c1105775af228396d187402a5934]

Chenweilong (1):
      ipv6: reallocate addrconf router for ipv6  address when lo device up
         [33d99113b1102c2d2f8603b9ba72d89d915c13f5]

Christian Borntraeger (1):
      KVM: s390: Fix user triggerable bug in dead code
         [614a80e474b227cace52fd6e3c790554db8a396e]

Clemens Ladisch (1):
      ALSA: pcm: fix fifo_size frame calculation
         [a9960e6a293e6fc3ed414643bb4e4106272e4d0a]

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()
         [3577af70a2ce4853d58e57d832e687d739281479]

Daniel Borkmann (3):
      net: sctp: fix panic on duplicate ASCONF chunks
         [b69040d8e39f20d5215a03502a8e8b4c6ab78395]
      net: sctp: fix remote memory pressure from excessive queueing
         [26b87c7881006311828bb0ab271a551a62dcceb4]
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks
         [9de7922bc709eee2f609cd01d98aaedc4cf5ea74]

Dave Chinner (1):
      xfs: don't dirty buffers beyond EOF
         [22e757a49cf010703fcb9c9b4ef793248c39b0c2]

David Dueck (1):
      can: at91_can: add missing prepare and unprepare of the clock
         [e77980e50bc2850599d4d9c0192b67a9ffd6daac]

David Jander (2):
      can: flexcan: correctly initialize mailboxes
         [fc05b884a31dbf259cc73cc856e634ec3acbebb6]
      can: flexcan: implement workaround for errata ERR005829
         [25e924450fcb23c11c07c95ea8964dd9f174652e]

Dmitry Torokhov (1):
      Input: synaptics - add support for ForcePads
         [5715fc764f7753d464dbe094b5ef9cffa6e479a4]

Eliad Peller (1):
      regulatory: add NUL to alpha2
         [a5fe8e7695dc3f547e955ad2b662e3e72969e506]

Emmanuel Grumbach (1):
      Revert "iwlwifi: dvm: don't enable CTS to self"
         [f47f46d7b09cf1d09e4b44b6cc4dd7d68a08028c]

Felipe Balbi (3):
      usb: dwc3: core: fix order of PM runtime calls
         [fed33afce0eda44a46ae24d93aec1b5198c0bac4]
      usb: dwc3: core: use pm_runtime_put_sync() on remove
         [16b972a592ea2c9a3c2a3c12238de650fd4043a9]
      usb: host: xhci: fix compliance mode workaround
         [96908589a8b2584b1185f834d365f5cc360e8226]

Hannes Frederic Sowa (1):
      ipv6: reuse ip6_frag_id from ip6_ufo_append_data
         [916e4cf46d0204806c062c8c6c4d1f633852c5b6]

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
         [271329b3c798b2102120f5df829071c211ef00ed]
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
         [cc18a69c92d0972bc2fc5a047ee3be1e8398171b]
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6
         [d2682118f4bb3ceb835f91c1a694407a31bb7378]

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system
         [3189eddbcafcc4d827f7f19facbeddec4424eba8]

Ilya Dryomov (3):
      libceph: add process_one_ticket() helper
         [597cda357716a3cf8d994cb11927af917c8d71fa]
      libceph: do not hard code max auth ticket len
         [c27a3e4d667fdcad3db7b104f75659478e0c68d8]
      libceph: rename ceph_msg::front_max to front_alloc_len
         [3cea4c3071d4e55e9d7356efe9d0ebf92f0c2204]

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
         [1b071a0947dbce5c184c12262e02540fbc493457]
      ata_piix: Add Device IDs for Intel 9 Series PCH
         [6cad1376954e591c3c41500c4e586e183e7ffe6d]

Jan Kara (1):
      ext2: Fix fs corruption in ext2_get_xip_mem()
         [7ba3ec5749ddb61f79f7be17b5fd7720eebc52de]

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring
         [2ff396be602f10b5eab8e73b24f20348fa2de159]

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock
         [6726655dfdd2dc60c035c690d9f10cb69d7ea075]

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist
         [c605f3cdff53a743f6d875b76956b239deca1272]

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure
         [8ae757d09c45102b347a1bc2867f54ffc1ab8fda]

Johan Hovold (1):
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
         [ee444609dbae8afee420c3243ce4c5f442efb622]

Johannes Berg (1):
      nl80211: clear skb cb before passing to netlink
         [bd8c78e78d5011d8111bc2533ee73b13a3bd6c42]

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds
         [d26a7730b5874a5fa6779c62f4ad7c5065a94723]

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl
         [a80d8b02751060a178bb1f7a6b7a93645a7a308b]

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new
         [5760a97c7143c208fa3a8f8cad0ed7dd672ebd28]

Josh Triplett (1):
      init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
         [361e9dfbaae84b0b246ed18d1ab7c82a1a41b53e]

Julian Anastasov (1):
      ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack
         [2627b7e15c5064ddd5e578e4efd948d48d531a3f]

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime
         [2da78092dda13f1efd26edbbf99a567776913750]

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID
         [c66517165610b911e4c6d268f28d8c640832dbd1]

Marc Kleine-Budde (2):
      can: flexcan: mark TX mailbox as TX_INACTIVE
         [c32fe4ad3e4861b2bfa1f44114c564935a123dda]
      can: flexcan: put TX mailbox into TX_INACTIVE mode after tx-complete
         [de5944883ebbedbf5adc8497659772f5da7b7d72]

Marcelo Ricardo Leitner (3):
      ipv4: avoid parallel route cache gc executions
         [not upstream; route cache has been removed]
      ipv4: disable bh while doing route gc
         [not upstream; route cache has been removed]
      ipv4: move route garbage collector to work queue
         [not upstream; route cache has been removed]

Mark (4):
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapter
         [67d365a57a51fb9dece6a5ceb504aa381cae1e5b]
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI adapter
         [b6a3ed677991558ce09046397a7c4d70530d15b3]
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters
         [c80b4495c61636edc58fe1ce300f09f24db28e10]
      storage: Add single-LUN quirk for Jaz USB Adapter
         [c66f1c62e85927357e7b3f4c701614dcb5c498a2]

Mark Brown (1):
      regmap: Fix handling of volatile registers for format_write() chips
         [5844a8b9d98ec11ce1d77610daacf3f0a0e14715]

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32
         [8a574cfa2652545eb95595d38ac2a0bb501af0ae]

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks
         [bbe1c2740d3a25aa1dbe5d842d2ff09cddcdde0a]

Mathias Nyman (1):
      xhci: Fix null pointer dereference if xhci initialization fails
         [c207e7c50f31113c24a9f536fcab1e8a256985d7]

Mel Gorman (1):
      mm: migrate: Close race between migration completion and mprotect
         [d3cb8bf6081b8b7a2dabb1264fe968fd870fa595]

Mike Christie (1):
      [SCSI] libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu
         [db9bfd64b14a3a8f1868d2164518fdeab1b26ad1]

Miklos Szeredi (1):
      shmem: fix nlink for rename overwrite directory
         [b928095b0a7cff7fb9fcf4c706348ceb8ab2c295]

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space
         [d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed]

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller
         [c5edfff9db6f4d2c35c802acb4abe0df178becee]

Nadav Amit (4):
      KVM: x86: Check non-canonical addresses upon WRMSR
         [854e8bb1aa06c578c2c9145fa6bfe3680ef63b23]
      KVM: x86: Emulator fixes for eip canonical checks on near branches
         [234f3ce485d54017f15cf5e0699cff4100121601]
      KVM: x86: Fix wrong masking on relative jump/call
         [05c83ec9b73c8124555b706f6af777b10adf0862]
      KVM: x86: Handle errors when RIP is set during far jumps
         [d1442d85cc30ea75f7d399474ca738e0bc96f715]

Nadav Har'El (1):
      nEPT: Nested INVEPT
         [bfd0a56b90005f8c8a004baf407ad90045c2b11e]

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_diffcid
         [b53b0d99d6fbf7d44330395349a895521cfdbc96]

Paolo Bonzini (1):
      KVM: x86: use new CS.RPL as CPL during task switch
         [2356aaeb2f58f491679dc0c38bc3f6dbe54e7ded]

Peter Zijlstra (1):
      perf: fix perf bug in fork()
         [6c72e3501d0d62fc064d3680e5234f3463ec5a86]

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully
         [a642fc305053cc1c6e47e4f4df327895747ab485]

Richard Larocque (3):
      alarmtimer: Do not signal SIGEV_NONE timers
         [265b81d23a46c39df0a735a3af4238954b41a4c2]
      alarmtimer: Lock k_itimer during timer callback
         [474e941bed9262f5fa2394f9a4a67e24499e5926]
      alarmtimer: Return relative times in timer_gettime
         [e86fea764991e00a03ff1e56409ec9cacdbda4c9]

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store
         [5ca918e5e3f9df4634077c06585c42bc6a8d699a]

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming
         [61a734d305e16944b42730ef582a7171dc733321]

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon
         [73c3d4812b4c755efeca0140f606f83772a39ce4]

Sergio Gelato (1):
      nfsd: Fix ACL null pointer deref
         [4ac7249ea5a0ceef9f8269f63f33cc873c3fac61]

Steven Rostedt (1):
      ring-buffer: Fix infinite spin in reading buffer
         [24607f114fd14f2f37e3e0cb3d47bce96e81e848]

Takashi Iwai (1):
      ALSA: hda - Fix COEF setups for ALC1150 codec
         [acf08081adb5e8fe0519eb97bb49797ef52614d6]

Takuya Yoshikawa (1):
      KVM: x86 emulator: Use opcode::execute for CALL
         [d4ddafcdf2201326ec9717172767cfad0ede1472]

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device
         [9c491c372d677b6420e0f8c6361fe422791662cc]

Tejun Heo (2):
      percpu: fix pcpu_alloc_pages() failure path
         [f0d279654dea22b7a6ad34b9334aee80cda62cde]
      percpu: perform tlb flush after pcpu_map_pages() failure
         [849f5169097e1ba35b90ac9df76b5bb6f9c0aabd]

Theodore Ts'o (1):
      ext4: fix BUG_ON in mb_free_blocks()
         [c99d1e6e83b06744c75d9f5e491ed495a7086b7b]

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path
         [13c42c2f43b19aab3195f2d357db00d1e885eaa8]

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle
         [f01ea0c3d9db536c64d47922716d8b3b8f21d850]

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device
         [675f0ab2fe5a0f7325208e60b617a5f32b86d72c]

Trond Myklebust (1):
      NFSv4: Fix another bug in the close/open_downgrade code
         [cd9288ffaea4359d5cfe2b8d264911506aed26a4]

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug
         [03bd4e1f7265548832a76e7919a81f3137c44fd1]

Wolfram Sang (1):
      regmap: if format_write is used, declare all registers as "unreadable"
         [4191f19792bf91267835eb090d970e9cd6277a65]

Yoichi Yuasa (1):
      MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches
         [5596b0b245fb9d2cefb5023b11061050351c1398]

 Makefile                                       |   4 +-
 arch/arm/mm/alignment.c                        |   3 +
 arch/mips/boot/compressed/decompress.c         |   1 +
 arch/mips/kernel/mcount.S                      |  12 ++
 arch/mips/mm/c-r4k.c                           |   2 +
 arch/parisc/Makefile                           |   7 +-
 arch/s390/kvm/kvm-s390.c                       |  10 -
 arch/x86/include/asm/kvm_host.h                |  14 ++
 arch/x86/include/asm/vmx.h                     |   4 +
 arch/x86/kernel/smpboot.c                      |   3 +
 arch/x86/kvm/emulate.c                         | 251 +++++++++++++++++-------
 arch/x86/kvm/i8254.c                           |   2 +
 arch/x86/kvm/mmu.c                             |   2 +
 arch/x86/kvm/svm.c                             |   2 +-
 arch/x86/kvm/vmx.c                             | 108 ++++++++++-
 arch/x86/kvm/x86.c                             |  27 ++-
 block/genhd.c                                  |  18 +-
 drivers/acpi/processor_idle.c                  |   4 +-
 drivers/ata/ahci.c                             |  10 +
 drivers/ata/ata_piix.c                         |   8 +
 drivers/base/regmap/regmap.c                   |   7 +-
 drivers/gpu/drm/i915/intel_bios.c              |   2 +-
 drivers/gpu/drm/i915/intel_lvds.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c       |   7 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c           |   3 +-
 drivers/input/mouse/elantech.c                 |   7 +
 drivers/input/mouse/synaptics.c                |  68 +++++--
 drivers/input/mouse/synaptics.h                |  11 ++
 drivers/input/serio/i8042-x86ia64io.h          |  15 ++
 drivers/input/serio/serport.c                  |  45 ++++-
 drivers/md/dm-crypt.c                          |  20 +-
 drivers/net/can/at91_can.c                     |   8 +-
 drivers/net/can/flexcan.c                      |  41 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |  13 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |   1 +
 drivers/scsi/libiscsi.c                        |  10 +
 drivers/target/iscsi/iscsi_target.c            |   4 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   2 +-
 drivers/usb/core/hub.c                         |   4 +-
 drivers/usb/dwc3/core.c                        |   6 +-
 drivers/usb/host/xhci-hub.c                    |   8 +-
 drivers/usb/host/xhci-mem.c                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                  |   3 +
 drivers/usb/serial/ftdi_sio_ids.h              |  12 ++
 drivers/usb/serial/sierra.c                    |   9 +-
 drivers/usb/storage/unusual_devs.h             |  38 ++++
 drivers/uwb/lc-dev.c                           |  13 +-
 drivers/xen/manage.c                           |   7 -
 fs/aio.c                                       |   7 +
 fs/buffer.c                                    |   6 +-
 fs/ext2/inode.c                                |   2 +
 fs/ext2/xip.c                                  |   1 +
 fs/ext4/mballoc.c                              |   5 +
 fs/namei.c                                     |  71 +++----
 fs/nfs/nfs4proc.c                              |  30 +--
 fs/nfsd/vfs.c                                  |   3 +
 fs/nilfs2/inode.c                              |   7 +-
 fs/ocfs2/dlm/dlmmaster.c                       |  18 +-
 fs/partitions/check.c                          |   2 +-
 fs/xfs/xfs_aops.c                              |  61 ++++++
 include/linux/alarmtimer.h                     |   1 +
 include/linux/ceph/messenger.h                 |   2 +-
 include/linux/jiffies.h                        |  12 --
 include/net/regulatory.h                       |   2 +-
 include/net/sctp/sctp.h                        |   5 +
 include/net/sctp/sm.h                          |   6 +-
 init/Kconfig                                   |   1 +
 kernel/cgroup.c                                |   5 +
 kernel/events/core.c                           |  14 +-
 kernel/fork.c                                  |   5 +-
 kernel/futex.c                                 |   1 +
 kernel/time.c                                  |  54 +++---
 kernel/time/alarmtimer.c                       |  40 ++--
 mm/migrate.c                                   |   5 +-
 mm/percpu-vm.c                                 |  22 ++-
 mm/percpu.c                                    |   2 +
 mm/shmem.c                                     |   4 +-
 net/ceph/auth_x.c                              | 256 +++++++++++++------------
 net/ceph/messenger.c                           |   6 +-
 net/ceph/mon_client.c                          |  16 +-
 net/ipv4/route.c                               |  58 ++++--
 net/ipv6/addrconf.c                            |  14 +-
 net/ipv6/udp.c                                 |   2 +-
 net/sctp/associola.c                           |   2 +
 net/sctp/inqueue.c                             |  33 +---
 net/sctp/sm_make_chunk.c                       |  99 +++++-----
 net/sctp/sm_statefuns.c                        |  21 +-
 net/wireless/nl80211.c                         |   6 +
 sound/core/pcm_lib.c                           |   8 +-
 sound/pci/hda/patch_realtek.c                  |   2 +
 90 files changed, 1261 insertions(+), 516 deletions(-)

-- 
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

