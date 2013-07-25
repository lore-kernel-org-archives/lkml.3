Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3GYCDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:03:42 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58252 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754388Ab3GYCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:03:41 -0400
Date: Thu, 25 Jul 2013 12:03:29 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>, davem@davemloft.net,
        tim.c.chen@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] modules: add support for soft module dependencies
Message-ID: <20130725020329.GA14625@gondor.apana.org.au>
References: <20130724071757.GA30970@gondor.apana.org.au>
 <87siz38q2t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87siz38q2t.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 09:32:02AM +0930, Rusty Russell wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> > Hi Rusty:
> >
> > I don't know why this patch never went into the kernel, even
> > though the corresponding features have been added to modprobe
> > in most if not all distros.
> 
> Because Andreas never sent me the patch?  This is the first I've *heard*
> of this feature.  Looks like it didn't hit lkml either.  And what was
> 2/2?

2/2 was the patch to actually use this in crc32c.

> It's not how I would have done this: post-deps are more flexibly done at
> runtime, because the module may have to do work to figure out what to
> pull in.  But since it already exists, I'll apply this patch: it doesn't
> cost the kernel anything.
> 
> And I've fixed the example, so we know how to list multiple modules!

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
