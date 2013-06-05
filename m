Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3FEIxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:53:51 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:42109 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753083Ab3FEIxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:53:49 -0400
Date: Wed, 5 Jun 2013 16:53:44 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Deepak Saxena'" <dsaxena@plexity.net>
Subject: Re: [PATCH V2] hwrng: use platform_{get,set}_drvdata()
Message-ID: <20130605085344.GD12202@gondor.apana.org.au>
References: <001801ce5c06$190091f0$4b01b5d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001801ce5c06$190091f0$4b01b5d0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:47:29AM +0900, Jingoo Han wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Also, unnecessary dev_set_drvdata() is removed, because the driver core
> clears the driver data to NULL after device_release or on probe failure.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
