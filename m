Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaHAOlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:41:06 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:39551 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaHAOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:41:03 -0400
Date: Fri, 1 Aug 2014 22:41:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] DRBG: fix failure of generating multiple of 2**16 bytes
Message-ID: <20140801144100.GG15005@gondor.apana.org.au>
References: <7159935.MYAcUzQ1Ny@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7159935.MYAcUzQ1Ny@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 09:47:33PM +0200, Stephan Mueller wrote:
> The function drbg_generate_long slices the request into 2**16 byte
> or smaller chunks. However, the loop, however invokes the random number
> generation function with zero bytes when the request size is a multiple
> of 2**16 bytes. The fix prevents zero bytes requests.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
