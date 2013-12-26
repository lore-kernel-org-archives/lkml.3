Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3LZScE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:32:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51655 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3LZScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:32:02 -0500
Date: Thu, 26 Dec 2013 13:32:00 -0500 (EST)
Message-Id: <20131226.133200.1159110493607479477.davem@davemloft.net>
To: dingtianhong@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, joe@perches.com,
        alexander.h.duyck@intel.com, antonio@meshcoding.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3.5 00/19] slight optimization of addr compare for
 some modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <52BC159C.1000903@huawei.com>
References: <52BC159C.1000903@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 26 Dec 2013 10:32:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>
Date: Thu, 26 Dec 2013 19:40:12 +0800

> Joe Perches add ether_addr_equal_unaligned to test if
> possibly unaligned to u16 Ethernet addresses are equal.
> 
> If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set, this uses
> the slightly faster generic routine ether_addr_equal,
> otherwise this uses memcmp.
> 
> So I use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp for slight
> optimization.

Series applied, thanks.
