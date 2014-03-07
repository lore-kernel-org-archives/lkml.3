Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaCGHYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:24:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCGHYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:24:39 -0500
Date: Thu, 6 Mar 2014 23:25:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.33
Message-ID: <20140307072509.GB29567@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.33 kernel.

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
 arch/arm/include/asm/cacheflush.h               |    1=20
 arch/arm/include/asm/spinlock.h                 |   82 ++++++++++++++-----=
-----
 arch/arm/mach-omap2/gpmc.c                      |    4 -
 arch/arm/mach-tegra/common.c                    |   11 +++
 arch/arm/mm/dma-mapping.c                       |    2=20
 arch/arm/mm/proc-v6.S                           |    3=20
 arch/arm/mm/proc-v7.S                           |    2=20
 arch/arm64/kernel/stacktrace.c                  |    6 +
 arch/avr32/Makefile                             |    2=20
 arch/avr32/boards/mimc200/fram.c                |    1=20
 arch/powerpc/kernel/crash_dump.c                |    8 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |   22 +++---
 arch/x86/kernel/cpu/perf_event.c                |    3=20
 arch/x86/kernel/pci-dma.c                       |    4 -
 arch/x86/kvm/x86.c                              |    2=20
 arch/xtensa/include/asm/traps.h                 |   44 ++++++++----
 arch/xtensa/kernel/entry.S                      |   60 ++++++++++++++---
 drivers/acpi/pci_irq.c                          |    1=20
 drivers/acpi/processor_throttling.c             |   69 +++++++++-----------
 drivers/acpi/video.c                            |    8 ++
 drivers/ata/ahci.c                              |   14 ++++
 drivers/ata/libata-pmp.c                        |    7 +-
 drivers/ata/sata_sil.c                          |    1=20
 drivers/cpufreq/powernow-k8.c                   |   10 ++
 drivers/dma/ioat/dma.c                          |   52 +++++++++++++--
 drivers/dma/ioat/dma.h                          |    1=20
 drivers/dma/ioat/dma_v2.c                       |   11 +--
 drivers/dma/ioat/dma_v3.c                       |    3=20
 drivers/dma/ste_dma40.c                         |    4 -
 drivers/edac/i7300_edac.c                       |   38 +++++------
 drivers/edac/i7core_edac.c                      |    9 ++
 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c |    2=20
 drivers/gpu/drm/nouveau/nouveau_drm.c           |    3=20
 drivers/gpu/drm/radeon/atombios_crtc.c          |   16 ++++
 drivers/gpu/drm/radeon/radeon_atpx_handler.c    |    3=20
 drivers/gpu/drm/radeon/radeon_kms.c             |    6 +
 drivers/hwmon/max1668.c                         |    2=20
 drivers/iio/gyro/Kconfig                        |    2=20
 drivers/iio/gyro/st_gyro.h                      |    1=20
 drivers/iio/gyro/st_gyro_core.c                 |    9 +-
 drivers/iio/gyro/st_gyro_i2c.c                  |    1=20
 drivers/iio/gyro/st_gyro_spi.c                  |    1=20
 drivers/input/misc/arizona-haptics.c            |   11 +--
 drivers/irqchip/irq-metag-ext.c                 |    2=20
 drivers/irqchip/irq-metag.c                     |    2=20
 drivers/md/dm-mpath.c                           |    7 +-
 drivers/md/dm-thin-metadata.c                   |   17 ++++
 drivers/md/dm-thin-metadata.h                   |    2=20
 drivers/md/dm-thin.c                            |    8 +-
 drivers/misc/mei/client.c                       |    4 -
 drivers/net/bonding/bond_3ad.c                  |    6 -
 drivers/net/bonding/bond_3ad.h                  |    1=20
 drivers/net/can/dev.c                           |   15 ----
 drivers/net/can/janz-ican3.c                    |   18 +----
 drivers/net/can/usb/kvaser_usb.c                |    2=20
 drivers/net/can/vcan.c                          |    9 +-
 drivers/net/ethernet/broadcom/tg3.c             |    4 -
 drivers/net/usb/asix_devices.c                  |    3=20
 drivers/net/usb/ax88179_178a.c                  |    4 +
 drivers/net/usb/gl620a.c                        |    4 +
 drivers/net/usb/mcs7830.c                       |    5 -
 drivers/net/usb/net1080.c                       |    4 +
 drivers/net/usb/qmi_wwan.c                      |    9 +-
 drivers/net/usb/rndis_host.c                    |    4 +
 drivers/net/usb/smsc75xx.c                      |    4 +
 drivers/net/usb/smsc95xx.c                      |    4 +
 drivers/net/usb/usbnet.c                        |   25 ++-----
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h  |   10 ++
 drivers/net/wireless/rtlwifi/ps.c               |    2=20
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c     |   18 ++++-
 drivers/pci/pci.c                               |   10 ++
 drivers/scsi/qla2xxx/qla_target.c               |    3=20
 drivers/staging/android/binder.c                |    3=20
 drivers/usb/chipidea/udc.c                      |    4 -
 drivers/usb/gadget/bcm63xx_udc.c                |   58 +++++++++-------
 drivers/usb/host/ehci-hcd.c                     |   13 ++-
 drivers/usb/serial/ftdi_sio.c                   |    2=20
 drivers/usb/serial/ftdi_sio_ids.h               |    6 +
 drivers/usb/serial/option.c                     |    3=20
 fs/attr.c                                       |    5 -
 fs/btrfs/inode.c                                |    8 +-
 fs/cifs/file.c                                  |   37 +++++++++-
 fs/cifs/smb2glob.h                              |    3=20
 fs/cifs/smb2ops.c                               |   14 +---
 fs/cifs/smb2pdu.c                               |    3=20
 fs/ext4/ext4.h                                  |    2=20
 fs/ext4/inode.c                                 |    4 +
 fs/ext4/ioctl.c                                 |    3=20
 fs/ext4/resize.c                                |   34 ++++++---
 fs/ext4/super.c                                 |   20 +++--
 fs/quota/dquot.c                                |   14 +++-
 include/linux/can/skb.h                         |   38 +++++++++++
 include/linux/ipc_namespace.h                   |    2=20
 include/linux/netdevice.h                       |    7 +-
 include/linux/skbuff.h                          |   19 +++++
 ipc/mq_sysctl.c                                 |   18 +++--
 ipc/mqueue.c                                    |    6 -
 kernel/events/core.c                            |   12 +--
 kernel/workqueue.c                              |    7 ++
 mm/memcontrol.c                                 |    4 -
 net/9p/trans_virtio.c                           |    5 +
 net/can/af_can.c                                |    3=20
 net/can/bcm.c                                   |    4 -
 net/core/dev.c                                  |   27 ++++---
 net/core/fib_rules.c                            |    7 ++
 net/core/netpoll.c                              |    4 -
 net/core/skbuff.c                               |   25 +++++++
 net/core/sock.c                                 |    2=20
 net/ieee802154/6lowpan.c                        |   20 +++++
 net/ipv4/devinet.c                              |    3=20
 net/ipv4/ip_forward.c                           |   71 ++++++++++++++++++++
 net/ipv4/route.c                                |    4 -
 net/ipv4/tcp_output.c                           |   13 +++
 net/ipv6/ip6_output.c                           |   17 ++++
 net/sctp/socket.c                               |   41 +++++++++---
 net/sunrpc/xprtsock.c                           |    6 +
 security/selinux/ss/policydb.c                  |    8 +-
 sound/pci/hda/patch_ca0132.c                    |   68 ++-----------------
 sound/pci/hda/patch_sigmatel.c                  |   33 +++++++++
 sound/soc/codecs/da732x.c                       |   12 +++
 sound/soc/codecs/max98090.c                     |   20 ++---
 sound/soc/codecs/sta32x.c                       |   76 +++++++++++--------=
---
 sound/soc/codecs/wm8770.c                       |    4 -
 sound/soc/codecs/wm8958-dsp2.c                  |    2=20
 sound/usb/mixer_maps.c                          |    9 ++
 126 files changed, 1078 insertions(+), 505 deletions(-)

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alex Deucher (2):
      drm/radeon: print the supported atpx function mask
      drm/radeon: disable pll sharing for DP on DCE4.1

Andrew Honig (1):
      kvm: x86: fix emulator buffer overflow (CVE-2014-0049)

Arve Hj=C3=B8nnev=C3=A5g (1):
      staging: binder: Fix death notifications

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

Christian K=C3=B6nig (1):
      drm/radeon: fix missing bo reservation

Christoph Hellwig (1):
      fs: fix iversion handling

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

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

Dr. Greg Wettstein (1):
      qla2xxx: Fix kernel panic on selective retransmission request

Duan Jiong (1):
      ipv4: fix counter in_slow_tot

Dylan Reid (1):
      ASoC: max98090: sync regcache on entering STANDBY

Emil Goode (2):
      net: asix: add missing flag to struct driver_info
      usbnet: remove generic hard_header_len check

Eric Dumazet (2):
      6lowpan: fix lockdep splats
      net: use __GFP_NORETRY for high order allocations

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Florian Fainelli (1):
      usb: gadget: bcm63xx_udc: fix build failure on DMA channel code

Florian Westphal (3):
      net: add and use skb_gso_transport_seglen()
      net: core: introduce netif_skb_dev_features
      net: ip, ipv6: handle gso skbs in forwarding path

Geert Uytterhoeven (1):
      ipv4: Fix runtime WARNING in rtmsg_ifa()

Greg Kroah-Hartman (1):
      Linux 3.10.33

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Hsin-Yu Chao (2):
      ALSA: hda/ca0132 - setup/cleanup streams
      ALSA: hda/ca0132 - Fix recording from mode id 0x8

Hui Wang (1):
      ALSA: hda - Enable front audio jacks on one HP desktop model

Ilia Mirkin (2):
      drm/nouveau: set irq_enabled manually
      drm/nv50/disp: use correct register to determine DP display bpp

James Hogan (1):
      irq-metag*: stop set_affinity vectoring to offline cpus

Jan Kara (1):
      quota: Fix race between dqput() and dquot_scan_active()

Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

Jeff Layton (1):
      cifs: ensure that uncached writes handle unmapped areas correctly

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

John Ogness (1):
      tcp: tsq: fix nonagle handling

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

Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

Mark Brown (1):
      ASoC: da732x: Mark DC offset control registers volatile

Matthieu CASTET (1):
      usb: chipidea: need to mask when writting endptflush and endptprime

Max Filippov (1):
      xtensa: introduce spill_registers_kernel macro

Michal Hocko (1):
      memcg: fix endless loop caused by mem_cgroup_iter

Mike Snitzer (2):
      dm thin: avoid metadata commit if a pool's thin devices haven't chang=
ed
      dm thin: fix the error path for the thin device constructor

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

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Pavel Shilovsky (1):
      CIFS: Fix too big maxBuf size for SMB3 mounts

Pekon Gupta (2):
      ARM: OMAP2+: gpmc: fix: DT NAND child nodes not probed when MTD_NAND =
is built as module
      ARM: OMAP2+: gpmc: fix: DT ONENAND child nodes not probed when MTD_ON=
ENAND is built as module

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Richard Yao (1):
      9p/trans_virtio.c: Fix broken zero-copy on vmalloc() buffers

Sabrina Dubroca (1):
      netpoll: fix netconsole IPv6 setup

Srivatsa S. Bhat (1):
      cpufreq: powernow-k8: Initialize per-cpu data-structures properly

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      usb: ehci: fix deadlock when threadirqs option is used

Stephen Warren (1):
      ARM: tegra: only run PL310 init on systems with one

Takashi Iwai (4):
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
      ASoC: sta32x: Fix array access overflow
      ALSA: hda - Add a fixup for HP Folio 13 mute LED

Tejun Heo (1):
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

Trond Myklebust (1):
      SUNRPC: Fix races in xs_nospace()

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Will Deacon (3):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling =
MMU
      ARM: 7749/1: spinlock: retry trylock operation if strex fails on free=
 lock
      ARM: 7812/1: rwlocks: retry trylock operation if strex fails on free =
lock

Zheng Liu (1):
      ext4: fix error paths in swap_inode_boot_loader()


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGXRVAAoJEDjbvchgkmk+KjwP/30crry7C5S7DmbPkUk6k/rh
sMjUGEoYwBEaetSzDpTokZQDEkA01eAH1RqxHNROwP9JiE8DU4+xcNmwsJjrCK8Z
Fobwf4yW/k3etvFN+XRNlawIne5vEgPiz5G6g/y3sqSVitYGWfJazrlqXq8PSrct
/2CHzk44or8W+sltmvEj2rqMsY+Lopztj1Yy7tEw34tgVWijDExVOqa3t2iIH9Xw
syzI9ze+Rtq3QTdyimw9/uIQF2GSXQUGygnaGTyHctoq53s/+LJ7XZVCeD4FbIkc
HPcTqHkTAIVriMql1OeGusdH5pXHqhBDY0/nsarO3f+HTpDYrB/HbIbtRxb9N7WV
3q/kJ1t+i90jNZGJIZzjZX9h7yBM3YPorO+7XZoDFepnsVGJne6YF4T8qa49vz+L
ME1HKpxYNUCmy/Ady5n1XXgsPXY7jmo5rX4UoXFIjkA9/Xqy/yGZNpILB6Rgg/7l
tgDzLn5OsqYjDzMlgrGHQZpvVbGZtIIDrc7oUX3nI19gmi8ZeUwmMpYYbMKjusBL
dK1xH99AiNIRNwyql7Vh/78leNOfffVQ+nm8yQPPBcPpqfkpzq9QbQv3NNsGvW1S
P13Vur9FVOxqF5HJv3+5gpzyzhhgiMVovEij4xvbvg+qHMMZXtka/wAFZxs7bgzB
tE+sXBLS7fa7rBl/YkG1
=8J/I
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
