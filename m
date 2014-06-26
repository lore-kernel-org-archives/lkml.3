Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaFZDqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 23:46:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40602 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaFZDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 23:46:14 -0400
Date: Wed, 25 Jun 2014 20:46:13 -0700 (PDT)
Message-Id: <20140625.204613.736194500616545556.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: therbert@google.com, torvalds@linux-foundation.org, davej@redhat.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fix setting csum_start in skb_segment()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403725861.3796.47.camel@edumazet-glaptop2.roam.corp.google.com>
References: <alpine.DEB.2.02.1406242056330.29780@tomh.mtv.corp.google.com>
	<1403725861.3796.47.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 20:46:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 25 Jun 2014 12:51:01 -0700

> From: Tom Herbert <therbert@google.com>
> 
> Dave Jones reported that a crash is occurring in
 ...
> It looks like a likely culprit is that SKB_GSO_CB()->csum_start is
> not set correctly when doing non-scatter gather. We are using
> offset as opposed to doffset.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Tested-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Tom Herbert <therbert@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Fixes: 7e2b10c1e52ca ("net: Support for multiple checksums with gso")

Applied, thanks everyone.
