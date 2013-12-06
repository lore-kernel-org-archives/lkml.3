Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3LFViM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:38:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42821 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3LFViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:38:08 -0500
Date: Fri, 06 Dec 2013 16:38:06 -0500 (EST)
Message-Id: <20131206.163806.1555069105347405484.davem@davemloft.net>
To: joe@perches.com
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] batadv: Slight optimization of batadv_compare_eth
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386364621.31845.32.camel@joe-AO722>
References: <1386317890.31845.26.camel@joe-AO722>
	<20131206.153944.1382127535160341376.davem@davemloft.net>
	<1386364621.31845.32.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 13:38:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 06 Dec 2013 13:17:01 -0800

> On Fri, 2013-12-06 at 15:39 -0500, David Miller wrote:
>> If so, make a function for that in linux/etherdevice.h and invoke it
>> in such places.  You can name it something like
>> "ether_addr_equal_unaligned()" or similar.
> 
> I'll resubmit if/after you apply the
> ether_addr_equal/compare_ether_addr removal.

Done.
