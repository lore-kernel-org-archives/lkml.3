Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEWVKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:10:18 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:58850 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaEWVKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:10:15 -0400
Date: Sat, 24 May 2014 05:10:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
        pwalten@au1.ibm.com, joe@perches.com
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Message-ID: <20140523211007.GA20955@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917794.FPSphFc8Fa@myon.chronox.de>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller@chronox.de> wrote:
>
> +       memset(&drbg_algs[i], 0, sizeof(struct crypto_alg));
> +       if (pr) {
> +               memcpy(drbg_algs[i].cra_name, "drbg(pr(", 8);
> +               memcpy(drbg_algs[i].cra_driver_name, "drbg_pr_", 8);
> +               pos = 8;

You shouldn't use the brackets here since this not a real template.
Just use one name for both cra_name and cra_driver_name.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
