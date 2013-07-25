Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3GYVNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:13:33 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44304 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab3GYVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:13:30 -0400
Message-ID: <51F194F5.8040303@gmail.com>
Date: Thu, 25 Jul 2013 23:13:25 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12
 ISP clocks
References: <1372099374-21008-1-git-send-email-s.nawrocki@samsung.com> <51ED2230.8080100@samsung.com> <20130725202337.7598.20912@quantum>
In-Reply-To: <20130725202337.7598.20912@quantum>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 10:23 PM, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2013-07-22 05:14:40)
>> On 06/24/2013 08:42 PM, Sylwester Nawrocki wrote:
>>> The ISP clock registers belong to the ISP power domain and may change
>>> their values if this power domain is switched off/on. Add
>>> CLK_GET_RATE_NOCACHE flags to ensure we do not rely on invalid cached
>>> data when setting or getting frequency of those clocks.
>>>
>>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>
>> Mike,
>>
>> would you consider queueing that patch for current -rc cycle ?
>
> Sylwester,
>
> Can you rebase this onto -rc2? It does not apply cleanly onto my -fixes
> branch.

Sure, I've just posted an updated version.

Thanks,
Sylwester
