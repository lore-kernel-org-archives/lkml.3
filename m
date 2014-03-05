Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaCECCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:02:39 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:55652 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaCECCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:02:38 -0500
MIME-Version: 1.0
In-Reply-To: <004101cf3379$ada38d30$08eaa790$%han@samsung.com>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
	<004101cf3379$ada38d30$08eaa790$%han@samsung.com>
Date: Wed, 5 Mar 2014 10:02:37 +0800
Message-ID: <CACRpkdbAhW=TB9Yu=rOSJbcok_B8fGhPd-gJ_osC3ysTVvUVbA@mail.gmail.com>
Subject: Re: [PATCH 4/5] hwrng: nomadik - Use devm_*() functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Rubini <rubini@gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 1:06 PM, Jingoo Han <jg1.han@samsung.com> wrote:

> Use devm_*() functions to make cleanup paths simpler.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Excellent, thanks!

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
