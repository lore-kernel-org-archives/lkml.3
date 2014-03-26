Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaCZTsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:48:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46319 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbaCZTrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:47:39 -0400
Date: Wed, 26 Mar 2014 15:47:37 -0400 (EDT)
Message-Id: <20140326.154737.1717367560265062054.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/7] alx: Remove casts of pointer to same type
From: David Miller <davem@davemloft.net>
In-Reply-To: <b8c7eec08a896af664e5ef18d1278504f450cfee.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
	<b8c7eec08a896af664e5ef18d1278504f450cfee.1395692043.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 12:47:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 24 Mar 2014 13:15:35 -0700

> Casting a pointer to a pointer of the same type is pointless,
> so remove these unnecessary casts.
> 
> Done via coccinelle script:
> 
> $ cat typecast_2.cocci
> @@
> type T;
> T *foo;
> @@
> 
> -	(T *)foo
> +	foo
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
