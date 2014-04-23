Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaDWNxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:53:45 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53491 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756823AbaDWNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:53:38 -0400
Message-ID: <5357C5E0.1070207@semaphore.gr>
Date: Wed, 23 Apr 2014 16:53:36 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: powernow-k8: Fix checkpatch warnings
References: <5356DB92.1060600@semaphore.gr> <2606012.9SjvfKiI5Z@vostro.rjw.lan>
In-Reply-To: <2606012.9SjvfKiI5Z@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/04/2014 01:37 μμ, Rafael J. Wysocki wrote:
> On Wednesday, April 23, 2014 12:13:54 AM Stratos Karafotis wrote:
>> Fix the following checkpatch warnings:
> 
> In addition to comments from Viresh, I have a general one.
> 
> Some of the checkpatch.pl warnings are not worth fixing at all ->
> 
>> - WARNING: Prefer pr_err(... to printk(KERN_ERR ...
>> - WARNING: Prefer pr_info(... to printk(KERN_INFO ...
>> - WARNING: Prefer pr_warn(... to printk(KERN_WARNING ...
>> - WARNING: quoted string split across lines
>> - WARNING: line over 80 characters
> 
> -> and the "line over 80 characters" ones are outright wrong in many cases,
> so please don't "fix" them.
> 

Hi Rafael,

Thanks for your comments!

Could you please clarify if you want me to drop the entire patch or
send it only with the changes about the last warning found ("no spaces
at the start of a line)?

Also, I would like to take the opportunity and ask a question. :)

Reading the code, sometimes, I find some minor formatting issues.
Like the checkpatch warnings or unnecessary parentheses and braces.

For example the line bellow:
		if ((freq < policy->min) || (freq > policy->max))

I know that this is not actually an issue and a patch with such changes
is (somehow) a noise for the maintainers. But, should it be "fixed" or not?

Thanks for your time,

Stratos


