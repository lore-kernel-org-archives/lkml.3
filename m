Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030442Ab3HIGm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:42:28 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:41455 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030352Ab3HIGm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:42:27 -0400
Date: Fri, 9 Aug 2013 16:42:22 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 0/2] drivers/crypto/nx: fixes when input data is too
 large
Message-ID: <20130809064222.GA23834@gondor.apana.org.au>
References: <1375445392-16237-1-git-send-email-mhcerri@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375445392-16237-1-git-send-email-mhcerri@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:09:50PM +0000, Marcelo Cerri wrote:
> This series of patches fixes two bugs that are triggered when the input data is
> too large. The first one is caused by the miscalculation of physical addresses
> and the second one by some limits that the co-processor has to the input data.
> 
> Changes in v2:
>         * Replace Signed-Off-By tags with Reviewed-By tags where it is
> 	  appropriate.
> 
> Marcelo Cerri (2):
>   drivers/crypto/nx: fix physical addresses added to sg lists
>   drivers/crypto/nx: fix limits to sg lists for SHA-2

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
