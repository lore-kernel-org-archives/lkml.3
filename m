Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaFZTgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaFZTgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:36:07 -0400
Date: Thu, 26 Jun 2014 15:25:35 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.45
Message-ID: <20140626192535.GA24676@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.45 kernel.

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

 Makefile                                  |    2=20
 arch/arm/mach-at91/sysirq_mask.c          |   22 ++-
 arch/mips/kvm/kvm_mips.c                  |    2=20
 arch/sparc/net/bpf_jit_comp.c             |    8 -
 arch/x86/kvm/lapic.c                      |   62 +++++++---
 crypto/crypto_user.c                      |    2=20
 drivers/connector/cn_proc.c               |    2=20
 drivers/hv/hv_balloon.c                   |   29 ++++-
 drivers/iio/adc/at91_adc.c                |   16 +-
 drivers/iio/adc/max1363.c                 |   16 +-
 drivers/iio/magnetometer/ak8975.c         |    9 -
 drivers/net/ethernet/mellanox/mlx4/main.c |  170 +++++++++++++++++--------=
-----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    1=20
 drivers/net/macvlan.c                     |    1=20
 drivers/net/team/team.c                   |    7 +
 drivers/net/usb/qmi_wwan.c                |    7 +
 drivers/net/vxlan.c                       |    4=20
 drivers/rtc/rtc-at91rm9200.c              |   16 ++
 drivers/scsi/scsi_netlink.c               |    2=20
 drivers/staging/iio/light/tsl2x7x_core.c  |    8 +
 drivers/target/iscsi/iscsi_target_auth.c  |   10 +
 drivers/usb/class/cdc-acm.c               |   96 ++++++++++------
 drivers/usb/class/cdc-acm.h               |    2=20
 include/linux/if_team.h                   |    1=20
 include/linux/netlink.h                   |   14 +-
 include/linux/sock_diag.h                 |    2=20
 include/net/inetpeer.h                    |    9 -
 include/net/sock.h                        |    5=20
 include/sound/core.h                      |    2=20
 include/uapi/sound/compress_offload.h     |    2=20
 kernel/audit.c                            |    4=20
 kernel/time/tick-sched.c                  |    4=20
 lib/lzo/lzo1x_decompress_safe.c           |   62 +++++++---
 lib/nlattr.c                              |    4=20
 net/can/gw.c                              |    4=20
 net/core/dev.c                            |    5=20
 net/core/rtnetlink.c                      |   43 +++++--
 net/core/sock.c                           |   49 ++++++++
 net/core/sock_diag.c                      |    4=20
 net/dcb/dcbnl.c                           |    2=20
 net/decnet/dn_dev.c                       |    4=20
 net/decnet/dn_fib.c                       |    4=20
 net/decnet/netfilter/dn_rtmsg.c           |    2=20
 net/ipv4/datagram.c                       |   20 ++-
 net/ipv4/ipip.c                           |    5=20
 net/ipv4/tcp_input.c                      |   11 -
 net/ipv6/ip6_tunnel.c                     |    1=20
 net/ipv6/output_core.c                    |   11 -
 net/ipv6/sit.c                            |    5=20
 net/mac80211/iface.c                      |    1=20
 net/netfilter/nfnetlink.c                 |    2=20
 net/netlink/af_netlink.c                  |   80 +++++++++++++-
 net/netlink/genetlink.c                   |    2=20
 net/packet/diag.c                         |    7 +
 net/phonet/pn_netlink.c                   |    8 -
 net/sched/act_api.c                       |    2=20
 net/sched/cls_api.c                       |    2=20
 net/sched/sch_api.c                       |    6 -
 net/sctp/associola.c                      |    2=20
 net/tipc/netlink.c                        |    2=20
 net/xfrm/xfrm_user.c                      |    2=20
 security/integrity/evm/evm_main.c         |   12 +-
 security/integrity/ima/ima_crypto.c       |   32 +++++
 sound/core/control.c                      |   78 +++++++++----
 sound/core/init.c                         |    1=20
 sound/pci/hda/patch_realtek.c             |   10 +
 sound/soc/codecs/max98090.c               |    3=20
 67 files changed, 701 insertions(+), 324 deletions(-)

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Bj=F8rn Mork (1):
      net: qmi_wwan: add Olivetti Olicard modems

Boris BREZILLON (2):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
      ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Dan Carpenter (1):
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Popov (1):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Eric Dumazet (3):
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()

Eric W. Biederman (6):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to packet_=
diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink messa=
ges
      netlink: Only check file credentials for implicit destinations

Greg Kroah-Hartman (2):
      lzo: properly check for overruns
      Linux 3.10.45

James Hogan (1):
      MIPS: KVM: Allocate at least 16KB for exception handlers

Jiri Pirko (1):
      team: fix mtu setting

Johan Hovold (7):
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max1161=
0 and max11611.

K. Y. Srinivasan (1):
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC891 codec

Lars-Peter Clausen (5):
      ALSA: control: Protect user controls against concurrent access
      ALSA: control: Fix replacing user controls
      ALSA: control: Don't access controls outside of protected regions
      ALSA: control: Handle numid overflow
      ALSA: control: Make sure that id->index does not overflow

Liam Girdwood (1):
      ASoC: max98090: Fix reset at resume time

Mario Schuknecht (1):
      staging: iio: tsl2x7x_core: fix proximity treshold

Michal Schmidt (2):
      netlink: rate-limit leftover bytes warning and print process name
      rtnetlink: fix userspace API breakage for iproute2 < v3.9.0

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value

Nicholas Bellinger (1):
      iscsi-target: Reject mutual authentication with reflected CHAP_C

Paolo Bonzini (1):
      KVM: lapic: sync highest ISR to hardware apic on EOI

Peter Meerwald (1):
      iio: Fix endianness issue in ak8975_read_axis()

Thomas Gleixner (1):
      nohz: Fix another inconsistency between CONFIG_NO_HZ=3Dn and nohz=3Do=
ff

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size =
of struct for all platform.

Wei Yang (2):
      net/mlx4_core: pass pci_device_id.driver_data to __mlx4_init_one duri=
ng reset
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yuchung Cheng (1):
      tcp: fix cwnd undo on DSACK in F-RTO


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrHOvAAoJEDjbvchgkmk+CNYQAIV3v4xyjGMcyKuH2F6Igqkj
SOX+wv9r4biJe0wWNKv9HTpzuWQDxVe1mYtQR43xqnzm74CMgeICJRAXoWBCrO/E
aAQbLs2abrCGhr1pcAC1mHtXq/aA+hoQRoDegV1iwwSK8jVIWQh6HYR6c3zzOS//
iNMy44bElFBYLpHhFYGESIMVwsIjxf9/NjJKZjWgoBwFEwqZ+vGPuroPslkicKqO
upZurBzsP8DhflsbAXDKPu9RE7brrDwwjgKBUAPGHCVRHTyn+UqJ7XD7jMUKlZC5
Gda04lmFGmUcyaIx7t0H3GC1nNpKeL/rbHNtiUsSU+kGOboqC226hi9zHTGiBWyV
GsQfRzwOwIqVOGuAUAHvpqPt8ALyxsGoXPtVa9uJEQaiDLy0VIXbxySSyzSeoh+v
Mm/sInwO+wgxFkas1xaAkJVA9brwnzV+kVsXiXzxmGnIMFcpL6WdRqNa9SCGqmAA
QJv28eTEkO8jpKDIpMuk9mMUd/dnHOuWIOyu1pA1oCyBtnCqIXnAaGDTyOJ3yTGx
RSOkL4sLtcAPS1555axL85XyauK1DB5gajcUQfAmLJGQrxjDlukop7CODV+2b3Pn
TWZD5IuGdMlDSFB9nvFn5wV+tCTS1qWvdGMOwGm04oFPk1uBMzWFCNa8GT9SRRLl
xgr73WfC3A+5sxfiNt2I
=7Wsh
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
