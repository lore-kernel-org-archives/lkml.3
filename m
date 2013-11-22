Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3KVQFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:05:00 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35267 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3KVQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:04:59 -0500
Date: Fri, 22 Nov 2013 08:04:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>, hjk@hansjkoch.de,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Add support for gpiodef
Message-ID: <20131122160457.GA3951@roeck-us.net>
References: <CAOMwXhM1Xi=UqpmKNDsOnQLXKo1o+65TZi6AkBk4Ds9wuXSaWQ@mail.gmail.com>
 <20131119165438.GD30481@roeck-us.net>
 <20131119180007.GB16693@roeck-us.net>
 <CAOMwXhOTRVu1EMSNE_muKKfSYBFQ1XVq1EQEL2d+wCwRJ0tkpw@mail.gmail.com>
 <CAOMwXhN8tZej9=65wyGvsnm64igiLLN6vdsiGaePCozKBs8J7Q@mail.gmail.com>
 <20131121173458.GC10783@roeck-us.net>
 <CAOMwXhNzpsiiK5NzxoXM56ACGmHo1gpm3OT6=kw29XQDFmyPAA@mail.gmail.com>
 <CAOMwXhPUR02fQ1EhV6K9eQW02kNHn55dTEND+R59g1=zC5qDWQ@mail.gmail.com>
 <528F6BB8.8040504@roeck-us.net>
 <CAOMwXhNx0v52BvxSWPrHFsGTvxss7N4tZT3gHMFJ8hz_HmvS5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhNx0v52BvxSWPrHFsGTvxss7N4tZT3gHMFJ8hz_HmvS5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:50:50PM +0000, Laszlo Papp wrote:
> On Fri, Nov 22, 2013 at 2:35 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 11/22/2013 01:23 AM, Laszlo Papp wrote:
> >>
> >> Just to clarify: you want to have ./gpio/gpio-max6650.c?
> >>
> > No, I never said that. I wanted you to register the gpio pins
> > with the gpio subsystem. I didn't ask you to write a separate
> > driver for it.
> >
> > Sure, strictly speaking one could write a top level mfd driver
> > and separate gpio and hwmon drivers, but at least in my opinion
> > that would be overkill. I also never suggested this; you brought
> > the term mfd into the discussion.
> 
> Why is it an overkill to write a separate gpio driver for this, and
> potentially also for the gpio status register of this particular MAXIM
> chip?
> 
> Other gpio drivers in the gpio folder are also short. This would not
> become long either.
> 
No one prevents you from writing a separate gpio driver. I will certainly
not prevent you from doing it. Just don't claim that I requested it.
Same is true for an mfd driver; I won't prevent you from writing one.
But don't claim that I told you to do it.

Guenter
