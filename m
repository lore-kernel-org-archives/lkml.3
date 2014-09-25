Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaIYHSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:18:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44886 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaIYHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:18:07 -0400
Message-ID: <5423C1A8.6080603@collabora.co.uk>
Date: Thu, 25 Sep 2014 09:18:00 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Kukjin Kim <kgene@kernel.org>, "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Daniel Drake'" <drake@endlessm.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        =?windows-1252?Q?=27Andreas_F=E4rber=27?= <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk> <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com> <5419ADF9.3010509@suse.de> <00f801cfd6f6$07e10500$17a30f00$@kernel.org> <5421992F.6070908@samsung.com> <54219D47.6010102@collabora.co.uk> <54233A84.7040902@collabora.co.uk> <54235360.7090303@samsung.com>
In-Reply-To: <54235360.7090303@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 09/25/2014 01:27 AM, Kukjin Kim wrote:
>>
>> Today I also had time to review the rebased patches from Andreas and found
>> two issues introduced during the merge conflict resolution:
>>
> Oops. Thanks for your quick fix it up.
>

You are welcome.
 
>> 1) The spi_1 dev node on exynos5250-smdk5250.dts now uses the old "cs-gpio"
>>     DT property under the controller-data instead of the standard "cs-gpios"
>>     under the SPI parent. IOW, is a regression of the bug fixed in commit
>>     e138d43 ("ARM: dts: fix the chip select gpios definition in the SPI nodes").
>>
>> 2) The display-timings child node of the dp-controller was removed in commit
>>     a98c3c2 ("ARM: dts: update display related nodes for exynos5250-snow") but
>>     was introduced again in the Snow DTS during the merge.
>>
>> I'll post a series that fixes both issues with the following patches:
>>
> I've applied them.
> 
>> Javier Martinez Canillas (2):
>>        ARM: dts: Fix chip select GPIO on smdk5250
>>        ARM: dts: Remove display timings node from exynos5250-snow
>>
>> I see that you already send a pull request to arm-soc maintainers so probably
>> these will be part of the fixes during the 3.18 rc cycle.
>>
> I'll queue them in my third pull-request maybe today :)
> 

Great. It would be awesome also if you can also pick Sjoerd's USB series [0]
which solves an issue with USB on certain configurations.

I looked at your for-next branch but I didn't see those patches there.

> Thanks,
> Kukjin
> 

Thanks a lot and best regards,
Javier

[0]: https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg37045.html
