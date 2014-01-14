Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaANCTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:19:46 -0500
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:56551 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751364AbaANCTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:19:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:4250:4321:5007:7652:8957:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: home00_8ea268770493f
X-Filterd-Recvd-Size: 1898
Message-ID: <1389665978.24849.27.camel@joe-AO722>
Subject: Re: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pol Eyschen <poleyschen@gmail.com>, sachin.kamat@linaro.org, jack@suse.cz,
        ufimtseva@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Pol Eyschen <poleyschen@hotmail.com>
Date: Mon, 13 Jan 2014 18:19:38 -0800
In-Reply-To: <20140113235650.GA23380@kroah.com>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
	 <20140113235650.GA23380@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 15:56 -0800, Greg KH wrote:
> On Mon, Jan 13, 2014 at 08:41:40PM +0100, Pol Eyschen wrote:
[]
> > diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
[]
> > @@ -41,7 +41,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
> >  {
> >  	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
> >  		pdx->sCurrentState);
> > -	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
> > +	if (pdx->sCurrentState == U14ERR_TIME)
> > +		/* Do nothing if hardware in trouble */
> >  		return;
> 
> Please wrap stuff like this in { } to not confuse people.

Yes please, or maybe put the comment on the return line like:

	if (pdx->sCurrentState == U14ERR_TIME)
		return;			/* Do nothing if hardware in trouble */

or above the test like:

	/* Do nothing if hardware in trouble */
	if (pdx->sCurrentState == U14ERR_TIME)
		return;



