Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaEBIw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:52:28 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45360 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaEBIwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:52:25 -0400
Message-ID: <53635CCB.9090301@linaro.org>
Date: Fri, 02 May 2014 10:52:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: peterz@infradead.org, mingo@elte.hu, amit.kucheria@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it
 out
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org> <2783362.8r7SvVhudq@vostro.rjw.lan>
In-Reply-To: <2783362.8r7SvVhudq@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 12:47 AM, Rafael J. Wysocki wrote:
> On Wednesday, April 30, 2014 02:01:02 PM Daniel Lezcano wrote:
>> Encapsulate the large portion of cpuidle_idle_call inside another
>> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
>> Also that is benefitial for the clarity of the code as it removes
>> a nested indentation level.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> Well, this conflicts with
>
> https://patchwork.kernel.org/patch/4071541/
>
> which you haven't commented on and I still want cpuidle_select() to be able to
> return negative values because of
>
> https://patchwork.kernel.org/patch/4089631/
>
> (and I have one more patch on top of these two that requires this).
>
> Any ideas how to resolve that?

I don't think we have a big conflict. If Peter takes your patches before 
than mines then I will refresh and resend them.

I am open to any other suggestion.


Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

