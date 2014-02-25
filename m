Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaBYARA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:17:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48632 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaBYAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:16:57 -0500
Date: Mon, 24 Feb 2014 19:16:55 -0500 (EST)
Message-Id: <20140224.191655.402406764181553805.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bridge: Use ether_addr_copy and ETH_ALEN
From: David Miller <davem@davemloft.net>
In-Reply-To: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
References: <06d3e7e463c2bbfa8b5264e67daace1181ada090.1393142669.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2014 16:16:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 23 Feb 2014 00:05:25 -0800

> Convert the more obvious uses of memcpy to ether_addr_copy.
> 
> There are still uses of memcpy that could be converted but
> these addresses are __aligned(2).
> 
> Convert a couple uses of 6 in gr_private.h to ETH_ALEN.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
