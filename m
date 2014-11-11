Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKKETZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:19:25 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34531 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaKKETY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:19:24 -0500
Date: Tue, 11 Nov 2014 12:19:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Sandy Harris <sandyinchina@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: crypto: zeroization of sensitive data in af_alg
Message-ID: <20141111041921.GA14667@gondor.apana.org.au>
References: <1979092.odOtqL46qU@tachyon.chronox.de>
 <CACXcFmmp=SMisc0p-Fx=M3myXE0E-kH3zN6NGrODeVzQrXUdFA@mail.gmail.com>
 <3021915.VU7Ypy9It6@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3021915.VU7Ypy9It6@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 05:16:54AM +0100, Stephan Mueller wrote:
> 
> Shall I now still use memset(0) or prepare a patch that does not yet compile 
> by using memzero_explicit?

Just send the patch with the memzer_explicit and I'll make sure
that I pull the requisite changes in before I apply your patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
