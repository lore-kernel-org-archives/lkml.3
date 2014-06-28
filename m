Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbaF1Gft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:35:49 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57519 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaF1Gfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:35:48 -0400
Date: Sat, 28 Jun 2014 01:35:43 -0500
From: Michael Welling <mwelling@ieee.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Morin <guillaume@morinfr.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: iio: ad9850.c: fix checkpatch.pl error
Message-ID: <20140628063542.GA2420@deathray>
References: <4d0e6b74dcc10ef5d60c9cab4f2df886782fb3c3.1403919775.git.guillaume@morinfr.org>
 <20140628020935.GA14333@kroah.com>
 <20140628023009.GA13273@bender.morinfr.org>
 <20140628023718.GB3579@kroah.com>
 <20140628031045.GA13985@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628031045.GA13985@bender.morinfr.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 05:10:46AM +0200, Guillaume Morin wrote:
> On 27 Jun 22:37, Greg Kroah-Hartman wrote:
> > Put that below the --- line.
> 
> Will do.
> 
> > > > And what checkpatch error did you fix?  And are you sure it needs to be
> > > > fixed?
> > > 
> > > That's what I changed:
> > > 
> > > $ scripts/checkpatch.pl -f drivers/staging/iio/frequency/ad9850.c
> > > ERROR: Macros with complex values should be enclosed in parenthesis
> > 
> > Then why didn't you say that :)
> 
> Well it was not totally clear to me if that was obvious or not.  Anyway,
> I'll mention it in the future.
> 
> > 
> > > I assumed that if it was reported as an error, it needed to be fixed...
> > 
> > Use your judgement, checkpatch is a tool, it isn't always correct.
> 
> Right, I guess it's borderline.  Should I resend the patch or just drop
> it?

These days we have GENMASK.
 
http://lxr.free-electrons.com/source/include/linux/bitops.h#L21
 
Maybe the macro can be used directly instead of the value_mask.

> 
> Guillaume.
> 
> -- 
> Guillaume Morin <guillaume@morinfr.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
