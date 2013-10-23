Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3JWJqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:46:09 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:59385 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936Ab3JWJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:46:07 -0400
Date: Wed, 23 Oct 2013 17:45:30 +0800
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
Message-ID: <20131023094530.GA21796@gondor.apana.org.au>
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
 <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
 <526799B6.1090904@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526799B6.1090904@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:41:10PM +0300, Stanimir Varbanov wrote:
> On 10/15/2013 05:11 PM, Stanimir Varbanov wrote:
> > This adds a driver for hardware random number generator present
> > on Qualcomm MSM SoC's.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> Hi Matt, Herbert,
> 
> Sorry for the noise but this patch staying for a while in mailing list
> and I'd like to get some attention to this driver. Do you think it needs
> another re-spin or it has obvious issues / concerns?
> 
> Thanks for your time.

Well if the ARM folks are OK with it I'm happy to take them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
