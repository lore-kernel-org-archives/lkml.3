Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111AbaLJUWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:22:10 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47469 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaLJUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:22:08 -0500
Date: Wed, 10 Dec 2014 15:22:04 -0500 (EST)
Message-Id: <20141210.152204.1151872702114872181.davem@davemloft.net>
To: joe@perches.com
Cc: acme@ghostprotocols.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3] llc: Make llc_sap_action_t function pointer arrays
 const
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418234150.18092.9.camel@perches.com>
References: <1418228330.18092.3.camel@perches.com>
	<1418233437.18092.7.camel@perches.com>
	<1418234150.18092.9.camel@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 12:22:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 10 Dec 2014 09:55:50 -0800

> It's better when function pointer arrays aren't modifiable.
> 
> Net change:
> 
> $ size net/llc/built-in.o.*
>    text	   data	    bss	    dec	    hex	filename
>   61193	  12758	   1344	  75295	  1261f	net/llc/built-in.o.new
>   47113	  27030	   1344	  75487	  126df	net/llc/built-in.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
