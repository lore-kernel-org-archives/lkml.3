Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaGaCI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 22:08:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38459 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaGaCIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 22:08:25 -0400
Date: Wed, 30 Jul 2014 19:08:24 -0700 (PDT)
Message-Id: <20140730.190824.1834967880150777985.davem@davemloft.net>
To: tgraf@suug.ch
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org
Subject: Re: [PATCH 0/2 net-next] Lockless netlink_lookup() with new
 concurrent hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1406633945.git.tgraf@suug.ch>
References: <cover.1406633945.git.tgraf@suug.ch>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Jul 2014 19:08:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Tue, 29 Jul 2014 13:41:31 +0200

> Netlink sockets are maintained in a hash table to allow efficient lookup
> via the port ID for unicast messages. However, lookups currently require
> a read lock to be taken. This series adds a new generic, resizable,
> scalable, concurrent hash table based on the paper referenced in the first
> patch. It then makes use of the new data type to implement lockless
> netlink_lookup().
> 
> Against net-next since the initial user of the new hash table is in net/
> 
> Thomas Graf (2):
>   lib: Resizable, Scalable, Concurrent Hash Table
>   netlink: Convert netlink_lookup() to use RCU protected hash table

This series looks great, please post an updated series once you have
addressed the current feedback.

Thanks!
