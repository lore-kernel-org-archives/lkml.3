Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3HWKrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:47:42 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:57395 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754564Ab3HWKrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:47:40 -0400
Date: Fri, 23 Aug 2013 20:47:32 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Chen Gang <gang.chen@asianux.com>, linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/padata.c: share code between CPU_ONLINE and
 CPU_DOWN_FAILED, same to CPU_DOWN_PREPARE and CPU_UP_CANCELED
Message-ID: <20130823104731.GA30865@gondor.apana.org.au>
References: <5212E5E4.8010408@asianux.com>
 <5212E61F.7010602@asianux.com>
 <20130822051122.GB26773@secunet.com>
 <5215A134.90607@asianux.com>
 <20130822060503.GC26773@secunet.com>
 <5215B319.3020908@asianux.com>
 <20130823104448.GI26773@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823104448.GI26773@secunet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 12:44:48PM +0200, Steffen Klassert wrote:
> On Thu, Aug 22, 2013 at 02:43:37PM +0800, Chen Gang wrote:
> > Share code between CPU_ONLINE and CPU_DOWN_FAILED, same to
> > CPU_DOWN_PREPARE and CPU_UP_CANCELED.
> > 
> > It will fix 2 bugs:
> > 
> >   "not check the return value of __padata_remove_cpu() and __padata_add_cpu()".
> >   "need add 'break' between CPU_UP_CANCELED and CPU_DOWN_FAILED".
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> This looks ok to me, Herbert can you take this one?

Sure.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
