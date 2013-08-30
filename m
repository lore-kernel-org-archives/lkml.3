Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3H3CJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 22:09:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41360 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3H3CJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 22:09:28 -0400
Date: Thu, 29 Aug 2013 22:09:26 -0400 (EDT)
Message-Id: <20130829.220926.226210132086755040.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH net-next] drivers:net: Convert
 dma_alloc_coherent(...__GFP_ZERO) to dma_zalloc_coherent
From: David Miller <davem@davemloft.net>
In-Reply-To: <1377582323.2658.10.camel@joe-AO722>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
	<1377582323.2658.10.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 29 Aug 2013 19:09:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 26 Aug 2013 22:45:23 -0700

> __GFP_ZERO is an uncommon flag and perhaps is better
> not used.  static inline dma_zalloc_coherent exists
> so convert the uses of dma_alloc_coherent with __GFP_ZERO
> to the more common kernel style with zalloc.
> 
> Remove memset from the static inline dma_zalloc_coherent
> and add just one use of __GFP_ZERO instead.
> 
> Trivially reduces the size of the existing uses of
> dma_zalloc_coherent.
> 
> Realign arguments as appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks a lot Joe.
