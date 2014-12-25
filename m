Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaLYWq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 17:46:56 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56315 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaLYWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 17:46:55 -0500
Date: Fri, 26 Dec 2014 09:46:51 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: AF_ALG: zeroize key data
Message-ID: <20141225224651.GA19828@gondor.apana.org.au>
References: <4092638.L73RGXcGnC@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4092638.L73RGXcGnC@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 09:34:03AM +0100, Stephan Mueller wrote:
> alg_setkey should zeroize the sensitive data after use.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
