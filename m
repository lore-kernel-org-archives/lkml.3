Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935971Ab3BOQMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:12:55 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:34396 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BOQMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:12:54 -0500
Message-ID: <511E5E81.5050408@intel.com>
Date: Fri, 15 Feb 2013 08:12:49 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, dirk.brandewie@gmail.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add kernel command line option
 disable intel_pstate.
References: <6075901.uWCJMxDDFf@vostro.rjw.lan> <1360867132-13004-1-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=mH0k8ZB0Qq+q=2bxwHcMUVmj-cy-=N4dBf=6Q2xd6nMw@mail.gmail.com> <2881062.pPx9cdkTcn@vostro.rjw.lan> <CAKohpomECGhRkFp8afS0DvozZFJif3MhGFG5XX2T2RWzC3Ez9w@mail.gmail.com>
In-Reply-To: <CAKohpomECGhRkFp8afS0DvozZFJif3MhGFG5XX2T2RWzC3Ez9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 05:28 AM, Viresh Kumar wrote:
> On 15 February 2013 18:00, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Friday, February 15, 2013 09:53:24 AM Viresh Kumar wrote:
>>> Parameter to this is really not required. By default intel_pstate
>>> driver is enabled, so just past disable_intel_pstate from command line
>>> without any args.
>>
>> Well, quite frankly, I'm fine with both.  It all boils down to passing a
>> specific string on the kernel command line.
>
> Well, we are all looking to save worlds power here and my suggestion
> would definitely use less power as it has less instructions to execute.
> Just for fun!!.
>

I would like to leave it the way it is now. If for what ever reason we need
another switch passed to the driver we have a place for it without adding
another single purpose command line option

The updated with __initdata and the spelling fixes will follow shortly

--Dirk
