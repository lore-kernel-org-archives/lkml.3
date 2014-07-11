Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaGKKH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:07:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40132 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaGKKH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:07:27 -0400
Message-ID: <de0adfb19532c754298579dbba62a6b9.squirrel@www.codeaurora.org>
In-Reply-To: <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
    <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
    <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
    <2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
Date: Fri, 11 Jul 2014 10:07:24 -0000
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
From: skannan@codeaurora.org
To: skannan@codeaurora.org
Cc: "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Saravana Kannan" <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Todd Poynor" <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Stephen Boyd" <sboyd@codeaurora.org>
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


skannan@codeaurora.org wrote:
>
> Viresh Kumar wrote:
>> Hi Saravana,
>>
>> Thanks for trying this..
>>
>> On 11 July 2014 09:48, Saravana Kannan <skannan@codeaurora.org> wrote:
>>> The CPUfreq driver moves the cpufreq policy ownership between CPUs when
>>
>> s/driver/core
>
> Will do
>

<snip>

Soooo many typos. This is what happens when I send a late night email! If
a sentence sounds incomplete, this is why.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

