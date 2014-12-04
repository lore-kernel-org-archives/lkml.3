Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaLDPrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:47:23 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44073 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaLDPrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:47:22 -0500
Date: Thu, 4 Dec 2014 23:47:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        "Theodore Ts'o" <tytso@mit.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Where exactly will arch_fast_hash be used
Message-ID: <20141204154708.GA22185@gondor.apana.org.au>
References: <20141204081147.GA19030@gondor.apana.org.au>
 <20141204152637.GA32140@casper.infradead.org>
 <20141204152929.GA22075@gondor.apana.org.au>
 <20141204153938.GC32140@casper.infradead.org>
 <54808123.8000704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54808123.8000704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 04:43:31PM +0100, Daniel Borkmann wrote:
>
> Hm, I thought the kernel doc on arch_fast_hash() in include/linux/hash.h
> would give enough of a hint ...

I think something more explicit like "do not use this in a hash
table unless you know what you're doing" might be needed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
