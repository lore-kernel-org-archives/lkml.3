Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3KYMBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:01:13 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:56429 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3KYMBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:01:10 -0500
Message-ID: <52933BFB.6000405@linaro.org>
Date: Mon, 25 Nov 2013 20:00:59 +0800
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
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <528F4A78.1080505@linaro.org> <5292A0AB.9030003@linaro.org> <52930C11.8070005@linaro.org>
In-Reply-To: <52930C11.8070005@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:36 PM, Daniel Lezcano wrote:
> On 11/25/2013 01:58 AM, Alex Shi wrote:
>> On 11/22/2013 08:13 PM, Daniel Lezcano wrote:
>>>
>>> Hi Alex,
>>>
>>> I tried on my Xeon server (2 x 4 cores) your patchset and got the
>>> following result:
>>>
>>> kernel a5d6e63323fe7799eb0e6  / + patchset
>>>
>>> hackbench -T -s 4096 -l 1000 -g 10 -f 40
>>>        27.604              38.556
>>
>> Hi Daniel, would you like give the detailed server info? 2 socket * 4
>> cores, sounds it isn't a modern machine.
> 
> Well it has several years old now, that's true but still competing with
> some recent processors :)
> 
> Bi-Xeon E5345 2.33GHz / 8Mb L2 cache / 7BG FB-DIMM Memory 667 MHz /
> 300GB SSD 3Gb/s
> 
> 


It is a core2 CPU, quite old.
Fengguang, do you include similar box in your system?

-- 
Thanks
    Alex
