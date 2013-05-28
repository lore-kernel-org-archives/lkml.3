Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab3E1JQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:16:21 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:57730 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933615Ab3E1JQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:16:20 -0400
Date: Tue, 28 May 2013 17:16:15 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        "'Deepak Saxena'" <dsaxena@plexity.net>
Subject: Re: [PATCH] hwrng: use platform_{get,set}_drvdata()
Message-ID: <20130528091615.GB24414@gondor.apana.org.au>
References: <002801ce57a0$1f004ba0$5d00e2e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002801ce57a0$1f004ba0$5d00e2e0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 07:27:26PM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Also, unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Sorry but this patch doesn't apply against the current cryptodev
tree.  If you are basing your patch on another tree, please submit
the patch there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
