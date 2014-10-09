Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaJIW5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:57:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43680 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaJIW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:57:28 -0400
Date: Thu, 09 Oct 2014 18:57:26 -0400 (EDT)
Message-Id: <20141009.185726.2200139354739768161.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH] net: Missing @ before descriptions cause make xmldocs
 warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412827088-30718-1-git-send-email-standby24x7@gmail.com>
References: <1412827088-30718-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Oct 2014 15:57:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Thu,  9 Oct 2014 12:58:08 +0900

> This patch fix following warning.
> Warning(.//net/core/skbuff.c:4142): No description found for parameter 'header_len'
> Warning(.//net/core/skbuff.c:4142): No description found for parameter 'data_len'
> Warning(.//net/core/skbuff.c:4142): No description found for parameter 'max_page_order'
> Warning(.//net/core/skbuff.c:4142): No description found for parameter 'errcode'
> Warning(.//net/core/skbuff.c:4142): No description found for parameter 'gfp_mask'
> 
> Acutually the descriptions exist, but missing "@" in front.
> 
> This problem start to happen when following commit was merged
> into Linus's tree during 3.18-rc1 merge period.
> commit 2e4e44107176d552f8bb1bb76053e850e3809841
> net: add alloc_skb_with_frags() helper
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thank you.
