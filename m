Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab3JUU1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:27:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42572 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3JUU1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:27:31 -0400
Date: Mon, 21 Oct 2013 16:27:29 -0400 (EDT)
Message-Id: <20131021.162729.2297054111992380683.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fix build warnings because of
 net_get_random_once merge
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131020042602.GC27787@order.stressinduktion.org>
References: <20131020042602.GC27787@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 13:27:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Sun, 20 Oct 2013 06:26:02 +0200

> This patch fixes the following warning:
> 
>    In file included from include/linux/skbuff.h:27:0,
>                     from include/linux/netfilter.h:5,
>                     from include/net/netns/netfilter.h:5,
>                     from include/net/net_namespace.h:20,
>                     from include/linux/init_task.h:14,
>                     from init/init_task.c:1:
> include/linux/net.h:243:14: warning: 'struct static_key' declared inside parameter list [enabled by default]
>           struct static_key *done_key);
> 
> on x86_64 allnoconfig, um defconfig and ia64 allmodconfig and maybe others as well.
> 
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied, thanks Hannes.
