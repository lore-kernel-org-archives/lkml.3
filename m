Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3CVKP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:15:26 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43134 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932633Ab3CVKPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:15:24 -0400
Date: Fri, 22 Mar 2013 18:15:14 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hwrng: exynos - add CONFIG_PM_RUNTIME to
 suspend/resume functions
Message-ID: <20130322101514.GA1905@gondor.apana.org.au>
References: <009c01ce268e$644fdc90$2cef95b0$%han@samsung.com>
 <00ad01ce26a0$652a58e0$2f7f0aa0$%han@samsung.com>
 <alpine.DEB.2.02.1303220238190.12597@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303220238190.12597@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:38:53AM -0700, David Rientjes wrote:
> On Fri, 22 Mar 2013, Jingoo Han wrote:
> 
> > Add CONFIG_PM_RUNTIME to suspend/resume functions to fix the build
> > error. It is because UNIVERSAL_DEV_PM_OPS macro is related to both
> > CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
> > 
> > drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_suspend' undeclared here (not in a function)
> > drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_resume' undeclared here (not in a function)
> > 
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Reported-by: David Rientjes <rientjes@google.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Thanks, I've folded this into the original patch and rebased
the tree so that it is bisectable.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
