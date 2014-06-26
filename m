Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaFZTiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:38:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaFZTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:38:22 -0400
Date: Thu, 26 Jun 2014 15:26:18 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.9
Message-ID: <20140626192618.GA24739@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.9 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/ABI/testing/ima_policy            |    2=20
 Makefile                                        |    2=20
 arch/arm/mach-at91/sysirq_mask.c                |   22 +--
 arch/mips/kvm/kvm_mips.c                        |    2=20
 arch/sparc/net/bpf_jit_comp.c                   |    8 -
 arch/x86/kvm/lapic.c                            |   62 ++++++--
 crypto/crypto_user.c                            |    2=20
 drivers/connector/cn_proc.c                     |    2=20
 drivers/hv/connection.c                         |    4=20
 drivers/hv/hv_balloon.c                         |   29 +++-
 drivers/iio/adc/at91_adc.c                      |   16 +-
 drivers/iio/adc/max1363.c                       |   16 +-
 drivers/iio/magnetometer/ak8975.c               |    9 -
 drivers/iio/pressure/mpl3115.c                  |    6=20
 drivers/net/ethernet/mellanox/mlx4/main.c       |  172 +++++++++++++------=
-----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h       |    1=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c |    1=20
 drivers/net/ethernet/renesas/sh_eth.c           |   32 +++-
 drivers/net/ethernet/renesas/sh_eth.h           |    2=20
 drivers/net/ethernet/sfc/io.h                   |    7=20
 drivers/net/ethernet/sfc/tx.c                   |   22 ++-
 drivers/net/macvlan.c                           |    1=20
 drivers/net/team/team.c                         |    7=20
 drivers/net/usb/qmi_wwan.c                      |    7=20
 drivers/net/vxlan.c                             |    7=20
 drivers/rtc/rtc-at91rm9200.c                    |   16 +-
 drivers/scsi/scsi_netlink.c                     |    2=20
 drivers/staging/iio/adc/mxs-lradc.c             |   12 +
 drivers/staging/iio/light/tsl2x7x_core.c        |    8 -
 drivers/target/iscsi/iscsi_target_auth.c        |   10 +
 drivers/target/target_core_transport.c          |    4=20
 drivers/usb/class/cdc-acm.c                     |  104 ++++++++------
 drivers/usb/class/cdc-acm.h                     |    2=20
 include/linux/if_team.h                         |    1=20
 include/linux/netlink.h                         |   14 +
 include/linux/sock_diag.h                       |    2=20
 include/net/inetpeer.h                          |    9 -
 include/net/sock.h                              |    5=20
 include/sound/core.h                            |    2=20
 include/uapi/sound/compress_offload.h           |    2=20
 kernel/audit.c                                  |    4=20
 lib/lz4/lz4_decompress.c                        |    2=20
 lib/lzo/lzo1x_decompress_safe.c                 |   62 +++++---
 lib/nlattr.c                                    |    4=20
 net/bridge/br_input.c                           |    4=20
 net/bridge/br_private.h                         |    7=20
 net/bridge/br_vlan.c                            |   28 +++
 net/can/gw.c                                    |    4=20
 net/core/dev.c                                  |    5=20
 net/core/rtnetlink.c                            |   43 ++++--
 net/core/sock.c                                 |   49 ++++++
 net/core/sock_diag.c                            |    4=20
 net/dcb/dcbnl.c                                 |    2=20
 net/decnet/dn_dev.c                             |    4=20
 net/decnet/dn_fib.c                             |    4=20
 net/decnet/netfilter/dn_rtmsg.c                 |    2=20
 net/ipv4/datagram.c                             |   20 ++
 net/ipv4/ipip.c                                 |    5=20
 net/ipv4/tcp_input.c                            |   11 -
 net/ipv4/udp.c                                  |    4=20
 net/ipv6/ip6_tunnel.c                           |    1=20
 net/ipv6/output_core.c                          |   11 -
 net/ipv6/sit.c                                  |    5=20
 net/ipv6/udp.c                                  |    8 -
 net/mac80211/iface.c                            |    1=20
 net/netfilter/nfnetlink.c                       |    2=20
 net/netlink/af_netlink.c                        |   80 ++++++++++-
 net/netlink/genetlink.c                         |    2=20
 net/packet/diag.c                               |    7=20
 net/phonet/pn_netlink.c                         |    8 -
 net/sched/act_api.c                             |    2=20
 net/sched/cls_api.c                             |    2=20
 net/sched/sch_api.c                             |    6=20
 net/sctp/associola.c                            |    2=20
 net/tipc/netlink.c                              |    2=20
 net/xfrm/xfrm_user.c                            |    2=20
 security/integrity/evm/evm_main.c               |   12 +
 security/integrity/ima/ima_api.c                |   10 +
 security/integrity/ima/ima_crypto.c             |   32 ++++
 security/integrity/ima/ima_main.c               |    5=20
 security/integrity/ima/ima_policy.c             |    6=20
 security/integrity/integrity.h                  |    1=20
 sound/core/control.c                            |   78 +++++++---
 sound/core/init.c                               |    1=20
 sound/pci/hda/patch_realtek.c                   |   24 +++
 sound/soc/codecs/max98090.c                     |    3=20
 sound/soc/codecs/tlv320aic3x.c                  |    2=20
 sound/soc/soc-dapm.c                            |   23 +--
 88 files changed, 861 insertions(+), 379 deletions(-)

Alexei Starovoitov (2):
      net: filter: fix typo in sparc BPF JIT
      net: filter: fix sparc32 typo

Ben Dooks (1):
      sh_eth: use RNC mode for packet reception

Bj=C3=B8rn Mork (1):
      net: qmi_wwan: add Olivetti Olicard modems

Boris BREZILLON (2):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
      ARM: at91: fix at91_sysirq_mask_rtc for sam9x5 SoCs

Cong Wang (1):
      vxlan: use dev->needed_headroom instead of dev->hard_header_len

Dan Carpenter (2):
      qlcnic: info leak in qlcnic_dcb_peer_app_info()
      iio: adc: at91: signedness bug in at91_adc_get_trigger_value_by_name()

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904

Dmitry Kasatkin (1):
      ima: introduce ima_kernel_read()

Dmitry Popov (1):
      ipip, sit: fix ipv4_{update_pmtu,redirect} calls

Eric Dumazet (4):
      net: fix inet_getid() and ipv6_select_ident() bugs
      net: force a list_del() in unregister_netdevice_many()
      ipv4: fix a race in ip4_datagram_release_cb()
      udp: ipv4: do not waste time in __udp4_lib_mcast_demux_lookup

Eric W. Biederman (6):
      netlink: Rename netlink_capable netlink_allowed
      net: Move the permission check in sock_diag_put_filterinfo to packet_=
diag_dump
      net: Add variants of capable for use on on sockets
      net: Add variants of capable for use on netlink messages
      net: Use netlink_ns_capable to verify the permisions of netlink messa=
ges
      netlink: Only check file credentials for implicit destinations

Greg Kroah-Hartman (3):
      lzo: properly check for overruns
      lz4: ensure length does not wrap
      Linux 3.14.9

James Hogan (1):
      MIPS: KVM: Allocate at least 16KB for exception handlers

Jiri Pirko (1):
      team: fix mtu setting

Johan Hovold (8):
      USB: cdc-acm: fix write and suspend race
      USB: cdc-acm: fix write and resume race
      USB: cdc-acm: fix broken runtime suspend
      USB: cdc-acm: fix runtime PM for control messages
      USB: cdc-acm: fix shutdown and suspend race
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
      USB: cdc-acm: fix I/O after failed open
      USB: cdc-acm: fix runtime PM imbalance at shutdown

Jon Cooper (1):
      sfc: PIO:Restrict to 64bit arch and use 64-bit writes.

Jonathan Cameron (1):
      iio:adc:max1363 incorrect resolutions for max11604, max11605, max1161=
0 and max11611.

K. Y. Srinivasan (1):
      Drivers: hv: balloon: Ensure pressure reports are posted regularly

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC891 codec
      ALSA: hda/realtek - Add more entry for enable HP mute led

Lars-Peter Clausen (6):
      ASoC: dapm: Make sure to always update the DAPM graph in _put_volsw()
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

Mimi Zohar (2):
      ima: audit log files opened with O_DIRECT flag
      evm: prohibit userspace writing 'security.evm' HMAC value

Nicholas Bellinger (2):
      target: Fix NULL pointer dereference for XCOPY in target_put_sess_cmd
      iscsi-target: Reject mutual authentication with reflected CHAP_C

Paolo Bonzini (1):
      KVM: lapic: sync highest ISR to hardware apic on EOI

Peter Meerwald (2):
      iio: Fix endianness issue in ak8975_read_axis()
      iio: Fix two mpl3115 issues in measurement conversion

Peter Ujfalusi (1):
      ASoC: tlv320aci3x: Fix custom snd_soc_dapm_put_volsw_aic3x() function

Radim Kr=C4=8Dm=C3=A1=C5=99 (1):
      hv: use correct order when freeing monitor_pages

Robert Hodaszi (1):
      iio: mxs-lradc: fix divider

Sergei Shtylyov (1):
      sh_eth: fix SH7619/771x support

Sven Wegener (1):
      ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()

Tom Gundersen (1):
      net: tunnels - enable module autoloading

Toshiaki Makita (1):
      bridge: Prevent insertion of FDB entry with disallowed vlan

Wang, Xiaoming (1):
      ALSA: compress: Cancel the optimization of compiler and fix the size =
of struct for all platform.

Wei Yang (2):
      net/mlx4_core: Preserve pci_dev_data after __mlx4_remove_one()
      net/mlx4_core: Keep only one driver entry release mlx4_priv

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem

Yuchung Cheng (1):
      tcp: fix cwnd undo on DSACK in F-RTO


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrHPZAAoJEDjbvchgkmk+aqMP/jJFaH3gMKRkHksjmpXFZM7q
zc14lXwfKYlQ/508WVgiAwgUuZWSv62CWLj758+EP7+laJqAGRvqohiEiROPK2NA
gne+Pb3jj72jJli1Gv8oghS+1ObagMxAt8QXJy8+/QpddjPe4wlsAekcO9YPdn1a
opRvnHS+o15KzOtVt3ZinX/f9ygsoaHaCaXAiAV6HweXFfYFWTkIhth1WM4rxJOR
1ddbgLLVPYiAn7qYa91lSsBw+P8lTr2iJcp6tk6YJvcjeaVmvyopQfzfMz1uEyBW
nNdAzYTR5dRzuo0l/Q3dkTpnRICrONNnv/1tqHHflMRZ7BQD7OYQ8Dr+dVzj3tM/
Z16g6hgGSJj02daR9MgYPwqOTwASl4oq9Qn3+UtxF9HuEk0Vhew0/0CQ0ya7tLZd
kg8xEe50HMFSjBCB2zZOoA8Pn1krpFMfc732nhaSA4P9jsWsncTvzTtA+ii+oimC
ldBqbsUf4gtrKV1WE8SZ0pwCFlYEj89moZIOKRhskRTWVjNljVo5O+jVpr1nCL+K
lxLDO6gsbpU1fgW/EhcYIdSeCC1wBRs0KC9ndG+JvRopHx+zJ/GBSTQzI+2Elyl3
SxWBwM/s8bnZ5cbGXeTU+fiZT6FzmXJOGbHqFCOE1yhkLfspyWVpYfh8buHg8xdE
24TSKQckB9yMuo3w20Bm
=ciTM
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
