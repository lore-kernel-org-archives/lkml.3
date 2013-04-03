Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658Ab3DCBxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:53:35 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:55504 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760241Ab3DCBxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:53:32 -0400
Date: Wed, 3 Apr 2013 09:53:27 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: caam - change key gen functions to
 return signed int
Message-ID: <20130403015327.GD20205@gondor.apana.org.au>
References: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364339415-23068-1-git-send-email-kim.phillips@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 06:10:14PM -0500, Kim Phillips wrote:
> commit 2af8f4a "crypto: caam - coccicheck fixes" added error
> return values yet neglected to change the type from unsigned.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
