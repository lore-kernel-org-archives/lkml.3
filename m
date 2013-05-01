Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3EARHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:07:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49556 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3EARG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:06:58 -0400
Date: Wed, 1 May 2013 10:06:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.11
Message-ID: <20130501170655.GA10008@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.11 kernel.

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

 Makefile                                        |    2=20
 arch/arm/include/asm/hardware/iop3xx.h          |    2=20
 arch/arm/kernel/sched_clock.c                   |    4=20
 arch/sparc/include/asm/pgtable_64.h             |    1=20
 arch/sparc/include/asm/switch_to_64.h           |    3=20
 arch/sparc/include/asm/tlbflush_64.h            |   37 ++++++-
 arch/sparc/kernel/smp_64.c                      |   41 +++++++-
 arch/sparc/mm/tlb.c                             |   39 +++++++
 arch/sparc/mm/tsb.c                             |   57 ++++++++---
 arch/sparc/mm/ultra.S                           |  119 +++++++++++++++++++=
-----
 drivers/net/bonding/bond_main.c                 |   65 ++++++++-----
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |    2=20
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |    1=20
 drivers/net/ethernet/marvell/Kconfig            |    2=20
 drivers/net/ethernet/marvell/mvneta.c           |    9 -
 drivers/net/usb/cdc_mbim.c                      |    2=20
 drivers/tty/tty_io.c                            |   14 ++
 fs/aio.c                                        |    2=20
 include/linux/netdevice.h                       |    2=20
 include/linux/skbuff.h                          |    7 +
 include/net/scm.h                               |    4=20
 kernel/trace/trace_selftest.c                   |   16 ---
 net/atm/common.c                                |    2=20
 net/ax25/af_ax25.c                              |    1=20
 net/bluetooth/af_bluetooth.c                    |    4=20
 net/bluetooth/rfcomm/sock.c                     |    1=20
 net/bluetooth/sco.c                             |    1=20
 net/caif/caif_socket.c                          |    2=20
 net/core/dev.c                                  |    4=20
 net/core/dev_addr_lists.c                       |    6 -
 net/core/rtnetlink.c                            |    4=20
 net/ipv4/esp4.c                                 |    6 -
 net/ipv4/ip_fragment.c                          |   15 ++-
 net/ipv4/syncookies.c                           |    4=20
 net/ipv4/tcp_input.c                            |   64 ++++++------
 net/ipv4/tcp_output.c                           |    8 +
 net/ipv6/addrconf.c                             |   27 +++++
 net/ipv6/reassembly.c                           |   13 ++
 net/ipv6/tcp_ipv6.c                             |    1=20
 net/irda/af_irda.c                              |    2=20
 net/iucv/af_iucv.c                              |    2=20
 net/l2tp/l2tp_ip6.c                             |    1=20
 net/llc/af_llc.c                                |    2=20
 net/netrom/af_netrom.c                          |    1=20
 net/nfc/llcp/sock.c                             |    3=20
 net/rose/af_rose.c                              |    1=20
 net/sched/sch_cbq.c                             |    5 -
 net/tipc/socket.c                               |    7 +
 net/unix/af_unix.c                              |    2=20
 49 files changed, 454 insertions(+), 166 deletions(-)

Aaro Koskinen (1):
      ARM: 7692/1: iop3xx: move IOP3XX_PERIPHERAL_VIRT_BASE

Balakumaran Kannan (1):
      net IPv6 : Fix broken IPv6 routing table after loopback down-up

Ben Greear (1):
      net: rate-limit warn-bad-offload splats.

Bj=F8rn Mork (1):
      net: cdc_mbim: remove bogus sizeof()

Christoph Paasch (1):
      ipv6/tcp: Stop processing ICMPv6 redirect messages

David S. Miller (1):
      sparc64: Fix race in TLB batch processing.

Dmitry Popov (1):
      tcp: incoming connections might use wrong route under synflood

Eric Dumazet (3):
      bonding: fix l23 and l34 load balancing in forwarding path
      tcp: call tcp_replace_ts_recent() from tcp_ack()
      net: drop dst before queueing fragments

Eric W. Biederman (1):
      af_unix: If we don't care about credentials coallesce all messages

Greg Kroah-Hartman (1):
      Linux 3.8.11

Hannes Frederic Sowa (1):
      atl1e: limit gso segment size to prevent generation of wrong ip lengt=
h fields

Jiri Slaby (2):
      TTY: do not update atime/mtime on read/write
      TTY: fix atime/mtime regression

Linus Torvalds (1):
      net: fix incorrect credentials passing

Mathias Krause (14):
      atm: update msg_namelen in vcc_recvmsg()
      ax25: fix info leak via msg_name in ax25_recvmsg()
      Bluetooth: fix possible info leak in bt_sock_recvmsg()
      Bluetooth: RFCOMM - Fix missing msg_namelen update in rfcomm_sock_rec=
vmsg()
      Bluetooth: SCO - Fix missing msg_namelen update in sco_sock_recvmsg()
      caif: Fix missing msg_namelen update in caif_seqpkt_recvmsg()
      irda: Fix missing msg_namelen update in irda_recvmsg_dgram()
      iucv: Fix missing msg_namelen update in iucv_sock_recvmsg()
      l2tp: fix info leak in l2tp_ip6_recvmsg()
      llc: Fix missing msg_namelen update in llc_ui_recvmsg()
      netrom: fix info leak via msg_name in nr_recvmsg()
      NFC: llcp: fix info leaks via msg_name in llcp_sock_recvmsg()
      rose: fix info leak via msg_name in rose_recvmsg()
      tipc: fix info leaks via msg_name in recv_msg/recv_stream

Michael Riesch (1):
      rtnetlink: Call nlmsg_parse() with correct header length

Patrick McHardy (1):
      netfilter: don't reset nf_trace in nf_reset()

Stephen Boyd (1):
      ARM: 7699/1: sched_clock: Add more notrace to prevent recursion

Steven Rostedt (1):
      tracing: Fix selftest function recursion accounting

Thomas Graf (1):
      tcp: Reallocate headroom if it would overflow csum_start

Thomas Petazzoni (1):
      net: mvmdio: add select PHYLIB

Vasily Averin (1):
      cbq: incorrect processing of high limits

Vlad Yasevich (1):
      net: count hw_addr syncs so that unsync works properly.

Wei Yongjun (1):
      esp4: fix error return code in esp_output()

Willy Tarreau (1):
      net: mvneta: fix improper tx queue usage in mvneta_tx()

Zhao Hongjiang (1):
      aio: fix possible invalid memory access when DEBUG is enabled

nikolay@redhat.com (2):
      bonding: fix bonding_masters race condition in bond unloading
      bonding: IFF_BONDING is not stripped on enslave failure


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgUuvAAoJEDjbvchgkmk+i9gQAJUBf/tpxyT0P8cvrmR0oSNl
VP4x13Gjs1EM1dWUWKdAY/Eu+K0myMrwY1tM1N0WajZ3n81syF0kQOBeH0IvfWz3
JoRVEfjxFa/orhHT3Jlv93Uw39bq3jKsIrRsTUqF61K0rEpy8vUR2IEvBkezv3cf
MvkRFw/Y0QPKEIfXMBcZtdkxh3kJPuPEwoJ3uq/aegTeMMxOq0esyCPtSjiur+86
wR9x44iUePpKw+HtwEI9jUsnxJIELC8yAsOFmdShPleFy3UZEibT7HuSXDxONrCF
7oHNbwatJnBJ7iQIEiPgnfsQPwBBA2qeFmLOxZMbFqIFIZZSriStgxFuxDxifAy6
P1nk6dPMe7nEJr01hNpOAryEPb3JIyD+0RyzPzuJv0UIR9yDuammmhekDS5Qxlng
ErGoPyLJcGo/SrcHb/RMpKX0pM0mj10+ju751wbnnQprD8lDerpfHka9owqrfg00
uLo8WttfHVxs96oz3OAdqpuQo6ZC5vlolmchkgZm5tLFk+CN1cDTpG5YQh+FbQ8p
bvq4c9SHKNbRhiI7sxWCMMLRsrhm08yLJpl/nST1m3yqHstDddrUQrP52EdXzwHp
9wiJIb7AtS7SmG4QK7b/l7Fjp+37lumzPAP1IozIN5acgAs1IAl0cg2ygdlK1Xta
D/SIcAO36uiTpNq2OBY2
=NcnF
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
