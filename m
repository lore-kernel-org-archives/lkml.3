Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbbAENW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:22:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35506 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbAENW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:22:26 -0500
Message-ID: <54AA900B.4000403@collabora.co.uk>
Date: Mon, 05 Jan 2015 14:22:19 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>
CC: "'Doug Anderson'" <dianders@chromium.org>,
        "'Kevin Hilman'" <khilman@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Krzysztof Kozlowski'" <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: exynos_defconfig: Enable options for display
 panel support
References: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk> <047c01d028e7$311858e0$93490aa0$@kernel.org>
In-Reply-To: <047c01d028e7$311858e0$93490aa0$@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

>> 
>> Hello Kukjin,
>> 
> Hi Javier,
> 
> Happy new year :)
>

Thanks, happy new year for you as well!

>> You dropped this patch since exynos drm was causing boot hangs on some
>> platforms but the fix for that issue is already in linux-next (commit:
>> f1e9203 clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
>> failure due to domain being gated) so I think it makes sense to enable
>> the display options again.
>> 
>> NOTE: Display panel is still not working since patch "arm: dts: Exynos5:
>> Use pmu_system_controller phandle for dp phy" is needed [0] but I think
>> we should enable display options to catch the regressions easier.
>> 
> Agreed with your suggestion and I'll pick this up into Samsung tree soon.
> 

Perfect, I hope you can pick my peach pit/pi and snow DTS updates series
as well since those patches have been in the list for some time.

> Thanks,
> Kukjin
> 

Best regards,
Javier
