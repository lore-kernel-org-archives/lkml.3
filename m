Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3HABrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:47:36 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:44068 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752523Ab3HABre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:47:34 -0400
Date: Thu, 1 Aug 2013 11:47:30 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] hw_random: mxc-rnga: Check the return value from
 clk_prepare_enable()
Message-ID: <20130801014730.GD24286@gondor.apana.org.au>
References: <1374428498-14222-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374428498-14222-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 02:41:38PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> clk_prepare_enable() may fail, so let's check its return value and propagate it
> in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
