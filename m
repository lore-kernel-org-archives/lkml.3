Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaL2KmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:42:07 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51392 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaL2KmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:42:05 -0500
Date: Mon, 29 Dec 2014 21:41:58 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 4/4] crypto: AF_ALG: enable RNG interface compilation
Message-ID: <20141229104158.GB13699@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <1531939.gTKbxagG6Z@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1531939.gTKbxagG6Z@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 11:00:39PM +0100, Stephan Mueller wrote:
> Enable compilation of the RNG AF_ALG support and provide a Kconfig
> option to compile the RNG AF_ALG support.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
