Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3FEWNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:13:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab3FEVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/127] 3.9.5-stable review
Date: Wed,  5 Jun 2013 14:32:47 -0700
Message-Id: <20130605213217.966891866@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.9.5 release.
There are 127 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jun  7 21:30:02 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.5-rc1

Wei Liu <wei.liu2@citrix.com>
    xen-netback: better names for thresholds

Johannes Berg <johannes.berg@intel.com>
    mac80211_hwsim: remove P2P_DEVICE support

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: remove P2P_DEVICE support

Wei Liu <wei.liu2@citrix.com>
    xen-netfront: reduce gso_max_size to account for max TCP header

Wei Liu <wei.liu2@citrix.com>
    xen-netback: avoid allocating variable size array on stack

Wei Liu <wei.liu2@citrix.com>
    xen-netback: remove redundent parameter in netbk_count_requests

Wei Liu <wei.liu2@citrix.com>
    xen-netback: don't disconnect frontend when seeing oversize packet

Wei Liu <wei.liu2@citrix.com>
    xen-netback: coalesce slots in TX path and fix regressions

Timo Teräs <timo.teras@iki.f>
    leds: leds-gpio: reserve gpio before using it

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Fix off-by-one READ_CAPACITY bug for !S_ISBLK export

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Re-instate sess_wait_list for target_wait_for_sess_cmds

Miklos Szeredi <mszeredi@suse.cz>
    fuse: fix readdirplus Oops in fuse_dentry_revalidate

Daniel Mack <zonque@gmail.com>
    ASoC: davinci: fix sample rotation

Or Gerlitz <ogerlitz@mellanox.com>
    IB/iser: Return error to upper layers on EAGAIN registration failures

Jonas Peterson <jonas.peterson@gmail.com>
    net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan R" type hardware.

Nithin Sujir <nsujir@broadcom.com>
    tg3: Add read dma workaround for 5720

Gabor Juhos <juhosg@openwrt.org>
    ath9k: use correct OTP register offsets for AR9550

Johannes Berg <johannes.berg@intel.com>
    cfg80211: check wdev->netdev in connection work

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: tell firmware to let multicast frames in

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: fix zero LQ CMD sending avoidance

Johannes Berg <johannes.berg@intel.com>
    mac80211: close AP_VLAN interfaces before unregistering all

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: fix direct probe auth

Ben Skeggs <bskeggs@redhat.com>
    drm/nvc0/ce: disable ce1 on a number of chipsets

Bastian Triller <bastian.triller@gmail.com>
    ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Allow device power states to be used for CONFIG_PM unset

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Workaround for ERBT1312

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Re-enable IOMMU event log interrupt after handling.

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix aggregation drain flow

Wei Liu <wei.liu2@citrix.com>
    xen-netback: remove skb in xen_netbk_alloc_page

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix a couple races

Jeff Mahoney <jeffm@jeffreymahoney.com>
    reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix problems with chowning setuid file w/ xattrs

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix deadlock with nfs racing on create/lookup

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP

Kishon Vijay Abraham I <kishon@ti.com>
    regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Paolo Bonzini <pbonzini@redhat.com>
    KVM: fix sil/dil/bpl/spl in the mod/rm fields

Paolo Bonzini <pbonzini@redhat.com>
    KVM: Emulate multibyte NOP

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a thinko in nfs4_try_open_cached

Nicholas Bellinger <nab@linux-iscsi.org>
    ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session

Kees Cook <keescook@chromium.org>
    iscsi-target: fix heap buffer overflow on error

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Move TM abort cause codes to uapi

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Abort on emulation and alignment faults

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Fix userspace stack corruption on signal delivery for active transactions

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Update cause codes documentation

Michael Neuling <mikey@neuling.org>
    powerpc/tm: Make room for hypervisor in abort cause codes

Priyanka Jain <Priyanka.Jain@freescale.com>
    powerpc/32bit:Store temporary result in r0 instead of r8

Tejun Heo <tj@kernel.org>
    cgroup: fix a subtle bug in descendant pre-order walk

Li Zefan <lizefan@huawei.com>
    cgroup: initialize xattr before calling d_instantiate()

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/pgtable: Fix check for pgste/storage key handling

Finn Thain <fthain@telegraphics.com.au>
    m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Vincent Pelletier <plr.vincent@gmail.com>
    libata: make ata_exec_internal_sg honor DMADIR

Chew, Chiau Ee <chiau.ee.chew@intel.com>
    ata_piix: add PCI IDs for Intel BayTail

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sata_rcar: fix interrupt handling

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    sata_rcar: clear STOP bit in bmdma_start() method

Jeff Layton <jlayton@redhat.com>
    cifs: fix potential buffer overrun when composing a new options string

Horia Geanta <horia.geanta@freescale.com>
    crypto: caam - fix inconsistent assoc dma mapping direction

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix card_posted check for newer asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in cu_per_sh on verde

Rodrigo Vivi <rodrigo.vivi@gmail.com>
    drm/i915: Adding more reserved PCI IDs for Haswell.

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Correct DSP4R Mixer control name

Nicolas Schichan <nschichan@freebox.fr>
    ASoC: cs42l52: fix default value for MASTERA_VOL.

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix failures to handle -1 uid's and gid's

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Prevent an rpc_task wakeup race

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ARM: SAMSUNG: Export MIPI CSIS/DSIM PHY control functions

Mark Rutland <mark.rutland@arm.com>
    arm64: don't kill the kernel on a bad esr from el0

Dave Chinner <dchinner@redhat.com>
    xfs: kill suid/sgid through the truncate path.

Rusty Russell <rusty@rustcorp.com.au>
    module: don't unlink the module until we've removed all exposure.

Jan Beulich <JBeulich@suse.com>
    x86, crc32-pclmul: Fix build with older binutils

Yinghai Lu <yinghai@kernel.org>
    x86, range: fix missing merge during add range

Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
    x86-64, init: Fix a possible wraparound bug in switchover in head_64.S

Pekka Riikonen <priikone@iki.fi>
    x86: Allow FPU to be used at interrupt time even with eagerfpu

wenxiong@linux.vnet.ibm.com <wenxiong@linux.vnet.ibm.com>
    SCSI: ipr: Need to reset adapter after the 6th EEH error

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Cliff Wickman <cpw@sgi.com>
    mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Brian Behlendorf <behlendorf1@llnl.gov>
    drivers/block/brd.c: fix brd_lookup_page() race

Johannes Weiner <hannes@cmpxchg.org>
    mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
    mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Imre Deak <imre.deak@intel.com>
    wait: fix false timeouts when using wait_event_timeout()

wang, biao <biao.wang@intel.com>
    klist: del waiter from klist_remove_waiters before wakeup waitting process

Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
    mm compaction: fix of improper cache flush in migration code

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/tsi721: fix bug in MSI interrupt handling

Christian Gmeiner <christian.gmeiner@gmail.com>
    drivers/leds/leds-ot200.c: fix error caused by shifted mask

Martin Michlmayr <tbm@cyrius.com>
    Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Joseph Qi <joseph.qi@huawei.com>
    ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k_hw: Enable manual peak calibration for AR9485

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix crash on module unload

Ben Hutchings <ben@decadent.org.uk>
    perf: net_dropmonitor: Fix symbol-relative addresses

Ben Hutchings <ben@decadent.org.uk>
    perf: net_dropmonitor: Fix trace parameter order

Michael Chan <mchan@broadcom.com>
    tg3: Fix data corruption on 5725 with TSO

Nithin Sujir <nsujir@broadcom.com>
    tg3: Skip powering down function 0 on certain serdes devices

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: fix possible overflow for fat_clusters

Jiri Kosina <jkosina@suse.cz>
    random: fix accounting race condition with lockless irq entropy_count update

Jarod Wilson <jarod@redhat.com>
    drivers/char/random.c: fix priming of last_data

Vineet Gupta <vgupta@synopsys.com>
    ARC: copy_(to|from)_user() to honor usermode-access permissions

Jeff Layton <jlayton@redhat.com>
    cifs: only set ops for inodes in I_NEW state

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: Fix a bug in get_vp_index()

Heiko Abraham <abrahamh@web.de>
    Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Alan Stern <stern@rowland.harvard.edu>
    USB: UHCI: fix for suspend of virtual HP controller

Alan Stern <stern@rowland.harvard.edu>
    USB: xHCI: override bogus bulk wMaxPacketSize values

Oliver Neukum <oliver@neukum.org>
    USB: reset resume quirk needed by a hub

Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
    USB: Blacklisted Cinterion's PLxx WWAN Interface

Wang YanQing <udknight@gmail.com>
    TTY: Fix tty miss restart after we turn off flow-control

Dan Carpenter <dan.carpenter@oracle.com>
    USB: cxacru: potential underflow in cxacru_cm_get_array()

Gomella, Andrew (NIH/NHLBI) [F] <andrew.gomella@nih.gov>
    USB: ftdi_sio: Add support for Newport CONEX motor drivers

Dan Williams <dcbw@redhat.com>
    USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Teppo Kotilainen <qubit303@gmail.com>
    usb: option: Add Telewell TW-LTE 4G

David Rientjes <rientjes@google.com>
    usb, chipidea: fix link error when USB_EHCI_HCD is a module

Hema Prathaban <hemaklnce@gmail.com>
    staging: vt6656: use free_netdev instead of kfree

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.

Alexander Bondar <alexander.bondar@intel.com>
    iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Always use SCAN_TYPE_FORCED

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix AP-mode frame matching

Johannes Berg <johannes.berg@intel.com>
    mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix sending WoWLAN TCP wakeup settings

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix wiphy_register error path

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix WoWLAN wakeup tracing

Boris BREZILLON <b.brezillon@overkiz.com>
    ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition

Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    ARM: at91: rm9200 fix time support

Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    ARM: at91/trivial: fix model name for SAM9X25-EK

Ard Biesheuvel <ard.biesheuvel@gmail.com>
    ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling

Vaibhav Hiremath <hvaibhav@ti.com>
    ARM: AM33XX: Add missing .clkdm_name to clkdiv32k_ick clock

jean-philippe francois <jp.francois@cynove.com>
    ARM: OMAP: fix __init section mismatch for _enable_preprogram

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Alan Stern <stern@rowland.harvard.edu>
    USB: fix latency in uhci-hcd and ohci-hcd

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: fix logic for scheduling isochronous URBs

Hans-Christian Egtvedt <egtvedt@samfundet.no>
    avr32: fix relocation check for signed 18-bit offset


-------------

Diffstat:

 Documentation/powerpc/transactional_memory.txt    |  27 +-
 Makefile                                          |   4 +-
 arch/arc/include/asm/pgtable.h                    |  26 +-
 arch/arc/include/asm/tlb.h                        |   2 +-
 arch/arc/mm/tlbex.S                               |   6 +-
 arch/arm/boot/dts/at91sam9260.dtsi                |   2 +-
 arch/arm/boot/dts/at91sam9x25ek.dts               |   2 +-
 arch/arm/crypto/sha1-armv4-large.S                |   2 +-
 arch/arm/mach-at91/at91rm9200_time.c              |   7 +-
 arch/arm/mach-kirkwood/ts219-setup.c              |   2 +-
 arch/arm/mach-omap2/cclock33xx_data.c             |  26 +-
 arch/arm/mach-omap2/omap_hwmod.c                  |   2 +-
 arch/arm/plat-orion/common.c                      |  12 +-
 arch/arm/plat-samsung/setup-mipiphy.c             |   3 +
 arch/arm64/kernel/traps.c                         |  12 +-
 arch/avr32/kernel/module.c                        |   2 +-
 arch/m68k/kernel/head.S                           |  29 +-
 arch/powerpc/include/asm/processor.h              |  13 +-
 arch/powerpc/include/asm/reg.h                    |  11 -
 arch/powerpc/include/asm/signal.h                 |   3 +
 arch/powerpc/include/asm/tm.h                     |   2 +
 arch/powerpc/include/uapi/asm/Kbuild              |   1 +
 arch/powerpc/include/uapi/asm/tm.h                |  18 ++
 arch/powerpc/kernel/entry_32.S                    |   2 +-
 arch/powerpc/kernel/signal.c                      |  40 ++-
 arch/powerpc/kernel/signal.h                      |   2 +-
 arch/powerpc/kernel/signal_32.c                   |  10 +-
 arch/powerpc/kernel/signal_64.c                   |  23 +-
 arch/powerpc/kernel/traps.c                       |  29 ++
 arch/powerpc/platforms/pseries/Kconfig            |   2 +
 arch/s390/include/asm/pgtable.h                   |  15 +-
 arch/x86/crypto/crc32-pclmul_asm.S                |   2 +-
 arch/x86/include/asm/inst.h                       |  74 ++++-
 arch/x86/kernel/head_64.S                         |   6 +-
 arch/x86/kernel/i387.c                            |  14 +-
 arch/x86/kvm/emulate.c                            |   9 +-
 drivers/acpi/Makefile                             |   2 +-
 drivers/acpi/device_pm.c                          | 126 ++++-----
 drivers/acpi/video_detect.c                       |   8 +
 drivers/ata/ata_piix.c                            |  15 ++
 drivers/ata/libata-core.c                         |   6 +
 drivers/ata/sata_rcar.c                           |  24 +-
 drivers/block/brd.c                               |   4 +-
 drivers/char/random.c                             |  54 ++--
 drivers/crypto/caam/caamalg.c                     |   4 +-
 drivers/gpu/drm/i915/i915_drv.c                   |  46 +++-
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c |   2 -
 drivers/gpu/drm/radeon/radeon_device.c            |  19 +-
 drivers/gpu/drm/radeon/si.c                       |   2 +-
 drivers/hv/channel_mgmt.c                         |   2 +-
 drivers/infiniband/ulp/iser/iser_memory.c         |   3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c             |  32 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.h             |   1 +
 drivers/input/touchscreen/egalax_ts.c             |   2 +-
 drivers/iommu/amd_iommu.c                         |  31 ++-
 drivers/iommu/amd_iommu_types.h                   |   1 +
 drivers/leds/leds-gpio.c                          |   9 +-
 drivers/leds/leds-ot200.c                         |  14 +-
 drivers/net/can/usb/kvaser_usb.c                  |  64 +++--
 drivers/net/ethernet/broadcom/tg3.c               |  70 ++++-
 drivers/net/ethernet/broadcom/tg3.h               |   5 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c     |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h    |   9 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h  |   2 +-
 drivers/net/wireless/ath/ath9k/debug.c            |   8 +
 drivers/net/wireless/ath/ath9k/debug.h            |   5 +
 drivers/net/wireless/ath/ath9k/init.c             |  10 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c            |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |  27 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |  12 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |  31 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |   1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c            |   1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c           |   6 +
 drivers/net/wireless/iwlwifi/mvm/sta.c            |  13 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h            |   2 -
 drivers/net/wireless/iwlwifi/mvm/tx.c             |  48 +++-
 drivers/net/wireless/mac80211_hwsim.c             |   4 +-
 drivers/net/xen-netback/netback.c                 | 311 ++++++++++++++++++----
 drivers/net/xen-netfront.c                        |  17 +-
 drivers/rapidio/devices/tsi721.c                  |  12 +
 drivers/regulator/palmas-regulator.c              |   2 +-
 drivers/scsi/ipr.c                                |  12 +-
 drivers/staging/vt6656/hostap.c                   |   2 +-
 drivers/staging/vt6656/iwctl.c                    |   6 +
 drivers/target/iscsi/iscsi_target_parameters.c    |   8 +-
 drivers/target/iscsi/iscsi_target_parameters.h    |   4 +-
 drivers/target/target_core_file.c                 |  12 +-
 drivers/target/target_core_transport.c            |  18 +-
 drivers/tty/n_tty.c                               |   8 +
 drivers/usb/atm/cxacru.c                          |   3 +-
 drivers/usb/chipidea/Kconfig                      |   2 +-
 drivers/usb/core/quirks.c                         |   3 +
 drivers/usb/host/ohci-hcd.c                       |  34 +--
 drivers/usb/host/uhci-hub.c                       |   3 +-
 drivers/usb/host/uhci-q.c                         |   2 +-
 drivers/usb/host/xhci-mem.c                       |  17 +-
 drivers/usb/serial/ftdi_sio.c                     |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                 |   2 +
 drivers/usb/serial/option.c                       |  13 +-
 fs/cifs/cifs_dfs_ref.c                            |   4 +-
 fs/cifs/inode.c                                   |   3 +-
 fs/fat/inode.c                                    |  15 +-
 fs/fuse/dir.c                                     |  12 +-
 fs/fuse/inode.c                                   |   7 +-
 fs/jfs/inode.c                                    |   2 +-
 fs/jfs/jfs_logmgr.c                               |   3 +-
 fs/nfs/nfs4proc.c                                 |   2 +-
 fs/nilfs2/inode.c                                 |  27 +-
 fs/ocfs2/extent_map.c                             |   2 +-
 fs/reiserfs/dir.c                                 |   2 +
 fs/reiserfs/inode.c                               |   9 +-
 fs/reiserfs/xattr.c                               |  14 +-
 fs/reiserfs/xattr_acl.c                           |   3 +
 fs/xfs/xfs_iops.c                                 |  47 ++--
 include/acpi/acpi_bus.h                           |  40 +--
 include/linux/cgroup.h                            |   2 +-
 include/linux/wait.h                              |  16 +-
 include/target/target_core_base.h                 |   1 +
 include/xen/interface/io/netif.h                  |  19 ++
 kernel/cgroup.c                                   |  18 +-
 kernel/module.c                                   |  13 +-
 kernel/range.c                                    |   8 +-
 lib/klist.c                                       |   2 +-
 mm/huge_memory.c                                  |   7 +-
 mm/memcontrol.c                                   |  14 +-
 mm/migrate.c                                      |   2 +-
 mm/mmu_notifier.c                                 |  79 +++---
 mm/pagewalk.c                                     |  70 ++---
 net/mac80211/iface.c                              |   9 +
 net/mac80211/mlme.c                               |  12 +-
 net/mac80211/rx.c                                 |   3 +
 net/mac80211/tkip.c                               |   4 +-
 net/sunrpc/sched.c                                |   8 +-
 net/sunrpc/svcauth_unix.c                         |  12 +-
 net/wireless/core.c                               |  16 +-
 net/wireless/nl80211.c                            |   2 +
 net/wireless/sme.c                                |   3 +
 net/wireless/trace.h                              |  23 +-
 sound/soc/codecs/cs42l52.c                        |   2 +-
 sound/soc/codecs/wm5110.c                         |   2 +-
 sound/soc/davinci/davinci-mcasp.c                 |   7 +-
 tools/perf/scripts/python/net_dropmonitor.py      |   8 +-
 143 files changed, 1545 insertions(+), 673 deletions(-)


