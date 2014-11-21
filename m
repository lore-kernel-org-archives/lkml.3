Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaKUUN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:13:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaKUUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:13:24 -0500
Date: Fri, 21 Nov 2014 12:12:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.25
Message-ID: <20141121201201.GA8553@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.25 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/ata/sata_rcar.txt |    3=20
 Makefile                                            |    2=20
 arch/arm/boot/compressed/head.S                     |   20 -
 arch/arm/kernel/kprobes-common.c                    |   19 -
 arch/arm/kernel/kprobes-thumb.c                     |   21 -
 arch/arm/kernel/kprobes.c                           |    9=20
 arch/arm/mm/Kconfig                                 |    1=20
 arch/arm64/kernel/insn.c                            |    5=20
 arch/arm64/lib/clear_user.S                         |    2=20
 arch/parisc/include/uapi/asm/shmbuf.h               |   25 -
 arch/parisc/kernel/syscall_table.S                  |    8=20
 arch/sparc/include/asm/atomic_32.h                  |    2=20
 arch/sparc/include/asm/cmpxchg_32.h                 |   12=20
 arch/sparc/include/asm/vio.h                        |   14=20
 arch/sparc/kernel/pci_schizo.c                      |    6=20
 arch/sparc/kernel/smp_64.c                          |    4=20
 arch/sparc/lib/atomic32.c                           |   27 +
 arch/x86/boot/compressed/Makefile                   |    4=20
 arch/x86/boot/compressed/head_32.S                  |    5=20
 arch/x86/boot/compressed/head_64.S                  |    5=20
 arch/x86/boot/compressed/misc.c                     |   13=20
 arch/x86/boot/compressed/mkpiggy.c                  |    9=20
 arch/x86/kernel/cpu/microcode/amd_early.c           |   33 +
 arch/x86/kernel/cpu/perf_event_intel.c              |    3=20
 arch/x86/kernel/ptrace.c                            |   11=20
 arch/x86/kvm/x86.c                                  |    2=20
 arch/x86/mm/pgtable.c                               |   21 -
 arch/x86/tools/calc_run_size.pl                     |   30 +
 arch/xtensa/include/uapi/asm/unistd.h               |    3=20
 drivers/ata/ahci.c                                  |   19 -
 drivers/ata/sata_rcar.c                             |   10=20
 drivers/base/regmap/regmap.c                        |    6=20
 drivers/block/sunvdc.c                              |  176 +++++++---
 drivers/block/zram/zram_drv.c                       |    3=20
 drivers/char/hw_random/pseries-rng.c                |   11=20
 drivers/crypto/caam/caamhash.c                      |   22 -
 drivers/crypto/caam/key_gen.c                       |   29 -
 drivers/crypto/caam/sg_sw_sec4.h                    |   54 ---
 drivers/firewire/core-cdev.c                        |    3=20
 drivers/gpu/drm/radeon/cik.c                        |    7=20
 drivers/gpu/drm/radeon/evergreen.c                  |    4=20
 drivers/gpu/drm/radeon/r100.c                       |    3=20
 drivers/gpu/drm/radeon/rs600.c                      |    3=20
 drivers/gpu/drm/radeon/rs690.c                      |    3=20
 drivers/gpu/drm/radeon/rv515.c                      |    3=20
 drivers/gpu/drm/radeon/si.c                         |    3=20
 drivers/infiniband/core/uverbs_cmd.c                |    2=20
 drivers/input/mouse/alps.c                          |   28 +
 drivers/input/mouse/synaptics.c                     |    5=20
 drivers/md/dm-bufio.c                               |   12=20
 drivers/md/dm-raid.c                                |   11=20
 drivers/md/dm-thin.c                                |   16=20
 drivers/md/md.c                                     |    4=20
 drivers/md/persistent-data/dm-btree-internal.h      |    6=20
 drivers/md/persistent-data/dm-btree-spine.c         |    2=20
 drivers/md/persistent-data/dm-btree.c               |   24 -
 drivers/media/usb/ttusb-dec/ttusbdecfe.c            |    3=20
 drivers/net/ethernet/smsc/smsc911x.c                |   46 ++
 drivers/net/ethernet/sun/sunvnet.c                  |    4=20
 drivers/net/macvtap.c                               |   15=20
 drivers/net/tun.c                                   |   35 --
 drivers/net/virtio_net.c                            |   24 -
 drivers/net/vxlan.c                                 |   28 +
 drivers/net/wireless/iwlwifi/iwl-trans.h            |    2=20
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h     |   35 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h           |    1=20
 drivers/net/wireless/iwlwifi/mvm/fw.c               |    9=20
 drivers/net/wireless/iwlwifi/mvm/ops.c              |    1=20
 drivers/net/wireless/iwlwifi/pcie/trans.c           |   16=20
 drivers/net/wireless/mac80211_hwsim.c               |    4=20
 drivers/platform/x86/dell-wmi.c                     |   12=20
 drivers/power/bq2415x_charger.c                     |   23 -
 drivers/power/charger-manager.c                     |  163 ++++++---
 drivers/scsi/scsi_error.c                           |    4=20
 fs/btrfs/compression.c                              |    2=20
 fs/btrfs/file.c                                     |    5=20
 fs/cramfs/inode.c                                   |    3=20
 fs/fuse/file.c                                      |    2=20
 fs/gfs2/meta_io.c                                   |    5=20
 fs/gfs2/meta_io.h                                   |    3=20
 fs/gfs2/ops_fstype.c                                |    2=20
 fs/ioprio.c                                         |   14=20
 fs/jffs2/fs.c                                       |    2=20
 fs/nfs/blocklayout/blocklayout.c                    |    2=20
 fs/nfs/delegation.c                                 |   25 +
 fs/nfs/delegation.h                                 |    1=20
 fs/nfs/direct.c                                     |    1=20
 fs/nfs/inode.c                                      |    2=20
 fs/nfs/nfs4proc.c                                   |   68 ++-
 fs/super.c                                          |   16=20
 include/dt-bindings/pinctrl/dra.h                   |    4=20
 include/linux/clocksource.h                         |    2=20
 include/linux/compaction.h                          |    4=20
 include/linux/crash_dump.h                          |   15=20
 include/linux/kgdb.h                                |    2=20
 include/linux/memory.h                              |    2=20
 include/linux/migrate.h                             |   11=20
 include/linux/mm.h                                  |   11=20
 include/linux/mmzone.h                              |    5=20
 include/linux/nfs_xdr.h                             |   11=20
 include/linux/pagemap.h                             |   30 -
 include/linux/pagevec.h                             |    5=20
 include/linux/power/charger-manager.h               |    3=20
 include/linux/radix-tree.h                          |    5=20
 include/linux/shmem_fs.h                            |    1=20
 include/net/sctp/sctp.h                             |    5=20
 include/net/sctp/sm.h                               |    6=20
 include/trace/events/compaction.h                   |   25 +
 include/uapi/linux/netfilter/xt_bpf.h               |    2=20
 ipc/ipc_sysctl.c                                    |    3=20
 kernel/audit.c                                      |    4=20
 kernel/audit_tree.c                                 |    1=20
 kernel/events/core.c                                |   23 +
 kernel/rcu/tree.c                                   |   22 +
 lib/radix-tree.c                                    |  106 +-----
 mm/compaction.c                                     |  249 ++++++++------
 mm/filemap.c                                        |  341 +++++++++++++++=
+----
 mm/internal.h                                       |   22 +
 mm/madvise.c                                        |    2=20
 mm/memory-failure.c                                 |    4=20
 mm/memory_hotplug.c                                 |    2=20
 mm/mempolicy.c                                      |    4=20
 mm/migrate.c                                        |   56 ++-
 mm/mincore.c                                        |   20 -
 mm/page_alloc.c                                     |   62 +--
 mm/readahead.c                                      |   27 -
 mm/shmem.c                                          |  122 +------
 mm/swap.c                                           |   51 ++
 mm/truncate.c                                       |   74 +++-
 mm/vmscan.c                                         |   36 +-
 net/ceph/crypto.c                                   |  169 +++++++--
 net/ipv6/ip6_gre.c                                  |    5=20
 net/ipv6/ip6_tunnel.c                               |   10=20
 net/ipv6/ip6_vti.c                                  |   11=20
 net/ipv6/sit.c                                      |   15=20
 net/mac80211/ibss.c                                 |    2=20
 net/mac80211/ieee80211_i.h                          |    3=20
 net/mac80211/iface.c                                |    7=20
 net/mac80211/mesh.c                                 |    2=20
 net/mac80211/mlme.c                                 |    5=20
 net/mac80211/rx.c                                   |   14=20
 net/mac80211/spectmgmt.c                            |   18 -
 net/netfilter/ipset/ip_set_core.c                   |    2=20
 net/netfilter/nfnetlink_log.c                       |   31 -
 net/netfilter/nft_compat.c                          |    2=20
 net/sctp/associola.c                                |    2=20
 net/sctp/auth.c                                     |    2=20
 net/sctp/inqueue.c                                  |   33 -
 net/sctp/sm_make_chunk.c                            |  102 +++--
 net/sctp/sm_statefuns.c                             |   21 -
 sound/usb/mixer_quirks.c                            |    6=20
 151 files changed, 2037 insertions(+), 1171 deletions(-)

Al Viro (1):
      callers of iov_copy_from_user_atomic() don't need pagecache_disable()

Alex Deucher (2):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: add missing crtc unlock when setting up the MC

Allen Pais (2):
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrey Vagin (1):
      ipc: always handle a new value of auto_msgmni

Andy Lutomirski (1):
      x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Arturo Borrero (1):
      netfilter: nft_compat: fix wrong target lookup in nft_target_select_o=
ps()

Ben Dooks (1):
      ARM: probes: fix instruction fetch order with <asm/opcodes.h>

Bjorn Helgaas (4):
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declarat=
ion
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      clocksource: Remove "weak" from clocksource_default_clock() declarati=
on

Borislav Petkov (2):
      x86, microcode, AMD: Fix early ucode loading on 32-bit
      x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset

Cristian Stoica (2):
      crypto: caam - fix missing dma unmap on error path
      crypto: caam - remove duplicated sg copy functions

Dan Carpenter (2):
      media: ttusb-dec: buffer overflow in ioctl
      netfilter: ipset: off by one in ip_set_nfnl_get_byindex()

Daniel Borkmann (5):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on mal=
formed packet
      net: sctp: fix memory leak in auth key management
      net: sctp: fix remote memory pressure from excessive queueing
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

Dave Chinner (1):
      fs/superblock: unregister sb shrinker before ->kill_sb()

David Rientjes (5):
      mm, migration: add destination page freeing callback
      mm, compaction: return failed migration target pages back to freelist
      mm, compaction: add per-zone migration pfn cache for async compaction
      mm, compaction: embed migration mode in compact_control
      mm, compaction: terminate async compaction when rescheduling

David S. Miller (2):
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().

Devesh Sharma (1):
      IB/core: Clear AH attr variable to prevent garbage data

Dwight Engen (3):
      sunvdc: limit each sg segment to a page
      vio: fix reuse of vio_dring slot
      sunvdc: don't call VD_OP_GET_VTOC

Emmanuel Grumbach (1):
      iwlwifi: configure the LTR

Enric Balletbo i Serra (1):
      smsc911x: power-up phydev before doing a software reset.

Fabian Frederick (1):
      mm/readahead.c: inline ra_submit

Florian Westphal (2):
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspa=
ce

Greg Kroah-Hartman (2):
      Revert "drivers/net: Disable UFO through virtio"
      Linux 3.14.25

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Heesub Shin (1):
      mm/compaction: clean up unused code lines

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop sys=
calls

Herbert Xu (2):
      tun: Fix csum_start with VLAN acceleration
      macvtap: Fix csum_start when VLAN tags are present

Houcheng Lin (1):
      netfilter: nf_log: release skbuff on nlmsg put failure

Hugh Dickins (1):
      mm: fix direct reclaim writeback regression

Ilya Dryomov (1):
      libceph: do not crash on large auth tickets

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Jammy Zhou (1):
      drm/radeon: set correct CE ram size for CIK

Jan Kara (2):
      block: Fix computation of merged request priority
      nfs: Fix use of uninitialized variable in nfs_getattr()

Joe Thornber (2):
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Johannes Weiner (5):
      lib: radix-tree: add radix_tree_delete_item()
      mm: shmem: save one radix tree lookup when truncating swapped pages
      mm: filemap: move radix tree hole searching here
      mm + fs: prepare for non-page entries in page cache radix trees
      mm: madvise: fix MADV_WILLNEED on shmem swapouts

Junjie Mao (2):
      mac80211_hwsim: release driver when ieee80211_register_hw fails
      x86, kaslr: Prevent .bss from overlaping initrd

Krzysztof Kozlowski (4):
      power: charger-manager: Fix accessing invalidated power supply after =
fuel gauge unbind
      power: charger-manager: Fix accessing invalidated power supply after =
charger unbind
      power: bq2415x_charger: Properly handle ENODEV from power_supply_get_=
by_phandle
      power: bq2415x_charger: Fix memory leak on DTS parsing error

Kyle McMartin (1):
      arm64: __clear_user: handle exceptions on strb

Luciano Coelho (2):
      mac80211: use secondary channel offset IE also beacons during CSA
      mac80211: schedule the actual switch of the station before CSA count 0

Marcelo Leitner (1):
      vxlan: Do not reuse sockets for a different address family

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Mel Gorman (1):
      mm: vmscan: use proportional scanning during direct reclaim and full =
scan at DEF_PRIORITY

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (1):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (1):
      KVM: x86: Don't report guest userspace emulation error to userspace

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

NeilBrown (1):
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Pablo Neira (1):
      netfilter: xt_bpf: add mising opaque struct sk_filter definition

Pali Roh=E1r (4):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
      dell-wmi: Fix access out of memory

Paul E. McKenney (1):
      rcu: Make callers awaken grace-period kthread

Pawel Moll (1):
      perf: Handle compat ioctl

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Pranith Kumar (1):
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Quentin Casasnovas (1):
      regmap: fix kernel hang on regmap_bulk_write with zero val_count.

Richard Guy Briggs (2):
      audit: correct AUDIT_GET_FEATURE return message type
      audit: AUDIT_FEATURE_CHANGE message format missing delimiting space

Roger Quadros (1):
      pinctrl: dra: dt-bindings: Fix output pull up/down

Sasha Levin (1):
      mm: remove read_cache_page_async()

Shaohua Li (1):
      x86/mm: In the PTE swapout page reclaim case clear the accessed bit i=
nstead of flushing the TLB

Simon Horman (1):
      ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Steffen Klassert (4):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      vti6: Use vti6_dev_init as the ndo_init function.
      sit: Use ipip6_tunnel_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Steven Whitehouse (1):
      GFS2: Fix address space from page function

Takashi Iwai (2):
      ALSA: usb-audio: Fix memory leak in FTU quirk
      Input: synaptics - add min/max quirk for Lenovo T440s

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Tim Chen (1):
      fs/superblock: avoid locking counting inodes and dentries before recl=
aiming them

Trond Myklebust (4):
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expir=
ed
      NFS: Don't try to reclaim delegation open state if recovery failed
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation r=
eturn
      NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED=
_STATE

Vince Weaver (1):
      perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Vlastimil Babka (5):
      mm/compaction: cleanup isolate_freepages()
      mm/compaction: do not count migratepages when unnecessary
      mm/compaction: avoid rescanning pageblocks in isolate_freepages
      mm, compaction: properly signal and act upon lock and need_sched() co=
ntention
      mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced

Weijie Yang (1):
      zram: avoid kunmap_atomic() of a NULL pointer

Will Deacon (1):
      ARM: 8191/1: decompressor: ensure I-side picks up relocated code

William Cohen (1):
      Correct the race condition in aarch64_insn_patch_text_sync()


--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUb5yRAAoJEDjbvchgkmk+dqgP/icEuBLaUK9BvsdZs0b1FBKG
Dm1vnxogiKJ2UYos3KQD0DZapTvu70QesvvFyTvRE/aPRJ0wy6o7G7rimZ38HlSW
TZ/xVMF3uFIirk4khpEtJhb1O0lVCSSSxtzssxytlUqiyv+uvtwb0w/82p/u7VIG
JLOOVM37VivtlzIAvnEtrnFX7+kIF9i0tm6m2Dx5pFMMHsfyvAQOp9VA/QEn9N8s
5Lt3NNaIsfF+JI7g6Oy5WCKBkm0QBLrXxkzD9pGNhFYLMmnq1t8fBCSNEdEJnh3m
4fhlfSqdnWY1XRn7V/CY260ocoEIr3dppI+eGkAZd936yZkqTeuYGL4AeLxX3KCC
gEwNetdBf2noLQ1LZS4OdPqgFyHZm3a/rmbTdUdMTAIyWNDh9iTi99J0ptaeWOZ6
YLStNGh3ZA7d12alBbCa/vHy6G+EntkQnscDDhlwdHXAFAZBB/p264ouuwn+qONt
WzPEc5lfoY8A2xZe6yWqNY7bpHX6Su0e20hkyrBiVrGmtJNQ7IoWqIFQKR51vX15
9OXMw6/ms7zFJfBEMbkBm1zm0s5gT+PVzLUnOzxkGJT0NugfCYMC9DFqTVwUR28/
ENOlGXLU5er79y1F3KRJ0qGTsojtl7fil6w5B5iOmft6Ct29AVX9cSW+FEeo3B5N
yeeL1ATJRpwT8Jdg7NA6
=SUj6
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
