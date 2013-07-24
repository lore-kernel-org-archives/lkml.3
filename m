Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3GXXFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:05:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36089 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3GXXFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:05:30 -0400
Date: Wed, 24 Jul 2013 16:05:28 -0700 (PDT)
Message-Id: <20130724.160528.250036563854826098.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: jerry.snitselaar@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: potential out of bounds access in
 trie_show_stats()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130724150000.GB22402@order.stressinduktion.org>
References: <1374519718-8299-1-git-send-email-jerry.snitselaar@oracle.com>
	<20130724150000.GB22402@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 16:05:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Wed, 24 Jul 2013 17:00:00 +0200

> On Mon, Jul 22, 2013 at 12:01:58PM -0700, Jerry Snitselaar wrote:
>> With the <= max condition in the for loop, it will be always go 1
>> element further than needed. If the condition for the while loop is
>> never met, then max is MAX_STAT_DEPTH, and for loop will walk off the
>> end of nodesizes[].
>> 
>> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> 
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied, thanks.
