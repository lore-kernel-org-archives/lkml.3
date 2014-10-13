Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaJMCul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:50:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbaJMC1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:27:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.16 00/55] 3.16.6-stable review
Date: Mon, 13 Oct 2014 04:24:14 +0200
Message-Id: <20141013022443.729870634@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.16.6 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 15 02:24:32 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.16.6-rc1

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    serial: 8250: Add Quark X1000 to 8250_pci.c

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    driver/base/node: remove unnecessary kfree of node struct from unregister_one_node

Cristian Stoica <cristian.stoica@freescale.com>
    crypto: caam - fix addressing of struct member

Felipe Balbi <balbi@ti.com>
    usb: musb: dsps: kill OTG timer on suspend

Andreas Bomholtz <andreas@seluxit.com>
    USB: cp210x: add support for Seluxit USB dongle

Joe Savage <joe.savage@goketra.com>
    USB: serial: cp210x: added Ketra N1 wireless interface support

Lu Baolu <baolu.lu@linux.intel.com>
    USB: Add device quirk for ASUS T100 Base Station keyboard

Hans de Goede <hdegoede@redhat.com>
    uas: Add another ASM1051 usb-id to the uas blacklist

Hans de Goede <hdegoede@redhat.com>
    uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives

Hans de Goede <hdegoede@redhat.com>
    uas: Add no-report-opcodes quirk

Hans de Goede <hdegoede@redhat.com>
    uas: Add a quirk for rejecting ATA_12 and ATA_16 commands

WANG Cong <xiyou.wangcong@gmail.com>
    net_sched: copy exts->type in tcf_exts_change()

Vlad Yasevich <vyasevich@gmail.com>
    sctp: handle association restarts when the socket is closed.

KY Srinivasan <kys@microsoft.com>
    hyperv: Fix a bug in netvsc_send()

Joe Lawrence <Joe.Lawrence@stratus.com>
    team: avoid race condition in scheduling delayed work

Florian Fainelli <f.fainelli@gmail.com>
    net: systemport: fix bcm_sysport_insert_tsb()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6_gre: fix flowi6_proto value in xmit path

KY Srinivasan <kys@microsoft.com>
    hyperv: Fix a bug in netvsc_start_xmit()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: remove rt6i_genid

Eric Dumazet <edumazet@google.com>
    gro: fix aggregation for skb using frag_list

Matan Barak <matanb@mellanox.com>
    net/mlx4: Correctly configure single ported VFs from the host

Matan Barak <matanb@mellanox.com>
    net/mlx4_core: Allow not to specify probe_vf in SRIOV IB mode

Soren Brinkmann <soren.brinkmann@xilinx.com>
    Revert "net/macb: add pinctrl consumer support"

Vlad Yasevich <vyasevich@gmail.com>
    macvtap: Fix race between device delete and open.

Steffen Klassert <steffen.klassert@secunet.com>
    ip_tunnel: Don't allow to add the same tunnel multiple times.

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Generate queueing routes only from route lookup functions

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Generate blackhole routes only from route lookup functions

Vlad Yasevich <vyasevich@gmail.com>
    tg3: Allow for recieve of full-size 8021AD frames

Vlad Yasevich <vyasevich@gmail.com>
    tg3: Work around HW/FW limitations with vlan encapsulated frames

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    macvlan: allow to enqueue broadcast pkt on virtual device

Francesco Ruggeri <fruggeri@arista.com>
    net: allow macvlans to move to net namespace

Vlad Yasevich <vyasevich@gmail.com>
    bridge: Fix br_should_learn to check vlan_enabled

Vlad Yasevich <vyasevich@gmail.com>
    bridge: Check if vlan filtering is enabled only once.

Eric Dumazet <edumazet@google.com>
    net: filter: fix possible use after free

Nikolay Aleksandrov <nikolay@redhat.com>
    bonding: fix div by zero while enslaving and transmitting

WANG Cong <xiyou.wangcong@gmail.com>
    ipv6: restore the behavior of ipv6_sock_ac_drop()

Guillaume Nault <g.nault@alphalink.fr>
    l2tp: fix race while getting PMTU on PPP pseudo-wire

Sabrina Dubroca <sd@queasysnail.net>
    ipv6: fix rtnl locking in setsockopt for anycast and multicast

Michal Kubeček <mkubecek@suse.cz>
    net: fix checksum features handling in netif_skb_features()

Gerhard Stenzel <gstenzel@linux.vnet.ibm.com>
    vxlan: fix incorrect initializer in union vxlan_addr

Jiri Benc <jbenc@redhat.com>
    openvswitch: fix panic with multiple vlan headers

Benjamin Block <bebl@mageta.org>
    net: ipv6: fib: don't sleep inside atomic lock

Yuval Mintz <Yuval.Mintz@qlogic.com>
    bnx2x: Revert UNDI flushing mechanism

Eric Dumazet <edumazet@google.com>
    packet: handle too big packets for PACKET_V3

Erik Hugne <erik.hugne@ericsson.com>
    tipc: fix message importance range check

Gwenhael Goavec-Merou <gwenhael.goavec-merou@armadeus.com>
    net: phy: smsc: move smsc_phy_config_init reset part in a soft_reset function

Neal Cardwell <ncardwell@google.com>
    tcp: fix ssthresh and undo for consecutive short FRTO episodes

Neal Cardwell <ncardwell@google.com>
    tcp: fix tcp_release_cb() to dispatch via address family for mtu_reduced()

Shmulik Ladkani <shmulik.ladkani@gmail.com>
    sit: Fix ipip6_tunnel_lookup device matching criteria

Andrey Vagin <avagin@openvz.org>
    tcp: don't use timestamp from repaired skb-s to calculate RTT (v2)

David S. Miller <davem@davemloft.net>
    Revert "macvlan: simplify the structure port"

Stanislaw Gruszka <sgruszka@redhat.com>
    myri10ge: check for DMA mapping errors

Vlad Yasevich <vyasevic@redhat.com>
    net: Always untag vlan-tagged traffic on input.

Jiri Benc <jbenc@redhat.com>
    rtnetlink: fix VF info size

Daniel Borkmann <dborkman@redhat.com>
    netlink: reset network header before passing to taps


-------------

Diffstat:

 Documentation/kernel-parameters.txt              |  4 ++
 Makefile                                         |  4 +-
 drivers/base/node.c                              |  1 -
 drivers/crypto/caam/caamhash.c                   |  6 +-
 drivers/net/bonding/bond_main.c                  | 17 ++++-
 drivers/net/ethernet/broadcom/bcmsysport.c       | 13 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 92 +++++-------------------
 drivers/net/ethernet/broadcom/tg3.c              | 23 +++++-
 drivers/net/ethernet/cadence/macb.c              | 11 ---
 drivers/net/ethernet/mellanox/mlx4/cmd.c         | 21 ++++++
 drivers/net/ethernet/mellanox/mlx4/main.c        |  4 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 88 +++++++++++++++--------
 drivers/net/hyperv/netvsc.c                      | 15 ++--
 drivers/net/hyperv/netvsc_drv.c                  |  3 +-
 drivers/net/macvlan.c                            | 16 +++--
 drivers/net/macvtap.c                            | 18 +++--
 drivers/net/phy/smsc.c                           | 33 +++++----
 drivers/net/team/team.c                          |  4 +-
 drivers/net/vxlan.c                              |  8 +--
 drivers/tty/serial/8250/8250_pci.c               | 21 ++++++
 drivers/usb/core/hub.c                           |  6 +-
 drivers/usb/core/quirks.c                        |  4 ++
 drivers/usb/musb/musb_dsps.c                     |  2 +
 drivers/usb/serial/cp210x.c                      |  2 +
 drivers/usb/storage/uas.c                        | 17 +++++
 drivers/usb/storage/unusual_uas.h                | 45 +++++++++---
 drivers/usb/storage/usb.c                        |  9 ++-
 include/linux/if_vlan.h                          |  6 --
 include/linux/skbuff.h                           |  1 +
 include/linux/usb/quirks.h                       |  3 +
 include/linux/usb_usual.h                        |  4 ++
 include/net/dst.h                                | 16 ++++-
 include/net/inet_connection_sock.h               |  1 +
 include/net/ip6_fib.h                            |  5 +-
 include/net/net_namespace.h                      | 20 +-----
 include/net/sctp/command.h                       |  2 +-
 include/net/sock.h                               |  1 -
 include/net/tcp.h                                |  5 +-
 net/8021q/vlan_core.c                            | 53 --------------
 net/bridge/br_private.h                          |  3 +
 net/bridge/br_vlan.c                             | 14 ++--
 net/core/dev.c                                   | 18 +++--
 net/core/filter.c                                |  1 +
 net/core/rtnetlink.c                             |  3 +-
 net/core/skbuff.c                                | 56 +++++++++++++++
 net/ipv4/ip_tunnel.c                             | 11 ++-
 net/ipv4/route.c                                 |  6 +-
 net/ipv4/tcp.c                                   | 14 ++--
 net/ipv4/tcp_input.c                             |  8 +--
 net/ipv4/tcp_ipv4.c                              |  5 +-
 net/ipv4/tcp_output.c                            |  7 +-
 net/ipv6/addrconf.c                              | 18 ++---
 net/ipv6/addrconf_core.c                         |  7 ++
 net/ipv6/anycast.c                               | 10 +++
 net/ipv6/ip6_fib.c                               | 22 +++++-
 net/ipv6/ip6_gre.c                               |  4 +-
 net/ipv6/ip6_output.c                            |  4 +-
 net/ipv6/mcast.c                                 | 14 ++++
 net/ipv6/route.c                                 |  4 --
 net/ipv6/sit.c                                   |  6 +-
 net/ipv6/tcp_ipv6.c                              |  3 +-
 net/l2tp/l2tp_ppp.c                              |  3 +-
 net/netlink/af_netlink.c                         |  2 +-
 net/openvswitch/actions.c                        |  5 ++
 net/packet/af_packet.c                           | 17 +++++
 net/packet/internal.h                            |  1 +
 net/sched/cls_api.c                              |  1 +
 net/sctp/sm_statefuns.c                          | 19 ++++-
 net/tipc/port.h                                  |  5 +-
 net/tipc/socket.c                                |  2 +-
 net/xfrm/xfrm_policy.c                           | 48 ++++++++++---
 71 files changed, 598 insertions(+), 347 deletions(-)


