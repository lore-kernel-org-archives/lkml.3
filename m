Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaGHHlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:41:14 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42354 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbaGHHlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:41:12 -0400
Message-ID: <53BBA075.9040204@st.com>
Date: Tue, 8 Jul 2014 09:40:37 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Cc: <lee.jones@linaro.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 3/3] MAINTAINERS: Add dwc3-st.c file to ARCH/STI architecture
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org> <1404541530-27856-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1404541530-27856-4-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-08_03:2014-07-07,2014-07-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 07/05/2014 08:25 AM, Peter Griffin wrote:
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 702ca10..269ad3b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1325,6 +1325,7 @@ F:	drivers/pinctrl/pinctrl-st.c
>   F:	drivers/media/rc/st_rc.c
>   F:	drivers/i2c/busses/i2c-st.c
>   F:	drivers/tty/serial/st-asc.c
> +F:	drivers/usb/dwc3/dwc3-st.c
>
>   ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>   M:	Lennert Buytenhek <kernel@wantstofly.org>
>
