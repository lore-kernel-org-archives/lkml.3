Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230Ab3BNTM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:12:58 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54676 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNTM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:12:56 -0500
Date: Thu, 14 Feb 2013 11:12:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.31
Message-ID: <20130214191253.GA24893@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.31 kernel.

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

 MAINTAINERS                                          |    6=20
 Makefile                                             |    2=20
 arch/x86/include/asm/efi.h                           |    1=20
 arch/x86/kernel/reboot.c                             |    2=20
 arch/x86/kernel/setup.c                              |   28 +--
 arch/x86/platform/efi/efi.c                          |   57 ++++---
 drivers/acpi/osl.c                                   |    2=20
 drivers/atm/iphase.h                                 |  146 +++++++++-----=
-----
 drivers/char/virtio_console.c                        |    3=20
 drivers/firmware/dmi_scan.c                          |    2=20
 drivers/firmware/efivars.c                           |    4=20
 drivers/firmware/iscsi_ibft_find.c                   |    2=20
 drivers/gpu/drm/radeon/radeon_device.c               |    3=20
 drivers/isdn/gigaset/capi.c                          |    2=20
 drivers/net/ethernet/broadcom/tg3.c                  |   62 +++++---
 drivers/net/ethernet/calxeda/xgmac.c                 |    4=20
 drivers/net/ethernet/emulex/benet/be.h               |    5=20
 drivers/net/ethernet/emulex/benet/be_main.c          |   56 +++++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c           |   13 +
 drivers/net/ethernet/mellanox/mlx4/main.c            |   11 -
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c |    2=20
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    2=20
 drivers/net/ethernet/realtek/r8169.c                 |    7=20
 drivers/net/ethernet/via/via-rhine.c                 |    8 -
 drivers/net/loopback.c                               |    5=20
 drivers/net/wireless/rtlwifi/base.c                  |    7=20
 drivers/net/wireless/rtlwifi/usb.c                   |    4=20
 drivers/net/xen-netback/common.h                     |    3=20
 drivers/net/xen-netback/interface.c                  |   23 +-
 drivers/net/xen-netback/netback.c                    |  115 +++++++++-----
 drivers/platform/x86/ibm_rtl.c                       |    2=20
 drivers/platform/x86/samsung-laptop.c                |    4=20
 drivers/scsi/isci/init.c                             |    2=20
 include/linux/efi.h                                  |   24 ++-
 init/main.c                                          |    4=20
 kernel/resource.c                                    |   50 ++++--
 net/bluetooth/smp.c                                  |   13 +
 net/bridge/br_netfilter.c                            |    3=20
 net/core/pktgen.c                                    |    9 -
 net/ipv4/ip_sockglue.c                               |    2=20
 net/ipv4/tcp_input.c                                 |    5=20
 net/ipv6/addrconf.c                                  |    2=20
 net/ipv6/ip6_output.c                                |    4=20
 net/ipv6/route.c                                     |    3=20
 net/packet/af_packet.c                               |   10 -
 net/sctp/endpointola.c                               |    5=20
 net/sctp/outqueue.c                                  |   12 +
 net/sctp/socket.c                                    |    2=20
 48 files changed, 460 insertions(+), 283 deletions(-)

Cong Wang (2):
      net: prevent setting ttl=3D0 via IP_TTL
      pktgen: correctly handle failures when adding a device

Daniel Borkmann (2):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

David S. Miller (1):
      via-rhine: Fix bugs in NAPI support.

Eric Dumazet (3):
      netxen: fix off by one bug in netxen_release_tx_buffer()
      net: loopback: fix a dst refcounting issue
      tcp: frto should not set snd_cwnd to 0

Greg Kroah-Hartman (1):
      Linux 3.4.31

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

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Matt Fleming (2):
      efi: Make 'efi_enabled' a function to query EFI facilities
      samsung-laptop: Disable on EFI hardware

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mo=
de
      tg3: Fix crc errors on jumbo frame receive

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to firmwar=
e defaults

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames

Romain KUNTZ (1):
      ipv6: fix header length calculation in ip6_append_data()

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.

Sjur Br=E6ndeland (1):
      virtio_console: Don't access uninitialized data.

Somnath Kotur (1):
      be2net: Fix to trim skb for padded vlan packets to workaround an ASIC=
 Bug

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Ter=E4s (1):
      r8169: remove the obsolete and incorrect AMD workaround

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHTc1AAoJEDjbvchgkmk+OLcQAI+cPEi9VsteIifrn4q2Rkrj
WjZ1TdzrZiYYmw2vlWpwfbwx5RHiP0ak+JilI7Xd7vp4yLpRmy5xuozzxSMmaXRY
iZovVoM2a5exI2nquFLB1LOk8NgaF/8NpIWcWiObYalXYQAwvpZJ6GkO/qau6dUz
PJmWG9bCV4qcZKpHnabINXyY1eYQr2tGHn8c7jsAuKXtfXI2q0b0gkwpfS/7A+wL
w36dqrDxByzE91VP2qJpiFH1adWB4tKrx8pYFnJjyC8kJ9nnPf82D7a79pWUmKdw
WSj8B99ibOhwT4wh4IdXvCTjxSHNhH1R9XnM3uUkRBKibaxy2WKWKaXebmXqzgPM
zadukzZMu3cgF/iyw+lvseILO7q0/2qLICVE8dhENm4xoXH3BkCKg0zoMASD4hJi
ubSxhzFUQJzppdRxXPyDwc5zYvSDyOyWtOATg6P59v/tQA5wuRs+4ooCIYmBhe1B
eR/SBiQ4hBLdYYx/rMfqhSMEjJNVnvS7Fw5pT6gXEZ58iV2dAkFkgslSTuvR4msV
+y7/CVcWcbu0mYAIGUjfPeDRmnSK1lJh6YSW1t8HWwmiY/ITSrjb6ewI9OhVn3mh
M+pQaT4b/FBCB9aW18SUHYKHlKmIS0edIHbrMsMHQsOWMuMnn4L5hrO6kVLWCJ5I
H72bQLhBtJWIcmv528sN
=US0t
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
