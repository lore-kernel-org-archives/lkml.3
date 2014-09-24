Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaIXX1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:27:38 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46710 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIXX1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:27:36 -0400
Message-ID: <54235360.7090303@samsung.com>
Date: Thu, 25 Sep 2014 08:27:28 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Daniel Drake'" <drake@endlessm.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        =?ISO-8859-1?Q?=27Andreas_F=E4rber=27?= <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk> <1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com> <5419ADF9.3010509@suse.de> <00f801cfd6f6$07e10500$17a30f00$@kernel.org> <5421992F.6070908@samsung.com> <54219D47.6010102@collabora.co.uk> <54233A84.7040902@collabora.co.uk>
In-Reply-To: <54233A84.7040902@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 06:41, Javier Martinez Canillas wrote:
> Hello Kukjin,
>
Hi,

> On 09/23/2014 06:18 PM, Javier Martinez Canillas wrote:
>> On 09/23/2014 06:00 PM, Kukjin Kim wrote:
>>> On 09/23/14 15:17, Kukjin Kim wrote:
>>>
>>> I've applied above and this series and please double-check the commits
>>> in my tree. If no problems, I will send the branch out for v3.18 soon...
>>>
>>> Thanks,
>>> Kukjin
>>>
>>
>> I've looked the RTC source clock patches and look good to me. Thanks a lot for your help!
>>
>
> Today I also had time to review the rebased patches from Andreas and found
> two issues introduced during the merge conflict resolution:
>
Oops. Thanks for your quick fix it up.

> 1) The spi_1 dev node on exynos5250-smdk5250.dts now uses the old "cs-gpio"
>     DT property under the controller-data instead of the standard "cs-gpios"
>     under the SPI parent. IOW, is a regression of the bug fixed in commit
>     e138d43 ("ARM: dts: fix the chip select gpios definition in the SPI nodes").
>
> 2) The display-timings child node of the dp-controller was removed in commit
>     a98c3c2 ("ARM: dts: update display related nodes for exynos5250-snow") but
>     was introduced again in the Snow DTS during the merge.
>
> I'll post a series that fixes both issues with the following patches:
>
I've applied them.

> Javier Martinez Canillas (2):
>        ARM: dts: Fix chip select GPIO on smdk5250
>        ARM: dts: Remove display timings node from exynos5250-snow
>
> I see that you already send a pull request to arm-soc maintainers so probably
> these will be part of the fixes during the 3.18 rc cycle.
>
I'll queue them in my third pull-request maybe today :)

Thanks,
Kukjin

