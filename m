Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab3LHRLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:11:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847Ab3LHRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:10:52 -0500
Date: Sun, 8 Dec 2013 09:12:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.4
Message-ID: <20131208171219.GA6269@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.4 kernel.

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

 Documentation/networking/ip-sysctl.txt         |    3=20
 Makefile                                       |    2=20
 arch/x86/net/bpf_jit_comp.c                    |    2=20
 block/blk-core.c                               |   10 +
 block/elevator.c                               |   22 ++
 crypto/algif_hash.c                            |    5=20
 crypto/algif_skcipher.c                        |    4=20
 drivers/atm/idt77252.c                         |    2=20
 drivers/connector/cn_proc.c                    |   72 +++++---
 drivers/gpu/drm/radeon/r600_hdmi.c             |   74 ++++++---
 drivers/hid/hid-elo.c                          |   35 ++++
 drivers/hid/hid-lg.c                           |   58 +++++++
 drivers/iommu/intel-iommu.c                    |    6=20
 drivers/iommu/intel_irq_remapping.c            |   13 -
 drivers/isdn/isdnloop/isdnloop.c               |    8=20
 drivers/isdn/mISDN/socket.c                    |   13 -
 drivers/md/raid5.c                             |   63 ++++---
 drivers/net/bonding/bond_main.c                |    8=20
 drivers/net/bonding/bond_sysfs.c               |   11 +
 drivers/net/ethernet/marvell/mv643xx_eth.c     |    2=20
 drivers/net/ethernet/mellanox/mlx4/en_main.c   |    8=20
 drivers/net/ethernet/realtek/8139cp.c          |    5=20
 drivers/net/ethernet/realtek/r8169.c           |    5=20
 drivers/net/ethernet/smsc/smc91x.h             |   22 --
 drivers/net/ethernet/via/via-velocity.c        |   11 -
 drivers/net/macvtap.c                          |    8=20
 drivers/net/ppp/pppoe.c                        |    2=20
 drivers/net/team/team.c                        |    4=20
 drivers/net/tun.c                              |   10 +
 drivers/net/usb/usbnet.c                       |    3=20
 drivers/net/wireless/rt2x00/rt2800.h           |    2=20
 drivers/net/wireless/rt2x00/rt2800lib.c        |    8=20
 drivers/net/xen-netback/netback.c              |    1=20
 drivers/usb/musb/davinci.c                     |   11 +
 drivers/usb/wusbcore/wa-xfer.c                 |    5=20
 drivers/video/kyro/fbdev.c                     |    6=20
 fs/aio.c                                       |  201 +++++++++++++-------=
-----
 fs/anon_inodes.c                               |   50 ------
 fs/libfs.c                                     |   43 +++++
 fs/xfs/xfs_ioctl.c                             |    6=20
 include/linux/fs.h                             |    1=20
 include/linux/net.h                            |    8=20
 include/linux/random.h                         |    6=20
 include/linux/skbuff.h                         |   32 ---
 include/linux/vm_event_item.h                  |    1=20
 include/net/ip.h                               |    2=20
 include/net/ip_vs.h                            |   32 ---
 include/net/ipv6.h                             |    6=20
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    5=20
 include/net/ping.h                             |    3=20
 include/uapi/linux/pkt_sched.h                 |    7=20
 kernel/time/ntp.c                              |    3=20
 lib/random32.c                                 |   14 -
 mm/mprotect.c                                  |    7=20
 mm/vmstat.c                                    |    1=20
 net/appletalk/ddp.c                            |   16 -
 net/atm/common.c                               |    2=20
 net/ax25/af_ax25.c                             |    4=20
 net/bluetooth/af_bluetooth.c                   |    4=20
 net/bluetooth/hci_sock.c                       |    2=20
 net/bluetooth/rfcomm/sock.c                    |    1=20
 net/bluetooth/sco.c                            |    1=20
 net/bridge/br_if.c                             |    2=20
 net/caif/caif_socket.c                         |    4=20
 net/compat.c                                   |    5=20
 net/core/dev.c                                 |    8=20
 net/core/fib_rules.c                           |    3=20
 net/core/iovec.c                               |    3=20
 net/core/pktgen.c                              |    7=20
 net/core/skbuff.c                              |   78 ++++++---
 net/ieee802154/6lowpan.c                       |    4=20
 net/ieee802154/dgram.c                         |    3=20
 net/ipv4/datagram.c                            |    2=20
 net/ipv4/ip_sockglue.c                         |    3=20
 net/ipv4/ip_tunnel.c                           |    4=20
 net/ipv4/ip_vti.c                              |    1=20
 net/ipv4/ping.c                                |   56 +++---
 net/ipv4/raw.c                                 |    6=20
 net/ipv4/route.c                               |    8=20
 net/ipv4/tcp.c                                 |    6=20
 net/ipv4/tcp_ipv4.c                            |    2=20
 net/ipv4/tcp_metrics.c                         |    5=20
 net/ipv4/tcp_offload.c                         |   31 +--
 net/ipv4/tcp_output.c                          |    7=20
 net/ipv4/udp.c                                 |   14 -
 net/ipv4/xfrm4_policy.c                        |    6=20
 net/ipv6/af_inet6.c                            |    4=20
 net/ipv6/datagram.c                            |    8=20
 net/ipv6/ip6_flowlabel.c                       |    2=20
 net/ipv6/ip6_output.c                          |    7=20
 net/ipv6/ip6_tunnel.c                          |   18 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   54 ------
 net/ipv6/netfilter/nf_conntrack_reasm.c        |   19 --
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    7=20
 net/ipv6/ping.c                                |    3=20
 net/ipv6/raw.c                                 |    8=20
 net/ipv6/route.c                               |    7=20
 net/ipv6/sit.c                                 |   18 +-
 net/ipv6/tcpv6_offload.c                       |   32 +--
 net/ipv6/udp.c                                 |    9 -
 net/ipv6/udp_offload.c                         |    2=20
 net/ipv6/xfrm6_policy.c                        |    6=20
 net/ipx/af_ipx.c                               |    3=20
 net/irda/af_irda.c                             |    4=20
 net/iucv/af_iucv.c                             |    2=20
 net/key/af_key.c                               |    1=20
 net/l2tp/l2tp_ip.c                             |    4=20
 net/l2tp/l2tp_ip6.c                            |    2=20
 net/l2tp/l2tp_ppp.c                            |    2=20
 net/llc/af_llc.c                               |    2=20
 net/netfilter/ipvs/ip_vs_core.c                |   55 ------
 net/netfilter/ipvs/ip_vs_pe_sip.c              |    8=20
 net/netlink/af_netlink.c                       |    2=20
 net/netrom/af_netrom.c                         |    3=20
 net/nfc/llcp_sock.c                            |    2=20
 net/nfc/rawsock.c                              |    2=20
 net/packet/af_packet.c                         |   95 ++++++-----
 net/packet/internal.h                          |    1=20
 net/phonet/datagram.c                          |    9 -
 net/rds/recv.c                                 |    2=20
 net/rose/af_rose.c                             |    8=20
 net/rxrpc/ar-recvmsg.c                         |    9 -
 net/sched/sch_fq.c                             |   40 ++--
 net/sched/sch_tbf.c                            |   32 +++
 net/socket.c                                   |   24 +-
 net/tipc/socket.c                              |    6=20
 net/unix/af_unix.c                             |    5=20
 net/vmw_vsock/af_vsock.c                       |    2=20
 net/vmw_vsock/vmci_transport.c                 |    2=20
 net/x25/af_x25.c                               |    3=20
 130 files changed, 949 insertions(+), 835 deletions(-)

Al Viro (1):
      take anon inode allocation to libfs.c

Alexei Starovoitov (2):
      core/dev: do not ignore dmac in dev_forward_skb()
      ipv4: fix race in concurrent ip_route_input_slow()

Amir Vadai (1):
      net/mlx4_en: Fixed crash when port type is changed

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Andrey Vagin (2):
      net: x86: bpf: don't forget to free sk_filter (v2)
      tcp: don't update snd_nxt, when a socket is switched from repair mode

Andy Whitcroft (1):
      xen-netback: include definition of csum_ipv6_magic

Benjamin LaHaise (1):
      rework aio migrate pages to use aio fs

Chris Metcalf (1):
      connector: improved unaligned access error fix

Dan Carpenter (4):
      net: mv643xx_eth: potential NULL dereference in probe()
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error
      aio: checking for NULL instead of IS_ERR

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

Eric Dumazet (7):
      tcp: tsq: restore minimal amount of queueing
      net-tcp: fix panic in tcp_fastopen_cache_set()
      ipv4: fix possible seqlock deadlock
      pkt_sched: fq: warn users using defrate
      pkt_sched: fq: fix pacing for small frames
      sch_tbf: handle too small burst
      inet: fix possible seqlock deadlocks

Felix Fietkau (1):
      usbnet: fix status interrupt urb handling

Francois Romieu (1):
      via-velocity: fix netif_receive_skb use in irq disabled section.

Greg Kroah-Hartman (1):
      Linux 3.12.4

Gu Zheng (1):
      aio: clean up aio ring in the fail path

Hannes Frederic Sowa (9):
      ipv6: fix headroom calculation in udp6_ufo_fragment
      ipv6: protect for_each_sk_fl_rcu in mem_check with rcu_read_lock_bh
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      ping: prevent NULL pointer dereference on write to msg_name
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sock=
addr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpm=
tu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Herbert Xu (3):
      gso: handle new frag_list of frags GRO packets
      gro: Only verify TCP checksums for candidates
      gro: Clean up tcpX_gro_receive checksum verification

Jason Gunthorpe (1):
      net: mv643xx_eth: Add missing phy_addr_set in DT mode

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

Kent Overstreet (1):
      aio: Fix a trinity splat

Linus Walleij (1):
      net: smc91: fix crash regression on the versatile

Maciej =C5=BBenczykowski (1):
      pkt_sched: fq: change classification of control packets

Mel Gorman (1):
      mm: numa: return the number of base pages altered by protection chang=
es

Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Neil Horman (1):
      iommu: Remove stack trace from broken irq remapping warning

Nicolas Dichtel (1):
      ip6tnl: fix use after free of fb_tnl_dev

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Oliver Neukum (1):
      HID: hid-elo: some systems cannot stomach work around

Pierre Ossman (2):
      drm/radeon/audio: improve ACR calculation
      drm/radeon/audio: correct ACR table

Sasha Levin (3):
      video: kyro: fix incorrect sizes when copying to userspace
      aio: prevent double free in ioctx_alloc
      aio: nullify aio->ring_pages after freeing it

Sergei Shtylyov (1):
      usb: musb: davinci: fix resources passed to MUSB driver for DM6467

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Simon Wood (1):
      HID: lg: fix Report Descriptor for Logitech MOMO Force (Black)

Stanislaw Gruszka (1):
      rt2800: add support for radio chip RF3070

Steffen Klassert (1):
      xfrm: Fix null pointer dereference when decoding sessions

Thomas Pugliese (1):
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Tomoki Sekiyama (2):
      elevator: Fix a race in elevator switching and md device initializati=
on
      elevator: acquire q->sysfs_lock in elevator_change()

Veaceslav Falico (3):
      bonding: RCUify bond_set_rx_mode()
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vlad Yasevich (2):
      ipv6: Fix inet6_init() cleanup order
      net: core: Always propagate flag changes to interfaces

Willem de Bruijn (1):
      sit: fix use after free of fb_tunnel_dev

Yang Yingliang (1):
      net: 8139cp: fix a BUG_ON triggered by wrong bytes_compl

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (2):
      xfrm: Release dst if this dst is improper for vti tunnel
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranfo=
rmation

majianpeng (1):
      md/raid5: Use conf->device_lock protect changing of multi-thread reso=
urces.


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpKhzAAoJEDjbvchgkmk++CcQANdivxvrhrH/DsrxmyVlHvo7
VDFwoTOA2l7vNkklmtgUxRJghhI2bOIiV38Zju19x8k+ig3Gyc3gIhtW+c0RwYRE
FY7JQefjV54v/u6FAFZgZwkFfKGURh6VzN9ohGUwnLN34yXTdrQyCG7Hh0KqM7hz
nI3DrfSCWcAoDNKMRll1yBTJNxsh/33pyAifmH9W7JzEeTaJ65GJmNn8WG3Ed4GX
VEJBzydLbzzNb3fAm4jvEwDzNPtNRUzcaEJBARjICWjFeP/kpWoLugp1RKYKDKJR
h+lI66udSP0p0hrGhkEirzjcoIES8TiXWUq5nF4bg0Y46wzoWvPoe4Y3JILurGhr
iEwzrV/HPcQTs7yVzpjwunedcGaATdof0rOAw3BzJOZZQ695/FhPCD/nv/jLpTWk
bCH8XOdTnmf3EfqAFRhXkOkkpyIXnqyB7CUNQ6pnsX1kQSKUlbFhACONRKsUvlbj
wayr3VHQwm2ghvyiDgETyFK6qLPoNghwoR0Y30mqRJ/svp/hi8SMT/DogLe/ZnMu
cPk1ntIu57/GyGiprAWNrYkX12Vnxz0Uy4t48yRzBBc8LSbhpKZuMJr/kH5o9FFj
TjI/m9dCcCaQj2IN2D620BePWM1XmUo4nrG30FuNiWCWzgfzBIH09i5DSj13Hp+V
BSWGSpW+OyTIwFju0ez0
=Mzdw
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
