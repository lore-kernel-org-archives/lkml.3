Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaAUJ26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:28:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47236 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaAUJ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:28:53 -0500
Message-ID: <52DE3DD4.5090506@linaro.org>
Date: Tue, 21 Jan 2014 10:28:52 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org> <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org> <20140117142644.GI11314@laptop.programming.kicks-ass.net> <52D94705.1000407@linaro.org> <20140117152310.GK11314@laptop.programming.kicks-ass.net> <52D94B95.2060704@linaro.org> <20140117153323.GM11314@laptop.programming.kicks-ass.net> <52DE32BB.4010006@linaro.org> <20140121090609.GP31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121090609.GP31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 10:06 AM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 09:41:31AM +0100, Daniel Lezcano wrote:
>> On 01/17/2014 04:33 PM, Peter Zijlstra wrote:
>>> On Fri, Jan 17, 2014 at 04:26:13PM +0100, Daniel Lezcano wrote:
>>>>
>>>> Ah, ok. Let me try it.
>>>>
>>>
>>> http://programming.kicks-ass.net/sekrit/patches.tar.bz2
>>>
>>> has a queue that applies to tip/master.
>>>
>>> The patches as on lkml need a little help in applying.
>>>
>>> They've not been near a compiler yet though :/
>>
>> Hi Peter,
>>
>> do you want me to resend the full serie with your patchset included ?
>
> Nah, I'll send it out, I wanted PJT or Ben to look over one more patch I
> did, meant to do that yesterday but you know how those things go :-)

Yeah :)

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

