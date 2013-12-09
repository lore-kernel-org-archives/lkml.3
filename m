Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3LIL5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:57:25 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54765 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab3LIL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:57:24 -0500
Date: Mon, 9 Dec 2013 19:57:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scatterwalk - Use sg_chain_ptr on chain entries
Message-ID: <20131209115719.GA1433@gondor.apana.org.au>
References: <20131205190953.16167.59879.stgit@tlendack-t1.amdoffice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205190953.16167.59879.stgit@tlendack-t1.amdoffice.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:09:53PM -0600, Tom Lendacky wrote:
> Now that scatterwalk_sg_chain sets the chain pointer bit the sg_page
> call in scatterwalk_sg_next hits a BUG_ON when CONFIG_DEBUG_SG is
> enabled. Use sg_chain_ptr instead of sg_page on a chain entry.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
