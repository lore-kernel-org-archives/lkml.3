Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbaHEF6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:58:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaHEF6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:58:40 -0400
Date: Mon, 04 Aug 2014 22:58:39 -0700 (PDT)
Message-Id: <20140804.225839.1596745671912500243.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tgraf@suug.ch, sasha.levin@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org, nikolay@redhat.com
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407217807.3178.70.camel@edumazet-glaptop2.roam.corp.google.com>
References: <53E03D0B.3000208@oracle.com>
	<20140804.195841.536725238366145203.davem@davemloft.net>
	<1407217807.3178.70.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 22:58:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 05 Aug 2014 07:50:07 +0200

> [PATCH net-next] netlink: fix lockdep splats
> 
> With netlink_lookup() conversion to RCU, we need to use appropriate
> rcu dereference in netlink_seq_socket_idx() & netlink_seq_next()
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Fixes: e341694e3eb57fc ("netlink: Convert netlink_lookup() to use RCU protected hash table")

Applied, thanks Eric.
