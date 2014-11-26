Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaKZMKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:10:31 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55958 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaKZMK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:10:29 -0500
Date: Wed, 26 Nov 2014 20:10:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH v3] crypto: include crypto- module prefix in template
Message-ID: <20141126121024.GB16424@gondor.apana.org.au>
References: <20141125003238.GA17207@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125003238.GA17207@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 04:32:38PM -0800, Kees Cook wrote:
> This adds the module loading prefix "crypto-" to the template lookup
> as well.
> 
> For example, attempting to load 'vfat(blowfish)' via AF_ALG now correctly
> includes the "crypto-" prefix at every level, correctly rejecting "vfat":
> 
> 	net-pf-38
> 	algif-hash
> 	crypto-vfat(blowfish)
> 	crypto-vfat(blowfish)-all
> 	crypto-vfat
> 
> Reported-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Mathias Krause <minipli@googlemail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
