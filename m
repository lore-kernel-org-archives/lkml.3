Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab3IZIUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:20:18 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38935 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3IZIUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:20:15 -0400
Message-ID: <5243EE3B.1050600@linaro.org>
Date: Thu, 26 Sep 2013 10:20:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 21/21] cpuidle: change governor from within cpuidle_replace_governor()
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>	<524368CF.4030803@linaro.org> <CAKohpom_BTYC4DZLP93VzFqfnCudPb9whugPigh-jO0MpHurtw@mail.gmail.com>
In-Reply-To: <CAKohpom_BTYC4DZLP93VzFqfnCudPb9whugPigh-jO0MpHurtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 08:37 AM, Viresh Kumar wrote:
> On 26 September 2013 04:20, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> Actually I am wondering if all this stuff is not over-engineered.
>>
>> There are 2 governors, each of them suits for a specific kernel config,
>> periodic tick or tickless system.
>>
>> menu     => tickless system
>> periodic => periodic tick system
>>
>> IMHO, all the code with rating checking and so do not really makes
>> sense. Wouldn't make sense to remove this code ?
>
> I am a newbie here, really can't think of all side effects of this :)

Rafael is pretty busy ATM but may be he can give his feedback on this later.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

