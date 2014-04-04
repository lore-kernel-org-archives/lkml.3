Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaDDIQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 04:16:52 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36024 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaDDIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:16:43 -0400
Message-ID: <533E6A7A.4070400@linaro.org>
Date: Fri, 04 Apr 2014 10:16:58 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, nicolas.pitre@linaro.org,
        Linux PM list <linux-pm@vger.kernel.org>, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 0/3] sched/idle : find the idlest cpu with cpuidle
 info
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <CAJvTdKk9AJUfCKGDS1RGDNJwP-Q9gTYswBEHHji6L6Lq3yd8JA@mail.gmail.com>
In-Reply-To: <CAJvTdKk9AJUfCKGDS1RGDNJwP-Q9gTYswBEHHji6L6Lq3yd8JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 08:29 AM, Len Brown wrote:
> Hi Daniel,
>
> Interesting idea.
>
> The benefit of this patch is to reduce power.
> Have you been able to measure a power reduction, via power meter, or
> via built-in RAPL power meter?
> (turbostat will show RAPL watts, or if you have constant quantity of
> work, use turbostat -J)

Hi Len,

thanks for looking the patches.

I will tweak, respin the patchset and do some more measurements.

I don't have a power meter but may be the RAPL could help to test on x86.

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

