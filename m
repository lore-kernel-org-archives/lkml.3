Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3CVJpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:45:08 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36248 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3CVJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:45:06 -0400
Date: Fri, 22 Mar 2013 02:38:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jingoo Han <jg1.han@samsung.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] hwrng: exynos - add CONFIG_PM_RUNTIME to suspend/resume
 functions
In-Reply-To: <00ad01ce26a0$652a58e0$2f7f0aa0$%han@samsung.com>
Message-ID: <alpine.DEB.2.02.1303220238190.12597@chino.kir.corp.google.com>
References: <009c01ce268e$644fdc90$2cef95b0$%han@samsung.com> <00ad01ce26a0$652a58e0$2f7f0aa0$%han@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Jingoo Han wrote:

> Add CONFIG_PM_RUNTIME to suspend/resume functions to fix the build
> error. It is because UNIVERSAL_DEV_PM_OPS macro is related to both
> CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
> 
> drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_suspend' undeclared here (not in a function)
> drivers/char/hw_random/exynos-rng.c:167:8: error: 'exynos_rng_runtime_resume' undeclared here (not in a function)
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Reported-by: David Rientjes <rientjes@google.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David Rientjes <rientjes@google.com>
