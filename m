Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3JZJQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:16:25 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:48881 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750876Ab3JZJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:16:22 -0400
Date: Sat, 26 Oct 2013 17:15:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Matt Mackall <mpm@selenic.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
Message-ID: <20131026091519.GA28935@gondor.apana.org.au>
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
 <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
 <526799B6.1090904@mm-sol.com>
 <20131023094530.GA21796@gondor.apana.org.au>
 <526A78C3.9030002@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526A78C3.9030002@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 04:57:23PM +0300, Stanimir Varbanov wrote:
> Hi Herbert,
> 
> On 10/23/2013 12:45 PM, Herbert Xu wrote:
> > On Wed, Oct 23, 2013 at 12:41:10PM +0300, Stanimir Varbanov wrote:
> >> On 10/15/2013 05:11 PM, Stanimir Varbanov wrote:
> >>> This adds a driver for hardware random number generator present
> >>> on Qualcomm MSM SoC's.
> >>>
> >>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> >>
> >> Hi Matt, Herbert,
> >>
> >> Sorry for the noise but this patch staying for a while in mailing list
> >> and I'd like to get some attention to this driver. Do you think it needs
> >> another re-spin or it has obvious issues / concerns?
> >>
> >> Thanks for your time.
> > 
> > Well if the ARM folks are OK with it I'm happy to take them.
> 
> Thanks!
> 
> Can I add your Acked-by for the driver part patch 2/2?

Sure.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
