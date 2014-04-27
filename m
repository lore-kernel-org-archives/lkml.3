Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaD0AhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:37:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaD0AhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:37:12 -0400
Date: Sat, 26 Apr 2014 17:37:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.88
Message-ID: <20140427003754.GA3157@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.88 kernel.

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

 Makefile                            |    2 +-
 arch/sparc/Kconfig                  |    2 +-
 arch/sparc/include/asm/uaccess_64.h |    4 ++--
 arch/sparc/kernel/pci.c             |    4 ++--
 arch/sparc/kernel/syscalls.S        |    4 ++--
 drivers/char/ipmi/ipmi_bt_sm.c      |    2 +-
 drivers/isdn/isdnloop/isdnloop.c    |   23 +++++++++++++++--------
 drivers/net/xen-netback/netback.c   |    4 ++--
 drivers/vhost/net.c                 |   20 +++++++++++++++++++-
 fs/jffs2/compr_rtime.c              |    4 ++--
 fs/jffs2/nodelist.h                 |    2 +-
 fs/jffs2/nodemgmt.c                 |   14 ++++++++++----
 kernel/exit.c                       |   15 +++++++++++----
 lib/nlattr.c                        |   10 ++++++++--
 net/8021q/vlan_dev.c                |    3 +++
 net/bluetooth/hci_event.c           |    8 +++++++-
 net/bridge/br_multicast.c           |    6 ++++++
 net/ipv6/addrconf.c                 |    5 ++++-
 net/ipv6/icmp.c                     |    2 +-
 net/ipv6/ip6_output.c               |   18 ++++++++----------
 net/ipv6/mcast.c                    |   11 ++++++-----
 net/ipv6/route.c                    |    2 +-
 net/rds/iw.c                        |    3 ++-
 net/sctp/sm_make_chunk.c            |    4 ++--
 net/sctp/sm_statefuns.c             |    5 -----
 net/socket.c                        |    4 ++++
 net/unix/af_unix.c                  |   17 ++++++++++++-----
 27 files changed, 133 insertions(+), 65 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
      sparc64: don't treat 64-bit syscall return codes as 32-bit

Eric Dumazet (1):
      net: unix: non blocking recvmsg() should not return -EINTR

Greg Kroah-Hartman (1):
      Linux 3.4.88

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Li Zefan (2):
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
      jffs2: remove from wait queue after schedule()

Linus L=FCssing (1):
      bridge: multicast: add sanity check for query source addresses

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael S. Tsirkin (2):
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Oleg Nesterov (1):
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Gortmaker (1):
      sparc32: fix build failure for arch_jump_label_transform

Peter Bostr=F6m (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

YOSHIFUJI Hideaki (1):
      isdnloop: Validate NUL-terminated strings from user.

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragmen=
t properly

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows o=
n Simba-bridges


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXFFhAAoJEDjbvchgkmk+TJAP/juVSJrtNTddde9N0tOk29ky
1WBcuzNnNL/6c9IcUEVscW8Mz4N7mePz6KrKvJFuIl+1YUYib5znZXqoSo1HvAYM
cCpUHd2AWy8Z9/sp4b440pRIDoA3xNvV6PK6UHxkwJO4ssZhHv32ec2cQK1aycZC
0iK8Sm+Sg8flnKd/D+TtTGBg0qVTPk87cqCZEzqd2h/Q3cHKZ47+AlXfeLMUooNF
2ORbqBjUKu5DDd6bEE7EJNgVZxDacO97GZlhrTDLMrqWuWN0EHVJ6BmzTiuZ0H2Q
HAwTJXzZcuQPx7mwTlet3QkboRirEha+P8WNfjI4/RN6l74R9uNfhZ/9VPMQ9KiT
zePR9WjD3cL5iz/AYz3wXqF9UFVC9bFifh4jDS39lE3ihQmg7dz6G18Xz06DNRnw
dKKWoLCgYCN6UjAYQ3ExQ0gBfqtujfpYjSICpbtHQBIIYlVljvrWNDtt8MIiLK5H
6qLrjDRjabwcQAmuDKfhtx8QVGdqIAYMMC47wy7Jsbiqg0lbL40oKR7g7XuHK83s
7TpTFwwL6r0mSe58PeNqEFkuQzGSb1qovaaslSqMWGToBBFZDt8wvAurpw6VKAOv
3Ws2GhhSB6r5sgtasmOORddfBy/oKG4gDY5/UJ3ODLZupEkw0Kuvxvn7GVRiYRp+
pA7t1hK/Ps1wYUUHo5EJ
=vnel
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
