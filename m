Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaCKKww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:52:52 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:56016 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbaCKKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:52:51 -0400
Message-ID: <531EEADF.5060001@st.com>
Date: Tue, 11 Mar 2014 11:52:15 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 2/3] ARM: STi: stih416-b2020: Explicitly include STiH416
 Pinctrl bindings
References: <1394533324-20299-1-git-send-email-lee.jones@linaro.org> <1394533324-20299-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1394533324-20299-2-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/11/2014 11:22 AM, Lee Jones wrote:
> At the moment we're relying on inheriting them from DTSI files which
> we're including Ideally we should be specifying these for ourselves.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   arch/arm/boot/dts/stih416-b2020-revE.dts | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> index bcb9d00..4168b019 100644
> --- a/arch/arm/boot/dts/stih416-b2020-revE.dts
> +++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> @@ -8,6 +8,7 @@
>    */
>   /dts-v1/;
>   #include "stih416.dtsi"
> +#include "stih416-pinctrl.dtsi"
Isn't this file already included in stih416.dtsi?

>   #include "stih41x-b2020.dtsi"
>   / {
>           model = "STih416 B2020 REV. E";
>

For the next revision, could you please add kernel@stlinux.com in cc?

Regards,
Maxime
