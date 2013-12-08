Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856Ab3LHRKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:10:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab3LHRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:10:27 -0500
Date: Sun, 8 Dec 2013 09:11:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.23
Message-ID: <20131208171143.GA6182@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.23 kernel.

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

 Documentation/networking/ip-sysctl.txt         |    3=20
 Makefile                                       |    2=20
 block/blk-core.c                               |   10 ++
 block/elevator.c                               |   22 ++++-
 crypto/algif_hash.c                            |    5 -
 crypto/algif_skcipher.c                        |    4=20
 drivers/atm/idt77252.c                         |    2=20
 drivers/connector/cn_proc.c                    |   72 +++++++++-------
 drivers/gpu/drm/radeon/r600_hdmi.c             |   74 +++++++++++------
 drivers/hid/hid-lg.c                           |   58 +++++++++++++
 drivers/iommu/intel-iommu.c                    |    6 +
 drivers/iommu/intel_irq_remapping.c            |   13 +--
 drivers/isdn/isdnloop/isdnloop.c               |    8 +
 drivers/isdn/mISDN/socket.c                    |   13 ---
 drivers/mmc/card/block.c                       |   45 +++++++++-
 drivers/net/bonding/bond_sysfs.c               |   11 ++
 drivers/net/ethernet/mellanox/mlx4/en_main.c   |    8 -
 drivers/net/ethernet/realtek/8139cp.c          |    5 -
 drivers/net/ethernet/realtek/r8169.c           |    5 +
 drivers/net/macvtap.c                          |    8 +
 drivers/net/ppp/pppoe.c                        |    2=20
 drivers/net/team/team.c                        |    4=20
 drivers/net/tun.c                              |   10 ++
 drivers/net/usb/usbnet.c                       |    3=20
 drivers/video/kyro/fbdev.c                     |    6 -
 fs/aio.c                                       |   10 +-
 fs/xfs/xfs_ioctl.c                             |    6 +
 include/linux/clockchips.h                     |    4=20
 include/linux/net.h                            |    8 +
 include/linux/random.h                         |    6 -
 include/linux/skbuff.h                         |   32 -------
 include/linux/vm_event_item.h                  |    1=20
 include/net/ip.h                               |    2=20
 include/net/ip_vs.h                            |   32 -------
 include/net/ipv6.h                             |    6 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    5 -
 kernel/time/clockevents.c                      |   36 --------
 kernel/time/ntp.c                              |    3=20
 kernel/time/tick-broadcast.c                   |   33 +++++--
 kernel/time/tick-common.c                      |  106 +++++++++++---------=
-----
 kernel/time/tick-internal.h                    |    7 -
 lib/random32.c                                 |   14 +--
 mm/mprotect.c                                  |    7 +
 mm/vmstat.c                                    |    1=20
 net/appletalk/ddp.c                            |   16 +--
 net/atm/common.c                               |    2=20
 net/ax25/af_ax25.c                             |    4=20
 net/bluetooth/af_bluetooth.c                   |    4=20
 net/bluetooth/hci_sock.c                       |    2=20
 net/bluetooth/rfcomm/sock.c                    |    1=20
 net/bluetooth/sco.c                            |    1=20
 net/bridge/br_if.c                             |    2=20
 net/caif/caif_socket.c                         |    4=20
 net/compat.c                                   |    5 -
 net/core/dev.c                                 |    2=20
 net/core/fib_rules.c                           |    3=20
 net/core/iovec.c                               |    3=20
 net/core/pktgen.c                              |    7 +
 net/core/skbuff.c                              |    3=20
 net/ieee802154/6lowpan.c                       |    4=20
 net/ieee802154/dgram.c                         |    3=20
 net/ipv4/datagram.c                            |    2=20
 net/ipv4/ip_sockglue.c                         |    3=20
 net/ipv4/ip_vti.c                              |    1=20
 net/ipv4/ping.c                                |   13 +--
 net/ipv4/raw.c                                 |    6 -
 net/ipv4/route.c                               |    8 +
 net/ipv4/tcp.c                                 |   19 +---
 net/ipv4/tcp_ipv4.c                            |    2=20
 net/ipv4/tcp_metrics.c                         |    5 -
 net/ipv4/tcp_output.c                          |    7 +
 net/ipv4/udp.c                                 |   14 +--
 net/ipv6/datagram.c                            |    8 +
 net/ipv6/ip6_flowlabel.c                       |    2=20
 net/ipv6/ip6_output.c                          |    7 -
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   54 ------------
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   19 ----
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    7 +
 net/ipv6/raw.c                                 |    8 -
 net/ipv6/route.c                               |    7 +
 net/ipv6/udp.c                                 |    9 --
 net/ipv6/udp_offload.c                         |    2=20
 net/ipx/af_ipx.c                               |    3=20
 net/irda/af_irda.c                             |    4=20
 net/iucv/af_iucv.c                             |    2=20
 net/key/af_key.c                               |    1=20
 net/l2tp/l2tp_ip.c                             |    4=20
 net/l2tp/l2tp_ip6.c                            |    2=20
 net/l2tp/l2tp_ppp.c                            |    2=20
 net/llc/af_llc.c                               |    2=20
 net/netfilter/ipvs/ip_vs_core.c                |   55 ------------
 net/netfilter/ipvs/ip_vs_pe_sip.c              |    8 -
 net/netlink/af_netlink.c                       |    2=20
 net/netrom/af_netrom.c                         |    3=20
 net/nfc/llcp_sock.c                            |    2=20
 net/nfc/rawsock.c                              |    2=20
 net/packet/af_packet.c                         |   95 ++++++++++++--------=
--
 net/packet/internal.h                          |    1=20
 net/phonet/datagram.c                          |    9 --
 net/rds/recv.c                                 |    2=20
 net/rose/af_rose.c                             |    8 +
 net/rxrpc/ar-recvmsg.c                         |    9 +-
 net/socket.c                                   |   24 +++--
 net/tipc/socket.c                              |    6 -
 net/unix/af_unix.c                             |    5 -
 net/vmw_vsock/af_vsock.c                       |    2=20
 net/vmw_vsock/vmci_transport.c                 |    2=20
 net/x25/af_x25.c                               |    3=20
 108 files changed, 615 insertions(+), 630 deletions(-)

Alexei Starovoitov (1):
      ipv4: fix race in concurrent ip_route_input_slow()

Amir Vadai (1):
      net/mlx4_en: Fixed crash when port type is changed

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andrey Vagin (1):
      tcp: don't update snd_nxt, when a socket is switched from repair mode

Chris Metcalf (1):
      connector: improved unaligned access error fix

Dan Carpenter (2):
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

David Chang (1):
      r8169: check ALDPS bit and disable it if enabled for the 8168g

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the bridge dev

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Dwight Engen (1):
      xfs: add capability check to free eofblocks ioctl

Eric Dumazet (5):
      tcp: tsq: restore minimal amount of queueing
      net-tcp: fix panic in tcp_fastopen_cache_set()
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks
      tcp: gso: fix truesize tracking

Felix Fietkau (1):
      usbnet: fix status interrupt urb handling

Greg Kroah-Hartman (1):
      Linux 3.10.23

Hannes Frederic Sowa (8):
      ipv6: fix headroom calculation in udp6_ufo_fragment
      ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sock=
addr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpm=
tu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Jason Wang (2):
      tuntap: limit head length of skb allocated
      macvtap: limit head length of skb allocated

Jiri Pirko (3):
      ip6_output: fragment outgoing reassembled skb properly
      netfilter: push reasm skb through instead of original frag skbs
      team: fix master carrier set when user linkup is enabled

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Julian Stecklina (1):
      iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU addres=
s limits

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

Mateusz Guzik (1):
      aio: restore locking of ioctx list on removal

Mel Gorman (1):
      mm: numa: return the number of base pages altered by protection chang=
es

Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Neil Horman (1):
      iommu: Remove stack trace from broken irq remapping warning

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Pierre Ossman (2):
      drm/radeon/audio: improve ACR calculation
      drm/radeon/audio: correct ACR table

Sasha Levin (1):
      video: kyro: fix incorrect sizes when copying to userspace

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Simon Wood (1):
      HID: lg: fix Report Descriptor for Logitech MOMO Force (Black)

Stephen Boyd (1):
      clockevents: Prefer CPU local devices over global devices

Thomas Gleixner (3):
      clockevents: Get rid of the notifier chain
      clockevents: Add module refcount
      clockevents: Split out selection logic

Tomoki Sekiyama (2):
      elevator: Fix a race in elevator switching and md device initializati=
on
      elevator: acquire q->sysfs_lock in elevator_change()

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Yang Yingliang (1):
      net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (2):
      xfrm: Release dst if this dst is improper for vti tunnel
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranfo=
rmation


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpKhPAAoJEDjbvchgkmk+eAwP/iXtlSMamqtRiLMx663N7HWJ
vnCftjllDTmEG9LShLl7y9NSm52YyGngs5n9TUt72qfzMIXk4+KdVFRw/8btGRL8
hZ5DfphwfSp8Ry9lBrSp11ajxEUaXYO0t4BglfZM0zjgD/+MYLGZ6xrIyh4y7u5R
57p6ETT0Ftcq9eFgUbEyC+ZlFiREyCxb1Zv59ommWeKaTk0wJoZKuYIS1PXXzqhE
Nbu+7aVOnGVPYIFqyeVds9hElPu3d6I1eECxks+/Ef/g8VbP5HbCMSM6U3GpBjFG
Zjq0aDDe2rp1stncdKZTDFQf05O2li+FsMNSzS/Pc3SkmT8IIPBOgViOPFiz0pci
Uu10lFp3zMOH+3mOTCWVyikboe8cBXj2OI/Dh8ak/X850o1TMiGD+T6hjf4DztG8
VTkedvJd+R0hNoHaLu25zvaOfhmB7zjK5/gZ5YmlA7uAzMUrecK7P0dI3WpTwLOe
4MSR2FM76puMxwgNee/aFll5CMZgwkBYIMTcTdsmV5XATR0i08eqlSffT5ePEceZ
WqpK8foX6cT/KiwFoh2TKVIMrcILS5KBpJL2JzYZFI3BX3r6993BrkLuS6Vi/nhL
VNhb8Gmok/ROcreu2QVlyjS+hB7ij3BZTlJvENerOey0Gf023esLe8RFsoB0zCDU
FClKYg4ip+eOkCENqJvx
=LD5a
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
