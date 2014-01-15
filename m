Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaAONJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 08:09:51 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51762 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaAONJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 08:09:48 -0500
Message-ID: <52D6887E.6010702@linaro.org>
Date: Wed, 15 Jan 2014 14:09:18 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
References: <52D64676.4040000@linaro.org> <20140115120418.GD31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140115120418.GD31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 01:04 PM, Peter Zijlstra wrote:
> On Wed, Jan 15, 2014 at 09:27:34AM +0100, Daniel Lezcano wrote:
>>
>> Hi all,
>>
>> I use the tip/sched/core branch.
>>
>> After git pulling yesterday, my host is unresponsive after booting the OS.
>>
>>   * It boots normally
>>   * It sends info to the console
>>   * The graphics does not work
>>   * The terminals show the prompt, I can enter the username but after
>> pressing enter, it does not give the password prompt
>>   * sysrq works more or less, I can't get the process stack but it receives
>> the command
>>
>> It is like no new process can be created.
>>
>> I have a dual Xeon processor E5325 (2 x 4 cores).
>>
>> After git bisecting, the following patch seems to introduce the bug.
>>
>> commit d50dde5a10f305253cbc3855307f608f8a3c5f73
>
> OK, so my headless WSM-EP boots just fine. Obviously it cannot confirm
> if graphics works, but I can ssh in and work on it without bother.
>
> I can even log in on the serial console without problems.
>
> I tried both tip/master and tip/sched/core.
>
> Would you happen to have a .config for me to try?

Yes, sure.

http://pastebin.com/Hj4nEZHc


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

