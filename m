Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaGVJHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:07:31 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:54686 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbaGVJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:07:29 -0400
Message-ID: <53CE29AE.3040505@st.com>
Date: Tue, 22 Jul 2014 11:06:54 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <devicetree@vger.kernel.org>
Subject: Re: [RESEND PATCH 1/1] ARM: DT: STi: STiH416: Add DT node for ST's
 SATA device
References: <1405931573-12407-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1405931573-12407-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-22_03:2014-07-22,2014-07-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 07/21/2014 10:32 AM, Lee Jones wrote:
> Cc: devicetree@vger.kernel.org
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   Documentation/devicetree/bindings/ata/ahci-st.txt |  2 +-
>   arch/arm/boot/dts/stih416-b2020.dts               |  4 ++++
>   arch/arm/boot/dts/stih416-b2020e.dts              |  4 ++++
>   arch/arm/boot/dts/stih416.dtsi                    | 16 ++++++++++++++++
>   4 files changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/ata/ahci-st.txt b/Documentation/devicetree/bindings/ata/ahci-st.txt
> index 0574a77..9883542 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-st.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-st.txt
> @@ -21,7 +21,7 @@ Example:
>   		reg             = <0xfe380000 0x1000>;
>   		interrupts      = <GIC_SPI 157 IRQ_TYPE_NONE>;
>   		interrupt-names = "hostc";
> -		phys	        = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
> +		phys	        = <&phy_port0 MIPHY_TYPE_SATA>;
>   		phy-names       = "ahci_phy";
>   		resets	        = <&powerdown STIH416_SATA0_POWERDOWN>,
>   				  <&softreset STIH416_SATA0_SOFTRESET>;

Patch does not apply because this file does not exist in my tree.
Shouldn't be in a separate patch?

Regards,
Maxime
