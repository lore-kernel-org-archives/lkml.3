Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3FKRz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:55:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:1430 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab3FKRz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:55:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,846,1363158000"; 
   d="scan'208";a="315455668"
Date: Tue, 11 Jun 2013 19:55:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130611175519.GL29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
 <20130611142358.GG29135@zurbaran>
 <20130611160415.GA379@core.coreip.homeip.net>
 <20130611161506.GK29135@zurbaran>
 <1565f2fb-7f16-4910-8fa2-cd5700e8986d@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565f2fb-7f16-4910-8fa2-cd5700e8986d@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Tue, Jun 11, 2013 at 05:27:48PM +0100, Jonathan Cameron wrote:
> Samuel Ortiz <sameo@linux.intel.com> wrote:
> >On Tue, Jun 11, 2013 at 09:04:16AM -0700, Dmitry Torokhov wrote:
> >> On Tue, Jun 11, 2013 at 04:23:58PM +0200, Samuel Ortiz wrote:
> >> > Hi Sebastian,
> >> > 
> >> > On Tue, Jun 11, 2013 at 01:30:46PM +0200, Sebastian Andrzej Siewior
> >wrote:
> >> > > I believe the whole thing should go via the MFD tree. It touches
> >also
> >> > > input & iio subsystem. I collected ACKs where I got some in the
> >meantime.
> >> > Please fix your commit logs, and your subject lines. It should be
> >e.g.
> >> > mfd: input: ti_am335x_adc: Blablabla
> >> > 
> >> > if it's mostly an mfd patch that also touches an input driver.
> >> > 
> >> > Then, this is a pretty big patchset, with iio, input and mfd all
> >mixed
> >> > together and it is likely to create merge conflicts.
> >> > From what I can see from it, and please correct me if I'm
> >> > wrong, the iio and input changes depend on the mfd ones, and not
> >the
> >> > other way around. If that's so, I'm going to ask you to reshuffle
> >your
> >> > patch set and separate the MFD changes from the iio and input ones.
> >I'll
> >> > take the MFD ones and will create an immutable branch for Jonathan
> >and
> >> > Dmitry to pull from and apply the iio and input changes on top of
> >it.
> >> > Merge conflicts should be mostly avoided that way.
> >> 
> >> I purposely left this driver alone as I expected it would be merged
> >> through MFD tree, so there should not be any merging issues on my
> >side.
> >Thanks for the notice.
> >Jonathan, can you guarantee the same for the iio parts ?
> I have also been avoiding taking any of these and there are unlikely to be any iio wide changes merging at this stage in cycle.  Hence these going through MFD is best plan.
>
Thanks. Then I'm willing to try and see if linux-next does not complain
too hard about that.

Sebastian, please address the commit log and cosmetic issues I pointed out,
keep the regmap code and I'll pull this patchset in.
If further down the road we get some nasty merge conflicts from
linux-next, I might ask you to re-work it. Let's see.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
