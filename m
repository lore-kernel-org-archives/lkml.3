Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaCGHZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:25:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaCGHZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:25:13 -0500
Date: Thu, 6 Mar 2014 23:25:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.6
Message-ID: <20140307072543.GA29971@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.6 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arm/include/asm/cacheflush.h               |    1=20
 arch/arm/include/asm/pgtable-3level.h           |   15 -
 arch/arm/include/asm/spinlock.h                 |   15 -
 arch/arm/mach-imx/Makefile                      |    2=20
 arch/arm/mach-imx/common.h                      |    4=20
 arch/arm/mach-omap2/gpmc.c                      |    4=20
 arch/arm/mach-tegra/tegra.c                     |   10 +
 arch/arm/mm/dma-mapping.c                       |    2=20
 arch/arm/mm/mm.h                                |    1=20
 arch/arm/mm/mmu.c                               |    7=20
 arch/arm/mm/proc-v6.S                           |    3=20
 arch/arm/mm/proc-v7.S                           |    2=20
 arch/arm64/kernel/stacktrace.c                  |    6=20
 arch/avr32/Makefile                             |    2=20
 arch/avr32/boards/mimc200/fram.c                |    1=20
 arch/powerpc/include/asm/compat.h               |    5=20
 arch/powerpc/include/asm/opal.h                 |    4=20
 arch/powerpc/include/asm/ptrace.h               |   16 +
 arch/powerpc/kernel/crash_dump.c                |    8=20
 arch/powerpc/kernel/misc_32.S                   |    5=20
 arch/powerpc/kernel/signal_64.c                 |    4=20
 arch/powerpc/platforms/powernv/eeh-ioda.c       |   29 ---
 arch/powerpc/platforms/powernv/opal-xscom.c     |   21 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   22 +-
 arch/x86/kernel/cpu/perf_event.c                |    3=20
 arch/x86/kernel/pci-dma.c                       |    4=20
 arch/x86/kvm/vmx.c                              |    2=20
 arch/x86/kvm/x86.c                              |    2=20
 arch/xtensa/include/asm/traps.h                 |   44 +++-
 arch/xtensa/kernel/entry.S                      |   72 ++++++-
 drivers/acpi/pci_irq.c                          |    1=20
 drivers/acpi/processor_throttling.c             |   69 +++----
 drivers/acpi/video.c                            |    8=20
 drivers/ata/ahci.c                              |   14 +
 drivers/ata/libata-pmp.c                        |    7=20
 drivers/ata/sata_sil.c                          |    1=20
 drivers/base/firmware_class.c                   |    1=20
 drivers/cpufreq/intel_pstate.c                  |    2=20
 drivers/cpufreq/powernow-k8.c                   |   10 -
 drivers/dma/ioat/dma.c                          |   52 ++++-
 drivers/dma/ioat/dma.h                          |    1=20
 drivers/dma/ioat/dma_v2.c                       |   11 -
 drivers/dma/ioat/dma_v3.c                       |    3=20
 drivers/dma/ste_dma40.c                         |    4=20
 drivers/edac/i7300_edac.c                       |   38 ++--
 drivers/edac/i7core_edac.c                      |    9=20
 drivers/gpu/drm/i915/intel_display.c            |   14 +
 drivers/gpu/drm/i915/intel_dp.c                 |   19 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c         |   21 ++
 drivers/gpu/drm/i915/intel_ringbuffer.h         |    1=20
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |    2=20
 drivers/gpu/drm/nouveau/core/subdev/fb/nv1a.c   |    2=20
 drivers/gpu/drm/nouveau/nouveau_drm.c           |    3=20
 drivers/gpu/drm/radeon/atombios_crtc.c          |   29 ++-
 drivers/gpu/drm/radeon/dce6_afmt.c              |    2=20
 drivers/gpu/drm/radeon/evergreen.c              |    2=20
 drivers/gpu/drm/radeon/ni_dpm.c                 |    2=20
 drivers/gpu/drm/radeon/radeon.h                 |    4=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |    3=20
 drivers/gpu/drm/radeon/radeon_kms.c             |    6=20
 drivers/gpu/drm/radeon/radeon_ring.c            |    2=20
 drivers/gpu/drm/radeon/radeon_semaphore.c       |   19 +-
 drivers/gpu/drm/radeon/radeon_uvd.c             |    2=20
 drivers/gpu/drm/radeon/rv770.c                  |    2=20
 drivers/hwmon/max1668.c                         |    2=20
 drivers/iio/gyro/Kconfig                        |    2=20
 drivers/iio/gyro/st_gyro.h                      |    1=20
 drivers/iio/gyro/st_gyro_core.c                 |    9=20
 drivers/iio/gyro/st_gyro_i2c.c                  |    1=20
 drivers/iio/gyro/st_gyro_spi.c                  |    1=20
 drivers/input/misc/arizona-haptics.c            |   11 -
 drivers/iommu/arm-smmu.c                        |  101 ++++++-----
 drivers/irqchip/irq-metag-ext.c                 |    2=20
 drivers/irqchip/irq-metag.c                     |    2=20
 drivers/irqchip/irq-orion.c                     |   22 ++
 drivers/md/dm-cache-target.c                    |    2=20
 drivers/md/dm-mpath.c                           |    7=20
 drivers/md/dm-thin-metadata.c                   |   17 +
 drivers/md/dm-thin-metadata.h                   |    2=20
 drivers/md/dm-thin.c                            |    8=20
 drivers/mfd/da9055-i2c.c                        |   12 +
 drivers/misc/mei/client.c                       |    4=20
 drivers/mtd/nand/omap2.c                        |   61 ++++--
 drivers/net/bonding/bond_3ad.c                  |    6=20
 drivers/net/bonding/bond_3ad.h                  |    1=20
 drivers/net/can/dev.c                           |   15 -
 drivers/net/can/janz-ican3.c                    |   18 -
 drivers/net/can/usb/kvaser_usb.c                |    2=20
 drivers/net/can/vcan.c                          |    9=20
 drivers/net/ethernet/broadcom/tg3.c             |    4=20
 drivers/net/ethernet/marvell/mvneta.c           |  217 ++++++++++++-------=
-----
 drivers/net/hyperv/netvsc_drv.c                 |   53 ++++-
 drivers/net/usb/asix_devices.c                  |    3=20
 drivers/net/usb/ax88179_178a.c                  |    4=20
 drivers/net/usb/gl620a.c                        |    4=20
 drivers/net/usb/mcs7830.c                       |    5=20
 drivers/net/usb/net1080.c                       |    4=20
 drivers/net/usb/qmi_wwan.c                      |    9=20
 drivers/net/usb/rndis_host.c                    |    4=20
 drivers/net/usb/smsc75xx.c                      |    4=20
 drivers/net/usb/smsc95xx.c                      |    4=20
 drivers/net/usb/usbnet.c                        |   25 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h  |   10 -
 drivers/net/wireless/rtlwifi/ps.c               |    2=20
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |   18 +
 drivers/pci/host/pci-mvebu.c                    |   11 -
 drivers/pci/pci.c                               |   10 +
 drivers/regulator/da9063-regulator.c            |    4=20
 drivers/scsi/qla2xxx/qla_target.c               |    3=20
 drivers/staging/android/binder.c                |    3=20
 drivers/staging/iio/adc/mxs-lradc.c             |    1=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c     |    1=20
 drivers/usb/chipidea/udc.c                      |    4=20
 drivers/usb/gadget/bcm63xx_udc.c                |   58 +++---
 drivers/usb/host/ehci-hcd.c                     |   13 +
 drivers/usb/host/ehci-hub.c                     |   26 ++
 drivers/usb/serial/ftdi_sio.c                   |    2=20
 drivers/usb/serial/ftdi_sio_ids.h               |    6=20
 drivers/usb/serial/option.c                     |    3=20
 drivers/vhost/net.c                             |   41 ++--
 fs/attr.c                                       |    5=20
 fs/btrfs/inode.c                                |    8=20
 fs/cifs/file.c                                  |   37 +++-
 fs/cifs/smb2glob.h                              |    3=20
 fs/cifs/smb2ops.c                               |   14 -
 fs/cifs/smb2pdu.c                               |    4=20
 fs/ext4/ext4.h                                  |    2=20
 fs/ext4/extents.c                               |    1=20
 fs/ext4/inode.c                                 |    4=20
 fs/ext4/ioctl.c                                 |    3=20
 fs/ext4/resize.c                                |   34 ++-
 fs/ext4/super.c                                 |   20 +-
 fs/fs-writeback.c                               |   33 +--
 fs/jbd2/transaction.c                           |    6=20
 fs/nfs/inode.c                                  |   14 +
 fs/nfs/internal.h                               |    9=20
 fs/nfs/nfs4state.c                              |    5=20
 fs/quota/dquot.c                                |   14 +
 fs/sync.c                                       |   15 -
 fs/xfs/xfs_super.c                              |    2=20
 include/linux/can/skb.h                         |   38 ++++
 include/linux/export.h                          |    1=20
 include/linux/ipc_namespace.h                   |    2=20
 include/linux/netdevice.h                       |    7=20
 include/linux/skbuff.h                          |   18 +
 include/linux/writeback.h                       |    2=20
 include/trace/events/writeback.h                |    6=20
 ipc/mq_sysctl.c                                 |   18 +
 ipc/mqueue.c                                    |    6=20
 kernel/cgroup.c                                 |   32 +--
 kernel/events/core.c                            |   12 -
 kernel/workqueue.c                              |    7=20
 mm/huge_memory.c                                |    9=20
 mm/memory.c                                     |   14 -
 net/9p/trans_virtio.c                           |    5=20
 net/batman-adv/bat_iv_ogm.c                     |   30 ++-
 net/batman-adv/hard-interface.c                 |   22 +-
 net/batman-adv/originator.c                     |   36 +++
 net/batman-adv/originator.h                     |    4=20
 net/batman-adv/routing.c                        |    4=20
 net/batman-adv/send.c                           |    9=20
 net/batman-adv/translation-table.c              |   23 +-
 net/bridge/br_device.c                          |   51 +++--
 net/can/af_can.c                                |    3=20
 net/can/bcm.c                                   |    4=20
 net/core/dev.c                                  |   22 +-
 net/core/fib_rules.c                            |    7=20
 net/core/netpoll.c                              |    4=20
 net/core/skbuff.c                               |   25 ++
 net/core/sock.c                                 |    6=20
 net/ieee802154/6lowpan.c                        |   20 ++
 net/ipv4/devinet.c                              |    3=20
 net/ipv4/ip_forward.c                           |   71 +++++++
 net/ipv4/route.c                                |    4=20
 net/ipv4/tcp_output.c                           |   13 +
 net/ipv6/addrconf.c                             |    2=20
 net/ipv6/ip6_output.c                           |   17 +
 net/sched/sch_tbf.c                             |   13 -
 net/sctp/socket.c                               |   41 +++-
 net/sunrpc/auth_gss/auth_gss.c                  |   13 +
 net/sunrpc/xprtsock.c                           |    6=20
 security/selinux/ss/policydb.c                  |    8=20
 sound/pci/hda/patch_ca0132.c                    |   68 -------
 sound/pci/hda/patch_realtek.c                   |    2=20
 sound/pci/hda/patch_sigmatel.c                  |   33 +++
 sound/soc/codecs/da732x.c                       |   12 +
 sound/soc/codecs/da9055.c                       |   11 -
 sound/soc/codecs/max98090.c                     |   20 +-
 sound/soc/codecs/rt5640.c                       |    1=20
 sound/soc/codecs/sta32x.c                       |   76 ++++----
 sound/soc/codecs/wm8770.c                       |    4=20
 sound/soc/codecs/wm8958-dsp2.c                  |    2=20
 sound/soc/fsl/imx-mc13783.c                     |    1=20
 sound/soc/fsl/imx-sgtl5000.c                    |   10 -
 sound/soc/fsl/imx-wm8962.c                      |   11 -
 sound/soc/txx9/txx9aclc-ac97.c                  |    8=20
 sound/usb/mixer_maps.c                          |    9=20
 tools/perf/builtin-trace.c                      |   22 ++
 199 files changed, 1791 insertions(+), 928 deletions(-)

Adam Thomson (1):
      ASoC: da9055: Fix device registration of PMIC and CODEC devices

Alan Stern (1):
      USB: EHCI: add delay during suspend to prevent erroneous wakeups

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alex Deucher (5):
      drm/radeon/ni: fix typo in dpm sq ramping setup
      drm/radeon: fix display tiling setup on SI
      drm/radeon: fix audio disable on dce6+
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1

Alexander Shiyan (1):
      ASoC: txx9aclc_ac97: Fix kernel crash on probe

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Andrew Lunn (2):
      PCI: mvebu: Use Device ID and revision from underlying endpoint
      irqchip: orion: Fix getting generic chip pointer.

Andy Adamson (1):
      NFS fix error return in nfs4_select_rw_stateid

Antonio Quartulli (9):
      batman-adv: fix soft-interface MTU computation
      batman-adv: fix TT-TVLV parsing on OGM reception
      batman-adv: release vlan object after checking the CRC
      batman-adv: properly check pskb_may_pull return value
      batman-adv: avoid potential race condition when adding a new neighbour
      batman-adv: fix TT CRC computation by ensuring byte order
      batman-adv: free skb on TVLV parsing success
      batman-adv: avoid double free when orig_node initialization fails
      batman-adv: fix potential kernel paging error for unicast transmissio=
ns

Arnaldo Carvalho de Melo (1):
      perf trace: Fix ioctl 'request' beautifier build problems on !(i386 |=
| x86_64) arches

Arve Hj=C3=B8nnev=C3=A5g (1):
      staging: binder: Fix death notifications

Ben Hutchings (1):
      perf trace: Add fallback definition of EFD_SEMAPHORE

Benjamin Herrenschmidt (2):
      powerpc/powernv: Fix opal_xscom_{read,write} prototype
      powerpc/powernv: Fix indirect XSCOM unmangling

Bjorn Helgaas (1):
      PCI: Enable INTx if BIOS left them disabled

Bj=C3=B8rn Mork (1):
      net: qmi_wwan: add Netgear Aircard 340U

Chao Bi (1):
      mei: set client's read_cb to NULL when flow control fails

Charles Keepax (1):
      Input - arizona-haptics: Fix double lock of dapm_mutex

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Christian K=C3=B6nig (2):
      drm/radeon: fix CP semaphores on CIK
      drm/radeon: fix missing bo reservation

Christoffer Dall (1):
      ARM: 7950/1: mm: Fix stage-2 device memory attributes

Christoph Hellwig (1):
      fs: fix iversion handling

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Cong Wang (1):
      bridge: fix netconsole setup over bridge

Dan Carpenter (1):
      jbd2: fix use after free in jbd2_journal_start_reserved()

Dan Williams (1):
      ioat: fix tasklet tear down

Daniel Borkmann (1):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Davidlohr Bueso (1):
      ipc,mqueue: remove limits for the amount of system-wide queues

Denis CIOCCA (1):
      iio:gyro: bug on L3GD20H gyroscope support

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dirk Brandewie (1):
      intel_pstate: Use LFM bus ratio as min ratio/P state

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Duan Jiong (1):
      ipv4: fix counter in_slow_tot

Dylan Reid (1):
      ASoC: max98090: sync regcache on entering STANDBY

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
      usbnet: remove generic hard_header_len check

Emil Velikov (1):
      drm/nouveau/fb: use correct ram oclass for nv1a hardware

Eric Dumazet (2):
      6lowpan: fix lockdep splats
      net: use __GFP_NORETRY for high order allocations

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Eric Whitney (1):
      ext4: fix xfstest generic/299 block validity failures

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Florian Westphal (3):
      net: add and use skb_gso_transport_seglen()
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Gavin Shan (1):
      powerpc/powernv: Rework EEH reset

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

Greg Kroah-Hartman (1):
      Linux 3.13.6

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Haiyang Zhang (1):
      hyperv: Fix the carrier status setting

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Hsin-Yu Chao (2):
      ALSA: hda/ca0132 - setup/cleanup streams
      ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hui Wang (2):
      ALSA: hda - add headset mic detect quirks for two Dell laptops
      ALSA: hda - Enable front audio jacks on one HP desktop model

Ilia Mirkin (2):
      drm/nouveau: set irq_enabled manually
      drm/nv50/disp: use correct register to determine DP display bpp

James Hogan (1):
      irq-metag*: stop set_affinity vectoring to offline cpus

Jan Kara (2):
      Revert "writeback: do not sync data dirtied after sync start"
      quota: Fix race between dqput() and dquot_scan_active()

Jani Nikula (2):
      drm/i915/dp: increase native aux defer retry timeout
      drm/i915/dp: add native aux defer retry limit

Jarkko Nikula (1):
      ASoC: rt5640: Add ACPI ID for Intel Baytrail

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jerome Glisse (1):
      drm/radeon: free uvd ring on unload

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Johannes Berg (1):
      export: declare ksymtab symbols

John Ogness (1):
      tcp: tsq: fix nonagle handling

Juergen Beisert (1):
      staging:iio:adc:MXS:LRADC: fix touchscreen statemachine

Kevin Hao (1):
      powerpc: Set the correct ksp_limit on ppc32 when switching to irq sta=
ck

Kirill A. Shutemov (1):
      mm, thp: fix infinite loop on memcg OOM

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (2):
      ASoC: sta32x: Fix cache sync
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Levente Kurusa (1):
      ahci: disable NCQ on Samsung pci-e SSDs on macbooks

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Maciej =C5=BBenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Manu Gupta (1):
      staging: r8188eu: Add new device ID

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Max Filippov (2):
      xtensa: save current register frame in fast_syscall_spill_registers_f=
ixup
      xtensa: introduce spill_registers_kernel macro

Michael S. Tsirkin (1):
      vhost: fix ref cnt checking deadlock

Mike Snitzer (3):
      dm cache: move hook_info into common portion of per_bio_data structure
      dm thin: avoid metadata commit if a pool's thin devices haven't chang=
ed
      dm thin: fix the error path for the thin device constructor

Nicolas Dichtel (1):
      gre: add link local route when local addr is any

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Oliver Hartkopp (1):
      can: add destructor for self generated skbs

Olivier Langlois (2):
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()
      rtlwifi: rtl8192ce: Fix too long disable of IRQs

Olivier Sobrie (1):
      can: kvaser_usb: check number of channels returned by HW

Olof Johansson (1):
      ARM64: unwind: Fix PC calculation

Paolo Bonzini (1):
      kvm, vmx: Really fix lazy FPU on nested guest

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Paul Mackerras (1):
      powerpc: Increase stack redzone for 64-bit userspace to 512 bytes

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Pekon Gupta (5):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND =
is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ON=
ENAND is built as module
      mtd: nand: omap: fix ecclayout to be in sync with u-boot NAND driver
      mtd: nand: omap: fix ecclayout->oobfree->offset
      mtd: nand: omap: fix ecclayout->oobfree->length

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Sebastian Capella (1):
      PM / hibernate: Fix restore hang in freeze_processes()

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

Shawn Guo (2):
      ARM: imx6: build pm-imx6q.c independently of CONFIG_PM
      ASoC: fsl: fix pm support of machine drivers

Simon Wunderlich (1):
      batman-adv: fix potential orig_node reference leak

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Stephen Warren (1):
      ARM: tegra: only run PL310 init on systems with one

Steve Twiss (1):
      regulator: da9063: Bug fix when setting max voltage on LDOs 5-11

Takashi Iwai (4):
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
      ASoC: sta32x: Fix array access overflow
      ALSA: hda - Add a fixup for HP Folio 13 mute LED

Tejun Heo (5):
      cgroup: fix error return value in cgroup_mount()
      cgroup: fix error return from cgroup_create()
      cgroup: fix locking in cgroup_cfts_commit()
      cgroup: update cgroup_enable_task_cg_lists() to grab siglock
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN

Theodore Ts'o (4):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with very large inode tables
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized

Tomasz Nowicki (1):
      ACPI / PCI: Fix memory leak in acpi_pci_irq_enable()

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correct=
ly

Trond Myklebust (3):
      NFS: Do not set NFS_INO_INVALID_LABEL unless server supports labeled =
NFS
      SUNRPC: Fix races in xs_nospace()
      SUNRPC: Ensure that gss_auth isn't freed before its upcall messages

Ville Syrj=C3=A4l=C3=A4 (2):
      drm/i915: Add intel_ring_cachline_align()
      drm/i915: Prevent MI_DISPLAY_FLIP straddling two cachelines on IVB

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (5):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling =
MMU
      ARM: 7955/1: spinlock: ensure we have a compiler barrier before sev
      iommu/arm-smmu: really fix page table locking
      iommu/arm-smmu: fix table flushing during initial allocations
      iommu/arm-smmu: set CBARn.BPSHCFG to NSH for s1-s2-bypass contexts

Yifan Zhang (1):
      iommu/arm-smmu: fix pud/pmd entry fill sequence

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()

willy tarreau (5):
      net: mvneta: increase the 64-bit rx/tx stats out of the hot path
      net: mvneta: use per_cpu stats to fix an SMP lock up
      net: mvneta: do not schedule in mvneta_tx_timeout
      net: mvneta: add missing bit descriptions for interrupt masks and cau=
ses
      net: mvneta: replace Tx timer with a real interrupt


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGXR2AAoJEDjbvchgkmk+FOoP/RawlAi/szUcVIxj7WHQcR/8
YOhOZJAOmkN/EOkKclXCxG296O/oV4Q032EW3VZu4ikAyD6rEvG4gRJnznvyWqH0
sbTX2cIDP3cra+oQJ3zNknF8CCC7K0z/qHPKbeoSL75tgFGIlLrjHDga+pPKKEBv
J58wJNUVs9eDoj8USiisNA8UzzU97avw5dWehiEe2H/AyTubY7RNPrk6YYV3VTVB
yy+y2+ghDDRi0FKFo+JVCiYbTo6gveISkDpb1k8TZwtpIZpTqgiJyllAJHbv/9T5
DoraWMJbf93Y/sGYXyspQv1vo7uLBU2ET2V7a6NN58huR14Q6ji9BOam6pNDfOaL
ALzmz96IAu+GRY46vcM+KN/BGoqFAj8ayd7qYmoZhz3o7iDVKMCAWfda9+FTMDMh
HflIyblDqE30PIg/fzyTzDflssKyHtdIUJkC3kI5xI/5xHWl29RjNhjWMqD8rLd0
8piftCPSD2KBV4Cm35Kf41Zwfjg/ANW/eNY36bujD0E6sRBLvzUf2LstplA3/T9H
OD//k9NyUUp8GJtZhW5CluTlmn0Q0pfnlVV8j72zen2Pay2B9mMH0QoKEYVlsm4v
akLXj8MPB8U1XE1Ws3J6xOcdqZaahu62RDfikOzZ1IjGZYwF4u2WzLz9jujUx5cM
hlaNEV0ZtsIsqttcO2Ou
=mCxy
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
