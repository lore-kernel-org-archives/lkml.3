Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaHDRSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:18:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56444 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.107020799@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/94] 3.2.62-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.62 release.
There are 94 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.61 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag
         [b14bf2d0c0358140041d1c1805a674376964d0e0]

Alex Deucher (2):
      drm/radeon/dp: return -EIO for flags not zero case
         [f6be5e64500abbba44e191e1ca0f3366c7d0291b]
      drm/radeon: avoid leaking edid data
         [0ac66effe7fcdee55bda6d5d10d3372c95a41920]

Alex Shi (1):
      include/linux/math64.h: add div64_ul()
         [c2853c8df57f49620d26f317d7d43347c29bfc2e]

Amitkumar Karwar (1):
      mwifiex: fix Tx timeout issue
         [d76744a93246eccdca1106037e8ee29debf48277]

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle
         [b9326057a3d8447f5d2e74a7b521ccf21add2ec0]

Andrey Utkin (1):
      appletalk: Fix socket referencing in skb
         [36beddc272c111689f3042bf3d10a64d8a805f93]

Axel Lin (2):
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
         [1035a9e3e9c76b64a860a774f5b867d28d34acc2]
      hwmon: (amc6821) Fix permissions for temp2_input
         [df86754b746e9a0ff6f863f690b1c01d408e3cdc]

Ben Hutchings (4):
      Revert "net: ip, ipv6: handle gso skbs in forwarding path"
         [not needed upstream as it has a complete fix for the bug]
      Revert "net: ipv4: ip_forward: fix inverted local_df  test"
         [not needed upstream as it has a complete fix for the bug]
      dns_resolver: Null-terminate the right string
         [640d7efe4c08f06c4ae5d31b79bd8740e7f6790a]
      score: Add missing #include <linux/export.h>
         [not needed upstream as header is included indirectly]

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2
         [3d28bd840b2d3981cd28caf5fe1df38f1344dd60]

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.
         [5a7fbe7e9ea0b1b9d7ffdba64db1faa3a259164c]

Bjørn Mork (1):
      usb: option: add/modify Olivetti Olicard modems
         [b0ebef36e93703e59003ad6a1a20227e47714417]

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
         [9ee755974bea2f9880e517ec985dc9dede1b3a36]
      ibmvscsi: Add memory barriers for send / receive
         [7114aae02742d6b5c5a0d39a41deb61d415d3717]

Catalin Marinas (1):
      mm: kmemleak: avoid false negatives on vmalloc'ed objects
         [7f88f88f83ed609650a01b18572e605ea50cd163]

Dan Carpenter (1):
      applicom: dereferencing NULL on error path
         [8bab797c6e5724a43b7666ad70860712365cdb71]

Daniel Borkmann (1):
      net: sctp: fix information leaks in ulpevent layer
         [8f2e5ae40ec193bc0a0ed99e95315c3eebca84ea]

Dave Chinner (2):
      xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near
         [76d095388b040229ea1aad7dea45be0cfa20f589]
      xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near
         [e3a746f5aab71f2dd0a83116772922fb37ae29d6]

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code
         [c021f241f4fab2bb4fc4120a38a828a03dd3f970]

David Vrabel (1):
      xen/manage: fix potential deadlock when resuming the console
         [1b6478231c6f5f844185acb32045cf195028cfce]

Dingtianhong (1):
      igmp: fix the problem when mc leave group
         [52ad353a5344f1f700c5b777175bdfa41d3cd65a]

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't enable CTS to self
         [43d826ca5979927131685cc2092c7ce862cb91cd]

Eric Dumazet (1):
      ipv4: fix buffer overflow in ip_options_compile()
         [10ec9472f05b45c94db3c854d22581a20b97db41]

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time==0
         [5dd214248f94d430d70e9230bda72f2654ac88a8]

Feng Tang (2):
      ACPI / EC: Add more debug info and trivial code cleanup
         [b76b51ba0cef13980813373a548a12206e3cd3c9]
      ACPI / EC: Don't count a SCI interrupt as a false one
         [a3cd8d2789c2e265e09377f260e7d2ac9cec81bb]

Fengguang Wu (1):
      unicore32: select generic atomic64_t support
         [82e54a6aaf8aec971fb16afa3a4404e238a1b98b]

Gavin Guo (1):
      usb: Check if port status is equal to RxDetect
         [bb86cf569bbd7ad4dce581a37c7fbd748057e9dc]

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context
         [391acf970d21219a2a5446282d3b20eace0c0d7a]

Guan Xuetao (1):
      unicore32: add ioremap_nocache definition
         [a50e4213e71adc7dde0d514aabd8af7275fee39f]

Guenter Roeck (3):
      hwmon: (adm1031) Fix writes to limit registers
         [145e74a4e5022225adb84f4e5d4fff7938475c35]
      hwmon: (adt7470) Fix writes to temperature limit registers
         [de12d6f4b10b21854441f5242dcb29ea96181e58]
      hwmon: (emc2103) Clamp limits instead of bailing out
         [f6c2dd20108c35e30e2c1f3c6142d189451a626b]

H. Peter Anvin (1):
      x86-32, espfix: Remove filter for espfix32 due to race
         [246f2d2ee1d715e1077fc47d61c394569c8ee692]

HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling
         [b292d7a10487aee6e74b1c18b8d95b92f40d4a4f]

Hugh Dickins (3):
      shmem: fix faulting into a hole while it's punched
         [f00cdc6df7d7cfcabb5b740911e6788cb0802bdb]
      shmem: fix faulting into a hole, not taking i_mutex
         [8e205f779d1443a94b5ae81aa359cb535dd3021e]
      shmem: fix splicing from a hole while it's punched
         [b1a366500bd537b50c3aad26dc7df083ec03a448]

Ivan Djelic (1):
      ARM: 7668/1: fix memset-related crashes caused by recent GCC (4.7.2) optimizations
         [455bd4c430b0c0a361f38e8658a0d6cb469942b5]

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug
         [76f47128f9b33af1e96819746550d789054c9664]

Jiang Liu (1):
      score: normalize global variables exported by vmlinux.lds
         [ae49b83dcacfb69e22092cab688c415c2f2d870c]

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io
         [10f1d5d111e8aed46a0f1179faf9a3cf422f689e]

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe
         [aea1ae8760314e072bf1b773521e9de5d5dda10d]

John Stultz (1):
      alarmtimer: Fix bug where relative alarm timers were treated as absolute
         [16927776ae757d0d132bdbfabbfe2c498342bd59]

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32
         [1871ee134b73fb4cadab75752a7152ed2813c751]

Lan Tianyu (1):
      ACPI / battery: Retry to get battery information if failed during probing
         [75646e758a0ecbed5024454507d5be5b9ea9dcbf]

Lennox Wu (1):
      Score: The commit is for compiling successfully. 	The modifications include: 	1. Kconfig of Score: we don't support ioremap  2. Missed headfile including 	3. There are some errors in other people's commit not checked by us, we fix it now 	3.1 arch/score/kernel/entry.S: wrong instructions 	3.2 arch/score/kernel/process.c : just some typos
         [5fbbf8a1a93452b26e7791cf32cefce62b0a480b]

Li RongQing (1):
      8021q: fix a potential memory leak
         [916c1689a09bc1ca81f2d7a34876f8d35aadd11b]

Lu Baolu (1):
      xhci: clear root port wake on bits if controller isn't wake-up capable
         [ff8cbf250b448aac35589f6075082c3fcad8a8fe]

Lv Zheng (4):
      ACPI / EC: Add asynchronous command byte write support
         [f92fca0060fc4dc9227342d0072d75df98c1e5a5]
      ACPI / EC: Avoid race condition related to advance_transaction()
         [66b42b78bc1e816f92b662e8888c89195e4199e1]
      ACPI / EC: Fix race condition in ec_transaction_completed()
         [c0d653412fc8450370167a3268b78fc772ff9c87]
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
         [9b80f0f73ae1583c22325ede341c74195847618c]

Manuel Schölling (1):
      dns_resolver: assure that dns_query() result is  null-terminated
         [84a7c0b1db1c17d5ded8d3800228a608e1070b40]

Markus F.X.J. Oberhumer (1):
      crypto: testmgr - update LZO compression test vectors
         [0ec7382036922be063b515b2a3f1d6f7a607392c]

Martin Lau (1):
      ring-buffer: Fix polling on trace_pipe
         [97b8ee845393701edc06e27ccec2876ff9596019]

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check
         [dab6cf55f81a6e16b8147aed9a843e1691dcd318]

Mateusz Guzik (1):
      sched: Fix possible divide by zero in avg_atom() calculation
         [b0ab99e7736af88b8ac1b7ae50ea287fffa2badc]

Mathias Krause (1):
      netfilter: ipt_ULOG: fix info leaks
         [278f2b3e2af5f32ea1afe34fa12a2518153e6e49]

Mathias Nyman (1):
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts
         [3213b151387df0b95f4eada104f68eb1c1409cb3]

Michael Cree (1):
      alpha: add io{read,write}{16,32}be functions
         [25534eb7707821b796fd84f7115367e02f36aa60]

Michal Nazarewicz (2):
      tools: ffs-test: fix header values endianess
         [f35f71244da6e51db4e1f2c7e318581f498ececf]
      usb: gadget: f_fs: fix NULL pointer dereference when there are no strings
         [f0688c8b81d2ea239c3fb0b848f623b579238d99]

Michal Schmidt (1):
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0
         [e5eca6d41f53db48edd8cf88a3f59d2c30227f8e]

Miklos Szeredi (2):
      fuse: handle large user and group ID
         [233a01fa9c4c7c41238537e8db8434667ff28a2f]
      fuse: timeout comparison fix
         [126b9d4365b110c157bc4cbc32540dfa66c9c85a]

Mikulas Patocka (1):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue
         [fd1232b214af43a973443aec6a2808f16ee5bf70]

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10
         [682367c494869008eb89ef733f196e99415ae862]

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()
         [0253d634e0803a8376a0d88efee0bf523d8673f9]

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at  end of an skb
         [2cd0d743b05e87445c54ca124a9916f22f16742e]

NeilBrown (1):
      md: flush writes before starting a recovery.
         [133d4527eab8d199a62eee6bd433f0776842df2e]

Nicolas Pitre (1):
      ARM: 7670/1: fix the memset fix
         [418df63adac56841ef6b0f1fcf435bc64d4ed177]

Pablo Neira Ayuso (1):
      ipvs: stop tot_stats estimator only under CONFIG_SYSCTL
         [9802d21e7a0b0d2167ef745edc1f4ea7a0fc6ea3]

Paolo Bonzini (1):
      KVM: x86: preserve the high 32-bits of the PAT register
         [7cb060a91c0efc5ff94f83c6df3ed705e143cdb9]

Peter Zijlstra (1):
      locking/mutex: Disable optimistic spinning on some architectures
         [4badad352a6bb202ec68afa7a574c0bb961e5ebc]

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members
         [36b15875a7819a2ec4cb5748ff7096ad7bd86cbb]

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages
         [c81c8a1eeede61e92a15103748c23d100880cc8a]

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt
         [3cf521f7dc87c031617fd47e4b7aa2593c2f3daf]

Sowmini Varadhan (1):
      sunvnet: clean up objects created in vnet_new() on  vnet_exit()
         [a4b70a07ed12a71131cab7adce2ce91c71b37060]

Stefan Assmann (1):
      igb: do a reset on SR-IOV re-init if device is down
         [76252723e88681628a3dbb9c09c963e095476f73]

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax
         [8142b215501f8b291a108a202b3a053a265b03dd]

Takao Indoh (1):
      iommu/vt-d: Disable translation if already enabled
         [3a93c841c2b3b14824f7728dd74bd00a1cedb806]

Tejun Heo (1):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers
         [1a112d10f03e83fb3a2fdc4c9165865dec8a3ca6]

Theodore Ts'o (1):
      ext4: clarify error count warning messages
         [ae0f78de2c43b6fadd007c231a352b13b5be8ed2]

Thomas Gleixner (1):
      nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
         [0e576acbc1d9600cf2d9b4a141a2554639959d50]

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:
         [4e578080ed3262ed2c3985868539bc66218d25c0]

Xi Wang (2):
      ceph: fix overflow check in build_snap_context()
         [80834312a4da1405a9bc788313c67643de6fcb4c]
      introduce SIZE_MAX
         [a3860c1c5dd1137db23d7786d284939c5761d517]

Yu Wang (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.
         [d6236f6d1d885aa19d1cd7317346fe795227a3cc]

 Makefile                                    |   4 +-
 arch/alpha/include/asm/io.h                 |   5 +
 arch/arm/Kconfig                            |   1 +
 arch/arm/lib/memset.S                       | 100 +++++++++----------
 arch/arm/mach-omap2/mux.c                   |   6 +-
 arch/powerpc/Kconfig                        |   1 +
 arch/s390/kernel/ptrace.c                   |   9 +-
 arch/score/Kconfig                          |   3 +
 arch/score/include/asm/io.h                 |   1 -
 arch/score/include/asm/pgalloc.h            |   2 +-
 arch/score/kernel/entry.S                   |   4 +-
 arch/score/kernel/init_task.c               |   1 +
 arch/score/kernel/vmlinux.lds.S             |   1 +
 arch/score/mm/init.c                        |   1 +
 arch/sparc/Kconfig                          |   1 +
 arch/unicore32/Kconfig                      |   1 +
 arch/unicore32/include/asm/io.h             |   1 +
 arch/x86/Kconfig                            |   1 +
 arch/x86/include/asm/kvm_host.h             |   4 +-
 arch/x86/kernel/cpu/perf_event_intel.c      |   9 ++
 arch/x86/kernel/entry_32.S                  |  14 +--
 arch/x86/mm/ioremap.c                       |  26 +++--
 crypto/testmgr.h                            |  38 +++----
 drivers/acpi/battery.c                      |  27 ++++-
 drivers/acpi/ec.c                           | 148 ++++++++++++++--------------
 drivers/ata/libata-core.c                   |  12 ++-
 drivers/char/applicom.c                     |   1 -
 drivers/gpu/drm/radeon/atombios_dp.c        |   2 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c          |   1 -
 drivers/hwmon/adm1029.c                     |   3 +
 drivers/hwmon/adm1031.c                     |   8 +-
 drivers/hwmon/adt7470.c                     |   6 +-
 drivers/hwmon/amc6821.c                     |   2 +-
 drivers/hwmon/emc2103.c                     |  15 +--
 drivers/iommu/dmar.c                        |  11 ++-
 drivers/iommu/intel-iommu.c                 |  15 +++
 drivers/md/dm-io.c                          |  22 ++---
 drivers/md/md.c                             |  13 +++
 drivers/net/ethernet/intel/igb/igb_main.c   |   2 +
 drivers/net/ethernet/sun/sunvnet.c          |  20 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  13 ---
 drivers/net/wireless/mwifiex/main.c         |   1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c            |   3 +-
 drivers/scsi/ibmvscsi/rpa_vscsi.c           |  10 ++
 drivers/scsi/sd.c                           |   5 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |   4 +
 drivers/usb/core/hub.c                      |  20 ++++
 drivers/usb/gadget/f_fs.c                   |  12 ++-
 drivers/usb/host/xhci-hub.c                 |   5 +-
 drivers/usb/host/xhci-ring.c                |   2 +-
 drivers/usb/host/xhci.c                     |  10 +-
 drivers/usb/serial/cp210x.c                 |   1 +
 drivers/usb/serial/ftdi_sio.c               |  10 +-
 drivers/usb/serial/ftdi_sio_ids.h           |   3 +-
 drivers/usb/serial/option.c                 |  24 +++--
 drivers/usb/storage/scsiglue.c              |   4 +
 drivers/usb/storage/unusual_devs.h          |   7 ++
 drivers/xen/manage.c                        |   5 +-
 fs/ceph/snap.c                              |   2 +-
 fs/ext4/super.c                             |   9 +-
 fs/fuse/dir.c                               |   6 +-
 fs/fuse/inode.c                             |  20 +++-
 fs/jbd2/transaction.c                       |   5 +-
 fs/nfsd/nfs4proc.c                          |   9 --
 fs/nfsd/nfs4xdr.c                           |  13 ++-
 fs/xfs/xfs_alloc.c                          |   3 +-
 include/drm/drm_mem_util.h                  |   4 +-
 include/linux/kernel.h                      |   1 +
 include/linux/libata.h                      |   1 +
 include/linux/math64.h                      |   6 +-
 include/linux/skbuff.h                      |  17 ----
 include/linux/slab.h                        |   2 +-
 include/linux/usb_usual.h                   |   4 +-
 include/scsi/scsi_device.h                  |   1 +
 kernel/Kconfig.locks                        |   6 +-
 kernel/cpuset.c                             |   8 +-
 kernel/sched_debug.c                        |   2 +-
 kernel/time/alarmtimer.c                    |  20 +++-
 kernel/time/tick-sched.c                    |   4 +-
 kernel/trace/trace.c                        |   2 -
 mm/hugetlb.c                                |   1 +
 mm/kmemleak.c                               |   4 +-
 mm/mempolicy.c                              |   2 -
 mm/shmem.c                                  | 139 ++++++++++++++++++++++++--
 mm/truncate.c                               |  25 -----
 mm/vmalloc.c                                |  14 ++-
 net/8021q/vlan_core.c                       |   5 +-
 net/appletalk/ddp.c                         |   3 -
 net/core/rtnetlink.c                        |  22 ++++-
 net/dns_resolver/dns_query.c                |   4 +-
 net/ipv4/igmp.c                             |  10 +-
 net/ipv4/ip_forward.c                       |  68 +------------
 net/ipv4/ip_options.c                       |   4 +
 net/ipv4/netfilter/ipt_ULOG.c               |   7 +-
 net/ipv4/tcp_input.c                        |   2 +-
 net/ipv6/ip6_output.c                       |  13 +--
 net/l2tp/l2tp_ppp.c                         |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c              |   2 +-
 net/sctp/ulpevent.c                         | 122 +++--------------------
 tools/usb/ffs-test.c                        |   4 +-
 101 files changed, 733 insertions(+), 553 deletions(-)

-- 
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

