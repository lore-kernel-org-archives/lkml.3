Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaKSMEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:04:00 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:60726 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaKSMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <CABxcv=mams-iVBvACLZ-=Ozcs3KcHSEvxAsRSSV-eKaSnrcXSA@mail.gmail.com>
References: <1414675442-3471-1-git-send-email-gautam.vivek@samsung.com>
	<1414675442-3471-2-git-send-email-gautam.vivek@samsung.com>
	<000101cffe30$155793a0$4006bae0$%han@samsung.com>
	<CABxcv=mams-iVBvACLZ-=Ozcs3KcHSEvxAsRSSV-eKaSnrcXSA@mail.gmail.com>
Date: Wed, 19 Nov 2014 17:33:56 +0530
Message-ID: <CAFp+6iEnTbXAUUYMU-bP27f4=X0pEtgmURAwKfRrqDQE4tRpKQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sean Paul <seanpaul@google.com>, Ajay Kumar <ajaykumar.rs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,


On Wed, Nov 19, 2014 at 5:06 PM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> [adding Kukjin to cc list]
>
> Hello Vivek,
>
> On Wed, Nov 12, 2014 at 5:21 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>> On Thursday, October 30, 2014 10:24 PM, Vivek Gautam wrote:
>>>
>>> DP PHY now require pmu-system-controller to handle PMU register
>>> to control PHY's power isolation. Adding the same to dp-phy
>>> node.
>>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> Cc: Jingoo Han <jg1.han@samsung.com>
>>
>> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
>>
>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thanks for testing.

>
> Kukjin,

Sorry for not adding Kukjin to the list and thereby for the delay
about this patch.

>
> This patch is -rc material and is needed to have display working in
> 3.18 again since commit a5ec598 ("phy: exynos-dp-video: Use syscon
> support to control pmu register") landed in 3.18 and broke the Exynos
> Display Port PHY:
>
> exynos-dp-video-phy 10040728.video-phy: Failed to lookup PMU regmap

Yes, we should pick this up and merge it since the driver patch is merged now.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
