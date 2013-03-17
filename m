Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab3CQQur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:50:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3CQQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:50:44 -0400
Date: Sun, 17 Mar 2013 12:50:42 -0400 (EDT)
Message-Id: <20130317.125042.778916600527811234.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH net-next] drivers:net: dma_alloc_coherent: use
 __GFP_ZERO instead of memset(, 0)
From: David Miller <davem@davemloft.net>
In-Reply-To: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:50:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 15 Mar 2013 10:23:58 -0700

> Reduce the number of calls required to alloc
> a zeroed block of memory.
> 
> Trivially reduces overall object size.
> 
> Other changes around these removals
> o Neaten call argument alignment
> o Remove an unnecessary OOM message after dma_alloc_coherent failure
> o Remove unnecessary gfp_t stack variable
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Looks good, applied, thanks Joe.
