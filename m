Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaBNENg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:13:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40107 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <52FD5615.20508@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com>
 <1391750695-27447-1-git-send-email-ch.naveen@samsung.com> <52FD552E.8040008@samsung.com>
 <52FD5615.20508@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 14 Feb 2014 09:43:13 +0530
Message-ID: <CAHfPSqCAMq+9hitDSYrq++bB5Rrs1tJBT7VAXzeJEPLjxWoGmg@mail.gmail.com>
Subject: Re: [PATCH 6/9 v6] ARM: dts: exynos5250/5420: add dt node for sss module
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 14 February 2014 05:02, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 02/14/14 08:28, Kukjin Kim wrote:
>>
>> On 02/07/14 14:24, Naveen Krishna Chatradhi wrote:
>>>
>>> This patch adds the device tree node for SSS module
>>> found on Exynos5420 and Exynos5250
>>>
>>> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
>>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>> TO:<linux-samsung-soc@vger.kernel.org>
>>> CC: Kukjin Kim<kgene.kim@samsung.com>
>>> CC:<linux-crypto@vger.kernel.org>
>>> ---
>>> changes since v5:
>>> 1. Added Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>>
>>> arch/arm/boot/dts/exynos5250.dtsi | 8 ++++++++
>>> arch/arm/boot/dts/exynos5420.dtsi | 10 ++++++++++
>>> 2 files changed, 18 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>>> b/arch/arm/boot/dts/exynos5250.dtsi
>>> index b7dec41..46b04e8 100644
>>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>>> @@ -706,4 +706,12 @@
>>> io-channel-ranges;
>>> status = "disabled";
>>> };
>>> +
>>> + sss@10830000 {
>>> + compatible = "samsung,exynos4210-secss";
>>> + reg =<0x10830000 0x10000>;
>>> + interrupts =<0 112 0>;
>>> + clocks =<&clock 348>;
>>> + clock-names = "secss";
>>> + };
>>> };
>>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
>>> b/arch/arm/boot/dts/exynos5420.dtsi
>>> index 8db792b..b503e96 100644
>>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>>> @@ -652,4 +652,14 @@
>>> clocks =<&clock 319>,<&clock 318>;
>>> clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>>> };
>>> +
>>> + sss@10830000 {
>>> + compatible = "samsung,exynos4210-secss";
>>> + reg =<0x10830000 0x10000>;
>>> + interrupts =<0 112 0>;
>>> + clocks =<&clock 471>;
>>> + clock-names = "secss";
>>> + samsung,power-domain =<&g2d_pd>;
>>> + };
>>> +
>>> };
>>
>>
>> Applied, thanks.
>>
>> BTW, I think the numbering is strange...maybe I missed something?
>> [PATCH 5/5], [PATCH 5/6 V2], [PATCH 6/8 V3] and this [PATCH 6/9 V6]
>>
> Oops, Naveen, where is bindings doc for "samsung,exynos4210-secss"?
The binding doc patch is along with the driver patch
https://groups.google.com/forum/#!msg/linux.kernel/9Z02Gg_MzPA/GTc7Csg74L0J
and
http://patchwork.ozlabs.org/patch/314946/
>
> - Kukjin



-- 
Shine bright,
(: Nav :)
