Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaKAE7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 00:59:25 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53143 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKAE7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 00:59:24 -0400
Date: Sat, 1 Nov 2014 10:29:16 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Mariusz Gorski <marius.gorski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: panel: Remove outdated TODO tasks
Message-ID: <20141101045916.GB3642@sudip-PC>
References: <1414792903-7986-1-git-send-email-marius.gorski@gmail.com>
 <20141031220834.GC15010@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031220834.GC15010@t400>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:08:34PM +0100, Konrad Zapalowicz wrote:
> On 10/31, Mariusz Gorski wrote:
> > Remove Lindent and checkpatch.pl tasks from TODO file as the first one
> > is obsolete and the other one is already done.
> > 

when i checked panel.c with checkpatch and with --strict option, i got 20 checks.
(sent the same reply to v1 patch also).

thanks
sudip

> > Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> > ---
> > v3: Fixed commit summary
> 
> Great. Thanks.
> 
> regards,
> konrad
>  
> >  drivers/staging/panel/TODO | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
> > index a4be749..c8040c1 100644
> > --- a/drivers/staging/panel/TODO
> > +++ b/drivers/staging/panel/TODO
> > @@ -1,6 +1,4 @@
> >  TODO:
> > -	- checkpatch.pl cleanups
> > -	- Lindent
> >  	- review major/minor usages
> >  	- review userspace api
> >  	- see if all of this could be easier done in userspace instead.
> > -- 
> > 2.1.3
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
