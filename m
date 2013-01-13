Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3AMRpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450Ab3AMRpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:05 -0500
Message-Id: <20130113174255.736888844@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:42:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/49] 3.2.37-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.37 release.
There are 49 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Jan 15 21:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.36 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (1):
      drm/nouveau: fix init with agpgart-uninorth
         [eda85d6ad490923152544fba0473798b6cc0edf6]

Alex Deucher (2):
      drm/radeon: add connector table for Mac G4 Silver
         [cafa59b9011a7790be4ddd5979419259844a165d]
      drm/radeon: add connector table for SAM440ep embedded board
         [6a556039e7823d27a0a7f7724d4d455053ea9253]

Andreas Hartmann (1):
      rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
         [be03d4a45c09ee5100d3aaaedd087f19bc20d01f]

Andy Lutomirski (1):
      PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz
         [812089e01b9f65f90fc8fc670d8cce72a0e01fbb]

Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors
         [0602934f302e016e2ea5dc6951681bfac77455ef]

Christian Lamparter (1):
      p54usb: add USBIDs for two more p54usb devices
         [4010fe21a315b4223c25376714c6a2b61b722e5c]

Christoffer Dall (1):
      mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED
         [ad4b3fb7ff9940bcdb1e4cd62bd189d10fa636ba]

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and  dccp_v4/6_request_recv_sock
         [e337e24d6624e74a558aa69071e112a65f7b5758]

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call  set_huge_pte_at()
         [6cb9c3697585c47977c42c5cc1b9fc49247ac530]

Ed Cashin (1):
      aoe: do not call bdi_init after blk_alloc_queue
         [0a41409c518083133e79015092585d68915865be]

Eric Dumazet (5):
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
         [354e4aa391ed50a4d827ff6fc11e0667d0859b25]
      tcp: implement RFC 5961 3.2
         [282f23c6ee343126156dd41218b22ece96d747e3]
      tcp: implement RFC 5961 4.2
         [0c24604b68fc7810d429d6c3657b6f148270e528]
      tcp: refine SYN handling in tcp_validate_incoming
         [e371589917011efe6ff8c7dfb4e9e81934ac5855]
      tcp: tcp_replace_ts_recent() should not be called from  tcp_validate_incoming()
         [bd090dfc634ddd711a5fbd0cadc6e0ab4977bcaf]

Eric Wong (1):
      epoll: prevent missed events on EPOLL_CTL_MOD
         [128dd1759d96ad36c379240f8b9463e8acfd37a1]

Forrest Liu (1):
      ext4: fix extent tree corruption caused by hole punch
         [c36575e663e302dbaa4d16b9c72d2c9a913a9aef]

Gabor Juhos (1):
      powerpc: Add missing NULL terminator to avoid boot panic on PPC40x
         [e6449c9b2d90c1bd9a5985bf05ddebfd1631cd6b]

Hugh Dickins (1):
      tmpfs mempolicy: fix /proc/mounts corrupting memory
         [f2a07f40dbc603c15f8b06e6ec7f768af67b424f]

Jan Kara (2):
      ext4: check dioread_nolock on remount
         [261cb20cb2f0737a247aaf08dff7eb065e3e5b66]
      jbd2: fix assertion failure in jbd2_journal_flush()
         [d7961c7fa4d2e3c3f12be67e21ba8799b5a7238a]

Jeff Layton (1):
      cifs: adjust sequence number downward after signing NT_CANCEL request
         [31efee60f489c759c341454d755a9fd13de8c03d]

Jianpeng Ma (1):
      [SCSI] mvsas: Fix oops when ata commond timeout.
         [95ab000388974d8ffef8257306b4be6e8778b768]

Krzysztof Mazur (1):
      i915: ensure that VGA plane is disabled
         [0fde901f1ddd2ce0e380a6444f1fb7ca555859e9]

Lothar Waßmann (1):
      video: mxsfb: fix crash when unblanking the display
         [6c1ecba8d84841277d68140ef485335d5be28485]

Michael Tokarev (1):
      ext4: do not try to write superblock on ro remount w/o journal
         [d096ad0f79a782935d2e06ae8fb235e8c5397775]

Michal Hocko (1):
      mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT
         [53a59fc67f97374758e63a9c785891ec62324c81]

Namjae Jeon (1):
      udf: don't increment lenExtents while writing to a hole
         [fb719c59bdb4fca86ee1fd1f42ab3735ca12b6b2]

Niels Ole Salscheider (1):
      drm/radeon: Properly handle DDC probe for DP bridges
         [0a9069d34918659bc8a89e21e69e60b2b83291a3]

Rafael J. Wysocki (1):
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes
         [4f5f64cf0cc916220aaa055992e31195470cfe37]

Shan Hai (1):
      powerpc/vdso: Remove redundant locking in update_vsyscall_tz()
         [ce73ec6db47af84d1466402781ae0872a9e7873c]

Stanislaw Gruszka (2):
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
         [ab9d6e4ffe192427ce9e93d4f927b0faaa8a941e]
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
         [5b632fe85ec82e5c43740b52e74c66df50a37db3]

Stefan Hasko (1):
      net: sched: integer overflow fix
         [d2fe85da52e89b8012ffad010ef352a964725d5f]

Steven Rostedt (1):
      ftrace: Do not function trace inlined functions
         [45959ee7aa645815a5ce303a0ea1e48a21e67c6a]

Sujith Manoharan (1):
      ath9k_hw: Fix RX gain initvals for AR9485
         [a796a1dd5da9645ad77aa687d1a890ecd63ab5a6]

Tatyana Nikolova (2):
      RDMA/nes: Fix for crash when registering zero length MR for CQ
         [7d9c199a55200c9b9fcad08e150470d02fb385be]
      RDMA/nes: Fix for terminate timer crash
         [7bfcfa51c35cdd2d37e0d70fc11790642dd11fb3]

Tomasz Guszkowski (1):
      p54usb: add USB ID for T-Com Sinus 154 data II
         [3194b7fcdf6caea338b5d2c72d76fed80437649c]

Tony Prisk (2):
      drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield
         [532db570e5181abc8f4f7bfa6c77c69ec2240198]
      drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time
         [2f90b68309683f2c5765a1b04ca23d71e51f1494]

Trond Myklebust (1):
      SUNRPC: Ensure that we free the rpc_task after cleanups are done
         [c6567ed1402c55e19b012e66a8398baec2a726f3]

Weston Andros Adamson (4):
      NFS4: nfs4_opendata_access should return errno
         [998f40b550f257e436485291802fa938e4cf580f]
      NFS: Fix access to suid/sgid executables
         [f8d9a897d4384b77f13781ea813156568f68b83e]
      NFSv4: Add ACCESS operation to OPEN compound
         [6168f62cbde8dcf4f58255794efbcdb8df603959]
      NFSv4: don't check MAY_WRITE access bit in OPEN
         [bbd3a8eee82a2a6f4aa1cce60ccb014f25e5c560]

Xi Wang (1):
      nfs: fix null checking in nfs_get_option_str()
         [e25fbe380c4e3c09afa98bcdcd9d3921443adab8]

Zhang Rui (1):
      ACPI : do not use Lid and Sleep button for S5 wakeup
         [b7e383046c2c7c13ad928cd7407eafff758ddd4b]

 Documentation/networking/ip-sysctl.txt     |    5 ++
 Makefile                                   |    4 +-
 arch/powerpc/kernel/time.c                 |    5 --
 arch/powerpc/platforms/40x/ppc40x_simple.c |    3 +-
 arch/sparc/include/asm/hugetlb.h           |   10 ++-
 drivers/acpi/scan.c                        |    9 ++-
 drivers/block/aoe/aoe.h                    |    2 +-
 drivers/block/aoe/aoeblk.c                 |    5 --
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/intel_display.c       |   17 ++++
 drivers/gpu/drm/i915/intel_lvds.c          |    1 +
 drivers/gpu/drm/nouveau/nouveau_bo.c       |    2 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |  117 ++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++-
 drivers/gpu/drm/radeon/radeon_display.c    |   13 +++-
 drivers/gpu/drm/radeon/radeon_i2c.c        |   10 ++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    4 +-
 drivers/hwmon/lm73.c                       |   16 ++--
 drivers/infiniband/hw/nes/nes.h            |    1 +
 drivers/infiniband/hw/nes/nes_hw.c         |    9 +--
 drivers/infiniband/hw/nes/nes_verbs.c      |    9 ++-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 +-
 drivers/net/wireless/p54/p54usb.c          |    4 +
 drivers/net/wireless/rt2x00/rt2800lib.c    |    3 +-
 drivers/pci/quirks.c                       |    7 +-
 drivers/rtc/rtc-vt8500.c                   |   11 +--
 drivers/scsi/mvsas/mv_sas.c                |    2 +-
 drivers/video/mxsfb.c                      |    3 +-
 fs/cifs/transport.c                        |    7 ++
 fs/eventpoll.c                             |   22 +++++-
 fs/ext4/extents.c                          |   22 +++++-
 fs/ext4/super.c                            |   22 +++---
 fs/jbd2/transaction.c                      |    3 +-
 fs/nfs/dir.c                               |   33 ++++++--
 fs/nfs/nfs4proc.c                          |   56 +++++++++++--
 fs/nfs/nfs4xdr.c                           |   16 +++-
 fs/nfs/super.c                             |    2 +-
 fs/udf/inode.c                             |    7 +-
 include/asm-generic/tlb.h                  |    9 +++
 include/linux/compiler-gcc.h               |    5 ++
 include/linux/nfs_fs.h                     |    2 +
 include/linux/nfs_xdr.h                    |    3 +
 include/linux/page-flags.h                 |    8 +-
 include/linux/pci_ids.h                    |    1 +
 include/linux/snmp.h                       |    3 +-
 include/net/inet_connection_sock.h         |    1 +
 include/net/mac80211.h                     |    5 ++
 include/net/tcp.h                          |    1 +
 mm/memory.c                                |    5 ++
 mm/mempolicy.c                             |   64 +++++++--------
 net/dccp/ipv4.c                            |    4 +-
 net/dccp/ipv6.c                            |    3 +-
 net/ipv4/inet_connection_sock.c            |   16 ++++
 net/ipv4/proc.c                            |    3 +-
 net/ipv4/sysctl_net_ipv4.c                 |    7 ++
 net/ipv4/tcp_input.c                       |   93 ++++++++++++++++------
 net/ipv4/tcp_ipv4.c                        |    5 +-
 net/ipv6/tcp_ipv6.c                        |    3 +-
 net/mac80211/status.c                      |    6 +-
 net/sched/sch_htb.c                        |    2 +-
 net/sunrpc/sched.c                         |   27 ++++++-
 61 files changed, 581 insertions(+), 172 deletions(-)

-- 
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others.

