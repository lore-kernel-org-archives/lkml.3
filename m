Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3D3XBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:01:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933643Ab3D3XBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:01:30 -0400
Date: Tue, 30 Apr 2013 19:01:28 -0400 (EDT)
Message-Id: <20130430.190128.2033981457511481406.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: rdunlap@infradead.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        amirv@mellanox.com
Subject: Re: [PATCH net-next] mlx4_en: fix a build error on 32bit arches
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367355231.11020.10.camel@edumazet-glaptop>
References: <1367350578.11020.4.camel@edumazet-glaptop>
	<51802BE9.7020805@infradead.org>
	<1367355231.11020.10.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Apr 2013 16:01:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 30 Apr 2013 13:53:51 -0700

> From: Eric Dumazet <edumazet@google.com>
> 
> commit b6c39bfcf1d7d63 ("net/mlx4_en: Add a service task")
> added a build error on 32bit arches.
> 
> ERROR: "__udivdi3" [drivers/net/ethernet/mellanox/mlx4/mlx4_en.ko]
> undefined!
> 
> Fix this problem by using do_div()
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks for fixing this Eric.
