Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbbAEJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:09:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35122 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbbAEJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:09:55 -0500
Message-ID: <54AA54DC.6000407@collabora.co.uk>
Date: Mon, 05 Jan 2015 10:09:48 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: exynos_defconfig: Enable options for display
 panel support
References: <1420215089-2093-1-git-send-email-javier.martinez@collabora.co.uk> <1420447691.3918.2.camel@AMDC1943>
In-Reply-To: <1420447691.3918.2.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

>> Hello Kukjin,
>> 
>> You dropped this patch since exynos drm was causing boot hangs on some
>> platforms but the fix for that issue is already in linux-next (commit:
>> f1e9203 clk: samsung: Fix Exynos 5420 pinctrl setup and clock disable
>> failure due to domain being gated) so I think it makes sense to enable
>> the display options again.
> 
> I think these issues were unrelated to each other. DRM was disabled
> because of infinite deferred probing of DRM components. I saw Inki was
> sending some patches for it but I am not sure if they were merged.
>

Ups, you are completely right and it was my bad for pasting the wrong
commit fixing the boot hang when DRM was enabled, I actually meant commit:
("820687be drm/exynos: move Exynos platform drivers registration to init")
which also landed in v3.19-rc1.

Sorry for the confusion.
 
> Best regards,
> Krzysztof

Best regards,
Javier
