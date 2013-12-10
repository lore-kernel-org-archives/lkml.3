Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3LJB6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:58:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45023 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LJB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:58:39 -0500
Date: Mon, 09 Dec 2013 20:58:38 -0500 (EST)
Message-Id: <20131209.205838.1809285255471420654.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] etherdevice: Optimize a few is_<foo>_ether_addr
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386373461.31845.50.camel@joe-AO722>
References: <20131206.163806.1555069105347405484.davem@davemloft.net>
	<1386368461.31845.38.camel@joe-AO722>
	<1386373461.31845.50.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 09 Dec 2013 17:58:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 06 Dec 2013 15:44:21 -0800

> If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set,
> several is_<foo>_ether_addr functions can be slightly
> improved by using u32 dereferences.
> 
> I believe all current uses of is_zero_ether_addr and
> is_broadcast_ether_addr are u16 aligned, so always use
> u16 references to improve those functions performance.
> 
> Document the u16 alignment requirements.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
