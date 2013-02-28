Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab3B1OvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933072Ab3B1OvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:04 -0500
Message-ID: <512F6EB0.1080706@redhat.com>
Date: Thu, 28 Feb 2013 09:50:24 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>	<1360861375-24131-3-git-send-email-prarit@redhat.com>	<5127D884.6020701@linaro.org>	<5127DB2B.3030700@redhat.com>	<5127DDAF.2000403@linaro.org>	<B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>	<512A47C5.3010500@redhat.com> <20130225155812.0758e093@linux.lan.towertech.it>
In-Reply-To: <20130225155812.0758e093@linux.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/25/2013 09:58 AM, Alessandro Zummo wrote:
> On Sun, 24 Feb 2013 12:03:01 -0500
> Prarit Bhargava <prarit@redhat.com> wrote:
> 
>>
>> AFAICT there is no way for me to "test" or use the write from userspace.
>> hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.
>>
>> I'd like to be at least able to test this stuff when we make changes to it so I
>> think having write functionality for date & time is worthwhile.
>>
>> For me, I'm using these to heavily test ntp and ntpdate over system reboots.
> 
>  the point is: who will benefit from this patch? users? distributions?
>  embedded distributions? if it's useful, then just go for it.

This can be dropped IMO.

P.

> 
> 
>> OOC, Alessandro, why is the date & time split into two fields?
> 
>  because date and time are two different things and we expect
>  sysfs to preferably have one value for each entry.
> 
