Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaGJIAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:00:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41986 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGJIAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:00:52 -0400
Message-ID: <53BE482C.9000503@collabora.com>
Date: Thu, 10 Jul 2014 10:00:44 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC v2 0/5] Per-user clock constraints
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com> <53BDA31D.40502@gmail.com>
In-Reply-To: <53BDA31D.40502@gmail.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 10:16 PM, Tomasz Figa wrote:
> Hi Tomeu,
>
> On 03.07.2014 16:38, Tomeu Vizoso wrote:
>> Hello,
>>
>> here is another round for commenting, not very different from the first one.
>>
>> Something I forgot to mention before is that the function rename was performed
>> by the scripts in:
>>
>> http://cgit.collabora.com/git/user/tomeu/linux.git/commit/?h=clk-refactoring-4&id=0e983e28864229f2cd525f87d59e034c4876b233
>>
>> As before, I have only checked that drivers/clk/ builds with allyesconfig, and
>> that a kernel can be built for tegra_defconfig.
>
> This is quite an interesting series. I have reviewed two of five patches
> and have plans to look at remaining ones, however here are few general
> issues I'd like to raise:
>
> - somehow I don't see patch 2/5 on LAKML. Too big?

Yes, I'm not sure what I can do about that, but it's only automated 
function renaming. I'm going to send v3 in a bit and will CC you.

> - I see the series changing particular clock drivers. A good practice
> would be to Cc respective driver maintainers to take a look at those
> changes.

Now that I'm more confident about this approach, for the next version 
I'm going to CC them as well.

> - please make sure that all the patches don't have checkpatch errors or
> significant warnings.

Sure.

> Will try (myself or by asking someone else) to do some testing on
> Samsung platforms.

That will be great, thanks. One scenario I'm looking forward to test 
this with is low system load while the display is being updated often at 
a high resolution.

I would expect to see that the Exynos5 devfreq driver sets a relatively 
low floor frequency, and the DC driver overrides that by setting a 
higher floor, based on the calculated bandwidth that will be required to 
move pixels around.

Regards,

Tomeu

> Best regards,
> Tomasz
>

