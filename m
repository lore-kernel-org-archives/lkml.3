Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbbATDsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:48:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35878 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbATDry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:47:54 -0500
Date: Tue, 20 Jan 2015 14:47:50 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-crypto@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: Documentation: remove colons in comments
Message-ID: <20150120034750.GB11274@gondor.apana.org.au>
References: <4431066.AhB5zCO9nr@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4431066.AhB5zCO9nr@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:13:39AM +0100, Stephan Mueller wrote:
> As documented in Documentation/kernel-doc-nano-HOWTO.txt lines
> terminated with a colon are treated as headings.
> 
> The current layout of the documentation when compiling the kernel
> crypto API DocBook documentation is messed up by by treating some lines
> as headings. The patch removes colons from comments that shall not be
> treated as headings.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
