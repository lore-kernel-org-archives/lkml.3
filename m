Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934487Ab3CUQik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:38:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44169 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab3CUQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:38:38 -0400
Date: Thu, 21 Mar 2013 12:38:35 -0400 (EDT)
Message-Id: <20130321.123835.105179567859494344.davem@davemloft.net>
To: avagin@openvz.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, xemul@parallels.com,
        edumazet@google.com, pablo@netfilter.org, ebiederm@xmission.com,
        gaofeng@cn.fujitsu.com, tgraf@suug.ch
Subject: Re: [PATCH 3/3] netlink: Diag core and basic socket info dumping
 (v2)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363883628-7249-4-git-send-email-avagin@openvz.org>
References: <1363883628-7249-1-git-send-email-avagin@openvz.org>
	<1363883628-7249-4-git-send-email-avagin@openvz.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Mar 2013 09:38:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Thu, 21 Mar 2013 20:33:48 +0400

> The netlink_diag can be built as a module, just like it's done in
> unix sockets.
> 
> The core dumping message carries the basic info about netlink sockets:
> family, type and protocol, portis, dst_group, dst_portid, state.
> 
> Groups can be received as an optional parameter NETLINK_DIAG_GROUPS.
> 
> Netlink sockets cab be filtered by protocols.
> 
> The socket inode number and cookie is reserved for future per-socket info
> retrieving. The per-protocol filtering is also reserved for future by
> requiring the sdiag_protocol to be zero.
> 
> The file /proc/net/netlink doesn't provide enough information for
> dumping netlink sockets. It doesn't provide dst_group, dst_portid,
> groups above 32.
> 
> v2: fix NETLINK_DIAG_MAX. Now it's equal to the last constant.
> 
> Acked-by: Pavel Emelyanov <xemul@parallels.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied to net-next
