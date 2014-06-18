Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194AbaFRLJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:09:38 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56347 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966138AbaFRLJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:09:34 -0400
Message-ID: <53A1734D.7000606@st.com>
Date: Wed, 18 Jun 2014 13:09:01 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: stih41x: Rename stih416-b2020-revE.dts to stih416-b2020e.dts
References: <1403087508-6710-1-git-send-email-lee.jones@linaro.org> <20140618105438.GC8300@lee--X1>
In-Reply-To: <20140618105438.GC8300@lee--X1>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_04:2014-06-17,2014-06-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 06/18/2014 12:54 PM, Lee Jones wrote:
> Two reasons for this rename.  Firstly, it removes the camel case
> convention which isn't used by any other platform and secondly it
> matches the naming convention for the internal kernel, which can
> become annoying when flipping between the two.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

It will be part of the STi pull-request for 3.16 fixes.

Thanks,
Maxime

> ---
> v1 -> v2: Appropriate change to the Makefile.
> ---
>   arch/arm/boot/dts/Makefile                                       | 2 +-
>   arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} | 0
>   2 files changed, 1 insertion(+), 1 deletion(-)
>   rename arch/arm/boot/dts/{stih416-b2020-revE.dts => stih416-b2020e.dts} (100%)
>
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 5986ff6..adb5ed9 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -357,7 +357,7 @@ dtb-$(CONFIG_ARCH_STI)+= stih407-b2120.dtb \
>          stih415-b2020.dtb \
>          stih416-b2000.dtb \
>          stih416-b2020.dtb \
> -       stih416-b2020-revE.dtb
> +       stih416-b2020e.dtb
>   dtb-$(CONFIG_MACH_SUN4I) += \
>          sun4i-a10-a1000.dtb \
>          sun4i-a10-cubieboard.dtb \
> diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020e.dts
> similarity index 100%
> rename from arch/arm/boot/dts/stih416-b2020-revE.dts
> rename to arch/arm/boot/dts/stih416-b2020e.dts
>
