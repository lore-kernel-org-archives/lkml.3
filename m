Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3LHRKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:10:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3LHRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:10:15 -0500
Date: Sun, 8 Dec 2013 09:11:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.73
Message-ID: <20131208171113.GA6122@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.73 kernel.

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

 Makefile                         |    2=20
 block/blk-core.c                 |    4 +
 block/elevator.c                 |   16 +++++-
 crypto/algif_hash.c              |    5 +-
 crypto/algif_skcipher.c          |    4 +
 drivers/atm/idt77252.c           |    2=20
 drivers/connector/cn_proc.c      |   66 +++++++++++++++-----------
 drivers/hid/hid-picolcd.c        |    2=20
 drivers/iommu/intel-iommu.c      |    6 ++
 drivers/isdn/isdnloop/isdnloop.c |    8 ++-
 drivers/isdn/mISDN/socket.c      |   13 +----
 drivers/md/dm-crypt.c            |   37 +++------------
 drivers/md/dm-delay.c            |    6 --
 drivers/md/dm-flakey.c           |    5 --
 drivers/md/dm-ioctl.c            |   18 ++++---
 drivers/md/dm-linear.c           |    5 --
 drivers/md/dm-mpath.c            |    6 --
 drivers/md/dm-raid.c             |    6 --
 drivers/md/dm-raid1.c            |    6 --
 drivers/md/dm-snap.c             |   12 +---
 drivers/md/dm-stripe.c           |    5 --
 drivers/md/dm-thin.c             |   74 ++++++++++++++++++------------
 drivers/md/dm-verity.c           |    6 --
 drivers/mmc/card/block.c         |   47 +++++++++++++++++--
 drivers/net/bonding/bond_sysfs.c |   11 +++-
 drivers/net/ppp/pppoe.c          |    2=20
 drivers/video/kyro/fbdev.c       |    6 +-
 fs/nfsd/nfssvc.c                 |    3 -
 include/linux/device-mapper.h    |    4 -
 include/linux/net.h              |    8 +++
 include/linux/random.h           |    6 +-
 include/net/ip.h                 |    2=20
 include/net/ipv6.h               |    6 +-
 lib/random32.c                   |   14 ++---
 net/appletalk/ddp.c              |   16 ++----
 net/atm/common.c                 |    2=20
 net/ax25/af_ax25.c               |    4 -
 net/bluetooth/af_bluetooth.c     |    4 -
 net/bluetooth/hci_sock.c         |    2=20
 net/bluetooth/rfcomm/sock.c      |    1=20
 net/bridge/br_if.c               |    2=20
 net/caif/caif_socket.c           |    4 -
 net/compat.c                     |    5 +-
 net/core/dev.c                   |    2=20
 net/core/fib_rules.c             |    3 -
 net/core/iovec.c                 |    3 -
 net/core/pktgen.c                |    7 ++
 net/ieee802154/6lowpan.c         |    4 -
 net/ipv4/datagram.c              |    2=20
 net/ipv4/ip_sockglue.c           |    3 -
 net/ipv4/ping.c                  |   13 ++---
 net/ipv4/raw.c                   |    6 --
 net/ipv4/tcp_ipv4.c              |    2=20
 net/ipv4/udp.c                   |   14 ++---
 net/ipv6/datagram.c              |    8 ++-
 net/ipv6/ip6_output.c            |    4 -
 net/ipv6/raw.c                   |    8 +--
 net/ipv6/route.c                 |    7 ++
 net/ipv6/udp.c                   |    9 +--
 net/ipx/af_ipx.c                 |    3 -
 net/irda/af_irda.c               |    4 -
 net/iucv/af_iucv.c               |    2=20
 net/key/af_key.c                 |    1=20
 net/l2tp/l2tp_ip.c               |    4 -
 net/l2tp/l2tp_ppp.c              |    2=20
 net/llc/af_llc.c                 |    2=20
 net/netlink/af_netlink.c         |    2=20
 net/netrom/af_netrom.c           |    3 -
 net/nfc/rawsock.c                |    2=20
 net/packet/af_packet.c           |   96 +++++++++++++++++++++-------------=
-----
 net/phonet/datagram.c            |    9 +--
 net/rds/recv.c                   |    2=20
 net/rose/af_rose.c               |    8 ++-
 net/rxrpc/ar-recvmsg.c           |    9 ++-
 net/socket.c                     |   24 +++++----
 net/tipc/socket.c                |    6 --
 net/unix/af_unix.c               |    5 --
 net/x25/af_x25.c                 |    3 -
 78 files changed, 398 insertions(+), 347 deletions(-)

Andreas Henriksson (1):
      net: Fix "ip rule delete table 256"

Chris Metcalf (1):
      connector: improved unaligned access error fix

Dan Carpenter (2):
      isdnloop: use strlcpy() instead of strcpy()
      net: clamp ->msg_namelen instead of returning an error

Daniel Borkmann (2):
      random32: fix off-by-one in seeding requirement
      packet: fix use after free race in send path when dev is released

Ding Tianhong (1):
      bridge: flush br's address entry in fdb when remove the bridge dev

Duan Jiong (1):
      ipv6: use rt6_get_dflt_router to get default router in rt6_route_rcv

Eric Dumazet (2):
      ipv4: fix possible seqlock deadlock
      inet: fix possible seqlock deadlocks

Greg Kroah-Hartman (1):
      Linux 3.4.73

Hannes Frederic Sowa (6):
      inet: prevent leakage of uninitialized memory to user in recv syscalls
      net: rework recvmsg handler msg_name and msg_namelen logic
      net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct sock=
addr_storage)
      inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpm=
tu functions
      ipv6: fix leaking uninitialized port number of offender sockaddr
      ipv6: fix possible seqlock deadlock in ip6_finish_output2

Jukka Rissanen (1):
      6lowpan: Uncompression of traffic class field was incorrect

Julian Stecklina (1):
      iommu/vt-d: Fixed interaction of VFIO_IOMMU_MAP_DMA with IOMMU addres=
s limits

KOBAYASHI Yoshitake (1):
      mmc: block: fix a bug of error handling in MMC driver

Kees Cook (1):
      HID: picolcd_core: validate output report details

Mikulas Patocka (2):
      dm: fix truncated status strings
      blk-core: Fix memory corruption if blkcg_init_queue fails

Nikolay Aleksandrov (1):
      bonding: fix two race conditions in bond_store_updelay/downdelay

Sasha Levin (1):
      video: kyro: fix incorrect sizes when copying to userspace

Shawn Landden (1):
      net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST

Stanislav Kinsbursky (1):
      nfsd: use "init_net" for portmapper

Tomoki Sekiyama (1):
      elevator: acquire q->sysfs_lock in elevator_change()

Veaceslav Falico (2):
      bonding: don't permit to use ARP monitoring in 802.3ad mode
      af_packet: block BH in prb_shutdown_retire_blk_timer()

Vlad Yasevich (1):
      net: core: Always propagate flag changes to interfaces

Ying Xue (1):
      atm: idt77252: fix dev refcnt leak

fan.du (1):
      {pktgen, xfrm} Update IPv4 header total len and checksum after tranfo=
rmation


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpKgxAAoJEDjbvchgkmk+v3UQAJJvR83NQxbc81AePOFE6tgb
yYHR/Y0c3Qvo6wyCNCSfQ0G71Ryi+5lDHBT0C6Kwf0p1Ul+JNMrN7PB5HQiPxeS3
17tJ59jKKfPXgYCUFQKXr6jZ9PCc03OUWwzh8MMmoR1+3cWTsYONvESatGdPxr9Z
XJVApLdF0ZV4ViCuDb7Y6OR+pgPObvwBriziL70X3DD5vRaTuEeuzlcZj5YQ1hV8
P95VF+Y3gpJq87v0Q1X8w/uhUt2nT9ojtRmi2bGM/Xv0aX9T9r+AVwE8+IBt1dCK
Pmjz3Evkswe5j4M+k0ISBxMqxoXpX9zLNb4c7BIAP6uKyuTKpJW+9BgfIFy8nmEb
UVdEShIJe2Q0RmAPvoZprPRxD3B9017miEVImgyf+WaSd/HPJPWYHHDiIObnrAz5
I+m/bwf+LNvvSeJ6eF10DZ6MCHIsVl58hFOQF7/QwhLwKh4Q1/XzaKXWILObZU+o
BPJqGsHdh8NXD5KTdA754naAhnb39RbJfinsn+1NqkjhKZ92oR4cl19A9mV/KuJc
JCnPZ0hpzh56MfpD9T6m0Wuqi86UmLg1xdGiWVMKGT2t+IBgeCTGmfOJ6MdLD0eb
a5BWe9vb+ZYWWnou/LqmMf9bI7095qfwF+RtdPNntrqC7aKguDFToeBR3p1qpNG9
/OmaFdkNHkvbjBWRZV1c
=kmNx
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
