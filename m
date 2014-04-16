Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaDPLtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:49:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49510 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaDPLti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:49:38 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c3-534e6e507ee4
Message-id: <534E6E4E.4020807@samsung.com>
Date: Wed, 16 Apr 2014 13:49:34 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 2/2] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
 <1397643118-6934-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397643118-6934-3-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Nd2APL9gg3WvZS3uPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWz2PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	ll6/yGQxYfpaFou3d6azWLTuPcJucfJPL6ODoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbA+Qtqffo27KK0ePzJrkAzigum5TUnMyy1CJ9uwSujL2fTrIWrBSp+Hh4LmMD4ymBLkZO
	DgkBE4m7+2awQdhiEhfurQeyuTiEBJYySiyeuogVwvnMKNGx+y07SBWvgJbEoZe/wGwWAVWJ
	FYsuM4HYbAJqEp8bHoFN4geqWdN0nQXEFhWIkLjXeJgVoldQ4sfke2BxEYEsidtTjzGC2MwC
	L5gk1vb5gNjCArES62buA4sLCdRL3Dv2Emw+p4CrxJJ5ELuYBawlVk7aBtUrL7F5zVvmCYyC
	s5CsmIWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQuLwyw7GxcesDjEKcDAq
	8fA6ZPkGC7EmlhVX5h5ilOBgVhLh7c3yCxbiTUmsrEotyo8vKs1JLT7EyMTBKdXAOFvLLMxI
	/bKpC5/YgpSS2IlzN/Vf7QmuMVkr9fmo+XnLzWvYzCSlIlTa7mWnrdujF8Hw9Mie9fPWTO7g
	nXd40ssH0/eekPbp0pdZuvR2tr12+8tpphOMNkfcazqy8gLzE37R8x0Om+5sa2bVfrVBuUTw
	/pqiyQvNsta7mu75eXGN5s05q8r+eiuxFGckGmoxFxUnAgAnPZHKoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 16.04.2014 12:11, Chanwoo Choi wrote:
> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
> special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.
>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 5d49f2b..7532ec3 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -14,6 +14,8 @@ Required properties:
>   				for exynos4412/5250 controllers.
>   			Must be "samsung,exynos-adc-v2" for
>   				future controllers.
> +			Must be "samsung,exynos-adc-v3" for
> +				for exynos3250 controllers.

I don't think adc-v3 is correct here. It looks like a normal V2 with 
additional special clock input. Possibly "samsung,exynos3250-adc-v2" or 
"samsung,exynos-adc-v2-sclk" would be better choices.

>   - reg:			Contains ADC register address range (base address and
>   			length) and the address of the phy enable register.
>   - interrupts: 		Contains the interrupt information for the timer. The
> @@ -21,7 +23,11 @@ Required properties:
>   			the Samsung device uses.
>   - #io-channel-cells = <1>; As ADC has multiple outputs
>   - clocks		From common clock binding: handle to adc clock.
> +			From common clock binding: handle to sclk_tsadc clock
> +			if using Exynos3250.
>   - clock-names		From common clock binding: Shall be "adc".
> +			From common clock binding: Shall be "sclk_tsadc"
> +			if using Exynos3250.
>   - vdd-supply		VDD input supply.
>
>   Note: child nodes can be added for auto probing from device tree.
> @@ -41,6 +47,20 @@ adc: adc@12D10000 {
>   	vdd-supply = <&buck5_reg>;
>   };
>
> +If Exynos3250 uses ADC,

Please keep proper formatting:

Example: Node for ADC of Exynos3250 with additional special clock

Best regards,
Tomasz
