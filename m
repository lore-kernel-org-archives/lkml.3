Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaBQF3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:29:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40270 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaBQF3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:29:49 -0500
Date: Mon, 17 Feb 2014 00:29:47 -0500 (EST)
Message-Id: <20140217.002947.1273623195685496622.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] bonding cleaning
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1392508410.git.joe@perches.com>
References: <cover.1392508410.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2014 21:29:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 15 Feb 2014 15:57:03 -0800

> Miscellaneous cleanups
> 
> Joe Perches (4):
>   bonding: Convert pr_warning to pr_warn, neatening
>   bonding: Neaten pr_<level>
>   bonding: Convert c99 comments
>   bonding: Convert memcpy(foo, bar, ETH_ALEN) to ether_addr_copy(foo, bar)

Series applied, thanks.
