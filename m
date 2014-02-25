Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBYMRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:17:45 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54792 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaBYMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:17:44 -0500
Date: Tue, 25 Feb 2014 20:17:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Nicolas Ferre'" <nicolas.ferre@atmel.com>,
        "'Peter Korsgaard'" <jacmet@sunsite.dk>
Subject: Re: [PATCH 1/2] hwrng: atmel - Use devm_ioremap_resource()
Message-ID: <20140225121736.GD12216@gondor.apana.org.au>
References: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cf27b1$acf29f30$06d7dd90$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:17:08PM +0900, Jingoo Han wrote:
> Use devm_ioremap_resource() in order to make the code simpler,
> and remove redundant return value check of platform_get_resource()
> because the value is checked by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
