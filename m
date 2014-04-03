Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaDCJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:30:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40050 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaDCJax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:30:53 -0400
Message-ID: <533D2A41.7090207@linaro.org>
Date: Thu, 03 Apr 2014 17:30:41 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Brown <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org> <5334078A.9010408@arm.com> <53341ADF.2050904@linaro.org> <2765234.k5FCzWzCDz@vostro.rjw.lan> <533D1D5E.20208@linaro.org> <CAOh2x=nYWjB+Org6eNjQAT93ZX2DRHNYSJWgWTo8vS2AmdrAbA@mail.gmail.com> <20140403085120.GB17022@arm.com> <533D2980.6000903@linaro.org>
In-Reply-To: <533D2980.6000903@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-4-3 17:27, Hanjun Guo wrote:
> On 2014-4-3 16:51, Catalin Marinas wrote:
>> On Thu, Apr 03, 2014 at 09:41:57AM +0100, Viresh Kumar wrote:
>>> On Thu, Apr 3, 2014 at 2:05 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>>> How about the following patch? if it is ok, I will resend it.
>>>
>>> http://www.spinics.net/lists/arm-kernel/msg319545.html
>>
>> I can see commit 62d1a3ba5adc5653d43f6cd3a90758bb6ad5d5bd (arm64: Fix
>> duplicated Kconfig entries again) already in mainline, so problem
>> solved.
>>
>> Thanks Josh ;)

I just noticed Josh's patch half a hour ago, that's why I didn't review it...

