Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaABD7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:59:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46275 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaABD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:59:31 -0500
Date: Wed, 01 Jan 2014 22:59:29 -0500 (EST)
Message-Id: <20140101.225929.656895130870992841.davem@davemloft.net>
To: dingtianhong@huawei.com
Cc: fubar@us.ibm.com, vfalico@redhat.com, joe@perches.com,
        julia.lawall@lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next 0/7] bonding: slight optimization for
 bonding
From: David Miller <davem@davemloft.net>
In-Reply-To: <52C4BD12.8000502@huawei.com>
References: <52C4BD12.8000502@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 01 Jan 2014 19:59:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ding Tianhong <dingtianhong@huawei.com>
Date: Thu, 2 Jan 2014 09:12:50 +0800

> This serious of patches will slight optimize the mac address compare
> and xmit path for bonding, also make some cleanups.
> 
> Julia was using ether_addr_equal_64bits to instead of ether_addr_equal,
> it is really a hard work and she may did not make patch for bonding yet,
> so I have do it in this patchset and that she could miss the bonding drivers.
> 
> resend and add cc for Julia.

Series applied, thank you.
