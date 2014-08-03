Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaHCCxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 22:53:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51155 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaHCCxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 22:53:39 -0400
Date: Sat, 02 Aug 2014 19:53:37 -0700 (PDT)
Message-Id: <20140802.195337.1579267101961188813.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org, nikolay@redhat.com
Subject: Re: [PATCH net-next v5 0/3] Lockless netlink_lookup() with new
 concurrent hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1406971567.git.tgraf@suug.ch>
References: <cover.1406971567.git.tgraf@suug.ch>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 Aug 2014 19:53:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Sat,  2 Aug 2014 11:47:43 +0200

> Netlink sockets are maintained in a hash table to allow efficient lookup
> via the port ID for unicast messages. However, lookups currently require
> a read lock to be taken. This series adds a new generic, resizable,
> scalable, concurrent hash table based on the paper referenced in the first
> patch. It then makes use of the new data type to implement lockless
> netlink_lookup().
> 
> Patch 3/3 to convert nft_hash is included for reference but should be
> merged via the netfilter tree. Inclusion in this series is to provide
> context for the suggested API.
> 
> Against net-next since the initial user of the new hash table is in net/

Applied, thanks Thomas.
