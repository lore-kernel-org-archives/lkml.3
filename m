Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBYLss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:48:48 -0500
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:50303 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751593AbaBYLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:48:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 13,1.2,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2196:2199:2393:2553:2559:2562:2691:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3872:3873:3874:4037:4321:4385:5007:7652:8784:8957:9010:10008:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: can31_868a7f0adcd0f
X-Filterd-Recvd-Size: 2441
Message-ID: <1393328923.8716.20.camel@joe-AO722>
Subject: Re: [PATCH] Staging: comedi: Fix line length exceeding 80 characters
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Date: Tue, 25 Feb 2014 03:48:43 -0800
In-Reply-To: <20140225110532.GK26722@mwanda>
References: <1393260582-10234-1-git-send-email-monamagarwal123@gmail.com>
	 <530C666B.6080900@mev.co.uk> <1393322365.8716.3.camel@joe-AO722>
	 <20140225110532.GK26722@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 14:05 +0300, Dan Carpenter wrote:
> On Tue, Feb 25, 2014 at 01:59:25AM -0800, Joe Perches wrote:
> > On Tue, 2014-02-25 at 09:46 +0000, Ian Abbott wrote:
> > > On 2014-02-24 16:49, Monam Agarwal wrote:
> > []
> > > > diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
> > []
> > > > @@ -1481,7 +1481,8 @@ static int do_cmd_ioctl(struct comedi_device *dev,
> > > >   	async->cmd.data = NULL;
> > > >   	/* load channel/gain list */
> > > >   	async->cmd.chanlist = memdup_user(user_chanlist,
> > > > -					  async->cmd.chanlist_len * sizeof(int));
> > > > +					  async->cmd.chanlist_len
> > > > +					  * sizeof(int));
> > > The `*` operator should go at the end of the line according to the 
> > > CodingStyle.
> > I don't believe there's a CodingStyle guide for this.
> Meanwhile you have felt totally justified in correcting me on this in
> the past.  :P

Doubtful.  You're probably thinking of something else.

Besides, we generally agree on style.  Anything I may
have written was more more suggestion than correction.

> Anyway, it should be that the operator goes on the first line like Ian
> says...

Feel free to use whatever style you want.

Feel free to update CodingStyle too.

cheers, Joe

