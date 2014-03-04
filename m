Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaCDHKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:10:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaCDHKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:10:14 -0500
Message-ID: <1393917011.5419.12.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
From: Mike Galbraith <bitbucket@online.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Cc: Salman Qazi" <sqazi@google.com>
Date: Tue, 04 Mar 2014 08:10:11 +0100
In-Reply-To: <CALAqxLUeb2GuPyULnHL+FHgbdanVxz2JsvD2O0bJWKyN=CJ3UQ@mail.gmail.com>
References: <1393911500.6415.18.camel@marge.simpson.net>
	 <CALAqxLUeb2GuPyULnHL+FHgbdanVxz2JsvD2O0bJWKyN=CJ3UQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:PH4KfxccTN+FiNA9wZ+1zohZ9842GUJ8duz546EBZC2
 5W4TsYDL8i/9+7sT1+tIHo0q+FxQb6ATK3ezN/NEz3sC0x5Kwi
 aHy69MBqLMrebpWT4BMVgGwjL4LjXpItD+92bPVkJC1HOlMI/z
 VzCT3oHN95p0YqC0A1NuqRgWdS5YvQRdnp8H/XeWehKc28cVS/
 WAYqNbJMFdM0AHXsjFyB2Z546uRZ9uDdCvRqb0HHbmi/vnKBMQ
 VV8mgdEfNJs2OsnyhUjcgf4E2dmINPmF/vMMycLZEjHtQp+iPQ
 YdAOpLIwjUomURWPnGd9QTxKPz3epy5YnoqXHutsWeY4174i7S
 PLummW87/ro67cEcuoZAWU5uQlwulsWdFJ1KYjFO+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 14:40 +0800, John Stultz wrote: 
> On Tue, Mar 4, 2014 at 1:38 PM, Mike Galbraith <bitbucket@online.de> wrote:
> > (crap crap crap... M.A.I.N.T.A.I.N.E.R.S _dummy_)
> >
> > clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> >
> > As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> > cycles * mult >> shift is overflow prone. so give it the same treatment.
> >
> > Cc: Salman Qazi <sqazi@google.com>
> > Cc: John Stultz <john.stultz@linaro.org>,
> > Signed-off-by: Mike Galbraith <bitbucket@online.de>
> 
> Thanks for sending this in!  Curious exactly how the issue was being
> triggered?

Dunno that it is.  This is the result of me rummaging around, looking
for any excuse what-so-ever for a small and identical group of weird a$$
boxen running old 2.6.32 kernels (w. 208 day fix!) to manage to hop back
and forth in time by exactly 208 days.  Grep showed me that function, so
I scurried off and swiped the fix.

-Mike

