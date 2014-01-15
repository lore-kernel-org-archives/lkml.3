Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaAOXmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:42:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44979 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAOXmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:42:36 -0500
Date: Wed, 15 Jan 2014 15:43:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.27
Message-ID: <20140115234315.GA23280@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.27 kernel.

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

 Documentation/networking/packet_mmap.txt          |   10 +
 Makefile                                          |    2=20
 arch/arm/boot/dts/exynos5250.dtsi                 |    2=20
 arch/arm/kernel/traps.c                           |    8 +
 arch/arm/mach-footbridge/dc21285-timer.c          |    5=20
 arch/arm/mach-shmobile/board-armadillo800eva.c    |    4=20
 arch/arm/mach-shmobile/board-kzm9g.c              |    2=20
 arch/arm/mach-shmobile/board-mackerel.c           |    4=20
 arch/parisc/include/asm/cacheflush.h              |   12 --
 arch/parisc/include/asm/page.h                    |    5=20
 arch/parisc/kernel/cache.c                        |   35 ------
 arch/x86/include/asm/fpu-internal.h               |   13 +-
 drivers/acpi/battery.c                            |   21 +++
 drivers/ata/ahci.c                                |    3=20
 drivers/char/tpm/tpm_ppi.c                        |   15 +-
 drivers/clk/clk-divider.c                         |    2=20
 drivers/clk/samsung/clk-exynos4.c                 |    2=20
 drivers/clk/samsung/clk-exynos5250.c              |    7 -
 drivers/clocksource/em_sti.c                      |    2=20
 drivers/cpufreq/intel_pstate.c                    |    3=20
 drivers/gpio/gpio-rcar.c                          |    2=20
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |    6 -
 drivers/hid/hid-logitech-dj.c                     |   45 ++++++++
 drivers/hid/hid-logitech-dj.h                     |    1=20
 drivers/irqchip/irq-renesas-irqc.c                |    4=20
 drivers/mfd/rtsx_pcr.c                            |   10 +
 drivers/net/ethernet/broadcom/tg3.c               |    3=20
 drivers/net/ethernet/freescale/fec_main.c         |    4=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |    2=20
 drivers/net/ethernet/tehuti/tehuti.c              |    1=20
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2=20
 drivers/net/hamradio/hdlcdrv.c                    |    2=20
 drivers/net/hamradio/yam.c                        |    1=20
 drivers/net/hyperv/netvsc_drv.c                   |    1=20
 drivers/net/macvtap.c                             |   20 +--
 drivers/net/tun.c                                 |    2=20
 drivers/net/virtio_net.c                          |  119 +++++++++++++++--=
-----
 drivers/scsi/sd.c                                 |    5=20
 include/linux/net.h                               |    2=20
 include/linux/netdevice.h                         |    9 +
 include/linux/skbuff.h                            |    5=20
 kernel/sched/core.c                               |    9 +
 kernel/sched/fair.c                               |   48 ++++++--
 kernel/sched/sched.h                              |    3=20
 net/8021q/vlan_dev.c                              |   19 +++
 net/bridge/br_multicast.c                         |    4=20
 net/core/drop_monitor.c                           |    1=20
 net/core/neighbour.c                              |    2=20
 net/core/netpoll.c                                |   11 +-
 net/core/skbuff.c                                 |    3=20
 net/core/sock.c                                   |    2=20
 net/ipv4/inet_diag.c                              |   16 ++
 net/ipv4/ip_gre.c                                 |    1=20
 net/ipv6/route.c                                  |   34 ++----
 net/ipv6/udp_offload.c                            |    2=20
 net/llc/af_llc.c                                  |    5=20
 net/mac80211/tx.c                                 |   23 ++--
 net/netfilter/nf_nat_irc.c                        |   32 ++++-
 net/packet/af_packet.c                            |   65 +++++++-----
 net/rds/ib.c                                      |    3=20
 net/rds/ib_send.c                                 |    5=20
 net/rose/af_rose.c                                |   16 --
 net/unix/af_unix.c                                |   16 ++
 64 files changed, 478 insertions(+), 247 deletions(-)

Abhilash Kesavan (2):
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg c=
lock

Andrew Bresticker (1):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

Andrey Vagin (1):
      virtio: delete napi structures from netdev before releasing memory

Axel Lin (1):
      irqchip: renesas-irqc: Fix irqc_probe error handling

Ben Segall (3):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel()/rq->lock deadlock

Bernd Schubert (1):
      SCSI: sd: Reduce buffer size for vpd request

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Daniel Borkmann (4):
      packet: fix send path when running with proto =3D=3D 0
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg
      netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT help=
er

David S. Miller (2):
      vlan: Fix header ops passthru when doing TX VLAN offload.
      netpoll: Fix missing TXQ unlock and and OOPS.

Dirk Brandewie (1):
      intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.

Eric Dumazet (2):
      net: do not pretend FRAGLIST support
      net: fec: fix potential use after free

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Greg Kroah-Hartman (1):
      Linux 3.10.27

Hannes Frederic Sowa (2):
      ipv6: don't count addrconf generated routes against gc limit
      ipv6: fix illegal mac_header comparison on 32bit

Ilia Mirkin (1):
      drm/nouveau/bios: make jump conditional

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Jason Wang (3):
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu
      virtio-net: fix refill races during restore

Jiang Liu (1):
      ACPI / TPM: fix memory leak when walking ACPI namespace

John David Anglin (1):
      parisc: Ensure full cache coherency for kmap/kunmap

Kamala R (1):
      IPv6: Fixed support for blackhole and prohibit routes

Kuninori Morimoto (1):
      gpio-rcar: R-Car GPIO IRQ share interrupt

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Laurent Pinchart (3):
      ARM: shmobile: kzm9g: Fix coherent DMA mask
      ARM: shmobile: armadillo: Fix coherent DMA mask
      ARM: shmobile: mackerel: Fix coherent DMA mask

Li RongQing (1):
      ipv6: always set the new created dst's from in ip6_rt_copy

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Magnus Damm (1):
      clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

Michael S. Tsirkin (3):
      virtio_net: fix error handling for mergeable buffers
      virtio-net: make all RX paths handle errors consistently
      virtio_net: don't leak memory or block when too many frags

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Nestor Lopez Casado (1):
      HID: Revert "Revert "HID: Fix logitech-dj: missing Unifying device is=
sue""

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Russell King (2):
      ARM: fix footbridge clockevent device
      ARM: fix "bad mode in ... handler" message for undefined instructions

Salva Peir=F3 (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow set_peek_off to fail
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Seung-Woo Kim (1):
      clk: samsung: exynos4: Correct SRC_MFC register

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

Simon Horman (1):
      net: Loosen constraints for recalculating checksum in skb_segment()

Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Timo Ter=E4s (1):
      ip_gre: fix msg_name parsing for recvfrom/recvmsg

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1x0TAAoJEDjbvchgkmk+GgwP/2r5TJb8DzwuYyBPOYftnwpq
NBfBhRHHX3zqA4BJ34pchbdzVmM5hoUmP1UN5ZIdmYgsqa08VvJjfelN52Thx46w
pL3/2YKw85ldvZemRTNEkwKFmgGPEi4Nj8j6lwh5PHnvx5Z6CUyuPOn7f13xbFfs
uRn7GbM4FqdLh+EM42gxX83uFtIfi58LF+CCkIM5uqBKlJPpAq2Lle2qrj7G6UFj
lSM/xuOocRuMhz881/vw/Pg2JZu3AiVG0o02TjxlUFWyVPtQP0B+xIfYtV2b8L/0
t0bk6EY7Zj/L4PkE6nrw7QhCVV5icYoTVxMfcIL+VCWI6Je0eiCJdvcy6zaXqBUW
8YUjMUtPspeW9bfWP+mjmnR/JwsTIGyrm6dkrxpVbO3wmApDnIQOdl9vHnJv1l2H
SgquQvRZjnlBfjqSGBnUrOSmBv9W0IsWyqCfM1TJ2jiYZJrkMmUhzBhsdGNUoBCf
pdq3cXrRV0liTTnSvBEToV0p7jcT+Z794+iNfM6NKZS339bXKsBV+oM3Xgq7QcSU
CCAr+jwEzk13yy9m6q/sS4jWKGXN259G3DnA6nKAyShs4jo59sLSqg/j20Bi/C0W
uU/l6EmIbiFKV0/cHU87n1JgbXkmHnzAZlozPaheJXjMdmxEIns/1IfyKX96Vkbr
eJ9M2nAGtra5YWfh9aYL
=TnyJ
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
