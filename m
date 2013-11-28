Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3K1OSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:18:42 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:37780 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab3K1OSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:18:38 -0500
Date: Thu, 28 Nov 2013 22:18:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] crypto: authenc - Find proper IV address in
 ablkcipher callback
Message-ID: <20131128141832.GB32124@gondor.apana.org.au>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
 <20131112174604.19746.83804.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112174604.19746.83804.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:46:04AM -0600, Tom Lendacky wrote:
> When performing an asynchronous ablkcipher operation the authenc
> completion callback routine is invoked, but it does not locate and use
> the proper IV.
> 
> The callback routine, crypto_authenc_encrypt_done, is updated to use
> the same method of calculating the address of the IV as is done in
> crypto_authenc_encrypt function which sets up the callback.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
