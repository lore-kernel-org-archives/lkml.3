Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3CTUOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:14:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57638 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3CTUO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:14:29 -0400
Date: Wed, 20 Mar 2013 13:15:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.4
Message-ID: <20130320201554.GA18281@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.4 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/tty/serial/of-serial.txt |    3=20
 Makefile                                                   |    2=20
 arch/arm/mach-at91/board-foxg20.c                          |    1=20
 arch/arm/mach-at91/board-stamp9g20.c                       |    1=20
 arch/arm/mach-davinci/dma.c                                |    3=20
 arch/arm/mach-ixp4xx/vulcan-setup.c                        |    1=20
 arch/arm/mach-kirkwood/board-dt.c                          |   24=20
 arch/arm/mach-pxa/raumfeld.c                               |    1=20
 arch/powerpc/include/asm/mmu-hash64.h                      |  128 ++---
 arch/powerpc/kernel/cputable.c                             |    2=20
 arch/powerpc/kernel/exceptions-64s.S                       |   34 -
 arch/powerpc/kvm/book3s_64_mmu_host.c                      |    4=20
 arch/powerpc/mm/hash_utils_64.c                            |   22=20
 arch/powerpc/mm/mmu_context_hash64.c                       |   11=20
 arch/powerpc/mm/pgtable_64.c                               |    2=20
 arch/powerpc/mm/slb_low.S                                  |   50 -
 arch/powerpc/mm/tlb_hash64.c                               |    2=20
 arch/s390/include/asm/tlbflush.h                           |    2=20
 arch/s390/kernel/entry.S                                   |    3=20
 arch/s390/kernel/entry64.S                                 |    5=20
 arch/x86/kernel/cpu/perf_event_intel_ds.c                  |   10=20
 arch/x86/power/cpu.c                                       |    2=20
 drivers/block/loop.c                                       |   24=20
 drivers/char/hw_random/virtio-rng.c                        |   13=20
 drivers/gpu/drm/i915/i915_dma.c                            |   23=20
 drivers/gpu/drm/i915/i915_drv.c                            |   13=20
 drivers/gpu/drm/i915/i915_drv.h                            |    1=20
 drivers/gpu/drm/i915/i915_irq.c                            |    4=20
 drivers/hwmon/lineage-pem.c                                |    2=20
 drivers/hwmon/pmbus/ltc2978.c                              |   14=20
 drivers/mtd/nand/nand_base.c                               |   16=20
 drivers/mtd/nand/nand_ids.c                                |   80 +--
 drivers/net/bonding/bond_main.c                            |    5=20
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c            |    2=20
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c             |   16=20
 drivers/net/macvlan.c                                      |    1=20
 drivers/net/team/team.c                                    |    2=20
 drivers/net/tun.c                                          |    2=20
 drivers/net/vxlan.c                                        |    9=20
 drivers/staging/comedi/drivers/dt9812.c                    |   16=20
 drivers/staging/vt6656/main_usb.c                          |    4=20
 drivers/tty/pty.c                                          |    1=20
 drivers/tty/serial/8250/8250.c                             |   52 ++
 drivers/tty/serial/8250/8250_pci.c                         |   21=20
 drivers/tty/serial/8250/8250_pnp.c                         |   12=20
 drivers/tty/serial/Kconfig                                 |    4=20
 drivers/tty/serial/of_serial.c                             |    6=20
 drivers/tty/tty_buffer.c                                   |    2=20
 drivers/usb/class/cdc-wdm.c                                |   23=20
 drivers/usb/dwc3/core.c                                    |    1=20
 drivers/usb/host/ehci-q.c                                  |   18=20
 drivers/usb/serial/cp210x.c                                |   20=20
 drivers/usb/serial/option.c                                |    5=20
 drivers/usb/serial/qcaux.c                                 |    1=20
 drivers/usb/serial/qcserial.c                              |    7=20
 drivers/usb/storage/initializers.c                         |   76 ---
 drivers/usb/storage/initializers.h                         |    4=20
 drivers/usb/storage/unusual_devs.h                         |  329 ++++++++=
++++-
 drivers/video/atmel_lcdfb.c                                |   22=20
 drivers/w1/masters/w1-gpio.c                               |    4=20
 drivers/w1/w1.c                                            |    3=20
 drivers/xen/xen-pciback/pciback_ops.c                      |    3=20
 fs/block_dev.c                                             |    4=20
 fs/btrfs/volumes.c                                         |    6=20
 fs/ext3/super.c                                            |    4=20
 include/linux/mtd/nand.h                                   |    7=20
 include/linux/perf_event.h                                 |    6=20
 include/uapi/linux/serial_core.h                           |    5=20
 include/video/atmel_lcdc.h                                 |    1=20
 kernel/signal.c                                            |    3=20
 net/bridge/br_mdb.c                                        |    4=20
 net/core/dev.c                                             |    1=20
 net/core/rtnetlink.c                                       |    1=20
 net/dcb/dcbnl.c                                            |    8=20
 net/ieee802154/6lowpan.h                                   |    2=20
 net/ipv4/tcp_input.c                                       |    6=20
 net/ipv6/ip6_input.c                                       |    3=20
 net/ipv6/route.c                                           |    3=20
 net/l2tp/l2tp_ppp.c                                        |    1=20
 net/netlabel/netlabel_unlabeled.c                          |   27 -
 net/rds/message.c                                          |    3=20
 net/sctp/socket.c                                          |    6=20
 scripts/Makefile.headersinst                               |   11=20
 security/selinux/xfrm.c                                    |    2=20
 sound/core/seq/seq_timer.c                                 |    8=20
 tools/usb/ffs-test.c                                       |    2=20
 86 files changed, 903 insertions(+), 395 deletions(-)

Alan Stern (1):
      USB: EHCI: don't check DMA values in QH overlays

Amir Vadai (2):
      net/mlx4_en: Initialize RFS filters lock and list in init_netdev
      net/mlx4_en: Disable RFS when running in SRIOV mode

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Aneesh Kumar K.V (3):
      powerpc: Make VSID_BITS* dependency explicit
      powerpc: Update kernel VSID range
      powerpc: Rename USER_ESID_BITS* to ESID_BITS*

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan=
]_attributes

Benjamin Herrenschmidt (2):
      powerpc: Fix STAB initialization
      powerpc: Fix cputable entry for 970MP rev 1.0

Bj=F8rn Mork (2):
      USB: option: add Huawei E5331
      USB: storage: fix Huawei mode switching regression

Brian Norris (1):
      mtd: nand: reintroduce NAND_NO_READRDY as NAND_NEED_READRDY

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Cong Wang (1):
      rds: limit the size allocated by rds_message_alloc()

Cristian Bercaru (1):
      bridging: fix rx_handlers return code

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

Dan Williams (2):
      qcaux: add Franklin U600
      qcserial: bind to DM/DIAG port on Gobi 1K devices

David Rientjes (1):
      perf,x86: fix link failure for non-Intel configs

Eric Dumazet (1):
      tun: add a missing nf_reset() in tun_net_xmit()

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Felipe Balbi (1):
      usb: dwc3: core: don't forget to free coherent memory

Greg Kroah-Hartman (3):
      Revert "drm/i915: enable irqs earlier when resuming"
      Revert "drm/i915: reorder setup sequence to have irqs for output setu=
p"
      Linux 3.8.4

Guenter Roeck (2):
      hwmon: (pmbus/ltc2978) Fix temperature reporting
      net/sctp: Validate parameter size for SCTP_GET_ASSOC_STATS

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds

Guo Chao (3):
      block: use i_size_write() in bd_set_size()
      loopdev: fix a deadlock
      loopdev: remove an user triggerable oops

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses

Heiko Carstens (1):
      s390/mm: fix flush_tlb_kernel_range()

Huang, Xiong (1):
      atl1c: restore buffer state

Ian Abbott (1):
      staging: comedi: dt9812: use CR_CHAN() for channel number

Jiri Slaby (2):
      TTY: disable debugging warning
      TTY: do not reset master's packet mode

Johan Hovold (3):
      ARM: w1-gpio: fix erroneous gpio requests
      w1-gpio: remove erroneous __exit and __exit_p()
      atmel_lcdfb: fix 16-bpp modes on older SOCs

Josh Boyer (1):
      serial: 8250: Keep 8250.<xxxx> module options functional after driver=
 rename

Kees Cook (1):
      signal: always clear sa_restorer on execve

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable a PCI device that is already disabled.

Lars-Peter Clausen (1):
      ext3: Fix format string issues

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Linus Torvalds (1):
      perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=3D2

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Martin Schwidefsky (1):
      s390: critical section cleanup vs. machine checks

Mathias Krause (3):
      bridge: fix mdb info leaks
      rtnl: fix info leak on RTM_GETLINK request for VF devices
      dcbnl: fix various netlink info leaks

Matt Porter (1):
      ARM: davinci: edma: fix dmaengine induced null pointer dereference on=
 da830

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Maxin B. John (1):
      tools: usb: ffs-test: Fix build failure

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Paul Bolle (2):
      tty: serial: fix typo "ARCH_S5P6450"
      tty: serial: fix typo "SERIAL_S3C2412"

Paul Moore (1):
      netlabel: correctly list all the static label mappings

Sam Ravnborg (1):
      kbuild: fix make headers_check with make 3.80

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Sean Young (1):
      tty/8250_pnp: serial port detection regression since v3.7

Sebastian Hesselbarth (1):
      ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels

Stephane Eranian (1):
      perf,x86: fix kernel crash with PEBS/BTS after suspend/resume

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

Takashi Iwai (1):
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Veaceslav Falico (1):
      bonding: fire NETDEV_RELEASE event only on 0 slaves

Vlad Yasevich (2):
      team: unsyc the devices addresses when port is removed
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology P=
CI 9835 Multi-I/O Controller

YOSHIFUJI Hideaki (1):
      6lowpan: Fix endianness issue in is_addr_link_local().

Zang MingJie (1):
      vxlan: fix oops when delete netns containing vxlan


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRShj6AAoJEDjbvchgkmk+ol8P/2+K2JB4rGh1Sw3yLeuOLEQO
8b+kP+a+I3ac0Il6pTndTBsACkp3a+47225oxa4s3cBqfQPSEc5k8Ybmx2cw5MpJ
Jue4v4ngGOqgXRP6XU2Z9Ceb9QzNNOVlFAzU4msXJh4EO8ylUnxNKGqtkwbav4Qm
S1ymUurOQWs/WgtVEia07EzMADQp0Myxu07K3Dt8MGAEJoj5m7yy8sRbS1gJT7DT
GyQsaEh4oIAYV0dlnf0f8eMPjXplTh1nLOGfVEA7VKsj6a7aSRjBtSvHRKnD+Cqp
Qqn4bYdxM6EOJSjNlIOFdabTIKMy7GUNV1ZSEpFk12W4N6/I1jXzDvzDa9C6/xFw
aC28RAt9xciOrzZjFUc29R30jYJfN/qfcRFfPeqLd4qeTOv15Vz9mv3KoiVf5i4q
JxJ5Nhcw6dCocPQc+7zDQK85UmEne4HpPMxBHr6OOv2UCz4fp8uCzqiP9yskRj+K
wAhas/o2+peY8PBVsN4kDuAtJ1yLK2CFiFuE6+1e2BrUIhvV1ozmFWl8wewSNgH8
sVBWWqPu5/XEHkOLHbbOGasK/Ll374GciqDM1N382ZNZHNlukWKQI3+bx1ltnXPm
WyqDwIE7RJ9aXri8IxcRUdpKpp7nNIvwSYBnRPigPLVXSYgmRYmcYCGxJHgoFzU8
n+g3ADcNz38etN+XbSf4
=Tz36
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
