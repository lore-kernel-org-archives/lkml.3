Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3KYLzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:55:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:2694 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3KYLzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:55:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,767,1378882800"; 
   d="scan'208";a="414199645"
Message-ID: <52933AB5.9060409@intel.com>
Date: Mon, 25 Nov 2013 19:55:33 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>, hg197@gmx.de,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Cpufreq: Change sysfs interface cpuinfo_cur_freq access
 privilege
References: <1385348018-30525-1-git-send-email-tianyu.lan@intel.com> <CAKohponvz8CjDpMbx=BXpBv5q8d4x94No90sJWjVsTRS_Uj1jw@mail.gmail.com> <5292E133.1040800@intel.com> <5074010.ha99UACE9S@vostro.rjw.lan>
In-Reply-To: <5074010.ha99UACE9S@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 07:26 PM, Rafael J. Wysocki wrote:
> On Monday, November 25, 2013 01:33:39 PM Lan Tianyu wrote:
>> On 2013年11月25日 12:30, Viresh Kumar wrote:
>>> On 25 November 2013 08:23, Lan Tianyu <tianyu.lan@intel.com> wrote:
>>>> Currently, cpuinfo_cur_freq is only accessible for root user while
>>>> other cpufreq sysfs interfaces(E,G scaling_cur_freq) are available
>>>> to ordinary user. This seems make no sense. This patch is to change
>>>> it.
>>>
>>> There is nothing wrong with the code and so this is more of a design
>>> change..
>>>
>>> Probably Rafael can help us here as cpufreq_cur_freq will read stuff
>>> directly from hardware instead of using cached value in software.
>>
>> I think so, too. I also tried to checking the reason of the privilege by
>> git log but the code was there before linux kernel being migrated to git
>> repository.
>
> And it has always behaved in the same way?  Then I wouldn't change it.
>

It has been there since 2.6.12-rc2 or more early. But the 
cpuinfo_cur_freq is read-only and seems no harmful.

Request from bug 65611.
https://bugzilla.kernel.org/show_bug.cgi?id=65611.


> Thanks!
>


-- 
Best Regards
Tianyu Lan
