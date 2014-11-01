Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaKAKus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 06:50:48 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44031 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaKAKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 06:50:47 -0400
Date: Sat, 1 Nov 2014 11:50:41 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Konrad Zapalowicz <bergo.torino@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: panel: Remove outdated TODO tasks
Message-ID: <20141101105040.GA21226@firebird>
References: <1414792903-7986-1-git-send-email-marius.gorski@gmail.com>
 <20141031220834.GC15010@t400>
 <20141101045916.GB3642@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141101045916.GB3642@sudip-PC>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:29:16AM +0530, Sudip Mukherjee wrote:
> On Fri, Oct 31, 2014 at 11:08:34PM +0100, Konrad Zapalowicz wrote:
> > On 10/31, Mariusz Gorski wrote:
> > > Remove Lindent and checkpatch.pl tasks from TODO file as the first one
> > > is obsolete and the other one is already done.
> > > 
> 
> when i checked panel.c with checkpatch and with --strict option, i got 20 checks.
> (sent the same reply to v1 patch also).

Good point, supid. Thanks! I guess the checkpatch.pl issues deserve a
separate patch, so I'll just reduce the scope of this one.

Cheers,
Mariusz

> thanks
> sudip
> 
> > > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > > ---
> > > v3: Fixed commit summary
> > 
> > Great. Thanks.
> > 
> > regards,
> > konrad
> >  
> > >  drivers/staging/panel/TODO | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
> > > index a4be749..c8040c1 100644
> > > --- a/drivers/staging/panel/TODO
> > > +++ b/drivers/staging/panel/TODO
> > > @@ -1,6 +1,4 @@
> > >  TODO:
> > > -	- checkpatch.pl cleanups
> > > -	- Lindent
> > >  	- review major/minor usages
> > >  	- review userspace api
> > >  	- see if all of this could be easier done in userspace instead.
> > > -- 
> > > 2.1.3
> > > 
> > > _______________________________________________
> > > devel mailing list
> > > devel@linuxdriverproject.org
> > > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
