Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbbAHKs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:48:57 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:38963 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbAHKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:48:56 -0500
Date: Thu, 8 Jan 2015 21:48:52 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] crypto: AEAD: add check for presence of auth tag
Message-ID: <20150108104852.GB8374@gondor.apana.org.au>
References: <2529951.NL2CVhi6xs@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2529951.NL2CVhi6xs@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:21:45PM +0100, Stephan Mueller wrote:
> The AEAD decryption operation requires the authentication tag to be
> present as part of the cipher text buffer. The added check verifies that
> the caller provides a cipher text with at least the authentication tag.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
