Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaDVL3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:29:32 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64610 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaDVL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:29:30 -0400
Date: Tue, 22 Apr 2014 12:29:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        " linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 5/8] mfd: db8500-prcmu: Use cpufreq_for_each_entry
 macro for iteration
Message-ID: <20140422112913.GB21613@lee--X1>
References: <535635d0.8908b40a.6c36.ffffaaa9SMTPIN_ADDED_MISSING@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535635d0.8908b40a.6c36.ffffaaa9SMTPIN_ADDED_MISSING@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The cpufreq core now supports the cpufreq_for_each_entry macro helper 
> > > for iteration over the cpufreq_frequency_table, so use it. 
> > > 
> > > It should have no functional changes. 
> >
> > > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr> 
> > > --- 
> >
> > It would be good to have a changelog which describes the differences 
> > between the versions, so we can keep track. 
> >
> > >  drivers/mfd/db8500-prcmu.c | 19 ++++++++----------- 
> > >  1 file changed, 8 insertions(+), 11 deletions(-) 
> >
> > So it looks like I already applied v2 of this patch to my tree. What 
> > changed in v3 and v4? Should I remove that patch from MFD and apply 
> > this one instead?
> 
> I'm sorry for the confusion.
> I sent v3 only for patches 1/8 and 3/8.
> So, I was asked by Rafael to resend the entire series as v4
> in order to be clear which is the latest version in each patch.
> Unfortunately, I omit the change log :(
> 
> The specific patch (5/8) is unchanged since v2.
> 
> I'm sorry for the inconvenience.

That's okay, thanks for clarifying.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
