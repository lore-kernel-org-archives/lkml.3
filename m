Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaGNQal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:30:41 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:31180 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487AbaGNQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:30:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwRACUFxFNXQxRI/2dsb2JhbABZgw6tRAUBAQEBAQEFAQVpm3+BFhd1hGAjgRqIfQHISIV7iVAdhC0Fmw6UHoNGOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-s390@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-sctp@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 00/16] net: remove unnecessary break after goto/return
Date: Mon, 14 Jul 2014 18:30:50 +0200
Message-Id: <1405355467-7350-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small patchset addressing break redundancy on net branch
(suggested by Joe Perches).

Fabian Frederick (16):
  packet: remove unnecessary break after return
  tipc: remove unnecessary break after return
  9P: remove unnecessary break after return
  af_iucv: remove unnecessary break after goto
  netlabel: remove unnecessary break after goto
  pktgen: remove unnecessary break after goto
  drop_monitor: remove unnecessary break after return
  mac80211: remove unnecessary break after return
  af_key: remove unnecessary break after return
  netfilter: remove unnecessary break after return
  ipv6: remove unnecessary break after return
  NFC: remove unnecessary break after goto
  caif: remove unnecessary break after goto
  irda: remove unnecessary break after return
  ieee802154: remove unnecessary break after goto
  net: sctp: remove unnecessary break after return/goto

 net/9p/client.c                      | 1 -
 net/caif/cfctrl.c                    | 1 -
 net/core/drop_monitor.c              | 2 --
 net/core/pktgen.c                    | 1 -
 net/ieee802154/6lowpan_iphc.c        | 1 -
 net/ipv6/ipv6_sockglue.c             | 1 -
 net/ipv6/netfilter/ip6t_ipv6header.c | 1 -
 net/irda/af_irda.c                   | 1 -
 net/irda/irlan/irlan_common.c        | 1 -
 net/iucv/af_iucv.c                   | 1 -
 net/key/af_key.c                     | 3 ---
 net/mac80211/mesh_hwmp.c             | 1 -
 net/netlabel/netlabel_kapi.c         | 1 -
 net/nfc/digital_dep.c                | 2 --
 net/packet/af_packet.c               | 2 --
 net/sctp/outqueue.c                  | 1 -
 net/sctp/sm_statefuns.c              | 4 ----
 net/tipc/socket.c                    | 1 -
 18 files changed, 26 deletions(-)

-- 
1.8.4.5

