Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3DWRKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:10:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52986 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3DWRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:10:12 -0400
Date: Tue, 23 Apr 2013 13:10:05 -0400 (EDT)
Message-Id: <20130423.131005.417093102271757523.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130423174618.59095bd1cf999c61332d4805@canb.auug.org.au>
References: <20130423174618.59095bd1cf999c61332d4805@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 23 Apr 2013 10:10:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Apr 2013 17:46:18 +1000

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> net/netlink/af_netlink.c: In function 'netlink_frame_flush_dcache':
> net/netlink/af_netlink.c:384:40: error: 'NL_MMAP_MSG_HDRLEN' undeclared (first use in this function)
> 
> Caused by commit 9652e931e73b ("netlink: add mmap'ed netlink helper
> functions").  This needed to be build tested on an architecture that has
> ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE set to 1 (like Sparc :-)).

Sorry, my Sparcs are busy debugging other things at the moment :-)
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 23 Apr 2013 17:40:35 +1000
> Subject: [PATCH] netlink: fix typo in net/netlink/af_netlink.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied, thanks!
