Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3CIVLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 16:11:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3CIVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 16:11:36 -0500
Date: Sat, 09 Mar 2013 16:11:42 -0500 (EST)
Message-Id: <20130309.161142.153533460204187265.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] drivers:net: Remove unnecessary OOM messages
 after netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <6379afbec3439c45180956b06c13b02ce3c9f802.1362790535.git.joe@perches.com>
References: <6379afbec3439c45180956b06c13b02ce3c9f802.1362790535.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 09 Mar 2013 13:11:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri,  8 Mar 2013 17:03:25 -0800

> Emitting netdev_alloc_skb and netdev_alloc_skb_ip_align OOM
> messages is unnecessary as there is already a dump_stack
> after allocation failures.
> 
> Other trivial changes around these removals:
> 
> Convert a few comparisons of pointer to 0 to !pointer.
> Change flow to remove unnecessary label.
> Remove now unused variable.
> Hoist assignment from if.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
