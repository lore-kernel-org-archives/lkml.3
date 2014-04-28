Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaD1KJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:09:25 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60636 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaD1KJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:09:22 -0400
Message-ID: <535E28D0.7050502@linaro.org>
Date: Mon, 28 Apr 2014 12:09:20 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <535911DC.9050109@linaro.org> <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com> <2713863.BLQTYQm2Oa@vostro.rjw.lan> <20140425132055.GC11096@twins.programming.kicks-ass.net> <535A94E3.5080004@linaro.org> <20140425184327.GH26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140425184327.GH26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 08:43 PM, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 07:01:23PM +0200, Daniel Lezcano wrote:
>> As the sysctl is some kind of ABI, I would like to make sure we reach a
>> consensus and discuss a bit about that.
>
> We could make it a sysfs file, like /sys/power/state, which when read
> provides the words it takes.
>
> That is more flexible than a numeric sysctl for which we have to keep an
> enumeration.

I agree a numerical value is not flexible. But it sounds weird to put a 
scheduler option in the sysfs and maybe more options will follow.

I am wondering if we shouldn't create a new cgroup for 'energy' and put 
everything in there. So we will have more flexibility for extension and 
we will be able to create a group of tasks for performance and a group 
of tasks for energy saving.

Does it make sense ?

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

