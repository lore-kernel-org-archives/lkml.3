Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3BDEde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:33:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:50738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3BDEdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:33:33 -0500
Date: Sun, 3 Feb 2013 20:35:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.6
Message-ID: <20130204043543.GA14993@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.6 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.7.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/device-mapper/dm-raid.txt               |    1=20
 Makefile                                              |    2=20
 arch/arm/kernel/head.S                                |    5=20
 arch/arm/kernel/hyp-stub.S                            |   18 +--
 arch/arm/mach-at91/setup.c                            |    2=20
 arch/arm/mach-omap2/board-omap4panda.c                |    6 +
 arch/arm/mach-s3c64xx/mach-crag6410-module.c          |    2=20
 arch/arm/mm/dma-mapping.c                             |   18 +--
 arch/arm/vfp/entry.S                                  |    6 -
 arch/arm/vfp/vfphw.S                                  |    4=20
 arch/powerpc/kernel/entry_64.S                        |   13 ++
 arch/powerpc/kvm/emulate.c                            |    2=20
 arch/s390/include/asm/pgtable.h                       |   12 ++
 arch/x86/boot/compressed/eboot.c                      |    3=20
 arch/x86/boot/compressed/head_32.S                    |    2=20
 arch/x86/include/asm/efi.h                            |    1=20
 arch/x86/kernel/msr.c                                 |    3=20
 arch/x86/kernel/reboot.c                              |    2=20
 arch/x86/kernel/setup.c                               |   30 ++---
 arch/x86/platform/efi/efi.c                           |   59 ++++++----
 arch/x86/platform/efi/efi_64.c                        |   22 +++
 drivers/acpi/osl.c                                    |    2=20
 drivers/edac/edac_pci_sysfs.c                         |    2=20
 drivers/firmware/dmi_scan.c                           |    2=20
 drivers/firmware/efivars.c                            |    4=20
 drivers/firmware/iscsi_ibft_find.c                    |    2=20
 drivers/gpu/drm/i915/i915_debugfs.c                   |    2=20
 drivers/gpu/drm/i915/i915_reg.h                       |    1=20
 drivers/gpu/drm/i915/intel_pm.c                       |   15 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c               |   24 +++-
 drivers/gpu/drm/radeon/radeon_cs.c                    |    6 -
 drivers/gpu/drm/radeon/radeon_cursor.c                |    3=20
 drivers/gpu/drm/radeon/radeon_device.c                |    3=20
 drivers/gpu/drm/radeon/radeon_display.c               |    2=20
 drivers/hid/hid-ids.h                                 |    3=20
 drivers/hid/usbhid/hid-quirks.c                       |    1=20
 drivers/iommu/amd_iommu_init.c                        |   34 ++++++
 drivers/iommu/intel-iommu.c                           |   21 ++-
 drivers/md/dm-raid.c                                  |  101 ++++++-------=
-----
 drivers/mfd/tc3589x.c                                 |   17 ---
 drivers/net/can/c_can/c_can.c                         |    4=20
 drivers/net/can/pch_can.c                             |    2=20
 drivers/net/can/ti_hecc.c                             |    4=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.c           |   25 +---
 drivers/net/wireless/ath/ath9k/ath9k.h                |    3=20
 drivers/net/wireless/ath/ath9k/beacon.c               |    2=20
 drivers/net/wireless/ath/ath9k/debug.c                |    1=20
 drivers/net/wireless/ath/ath9k/debug.h                |    2=20
 drivers/net/wireless/ath/ath9k/htc_hst.c              |    2=20
 drivers/net/wireless/ath/ath9k/main.c                 |   22 +--
 drivers/net/wireless/ath/ath9k/recv.c                 |   54 ++-------
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |   11 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c        |   14 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.h        |    2=20
 drivers/net/wireless/brcm80211/brcmsmac/pub.h         |    2=20
 drivers/net/wireless/iwlegacy/common.c                |   35 ++----
 drivers/net/wireless/mwifiex/cfg80211.c               |   15 --
 drivers/net/wireless/mwifiex/pcie.c                   |    2=20
 drivers/net/wireless/mwifiex/sta_ioctl.c              |   14 ++
 drivers/platform/x86/ibm_rtl.c                        |    2=20
 drivers/platform/x86/samsung-laptop.c                 |    4=20
 drivers/scsi/isci/init.c                              |    2=20
 drivers/target/target_core_fabric_configfs.c          |   11 -
 fs/cifs/cifs_dfs_ref.c                                |    2=20
 fs/nfs/namespace.c                                    |   20 +++
 fs/nfs/nfs4client.c                                   |   62 ++++-------
 fs/nfs/nfs4state.c                                    |   22 ++-
 fs/nfs/super.c                                        |   22 +--
 fs/xfs/xfs_aops.c                                     |    2=20
 fs/xfs/xfs_buf.c                                      |   18 +++
 fs/xfs/xfs_sync.c                                     |    2=20
 include/linux/efi.h                                   |   24 +++-
 include/net/netfilter/nf_conntrack_core.h             |    2=20
 include/net/netns/x_tables.h                          |    1=20
 init/main.c                                           |    4=20
 kernel/smp.c                                          |   13 ++
 mm/slub.c                                             |    1=20
 net/bluetooth/hci_event.c                             |    2=20
 net/bluetooth/hidp/core.c                             |    2=20
 net/ipv4/netfilter/ipt_REJECT.c                       |    1=20
 net/ipv6/netfilter/ip6t_REJECT.c                      |    1=20
 net/ipv6/netfilter/nf_conntrack_reasm.c               |    5=20
 net/mac80211/cfg.c                                    |   12 +-
 net/mac80211/ieee80211_i.h                            |    6 -
 net/mac80211/offchannel.c                             |   19 +--
 net/mac80211/scan.c                                   |   15 --
 net/netfilter/Kconfig                                 |    7 +
 net/netfilter/nf_conntrack_core.c                     |    9 -
 net/netfilter/nf_conntrack_netlink.c                  |    2=20
 net/netfilter/nf_conntrack_standalone.c               |    1=20
 net/netfilter/nfnetlink_log.c                         |   16 ++
 net/netfilter/x_tables.c                              |   28 +++-
 net/netfilter/xt_CT.c                                 |   54 +++++++++
 net/netfilter/xt_hashlimit.c                          |   54 ++++++++-
 net/netfilter/xt_recent.c                             |   43 ++++++-
 sound/pci/hda/hda_intel.c                             |   40 ++++---
 sound/pci/hda/patch_realtek.c                         |    2=20
 sound/soc/codecs/arizona.c                            |    2=20
 sound/soc/codecs/wm2200.c                             |    3=20
 sound/usb/mixer.c                                     |   17 ++-
 virt/kvm/eventfd.c                                    |    2=20
 101 files changed, 756 insertions(+), 475 deletions(-)

Alan Cox (1):
      x86/msr: Add capabilities check

Alex Williamson (1):
      kvm: Fix irqfd resampler list walk

Alexander Graf (1):
      KVM: PPC: Emulate dcbf

Amitkumar Karwar (1):
      mwifiex: update config_bands during infra association

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Avinash Patil (1):
      mwifiex: fix typo in PCIe adapter NULL check

Bob Hockney (1):
      netfilter: nfnetlink_log: fix mac address for 6in4 tunnels

CAI Qian (1):
      slub: assign refcount for kmalloc_caches

Chris Rattray (1):
      ASoC: wm2200: correct mixer values and text

Chris Wilson (2):
      drm/i915: Disable AsyncFlip performance optimisations
      drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline=
 waits

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 dev=
ices

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function

Daniel Vetter (2):
      drm/i915: dump UTS_RELEASE into the error_state
      iommu/intel: disable DMAR for g4x integrated gfx

Dave Chinner (2):
      xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end
      xfs: fix periodic log flushing

Dave Martin (1):
      ARM: virt: Avoid bx instruction for compatibility with <=3DARMv4

David Henningsson (1):
      ALSA: hda - fix inverted internal mic on Acer AOA150/ZG5

David Woodhouse (2):
      x86, efi: Fix display detection in EFI boot stub
      x86, efi: Fix 32-bit EFI handover protocol entry point

Dimitris Papastamos (1):
      ARM: S3C64XX: Fix up IRQ mapping for balblair on Cragganmore

Eric Dumazet (1):
      netfilter: xt_recent: avoid high order page allocations

Felix Fietkau (9):
      ath9k: do not link receive buffers during flush
      ath9k: fix double-free bug on beacon generate failure
      ath9k: remove the WARN_ON that triggers if generating a beacon fails
      ath9k: add a better fix for the rx tasklet vs rx flush race
      ath9k: fix rx flush handling
      ath9k: remove sc->rx.rxbuflock to fix a deadlock
      ath9k: disable the tasklet before taking the PCU lock
      ath9k_hw: fix chain swap setting when setting rx chainmask to 5
      ath9k: allow setting arbitrary antenna masks on AR9003+

Gerald Schaefer (1):
      s390/thp: implement pmdp_set_wrprotect()

Greg Kroah-Hartman (1):
      Linux 3.7.6

H. Peter Anvin (1):
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Haibo Xi (1):
      netfilter: nf_ct_reasm: fix conntrack reassembly expire code

Ilija Hadzic (2):
      drm/radeon: fix error path in kpage allocation
      drm/radeon: fix a rare case of double kfree

Jan Engelhardt (1):
      netfilter: x_tables: print correct hook names for ARP

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jani Nikula (1):
      drm/i915: fix FORCEWAKE posting reads

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: rm9200: remake the BGA as default version

Jerome Glisse (1):
      drm/radeon: fix cursor corruption on DCE6 and newer

Jesper Juhl (1):
      netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expe=
ct

Johannes Berg (1):
      mac80211: fix FT roaming

Jonathan Brassow (1):
      DM-RAID: Fix RAID10's check for sufficient redundancy

Linus Walleij (1):
      mfd: tc3589x: Use simple irqdomain

Luciano Coelho (1):
      ARM: OMAP2+: omap4-panda: add UART2 muxing for WiLink shared transport

Marc Zyngier (2):
      ARM: virt: boot secondary CPUs through the right entry point
      ARM: virt: simplify __hyp_stub_install epilog

Mark Brown (1):
      ASoC: arizona: Use actual rather than desired BCLK when calculating L=
RCLK

Matt Fleming (3):
      efi: Make 'efi_enabled' a function to query EFI facilities
      samsung-laptop: Disable on EFI hardware
      x86, efi: Set runtime_version to the EFI spec revision

Mukund Jampala (1):
      netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP r=
eset

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Nicholas Bellinger (1):
      target: fix regression with dev_link_magic in target_fabric_port_link

Nicholas Santos (1):
      HID: usbhid: quirk for Formosa IR receiver

Nicolas Pitre (1):
      ARM: 7628/1: head.S: map one extra section for the ATAG/DTB area

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Pablo Neira Ayuso (6):
      netfilter: nfnetlink_log: fix possible compilation issue due to missi=
ng include
      netfilter: xt_CT: recover NOTRACK target support
      netfilter: fix missing dependencies for the NOTRACK target
      netfilter: xt_hashlimit: fix race that results in duplicated entries
      netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with =
netns
      netfilter: xt_CT: fix unset return value if conntrack zone are disabl=
ed

Piotr Haber (2):
      brcmsmac: increase timer reference count for new timers only
      brcmsmac: handle packet drop during transmit correctly

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with =
sparsemem

Stanislaw Gruszka (2):
      iwlegacy: fix IBSS cleanup
      mac80211: synchronize scan off/on-channel and PS states

Stephen Boyd (1):
      ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

Takashi Iwai (2):
      ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880
      ALSA: hda - Fix non-snoop page handling

Tiejun Chen (1):
      powerpc/book3e: Disable interrupt after preempt_schedule_irq

Trond Myklebust (6):
      NFS: Fix error reporting in nfs_xdev_mount
      NFS: Don't silently fail setattr() requests on mountpoints
      NFSv4: Fix NFSv4 reference counting for trunked sessions
      NFSv4: Fix NFSv4 trunking discovery
      NFSv4.1: Ensure that nfs41_walk_client_list() does start lease recove=
ry
      NFSv4.1: Handle NFS4ERR_DELAY when resetting the NFSv4.1 session

Vitaly E. Lavrov (2):
      netfilter: xt_hashlimit: fix namespace destroy path
      netfilter: xt_recent: fix namespace destroy path

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race

xueminsu (1):
      radeon_display: Use pointer return error codes


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRDzqfAAoJEDjbvchgkmk+o2gP+QG45/jWP+gzjGSsViNeCPqZ
wwxhP/1B0nGeLuHRF6cARTDGEDmfb2rgi9T6BRXiqNd1g0CRWHWip5Ce2m87vpMv
lEyMMt4P3g0oYEbbjGk+gdDlp034wpvFYrfhtvR/RK+CpXd+XtywtnlzLTbxVRSC
bJZ0f7NejKDNlL8RrpNSvDk9TFHpegAk9mH+cukVQAr1tsmqoyqZEPFy2vPOf2jH
UvtTK1sS0p1kfYmTqfF1UjklAAfS/9lg1KQQOQQb4fHCx8TFFAtOgqXtdbQXIwMN
cvgyCRMx9MTs7P/BirvPFau15S3Xsx1jiTS0vY7QesQ0ElftejJmpIIgyVxTqX7z
cTKQ1U3m34007Am5Cl6HaosdgpUyHtp9XIU1FqBizw7Sy44wjv4lhfIe1H7bgWZw
sJ3AjEJDlxt2bNJeP0HWII79nfLbvEtbmypZhfsmS6TrWKyM4tWPzr9cRt812M7G
XWu2zwC/gWTVdck5FfgssM9iPr1wJUCc2swwH36bMZ4ggommK/3ZA0mvo+HRfc2o
k4L08XxDuOy9BiDUm9816DH7SfmRKblUHh6IgP/R1oEDmttuQTp7SORJKnCe+6hH
pl0l8u2K75b3AqEJt5x3Df3lYBidSay/y7y+VqY6M5kOVoLkV//9Rkgd4UCfZQWV
9yHfg012Zq41ukUdNw2D
=bgf3
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
