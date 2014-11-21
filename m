Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaKUJBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:01:22 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:39390 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaKUJBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:01:20 -0500
Date: Fri, 21 Nov 2014 17:01:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mathias Krause <minipli@googlemail.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: prefix module autoloading with "crypto-"
Message-ID: <20141121090108.GA5984@gondor.apana.org.au>
References: <20141121010553.GA5959@www.outflux.net>
 <CA+rthh-AkVT4FmBXMiKYL8863eReYyE5g6+8wDEUiOnNevt_OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh-AkVT4FmBXMiKYL8863eReYyE5g6+8wDEUiOnNevt_OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 09:31:15AM +0100, Mathias Krause wrote:
>
> The last modlog call does not contain the "crypto-" prefix, therefore
> happily loads the vfat module.
> I guess crypto templates are handled special?

Yes templates are loaded in crypto_lookup_template so a small change
there (assuming this patch didn't change it) plus a few more aliases
to the template files should suffice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
