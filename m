Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3KSCPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:15:09 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:60128 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679Ab3KSCPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:15:05 -0500
Date: Tue, 19 Nov 2013 10:14:09 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Matt Mackall <mpm@selenic.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] hwrng: OMAP3 ROM Random Number Generator support
Message-ID: <20131119021409.GA2820@gondor.apana.org.au>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <20131008190408.GM8313@atomide.com>
 <20131016125734.GA10906@gondor.apana.org.au>
 <201311182251.35704@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311182251.35704@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:51:30PM +0100, Pali Rohár wrote:
> On Wednesday 16 October 2013 14:57:34 Herbert Xu wrote:
> > On Tue, Oct 08, 2013 at 12:04:09PM -0700, Tony Lindgren wrote:
> > > * Pali Rohár <pali.rohar@gmail.com> [130920 06:33]:
> > > > This driver provides kernel-side support for the Random
> > > > Number Generator hardware found on OMAP34xx processors.
> > > > 
> > > > This driver comes from Maemo 2.6.28 kernel and was tested
> > > > on Nokia RX-51. It is platform device because it needs
> > > > board specific function for smc calls.
> > > 
> > > This one is should be merged via the hw_random patches
> > > seprately:
> > > 
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> > Patch applied.  Thanks!
> 
> Hello, I still do not see this patch (2/3) in linus tree. But 
> patch 1/3 and 3/3 are already merged. So is there any problem?

2/3 is still in my tree so when Linus pulls it it'll be there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
