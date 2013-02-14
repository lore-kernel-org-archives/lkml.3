Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3BNTMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:12:32 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:40951 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:12:30 -0500
Date: Thu, 14 Feb 2013 11:12:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.8
Message-ID: <20130214191226.GA23218@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.8 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.7.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 MAINTAINERS                                          |    6=20
 Makefile                                             |    2=20
 drivers/atm/iphase.h                                 |  146 +++++++++-----=
-----
 drivers/char/virtio_console.c                        |    3=20
 drivers/gpu/drm/nouveau/core/core/subdev.c           |    2=20
 drivers/gpu/drm/nouveau/core/include/core/object.h   |    7=20
 drivers/gpu/drm/nouveau/nouveau_drm.c                |    3=20
 drivers/infiniband/hw/qib/qib_qp.c                   |   11 -
 drivers/isdn/gigaset/capi.c                          |    2=20
 drivers/md/dm-thin.c                                 |   13 -
 drivers/media/usb/pwc/pwc-if.c                       |    6=20
 drivers/mfd/db8500-prcmu.c                           |    6=20
 drivers/net/can/c_can/c_can.c                        |    6=20
 drivers/net/ethernet/calxeda/xgmac.c                 |    4=20
 drivers/net/ethernet/intel/e1000e/defines.h          |    9 +
 drivers/net/ethernet/intel/e1000e/e1000.h            |    2=20
 drivers/net/ethernet/intel/e1000e/ethtool.c          |    2=20
 drivers/net/ethernet/intel/e1000e/hw.h               |    1=20
 drivers/net/ethernet/intel/e1000e/ich8lan.c          |   11 +
 drivers/net/ethernet/intel/e1000e/netdev.c           |   46 +++++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c           |   13 +
 drivers/net/ethernet/mellanox/mlx4/main.c            |   11 -
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |    2=20
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    2=20
 drivers/net/ethernet/realtek/r8169.c                 |    7=20
 drivers/net/ethernet/via/via-rhine.c                 |    8 -
 drivers/net/loopback.c                               |    5=20
 drivers/net/macvlan.c                                |    5=20
 drivers/net/wireless/ath/ath9k/ar9003_calib.c        |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.c          |    2=20
 drivers/net/wireless/ath/ath9k/hw.h                  |    1=20
 drivers/net/wireless/iwlwifi/dvm/tx.c                |   24 ---
 drivers/net/wireless/mwifiex/scan.c                  |    9 -
 drivers/net/wireless/rtlwifi/base.c                  |    7=20
 drivers/net/wireless/rtlwifi/usb.c                   |    4=20
 drivers/net/xen-netback/common.h                     |    3=20
 drivers/net/xen-netback/interface.c                  |   23 +-
 drivers/net/xen-netback/netback.c                    |  115 +++++++++-----
 drivers/regulator/max8998.c                          |    2=20
 drivers/regulator/of_regulator.c                     |    6=20
 drivers/regulator/s2mps11.c                          |    4=20
 include/linux/netdevice.h                            |    3=20
 include/net/ip.h                                     |    2=20
 net/bluetooth/smp.c                                  |   13 +
 net/core/dev.c                                       |    8 +
 net/core/pktgen.c                                    |    9 -
 net/core/request_sock.c                              |    2=20
 net/core/skbuff.c                                    |   44 +----
 net/ipv4/datagram.c                                  |   25 +++
 net/ipv4/ip_gre.c                                    |    6=20
 net/ipv4/ip_sockglue.c                               |    2=20
 net/ipv4/ping.c                                      |    1=20
 net/ipv4/raw.c                                       |    1=20
 net/ipv4/route.c                                     |   54 ++++++-
 net/ipv4/tcp.c                                       |   27 ++-
 net/ipv4/tcp_cong.c                                  |   14 +
 net/ipv4/tcp_input.c                                 |    8 -
 net/ipv4/tcp_ipv4.c                                  |    9 -
 net/ipv4/udp.c                                       |    1=20
 net/ipv6/addrconf.c                                  |    2=20
 net/ipv6/icmp.c                                      |   12 +
 net/ipv6/ip6_gre.c                                   |    2=20
 net/ipv6/ip6_output.c                                |    4=20
 net/ipv6/route.c                                     |    2=20
 net/packet/af_packet.c                               |   10 -
 net/sctp/endpointola.c                               |    5=20
 net/sctp/outqueue.c                                  |   12 +
 net/sctp/socket.c                                    |    2=20
 net/wireless/core.c                                  |    3=20
 69 files changed, 536 insertions(+), 290 deletions(-)

Alexander Stein (1):
      can: c_can: Set reserved bit in IFx_MASK2 to 1 on write

Alim Akhtar (1):
      regulator: s2mps11: fix incorrect register for buck10

Bing Zhao (1):
      mwifiex: fix incomplete scan in case of IE parsing error

Bruce Allan (1):
      e1000e: enable ECC on I217/I218 to catch packet buffer memory errors

Cong Wang (2):
      net: prevent setting ttl=3D0 via IP_TTL
      pktgen: correctly handle failures when adding a device

Daniel Borkmann (2):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

David S. Miller (1):
      via-rhine: Fix bugs in NAPI support.

Emmanuel Grumbach (1):
      Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"

Eric Dumazet (11):
      tcp: fix a panic on UP machines in reqsk_fastopen_remove
      macvlan: fix macvlan_get_size()
      tcp: fix incorrect LOCKDROPPEDICMPS counter
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue
      tcp: fix an infinite loop in tcp_slow_start()
      tcp: frto should not set snd_cwnd to 0
      tcp: splice: fix an infinite loop in tcp_read_sock()
      tcp: fix splice() and tcp collapsing interaction
      net: splice: avoid high order page splitting
      net: splice: fix __splice_segment()

Felix Fietkau (1):
      ath9k_hw: fix calibration issues on chainmask that don't include chai=
n 0

Greg Kroah-Hartman (1):
      Linux 3.7.8

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_ge=
t_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo J=E4rvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Johan Hedberg (1):
      Bluetooth: Fix handling of unexpected SMP PDUs

Larry Finger (2):
      rtlwifi: Fix the usage of the wrong variable in usb.c
      rtlwifi: Fix scheduling while atomic bug

Linus Walleij (1):
      mfd: db8500-prcmu: Fix irqdomain usage

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Marcin Slusarz (1):
      drm/nouveau: add lockdep annotations

Marek Szyprowski (1):
      regulator: max8998: fix incorrect min_uV value for ldo10

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Mauro Carvalho Chehab (1):
      media: pwc-if: must check vb2_queue_init() success

Mike Marciniszyn (1):
      IB/qib: Fix for broken sparse warning fix

Mike Snitzer (1):
      dm thin: fix queue limits stacking

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to firmwar=
e defaults

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Pravin B Shelar (1):
      IP_GRE: Fix kernel panic in IP_GRE with GRE csum.

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames

Romain KUNTZ (1):
      ipv6: fix header length calculation in ip6_append_data()

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route

Sjur Br=E6ndeland (1):
      virtio_console: Don't access uninitialized data.

Stanislaw Gruszka (1):
      net, wireless: overwrite default_ethtool_ops

Steffen Klassert (6):
      ipv4: Remove output route check in ipv4_mtu
      ipv4: Don't update the pmtu on mtu locked routes
      ipv6: Add an error handler for icmp6
      ipv4: Invalidate the socket cached route on pmtu events if possible
      ipv4: Add a socket release callback for datagram sockets
      ipv4: Fix route refcount on pmtu discovery

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

Stephen Warren (1):
      regulator: clear state each invocation of of_regulator_match

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Ter=E4s (1):
      r8169: remove the obsolete and incorrect AMD workaround

Tommi Rantala (1):
      ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()

Willy Tarreau (1):
      tcp: don't abort splice() after small transfers

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode

Yuchung Cheng (1):
      tcp: detect SYN/data drop when F-RTO is disabled


--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHTcaAAoJEDjbvchgkmk+FcMP/jbVYblMTZWdVliTGTPtLdeg
05XeamPs7/zICl+i37BVNMOVppAaBaIJNN4EOADgjaeD496ctlBxqClcX11FI33N
aGHkzw5ioGCmVs6qPmKZUg/XGpnkH0Z5fM2VWsJXLcO9S2E4HSR7DX3Y8JT5qPfB
X5ULB7vECciAp4uVl3Vufy7USsrs3LHvxE0CMiwHTMdiubcXguzi2bylpQfpN0lC
t8VM2+WC6wkCZStYejE9zInPoUfQqx6nyttNQFWmfU6Wkvm2tyjAGccObGJs57Ny
A6xptiXb8AOVzgQxsiTzwnow7J8SStmC3WFv/OOyAxozLVBmJCjrAjFmlK7ygtRj
bc2A7rjtk1tuJxIc50DAu4JLhD03YKm9fMt0EVXn7LhWCagPXUcMzlhMpJTID11e
8bTEx525UYYL50LSnMqqtzhxRrcg9zE75BnbdudddQ0+cbzdO/0RMV0QnJlfPSeq
7DSoaLe+CrbQkMOltnibNibTODLoATLj7sO4NWAGGCEcm0VHqSeEEU7hww02iLTb
pOqCZwpRLfuK7cGOEiczxQADPY8d2/8yj2m917gBF1PVqzrN6Y97afTXfvU05f+E
OBS2PyK2VwltLbDrKW7yzDFTnfoZ66H41TsmYCPFzoR0aL2N/PiaBfJMJn1eB3tT
T/sSPwsBFxAlWAriQA4l
=R+Rp
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
