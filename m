Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaDVKCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:02:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60643 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754468AbaDVKCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:02:32 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v4 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry macro for iteration
Date: Tue, 22 Apr 2014 12:18:51 +0200
Message-ID: <6612075.PRZcWcuj98@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140422071541.GA17657@lee--X1>
References: <534DB213.7080802@semaphore.gr> <5355A349.50908@semaphore.gr> <20140422071541.GA17657@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 08:15:41 AM Lee Jones wrote:
> > The cpufreq core now supports the cpufreq_for_each_entry macro helper
> > for iteration over the cpufreq_frequency_table, so use it.
> > 
> > It should have no functional changes.
> 
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > ---
> 
> It would be good to have a changelog which describes the differences
> between the versions, so we can keep track.
> 
> >  drivers/mfd/db8500-prcmu.c | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> So it looks like I already applied v2 of this patch to my tree. What
> changed in v3 and v4? Should I remove that patch from MFD and apply
> this one instead?

The reason why v4 was sent is because I asked for it.

And if you applied [5/8] without [1/8], it won't work, because the macro is
introduced by that patch.

If that's the case, please drop [5/8] and let me handle the entire series.

Kind regards,
Rafael

