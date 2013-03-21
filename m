Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3CUKhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:37:06 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:40700 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753199Ab3CUKhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:37:05 -0400
Date: Thu, 21 Mar 2013 17:55:14 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] hw_random: mxc-rnga: Use devm_ioremap_resource()
Message-ID: <20130321095514.GF26931@gondor.apana.org.au>
References: <1363147047-22546-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363147047-22546-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:57:27AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Using devm_ioremap_resource() can make the code cleaner and simpler.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
