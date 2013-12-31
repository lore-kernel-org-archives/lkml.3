Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3LaVtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:49:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab3LaVtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:49:14 -0500
Date: Tue, 31 Dec 2013 16:49:12 -0500 (EST)
Message-Id: <20131231.164912.1373331336904065031.davem@davemloft.net>
To: dingtianhong@huawei.com
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, edumazet@google.com
Subject: Re: [PATCH net-next v3 00/19] slight optimization of addr compare
 for net modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <52C12369.7020206@huawei.com>
References: <52C12369.7020206@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 31 Dec 2013 13:49:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>
Date: Mon, 30 Dec 2013 15:40:25 +0800

> This is the second patchset for slight optimization of address compare,
> mainly for net tree, just following the Joe's opinion, it will help review
> the code for maintainers and supports.
> 
> v2: Change some style for patch 2.
>     According Eric's suggestion, use the ether_addr_equal_64bits to instead
>     of ether_addr_equal for patch 19.
>     In fact, there are a lot of places which could use ether_addr_equal_64bits
>     to instead of ether_addr_equal, but not this time, thanks for Joe's
>     opinion.
> 
> v3: Change some style for patch 11/19:
>     (net: packetengines: slight optimization of addr compare).
>     Joe pointed out that is_broadcast_ether_addr(addr) would be appropriate here,
>     but this should be left alone and not in this patch, so fix it later.
> 
>     In the patch (net: caif: slight optimization of addr compare), the operand for
>     memcmp is not mac address, so it is unsuitable to use the ether_addr_equal
>     to compare a non mac address, so remove the patch from the series.

Series applied, thanks.
