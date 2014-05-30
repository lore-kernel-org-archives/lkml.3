Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaE3Ma0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:30:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58870 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaE3MaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:30:25 -0400
Date: Fri, 30 May 2014 14:30:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Miguel Oliveira <cmroliv@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        gulsah.1004@gmail.com,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530123023.GA10549@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530113418.GA9670@amd.pavel.ucw.cz>
 <7447FAB3-E22D-44C5-AD79-E366FEE57879@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7447FAB3-E22D-44C5-AD79-E366FEE57879@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Creating this patch for the Eudyptula Challenge.
> >> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
> >> Also inserted a blank line after adeclaration.
> > 
> > So you are changing timings without testing. Plus, burning CPU power
> > instead of sleeping.
> > 
> > Seems you'll need another patch for the challenge :-).
> 
> I actually wonder if anybody is seriously working on this driver. My concern with the staging drivers has always been that we are quick with merging them when the work on getting them into upstream shape is actually hard. However reality is once they are in staging nobody is doing the work to clean them up and fix the issues.
>

There is active work on merging n900 changes. And no, it does not
progress as quickly as I'd like, but we'll get there. It is also
requirement for n900 FM radio receiving...

> Greg, instead of wasting our time with this, can we just remove this driver from staging.

Please don't.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
