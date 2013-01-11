Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3AKGt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:49:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3AKGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:49:56 -0500
Date: Thu, 10 Jan 2013 22:49:54 -0800 (PST)
Message-Id: <20130110.224954.902891494419623809.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: normalperson@yhbt.net, netdev@vger.kernel.org, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        minchan@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: 3.8-rc2/rc3 write() blocked on CLOSE_WAIT TCP socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357870727.27446.2988.camel@edumazet-glaptop>
References: <20130111004915.GA15415@dcvr.yhbt.net>
	<1357869675.27446.2962.camel@edumazet-glaptop>
	<1357870727.27446.2988.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 10 Jan 2013 18:18:47 -0800

> [PATCH] tcp: accept RST without ACK flag
> 
> commit c3ae62af8e755 (tcp: should drop incoming frames without ACK flag
> set) added a regression on the handling of RST messages.
> 
> RST should be allowed to come even without ACK bit set. We validate
> the RST by checking the exact sequence, as requested by RFC 793 and 
> 5961 3.2, in tcp_validate_incoming()
> 
> Reported-by: Eric Wong <normalperson@yhbt.net>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
