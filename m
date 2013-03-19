Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3CSOfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:35:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43319 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3CSOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:35:38 -0400
Date: Tue, 19 Mar 2013 10:35:36 -0400 (EDT)
Message-Id: <20130319.103536.2293402411730251000.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: steffen.klassert@secunet.com, herbert@gondor.hengli.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baker.zhang@gmail.com
Subject: Re: [PATCH] use xfrm direction when lookup policy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363703070-2910-1-git-send-email-baker.zhang@gmail.com>
References: <1363703070-2910-1-git-send-email-baker.zhang@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 07:35:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baker Zhang <baker.kernel@gmail.com>
Date: Tue, 19 Mar 2013 22:24:30 +0800

> because xfrm policy direction has same value with corresponding
> flow direction, so this problem is covered.
> 
> In xfrm_lookup and __xfrm_policy_check, flow_cache_lookup is used to
> accelerate the lookup.
> 
> Flow direction is given to flow_cache_lookup by policy_to_flow_dir.
> 
> When the flow cache is mismatched, callback 'resolver' is called.
> 
> 'resolver' requires xfrm direction,
> so convert direction back to xfrm direction.
> 
> Signed-off-by: Baker Zhang <baker.zhang@gmail.com>

Since this is a cleanup and doesn't really fix a bug, I've applied
this to net-next.

Thanks.
