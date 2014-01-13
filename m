Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaAMVoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:44:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31464 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaAMVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:44:52 -0500
Date: Tue, 14 Jan 2014 00:44:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Einon <mark@einon.net>
Cc: Pol Eyschen <poleyschen@gmail.com>, devel@driverdev.osuosl.org,
        jack@suse.cz, Pol Eyschen <poleyschen@hotmail.com>,
        sachin.kamat@linaro.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, ufimtseva@gmail.com
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Message-ID: <20140113214429.GH7444@mwanda>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
 <20140113213552.GA5368@einon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113213552.GA5368@einon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 09:35:53PM +0000, Mark Einon wrote:
> On Mon, Jan 13, 2014 at 08:41:40PM +0100, Pol Eyschen wrote:
> > From: Pol Eyschen <poleyschen@hotmail.com>
> > 
> > All comments fixed to match the kernel coding style.
> > 
> > Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
> > ---
> 
> This patch doesn't apply to my staging-next branch. Are you making your
> changes to the staging-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git?
> 
> >  drivers/staging/ced1401/ced_ioc.c |  382 ++++++++++++++++++++++++-------------
> >  1 file changed, 249 insertions(+), 133 deletions(-)
> > 
> > diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
> > index 62efd74..e5172cb 100644
> > --- a/drivers/staging/ced1401/ced_ioc.c
> > +++ b/drivers/staging/ced1401/ced_ioc.c
> > @@ -41,7 +41,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
> >  {
> >  	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
> >  		pdx->sCurrentState);
> > -	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
> > +	if (pdx->sCurrentState == U14ERR_TIME)
> > +		/* Do nothing if hardware in trouble */
> >  		return;
> 
> Putting a comment after a single line 'if' and before the statement is
> not the norm and can be confusing. Please don't do it.
> 

The guideline is that multi-line indents should get {} braces for
readability even though they aren't needed for syntax.

	if (pdx->sCurrentState == U14ERR_TIME) {
		/* Do nothing if hardware in trouble */
		return;
	}

regards,
dan carpenter

