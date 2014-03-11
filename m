Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaCKXct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:32:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaCKXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:32:46 -0400
Date: Tue, 11 Mar 2014 16:33:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.83
Message-ID: <20140311233332.GA12971@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.83 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/include/asm/cacheflush.h                 |    1=20
 arch/arm/mm/proc-v6.S                             |    3=20
 arch/arm/mm/proc-v7.S                             |    2=20
 arch/avr32/Makefile                               |    2=20
 arch/avr32/boards/mimc200/fram.c                  |    1=20
 arch/powerpc/kernel/crash_dump.c                  |    8=20
 arch/powerpc/kvm/emulate.c                        |    2=20
 arch/s390/kvm/kvm-s390.c                          |   14 -
 arch/x86/kernel/cpu/perf_event.c                  |    3=20
 arch/x86/xen/enlighten.c                          |    4=20
 arch/x86/xen/smp.c                                |    2=20
 block/blk-exec.c                                  |   12=20
 drivers/acpi/processor_throttling.c               |   69 ++---
 drivers/acpi/video.c                              |    8=20
 drivers/ata/libata-pmp.c                          |    7=20
 drivers/ata/sata_sil.c                            |    1=20
 drivers/block/nbd.c                               |    8=20
 drivers/block/xen-blkback/blkback.c               |   13=20
 drivers/block/xen-blkback/common.h                |    2=20
 drivers/block/xen-blkback/xenbus.c                |    2=20
 drivers/connector/cn_proc.c                       |    8=20
 drivers/dma/ste_dma40.c                           |    4=20
 drivers/edac/i7core_edac.c                        |    9=20
 drivers/hwmon/max1668.c                           |    2=20
 drivers/md/dm-mpath.c                             |    7=20
 drivers/media/video/saa7134/saa7134-alsa.c        |    2=20
 drivers/net/bonding/bond_3ad.c                    |    6=20
 drivers/net/bonding/bond_3ad.h                    |    1=20
 drivers/net/ethernet/broadcom/tg3.c               |    4=20
 drivers/net/usb/asix.c                            |  128 +++++++--
 drivers/net/usb/gl620a.c                          |    4=20
 drivers/net/usb/mcs7830.c                         |    5=20
 drivers/net/usb/net1080.c                         |    4=20
 drivers/net/usb/qmi_wwan.c                        |    8=20
 drivers/net/usb/rndis_host.c                      |    4=20
 drivers/net/usb/smsc75xx.c                        |    4=20
 drivers/net/usb/smsc95xx.c                        |    4=20
 drivers/net/usb/usbnet.c                          |   25 -
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    6=20
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2=20
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |    1=20
 drivers/net/wireless/iwlwifi/iwl-core.c           |    5=20
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    3=20
 drivers/net/wireless/iwlwifi/iwl-pci.c            |   10=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   11=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   37 ++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   65 ++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   27 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h    |   10=20
 drivers/net/wireless/rtlwifi/base.c               |   89 +++---
 drivers/net/wireless/rtlwifi/ps.c                 |    2=20
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |   18 +
 drivers/net/wireless/rtlwifi/wifi.h               |    6=20
 drivers/net/xen-netback/netback.c                 |  289 +++++++++++++++++=
-----
 drivers/staging/line6/pcm.c                       |    5=20
 drivers/usb/serial/ftdi_sio.c                     |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                 |    6=20
 drivers/usb/serial/option.c                       |    3=20
 drivers/xen/events.c                              |   11=20
 fs/cifs/file.c                                    |   37 ++
 fs/cifs/readdir.c                                 |    8=20
 fs/cifs/transport.c                               |    7=20
 fs/ext4/ext4.h                                    |    2=20
 fs/ext4/extents.c                                 |   25 +
 fs/ext4/fsync.c                                   |    3=20
 fs/ext4/indirect.c                                |    9=20
 fs/ext4/inode.c                                   |   14 -
 fs/ext4/mmp.c                                     |    2=20
 fs/ext4/page-io.c                                 |    9=20
 fs/ext4/resize.c                                  |   10=20
 fs/ext4/super.c                                   |   20 -
 fs/ext4/xattr.c                                   |    3=20
 fs/fuse/dir.c                                     |    9=20
 fs/fuse/file.c                                    |    8=20
 fs/fuse/fuse_i.h                                  |    9=20
 fs/fuse/inode.c                                   |    4=20
 fs/jbd2/journal.c                                 |   31 ++
 fs/ncpfs/dir.c                                    |    9=20
 fs/nilfs2/page.c                                  |    2=20
 fs/nilfs2/segment.c                               |   11=20
 fs/quota/dquot.c                                  |   14 -
 fs/ubifs/orphan.c                                 |    5=20
 fs/ubifs/ubifs.h                                  |    2=20
 include/linux/cgroup.h                            |   53 +++-
 include/linux/jbd2.h                              |    1=20
 include/linux/nbd.h                               |    1=20
 include/linux/skbuff.h                            |   19 +
 include/xen/interface/io/netif.h                  |   18 +
 include/xen/interface/io/ring.h                   |    5=20
 kernel/cgroup.c                                   |   50 +--
 kernel/cgroup_freezer.c                           |   13=20
 kernel/events/core.c                              |   12=20
 kernel/fork.c                                     |    9=20
 kernel/workqueue.c                                |    7=20
 mm/memory_hotplug.c                               |   15 -
 mm/vmscan.c                                       |   27 +-
 net/ceph/osd_client.c                             |    2=20
 net/core/fib_rules.c                              |    7=20
 net/core/skbuff.c                                 |   25 +
 net/ipv4/ip_forward.c                             |   68 +++++
 net/ipv6/ip6_output.c                             |   13=20
 net/sctp/socket.c                                 |   41 ++-
 net/sunrpc/sched.c                                |   13=20
 net/sunrpc/xprtsock.c                             |    6=20
 security/selinux/ss/policydb.c                    |    8=20
 sound/arm/pxa2xx-pcm-lib.c                        |    2=20
 sound/pci/asihpi/asihpi.c                         |    3=20
 sound/pci/atiixp.c                                |    2=20
 sound/pci/atiixp_modem.c                          |    2=20
 sound/soc/codecs/sgtl5000.c                       |    2=20
 sound/soc/codecs/sta32x.c                         |   74 ++---
 sound/soc/codecs/wm8770.c                         |    4=20
 sound/soc/codecs/wm8958-dsp2.c                    |    2=20
 sound/soc/imx/imx-ssi.c                           |    5=20
 sound/soc/s6000/s6000-pcm.c                       |    2=20
 sound/usb/6fire/pcm.c                             |   12=20
 sound/usb/misc/ua101.c                            |   14 -
 sound/usb/mixer_maps.c                            |    9=20
 sound/usb/usx2y/usbusx2yaudio.c                   |    4=20
 tools/perf/util/parse-events.c                    |    2=20
 virt/kvm/iommu.c                                  |    4=20
 122 files changed, 1341 insertions(+), 471 deletions(-)

Adam Thomas (1):
      UBIFS: fix double free of ubifs_orphan objects

Aleksander Morgado (1):
      USB: serial: option: blacklist interface 4 for Cinterion PHS8 and PXS8

Alexander Graf (1):
      KVM: PPC: Emulate dcbf

Arnaldo Carvalho de Melo (1):
      perf tools: Remove extraneous newline when parsing hardware cache eve=
nts

Chen Gang (1):
      avr32: Makefile: add '-D__linux__' flag for gcc-4.4.7 use

Christian Borntraeger (1):
      s390/kvm: dont announce RRBM support

Clemens Ladisch (1):
      ALSA: usb-audio: work around KEF X300A firmware bug

Daniel Borkmann (1):
      net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode

Dave Chiluk (1):
      ncpfs: fix rmdir returns Device or resource busy

David Vrabel (1):
      xen/events: mask events when changing their VCPU binding

Denis V. Lunev (1):
      ata: enable quirk from jmicron JMB350 for JMB394

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Emil Goode (2):
      usbnet: remove generic hard_header_len check
      net: asix: add missing flag to struct driver_info

Emmanuel Grumbach (2):
      iwlwifi: don't handle masked interrupt
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series

Eric Paris (1):
      SELinux: bigendian problems with filename trans rules

Fabio Estevam (1):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL

Florian Westphal (2):
      net: add and use skb_gso_transport_seglen()
      net: ip, ipv6: handle gso skbs in forwarding path

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Greg Kroah-Hartman (1):
      Linux 3.4.83

Guenter Roeck (1):
      hwmon: (max1668) Fix writing the minimum temperature

Hannes Reinecke (1):
      dm mpath: fix stalls when handling invalid ioctls

Hans de Goede (1):
      ACPI / video: Filter the _BCL table for duplicate brightness values

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many request=
s on the ring

Jan Kara (2):
      quota: Fix race between dqput() and dquot_scan_active()
      ext4: fix possible use-after-free with AIO

Jean Delvare (1):
      i7core_edac: Fix PCI device reference count

Jeff Layton (4):
      cifs: ensure that uncached writes handle unmapped areas correctly
      cifs: don't instantiate new dentries in readdir for inodes that need =
to be revalidated immediately
      cifs: adjust sequence number downward after signing NT_CANCEL request
      sunrpc: clarify comments on rpc_make_runnable

Jiang Liu (1):
      mm/hotplug: correctly add new zone to all other nodes' zone lists

Jiri Bohac (1):
      bonding: 802.3ad: make aggregator_identifier bond-private

Jiri Olsa (1):
      perf tools: Fix cache event name generation

Joerg Dorchain (1):
      USB: ftdi_sio: add Cressi Leonardo PID

Johannes Berg (5):
      iwlwifi: fix flow handler debug code
      iwlwifi: protect SRAM debugfs
      iwlwifi: handle DMA mapping failures
      iwlwifi: always copy first 16 bytes of commands
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing

Kees Cook (1):
      proc connector: reject unprivileged listener bumps

Konrad Rzeszutek Wilk (4):
      xen/boot: Disable BIOS SMP MP table search.
      xen/smp: Fix leakage of timer interrupt line for every CPU online/off=
line.
      xen/smp/spinlock: Fix leakage of the spinlock interrupt line for ever=
y CPU online/offline
      xen/blkback: Check for insane amounts of request on the ring (v6).

Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Lan Tianyu (1):
      ACPI / processor: Rework processor throttling with work_on_cpu()

Lars-Peter Clausen (1):
      ASoC: wm8958-dsp: Fix firmware block loading

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Lucas Stach (1):
      net: asix: handle packets crossing URB boundaries

Maciej =C5=BBenczykowski (1):
      net: fix 'ip rule' iif/oif device rename

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Maxim Patlasov (1):
      fuse: hotfix truncate_pagecache() issue

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

Nithin Sujir (1):
      tg3: Fix deadlock in tg3_change_mtu()

Olivier Langlois (2):
      rtlwifi: Fix incorrect return from rtl_ps_enable_nic()
      rtlwifi: rtl8192ce: Fix too long disable of IRQs

Paul Clements (1):
      nbd: correct disconnect behavior

Paul Gortmaker (1):
      avr32: fix missing module.h causing build failure in mimc200/fram.c

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat

Roland Dreier (1):
      block: Don't access request after it might be freed

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Stanislaw Gruszka (2):
      rtl8187: fix regression on MIPS without coherent DMA
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

Takashi Iwai (12):
      ASoC: wm8770: Fix wrong number of enum items
      ASoC: sta32x: Fix wrong enum for limiter2 release rate
      ASoC: sta32x: Fix array access overflow
      saa7134: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call

Tejun Heo (3):
      sata_sil: apply MOD15WRITE quirk to TOSHIBA MK2561GSYN
      cgroup: cgroup_subsys->fork() should be called after the task is adde=
d to css_set
      cgroup: fix RCU accesses to task->cgroups

Theodore Ts'o (5):
      ext4: don't try to modify s_flags if the the file system is read-only
      ext4: fix online resize with a non-standard blocks per group setting
      ext4: don't leave i_crtime.tv_sec uninitialized
      ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
      ext4: return ENOMEM if sb_getblk() fails

Trond Myklebust (2):
      SUNRPC: Fix races in xs_nospace()
      SUNRPC: Prevent an rpc_task wakeup race

Vinayak Kale (1):
      ARM: 7957/1: add DSB after icache flush in __flush_icache_all()

Vyacheslav Dubeyko (1):
      nilfs2: fix issue with race condition of competition between segments=
 for dirty blocks

Wei Liu (2):
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet

Will Deacon (1):
      ARM: 7953/1: mm: ensure TLB invalidation is complete before enabling =
MMU

majianpeng (1):
      libceph: unregister request in __map_request failed and nofail =3D=3D=
 false

stephen hemminger (1):
      xen-netback: fix sparse warning


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH51MAAoJEDjbvchgkmk+/hoP/1C6ebUkjVIZ1WyFBWcNP5Ei
hhmPXVcMvVSAEY5WRwM+8OMMfBuJRR/C/O58gQ4zX4a0Tq+L57zpOb0MatmY6HUW
K/mG4lRfqZwCST+LCadDtPrOBO52/Cud5hGKWC7Sr36sGjWl8IuUt7aXI+1RKHHE
ipQGsBgZrm/qWgHh6p+rDL27OD6DoPIzppjPplhzQZB1n8zhyIo5tOwqHAtHF0RM
lhOANziHUGDg5lWIpiVIx0RTp+QR1Z/u1yBdXtzz735UrjSxGBaetGEI+E9DvNIq
wyYB7xuK1vc2B+obGQerIDAeNTOWZV+YzAue4wFKSneYidoOERaga7k9xA4C3hyp
IKnkOR9M07kLgN60ooPVgTdQ89ZQpN96WNqX5Kyug5YCPABoCypFxOuDFNM2x/Aj
KWw8LhkKXbQkQhVDgXloFFWXWYq/cF85y8gJaVxStndz7XoRwb4xct7ZscfeDUqO
6zj0zNNkXfM5r8dSKqdbQBuTvpDmMqxEYWldy16sut/t6ocqNQ4Erhl9GF+XyxX9
XJflxh34ZOas73/T8LwkY+aPIUjGqp1B9veZk7ka17gRgf2lmyK4Ko1gyVPOF0KA
HszdTlxrxnn8D9ry7zEthUFX7j+5EGQUc/jHZn4IK233cIVn1pbDDrp+TQFSAMj5
2XsV8LQuaKvtozmdYIlG
=TH5F
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
