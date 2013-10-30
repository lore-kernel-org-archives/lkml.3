Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3J3ELH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 00:11:07 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:45684 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716Ab3J3ELE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 00:11:04 -0400
Date: Wed, 30 Oct 2013 12:10:34 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] hwrng: msm: Add PRNG support for MSM SoC's
Message-ID: <20131030041034.GA2957@gondor.apana.org.au>
References: <1381846278-9529-1-git-send-email-svarbanov@mm-sol.com>
 <1381846278-9529-3-git-send-email-svarbanov@mm-sol.com>
 <52618060.1060804@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52618060.1060804@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 11:39:28AM -0700, Stephen Boyd wrote:
> On 10/15/13 07:11, Stanimir Varbanov wrote:
> > This adds a driver for hardware random number generator present
> > on Qualcomm MSM SoC's.
> >
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > ---
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
