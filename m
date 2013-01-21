Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3AUW2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:28:07 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41079 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3AUW2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:28:04 -0500
Date: Mon, 21 Jan 2013 14:28:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.hengli.com.au, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH 1/1] char: hw_random: Make exynos_rng_pm_ops static
Message-ID: <20130121222800.GA27601@kroah.com>
References: <1358768749-6061-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358768749-6061-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 05:15:49PM +0530, Sachin Kamat wrote:
> 'exynos_rng_pm_ops' is used only in this file. Without this patch
> we get the following sparse warning:
> drivers/char/hw_random/exynos-rng.c:165:1: warning:
> symbol 'exynos_rng_pm_ops' was not declared. Should it be static?
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/char/hw_random/exynos-rng.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Sorry, someone else already sent in this patch on Saturday.

greg k-h
