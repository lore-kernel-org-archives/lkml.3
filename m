Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaBJXKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:10:36 -0500
Received: from mail-pa0-f68.google.com ([209.85.220.68]:49900 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaBJXKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:10:35 -0500
Date: Mon, 10 Feb 2014 15:10:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: Jean Delvare <jdelvare@suse.de>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
Message-ID: <20140210231031.GA5857@roeck-us.net>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
 <20140210160842.GB26997@lee--X1>
 <20140210173811.04ba5964@endymion.delvare>
 <20140210105346.14592yef0najhyio@67.228.131.205>
 <CAOMwXhMTK6h3MQdHHaEV+5=XbQSqXzj0mPt3MzK9X9jhj4jOhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhMTK6h3MQdHHaEV+5=XbQSqXzj0mPt3MzK9X9jhj4jOhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:59:55PM +0000, Laszlo Papp wrote:
> On Mon, Feb 10, 2014 at 4:53 PM,  <linux@roeck-us.net> wrote:
> > Quoting Jean Delvare <jdelvare@suse.de>:
> >
> >>
> >> That being said, going with MFD in this case seems quite overkill to
> >> me. MFD makes a lot of sense when each function has its own resources.
> >> As this isn't the case here, a single driver registering both an hwmon
> >> interface and a pinctrl interface would seem sufficient to me. But I
> >> think Guenter already discussed this in the past so I'll let him
> >> continue and decide.
> >>
> >
> > That is what I had suggested as well (though we were talking gpio
> > at the time). Laszlo didn't want to do it this way for some reason.
> > Right now I don't really have an idea what to do.
> 
> Right now I do not really have an idea what the concern here is.
> 
> I will quote you:
> 
> "Please explain, for my education, what makes you believe that I would
> object to or reject to anyone submitting such a driver."
> 
> and then the next one in the thread:
> 
> "> > Works for me. Should I apply the gpio and mfd drivers separately or in
> > > one single patch?
> >
> > s/apply/send/
> >
> Separately."
> 
> This happened about two months ago, and after two months of man work,
> several reviews from various people, while you have been *explicitly*
> included in the threads, are claiming that it is unacceptable? Do you
> see how much time waste that would be for everyone who have been
> involved.
> 
> What I currently do not understand is the point for rejecting the
> contribution that does not have API drawback, etc, if you do not
> provide anything better. You are more than welcome to rewrite my work
> once the feature works, but I guess it is very likely that you would
> not do that.
> 
> So, let me ask it: shall we continue the bike-shedding after months,
> or there is a definite decision from the maintainers? Disagreement is
> not a problem because people can move on if the maintainers actually
> make it clear what is acceptable and what not, but here that did not
> really happen. We are where we were months ago.
> 

I think I'll let Jean handle this one.

Guenter
