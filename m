Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFFBqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:46:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52927 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaFFBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:46:08 -0400
Date: Thu, 05 Jun 2014 18:46:04 -0700 (PDT)
Message-Id: <20140605.184604.449700096883990839.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] ip_tunnel: fix possible rtable leak
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140606043437.f50f21cd56243ffa30165710@qrator.net>
References: <20140606043437.f50f21cd56243ffa30165710@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Jun 2014 18:46:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Fri, 6 Jun 2014 04:34:37 +0400

> ip_rt_put(rt) is always called in "error" branches above, but was missed in
> skb_cow_head branch. As rt is not yet bound to skb here we have to release it by 
> hand.
> 
> Signed-off-by: Dmitry Popov <ixaphire@qrator.net>

Applied, thanks.
