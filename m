Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaAOXpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:45:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaAOXpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:45:02 -0500
Date: Wed, 15 Jan 2014 15:45:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.8
Message-ID: <20140115234536.GA6756@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.8 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/clock/exynos5250-clock.txt |    2=20
 Documentation/networking/packet_mmap.txt                     |   10=20
 Makefile                                                     |    2=20
 arch/arm/boot/dts/exynos5250.dtsi                            |    2=20
 arch/arm/kernel/traps.c                                      |    8=20
 arch/arm/mach-footbridge/dc21285-timer.c                     |    5=20
 arch/arm/mach-shmobile/board-armadillo800eva.c               |    4=20
 arch/arm/mach-shmobile/board-kzm9g.c                         |    2=20
 arch/arm/mach-shmobile/board-mackerel.c                      |    4=20
 arch/arm/mm/flush.c                                          |    6=20
 arch/parisc/include/asm/cacheflush.h                         |   12 -
 arch/parisc/include/asm/page.h                               |    5=20
 arch/parisc/kernel/cache.c                                   |   35 ---
 arch/x86/include/asm/fpu-internal.h                          |   13 -
 drivers/acpi/battery.c                                       |   21 +
 drivers/ata/ahci.c                                           |    3=20
 drivers/char/tpm/tpm_ppi.c                                   |   15 -
 drivers/clk/clk-divider.c                                    |    2=20
 drivers/clk/samsung/clk-exynos4.c                            |    2=20
 drivers/clk/samsung/clk-exynos5250.c                         |   14 -
 drivers/cpufreq/intel_pstate.c                               |    3=20
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c              |    6=20
 drivers/leds/leds-lp5521.c                                   |   12 -
 drivers/leds/leds-lp5523.c                                   |   12 -
 drivers/mfd/rtsx_pcr.c                                       |   10=20
 drivers/net/ethernet/arc/emac_main.c                         |    4=20
 drivers/net/ethernet/broadcom/tg3.c                          |    3=20
 drivers/net/ethernet/freescale/fec_main.c                    |    4=20
 drivers/net/ethernet/ibm/ehea/ehea_main.c                    |    2=20
 drivers/net/ethernet/sfc/efx.c                               |    8=20
 drivers/net/ethernet/sfc/mcdi.c                              |   39 ++-
 drivers/net/ethernet/sfc/net_driver.h                        |    3=20
 drivers/net/ethernet/sfc/nic.h                               |    2=20
 drivers/net/ethernet/sfc/ptp.c                               |   66 +++++-
 drivers/net/ethernet/sfc/rx.c                                |    6=20
 drivers/net/ethernet/tehuti/tehuti.c                         |    1=20
 drivers/net/ethernet/xilinx/ll_temac_main.c                  |    2=20
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c            |    2=20
 drivers/net/hamradio/hdlcdrv.c                               |    2=20
 drivers/net/hamradio/yam.c                                   |    1=20
 drivers/net/hyperv/netvsc_drv.c                              |    1=20
 drivers/net/macvtap.c                                        |   23 --
 drivers/net/tun.c                                            |   18 +
 drivers/net/virtio_net.c                                     |  119 ++++++=
+----
 drivers/net/vxlan.c                                          |    2=20
 drivers/scsi/sd.c                                            |    5=20
 include/linux/net.h                                          |    2=20
 include/linux/netdevice.h                                    |   22 ++
 include/linux/skbuff.h                                       |    5=20
 kernel/sched/core.c                                          |    9=20
 kernel/sched/fair.c                                          |   48 +++-
 kernel/sched/sched.h                                         |    3=20
 net/8021q/vlan_dev.c                                         |   19 +
 net/bridge/br_multicast.c                                    |    4=20
 net/bridge/br_private.h                                      |   10=20
 net/bridge/br_stp_bpdu.c                                     |    2=20
 net/core/drop_monitor.c                                      |    1=20
 net/core/neighbour.c                                         |    2=20
 net/core/netpoll.c                                           |   11 -
 net/core/skbuff.c                                            |    1=20
 net/core/sock.c                                              |    2=20
 net/ipv4/fib_rules.c                                         |    5=20
 net/ipv4/gre_offload.c                                       |   11 -
 net/ipv4/inet_diag.c                                         |   16 +
 net/ipv4/ip_gre.c                                            |    1=20
 net/ipv4/udp.c                                               |    6=20
 net/ipv4/udp_offload.c                                       |   37 +--
 net/ipv6/fib6_rules.c                                        |    6=20
 net/ipv6/route.c                                             |   34 +--
 net/ipv6/udp_offload.c                                       |    2=20
 net/llc/af_llc.c                                             |    5=20
 net/mac80211/tx.c                                            |   23 +-
 net/netfilter/nf_conntrack_seqadj.c                          |    4=20
 net/netfilter/nf_nat_irc.c                                   |   32 ++
 net/packet/af_packet.c                                       |   65 +++---
 net/rds/ib.c                                                 |    3=20
 net/rds/ib_send.c                                            |    5=20
 net/rose/af_rose.c                                           |   16 -
 net/unix/af_unix.c                                           |   16 +
 79 files changed, 624 insertions(+), 327 deletions(-)

Abhilash Kesavan (4):
      ARM: dts: exynos5250: Fix MDMA0 clock number
      clk: samsung: exynos5250: Fix ACP gate register offset
      clk: samsung: exynos5250: Add MDMA0 clocks
      clk: samsung: exynos5250: Add CLK_IGNORE_UNUSED flag for the sysreg c=
lock

Alexandre Rames (1):
      sfc: Stop/re-start PTP when stopping/starting the datapath.

Andrew Bresticker (1):
      clk: exynos5250: fix sysmmu_mfc{l,r} gate clocks

Andrew Rybchenko (1):
      sfc: RX buffer allocation takes prefix size into account in IP header=
 alignment

Andrey Vagin (1):
      virtio: delete napi structures from netdev before releasing memory

Ben Hutchings (3):
      sfc: Add length checks to efx_xmit_with_hwtstamp() and efx_ptp_is_ptp=
_tx()
      sfc: Rate-limit log message for PTP packets without a matching timest=
amp event
      sfc: Maintain current frequency adjustment when applying a time offset

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

Eric Dumazet (3):
      net: do not pretend FRAGLIST support
      net: fec: fix potential use after free
      arc_emac: fix potential use after free

Fan Du (1):
      vxlan: release rt when found circular route

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Greg Kroah-Hartman (1):
      Linux 3.12.8

Hannes Frederic Sowa (3):
      net: clear local_df when passing skb between namespaces
      ipv6: don't count addrconf generated routes against gc limit
      ipv6: fix illegal mac_header comparison on 32bit

Ilia Mirkin (1):
      drm/nouveau/bios: make jump conditional

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Jason Wang (4):
      tun: unbreak truncated packet signalling
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu
      virtio-net: fix refill races during restore

Jiang Liu (1):
      ACPI / TPM: fix memory leak when walking ACPI namespace

Jiri Pirko (1):
      br: fix use of ->rx_handler_data in code executed on non-rx_handler p=
ath

John David Anglin (1):
      parisc: Ensure full cache coherency for kmap/kunmap

Kamala R (1):
      IPv6: Fixed support for blackhole and prohibit routes

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Laurence Evans (1):
      sfc: PTP: Moderate log message on event queue overflow

Laurent Pinchart (3):
      ARM: shmobile: kzm9g: Fix coherent DMA mask
      ARM: shmobile: armadillo: Fix coherent DMA mask
      ARM: shmobile: mackerel: Fix coherent DMA mask

Li RongQing (1):
      ipv6: always set the new created dst's from in ip6_rt_copy

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Michael S. Tsirkin (3):
      virtio_net: fix error handling for mergeable buffers
      virtio-net: make all RX paths handle errors consistently
      virtio_net: don't leak memory or block when too many frags

Milo Kim (1):
      leds: lp5521/5523: Remove duplicate mutex

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Phil Oester (1):
      netfilter: fix wrong byte order in nf_ct_seqadj_set internal informat=
ion

Robert Stonehouse (2):
      sfc: Refactor efx_mcdi_poll() by introducing efx_mcdi_poll_once()
      sfc: Poll for MCDI completion once before timeout occurs

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

Stefan Tomanek (1):
      inet: fix NULL pointer Oops in fib(6)_rule_suppress

Steven Capper (1):
      ARM: 7923/1: mm: fix dcache flush logic for compound high pages

Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Timo Ter=E4s (1):
      ip_gre: fix msg_name parsing for recvfrom/recvmsg

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Wei-Chun Chao (1):
      ipv4: fix tunneled VM traffic over hw VXLAN/GRE GSO NIC

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1x2gAAoJEDjbvchgkmk+P4IP/04pwFGjx24ODiaca78g/fmw
/EYjRw/DduRWrZF+YZun3MJrPk8mvEzPM08u6C0OTNre7SDL2Hihu4XoUA8KyYQt
eukUEs6NiwhNAWaJ9GqCiSM7DunH2ldRLxw2GPwhR8i3w+s+75r2BQyLbwJ9NfdM
Qg/Trqo5De+rfs9le3IGMZo2gCujiJoItBQJJRH3wWW2S+Ls9AMFN332zd+R/A6o
37cxIgNY6f4UC8crROpChHVYex19dg2wyrMRLXnkaW94J982X5ldJxjD8kNztDel
UoKlMUYuAwnqMIwAGDEN2lV6UYBCWac0DBy0TPwce5sGoSsKsGNbZms0i52xUrA6
jVr2TMlXeVn0mfyg8Lkk5AeeCwF5OxyWnkYaDMmVpc0sAhpJmvPrUNz7v4a9QJGt
cogfg452UVLcbmsB540+3bY7tDHVKLjZ+T/3kVKGnueFVIHoMqRKLO+BKJNDJXcM
XwNrJotEVGCGrFr1JM/ku/P03Hj+rzkZsD3r1+oqcsRX5rQ9p1krQrRK4huDU6QZ
aWJDscfsUdO+RclsoW0pcGWMM4QS2Cxqhpxj3dwwcyz89bXcc5rds8tUE6b5rZdH
IRtWzW03HC2XRD9Ir/gtFs3wNirIYe5L3QIzsbVMzAsJRfkK5QYaCY2YBP8mIpOC
PMs3j++yjmpasJ7So44l
=Ynr4
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
