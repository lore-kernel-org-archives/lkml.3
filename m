Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3ITTIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:08:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ITTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:08:18 -0400
Message-ID: <523C9CE5.9040009@ti.com>
Date: Fri, 20 Sep 2013 14:07:17 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 1/3] PM / OPP: rename functions to dev_pm_opp*
References: <1379624632-17356-1-git-send-email-nm@ti.com>	<1379624632-17356-2-git-send-email-nm@ti.com>	<CAKohpoku7n6b2dDKD=+3DqG4pHtmWoeXZnAt3EoFRp+rNFofYA@mail.gmail.com>	<20130920123808.GA22176@kahuna> <CAKohpoktS4ZSQAeKvu3hdVsKkzcbKFvHvR2=wCA3qeB6moPphA@mail.gmail.com>
In-Reply-To: <CAKohpoktS4ZSQAeKvu3hdVsKkzcbKFvHvR2=wCA3qeB6moPphA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 11:51 AM, Viresh Kumar wrote:
> On 20 September 2013 18:08, Nishanth Menon <nm@ti.com> wrote:
> 
>> I am open to suggestions if any one feels we can improve this better.
> 
> I didn't really had one.. I thought of pm_opp** instead of dev_pm_opp**
> though..

I had proposed this earlier, however, had gone with Rafael's
suggestion [1] to have the right context to the usage.

> 
>> I believe that change was from Patch #2[1]
> 
> Yeah.. I just replied on a single patch :)
> 
>> yes, you are right, I had squashed this patch in to squelch checkpatch
>> warnings:
> 
> I see..
> 
>> I had added a comment:
>> " Minor checkpatch warning fixes as a result of this change was fixed as
>> well."
> 
> I really missed that..
no problems..

> 
>> Would you suggest I split the change off to a separate patch or improve
>>  the comment a little more?
> 
> don't really know, maybe leave those as is and let checkpatch warn you..
> 
that is fair as well. i can split it off seperately in the next respin.

[1] http://marc.info/?l=linaro-kernel&m=137645747511725&w=2
-- 
Regards,
Nishanth Menon
