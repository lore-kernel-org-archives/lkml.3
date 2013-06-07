Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3FGT6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:58:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3FGT6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:58:17 -0400
Date: Fri, 7 Jun 2013 12:58:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.5
Message-ID: <20130607195816.GA28479@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.5 kernel.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/powerpc/transactional_memory.txt    |   27 +
 Makefile                                          |    2=20
 arch/arc/include/asm/pgtable.h                    |   26 +
 arch/arc/include/asm/tlb.h                        |    2=20
 arch/arc/mm/tlbex.S                               |    6=20
 arch/arm/boot/dts/at91sam9260.dtsi                |    2=20
 arch/arm/boot/dts/at91sam9x25ek.dts               |    2=20
 arch/arm/crypto/sha1-armv4-large.S                |    2=20
 arch/arm/mach-at91/at91rm9200_time.c              |    7=20
 arch/arm/mach-kirkwood/ts219-setup.c              |    2=20
 arch/arm/mach-omap2/cclock33xx_data.c             |   26 +
 arch/arm/mach-omap2/omap_hwmod.c                  |    2=20
 arch/arm/plat-orion/common.c                      |   12=20
 arch/arm/plat-samsung/setup-mipiphy.c             |    3=20
 arch/arm64/kernel/traps.c                         |   12=20
 arch/avr32/kernel/module.c                        |    2=20
 arch/m68k/kernel/head.S                           |   29 +-
 arch/powerpc/include/asm/processor.h              |   13=20
 arch/powerpc/include/asm/reg.h                    |   11=20
 arch/powerpc/include/asm/signal.h                 |    3=20
 arch/powerpc/include/asm/tm.h                     |    2=20
 arch/powerpc/include/uapi/asm/Kbuild              |    1=20
 arch/powerpc/include/uapi/asm/tm.h                |   18 +
 arch/powerpc/kernel/entry_32.S                    |    2=20
 arch/powerpc/kernel/signal.c                      |   40 ++
 arch/powerpc/kernel/signal.h                      |    2=20
 arch/powerpc/kernel/signal_32.c                   |   10=20
 arch/powerpc/kernel/signal_64.c                   |   23 -
 arch/powerpc/kernel/traps.c                       |   29 ++
 arch/powerpc/platforms/pseries/Kconfig            |    2=20
 arch/s390/include/asm/pgtable.h                   |   15 -
 arch/x86/crypto/crc32-pclmul_asm.S                |    2=20
 arch/x86/include/asm/inst.h                       |   74 +++++
 arch/x86/kernel/head_64.S                         |    6=20
 arch/x86/kernel/i387.c                            |   14=20
 arch/x86/kvm/emulate.c                            |    9=20
 drivers/acpi/Makefile                             |    2=20
 drivers/acpi/device_pm.c                          |  126 ++++----
 drivers/acpi/video_detect.c                       |    8=20
 drivers/ata/ata_piix.c                            |   15 +
 drivers/ata/libata-core.c                         |    6=20
 drivers/ata/sata_rcar.c                           |   24 -
 drivers/block/brd.c                               |    4=20
 drivers/char/random.c                             |   54 ++-
 drivers/crypto/caam/caamalg.c                     |    4=20
 drivers/gpu/drm/i915/i915_drv.c                   |   46 ++-
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c |    2=20
 drivers/gpu/drm/radeon/radeon_device.c            |   19 -
 drivers/gpu/drm/radeon/si.c                       |    2=20
 drivers/hv/channel_mgmt.c                         |    2=20
 drivers/infiniband/ulp/iser/iser_memory.c         |    3=20
 drivers/infiniband/ulp/srpt/ib_srpt.c             |   32 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h             |    1=20
 drivers/input/touchscreen/egalax_ts.c             |    2=20
 drivers/iommu/amd_iommu.c                         |   31 +-
 drivers/iommu/amd_iommu_types.h                   |    1=20
 drivers/leds/leds-gpio.c                          |    9=20
 drivers/leds/leds-ot200.c                         |   14=20
 drivers/net/can/usb/kvaser_usb.c                  |   64 +++-
 drivers/net/ethernet/broadcom/tg3.c               |   70 ++++
 drivers/net/ethernet/broadcom/tg3.h               |    5=20
 drivers/net/wireless/ath/ath9k/ar9003_calib.c     |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h    |    9=20
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h  |    2=20
 drivers/net/wireless/ath/ath9k/debug.c            |    8=20
 drivers/net/wireless/ath/ath9k/debug.h            |    5=20
 drivers/net/wireless/ath/ath9k/init.c             |   10=20
 drivers/net/wireless/iwlwifi/dvm/sta.c            |    2=20
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |   27 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |   12=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |   31 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |    1=20
 drivers/net/wireless/iwlwifi/mvm/ops.c            |    1=20
 drivers/net/wireless/iwlwifi/mvm/scan.c           |    6=20
 drivers/net/wireless/iwlwifi/mvm/sta.c            |   13=20
 drivers/net/wireless/iwlwifi/mvm/sta.h            |    2=20
 drivers/net/wireless/iwlwifi/mvm/tx.c             |   48 ++-
 drivers/net/wireless/mac80211_hwsim.c             |    4=20
 drivers/net/xen-netback/netback.c                 |  311 +++++++++++++++++=
+----
 drivers/net/xen-netfront.c                        |   17 +
 drivers/rapidio/devices/tsi721.c                  |   12=20
 drivers/regulator/palmas-regulator.c              |    2=20
 drivers/scsi/ipr.c                                |   12=20
 drivers/staging/vt6656/hostap.c                   |    2=20
 drivers/staging/vt6656/iwctl.c                    |    6=20
 drivers/target/iscsi/iscsi_target_parameters.c    |    8=20
 drivers/target/iscsi/iscsi_target_parameters.h    |    4=20
 drivers/target/target_core_file.c                 |   12=20
 drivers/target/target_core_transport.c            |   18 -
 drivers/tty/n_tty.c                               |    8=20
 drivers/usb/atm/cxacru.c                          |    3=20
 drivers/usb/chipidea/Kconfig                      |    2=20
 drivers/usb/core/quirks.c                         |    3=20
 drivers/usb/host/ohci-hcd.c                       |   34 +-
 drivers/usb/host/uhci-hub.c                       |    3=20
 drivers/usb/host/uhci-q.c                         |    2=20
 drivers/usb/host/xhci-mem.c                       |   17 -
 drivers/usb/serial/ftdi_sio.c                     |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                 |    2=20
 drivers/usb/serial/option.c                       |   13=20
 fs/cifs/cifs_dfs_ref.c                            |    4=20
 fs/cifs/inode.c                                   |    3=20
 fs/fat/inode.c                                    |   15 -
 fs/fuse/dir.c                                     |   12=20
 fs/fuse/inode.c                                   |    7=20
 fs/jfs/inode.c                                    |    2=20
 fs/jfs/jfs_logmgr.c                               |    3=20
 fs/nfs/nfs4proc.c                                 |    2=20
 fs/nilfs2/inode.c                                 |   27 +
 fs/ocfs2/extent_map.c                             |    2=20
 fs/reiserfs/dir.c                                 |    2=20
 fs/reiserfs/inode.c                               |    9=20
 fs/reiserfs/xattr.c                               |   14=20
 fs/reiserfs/xattr_acl.c                           |    3=20
 fs/xfs/xfs_iops.c                                 |   47 ++-
 include/acpi/acpi_bus.h                           |   40 --
 include/linux/cgroup.h                            |    2=20
 include/linux/wait.h                              |   16 -
 include/target/target_core_base.h                 |    1=20
 include/xen/interface/io/netif.h                  |   19 +
 kernel/cgroup.c                                   |   18 -
 kernel/module.c                                   |   13=20
 kernel/range.c                                    |    8=20
 lib/klist.c                                       |    2=20
 mm/huge_memory.c                                  |    7=20
 mm/memcontrol.c                                   |   14=20
 mm/migrate.c                                      |    2=20
 mm/mmu_notifier.c                                 |   79 ++---
 mm/pagewalk.c                                     |   70 ++--
 net/mac80211/iface.c                              |    9=20
 net/mac80211/mlme.c                               |   12=20
 net/mac80211/rx.c                                 |    3=20
 net/mac80211/tkip.c                               |    4=20
 net/sunrpc/sched.c                                |    8=20
 net/sunrpc/svcauth_unix.c                         |   12=20
 net/wireless/core.c                               |   16 -
 net/wireless/nl80211.c                            |    2=20
 net/wireless/sme.c                                |    3=20
 net/wireless/trace.h                              |   23 -
 sound/soc/codecs/cs42l52.c                        |    2=20
 sound/soc/codecs/wm5110.c                         |    2=20
 sound/soc/davinci/davinci-mcasp.c                 |    7=20
 tools/perf/scripts/python/net_dropmonitor.py      |    8=20
 143 files changed, 1544 insertions(+), 672 deletions(-)

Alan Stern (4):
      USB: OHCI: fix logic for scheduling isochronous URBs
      USB: fix latency in uhci-hcd and ohci-hcd
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller

Alex Deucher (2):
      drm/radeon: fix typo in cu_per_sh on verde
      drm/radeon: fix card_posted check for newer asics

Alexander Bondar (1):
      iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Ard Biesheuvel (1):
      ARM: 7723/1: crypto: sha1-armv4-large.S: fix SP handling

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (2):
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses

Ben Skeggs (1):
      drm/nvc0/ce: disable ce1 on a number of chipsets

Boris BREZILLON (1):
      ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Charles Keepax (1):
      ASoC: wm5110: Correct DSP4R Mixer control name

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christian Borntraeger (1):
      s390/pgtable: Fix check for pgste/storage key handling

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Daniel Mack (1):
      ASoC: davinci: fix sample rotation

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Kleikamp (1):
      jfs: fix a couple races

David Rientjes (1):
      usb, chipidea: fix link error when USB_EHCI_HCD is a module

Emmanuel Grumbach (3):
      iwlwifi: mvm: fix aggregation drain flow
      iwlwifi: dvm: fix zero LQ CMD sending avoidance
      iwlwifi: mvm: tell firmware to let multicast frames in

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Gabor Juhos (1):
      ath9k: use correct OTP register offsets for AR9550

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Greg Kroah-Hartman (1):
      Linux 3.9.5

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Horia Geanta (1):
      crypto: caam - fix inconsistent assoc dma mapping direction

Ilan Peer (1):
      iwlwifi: mvm: Always use SCAN_TYPE_FORCED

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

J. Bruce Fields (1):
      svcrpc: fix failures to handle -1 uid's and gid's

Jan Beulich (1):
      x86, crc32-pclmul: Fix build with older binutils

Jarod Wilson (1):
      drivers/char/random.c: fix priming of last_data

Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91/trivial: fix model name for SAM9X25-EK
      ARM: at91: rm9200 fix time support

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
      cifs: fix potential buffer overrun when composing a new options string

Jeff Mahoney (3):
      reiserfs: fix deadlock with nfs racing on create/lookup
      reiserfs: fix problems with chowning setuid file w/ xattrs
      reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count=
 update

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312

Johannes Berg (9):
      cfg80211: fix WoWLAN wakeup tracing
      cfg80211: fix wiphy_register error path
      cfg80211: fix sending WoWLAN TCP wakeup settings
      mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
      mac80211: fix AP-mode frame matching
      mac80211: close AP_VLAN interfaces before unregistering all
      cfg80211: check wdev->netdev in connection work
      iwlwifi: mvm: remove P2P_DEVICE support
      mac80211_hwsim: remove P2P_DEVICE support

Johannes Weiner (1):
      mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

Jonas Peterson (1):
      net: can: kvaser_usb: fix reception on "USBcan Pro" and "USBcan R" ty=
pe hardware.

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs=
2_fiemap()

K. Y. Srinivasan (1):
      Drivers: hv: Fix a bug in get_vp_index()

Kees Cook (1):
      iscsi-target: fix heap buffer overflow on error

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for S=
MPS10

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Li Zefan (1):
      cgroup: initialize xattr before calling d_instantiate()

Malcolm Priestley (1):
      staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.

Mark Rutland (1):
      arm64: don't kill the kernel on a bad esr from el0

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Michael Chan (1):
      tg3: Fix data corruption on 5725 with TSO

Michael Neuling (5):
      powerpc/tm: Make room for hypervisor in abort cause codes
      powerpc/tm: Update cause codes documentation
      powerpc/tm: Fix userspace stack corruption on signal delivery for act=
ive transactions
      powerpc/tm: Abort on emulation and alignment faults
      powerpc/tm: Move TM abort cause codes to uapi

Miklos Szeredi (1):
      fuse: fix readdirplus Oops in fuse_dentry_revalidate

Nicholas Bellinger (3):
      ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
      target: Re-instate sess_wait_list for target_wait_for_sess_cmds
      target/file: Fix off-by-one READ_CAPACITY bug for !S_ISBLK export

Nicolas Schichan (1):
      ASoC: cs42l52: fix default value for MASTERA_VOL.

Nithin Sujir (2):
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Add read dma workaround for 5720

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Or Gerlitz (1):
      IB/iser: Return error to upper layers on EAGAIN registration failures

Paolo Bonzini (2):
      KVM: Emulate multibyte NOP
      KVM: fix sil/dil/bpl/spl in the mod/rm fields

Pekka Riikonen (1):
      x86: Allow FPU to be used at interrupt time even with eagerfpu

Priyanka Jain (1):
      powerpc/32bit:Store temporary result in r0 instead of r8

Rafael J. Wysocki (1):
      ACPI / PM: Allow device power states to be used for CONFIG_PM unset

Rodrigo Vivi (1):
      drm/i915: Adding more reserved PCI IDs for Haswell.

Rusty Russell (1):
      module: don't unlink the module until we've removed all exposure.

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Sergei Shtylyov (2):
      sata_rcar: clear STOP bit in bmdma_start() method
      sata_rcar: fix interrupt handling

Srivatsa S. Bhat (1):
      powerpc/pseries: Always enable CONFIG_HOTPLUG_CPU on PSERIES SMP

Stanislaw Gruszka (1):
      mac80211: fix direct probe auth

Sujith Manoharan (2):
      ath9k: Fix crash on module unload
      ath9k_hw: Enable manual peak calibration for AR9485

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.

Sylwester Nawrocki (1):
      ARM: SAMSUNG: Export MIPI CSIS/DSIM PHY control functions

Tejun Heo (1):
      cgroup: fix a subtle bug in descendant pre-order walk

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Timo Ter=E4s (1):
      leds: leds-gpio: reserve gpio before using it

Trond Myklebust (2):
      SUNRPC: Prevent an rpc_task wakeup race
      NFSv4: Fix a thinko in nfs4_try_open_cached

Vaibhav Hiremath (1):
      ARM: AM33XX: Add missing .clkdm_name to clkdiv32k_ick clock

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Vineet Gupta (1):
      ARC: copy_(to|from)_user() to honor usermode-access permissions

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Liu (7):
      xen-netback: remove skb in xen_netbk_alloc_page
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netfront: reduce gso_max_size to account for max TCP header
      xen-netback: better names for thresholds

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

Yinghai Lu (1):
      x86, range: fix missing merge during add range

Zhang Yanfei (1):
      x86-64, init: Fix a possible wraparound bug in switchover in head_64.S

jean-philippe francois (1):
      ARM: OMAP: fix __init section mismatch for _enable_preprogram

wang, biao (1):
      klist: del waiter from klist_remove_waiters before wakeup waitting pr=
ocess

wenxiong@linux.vnet.ibm.com (1):
      SCSI: ipr: Need to reset adapter after the 6th EEH error


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRsjtYAAoJEDjbvchgkmk+c0UP/ihCLemYUqRZwOP299N9tjRm
AgyDLf48TlLHtvRPnonyH7vzWGFDoLSoqviqzj5N3oD+bKAM4duXorJcznFaGnB/
HFZFuzG2g+G+KS1lY5GV41G+XKc1vWrmBaCiZALmG5MLkHDWYuIDkNSqcL5LjBux
rrucyjqTUS6TMoYcSLXbKB8MrmwWXMFgesbj2VDLUxQc+tfIVKRCQEGnZCF1gq/7
odTXvj9sudm2JpOMneWhBpX7jUM9EPotzMwxOSwb5oU1Qyz6RI/DHH2K2XWhU3uG
UrFqVeoZCXDaKtWK5YvNSiMTxKL1gVaX4850kr7/mFx/B0M5AYpfBZS32oNpqay+
FLOLOS57DZelHWz/SHPc2JWlLBPlZ5tTup5wub6kCxxbtrjsYWC0EXI3QOPT+Hzn
v9q4MGvhNvS/Nrs5tALfEpcDfnGSE3Qdhm1euXWlHYWIaAHEPkzZ2z0MockPQgI/
tgPq3Pq+gh/CKsy7kCrk5YS8Y3gi+5jAa0O0VENy7JflbPktvyVnNbncHLxMOJkz
lLgRFUnRU27cbmONr7rFhPM+NJ4BcnWvhu5KXX1Cv/7EuJ7RTvvnFt+COqs2MNuK
19XoKRxfMNnyDfu1CMEVmDoMf7gGgdrg3GOLcbLCfPXeWHbulpeucM0aatj1hz8D
ka1AJJejHi2/D5QFjJ2n
=DVrx
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
