Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbaGRAK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:10:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaGRAK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:10:27 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-1d-53c865e38cd3
Message-id: <53C865E3.5030806@samsung.com>
Date: Fri, 18 Jul 2014 09:10:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux@arm.linux.org.uk, kgene.kim@samsung.com, t.figa@samsung.com,
        kyungmin.park@samsung.com, ideal.song@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] ARM: dts: Add I2S dt node for Exynos3250
References: <1404874819-8257-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1404874819-8257-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWyRsSkWPdx6olgg+Y1ehbXvzxntdj19z6j
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12L9jNcsDpweLc09bB6bl9R79G1Zxejx
	eZNcAEsUl01Kak5mWWqRvl0CV8al/30sBX08Fa9m72dvYLzE2cXIySEhYCJx/sV5dghbTOLC
	vfVsXYxcHEICSxkldv94xARTNPH5BUaIxCJGiddn/rNCOK8ZJX4uv8oMUsUroCWx//hXsFEs
	AqoSF/avAYuzgcRf3GADsUUFwiRWTr/CAlEvKPFj8j0wW0RAQ2Lm3ytgG5gFnjJKbGqZyAiS
	EBawlzi7+TjYICEBF4lNz9aCncQp4Cox4/k0MJtZQEdif+s0NghbXmLzmrfMIIMkBC6xS7Ru
	Wg91kYDEt8mHgLZxACVkJTYdYIZ4TVLi4IobLBMYxWYhuWkWkrGzkIxdwMi8ilE0tSC5oDgp
	vchQrzgxt7g0L10vOT93EyMwAk//e9a7g/H2AetDjMlAKycyS4km5wMjOK8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGA0+SvK6fd32T17w68t7
	Ujzu/vwLNi1MY38ZLeuwIdBVK2/fnvrmufazWqdI+kb3fg9QXLh2X0z7BIG/uT4uNwpsJgl6
	/4+vudbf+PdeVuBlT+ssqZKrW7nve3cctZOfkVApHcwmsupbtfXXFVu6smecu3F6l6Wmiay7
	d29pjl1lpWLNXVtmJZbijERDLeai4kQAdHK92dYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAd3HqSeCDZ5fVbO4/uU5q8Wuv/cZ
	LXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3LvBbrZ7xmceD0aGnuYfPYvKTeo2/LKkaP
	z5vkAliiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmXPrfx1LQx1PxavZ+
	9gbGS5xdjJwcEgImEhOfX2CEsMUkLtxbz9bFyMUhJLCIUeL1mf+sEM5rRomfy68yg1TxCmhJ
	7D/+lR3EZhFQlbiwfw1YnA0k/uIGG4gtKhAmsXL6FRaIekGJH5PvgdkiAhoSM/9eYQQZyizw
	lFFiU8tEsNXCAvYSZzcfBxskJOAisenZWiYQm1PAVWLG82lgNrOAjsT+1mlsELa8xOY1b5kn
	MArMQrJjFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQIju9n0jsYVzVYHGIU
	4GBU4uG1uHk8WIg1say4MvcQowQHs5IIb/Z9oBBvSmJlVWpRfnxRaU5q8SFGU2AQTGSWEk3O
	B6aevJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjBqXz79Iu9Zh
	t25tfDjfZ2+OBLcD0+KqPp+rX/dPJpj/kv7k30c2KhlfqP553830r8G7OT/vV6w6atFgzn6D
	LTFHz3repnSB4zeynp6//17ypV82u78v56VVLyeEX/qhkhOgtW5bHddUBeFT7e5HLwbGu5rL
	ff5rsU9qy81zsfVxr8139wk+LFNiKc5INNRiLipOBABLIu4kBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 12:00 PM, Chanwoo Choi wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch add I2S (Inter-IC Sound) dt node which supports 1-port stereo
> (1 channels) IIS-bus for audio interface with DMA-based operation.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Tested-by: Inha Song <ideal.song@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes from v1:
> - Fix wrong name of property (pinctrl-names)
> - Change phanle name (i2s->i2s2)
> 
>  arch/arm/boot/dts/exynos3250.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 3e678fa..77a06df 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -425,6 +425,19 @@
>  			status = "disabled";
>  		};
>  
> +		i2s2: i2s@13970000 {
> +			compatible = "samsung,s3c6410-i2s";
> +			reg = <0x13970000 0x100>;
> +			interrupts = <0 126 0>;
> +			clocks = <&cmu CLK_I2S>, <&cmu CLK_SCLK_I2S>;
> +			clock-names = "iis", "i2s_opclk0";
> +			dmas = <&pdma0 14>, <&pdma0 13>;
> +			dma-names = "tx", "rx";
> +			pinctrl-0 = <&i2s2_bus>;
> +			pinctrl-names = "default";
> +			status = "disabled";
> +		};
> +
>  		pwm: pwm@139D0000 {
>  			compatible = "samsung,exynos4210-pwm";
>  			reg = <0x139D0000 0x1000>;
> 

Ping.

Best Regards,
Chanwoo Choi


