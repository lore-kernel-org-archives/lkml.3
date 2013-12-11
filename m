Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3LKDQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:16:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3LKDQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:16:15 -0500
Date: Tue, 10 Dec 2013 22:16:13 -0500 (EST)
Message-Id: <20131210.221613.1663906151846555561.davem@davemloft.net>
To: dvlasenk@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        jpirko@redhat.com
Subject: Re: [patch net-next] ipv6: log autoconfiguration failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386606408-21552-1-git-send-email-dvlasenk@redhat.com>
References: <1386606408-21552-1-git-send-email-dvlasenk@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 19:16:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <dvlasenk@redhat.com>
Date: Mon,  9 Dec 2013 17:26:48 +0100

> If ipv6 auto-configuration does not work, currently it's hard
> to track what's going on. This change adds log messages
> (at debug level) on every code path where ipv6 autoconf fails.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Add statistics, those are more globally useful.

> +		pr_debug("IPv6 addrconf: %s: address length %d != %s\n",
> +				dev->name, dev->addr_len, "ETH_ALEN");

And this is not indented correctly, the arguments on lines after the
first must line up exactly to the column after the openning parenthesis
of the function call.

The idea isn't to use just TABs until you think it looks nice, rather
you should use the appropriate number of SPACE and TAB characters
necessary to reach the exact column.
