Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3ENCfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:35:20 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:35393 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755783Ab3ENCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:35:19 -0400
Date: Tue, 14 May 2013 10:35:09 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Garg Vakul-B16394 <B16394@freescale.com>
Cc: Gupta Ruchika-R66431 <R66431@freescale.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        Porosanu Alexandru-B06830 <B06830@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam - FIX RNG init for RNG greater than equal
 to 4
Message-ID: <20130514023509.GA19306@gondor.apana.org.au>
References: <1366971294-10673-1-git-send-email-ruchika.gupta@freescale.com>
 <065BBB7616BCE543832A2EF096986B941D616B@039-SN2MPN1-012.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <065BBB7616BCE543832A2EF096986B941D616B@039-SN2MPN1-012.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:34:19AM +0000, Garg Vakul-B16394 wrote:
> Reviewed-by: Vakul Garg <vakul@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
