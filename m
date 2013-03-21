Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab3CUQge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8832 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934293Ab3CUQg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:27 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>, Andrey Vagin <avagin@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, Thomas Graf <tgraf@suug.ch>
Subject: [PATCH 0/3] netlink: implement socket diag for netlink sockets (v2)
Date: Thu, 21 Mar 2013 20:33:45 +0400
Message-Id: <1363883628-7249-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: fix *_DIAG_MAX constants

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Andrey Vagin <avagin@openvz.org>

Andrey Vagin (3):
  net: fix *_DIAG_MAX constants
  net: prepare netlink code for netlink diag
  netlink: Diag core and basic socket info dumping (v2)

 include/uapi/linux/netlink_diag.h |  42 +++++++++
 include/uapi/linux/packet_diag.h  |   4 +-
 include/uapi/linux/unix_diag.h    |   4 +-
 net/Kconfig                       |   1 +
 net/netlink/Kconfig               |  10 ++
 net/netlink/Makefile              |   3 +
 net/netlink/af_netlink.c          |  59 +-----------
 net/netlink/af_netlink.h          |  62 +++++++++++++
 net/netlink/diag.c                | 188 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 317 insertions(+), 56 deletions(-)
 create mode 100644 include/uapi/linux/netlink_diag.h
 create mode 100644 net/netlink/Kconfig
 create mode 100644 net/netlink/af_netlink.h
 create mode 100644 net/netlink/diag.c

-- 
1.8.1.4

