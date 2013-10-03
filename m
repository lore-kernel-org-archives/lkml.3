Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3JCTl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:41:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab3JCTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:41:26 -0400
Date: Thu, 03 Oct 2013 15:41:24 -0400 (EDT)
Message-Id: <20131003.154124.919042100815203643.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: hykim@myri.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/19 v2] net: myri10ge: Change variable type to bool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380716391-20214-3-git-send-email-peter.senna@gmail.com>
References: <1380716391-20214-1-git-send-email-peter.senna@gmail.com>
	<1380716391-20214-3-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 12:41:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Wed,  2 Oct 2013 14:19:50 +0200

> There is the rc variable on both myri10ge_ss_lock_napi and
> myri10ge_ss_lock_poll functions. In both cases rc is only assigned the
> values true and false. Both functions already return bool. Change rc
> type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.
