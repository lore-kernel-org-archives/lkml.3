Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbaDNS4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:56:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaDNSzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:55:55 -0400
Date: Mon, 14 Apr 2014 11:58:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.37
Message-ID: <20140414185852.GA25080@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.37 kernel.

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

 Makefile                                   |    2=20
 arch/arc/boot/dts/nsimosci.dts             |   12 +-
 arch/arc/configs/nsimosci_defconfig        |    1=20
 arch/m68k/Kconfig                          |    1=20
 arch/s390/Kconfig                          |    1=20
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |   29 -----
 arch/x86/crypto/ghash-clmulni-intel_glue.c |   14 ++
 drivers/cpufreq/cpufreq.c                  |   24 ++++
 drivers/cpufreq/cpufreq_governor.c         |    3=20
 drivers/cpufreq/powernow-k6.c              |  147 +++++++++++++++++++++++-=
-----
 drivers/cpuidle/driver.c                   |    3=20
 drivers/isdn/isdnloop/isdnloop.c           |   23 ++--
 drivers/net/ethernet/broadcom/tg3.c        |    5=20
 drivers/net/usb/usbnet.c                   |   33 +++---
 drivers/net/vxlan.c                        |    3=20
 drivers/net/xen-netback/netback.c          |    4=20
 drivers/vhost/net.c                        |   20 +++
 include/linux/cpufreq.h                    |    1=20
 include/linux/futex.h                      |    4=20
 include/linux/usb/usbnet.h                 |    2=20
 include/net/sock.h                         |    5=20
 init/Kconfig                               |    7 +
 kernel/futex.c                             |   14 ++
 lib/nlattr.c                               |   10 +
 net/8021q/vlan.c                           |    4=20
 net/8021q/vlan_dev.c                       |    6 -
 net/bridge/br_multicast.c                  |    6 +
 net/core/netpoll.c                         |    2=20
 net/core/rtnetlink.c                       |   10 +
 net/core/sock.c                            |    5=20
 net/ipv4/inet_fragment.c                   |    5=20
 net/ipv4/ipmr.c                            |   13 +-
 net/ipv4/tcp_output.c                      |   11 ++
 net/ipv6/addrconf.c                        |    5=20
 net/ipv6/exthdrs_offload.c                 |    4=20
 net/ipv6/icmp.c                            |    2=20
 net/ipv6/ip6_output.c                      |   18 +--
 net/ipv6/ip6mr.c                           |   13 +-
 net/ipv6/mcast.c                           |   11 +-
 net/ipv6/route.c                           |    2=20
 net/rds/iw.c                               |    3=20
 net/sctp/sm_make_chunk.c                   |    4=20
 net/sctp/sm_statefuns.c                    |    5=20
 net/socket.c                               |    4=20
 net/unix/af_unix.c                         |   17 ++-
 scripts/Makefile.headersinst               |   20 ++-
 scripts/headers_install.sh                 |    7 -
 security/selinux/hooks.c                   |   36 +++++--
 48 files changed, 412 insertions(+), 169 deletions(-)

Anton Nayshtut (1):
      ipv6: Fix exthdrs offload registration.

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Daniel Fu (1):
      cpuidle: Check the result of cpuidle_get_driver() against NULL

David Stevens (1):
      vxlan: fix potential NULL dereference in arp_reduce()

Eric Dumazet (2):
      net: unix: non blocking recvmsg() should not return -EINTR
      tcp: tcp_release_cb() should release socket ownership

Finn Thain (1):
      m68k: Skip futex_atomic_cmpxchg_inatomic() test

Florian Westphal (1):
      inet: frag: make sure forced eviction removes all frags

Greg Kroah-Hartman (1):
      Linux 3.10.37

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Heiko Carstens (1):
      futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() te=
st

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Li RongQing (1):
      netpoll: fix the skb check in pkt_is_ns

Linus L=FCssing (1):
      bridge: multicast: add sanity check for query source addresses

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Mikulas Patocka (3):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Mischa Jonker (1):
      ARC: [nsimosci] Change .dts to use generic 8250 UART

Nicolas Dichtel (4):
      kbuild: fix make headers_install when path is too long
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Nikolay Aleksandrov (1):
      net: fix for a race condition in the inet frag code

Oliver Neukum (1):
      usbnet: include wait queue head in device structure

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loa=
ded

Peter Bostr=F6m (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Stephen Boyd (1):
      cpufreq: Fix timer/workqueue corruption due to double queueing

Vineet Gupta (1):
      ARC: [nsimosci] Unbork console

Vlad Yasevich (2):
      tg3: Do not include vlan acceleration features in vlan_features
      vlan: Set hard_header_len according to available acceleration

Xiaoguang Chen (1):
      cpufreq: Fix governor start/stop race condition

YOSHIFUJI Hideaki (1):
      isdnloop: Validate NUL-terminated strings from user.

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragmen=
t properly


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTC/sAAoJEDjbvchgkmk+vZoP/iht9UVytYi/CwPsN1HN1D0B
DIfLwrmYgpwcgDxh0UH56wvjqwe2OVMJZWWbtos6UGBSAd0/bpHpsydfEfwe1Eq/
10hnq5RWbSQINJSBJBGuZj40Rf5APmPklKHtsWMWxU3CXcECRliZ0oRDYJssHp0G
HoBsfOXChF98IeAG2CX8e0mhEc165faTji2vkw2vVG0H+ZVA2sHR+Nuf5PTN7g73
n3KhF1Qb/vh345xrfs+Zfp300/gokGo8Xkv55SWmYmhpQDwVtvKwy0v/Id2r4oRC
i8E+TcMqZGQx1v0pXSuNIN7XYKI+lrM2jOP8AvvwgD6YpQHH+cJ9/OyOd9/dMhwL
xIkryG7C5ED7Vgocm/PYaATBC8cROdsUWN1eWuxyBt+vbO/bsgu4i355d+0AfxGP
H7KZ6HEn4I4G6DwNt4UoCVoXqWalrH9E2JyUTIth7YF2ZLHwUogBGCJe9ldSHFUA
ThZ7M3qehOAKL1qdhABgzn8mEJNQdyFaGBp2OkBPoVPF1XiicBrSMjUH2hny9Q91
HawyRELRplq/0+OKip+qJB2frtO9OWFF9d8dsl8voYKPlOehPfPLsNPbqyf7ji/l
ax1lA9FPmrMLAse1y2mWPdCLYbhLkL+/lo92Etm8XkILx2m5iYc4a/HWFnVfSy8r
YAE2WLSt/cGgPYyTWvZ7
=Tt2O
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
