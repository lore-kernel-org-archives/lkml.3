Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaLCL0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:26:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaLCL0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:26:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/101] 3.12.34-stable review
Date: Wed,  3 Dec 2014 12:26:07 +0100
Message-Id: <cover.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.34 release.
There are 101 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Dec  5 12:25:22 CET 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.34-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Al Viro (1):
  fix O_SYNC|O_APPEND syncing the wrong range on write()

Alex Deucher (2):
  drm/radeon: make sure mode init is complete in bandwidth_update
  drm/radeon: add missing crtc unlock when setting up the MC

Alexey Khoroshilov (1):
  ieee802154: fix error handling in ieee802154fake_probe()

Allen Pais (2):
  sunvdc: add cdrom and v1.1 protocol support
  sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
  sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andreas Rohner (1):
  nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

Andrey Vagin (1):
  ipc: always handle a new value of auto_msgmni

Andy Lutomirski (1):
  x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Arnd Bergmann (3):
  pcmcia: sa1100: H3100 and H3600 share a driver
  pcmcia: pxa2xx: fix logic for lubbock
  pcmcia: journada720: use sa1100 pin interfaces correctly

Ben Dooks (1):
  ARM: probes: fix instruction fetch order with <asm/opcodes.h>

Bjorn Helgaas (3):
  vmcore: Remove "weak" from function declarations
  kgdb: Remove "weak" from kgdb_arch_pc() declaration
  clocksource: Remove "weak" from clocksource_default_clock()
    declaration

Christoph Hellwig (1):
  scsi: only re-lock door after EH on devices that were reset

Cristian Stoica (1):
  crypto: caam - remove duplicated sg copy functions

Dan Carpenter (2):
  [media] usbvision-video: two use after frees
  drivers/vlynq/vlynq.c: fix another resource size off by 1 error

Daniel Borkmann (5):
  net: sctp: fix NULL pointer dereference in af->from_addr_param on
    malformed packet
  net: sctp: fix memory leak in auth key management
  net: sctp: fix remote memory pressure from excessive queueing
  net: sctp: fix panic on duplicate ASCONF chunks
  net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

David S. Miller (3):
  sparc64: Fix crashes in schizo_pcierr_intr_other().
  sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().
  sparc64: Fix constraints on swab helpers.

Dmitry Eremin-Solenikov (1):
  Input: wm97xx - adapt parameters to tosa touchscreen.

Dmitry Torokhov (1):
  Input: evdev - fix EVIOCG{type} ioctl

Dwight Engen (3):
  sunvdc: limit each sg segment to a page
  vio: fix reuse of vio_dring slot
  sunvdc: don't call VD_OP_GET_VTOC

Emmanuel Grumbach (1):
  iwlwifi: configure the LTR

Ezequiel Garcia (1):
  parport: Add support for the WCH353 1S/1P multi-IO card

Fabian Frederick (1):
  fs/jfs/jfs_inode.c: atomically set inode->i_flags

Florian Westphal (2):
  netfilter: nf_log: account for size of NLMSG_DONE attribute
  netfilter: nfnetlink_log: fix maximum packet length logged to
    userspace

Greg Kurz (1):
  hwrng: pseries - port to new read API and fix stack corruption

Heinz Mauelshagen (1):
  dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
  parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop
    syscalls

Herbert Xu (2):
  tun: Fix csum_start with VLAN acceleration
  macvtap: Fix csum_start when VLAN tags are present

Houcheng Lin (1):
  netfilter: nf_log: release skbuff on nlmsg put failure

Ilya Dryomov (1):
  libceph: do not crash on large auth tickets

James Ralston (1):
  ahci: Add Device IDs for Intel Sunrise Point PCH

Jammy Zhou (1):
  drm/radeon: set correct CE ram size for CIK

Jan Kara (2):
  block: Fix computation of merged request priority
  nfs: Fix use of uninitialized variable in nfs_getattr()

Jiri Bohac (1):
  ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Joe Schultz (2):
  vme_tsi148: Fix PCI address mapping assumption
  vme_tsi148: Fix typo in tsi148_slave_get()

Joe Thornber (2):
  dm thin: grab a virtual cell before looking up the mapping
  dm btree: fix a recursion depth bug in btree walking code

Johan Hovold (1):
  pcmcia: at91_cf: fix deferred probe from __init

Johannes Berg (2):
  mac80211: properly flush delayed scan work on interface removal
  mac80211: fix use-after-free in defragmentation

Junjie Mao (1):
  mac80211_hwsim: release driver when ieee80211_register_hw fails

Kyle McMartin (1):
  arm64: __clear_user: handle exceptions on strb

Luciano Coelho (1):
  mac80211: schedule the actual switch of the station before CSA count 0

Marcelo Leitner (1):
  vxlan: Do not reuse sockets for a different address family

Martin Hauke (1):
  qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Martyn Welch (1):
  VME: Stop using memcpy_[to|from]io() due to unwanted behaviour

Mathias Krause (1):
  pptp: fix stack info leak in pptp_getname()

Max Filippov (1):
  xtensa: re-wire umount syscall to sys_oldumount

Michael Ellerman (1):
  hwrng: pseries - Return errors to upper levels in pseries-rng.c

Micky Ching (1):
  drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove
    driver

Miklos Szeredi (1):
  audit: keep inode pinned

Mikulas Patocka (1):
  dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (1):
  KVM: x86: Don't report guest userspace emulation error to userspace

Nathan Lynch (1):
  ARM: 8198/1: make kuser helpers depend on MMU

Pablo Neira (1):
  netfilter: xt_bpf: add mising opaque struct sk_filter definition

Pali Rohár (3):
  Input: alps - ignore potential bare packets when device is out of sync
  Input: alps - allow up to 2 invalid packets without resetting device
  Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Panu Matilainen (1):
  ipv4: Fix incorrect error code when adding an unreachable route

Paolo Bonzini (1):
  x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is
    read-only

Paul E. McKenney (1):
  rcu: Make callers awaken grace-period kthread

Peng Tao (1):
  nfs: fix pnfs direct write memory leak

Pranith Kumar (1):
  rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Qi Yong (1):
  minix zmap block counts calculation fix

Sergei Antonov (1):
  hfsplus: emit proper file type from readdir

Sougata Santra (1):
  fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks

Stefan Richter (1):
  firewire: cdev: prevent kernel stack leaking into ioctl arguments

Steffen Klassert (3):
  ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
  sit: Use ipip6_tunnel_init as the ndo_init function.
  gre6: Move the setting of dev->iflink into the ndo_init functions.

Takashi Iwai (2):
  ALSA: usb-audio: Fix memory leak in FTU quirk
  pvpanic: Set high notifier priority

Tejun Heo (1):
  ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Theodore Ts'o (1):
  ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Tobias Klauser (1):
  Input: altera_ps2 - write to correct register when disabling
    interrupts

Trond Myklebust (4):
  NFSv4: Ensure that we remove NFSv4.0 delegations when state has
    expired
  NFS: Don't try to reclaim delegation open state if recovery failed
  NFSv4: Fix races between nfs_remove_bad_delegation() and delegation
    return
  NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust
    NFS_DELEGATED_STATE

Vincent BENAYOUN (1):
  inetdevice: fixed signed integer overflow

Vyacheslav Dubeyko (1):
  hfsplus: fix remount issue

Weijie Yang (1):
  zram: avoid kunmap_atomic() of a NULL pointer

Will Deacon (1):
  ARM: 8191/1: decompressor: ensure I-side picks up relocated code

 arch/arm/boot/compressed/head.S                 |  20 ++-
 arch/arm/kernel/kprobes-common.c                |  19 +--
 arch/arm/kernel/kprobes-thumb.c                 |  21 +--
 arch/arm/kernel/kprobes.c                       |   9 +-
 arch/arm/mm/Kconfig                             |   1 +
 arch/arm64/lib/clear_user.S                     |   2 +-
 arch/parisc/include/uapi/asm/shmbuf.h           |  25 ++--
 arch/parisc/kernel/syscall_table.S              |   8 +-
 arch/sparc/include/asm/atomic_32.h              |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h             |  12 +-
 arch/sparc/include/asm/vio.h                    |  14 +-
 arch/sparc/include/uapi/asm/swab.h              |  12 +-
 arch/sparc/kernel/pci_schizo.c                  |   6 +-
 arch/sparc/kernel/smp_64.c                      |   4 +
 arch/sparc/lib/atomic32.c                       |  27 ++++
 arch/x86/include/asm/cpufeature.h               |   1 +
 arch/x86/include/asm/kvm_para.h                 |  10 +-
 arch/x86/kernel/cpu/amd.c                       |   7 +
 arch/x86/kernel/ptrace.c                        |  11 +-
 arch/x86/kvm/x86.c                              |   2 +-
 arch/xtensa/include/uapi/asm/unistd.h           |   3 +-
 drivers/ata/ahci.c                              |  19 ++-
 drivers/block/sunvdc.c                          | 176 +++++++++++++++++-------
 drivers/char/hw_random/pseries-rng.c            |  23 +++-
 drivers/crypto/caam/caamhash.c                  |  22 +--
 drivers/crypto/caam/sg_sw_sec4.h                |  38 -----
 drivers/firewire/core-cdev.c                    |   3 +-
 drivers/gpu/drm/radeon/cik.c                    |   7 +-
 drivers/gpu/drm/radeon/evergreen.c              |   4 +
 drivers/gpu/drm/radeon/r100.c                   |   3 +
 drivers/gpu/drm/radeon/rs600.c                  |   3 +
 drivers/gpu/drm/radeon/rs690.c                  |   3 +
 drivers/gpu/drm/radeon/rv515.c                  |   3 +
 drivers/gpu/drm/radeon/si.c                     |   3 +
 drivers/input/evdev.c                           |  13 +-
 drivers/input/mouse/alps.c                      |  26 +++-
 drivers/input/serio/altera_ps2.c                |   2 +-
 drivers/input/touchscreen/wm97xx-core.c         |   4 +-
 drivers/md/dm-bufio.c                           |  12 +-
 drivers/md/dm-raid.c                            |  11 +-
 drivers/md/dm-thin.c                            |  16 ++-
 drivers/md/persistent-data/dm-btree-internal.h  |   6 +
 drivers/md/persistent-data/dm-btree-spine.c     |   2 +-
 drivers/md/persistent-data/dm-btree.c           |  24 ++--
 drivers/media/usb/usbvision/usbvision-video.c   |   2 +
 drivers/memstick/host/rtsx_pci_ms.c             |   1 +
 drivers/net/ethernet/sun/sunvnet.c              |   4 +-
 drivers/net/ieee802154/fakehard.c               |  13 +-
 drivers/net/macvtap.c                           |   2 +
 drivers/net/ppp/pptp.c                          |   4 +-
 drivers/net/tun.c                               |  16 ++-
 drivers/net/usb/qmi_wwan.c                      |   1 +
 drivers/net/vxlan.c                             |  28 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  35 ++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   9 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  16 ++-
 drivers/net/wireless/mac80211_hwsim.c           |   4 +-
 drivers/parport/parport_serial.c                |   9 ++
 drivers/pcmcia/Kconfig                          |   2 +-
 drivers/pcmcia/Makefile                         |   1 +
 drivers/pcmcia/at91_cf.c                        |  11 +-
 drivers/pcmcia/sa1111_jornada720.c              |  10 +-
 drivers/platform/x86/pvpanic.c                  |   1 +
 drivers/scsi/scsi_error.c                       |   4 +-
 drivers/staging/zram/zram_drv.c                 |   3 +-
 drivers/tty/serial/8250/8250_pci.c              |  10 ++
 drivers/vlynq/vlynq.c                           |   3 +-
 drivers/vme/bridges/vme_ca91cx42.c              |  29 ++--
 drivers/vme/bridges/vme_tsi148.c                |  28 ++--
 fs/cifs/file.c                                  |   4 +-
 fs/ext4/file.c                                  |   2 +-
 fs/ext4/inode.c                                 |   4 +-
 fs/hfsplus/dir.c                                |  20 ++-
 fs/hfsplus/extents.c                            |  14 +-
 fs/hfsplus/options.c                            |   2 +-
 fs/inode.c                                      |  31 +++++
 fs/ioprio.c                                     |  14 +-
 fs/jfs/jfs_inode.c                              |  16 +--
 fs/minix/bitmap.c                               |   2 +-
 fs/minix/inode.c                                |   4 +-
 fs/nfs/delegation.c                             |  25 +++-
 fs/nfs/delegation.h                             |   1 +
 fs/nfs/direct.c                                 |   1 +
 fs/nfs/inode.c                                  |   2 +-
 fs/nfs/nfs4proc.c                               |  68 +++++----
 fs/nilfs2/file.c                                |   8 +-
 fs/nilfs2/ioctl.c                               |   8 +-
 fs/nilfs2/segment.c                             |   3 +
 fs/nilfs2/super.c                               |   6 +
 fs/nilfs2/the_nilfs.h                           |  22 +++
 fs/ntfs/file.c                                  |   2 +-
 fs/sync.c                                       |  17 ---
 fs/xfs/xfs_file.c                               |   2 +-
 include/linux/clocksource.h                     |   2 +-
 include/linux/crash_dump.h                      |  15 +-
 include/linux/fs.h                              |  11 +-
 include/linux/inetdevice.h                      |   2 +-
 include/linux/kgdb.h                            |   2 +-
 include/linux/nfs_xdr.h                         |  11 ++
 include/net/sctp/sctp.h                         |   5 +
 include/net/sctp/sm.h                           |   6 +-
 include/uapi/linux/netfilter/xt_bpf.h           |   2 +
 ipc/ipc_sysctl.c                                |   3 +-
 kernel/audit_tree.c                             |   1 +
 kernel/rcutree.c                                |  22 ++-
 mm/filemap.c                                    |   4 +-
 net/ceph/crypto.c                               | 169 ++++++++++++++++++-----
 net/ipv4/fib_rules.c                            |   4 +
 net/ipv6/ip6_gre.c                              |   7 +-
 net/ipv6/ip6_tunnel.c                           |  10 +-
 net/ipv6/sit.c                                  |  15 +-
 net/ipx/af_ipx.c                                |   6 +-
 net/mac80211/iface.c                            |   7 +-
 net/mac80211/mlme.c                             |   3 +-
 net/mac80211/rx.c                               |  14 +-
 net/netfilter/nfnetlink_log.c                   |  31 +++--
 net/sctp/associola.c                            |   2 +
 net/sctp/auth.c                                 |   2 -
 net/sctp/inqueue.c                              |  33 +----
 net/sctp/sm_make_chunk.c                        | 102 ++++++++------
 net/sctp/sm_statefuns.c                         |  21 +--
 sound/usb/mixer_quirks.c                        |   6 +
 125 files changed, 1103 insertions(+), 582 deletions(-)

-- 
2.1.3

