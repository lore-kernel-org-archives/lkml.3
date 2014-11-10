Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaKJOKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:10:19 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:58807 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaKJOKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:10:17 -0500
Date: Mon, 10 Nov 2014 22:10:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg - add MODULE_ALIAS for all DRBG types
Message-ID: <20141110141011.GA9152@gondor.apana.org.au>
References: <6130984.PGBGVNdX6r@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6130984.PGBGVNdX6r@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 03:08:09AM +0100, Stephan Mueller wrote:
> The kernel module drbg.ko is currently not loaded automatically when a
> DRBG is requested by a consumer. This is due to missing MODULE_ALIAS
> flags for each of the implemented DRBG types.
> 
> This patch adds aliases for each of the 22 defined DRBGs.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
