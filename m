Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaBLIl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:41:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751526AbaBLINi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:38 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 08:10:11 +0000
Message-ID: <lsq.1392192611.998273004@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/79] 3.2.55-rc1 review
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.55 release.
There are 79 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Feb 14 09:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.54 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
         [2afc745f3e3079ab16c826be4860da2529054dd2]

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report
         [9105bb149bbbc555d2e11ba5166dfe7a24eae09e]

Alex Deucher (2):
      drm/radeon: 0x9649 is SUMO2 not SUMO
         [d00adcc8ae9e22eca9d8af5f66c59ad9a74c90ec]
      drm/radeon: Fix sideport problems on certain RS690 boards
         [8333f0fe133be420ce3fcddfd568c3a559ab274e]

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization
         [27c73ae759774e63313c1fbfeb17ba076cea64c5]

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption
         [70f2fe3a26248724d8a5019681a869abdaf3e89a]

Andy Honig (1):
      KVM: x86: Convert vapic synchronization to _cached functions  (CVE-2013-6368)
         [fda4e2e85589191b123d31cdc21fd33ee70f50fd]

Ben Hutchings (1):
      pci: Add PCI_DEVICE_SUB() macro
         [part of 3d567e0e291c4ffd041cf653aea3c38a1d5f4620]

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration
         [f0199bc5e3a3ec13f9bc938556517ec430b36437]

Chad Hanson (1):
      selinux: fix broken peer recv check
         [46d01d63221c3508421dd72ff9c879f61053cffc]

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr
         [d323e92cc3f4edd943610557c9ea1bb4bb5056e8]

Chris Wilson (1):
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+
         [a885b3ccc74d8e38074e1c43a47c354c5ea0b01e]

Colin Cross (1):
      sched/rt: Fix SCHED_RR across cgroups
         [454c79999f7eaedcdf4c15c449e43902980cbdf5]

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max
         [fe0d692bbc645786bce1a98439e548ae619269f5]

Dan Williams (1):
      net_dma: mark broken
         [77873803363c9e831fc1d1e6895c084279090c22]

Daniel Borkmann (2):
      net: inet_diag: zero out uninitialized idiag_{src,dst}  fields
         [b1aac815c0891fe4a55a6b0b715910142227700f]
      net: llc: fix use after free in llc_ui_recvmsg
         [4d231b76eef6c4a6bd9c96769e191517765942cb]

Dave Chinner (1):
      xfs: Account log unmount transaction correctly
         [3948659e30808fbaa7673bbe89de2ae9769e20a7]

David Henningsson (1):
      ALSA: hda - Add enable_msi=0 workaround for four HP machines
         [693e0cb052c607e2d41edf9e9f1fa99ff8c266c1]

David S. Miller (1):
      vlan: Fix header ops passthru when doing TX VLAN  offload.
         [2205369a314e12fcec4781cc73ac9c08fc2b47de]

Eric Dumazet (1):
      net: do not pretend FRAGLIST support
         [28e24c62ab3062e965ef1b3bcc244d50aee7fa85]

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()
         [5946d089379a35dda0e531710b48fca05446a196]

Florian Westphal (1):
      net: rose: restore old recvmsg behavior
         [f81152e35001e91997ec74a7b4e040e6ab0acccf]

Geert Uytterhoeven (1):
      sh: always link in helper functions extracted from libgcc
         [84ed8a99058e61567f495cc43118344261641c5f]

George Spelvin (1):
      ahci: add an observed PCI ID for Marvell 88se9172 SATA controller
         [fcce9a35f8faaa1f52236c554ef1b15d99a7537e]

Hannes Frederic Sowa (2):
      ipv6: don't count addrconf generated routes against gc  limit
         [a3300ef4bbb1f1e33ff0400e1e6cf7733d988f4f]
      net: avoid reference counter overflows on fib_rules in  multicast forwarding
         [95f4a45de1a0f172b35451fc52283290adb21f6e]

Ian Abbott (1):
      staging: comedi: cb_pcidio: fix for newer  PCI-DIO48H
         [0283f7a100882684ad32b768f9f1ad81658a0b92]

Jan Kara (1):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
         [df4e7ac0bb70abc97fbfd9ef09671fc084b3f9db]

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes
         [3f9aec7610b39521c7c69d754de7265f6994c194]

Jianguo Wu (1):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully
         [a49ecbcd7b0d5a1cda7d60e03df402dd0ef76ac8]

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun
         [bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575]

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function
         [ed697e1aaf7237b1a62af39f64463b05c262808d]

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments
         [f447ef4a56dee4b68a91460bcdfe06b5011085f2]

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks
         [4e8d2139802ce4f41936a687f06c560b12115247]

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP
         [7cb2ef56e6a8b7b368b2e883a0a47d02fed66911]

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities
         [757dfcaa41844595964f1220f1d33182dae49976]

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload
         [9278db6279e28d4d433bc8a848e10b4ece8793ed]

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround
         [26bef1318adc1b3a530ecc807ef99346db2aa8b0]

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask
         [657eb17d87852c42b55c4b06d5425baa08b2ddb3]

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu
         [c4602c1c818bd6626178d6d3fcc152d9f2f48ac0]

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry
         [90ff5d688e61f49f23545ffab6228bd7e87e6dc7]

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs
         [95e92fd40c967c363ad66b2fd1ce4dcd68132e54]

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8
         [87809942d3fa60bafb7a58d0bdb1c79e90a6821d]

Mike Galbraith (1):
      sched,rt: fix isolated CPUs leaving root_task_group indefinitely throttled
         [e221d028bb08b47e624c5f0a31732c642db9d19a]

Mikulas Patocka (1):
      hpfs: fix warnings when the filesystem fills up
         [bbd465df73f0d8ba41b8a0732766a243d0f5b356]

Myron Stowe (1):
      ahci: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b
         [69fd3157363935b1e052bd76b8f8ec65e494306e]

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120  to 0
         [388d3335575f4c056dcf7138a30f1454e2145cd8]

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket  state logic
         [70315d22d3c7383f9a508d0aab21e2eb35b2303a]

NeilBrown (3):
      md/raid10: fix bug when raid10 recovery fails to recover a block.
         [e8b849158508565e0cd6bc80061124afc5879160]
      md/raid10: fix two bugs in handling of known-bad-blocks.
         [b50c259e25d9260b9108dc0c2964c26e5ecbe1c1]
      md/raid5: Fix possible confusion when multiple write errors occur.
         [1cc03eb93245e63b0b7a7832165efdc52e25b4e6]

Nicholas Bellinger (1):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
         [4454b66cb67f14c33cd70ddcf0ff4985b26324b7]

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
         [c0c1439541f5305b57a83d599af32b74182933fe]

Paul Gortmaker (1):
      [IA64] Fix warning from machine_kexec.c
         [c19ce0ab53ad9698968a154647f3dc22aad6c45b]

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()
         [a4c96ae319b8047f62dedbe1eac79e321c185749]

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
         [407900cfb54bdb2cfa228010b6697305f66b2948]
      dm9601: work around tx fifo sync issue on dm962x
         [4263c86dca5198da6bd3ad826d0b2304fbe25776]

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h
         [bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6]

Robin H. Johnson (1):
      libata: disable a disk via libata.force params
         [b8bd6dc36186fe99afa7b73e9e2d9a98ad5c4865]

Russell King (2):
      ARM: fix "bad mode in ... handler" message for undefined instructions
         [29c350bf28da333e41e30497b649fe335712a2ab]
      ARM: fix footbridge clockevent device
         [4ff859fe1dc0da0f87bbdfff78f527898878fa4a]

Salva Peiró (1):
      hamradio/yam: fix info leak in ioctl
         [8e3fbf870481eb53b2d3a322d1fc395ad8b367ed]

Sasha Levin (2):
      net: unix: allow bind to fail on mutex lock
         [37ab4fa7844a044dc21fde45e2a0fc2f3c3b6490]
      rds: prevent dereference of a NULL device
         [c2349758acf1874e4c2b93fe41d072336f1a31d0]

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller
         [e098f5cbe9d410e7878b50f524dce36cc83ec40e]

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers
         [4cc629b7a20945ce35628179180329b6bc9e552b]

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()
         [3dc91d4338d698ce77832985f9cb183d8eeaf6be]

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family
         [73f0b56a1ff64e7fb6c3a62088804bab93bcedc2]

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines
         [6962d914f317b119e0db7189199b21ec77a4b3e0]

Theodore Ts'o (2):
      ext4: add explicit casts when masking cluster sizes
         [f5a44db5d2d677dfbf12deee461f85e9ec633961]
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
         [ae1495b12df1897d4f42842a7aa7276d920f6290]

Thomas Hellstrom (1):
      drm/ttm: Fix accesses through vmas with only partial coverage
         [d386735588c3e22129c2bc6eb64fc1d37a8f805c]

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to  loopback
         [18fc25c94eadc52a42c025125af24657a93638c0]

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in  hdlcdrv_ioctl()
         [e9db5c21d3646a6454fcd04938dd215ac3ab620a]

Yijing Wang (1):
      PCI: Enable ARI if dev and upstream bridge support it; disable otherwise
         [b0cc6020e1cc62f1253215f189611b34be4a83c7]

Ying Xue (1):
      sched/rt: Avoid updating RT entry timeout twice within one tick period
         [57d2aa00dcec67afa52478730f2b524521af14fb]

Zheng Yan (2):
      ceph: cleanup aborted requests when re-sending requests.
         [eb1b8af33c2e42a9a57fc0a7588f4a7b255d2e79]
      ceph: wake up 'safe' waiters when unregistering request
         [fc55d2c9448b34218ca58733a6f51fbede09575b]

 Documentation/kernel-parameters.txt             |  2 +
 Makefile                                        |  4 +-
 arch/arm/kernel/traps.c                         |  8 ++-
 arch/arm/mach-footbridge/dc21285-timer.c        |  9 +--
 arch/ia64/kernel/machine_kexec.c                |  2 +-
 arch/powerpc/include/asm/exception-64s.h        |  2 +-
 arch/sh/lib/Makefile                            |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c        | 53 +++++++++++++---
 arch/x86/kernel/traps.c                         | 13 ++--
 arch/x86/kvm/lapic.c                            | 22 ++++---
 arch/x86/kvm/lapic.h                            |  4 +-
 arch/x86/kvm/x86.c                              | 33 +---------
 drivers/ata/ahci.c                              | 15 +++--
 drivers/ata/libata-core.c                       |  4 ++
 drivers/dma/Kconfig                             |  1 +
 drivers/gpio/gpio-msm-v2.c                      |  4 +-
 drivers/gpu/drm/i915/i915_reg.h                 |  1 +
 drivers/gpu/drm/i915/intel_display.c            |  5 +-
 drivers/gpu/drm/radeon/rs690.c                  | 10 +++
 drivers/gpu/drm/ttm/ttm_bo_vm.c                 |  6 +-
 drivers/hwmon/coretemp.c                        |  2 +-
 drivers/md/raid10.c                             | 12 ++--
 drivers/md/raid5.c                              |  4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 13 ++--
 drivers/net/ethernet/broadcom/tg3.c             |  3 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c       |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c            |  1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c     |  2 +-
 drivers/net/hamradio/hdlcdrv.c                  |  2 +
 drivers/net/hamradio/yam.c                      |  1 +
 drivers/net/usb/dm9601.c                        | 34 +++++++---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c     | 52 ++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 25 +++++---
 drivers/net/wireless/ath/ath9k/main.c           |  5 +-
 drivers/net/wireless/rtlwifi/pci.c              |  4 +-
 drivers/pci/pci.c                               | 14 ++---
 drivers/staging/comedi/drivers/cb_pcidio.c      | 21 +++----
 drivers/target/iscsi/iscsi_target.c             | 26 ++++----
 drivers/usb/host/xhci-pci.c                     |  7 ++-
 fs/ceph/mds_client.c                            |  8 ++-
 fs/ext2/super.c                                 |  1 +
 fs/ext4/ext4.h                                  | 10 +++
 fs/ext4/ext4_jbd2.c                             |  4 ++
 fs/ext4/extents.c                               | 43 ++++++++-----
 fs/ext4/mballoc.c                               | 17 +++--
 fs/ext4/super.c                                 |  4 +-
 fs/hpfs/file.c                                  |  5 +-
 fs/nilfs2/segment.c                             | 10 +--
 fs/xfs/xfs_log.c                                |  3 +-
 include/drm/drm_pciids.h                        |  2 +-
 include/linux/hugetlb.h                         |  6 ++
 include/linux/netdevice.h                       |  9 +++
 include/linux/pci.h                             | 14 +++++
 include/linux/sched.h                           |  1 +
 kernel/sched.c                                  | 13 ++--
 kernel/sched_fair.c                             |  3 +
 kernel/sched_rt.c                               | 49 +++++++++++++--
 kernel/trace/ftrace.c                           |  2 +-
 mm/hugetlb.c                                    | 17 +++++
 mm/memory-failure.c                             | 16 +++--
 mm/mmap.c                                       | 15 ++---
 mm/swap.c                                       | 84 +++++++++++++++++++++++--
 net/8021q/vlan_dev.c                            | 18 +++++-
 net/bridge/br_multicast.c                       |  4 +-
 net/core/drop_monitor.c                         |  1 -
 net/ipv4/inet_diag.c                            | 20 +++++-
 net/ipv4/ipmr.c                                 |  7 ++-
 net/ipv6/ip6mr.c                                |  7 ++-
 net/ipv6/route.c                                |  8 +--
 net/llc/af_llc.c                                |  5 +-
 net/rds/ib.c                                    |  3 +-
 net/rds/ib_send.c                               |  5 +-
 net/rose/af_rose.c                              | 16 ++---
 net/unix/af_unix.c                              |  8 ++-
 net/wireless/radiotap.c                         |  4 ++
 security/selinux/hooks.c                        | 28 +++++++--
 security/selinux/include/objsec.h               |  5 +-
 sound/core/pcm_lib.c                            |  2 +
 sound/pci/hda/hda_intel.c                       |  4 ++
 sound/soc/codecs/wm8904.c                       |  2 +-
 tools/power/cpupower/utils/cpupower-set.c       |  6 +-
 81 files changed, 654 insertions(+), 265 deletions(-)

-- 
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

