Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3LFViE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:38:04 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42813 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3LFViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:38:00 -0500
Date: Fri, 06 Dec 2013 16:37:58 -0500 (EST)
Message-Id: <20131206.163758.1360809557088338617.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ether_addr_equal: Optimize implementation,
 remove unused compare_ether_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <34a0bad292ab2535a3a2e757a83eca13408e55b7.1386283991.git.joe@perches.com>
References: <34a0bad292ab2535a3a2e757a83eca13408e55b7.1386283991.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 06 Dec 2013 13:38:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu,  5 Dec 2013 14:54:38 -0800

> Add a new check for CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to reduce
> the number of or's used in the ether_addr_equal comparison to very
> slightly improve function performance.
> 
> Simplify the ether_addr_equal_64bits implementation.
> Integrate and remove the zap_last_2bytes helper as it's now
> used only once.
> 
> Remove the now unused compare_ether_addr function.
> 
> Update the unaligned-memory-access documentation to remove the
> compare_ether_addr description and show how unaligned accesses
> could occur with ether_addr_equal.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
