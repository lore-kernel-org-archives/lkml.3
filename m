Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3FFRM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:12:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3FFRMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:12:15 -0400
Date: Thu, 6 Jun 2013 19:11:52 +0200
From: Borislav Petkov <bp@suse.de>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <20130606171152.GF21181@pd.tnic>
References: <51AF60D5.3080605@semaphore.gr>
 <20130605161703.GA29958@pd.tnic>
 <51AF71B6.6030408@semaphore.gr>
 <105446113.ZumbZWCbSi@vostro.rjw.lan>
 <20130606100138.GC21181@pd.tnic>
 <CAKohpo=cwxvcicw4svcvyKJOzGD9j+gzTyg=4yYg4EsY89C3EQ@mail.gmail.com>
 <20130606121012.GD21181@pd.tnic>
 <51B0BCD9.6030308@semaphore.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51B0BCD9.6030308@semaphore.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 07:46:17PM +0300, Stratos Karafotis wrote:
> Apologies for top-posting. I was able to send email only from my phone.
> 
> Thanks for you hint about turbostat.
> 
> As you most probably understood, I'm individual amateur kernel developer.
> I could provide some numbers from x86 architecture as Rafael suggested.
> But unfortunately, I don't have access to more sources/infrastructure.
> So, I will not be able to provide numbers from different platform(s).
> 
> I've already provided some benchmarks from x86 (3.10-rc3) and also
> tested the patch in 3.4.47 kernel (ARM, Nexus 4 phone, ~1000 installations)
> and in 3.0.80 kernel (ARM, Samsung Galaxy S phone, ~1500 installations).
> 
> Kindly let me know if "couple of platforms/vendors" is a show stopper
> for this patch series. If yes, please ignore this patch and accept
> my apologies for wasting your time. I am just trying to contribute
> on this project (I believe there is space here for amateur developers).

I'm in no way discouraging you in contributing to the kernel - on the
opposite: you should continue doing that.

I'm just trying to make sure that a change like that doesn't hurt
existing systems, thus the request to test on a couple of platforms. If
you don't have other platforms, that's fine, we'll find them somewhere. :-)

I'm hoping you can understand my aspect too, though - how would you feel
if a patch shows improvement on my box but slows down yours - you won't
be very happy with it, right? That's why we generally want to test such
power/performance tweaks on a wider range of machines.

But you said you have a i7-3770 CPU on which, I think, turbostat should
be able to show you how the power consumption looks like.

And if so, you could measure that consumption once with, and once
without your patch. This will give us initial numbers, at least.

How does that sound?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
