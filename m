Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaAIE0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:26:39 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46753 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAIE0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:26:33 -0500
MIME-Version: 1.0
In-Reply-To: <1420297.0gEDu9oNDc@flatron>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
 <1389095509-14357-6-git-send-email-ch.naveen@samsung.com> <1420297.0gEDu9oNDc@flatron>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 9 Jan 2014 09:56:13 +0530
Message-ID: <CAHfPSqC3D-=T+v=zgWYfJbXki=L2Uc_axZWEsnMET8rDi31WKg@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: exynos5420: add dt node for sss module
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Naveen Krishna Ch <ch.naveen@samsung.com>, linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>, herbert@gondor.apana.org.au,
        cpgs@samsung.com, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tomasz,

On 8 January 2014 06:02, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Tuesday 07 of January 2014 17:21:49 Naveen Krishna Ch wrote:
>> From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>
>> this patch adds the device tree nodes for SSS module found on Exynos5420
>
> nit: Sentences in English start with a capital letter. Also this patch
> adds one node, not few of them as the description suggests.
>
> Also patch subject should start with ARM: dts: prefix.
>
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> TO: <linux-samsung-soc@vger.kernel.org>
>> CC: Kukjin Kim <kgene.kim@samsung.com>
>> CC: <linux-crypto@vger.kernel.org>
>> ---
>>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
>> index 11dd202..97045f9 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -652,4 +652,14 @@
>>               clocks = <&clock 319>, <&clock 318>;
>>               clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>>       };
>> +
>> +     sss: sss {
>
> Node name should be sss@10830000 as per ePAPR node naming recommendation.
Thanks for the correction, Will correct it and submit. Thanks
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
