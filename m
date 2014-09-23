Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaIWQA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:00:57 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43519 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaIWQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:00:55 -0400
Message-ID: <5421992F.6070908@samsung.com>
Date: Wed, 24 Sep 2014 01:00:47 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>
CC: =?UTF-8?B?J0FuZHJlYXMgRsOkcmJlcic=?= <afaerber@suse.de>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Daniel Drake'" <drake@endlessm.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk> <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com> <5419ADF9.3010509@suse.de> <00f801cfd6f6$07e10500$17a30f00$@kernel.org>
In-Reply-To: <00f801cfd6f6$07e10500$17a30f00$@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/14 15:17, Kukjin Kim wrote:
> Kukjin Kim wrote:
>>>
>> Andreas Färber wrote:
>
> [...]
>
>>>> Kukjin: Andreas's patch series was Reviewed long ago I think and by
>>>> now I'd imagine it's got some conflicts due to it not having been
>>>> applied in a timely fashion.  Perhaps you could fix it up for Andreas
>>>> (since he's already rebased it several times) and land it?
>>>>
>>>> If I had to guess, outstanding from Andreas's series (patchwork IDs listed):
>>>>
>>>> 4751131 New          [v7] ARM: dts: Prepare node labels for exynos5250
>>>> 4664801 New          [v6,04/10] ARM: dts: Clean up exynos5250-snow
>>>> 4664771 New          [v6,05/10] ARM: dts: Fill in bootargs for exynos5250-snow
>>>> 4664731 New          [v6,06/10] ARM: dts: Clean up exynos5250-smdk5250
>>>> 4664751 New          [v6,07/10] ARM: dts: Clean up exynos5250-arndale
>>>> 4664711 New          [v6,08/10] ARM: dts: Fix apparent GPIO typo in
>>>> exynos5250-arndale
>>>> 4664681 New          [v6,09/10] ARM: dts: Simplify USB3503 on exynos5250-arndale
>>>> 4664691 New          [v6,10/10] ARM: dts: Add exynos5250-spring device tree
>>>
>>> Yes, Kukjin told me not to resend anything, and I haven't heard back
>>> from him since his Kernel Summit trip.
>>>
>> Sorry about that and I thought I took them :( I'll sort them out tonight
>> including this series together.
>>
> Hmm...since some conflicts with dp and mmc_slot related patches, I couldn't,
> but Andreas' patches will be handled by tonight :(
>
> - Kukjin

I've applied above and this series and please double-check the commits 
in my tree. If no problems, I will send the branch out for v3.18 soon...

Thanks,
Kukjin
