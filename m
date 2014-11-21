Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKUUM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:12:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaKUUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:12:56 -0500
Date: Fri, 21 Nov 2014 12:11:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.61
Message-ID: <20141121201133.GA8476@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.61 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/alpha/mm/fault.c                           |    7=20
 arch/arc/mm/fault.c                             |   17 +-
 arch/arm/include/asm/bug.h                      |   10 -
 arch/arm/kernel/kprobes-common.c                |   19 +-
 arch/arm/kernel/kprobes-thumb.c                 |   20 +-
 arch/arm/kernel/kprobes.c                       |    9 -
 arch/arm/kernel/traps.c                         |    8 -
 arch/arm/mm/Kconfig                             |    1=20
 arch/arm/mm/fault.c                             |   23 +--
 arch/arm64/lib/clear_user.S                     |    2=20
 arch/arm64/mm/fault.c                           |   31 ++--
 arch/avr32/mm/fault.c                           |    4=20
 arch/cris/mm/fault.c                            |    6=20
 arch/frv/mm/fault.c                             |   10 -
 arch/hexagon/mm/vm_fault.c                      |    6=20
 arch/ia64/mm/fault.c                            |    6=20
 arch/m32r/mm/fault.c                            |   10 -
 arch/m68k/mm/fault.c                            |    2=20
 arch/metag/mm/fault.c                           |   12 +
 arch/microblaze/mm/fault.c                      |    7=20
 arch/mips/mm/c-r4k.c                            |    2=20
 arch/mips/mm/fault.c                            |    8 -
 arch/mn10300/mm/fault.c                         |    9 -
 arch/openrisc/mm/fault.c                        |    9 -
 arch/parisc/include/uapi/asm/shmbuf.h           |   25 +--
 arch/parisc/kernel/syscall_table.S              |    8 -
 arch/parisc/mm/fault.c                          |    7=20
 arch/powerpc/mm/fault.c                         |    7=20
 arch/s390/mm/fault.c                            |    2=20
 arch/score/mm/fault.c                           |   21 +-
 arch/sh/mm/fault.c                              |    9 -
 arch/sparc/include/asm/atomic_32.h              |    2=20
 arch/sparc/include/asm/cmpxchg_32.h             |   12 -
 arch/sparc/include/asm/vio.h                    |   14 +
 arch/sparc/kernel/pci_schizo.c                  |    6=20
 arch/sparc/kernel/smp_64.c                      |    4=20
 arch/sparc/lib/atomic32.c                       |   27 +++
 arch/sparc/mm/fault_32.c                        |   12 +
 arch/sparc/mm/fault_64.c                        |    6=20
 arch/tile/mm/fault.c                            |   21 +-
 arch/um/kernel/trap.c                           |   22 +-
 arch/unicore32/mm/fault.c                       |   22 +-
 arch/x86/kernel/cpu/perf_event_intel.c          |    3=20
 arch/x86/kernel/ptrace.c                        |   11 -
 arch/x86/kvm/x86.c                              |    2=20
 arch/x86/mm/fault.c                             |   43 ++---
 arch/xtensa/include/uapi/asm/unistd.h           |    3=20
 arch/xtensa/mm/fault.c                          |    2=20
 drivers/ata/ahci.c                              |   19 ++
 drivers/block/sunvdc.c                          |  176 +++++++++++++++++--=
----
 drivers/firewire/core-cdev.c                    |    3=20
 drivers/gpu/drm/radeon/evergreen.c              |    1=20
 drivers/input/mouse/alps.c                      |   11 +
 drivers/md/dm-raid.c                            |   11 -
 drivers/md/persistent-data/dm-btree-internal.h  |    6=20
 drivers/md/persistent-data/dm-btree-spine.c     |    2=20
 drivers/md/persistent-data/dm-btree.c           |   24 +--
 drivers/media/usb/ttusb-dec/ttusbdecfe.c        |    3=20
 drivers/misc/mei/bus.c                          |    2=20
 drivers/net/ethernet/mellanox/mlx4/en_tx.c      |   61 +++++---
 drivers/net/ethernet/sun/sunvnet.c              |    4=20
 drivers/net/macvtap.c                           |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans.h        |    2=20
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   35 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |    1=20
 drivers/net/wireless/iwlwifi/mvm/fw.c           |    9 +
 drivers/net/wireless/iwlwifi/mvm/ops.c          |    1=20
 drivers/net/wireless/iwlwifi/pcie/trans.c       |   17 +-
 drivers/platform/x86/dell-wmi.c                 |   12 +
 drivers/scsi/hpsa.c                             |    4=20
 drivers/scsi/scsi_error.c                       |    4=20
 fs/ioprio.c                                     |   14 +
 fs/nfs/delegation.c                             |   25 +++
 fs/nfs/delegation.h                             |    1=20
 fs/nfs/direct.c                                 |    1=20
 fs/nfs/inode.c                                  |    2=20
 fs/nfs/nfs4proc.c                               |   26 +++
 include/linux/clocksource.h                     |    2=20
 include/linux/kgdb.h                            |    2=20
 include/linux/memcontrol.h                      |   37 ++++
 include/linux/mm.h                              |    1=20
 include/linux/nfs_xdr.h                         |   11 +
 include/linux/sched.h                           |    6=20
 include/net/sctp/sctp.h                         |    5=20
 include/net/sctp/sm.h                           |    6=20
 include/uapi/linux/netfilter/xt_bpf.h           |    2=20
 ipc/ipc_sysctl.c                                |    3=20
 kernel/audit_tree.c                             |    1=20
 kernel/events/core.c                            |   22 ++
 mm/memcontrol.c                                 |  182 ++++++++++++++-----=
-----
 mm/memory.c                                     |   49 +++++-
 mm/oom_kill.c                                   |    7=20
 net/bridge/br_private.h                         |   10 +
 net/bridge/br_stp_bpdu.c                        |    2=20
 net/ceph/crypto.c                               |  169 +++++++++++++++++--=
---
 net/ipv6/ip6_gre.c                              |    7=20
 net/ipv6/ip6_tunnel.c                           |   10 -
 net/mac80211/rx.c                               |   14 -
 net/netfilter/nf_nat_core.c                     |   35 ++++
 net/netfilter/nfnetlink_log.c                   |   31 ++--
 net/sctp/associola.c                            |    2=20
 net/sctp/auth.c                                 |    2=20
 net/sctp/inqueue.c                              |   33 ----
 net/sctp/sm_make_chunk.c                        |  102 +++++++------
 net/sctp/sm_statefuns.c                         |   21 --
 sound/usb/mixer_quirks.c                        |    6=20
 107 files changed, 1196 insertions(+), 594 deletions(-)

Alex Deucher (1):
      drm/radeon: add missing crtc unlock when setting up the MC

Alexander Usyskin (1):
      mei: bus: fix possible boundaries violation

Allen Pais (2):
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrey Vagin (1):
      ipc: always handle a new value of auto_msgmni

Andy Lutomirski (1):
      x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Ben Dooks (2):
      ARM: probes: fix instruction fetch order with <asm/opcodes.h>
      ARM: Correct BUG() assembly to ensure it is endian-agnostic

Bjorn Helgaas (2):
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      clocksource: Remove "weak" from clocksource_default_clock() declarati=
on

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset

Dan Carpenter (1):
      media: ttusb-dec: buffer overflow in ioctl

Daniel Borkmann (5):
      net: sctp: fix NULL pointer dereference in af->from_addr_param on mal=
formed packet
      net: sctp: fix memory leak in auth key management
      net: sctp: fix remote memory pressure from excessive queueing
      net: sctp: fix panic on duplicate ASCONF chunks
      net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

David S. Miller (2):
      sparc64: Fix crashes in schizo_pcierr_intr_other().
      sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().

Dwight Engen (3):
      sunvdc: limit each sg segment to a page
      vio: fix reuse of vio_dring slot
      sunvdc: don't call VD_OP_GET_VTOC

Emmanuel Grumbach (1):
      iwlwifi: configure the LTR

Eugenia Emantayev (1):
      net/mlx4_en: Fix BlueFlame race

Florian Westphal (3):
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspa=
ce
      netfilter: nf_nat: fix oops on netns removal

Greg Kroah-Hartman (1):
      Linux 3.10.61

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop sys=
calls

Herbert Xu (1):
      macvtap: Fix csum_start when VLAN tags are present

Houcheng Lin (1):
      netfilter: nf_log: release skbuff on nlmsg put failure

Ilya Dryomov (1):
      libceph: do not crash on large auth tickets

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Jan Kara (2):
      block: Fix computation of merged request priority
      nfs: Fix use of uninitialized variable in nfs_getattr()

Jiri Pirko (1):
      br: fix use of ->rx_handler_data in code executed on non-rx_handler p=
ath

Joe Thornber (1):
      dm btree: fix a recursion depth bug in btree walking code

Johannes Berg (1):
      mac80211: fix use-after-free in defragmentation

Johannes Weiner (9):
      mm: invoke oom-killer from remaining unconverted page fault handlers
      arch: mm: remove obsolete init OOM protection
      arch: mm: do not invoke OOM killer on kernel fault OOM
      arch: mm: pass userspace fault flag to generic fault handler
      x86: finish user fault error path with fatal signal
      mm: memcg: enable memcg OOM killer only for user faults
      mm: memcg: rework and document OOM waiting and wakeup
      mm: memcg: do not trap chargers with full callstack on OOM
      mm: memcg: handle non-error OOM situations more gracefully

Kyle McMartin (1):
      arm64: __clear_user: handle exceptions on strb

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Miklos Szeredi (1):
      audit: keep inode pinned

Nadav Amit (1):
      KVM: x86: Don't report guest userspace emulation error to userspace

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

Pablo Neira (1):
      netfilter: xt_bpf: add mising opaque struct sk_filter definition

Pali Roh=E1r (3):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      dell-wmi: Fix access out of memory

Pawel Moll (1):
      perf: Handle compat ioctl

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Steffen Klassert (2):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Takashi Iwai (1):
      ALSA: usb-audio: Fix memory leak in FTU quirk

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Tomas Henzl (1):
      SCSI: hpsa: fix a race in cmd_free/scsi_done

Trond Myklebust (3):
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expir=
ed
      NFS: Don't try to reclaim delegation open state if recovery failed
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation r=
eturn

Vince Weaver (1):
      perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Yoichi Yuasa (1):
      MIPS: Fix forgotten preempt_enable() when CPU has inclusive pcaches


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUb5x1AAoJEDjbvchgkmk+U4UP/jJTd5RNCiT4bHpGz7C4C2Ne
wsDJtepqIdT5SHmTkURtxsDjgLt8HRaHstSNgmvlN3ZfzgiUqXoM8Nu/f5t581St
BsLkOLdiTdbVD73L0FtO9UF9DDlnRmXareAMMK1vMqwLVEmnu/ciDJoPxQsXl4TY
Jz5LmR9xY0+50CZtYna8Lap1m5xh07xBBsRNS0V5GcR8DW/XscBKfk83Slgnj8vZ
xImlsU6DcrJbGmzc1BYxRa93VMEZ0ycbAiAep2TrZ4qL+S1/oriPBrJK2XelmQQK
C0z0JQMjAFM8FLHid5vGunatljoRAR93vDYhAfs0kw5jbpRYzS1mEBbAOst8Y2Om
lhRRPU2gBPj9Q8aFfT4ab0VUJtEtj/uM+Vwrol4n5g3VKTQac2uz8F/tKNiqZjti
T80lcz92dcBQBN6OnbtJ9bYOIeVZ1v/Hh9y0PdlAvcHgMxQjWDDF9XuT/fLSZ20f
MeO++Gi6DlrnIyA+pvuWuv1y76vvH0t2IFk65HZ2MUAXXoz44VaPljCmVpo0a3mn
o6DzJU7aHk9zKwjE6g+VFxXmMuN8TntdzN6gNALfpD3i8pE8FbbM8e8bn2Bxunwy
494bguF0Wxk/IuseKZOrPLiIIQuvUsABVGxNq/vxvDNYVMLYq5erfz6vhJZwxE9X
CgvPuJcHfpapfMPLvW+Z
=vrEX
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
