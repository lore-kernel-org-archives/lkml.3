Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3KEGdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:33:04 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58262 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:33:02 -0500
Message-ID: <527890A5.8050507@huawei.com>
Date: Tue, 5 Nov 2013 14:31:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>,
        Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, <prarit@redhat.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131103155729.GB9944@hansolo.jdub.homelinux.org> <20131104065343.GC13030@gmail.com> <20131104140141.GC9944@hansolo.jdub.homelinux.org> <20131104141051.GA19355@gmail.com> <20131104141615.GD9944@hansolo.jdub.homelinux.org> <20131104155624.GA31656@sgi.com> <20131104174841.GA19498@gmail.com> <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com> <20131104201111.GA19789@gmail.com> <527824C3.6000504@zytor.com> <20131105062537.GA31880@gmail.com>
In-Reply-To: <20131105062537.GA31880@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/5 14:25, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 11/04/2013 12:11 PM, Ingo Molnar wrote:
>>>
>>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>>> 8192 maybe?
>>>
>>> Yeah, that makes more sense I guess.
>>>
>>
>> However, I still have serious issues with crap like this because 
>> randconfig is basically broken.  If nothing else we need to get that 
>> feedback to the kconfig maintainers.
> 
> The problem with that is that there are no kconfig maintainers:
> 

Yes, there is.

https://lkml.org/lkml/2013/10/30/124

Though I don't know if the new maintainer will help in this issue.

>   KCONFIG
>   ...
>   S:      Odd Fixes
> 
> The kconfig code is still a hard to maintain, scarcely documented mess. It 
> took us almost a decade to rescue the NTP code from a similar obfuscation 
> trap and make it maintainable. It had the same author as the original 
> Kconfig code - and the Kconfig code is 10 times larger than the NTP code.
> 
> Thanks,
> 

