Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab3LKFUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:20:46 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3LKFUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:20:42 -0500
Date: Wed, 11 Dec 2013 00:20:40 -0500 (EST)
Message-Id: <20131211.002040.1061939246483044835.davem@davemloft.net>
To: joe@perches.com
Cc: viro@zeniv.linux.org.uk, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH -next 0/3] seq_printf/puts/putc: Start to convert to
 return void
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1386738050.git.joe@perches.com>
References: <cover.1386738050.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 10 Dec 2013 21:20:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 10 Dec 2013 21:12:41 -0800

> Many uses of the return value of seq_printf/seq_puts/seq_putc are
> incorrect.  Many assume that the return value is the number of
> chars emitted into a buffer like printf/puts/putc.
> 
> It would be better to make the return value of these functions void
> to avoid these misuses.
> 
> Start to do so.
> Convert seq_overflow to a public function from a static function.
> 
> Remove the return uses of seq_printf/seq_puts/seq_putc from net.
> Add a seq_overflow function call instead.

I'm fine with this going in whatever tree is appropriate for
the seq_overflow un-static change:

Acked-by: David S. Miller <davem@davemloft.net>
