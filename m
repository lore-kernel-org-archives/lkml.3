Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3H2Enq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 00:43:46 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:51074 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755823Ab3H2Eno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 00:43:44 -0400
Date: Thu, 29 Aug 2013 14:43:08 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Richard Weinberger <richard@nod.at>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, gang.chen@asianux.com
Subject: Re: [PATCH] kernel/padata.c: Register hotcpu notifier after
 initialization
Message-ID: <20130829044308.GC25208@gondor.apana.org.au>
References: <1377256353-7979-1-git-send-email-richard@nod.at>
 <20130827093041.GD7660@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827093041.GD7660@secunet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:30:41AM +0200, Steffen Klassert wrote:
> On Fri, Aug 23, 2013 at 01:12:33PM +0200, Richard Weinberger wrote:
> > padata_cpu_callback() takes pinst->lock, to avoid taking
> > an uninitialized lock, register the notifier after it's
> > initialization.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Looks ok,
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
