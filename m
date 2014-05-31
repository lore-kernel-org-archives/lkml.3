Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaEaTrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:47:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbaEaTrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:47:42 -0400
Date: Sat, 31 May 2014 12:47:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.41
Message-ID: <20140531194739.GA8562@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.41 kernel.

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

 Makefile                                       |    2=20
 arch/arm/configs/multi_v7_defconfig            |    2=20
 arch/parisc/kernel/syscall_table.S             |    2=20
 arch/powerpc/lib/crtsavres.S                   |  186 ++++++++++++++++++++=
+++++
 block/blk-core.c                               |    2=20
 drivers/block/rbd.c                            |    2=20
 drivers/firewire/ohci.c                        |   31 +---
 drivers/gpu/drm/qxl/qxl_ttm.c                  |    1=20
 drivers/gpu/drm/radeon/radeon_display.c        |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c        |   22 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c             |    5=20
 drivers/md/raid1.c                             |   17 +-
 drivers/net/bonding/bond_main.c                |    1=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c |    3=20
 drivers/net/ethernet/broadcom/tg3.c            |    4=20
 drivers/net/macvlan.c                          |    9 -
 drivers/net/usb/cdc_mbim.c                     |   39 +++--
 drivers/net/usb/qmi_wwan.c                     |   38 ++++-
 drivers/scsi/megaraid/megaraid_mm.c            |    2=20
 drivers/scsi/scsi_scan.c                       |  112 +++++++++------
 drivers/scsi/scsi_sysfs.c                      |   20 +-
 drivers/usb/class/cdc-acm.c                    |   28 ++-
 drivers/usb/serial/cp210x.c                    |    1=20
 drivers/usb/serial/ftdi_sio.c                  |   33 ++++
 drivers/usb/serial/ftdi_sio_ids.h              |   37 ++++
 drivers/usb/serial/io_ti.c                     |   50 ++++--
 drivers/usb/serial/option.c                    |   83 ++++++++++-
 drivers/usb/serial/qcserial.c                  |    9 +
 drivers/usb/serial/sierra.c                    |    1=20
 drivers/usb/serial/usb-serial.c                |    4=20
 drivers/usb/serial/usb_wwan.c                  |    9 -
 drivers/video/tgafb.c                          |   15 +-
 fs/file_table.c                                |    4=20
 fs/open.c                                      |   26 ---
 include/asm-generic/pgtable.h                  |   31 +++-
 include/linux/list.h                           |   16 ++
 include/linux/sock_diag.h                      |    2=20
 include/net/ip6_route.h                        |    5=20
 include/net/netfilter/nf_conntrack_extend.h    |    4=20
 include/net/sctp/structs.h                     |    4=20
 include/scsi/scsi_device.h                     |    3=20
 include/trace/events/block.h                   |   33 ++++
 kernel/events/core.c                           |    3=20
 kernel/trace/blktrace.c                        |   20 +-
 kernel/tracepoint.c                            |    6=20
 mm/hugetlb.c                                   |    1=20
 net/8021q/vlan_dev.c                           |   46 +++++-
 net/bridge/br_input.c                          |    2=20
 net/bridge/br_netlink.c                        |   15 ++
 net/bridge/br_vlan.c                           |    7=20
 net/bridge/netfilter/ebtables.c                |    5=20
 net/core/dev.c                                 |    2=20
 net/core/filter.c                              |    6=20
 net/core/rtnetlink.c                           |   33 ++--
 net/core/skbuff.c                              |   12 -
 net/core/sock_diag.c                           |    4=20
 net/ipv4/fib_semantics.c                       |    2=20
 net/ipv4/ip_forward.c                          |    4=20
 net/ipv4/ip_gre.c                              |    2=20
 net/ipv4/ip_vti.c                              |    2=20
 net/ipv4/netfilter/arp_tables.c                |    6=20
 net/ipv4/netfilter/ip_tables.c                 |    6=20
 net/ipv4/ping.c                                |   15 +-
 net/ipv4/route.c                               |    4=20
 net/ipv4/tcp_cubic.c                           |    2=20
 net/ipv6/ip6_fib.c                             |    3=20
 net/ipv6/ip6_gre.c                             |   10 +
 net/ipv6/ip6_output.c                          |    6=20
 net/ipv6/ip6_tunnel.c                          |    2=20
 net/ipv6/netfilter/ip6_tables.c                |    6=20
 net/ipv6/route.c                               |    5=20
 net/l2tp/l2tp_ppp.c                            |    4=20
 net/packet/diag.c                              |    2=20
 net/sctp/auth.c                                |   17 --
 net/sctp/endpointola.c                         |    3=20
 net/sctp/protocol.c                            |    7=20
 net/sctp/sm_make_chunk.c                       |   32 ++--
 net/sctp/sm_statefuns.c                        |    6=20
 net/sctp/socket.c                              |   96 +++++++++---
 net/sctp/sysctl.c                              |   38 ++++-
 scripts/mod/modpost.c                          |    8 -
 81 files changed, 1040 insertions(+), 309 deletions(-)

Al Viro (1):
      don't bother with {get,put}_write_access() on non-regular files

Aleksander Morgado (2):
      net: qmi_wwan: fix Cinterion PLXX product ID
      net: qmi_wwan: add support for Cinterion PXS8 and PHS8

Alex Deucher (1):
      drm/radeon: call drm_edid_to_eld when we update the edid

Andreas Schwab (1):
      powerpc: Add vr save/restore functions

Andrew Lutomirski (1):
      net: Fix ns_capable check in sock_diag_put_filterinfo

Andrey Vagin (1):
      netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len

Bj=F8rn Mork (17):
      usb: qcserial: add Sierra Wireless EM7355
      usb: qcserial: add Sierra Wireless MC73xx
      usb: qcserial: add Sierra Wireless MC7305/MC7355
      usb: option: add Olivetti Olicard 500
      usb: option: add Alcatel L800MA
      usb: option: add and update a number of CMOTech devices
      net: cdc_mbim: handle unaccelerated VLAN tagged frames
      net: qmi_wwan: fixup Sierra Wireless MC8305 entry
      net: qmi_wwan: add Option GTM681W
      net: qmi_wwan: add TP-LINK MA260
      net: qmi_wwan: add Sierra Wireless EM7355
      net: qmi_wwan: add Sierra Wireless MC73xx
      net: qmi_wwan: add Sierra Wireless MC7305/MC7355
      net: qmi_wwan: add Olivetti Olicard 500
      net: qmi_wwan: add Alcatel L800MA
      net: qmi_wwan: add a number of CMOTech devices
      net: qmi_wwan: add a number of Dell devices

Christopher Friedt (1):
      drm/vmwgfx: correct fb_fix_screeninfo.line_length

Dan Carpenter (1):
      SCSI: megaraid: missing bounds check in mimd_to_kioc()

Daniel Borkmann (2):
      net: sctp: wake up all assocs if sndbuf policy is per socket
      net: sctp: test if association is dead in sctp_wake_up_waiters

Daniele Palmas (1):
      usb: option driver, add support for Telit UE910v2

David Gibson (2):
      rtnetlink: Warn when interface's information won't fit in our packet
      rtnetlink: Only supply IFLA_VF_PORTS information when RTEXT_FILTER_VF=
 is set

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket

Enrico Mioso (2):
      qmi_wwan: add ONDA MT689DC device ID (fwd)
      net: qmi_wwan: Olivetti Olicard 200 support

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
      net-gro: reset skb->truesize in napi_reuse_skb()

Fabio Porcedda (1):
      net: qmi_wwan: add Telit LE920 newer firmware support

Florian Westphal (3):
      net: core: don't account for udp header size when computing seglen
      net: ipv4: ip_forward: fix inverted local_df test
      net: ipv6: send pkttoobig immediately if orig frag size > mtu

Greg Kroah-Hartman (1):
      Linux 3.10.41

Helge Deller (1):
      parisc: fix epoll_pwait syscall on compat kernel

Ilya Dryomov (1):
      rbd: fix error paths in rbd_img_request_fill()

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo frames are en=
abled

James Bottomley (2):
      scsi: fix our current target reap infrastructure
      SCSI: dual scan thread bug fix

Johan Hovold (4):
      USB: usb_wwan: fix handling of missing bulk endpoints
      Revert "USB: serial: add usbid for dell wwan card to sierra.c"
      USB: serial: fix sysfs-attribute removal deadlock
      USB: io_ti: fix firmware download on big-endian machines

Julian Anastasov (1):
      ipv4: return valid RTA_IIF on ip route get

Kumar Sundararajan (1):
      ipv6: fib: fix fib dump restart

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack

Maarten Lankhorst (1):
      drm/qxl: unset a pointer in sync_obj_unref

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end of the message

Mel Gorman (1):
      mm: use paravirt friendly ops for NUMA hinting ptes

Michael Ulbricht (1):
      USB: cdc-acm: Remove Motorola/Telit H24 serial interfaces from ACM dr=
iver

Michele Baldessari (1):
      USB: serial: ftdi_sio: add id for Brainboxes serial cards

Mikulas Patocka (1):
      tgafb: fix mode setting with fbset

Mizuma, Masayoshi (1):
      mm/hugetlb.c: add cond_resched_lock() in return_unused_surplus_pages()

NeilBrown (1):
      md/raid1: r1buf_pool_alloc: free allocate pages when subsequent alloc=
ation fails.

Nicolas Dichtel (3):
      gre: don't allow to add the same tunnel twice
      vti: don't allow to add the same tunnel twice
      ip6_gre: don't allow to remove the fb_tunnel_dev

Oleg Nesterov (1):
      list: introduce list_next_entry() and list_prev_entry()

Olof Johansson (1):
      ARM: multi_v7_defconfig: enable ARM_ATAG_DTB_COMPAT

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.

Raymond Wanyoike (1):
      net: qmi_wwan: add ZTE MF667

Roman Pen (1):
      blktrace: fix accounting of partially completed requests

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation

Soren Brinkmann (1):
      arm: multi_v7_defconfig: Enable initrd/initramfs support

Stefan Richter (2):
      firewire: ohci: beautify some macro definitions
      firewire: ohci: fix probe failure with Agere/LSI controllers

Steven Rostedt (Red Hat) (1):
      tracepoint: Do not waste memory on mods with no tracepoints

Susant Sahani (1):
      ip6_tunnel: fix potential NULL pointer dereference

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object bound=
aries v2

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails

Toshiaki Makita (2):
      bridge: Fix double free and memory leak around br_allowed_ingress
      bridge: Handle IFLA_ADDRESS correctly when creating bridge device

Tristan Bruns (1):
      USB: cp210x: Add 8281 (Nanotec Plug & Drive)

Vlad Yasevich (2):
      net: sctp: cache auth_enable per endpoint
      Revert "macvlan : fix checksums error when we are in bridge mode"

Wang, Xiaoming (1):
      net: ipv4: current group_info should be put after using.

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup

dingtianhong (1):
      vlan: Fix lockdep warning when vlan dev handle notification


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTijHbAAoJEDjbvchgkmk+5vMP/1l8hSFEfcP9H/DvYx9Xft9+
qzX/Yv6jHOKQaN4KSft1li9P7TWcRfzOkbh9m8cfW8iA0hSvFIvFB902fAzYZ2iM
KUa5ALLkIJayxxwsnX8lp8cQMxJOYVdxBeWqAXLQemIJMXGIK5etSI9yt59UQhfS
JGFWFl71qpnK7nbcb5at9HyC5vNqHPDzOrKckKbOijjXU7R+CcI+3NQmlw4fBP1T
iVJLS03MuezF5pOQW/kIdL+OdW+VrkCm1KJMyKSFTjHl+3xOkOcMyUdW+dc3aIwh
aCC2WAT4unX/tXQ3wxY7CgHW7x7M+CJiHO2uSWcAkNr40VrLpOJIg9f1jD+dULcP
qxfiNTLIAt1tLfWvUOzcSkV8Er2XvsUvJAQrxp2FX/3MKkeJAX0NRiq/wMy2mpc1
YtS9sAiAvhsLGFhIdkqZLqizViaJrpj0iYl6K5CrLsicLCOltr63mvg5QV2IEUXV
UO9NA/CiFse+tgQ1LET1YGBbrS3Jp4XoSjqjtzb29tEEuojlLnKjszivbyztBw9/
Dd12+6jjPcZ7IXd0Pcbwezt6AvXzBsvmvWgy9qmoEN9f1fQHSTIzRtG+gE/rcrTq
i/zSmAaG2amsXLDUJ3sVPFt50SrBv/lq8f44RKpP714lUqHNwYgdf1M51qNW4WV9
7oNTR31aKqLSwMw60X6a
=tlK+
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
