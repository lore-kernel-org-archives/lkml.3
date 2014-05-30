Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144AbaE3P4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:56:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbaE3P4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:56:21 -0400
Date: Fri, 30 May 2014 08:59:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>, Miguel Oliveira <cmroliv@gmail.com>,
        gulsah.1004@gmail.com,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530155959.GA10682@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530113418.GA9670@amd.pavel.ucw.cz>
 <7447FAB3-E22D-44C5-AD79-E366FEE57879@holtmann.org>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530123023.GA10549@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 02:30:23PM +0200, Pavel Machek wrote:
> Hi!
> 
> > >> Creating this patch for the Eudyptula Challenge.
> > >> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
> > >> Also inserted a blank line after adeclaration.
> > > 
> > > So you are changing timings without testing. Plus, burning CPU power
> > > instead of sleeping.
> > > 
> > > Seems you'll need another patch for the challenge :-).
> > 
> > I actually wonder if anybody is seriously working on this driver. My concern with the staging drivers has always been that we are quick with merging them when the work on getting them into upstream shape is actually hard. However reality is once they are in staging nobody is doing the work to clean them up and fix the issues.
> >
> 
> There is active work on merging n900 changes.

Really?  Where?

> And no, it does not progress as quickly as I'd like, but we'll get
> there. It is also requirement for n900 FM radio receiving...
> 
> > Greg, instead of wasting our time with this, can we just remove this driver from staging.
> 
> Please don't.

As there has not been any real work on it since it has been merged, I
don't see why I shouldn't remove it.  If you do get some work done on
it, you can always revert the removal and continue on.  But the
existance of code in staging that is not progressing forward at all is
something that I don't like at all, and will be doing a large sweep of
soon to remove.

thanks,

greg k-h
