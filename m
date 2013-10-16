Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab3JPM6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:58:02 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:45062 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934199Ab3JPM57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:57:59 -0400
Date: Wed, 16 Oct 2013 20:57:34 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Russell King <linux@arm.linux.org.uk>,
        Joe Perches <joe@perches.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juha Yrjola <juha.yrjola@solidboot.com>
Subject: Re: [PATCH v2 2/3] hwrng: OMAP3 ROM Random Number Generator support
Message-ID: <20131016125734.GA10906@gondor.apana.org.au>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-1-git-send-email-pali.rohar@gmail.com>
 <1379683507-30793-3-git-send-email-pali.rohar@gmail.com>
 <20131008190408.GM8313@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131008190408.GM8313@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:04:09PM -0700, Tony Lindgren wrote:
> * Pali Rohár <pali.rohar@gmail.com> [130920 06:33]:
> > This driver provides kernel-side support for the Random Number
> > Generator hardware found on OMAP34xx processors.
> > 
> > This driver comes from Maemo 2.6.28 kernel and was tested on Nokia RX-51.
> > It is platform device because it needs board specific function for smc calls.
> 
> This one is should be merged via the hw_random patches seprately:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
