Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbaKTHpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:45:38 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57289 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKTHpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:45:35 -0500
Date: Thu, 20 Nov 2014 15:45:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephan Mueller <smueller@chronox.de>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: crypto: user - Allow get request with empty driver name
Message-ID: <20141120074526.GB29544@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <1886827.KUDIsNtfuk@tachyon.chronox.de>
 <20141120041824.GA28612@gondor.apana.org.au>
 <3538055.XH2t7HNEVj@tachyon.chronox.de>
 <20141120044650.GA28691@gondor.apana.org.au>
 <20141120071141.GS6390@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120071141.GS6390@secunet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 08:11:42AM +0100, Steffen Klassert wrote:
>
> I think this is not sufficient, crypto_alg_match() will now return the first
> algorithm in crypto_alg_list that matches cra_name. We would need to extend
> crypto_alg_match() to return the algorithm with the highest priority in that
> case.

It doesn't really matter because all implementations must provide
exactly the same set of parameters for a given algorithm so it's
good enough for what Stephan wants to do.

But yes an interface to grab the highest priority algorithm would
be useful too so patches are welcome :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
