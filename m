Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaH1Oc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:32:26 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41719 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbaH1OcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:32:24 -0400
Message-ID: <53FF3D55.40006@st.com>
Date: Thu, 28 Aug 2014 16:31:49 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>, <kernel@stlinux.com>, <wsa@the-dreams.de>
Subject: Re: [STLinux Kernel] [PATCH 1/1] i2c: i2c-st: Rename clock reference
 to something that exists
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-28_01:2014-08-28,2014-08-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 08/28/2014 04:02 PM, Lee Jones wrote:
> CLK_S_ICN_REG_0 hasn't existed for a while now.  This was renamed
> over a few commits, then finally removed in commit 5aa02b9 (ARM:
> STi: DT: STiH415: Remove unused CLK_S_ICN_REG_0 fixed clock).
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Maybe it will be part of my next pull-requests, but in case it is not, 
you can add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime
> ---
>   Documentation/devicetree/bindings/i2c/i2c-st.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt
> index 437e0db..4c26fda 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-st.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-st.txt
> @@ -31,7 +31,7 @@ i2c0: i2c@fed40000 {
>   	compatible	= "st,comms-ssc4-i2c";
>   	reg		= <0xfed40000 0x110>;
>   	interrupts	=  <GIC_SPI 187 IRQ_TYPE_LEVEL_HIGH>;
> -	clocks		= <&CLK_S_ICN_REG_0>;
> +	clocks		= <&clk_s_a0_ls CLK_ICN_REG>;
>   	clock-names	= "ssc";
>   	clock-frequency = <400000>;
>   	pinctrl-names	= "default";
>
