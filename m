Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987Ab3KXFAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 00:00:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36537 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3KXFAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 00:00:43 -0500
Message-ID: <529187EE.4010304@linaro.org>
Date: Sun, 24 Nov 2013 13:00:30 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, mingo@redhat.com,
        peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com
CC: james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <528F4A78.1080505@linaro.org>
In-Reply-To: <528F4A78.1080505@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 08:13 PM, Daniel Lezcano wrote:
>>
>> The git tree for this patchset at:
>>   git@github.com:alexshi/power-scheduling.git no-load-idx
>> Since Fengguang had included this tree into his kernel testing system.
>> and I haven't get a regression report until now. I suppose it is fine
>> for x86 system.
>>
>> But anyway, since the scheduler change will effect all archs. and
>> hackbench is only benchmark I found now for this patchset. I'd like to
>> see more testing and talking on this patchset.
> 
> Hi Alex,
> 
> I tried on my Xeon server (2 x 4 cores) your patchset and got the
> following result:
> 
> kernel a5d6e63323fe7799eb0e6  / + patchset
> 
> hackbench -T -s 4096 -l 1000 -g 10 -f 40
>       27.604              38.556


Thanks for your testing, Daniel!

Fengguang, how about your kernel results for this patchset?

-- 
Thanks
    Alex
