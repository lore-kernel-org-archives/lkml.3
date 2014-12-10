Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbaLJUdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:33:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47602 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaLJUdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:33:38 -0500
Date: Wed, 10 Dec 2014 15:33:36 -0500 (EST)
Message-Id: <20141210.153336.869064783048125658.davem@davemloft.net>
To: joe@perches.com
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irda: Convert function pointer arrays and uses to const
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418236138.18092.13.camel@perches.com>
References: <1418236138.18092.13.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 12:33:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 10 Dec 2014 10:28:58 -0800

> Making things const is a good thing.
> 
> (x86-64 defconfig with all irda)
> $ size net/irda/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  109276	   1868	    244	 111388	  1b31c	net/irda/built-in.o.new
>  108828	   2316	    244	 111388	  1b31c	net/irda/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
