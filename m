Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3CUKhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:37:42 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:43215 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754453Ab3CUKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:37:23 -0400
Date: Thu, 21 Mar 2013 17:54:31 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>
Subject: Re: [PATCH] hwrng: exynos - add CONFIG_PM_SLEEP to suspend/resume
 functions
Message-ID: <20130321095430.GC26931@gondor.apana.org.au>
References: <003a01ce1ee4$ed8842b0$c898c810$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003a01ce1ee4$ed8842b0$c898c810$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:46:22PM +0900, Jingoo Han wrote:
> This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
> the following build warning when CONFIG_PM_SLEEP is not selected.
> 
> drivers/char/hw_random/exynos-rng.c:147:12: warning: 'exynos_rng_runtime_suspend' defined but not used [-Wunused-function]
> drivers/char/hw_random/exynos-rng.c:157:12: warning: 'exynos_rng_runtime_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
