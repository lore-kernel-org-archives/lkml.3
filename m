Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaKUUOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:14:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaKUUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:14:16 -0500
Date: Fri, 21 Nov 2014 12:12:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.4
Message-ID: <20141121201253.GA8623@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.17.4 kernel.

All users of the 3.17 kernel series must upgrade.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.17.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/ata/sata_rcar.txt |    3=20
 Makefile                                            |    2=20
 arch/arm/boot/compressed/head.S                     |   20 +-
 arch/arm/boot/dts/am335x-evm.dts                    |    2=20
 arch/arm/mach-mvebu/board-v7.c                      |    2=20
 arch/arm/mm/Kconfig                                 |    1=20
 arch/arm64/kernel/efi-entry.S                       |   27 ++-
 arch/arm64/kernel/insn.c                            |    5=20
 arch/arm64/lib/clear_user.S                         |    2=20
 arch/parisc/include/uapi/asm/shmbuf.h               |   25 +-
 arch/parisc/kernel/syscall_table.S                  |    8=20
 arch/sparc/include/asm/atomic_32.h                  |    2=20
 arch/sparc/include/asm/cmpxchg_32.h                 |   12 -
 arch/sparc/include/asm/vio.h                        |   14 +
 arch/sparc/kernel/pci_schizo.c                      |    6=20
 arch/sparc/kernel/smp_64.c                          |    4=20
 arch/sparc/lib/atomic32.c                           |   27 +++
 arch/x86/.gitignore                                 |    2=20
 arch/x86/boot/compressed/Makefile                   |    4=20
 arch/x86/boot/compressed/head_32.S                  |    5=20
 arch/x86/boot/compressed/head_64.S                  |    5=20
 arch/x86/boot/compressed/misc.c                     |   13 +
 arch/x86/boot/compressed/mkpiggy.c                  |    9 -
 arch/x86/kernel/cpu/microcode/amd_early.c           |   33 ++-
 arch/x86/kernel/cpu/microcode/core_early.c          |    2=20
 arch/x86/kernel/ptrace.c                            |   11 -
 arch/x86/kvm/emulate.c                              |    8=20
 arch/x86/kvm/x86.c                                  |    2=20
 arch/x86/tools/calc_run_size.pl                     |   30 +++
 arch/xtensa/include/uapi/asm/unistd.h               |    3=20
 block/ioprio.c                                      |   14 -
 drivers/ata/ahci.c                                  |   28 ++-
 drivers/ata/sata_rcar.c                             |   10 +
 drivers/block/sunvdc.c                              |  176 ++++++++++++++-=
-----
 drivers/block/zram/zram_drv.c                       |    3=20
 drivers/char/hw_random/pseries-rng.c                |   11 -
 drivers/cpufreq/cpufreq.c                           |    3=20
 drivers/crypto/caam/caamhash.c                      |   22 +-
 drivers/crypto/caam/key_gen.c                       |   29 +--
 drivers/crypto/caam/sg_sw_sec4.h                    |   54 ------
 drivers/crypto/qat/qat_common/adf_accel_devices.h   |    3=20
 drivers/crypto/qat/qat_common/adf_transport.c       |   12 -
 drivers/crypto/qat/qat_common/qat_algs.c            |    7=20
 drivers/crypto/qat/qat_common/qat_crypto.c          |    8=20
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c         |    2=20
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c           |   32 +--
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c           |    2=20
 drivers/firewire/core-cdev.c                        |    3=20
 drivers/gpu/drm/i915/i915_gem_gtt.c                 |   16 +
 drivers/gpu/drm/i915/intel_dp.c                     |    5=20
 drivers/gpu/drm/i915/intel_panel.c                  |   17 +
 drivers/gpu/drm/radeon/atom.c                       |   11 +
 drivers/gpu/drm/radeon/atom.h                       |    2=20
 drivers/gpu/drm/radeon/atombios_dp.c                |    4=20
 drivers/gpu/drm/radeon/atombios_i2c.c               |    4=20
 drivers/gpu/drm/radeon/cik.c                        |    7=20
 drivers/gpu/drm/radeon/cik_sdma.c                   |   21 +-
 drivers/gpu/drm/radeon/evergreen.c                  |    4=20
 drivers/gpu/drm/radeon/r100.c                       |    3=20
 drivers/gpu/drm/radeon/r600_dma.c                   |   20 +-
 drivers/gpu/drm/radeon/radeon_device.c              |    1=20
 drivers/gpu/drm/radeon/rs600.c                      |    3=20
 drivers/gpu/drm/radeon/rs690.c                      |    3=20
 drivers/gpu/drm/radeon/rv515.c                      |    3=20
 drivers/gpu/drm/radeon/si.c                         |    3=20
 drivers/infiniband/core/uverbs_cmd.c                |    2=20
 drivers/input/mouse/alps.c                          |   28 ++-
 drivers/input/mouse/synaptics.c                     |    5=20
 drivers/md/dm-bufio.c                               |   12 -
 drivers/md/dm-raid.c                                |   11 -
 drivers/md/dm-thin.c                                |   16 +
 drivers/md/md.c                                     |    4=20
 drivers/md/persistent-data/dm-btree-internal.h      |    6=20
 drivers/md/persistent-data/dm-btree-spine.c         |    2=20
 drivers/md/persistent-data/dm-btree.c               |   24 +-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c            |    3=20
 drivers/mfd/max77693.c                              |   14 +
 drivers/mfd/twl4030-power.c                         |   52 +++++
 drivers/net/ethernet/broadcom/bcmsysport.c          |   11 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c      |    7=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     |    6=20
 drivers/net/ethernet/marvell/mv643xx_eth.c          |   18 +-
 drivers/net/ethernet/smsc/smsc911x.c                |   46 +++++
 drivers/net/ethernet/sun/sunvnet.c                  |    4=20
 drivers/net/ethernet/ti/cpts.c                      |    2=20
 drivers/net/macvtap.c                               |    2=20
 drivers/net/phy/dp83640.c                           |    4=20
 drivers/net/ppp/ppp_generic.c                       |   40 ++--
 drivers/net/tun.c                                   |   16 +
 drivers/net/vxlan.c                                 |   31 ++-
 drivers/net/wireless/iwlwifi/mvm/fw.c               |   10 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |    1=20
 drivers/net/wireless/iwlwifi/mvm/mvm.h              |    1=20
 drivers/net/wireless/iwlwifi/mvm/ops.c              |   11 +
 drivers/net/wireless/iwlwifi/pcie/trans.c           |    4=20
 drivers/net/wireless/mac80211_hwsim.c               |    4=20
 drivers/platform/x86/asus-nb-wmi.c                  |    9 +
 drivers/platform/x86/dell-wmi.c                     |   12 +
 drivers/platform/x86/ideapad-laptop.c               |    7=20
 drivers/power/bq2415x_charger.c                     |   23 +-
 drivers/power/charger-manager.c                     |  163 ++++++++++++---=
---
 drivers/pwm/core.c                                  |   29 +--
 drivers/scsi/scsi_error.c                           |    4=20
 fs/gfs2/dir.c                                       |    9 -
 fs/gfs2/dir.h                                       |    1=20
 fs/gfs2/inode.c                                     |    6=20
 fs/nfs/delegation.c                                 |   25 ++
 fs/nfs/delegation.h                                 |    1=20
 fs/nfs/direct.c                                     |    1=20
 fs/nfs/filelayout/filelayout.c                      |    3=20
 fs/nfs/inode.c                                      |    2=20
 fs/nfs/nfs4proc.c                                   |   76 ++++----
 include/dt-bindings/pinctrl/dra.h                   |    4=20
 include/linux/bootmem.h                             |    1=20
 include/linux/clocksource.h                         |    2=20
 include/linux/crash_dump.h                          |   15 -
 include/linux/kgdb.h                                |    2=20
 include/linux/khugepaged.h                          |   17 +
 include/linux/memory.h                              |    2=20
 include/linux/mfd/max77693-private.h                |    7=20
 include/linux/mmzone.h                              |    9 +
 include/linux/nfs_xdr.h                             |   11 +
 include/linux/page-isolation.h                      |    8=20
 include/linux/power/charger-manager.h               |    3=20
 include/linux/ring_buffer.h                         |    2=20
 include/net/sctp/sctp.h                             |    5=20
 include/net/sctp/sm.h                               |    6=20
 include/net/udp_tunnel.h                            |    9 +
 include/uapi/linux/netfilter/xt_bpf.h               |    2=20
 init/main.c                                         |    2=20
 ipc/ipc_sysctl.c                                    |    3=20
 kernel/audit.c                                      |    4=20
 kernel/audit_tree.c                                 |    1=20
 kernel/rcu/tree.c                                   |    4=20
 kernel/trace/ring_buffer.c                          |   81 ++++++---
 kernel/trace/trace.c                                |   23 --
 mm/bootmem.c                                        |    9 -
 mm/huge_memory.c                                    |   11 -
 mm/internal.h                                       |   25 ++
 mm/iov_iter.c                                       |    4=20
 mm/memory_hotplug.c                                 |   26 ++
 mm/mmap.c                                           |    8=20
 mm/nobootmem.c                                      |    8=20
 mm/page_alloc.c                                     |   55 ++----
 mm/page_isolation.c                                 |   43 ++++
 net/ceph/crypto.c                                   |  169 +++++++++++++++=
----
 net/ipv4/inet_fragment.c                            |    4=20
 net/ipv4/ip_sockglue.c                              |    2=20
 net/ipv6/ip6_gre.c                                  |    5=20
 net/ipv6/ip6_tunnel.c                               |   10 -
 net/ipv6/ip6_vti.c                                  |   11 -
 net/ipv6/sit.c                                      |   15 -
 net/mac80211/ibss.c                                 |    2=20
 net/mac80211/ieee80211_i.h                          |    3=20
 net/mac80211/iface.c                                |    7=20
 net/mac80211/mesh.c                                 |    2=20
 net/mac80211/mlme.c                                 |    5=20
 net/mac80211/rx.c                                   |   14 -
 net/mac80211/spectmgmt.c                            |   18 --
 net/netfilter/ipset/ip_set_core.c                   |    2=20
 net/netfilter/nf_tables_api.c                       |    4=20
 net/netfilter/nfnetlink_log.c                       |   31 +--
 net/netfilter/nft_compat.c                          |    2=20
 net/netlink/af_netlink.c                            |    5=20
 net/sctp/associola.c                                |    2=20
 net/sctp/auth.c                                     |    2=20
 net/sctp/inqueue.c                                  |   33 ---
 net/sctp/sm_make_chunk.c                            |  102 ++++++-----
 net/sctp/sm_statefuns.c                             |   21 --
 net/sunrpc/auth_gss/auth_gss.c                      |   35 +++
 scripts/checkpatch.pl                               |    2=20
 scripts/package/builddeb                            |   22 +-
 security/keys/keyctl.c                              |    2=20
 sound/pci/hda/patch_conexant.c                      |   31 +++
 sound/usb/mixer_quirks.c                            |    6=20
 175 files changed, 1710 insertions(+), 874 deletions(-)

Alex Deucher (3):
      drm/radeon: make sure mode init is complete in bandwidth_update
      drm/radeon: use gart for DMA IB tests
      drm/radeon: add missing crtc unlock when setting up the MC

Allen Pais (2):
      sunvdc: add cdrom and v1.1 protocol support
      sunvdc: compute vdisk geometry from capacity

Andreas Larsson (1):
      sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

Andrew Lunn (1):
      ARM: mvebu: armada xp: Generalize use of i2c quirk

Andrey Vagin (1):
      ipc: always handle a new value of auto_msgmni

Andy Lutomirski (1):
      x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Anish Bhatt (1):
      cxgb4 : Handle dcb enable correctly

Antoine Tenart (1):
      ahci: fix AHCI parameters not taken into account

Arturo Borrero (1):
      netfilter: nft_compat: fix wrong target lookup in nft_target_select_o=
ps()

Bjorn Helgaas (4):
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declarat=
ion
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      clocksource: Remove "weak" from clocksource_default_clock() declarati=
on

Bob Peterson (1):
      GFS2: Make rename not save dirent location

Borislav Petkov (3):
      x86, microcode, AMD: Fix early ucode loading on 32-bit
      x86, microcode: Fix accessing dis_ucode_ldr on 32-bit
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

Daniel Thompson (1):
      param: fix crash on bad kernel arguments

Dave Airlie (1):
      drm/radeon: add locking around atombios scratch space usage

David Howells (1):
      KEYS: Reinstate EPERM for a key type name beginning with a '.'

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise

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
      iwlwifi: fix RFkill while calibrating

Enric Balletbo i Serra (1):
      smsc911x: power-up phydev before doing a software reset.

Eric Dumazet (1):
      ipv6: fix IPV6_PKTINFO with v4 mapped

Florian Fainelli (2):
      net: systemport: enable RX interrupts after NAPI
      net: systemport: reset UniMAC coming out of a suspend cycle

Florian Westphal (2):
      netfilter: nf_log: account for size of NLMSG_DONE attribute
      netfilter: nfnetlink_log: fix maximum packet length logged to userspa=
ce

Geert Uytterhoeven (2):
      cpufreq: Avoid crash in resume on SMP without OPP
      pwm: Fix uninitialized warnings in pwm_get()

Greg Kroah-Hartman (1):
      Linux 3.17.4

Greg Kurz (1):
      hwrng: pseries - port to new read API and fix stack corruption

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Helge Deller (1):
      parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop sys=
calls

Herbert Xu (2):
      tun: Fix csum_start with VLAN acceleration
      macvtap: Fix csum_start when VLAN tags are present

Hiroaki SHIMODA (1):
      netlink: Properly unbind in error conditions.

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

Jani Nikula (2):
      drm/i915: safeguard against too high minimum brightness
      drm/i915/dp: only use training pattern 3 on platforms that support it

Jeff Layton (1):
      sunrpc: fix sleeping under rcu_read_lock in gss_stringify_acceptor

Jesse Gross (1):
      udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.

Joe Perches (1):
      checkpatch: remove unnecessary + after {8,8}

Joe Thornber (2):
      dm thin: grab a virtual cell before looking up the mapping
      dm btree: fix a recursion depth bug in btree walking code

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Joonsoo Kim (4):
      mm/page_alloc: fix incorrect isolation behavior by rechecking migrate=
type
      mm/page_alloc: add freepage on isolate pageblock to correct buddy list
      mm/page_alloc: move freepage counting logic to __free_one_page()
      mm/page_alloc: restrict max order of merging on isolated pageblock

Junjie Mao (2):
      mac80211_hwsim: release driver when ieee80211_register_hw fails
      x86, kaslr: Prevent .bss from overlaping initrd

Karl Beldan (1):
      net: mv643xx_eth: reclaim TX skbs only when released by the HW

Krzysztof Kozlowski (6):
      mfd: max77693: Use proper regmap for handling MUIC interrupts
      mfd: max77693: Fix always masked MUIC interrupts
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

Mark Rutland (1):
      arm64: efi: Fix stub cache maintenance

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Michal Marek (1):
      builddeb: put the dbg files into the correct directory

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (1):
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (2):
      KVM: x86: Fix uninitialized op->type for some immediate values
      KVM: x86: Don't report guest userspace emulation error to userspace

Nathan Lynch (1):
      ARM: 8198/1: make kuser helpers depend on MMU

NeilBrown (1):
      md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Nikolay Aleksandrov (2):
      inet: frags: fix a race between inet_evict_bucket and inet_frag_kill
      inet: frags: remove the WARN_ON from inet_evict_bucket

Pablo Neira (1):
      netfilter: xt_bpf: add mising opaque struct sk_filter definition

Pali Roh=E1r (4):
      Input: alps - ignore potential bare packets when device is out of sync
      Input: alps - allow up to 2 invalid packets without resetting device
      Input: alps - ignore bad data on Dell Latitudes E6440 and E7440
      dell-wmi: Fix access out of memory

Paul Mackerras (1):
      Fix thinko in iov_iter_single_seg_count

Peng Tao (1):
      nfs: fix pnfs direct write memory leak

Pranith Kumar (1):
      rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Rabin Vincent (1):
      tracing: Do not busy wait in buffer splice

Richard Cochran (1):
      net: ptp: fix time stamp matching logic for VLAN packets.

Richard Guy Briggs (2):
      audit: correct AUDIT_GET_FEATURE return message type
      audit: AUDIT_FEATURE_CHANGE message format missing delimiting space

Rodrigo Vivi (1):
      drm/i915: Disable caches for Global GTT.

Roger Quadros (2):
      ARM: dts: am335x-evm: Fix 5th NAND partition's name
      pinctrl: dra: dt-bindings: Fix output pull up/down

Sabrina Dubroca (1):
      netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats=
 allocation

Shuah Khan (1):
      x86/build: Add arch/x86/purgatory/ make generated files to gitignore

Simon Horman (1):
      ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Stanislaw Gruszka (1):
      asus-nb-wmi: Add wapf4 quirk for the X550VB

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Steffen Klassert (4):
      ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
      vti6: Use vti6_dev_init as the ndo_init function.
      sit: Use ipip6_tunnel_init as the ndo_init function.
      gre6: Move the setting of dev->iflink into the ndo_init functions.

Stephan Mueller (1):
      quirk for Lenovo Yoga 3: no rfkill switch

Tadeusz Struk (2):
      crypto: qat - Prevent dma mapping zero length assoc data
      crypto: qat - Enforce valid numa configuration

Takashi Iwai (4):
      net: ppp: Don't call bpf_prog_create() in ppp_lock
      ALSA: hda - Add mute LED control for Lenovo Ideapad Z560
      ALSA: usb-audio: Fix memory leak in FTU quirk
      Input: synaptics - add min/max quirk for Lenovo T440s

Tang Chen (2):
      mem-hotplug: reset node managed pages when hot-adding a new pgdat
      mem-hotplug: reset node present pages when hot-adding a new pgdat

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Tony Lindgren (1):
      mfd: twl4030-power: Fix poweroff with PM configuration enabled

Trond Myklebust (5):
      NFSv4: Ensure that we remove NFSv4.0 delegations when state has expir=
ed
      NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are rev=
oked
      NFS: Don't try to reclaim delegation open state if recovery failed
      NFSv4: Fix races between nfs_remove_bad_delegation() and delegation r=
eturn
      NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED=
_STATE

Weijie Yang (1):
      zram: avoid kunmap_atomic() of a NULL pointer

Will Deacon (1):
      ARM: 8191/1: decompressor: ensure I-side picks up relocated code

William Cohen (1):
      Correct the race condition in aarch64_insn_patch_text_sync()


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUb5zFAAoJEDjbvchgkmk+fQIQAJb0ULyg5TG6yvTtLS/vwwyI
6ibQuBionc79Hc470iYvOArpCuocU3ecmrN+rIOEpbs1pHYP1xiNhLGzufFS0VOG
3FVxnudEivf+jdxQjmMhGd3Sr2d9IQk4nifRJQT6IU62bKxuKQ1+UXCuecJmDGQa
qdGw98kIMleZatN7DYi+Jb+LnzIO2+iRbGkiaF5mgHM+/wDKMLEK8u7/pKLYLhml
HtYIzT9gBulI6+k6uGWiA2nB+cwBGJ5hV8yxi3eF5U5BJa8Vl3II9oJjKWUX8pUZ
0ZWZw0rTtzxymbjzWadh2frIayqq9km6YE3PmEDOngdvHjqOb+SXaXqSssVG6mlz
xS4NepsDlgPN2bdJ/OeBnJuOY+yXL6cuMCghHDbBKskmF+kuwbFfWRzA9uvxZRAb
Emx4wVkhNoTUT0z9KJpt86tZqUt6G/GCM7+NMJv3n8xRhCvYX+hfhyWHPbG7x/eS
Um6+w9ilOiz6SCeqlB/6iNqfHAAqLQRa4zEg2W1ay47bIEtcIdFEY1kbXsTL1Ol0
02sb9x5z6Oi0iY2eKnW2jZOIVcxfUB6capSHnqeK360nOEORyth/ma4d+qdtBFn4
jaCUpsMFm0BWrk9n+8z67RpxHks9yX6zImVxE5jZt4o5KQH0v0kGrmSRjQL4s/z2
rTx4srmaQGR1fZh/4dzj
=8FfC
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
