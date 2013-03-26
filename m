Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab3CZSGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:06:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3CZRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:01 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3MQ8otXKIWwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oOcElbzyPCwA:10 a=VwQbUJbxAAAA:8 a=42gRmMmOUcbNodJEz1cA:9 a=2XgmJS_RdeiewrB9:21 a=_n1ZgS8v3Ir3KG9S:21 a=yMRUqGzda45-tLPC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326172059.136127374@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:20:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 00/86] [ANNOUNCE] The new 3.6.11.x short-term extended stable series (stable review)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the latest stable PREEMPT_RT patch is based off of 3.6.11.
As 3.6 is no longer supported by the stable Linux maintainers, this
release has been neglected, and its unfortunate that its the latest
of the -rt stable series.

I have decided to create a stable series that extends 3.6.11, and will
be of the form 3.6.11.x. I want to stress that this is a temporary
series, and will not be for long term. I will be pulling in patches from
3.4 and 3.8 stable releases as I find time.

I will host the 3.6.11.x patches at:

  https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/

Nothing is there yet.

Below is the format of the announcements I will make for the 3.6.11.x
stable reviews. This being the first of the series.

Again, I want to stress that this is not a long term stable release.
I will only support 3.6.11.x until 3.8-rt becomes stable. At which
time I will drop support for both 3.6.11.x as well as 3.6-rt.

-- Steve


This is the start of the stable review cycle for 3.6.11.1 release.
There are 86 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Mar 29 2013.
Anything received after that time might be too late.

Akinobu Mita (1):
      batman-adv: fix random jitter calculation
         [143cdd8f33909ff5a153e3f02048738c5964ba26]

Alexander Aring (1):
      mac802154: fix NOHZ local_softirq_pending 08 warning
         [386de15c3f62bf100b4e162c0a859785d2d58661]

Christoph Paasch (1):
      inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_recv_sock
         [e337e24d6624e74a558aa69071e112a65f7b5758]

Cong Wang (4):
      rds: limit the size allocated by rds_message_alloc()
         [ece6b0a2b25652d684a7ced4ae680a863af041e0]
      vlan: adjust vlan_set_encap_proto() for its callers
         [da8c87241c26aac81a64c7e4d21d438a33018f4e]
      pktgen: correctly handle failures when adding a device
         [604dfd6efc9b79bce432f2394791708d8e8f6efc]
      net: prevent setting ttl=0 via IP_TTL
         [c9be4a5c49cf51cc70a993f004c5bb30067a65ce]

Cristian Bercaru (1):
      bridging: fix rx_handlers return code
         [3bc1b1add7a8484cc4a261c3e128dbe1528ce01f]

Daniel Borkmann (3):
      sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch
         [c5b1825fa547eb475ca8936f6f346c18b1ece298]
      net: sctp: sctp_endpoint_free: zero out secret key data
         [b5c37fe6e24eec194bb29d22fdd55d73bcc709bf]
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
         [6ba542a291a5e558603ac51cda9bded347ce7627]

Dave Kleikamp (1):
      sparc: huge_ptep_set_* functions need to call set_huge_pte_at()
         [6cb9c3697585c47977c42c5cc1b9fc49247ac530]

David S. Miller (4):
      sparc64: Fix gfp_flags setting in tsb_grow().
         [95a2fea6fbb81f56e2ecb60ef0c31e075d6a8995]
      sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
         [f53f5f1e2a84c2a95c47f28b0859ef5eee34569d]
      sunvdc: Fix off-by-one in generic_request().
         [f4d9605434c0fd4cc8639bf25cfc043418c52362]
      via-rhine: Fix bugs in NAPI support.
         [559bcac35facfed49ab4f408e162971612dcfdf3]

David Vrabel (2):
      xen-netback: cancel the credit timer when taking the vif down
         [3e55f8b306cf305832a4ac78aa82e1b40e818ece]
      xen-netback: correctly return errors from netbk_count_requests()
         [35876b5ffc154c357476b2c3bdab10feaf4bd8f0]

Duan Jiong (1):
      ipv6: Change skb->data before using icmpv6_notify() to propagate redirect
         [7801a085efab5f1d7cc54fa1f80b0c69b457db68]

Eric Dumazet (17):
      ppp: set qdisc_tx_busylock to avoid LOCKDEP splat
         [0b652fb68c02c1acd0307d3acac4ae7123536031]
      net: splice: fix __splice_segment()
         [9049d7450887d54b199441144f8ba50fa4d8cf92]
      net: splice: avoid high order page splitting
         [4678414601960b3d60b651d82e2913c48c53508d]
      tcp: fix splice() and tcp collapsing interaction
         [fdd384558afc89793bf35db6b5263e80ee92093d]
      tcp: splice: fix an infinite loop in tcp_read_sock()
         [74b2a7b4ea60d5c1c94ac01ad001e16ac40132f3]
      tcp: fix an infinite loop in tcp_slow_start()
         [93e3a886683c28e718e146c827e9cc750c88817e]
      tcp: fix incorrect LOCKDROPPEDICMPS counter
         [55ef74760190fb39eacaaee1816dfaeeadd5b92d]
      macvlan: fix macvlan_get_size()
         [ee19a438d8f4f7ff5a9469a2f30bba7bb15f00ec]
      tun: add a missing nf_reset() in tun_net_xmit()
         [f8af75f3517a24838a36eb5797a1a3e60bf9e276]
      ipv6: use a stronger hash for tcp
         [08dcdbf6a7b9d14c2302c5bd0c5390ddf122f664]
      net: fix infinite loop in __skb_recv_datagram()
         [77c1090f94d1b0b5186fb13a1b71b47b1343f87f]
      tcp: frto should not set snd_cwnd to 0
         [2e5f421211ff76c17130b4597bc06df4eeead24f]
      net: loopback: fix a dst refcounting issue
         [794ed393b707f01858f5ebe2ae5eabaf89d00022]
      netxen: fix off by one bug in netxen_release_tx_buffer()
         [a05948f296ce103989b28a2606e47d2e287c3c89]
      tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
         [354e4aa391ed50a4d827ff6fc11e0667d0859b25]
      tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()
         [bd090dfc634ddd711a5fbd0cadc6e0ab4977bcaf]
      tcp: fix MSG_SENDPAGE_NOTLAST logic
         [ae62ca7b03217be5e74759dc6d7698c95df498b3]

Guillaume Nault (1):
      l2tp: Restore socket refcount when sendmsg succeeds
         [8b82547e33e85fc24d4d172a93c796de1fefa81a]

Hannes Frederic Sowa (1):
      ipv6: stop multicast forwarding to process interface scoped addresses
         [ddf64354af4a702ee0b85d0a285ba74c7278a460]

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t
         [ab54ee80aa7585f9666ff4dd665441d7ce41f1e8]

Ian Campbell (3):
      netback: correct netbk_tx_err to handle wrap around.
         [b9149729ebdcfce63f853aa54a404c6a8f6ebbf3]
      xen/netback: free already allocated memory on failure in xen_netbk_get_requests
         [4cc7c1cb7b11b6f3515bd9075527576a1eecc4aa]
      xen/netback: shutdown the ring if it contains garbage.
         [48856286b64e4b66ec62b94e504d0b29c1ade664]

Ilpo Järvinen (1):
      tcp: fix for zero packets_in_flight was too broad
         [6731d2095bd4aef18027c72ef845ab1087c3ba63]

Kleber Sacilotto de Souza (1):
      mlx4_en: fix allocation of CPU affinity reverse-map
         [77c5d9e186705280ca6eff08f3280a5f70c79f8e]

Li Wei (2):
      ipv4: fix error handling in icmp_protocol.
         [a426b816575c9701ddcb12a793693dbcbcee5c2b]
      ipv4: fix a bug in ping_err().
         [b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8]

Lorenzo Colitti (1):
      net: ipv6: Don't purge default router if accept_ra=2
         [3e8b0ac3e41e3c882222a5522d5df7212438ab51]

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery
         [bd30e947207e2ea0ff2c08f5b4a03025ddce48d3]

Mathias Krause (3):
      dcbnl: fix various netlink info leaks
         [29cd8ae0e1a39e239a3a7b67da1986add1199fc0]
      rtnl: fix info leak on RTM_GETLINK request for VF devices
         [84d73cd3fb142bf1298a8c13fd4ca50fd2432372]
      sock_diag: Fix out-of-bounds access to sock_diag_handlers[]
         [6e601a53566d84e1ffd25e7b6fe0b6894ffd79c0]

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.
         [7d5145d8eb2b9791533ffe4dc003b129b9696c48]

Neal Cardwell (1):
      tcp: fix double-counted receiver RTT when leaving receiver fast path
         [aab2b4bf224ef8358d262f95b568b8ad0cecf0a0]

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization
         [2f94aabd9f6c925d77aecb3ff020f1cc12ed8f86]

Nithin Nayak Sujir (2):
      tg3: Fix crc errors on jumbo frame receive
         [daf3ec688e057f6060fb9bb0819feac7a8bbf45c]
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
         [9c13cb8bb477a83b9a3c9e5a5478a4e21294a760]

Or Gerlitz (1):
      net/mlx4_core: Set number of msix vectors under SRIOV mode to firmware defaults
         [ca4c7b35f75492de7fbf5ee95be07481c348caee]

Paul Moore (2):
      netlabel: correctly list all the static label mappings
         [0c1233aba1e948c37f6dc7620cb7c253fcd71ce9]
      netlabel: fix build problems when CONFIG_IPV6=n
         [a6a8fe950e1b8596bb06f2c89c3a1a4bf2011ba9]

Phil Sutter (1):
      packet: fix leakage of tx_ring memory
         [9665d5d62487e8e7b1f546c00e11107155384b9a]

Pravin B Shelar (1):
      IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
         [d0a7cc630a337b0f56dc145e7eb6232852b14dd4]

Rob Herring (1):
      net: calxedaxgmac: throw away overrun frames
         [d6fb3be544b46a7611a3373fcaa62b5b0be01888]

Romain KUNTZ (2):
      xfrm: release neighbor upon dst destruction
         [2894f6da7e382a42948cc42ab52148dddf281c48]
      ipv6: fix header length calculation in ip6_append_data()
         [7efdba5bd9a2f3e2059beeb45c9fa55eefe1bced]

Romain Kuntz (1):
      ipv6: fix the noflags test in addrconf_get_prefix_route
         [85da53bf1c336bb07ac038fb951403ab0478d2c5]

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.
         [6caab7b0544e83e6c160b5e80f5a4a7dd69545c7]

Stefan Hasko (1):
      net: sched: integer overflow fix
         [d2fe85da52e89b8012ffad010ef352a964725d5f]

Steffen Klassert (6):
      ipv4: Fix route refcount on pmtu discovery
         [9a2a0fefaf476a4be4d153792eaa600203b83edf]
      ipv4: Add a socket release callback for datagram sockets
         [1c4fa590068ef4e257cb7b27643a3ee34cf9163b]
      ipv4: Invalidate the socket cached route on pmtu events if possible
         [c82d543a2e8727233337c6f93ba7a1bddd5228cc]
      ipv6: Add an error handler for icmp6
         [cdd6baf1fd9159d9b333938f1717e7c4cba025cc]
      ipv4: Don't update the pmtu on mtu locked routes
         [4ac7bed1ff5f935525a8c71c347bbc8cdff9e067]
      ipv4: Remove output route check in ipv4_mtu
         [34f48df8ec531943ca83ea994eb2561897d8f9f4]

Stephen Hemminger (2):
      bridge: set priority of STP packets
         [547b4e718115eea74087e28d7fa70aec619200db]
      MAINTAINERS: Stephen Hemminger email change
         [adbbf69d1a54abf424e91875746a610dcc80017d]

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump
         [d721a1752ba544df8d7d36959038b26bc92bdf80]

Timo Teräs (1):
      r8169: remove the obsolete and incorrect AMD workaround
         [5d0feaff230c0abfe4a112e6f09f096ed99e0b2d]

Vlad Yasevich (2):
      team: unsyc the devices addresses when port is removed
         [972ea34911d5f81639d963224d00add37170bd52]
      macvlan: Set IFF_UNICAST_FLT flag to prevent unnecessary promisc mode.
         [87ab7f6f2874f1115817e394a7ed2dea1c72549e]

Willy Tarreau (1):
      tcp: don't abort splice() after small transfers
         [e9feca83d1496afabd0cc174863646e6d7101d85]

YOSHIFUJI Hideaki / 吉藤英明 (2):
      ipv6: fix race condition regarding dst->expires and dst->from.
         [eaf11ca939f83c273740d5bcec7225969ae95295]
      6lowpan: Fix endianness issue in is_addr_link_local().
         [9026c4927254f5bea695cc3ef2e255280e6a3011]

Yan Burman (1):
      net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode
         [213815a1e6ae70b9648483b110bc5081795f99e8]

Ying Xue (1):
      net: fix a compile error when SOCK_REFCNT_DEBUG is enabled
         [dec34fb0f5b7873de45132a84a3af29e61084a6b]

Yuchung Cheng (2):
      tcp: fix SYN-data space mis-accounting
         [f7983d26995f85994a08ee173ee7d0c4ff3da356]
      tcp: detect SYN/data drop when F-RTO is disabled
         [9d475971466bf0e4c65a88d46031b8127a767897]

----
 MAINTAINERS                                        |    6 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/asm/hugetlb.h                   |   10 +-
 arch/sparc/mm/tsb.c                                |    2 +-
 drivers/atm/iphase.h                               |  146 ++++++++++----------
 drivers/block/sunvdc.c                             |    2 +-
 drivers/isdn/gigaset/capi.c                        |    2 +
 drivers/net/ethernet/broadcom/tg3.c                |   62 ++++++---
 drivers/net/ethernet/calxeda/xgmac.c               |    4 +
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   11 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |    2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +
 drivers/net/ethernet/realtek/r8169.c               |    7 -
 drivers/net/ethernet/via/via-rhine.c               |    8 +-
 drivers/net/loopback.c                             |    5 +
 drivers/net/macvlan.c                              |    6 +-
 drivers/net/ppp/ppp_generic.c                      |    8 ++
 drivers/net/team/team.c                            |    2 +
 drivers/net/tun.c                                  |    2 +
 drivers/net/xen-netback/common.h                   |    3 +
 drivers/net/xen-netback/interface.c                |   26 ++--
 drivers/net/xen-netback/netback.c                  |  123 ++++++++++-------
 fs/splice.c                                        |    4 +-
 include/linux/if_vlan.h                            |    6 +-
 include/net/dst.h                                  |    8 +-
 include/net/icmp.h                                 |    1 +
 include/net/inet6_hashtables.h                     |    8 +-
 include/net/inet_connection_sock.h                 |    1 +
 include/net/inet_sock.h                            |    1 +
 include/net/ip.h                                   |    2 +
 include/net/ip6_fib.h                              |   39 ++----
 include/net/ipv6.h                                 |   12 ++
 include/net/ndisc.h                                |    7 +
 include/net/sock.h                                 |    2 +-
 net/batman-adv/bat_iv_ogm.c                        |    2 +-
 net/bridge/br_netfilter.c                          |    3 +
 net/bridge/br_stp_bpdu.c                           |    2 +
 net/core/datagram.c                                |    2 +-
 net/core/dev.c                                     |    1 +
 net/core/dst.c                                     |    1 +
 net/core/pktgen.c                                  |    9 +-
 net/core/rtnetlink.c                               |    1 +
 net/core/skbuff.c                                  |   44 ++----
 net/core/sock_diag.c                               |    3 +
 net/dcb/dcbnl.c                                    |    8 ++
 net/dccp/ipv4.c                                    |    4 +-
 net/dccp/ipv6.c                                    |    3 +-
 net/ieee802154/6lowpan.h                           |    2 +-
 net/ipv4/af_inet.c                                 |   11 +-
 net/ipv4/datagram.c                                |   25 ++++
 net/ipv4/icmp.c                                    |   23 +++
 net/ipv4/inet_connection_sock.c                    |   16 +++
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ip_sockglue.c                             |    2 +-
 net/ipv4/ping.c                                    |    5 +-
 net/ipv4/raw.c                                     |    1 +
 net/ipv4/route.c                                   |   54 +++++++-
 net/ipv4/tcp.c                                     |   27 ++--
 net/ipv4/tcp_cong.c                                |   14 +-
 net/ipv4/tcp_input.c                               |   72 ++++++----
 net/ipv4/tcp_ipv4.c                                |   15 +-
 net/ipv4/tcp_output.c                              |   18 ++-
 net/ipv4/udp.c                                     |    1 +
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/icmp.c                                    |   12 ++
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/ndisc.c                                   |   17 +++
 net/ipv6/route.c                                   |   13 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/ipv6/xfrm6_policy.c                            |    2 +
 net/l2tp/l2tp_ppp.c                                |    1 +
 net/mac802154/wpan.c                               |    2 +-
 net/netlabel/netlabel_unlabeled.c                  |   27 ++--
 net/packet/af_packet.c                             |   10 +-
 net/rds/message.c                                  |    3 +
 net/sched/sch_htb.c                                |    2 +-
 net/sctp/endpointola.c                             |    5 +
 net/sctp/outqueue.c                                |   12 +-
 net/sctp/probe.c                                   |    3 +-
 net/sctp/socket.c                                  |    2 +-
 83 files changed, 666 insertions(+), 378 deletions(-)
