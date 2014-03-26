Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaCZTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:46:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46295 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaCZTqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:46:51 -0400
Date: Wed, 26 Mar 2014 15:46:48 -0400 (EDT)
Message-Id: <20140326.154648.2160205796112896190.davem@davemloft.net>
To: joe@perches.com
Cc: dm@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] chelsio: Remove addressof casts to same type
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395683112.13968.59.camel@joe-AO722>
References: <1395683112.13968.59.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 12:46:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 24 Mar 2014 10:45:12 -0700

> Using addressof then casting to the original type is pointless,
> so remove these unnecessary casts.
> 
> Done via coccinelle script:
> 
> $ cat typecast.cocci 
> @@
> type T;
> T foo;
> @@
> 
> -	(T *)&foo
> +	&foo
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
