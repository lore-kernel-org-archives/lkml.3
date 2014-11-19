Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbaKSW3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:29:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbaKSUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 000/141] 3.17.4-stable review
Date: Wed, 19 Nov 2014 12:50:23 -0800
Message-Id: <20141119205150.700188369@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.4 release.
There are 141 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Nov 21 20:51:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.4-rc1

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: fix RFkill while calibrating

David Howells <dhowells@redhat.com>
    KEYS: Reinstate EPERM for a key type name beginning with a '.'

Stanislaw Gruszka <sgruszka@redhat.com>
    asus-nb-wmi: Add wapf4 quirk for the X550VB

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix skb_over_panic when receiving malformed ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix panic on duplicate ASCONF chunks

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix remote memory pressure from excessive queueing

Stephan Mueller <smueller@chronox.de>
    quirk for Lenovo Yoga 3: no rfkill switch

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Don't report guest userspace emulation error to userspace

David Rientjes <rientjes@google.com>
    mm, thp: fix collapsing of hugepages on madvise

Joe Perches <joe@perches.com>
    checkpatch: remove unnecessary + after {8,8}

Michal Marek <mmarek@suse.cz>
    builddeb: put the dbg files into the correct directory

Pali Rohár <pali.rohar@gmail.com>
    dell-wmi: Fix access out of memory

Pranith Kumar <bobby.prani@gmail.com>
    rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads

Bob Peterson <rpeterso@redhat.com>
    GFS2: Make rename not save dirent location

Pablo Neira <pablo@netfilter.org>
    netfilter: xt_bpf: add mising opaque struct sk_filter definition

Arturo Borrero <arturo.borrero.glez@gmail.com>
    netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()

Houcheng Lin <houcheng@gmail.com>
    netfilter: nf_log: release skbuff on nlmsg put failure

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: fix maximum packet length logged to userspace

Florian Westphal <fw@strlen.de>
    netfilter: nf_log: account for size of NLMSG_DONE attribute

Sabrina Dubroca <sd@queasysnail.net>
    netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats allocation

Dan Carpenter <dan.carpenter@oracle.com>
    netfilter: ipset: off by one in ip_set_nfnl_get_byindex()

Andrey Vagin <avagin@openvz.org>
    ipc: always handle a new value of auto_msgmni

Devesh Sharma <devesh.sharma@emulex.com>
    IB/core: Clear AH attr variable to prevent garbage data

Geert Uytterhoeven <geert+renesas@glider.be>
    pwm: Fix uninitialized warnings in pwm_get()

Bjorn Helgaas <bhelgaas@google.com>
    clocksource: Remove "weak" from clocksource_default_clock() declaration

Bjorn Helgaas <bhelgaas@google.com>
    kgdb: Remove "weak" from kgdb_arch_pc() declaration

Bjorn Helgaas <bhelgaas@google.com>
    vmcore: Remove "weak" from function declarations

Bjorn Helgaas <bhelgaas@google.com>
    memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: reset UniMAC coming out of a suspend cycle

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: enable RX interrupts after NAPI

Anish Bhatt <anish@chelsio.com>
    cxgb4 : Handle dcb enable correctly

Dan Carpenter <dan.carpenter@oracle.com>
    media: ttusb-dec: buffer overflow in ioctl

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1: nfs41_clear_delegation_stateid shouldn't trust NFS_DELEGATED_STATE

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix races between nfs_remove_bad_delegation() and delegation return

Jan Kara <jack@suse.cz>
    nfs: Fix use of uninitialized variable in nfs_getattr()

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Don't try to reclaim delegation open state if recovery failed

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Ensure that we call FREE_STATEID when NFSv4.x stateids are revoked

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Ensure that we remove NFSv4.0 delegations when state has expired

NeilBrown <neilb@suse.de>
    md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN

Junjie Mao <eternal.n08@gmail.com>
    x86, kaslr: Prevent .bss from overlaping initrd

Borislav Petkov <bp@suse.de>
    x86, microcode, AMD: Fix ucode patch stashing on 32-bit

Borislav Petkov <bp@suse.de>
    x86, microcode: Fix accessing dis_ucode_ldr on 32-bit

Borislav Petkov <bp@suse.de>
    x86, microcode, AMD: Fix early ucode loading on 32-bit

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: bq2415x_charger: Fix memory leak on DTS parsing error

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: bq2415x_charger: Properly handle ENODEV from power_supply_get_by_phandle

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: charger-manager: Fix accessing invalidated power supply after charger unbind

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    power: charger-manager: Fix accessing invalidated power supply after fuel gauge unbind

Jeff Layton <jlayton@primarydata.com>
    sunrpc: fix sleeping under rcu_read_lock in gss_stringify_acceptor

Geert Uytterhoeven <geert+renesas@glider.be>
    cpufreq: Avoid crash in resume on SMP without OPP

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - ignore bad data on Dell Latitudes E6440 and E7440

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - allow up to 2 invalid packets without resetting device

Pali Rohár <pali.rohar@gmail.com>
    Input: alps - ignore potential bare packets when device is out of sync

Takashi Iwai <tiwai@suse.de>
    Input: synaptics - add min/max quirk for Lenovo T440s

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: ensure superblock's size matches device's logical block size

Joe Thornber <ejt@redhat.com>
    dm btree: fix a recursion depth bug in btree walking code

Mikulas Patocka <mpatocka@redhat.com>
    dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Jan Kara <jack@suse.cz>
    block: Fix computation of merged request priority

Helge Deller <deller@gmx.de>
    parisc: Use compat layer for msgctl, shmat, shmctl and semtimedop syscalls

Christoph Hellwig <hch@lst.de>
    scsi: only re-lock door after EH on devices that were reset

William Cohen <wcohen@redhat.com>
    Correct the race condition in aarch64_insn_patch_text_sync()

Peng Tao <tao.peng@primarydata.com>
    nfs: fix pnfs direct write memory leak

Simon Horman <horms+renesas@verge.net.au>
    ata: sata_rcar: Disable DIPM mode for r8a7790 ES1

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: prevent kernel stack leaking into ioctl arguments

Mark Rutland <mark.rutland@arm.com>
    arm64: efi: Fix stub cache maintenance

Kyle McMartin <kyle@redhat.com>
    arm64: __clear_user: handle exceptions on strb

Joe Thornber <ejt@redhat.com>
    dm thin: grab a virtual cell before looking up the mapping

Paul Mackerras <paulus@samba.org>
    Fix thinko in iov_iter_single_seg_count

Roger Quadros <rogerq@ti.com>
    pinctrl: dra: dt-bindings: Fix output pull up/down

Andrew Lunn <andrew@lunn.ch>
    ARM: mvebu: armada xp: Generalize use of i2c quirk

Roger Quadros <rogerq@ti.com>
    ARM: dts: am335x-evm: Fix 5th NAND partition's name

Will Deacon <will.deacon@arm.com>
    ARM: 8191/1: decompressor: ensure I-side picks up relocated code

Nathan Lynch <nathan_lynch@mentor.com>
    ARM: 8198/1: make kuser helpers depend on MMU

Dave Airlie <airlied@redhat.com>
    drm/radeon: add locking around atombios scratch space usage

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing crtc unlock when setting up the MC

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use gart for DMA IB tests

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: make sure mode init is complete in bandwidth_update

Jammy Zhou <Jammy.Zhou@amd.com>
    drm/radeon: set correct CE ram size for CIK

Jani Nikula <jani.nikula@intel.com>
    drm/i915/dp: only use training pattern 3 on platforms that support it

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/i915: Disable caches for Global GTT.

Jani Nikula <jani.nikula@intel.com>
    drm/i915: safeguard against too high minimum brightness

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix use-after-free in defragmentation

Luciano Coelho <luciano.coelho@intel.com>
    mac80211: schedule the actual switch of the station before CSA count 0

Luciano Coelho <luciano.coelho@intel.com>
    mac80211: use secondary channel offset IE also beacons during CSA

Johannes Berg <johannes@sipsolutions.net>
    mac80211: properly flush delayed scan work on interface removal

Junjie Mao <eternal.n08@gmail.com>
    mac80211_hwsim: release driver when ieee80211_register_hw fails

Herbert Xu <herbert@gondor.apana.org.au>
    macvtap: Fix csum_start when VLAN tags are present

Ilya Dryomov <idryomov@redhat.com>
    libceph: do not crash on large auth tickets

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: re-wire umount syscall to sys_oldumount

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix memory leak in FTU quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add mute LED control for Lenovo Ideapad Z560

Tejun Heo <tj@kernel.org>
    ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Antoine Tenart <antoine.tenart@free-electrons.com>
    ahci: fix AHCI parameters not taken into account

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Sunrise Point PCH

Daniel Thompson <daniel.thompson@linaro.org>
    param: fix crash on bad kernel arguments

Rabin Vincent <rabin@rab.in>
    tracing: Do not busy wait in buffer splice

Miklos Szeredi <mszeredi@suse.cz>
    audit: keep inode pinned

Richard Guy Briggs <rgb@redhat.com>
    audit: AUDIT_FEATURE_CHANGE message format missing delimiting space

Richard Guy Briggs <rgb@redhat.com>
    audit: correct AUDIT_GET_FEATURE return message type

Andy Lutomirski <luto@amacapital.net>
    x86, x32, audit: Fix x32's AUDIT_ARCH wrt audit

Herbert Xu <herbert@gondor.apana.org.au>
    tun: Fix csum_start with VLAN acceleration

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Fix uninitialized op->type for some immediate values

Tang Chen <tangchen@cn.fujitsu.com>
    mem-hotplug: reset node present pages when hot-adding a new pgdat

Tang Chen <tangchen@cn.fujitsu.com>
    mem-hotplug: reset node managed pages when hot-adding a new pgdat

Greg Kurz <gkurz@linux.vnet.ibm.com>
    hwrng: pseries - port to new read API and fix stack corruption

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77693: Fix always masked MUIC interrupts

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77693: Use proper regmap for handling MUIC interrupts

Tony Lindgren <tony@atomide.com>
    mfd: twl4030-power: Fix poweroff with PM configuration enabled

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - remove duplicated sg copy functions

Tadeusz Struk <tadeusz.struk@intel.com>
    crypto: qat - Enforce valid numa configuration

Tadeusz Struk <tadeusz.struk@intel.com>
    crypto: qat - Prevent dma mapping zero length assoc data

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - fix missing dma unmap on error path

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/page_alloc: restrict max order of merging on isolated pageblock

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/page_alloc: move freepage counting logic to __free_one_page()

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/page_alloc: add freepage on isolate pageblock to correct buddy list

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/page_alloc: fix incorrect isolation behavior by rechecking migratetype

Weijie Yang <weijie.yang@samsung.com>
    zram: avoid kunmap_atomic() of a NULL pointer

Andreas Larsson <andreas@gaisler.com>
    sparc32: Implement xchg and atomic_xchg using ATOMIC_HASH locks

David S. Miller <davem@davemloft.net>
    sparc64: Do irq_{enter,exit}() around generic_smp_call_function*().

David S. Miller <davem@davemloft.net>
    sparc64: Fix crashes in schizo_pcierr_intr_other().

Dwight Engen <dwight.engen@oracle.com>
    sunvdc: don't call VD_OP_GET_VTOC

Dwight Engen <dwight.engen@oracle.com>
    vio: fix reuse of vio_dring slot

Dwight Engen <dwight.engen@oracle.com>
    sunvdc: limit each sg segment to a page

Allen Pais <allen.pais@oracle.com>
    sunvdc: compute vdisk geometry from capacity

Allen Pais <allen.pais@oracle.com>
    sunvdc: add cdrom and v1.1 protocol support

Enric Balletbo i Serra <eballetbo@iseebcn.com>
    smsc911x: power-up phydev before doing a software reset.

Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
    netlink: Properly unbind in error conditions.

Richard Cochran <richardcochran@gmail.com>
    net: ptp: fix time stamp matching logic for VLAN packets.

Eric Dumazet <edumazet@google.com>
    ipv6: fix IPV6_PKTINFO with v4 mapped

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix memory leak in auth key management

Daniel Borkmann <dborkman@redhat.com>
    net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet

Takashi Iwai <tiwai@suse.de>
    net: ppp: Don't call bpf_prog_create() in ppp_lock

Marcelo Leitner <mleitner@redhat.com>
    vxlan: Do not reuse sockets for a different address family

Jesse Gross <jesse@nicira.com>
    udptunnel: Add SKB_GSO_UDP_TUNNEL during gro_complete.

Karl Beldan <karl.beldan@rivierawaves.com>
    net: mv643xx_eth: reclaim TX skbs only when released by the HW

Steffen Klassert <steffen.klassert@secunet.com>
    gre6: Move the setting of dev->iflink into the ndo_init functions.

Steffen Klassert <steffen.klassert@secunet.com>
    sit: Use ipip6_tunnel_init as the ndo_init function.

Steffen Klassert <steffen.klassert@secunet.com>
    vti6: Use vti6_dev_init as the ndo_init function.

Steffen Klassert <steffen.klassert@secunet.com>
    ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.

Nikolay Aleksandrov <nikolay@redhat.com>
    inet: frags: remove the WARN_ON from inet_evict_bucket

Nikolay Aleksandrov <nikolay@redhat.com>
    inet: frags: fix a race between inet_evict_bucket and inet_frag_kill

Shuah Khan <shuahkh@osg.samsung.com>
    x86/build: Add arch/x86/purgatory/ make generated files to gitignore


-------------

Diffstat:

 .../devicetree/bindings/ata/sata_rcar.txt          |   3 +-
 Makefile                                           |   4 +-
 arch/arm/boot/compressed/head.S                    |  20 ++-
 arch/arm/boot/dts/am335x-evm.dts                   |   2 +-
 arch/arm/mach-mvebu/board-v7.c                     |   2 +-
 arch/arm/mm/Kconfig                                |   1 +
 arch/arm64/kernel/efi-entry.S                      |  27 +++-
 arch/arm64/kernel/insn.c                           |   5 +-
 arch/arm64/lib/clear_user.S                        |   2 +-
 arch/parisc/include/uapi/asm/shmbuf.h              |  25 ++-
 arch/parisc/kernel/syscall_table.S                 |   8 +-
 arch/sparc/include/asm/atomic_32.h                 |   2 +-
 arch/sparc/include/asm/cmpxchg_32.h                |  12 +-
 arch/sparc/include/asm/vio.h                       |  14 +-
 arch/sparc/kernel/pci_schizo.c                     |   6 +-
 arch/sparc/kernel/smp_64.c                         |   4 +
 arch/sparc/lib/atomic32.c                          |  27 ++++
 arch/x86/.gitignore                                |   2 +
 arch/x86/boot/compressed/Makefile                  |   4 +-
 arch/x86/boot/compressed/head_32.S                 |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +-
 arch/x86/boot/compressed/misc.c                    |  13 +-
 arch/x86/boot/compressed/mkpiggy.c                 |   9 +-
 arch/x86/kernel/cpu/microcode/amd_early.c          |  33 ++--
 arch/x86/kernel/cpu/microcode/core_early.c         |   2 +-
 arch/x86/kernel/ptrace.c                           |  11 +-
 arch/x86/kvm/emulate.c                             |   8 +
 arch/x86/kvm/x86.c                                 |   2 +-
 arch/x86/tools/calc_run_size.pl                    |  30 ++++
 arch/xtensa/include/uapi/asm/unistd.h              |   3 +-
 block/ioprio.c                                     |  14 +-
 drivers/ata/ahci.c                                 |  28 ++--
 drivers/ata/sata_rcar.c                            |  10 ++
 drivers/block/sunvdc.c                             | 176 +++++++++++++++------
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/char/hw_random/pseries-rng.c               |  11 +-
 drivers/cpufreq/cpufreq.c                          |   3 +-
 drivers/crypto/caam/caamhash.c                     |  22 ++-
 drivers/crypto/caam/key_gen.c                      |  29 ++--
 drivers/crypto/caam/sg_sw_sec4.h                   |  54 -------
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |   3 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |  12 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |   7 +-
 drivers/crypto/qat/qat_common/qat_crypto.c         |   8 +-
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |   2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |  32 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |   2 +-
 drivers/firewire/core-cdev.c                       |   3 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c                |  16 ++
 drivers/gpu/drm/i915/intel_dp.c                    |   5 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  17 +-
 drivers/gpu/drm/radeon/atom.c                      |  11 +-
 drivers/gpu/drm/radeon/atom.h                      |   2 +
 drivers/gpu/drm/radeon/atombios_dp.c               |   4 +-
 drivers/gpu/drm/radeon/atombios_i2c.c              |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |   7 +-
 drivers/gpu/drm/radeon/cik_sdma.c                  |  21 +--
 drivers/gpu/drm/radeon/evergreen.c                 |   4 +
 drivers/gpu/drm/radeon/r100.c                      |   3 +
 drivers/gpu/drm/radeon/r600_dma.c                  |  20 +--
 drivers/gpu/drm/radeon/radeon_device.c             |   1 +
 drivers/gpu/drm/radeon/rs600.c                     |   3 +
 drivers/gpu/drm/radeon/rs690.c                     |   3 +
 drivers/gpu/drm/radeon/rv515.c                     |   3 +
 drivers/gpu/drm/radeon/si.c                        |   3 +
 drivers/infiniband/core/uverbs_cmd.c               |   2 +
 drivers/input/mouse/alps.c                         |  28 +++-
 drivers/input/mouse/synaptics.c                    |   5 +-
 drivers/md/dm-bufio.c                              |  12 +-
 drivers/md/dm-raid.c                               |  11 +-
 drivers/md/dm-thin.c                               |  16 +-
 drivers/md/md.c                                    |   4 +
 drivers/md/persistent-data/dm-btree-internal.h     |   6 +
 drivers/md/persistent-data/dm-btree-spine.c        |   2 +-
 drivers/md/persistent-data/dm-btree.c              |  24 ++-
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           |   3 +
 drivers/mfd/max77693.c                             |  14 +-
 drivers/mfd/twl4030-power.c                        |  52 ++++++
 drivers/net/ethernet/broadcom/bcmsysport.c         |  11 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c     |   7 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   6 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |  18 ++-
 drivers/net/ethernet/smsc/smsc911x.c               |  46 ++++++
 drivers/net/ethernet/sun/sunvnet.c                 |   4 +-
 drivers/net/ethernet/ti/cpts.c                     |   2 +-
 drivers/net/macvtap.c                              |   2 +
 drivers/net/phy/dp83640.c                          |   4 +-
 drivers/net/ppp/ppp_generic.c                      |  40 ++---
 drivers/net/tun.c                                  |  16 +-
 drivers/net/vxlan.c                                |  31 ++--
 drivers/net/wireless/iwlwifi/mvm/fw.c              |  10 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  11 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   4 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   9 ++
 drivers/platform/x86/dell-wmi.c                    |  12 +-
 drivers/platform/x86/ideapad-laptop.c              |   7 +
 drivers/power/bq2415x_charger.c                    |  23 ++-
 drivers/power/charger-manager.c                    | 163 ++++++++++++-------
 drivers/pwm/core.c                                 |  29 ++--
 drivers/scsi/scsi_error.c                          |   4 +-
 fs/gfs2/dir.c                                      |   9 +-
 fs/gfs2/dir.h                                      |   1 +
 fs/gfs2/inode.c                                    |   6 +-
 fs/nfs/delegation.c                                |  25 ++-
 fs/nfs/delegation.h                                |   1 +
 fs/nfs/direct.c                                    |   1 +
 fs/nfs/filelayout/filelayout.c                     |   3 -
 fs/nfs/inode.c                                     |   2 +-
 fs/nfs/nfs4proc.c                                  |  76 +++++----
 include/dt-bindings/pinctrl/dra.h                  |   4 +-
 include/linux/bootmem.h                            |   1 +
 include/linux/clocksource.h                        |   2 +-
 include/linux/crash_dump.h                         |  15 +-
 include/linux/kgdb.h                               |   2 +-
 include/linux/khugepaged.h                         |  17 +-
 include/linux/memory.h                             |   2 +-
 include/linux/mfd/max77693-private.h               |   7 +
 include/linux/mmzone.h                             |   9 ++
 include/linux/nfs_xdr.h                            |  11 ++
 include/linux/page-isolation.h                     |   8 +
 include/linux/power/charger-manager.h              |   3 -
 include/linux/ring_buffer.h                        |   2 +-
 include/net/sctp/sctp.h                            |   5 +
 include/net/sctp/sm.h                              |   6 +-
 include/net/udp_tunnel.h                           |   9 ++
 include/uapi/linux/netfilter/xt_bpf.h              |   2 +
 init/main.c                                        |   2 +-
 ipc/ipc_sysctl.c                                   |   3 +-
 kernel/audit.c                                     |   4 +-
 kernel/audit_tree.c                                |   1 +
 kernel/rcu/tree.c                                  |   4 +-
 kernel/trace/ring_buffer.c                         |  81 ++++++----
 kernel/trace/trace.c                               |  23 +--
 mm/bootmem.c                                       |   9 +-
 mm/huge_memory.c                                   |  11 +-
 mm/internal.h                                      |  25 +++
 mm/iov_iter.c                                      |   4 +-
 mm/memory_hotplug.c                                |  26 +++
 mm/mmap.c                                          |   8 +-
 mm/nobootmem.c                                     |   8 +-
 mm/page_alloc.c                                    |  55 +++----
 mm/page_isolation.c                                |  43 ++++-
 net/ceph/crypto.c                                  | 169 +++++++++++++++-----
 net/ipv4/inet_fragment.c                           |   4 +-
 net/ipv4/ip_sockglue.c                             |   2 +-
 net/ipv6/ip6_gre.c                                 |   5 +-
 net/ipv6/ip6_tunnel.c                              |  10 +-
 net/ipv6/ip6_vti.c                                 |  11 +-
 net/ipv6/sit.c                                     |  15 +-
 net/mac80211/ibss.c                                |   2 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   7 +-
 net/mac80211/mesh.c                                |   2 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mac80211/rx.c                                  |  14 +-
 net/mac80211/spectmgmt.c                           |  18 +--
 net/netfilter/ipset/ip_set_core.c                  |   2 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |  31 ++--
 net/netfilter/nft_compat.c                         |   2 +-
 net/netlink/af_netlink.c                           |   5 +-
 net/sctp/associola.c                               |   2 +
 net/sctp/auth.c                                    |   2 -
 net/sctp/inqueue.c                                 |  33 +---
 net/sctp/sm_make_chunk.c                           | 102 ++++++------
 net/sctp/sm_statefuns.c                            |  21 +--
 net/sunrpc/auth_gss/auth_gss.c                     |  35 +++-
 scripts/checkpatch.pl                              |   2 +-
 scripts/package/builddeb                           |  22 ++-
 security/keys/keyctl.c                             |   2 +
 sound/pci/hda/patch_conexant.c                     |  31 ++++
 sound/usb/mixer_quirks.c                           |   6 +
 175 files changed, 1711 insertions(+), 875 deletions(-)


