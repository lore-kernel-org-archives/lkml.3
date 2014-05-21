Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaEUIdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:33:21 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52347 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbaEUIdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:33:19 -0400
Message-ID: <537C64A6.4050409@st.com>
Date: Wed, 21 May 2014 10:32:38 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <patrice.chotard@st.com>
Cc: <kernel@stlinux.com>
Subject: Re: [PATCH 3/3] ARM: sti: stih41x: Provide a proper header for this
 DTSI file
References: <1400660415-14720-1-git-send-email-lee.jones@linaro.org> <1400660415-14720-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400660415-14720-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-21_02:2014-05-21,2014-05-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 05/21/2014 10:20 AM, Lee Jones wrote:
> Also explicitly include STiH416 Clk bindings instead of relying on
> inheriting them from other DTSI files which we happen to include.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih41x.dtsi | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/stih41x.dtsi b/arch/arm/boot/dts/stih41x.dtsi
> index f5b9898..32730e5 100644
> --- a/arch/arm/boot/dts/stih41x.dtsi
> +++ b/arch/arm/boot/dts/stih41x.dtsi
> @@ -1,3 +1,11 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics Limited.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * publishhed by the Free Software Foundation.
> + */
> +#include "stih416-clock.dtsi"

Nack.
As discussed on IRC, this dtsi file is included by stih415.dtsi.
In this case, we want to include stih415-clocks.dtsi instead.

Regards,
Maxime
>   / {
>   	#address-cells = <1>;
>   	#size-cells = <1>;
>
