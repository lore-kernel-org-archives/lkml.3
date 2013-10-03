Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3JCMzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:55:41 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46700 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3JCMzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:55:39 -0400
X-Greylist: delayed 2443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 08:55:38 EDT
Date: Thu, 3 Oct 2013 22:14:36 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Rob Landley <rob@landley.net>
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Kevin Mulvey <kevin@kevinmulvey.net>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, astor@fast.no
Subject: Re: Status of "kernel crypto services" patch? Re: [PATCH]
 Documentation: "kerneli" typo in description for "Serpent cipher algorithm"
 Bug #60848
Message-ID: <20131003121436.GA7651@gondor.apana.org.au>
References: <1380730237-42543-1-git-send-email-kevin@kevinmulvey.net>
 <1380737551.1974.127@driftwood>
 <524C645E.9030800@iki.fi>
 <1380739738.1974.129@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380739738.1974.129@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:48:58PM -0500, Rob Landley wrote:
> On 10/02/2013 01:22:22 PM, Jussi Kivilinna wrote:
> >On 02.10.2013 21:12, Rob Landley wrote:
> >> On 10/02/2013 11:10:37 AM, Kevin Mulvey wrote:
> >>> change kerneli to kernel as well as kerneli.org to kernel.org
> >>>
> >>> Signed-off-by: Kevin Mulvey <kevin@kevinmulvey.net>
> >>
> >> There's a bug number for this?
> >>
> >> Acked, queued. (Although I'm not sure the value of pointing to
> >www.kernel.org for this.)
> >
> >I think kerneli.org is correct.. see old website at
> >http://web.archive.org/web/20010201085500/http://www.kerneli.org/
> 
> Should I have the update link to the archive.org page, or...?
> 
> The above links to http://www.kernel.org/pub/linux/kernel/crypto
> which has patches for the 2.5 kernel circa 2003. Did this get
> merged, or dropped, or what?
> 
> (Documentation maintainership does not mean domain expert in
> everything, it's somewhere between librarian and janitor. Please
> tell me what to do here.)

The documentation is correct as is so please discard the patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
