Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaBTArR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:47:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49106 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBTArP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:47:15 -0500
Date: Wed, 19 Feb 2014 19:47:13 -0500 (EST)
Message-Id: <20140219.194713.1411547109743205257.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/4] Sparc: sparc_cpu_model isn't in asm/system.h any
 more
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140212154559.2405.3104.stgit@warthog.procyon.org.uk>
References: <20140212154544.2405.2992.stgit@warthog.procyon.org.uk>
	<20140212154559.2405.3104.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 16:47:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 12 Feb 2014 15:45:59 +0000

> sparc_cpu_model isn't in asm/system.h any more, so remove a comment about it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

That's not all your patch does:

> -	/* extern enum sparc_cpu sparc_cpu_model; */ /* in <asm/system.h> */
> -	if (sparc_cpu_model != sun4m) {
> +	if (sparc_cpu_model != sun4m)
>  		/* We must be on sun4m because we use MMU Bypass ASI. */
>  		return -ENXIO;
> -	}

The basic block is more than one line, therefore the braces are
appropriate.  Please do not remove them, and especially do not
remove them without mentioning them in the commit message.

Thanks.
