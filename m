Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaBYMRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:17:15 -0500
Received: from ringil.hengli.com.au ([178.18.16.133]:54825 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaBYMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:17:14 -0500
Date: Tue, 25 Feb 2014 20:16:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hwrng: msm: switch Kconfig to ARCH_QCOM depends
Message-ID: <20140225121656.GB12216@gondor.apana.org.au>
References: <1392150105-21057-1-git-send-email-galak@codeaurora.org>
 <52FB3FDA.4060307@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB3FDA.4060307@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:33:14AM +0200, Stanimir Varbanov wrote:
> Hi,
> > We've split Qualcomm MSM support into legacy and multiplatform.  The RNG
> > driver is only relevant on the multiplatform supported SoCs so switch the
> > Kconfig depends to ARCH_QCOM.
> > 
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Kumar Gala <galak@codeaurora.org>
> > ---
> >  drivers/char/hw_random/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index 2f2b084..289bd3a 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -343,7 +343,7 @@ config HW_RANDOM_TPM
> >  
> >  config HW_RANDOM_MSM
> >  	tristate "Qualcomm MSM Random Number Generator support"
> > -	depends on HW_RANDOM && ARCH_MSM
> > +	depends on HW_RANDOM && ARCH_QCOM
> >  	---help---
> >  	  This driver provides kernel-side support for the Random Number
> >  	  Generator hardware found on Qualcomm MSM SoCs.
> > 
> 
> IMO, after this change the "MSM" abbreviation in help clause is
> irrelevant, could you remove it?
> 
> Reviewed-by: Stanimir Varbanov <svarbanov@mm-sol.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
