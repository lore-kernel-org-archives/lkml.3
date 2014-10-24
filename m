Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaJXKc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:32:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18749 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:32:23 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-56-544a2ab4b1c5
Message-id: <544A2AA5.3020407@samsung.com>
Date: Fri, 24 Oct 2014 12:32:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
        arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        geunsik.lim@samsung.com, jh80.chung@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com, yj44.cho@samsung.com
Subject: Re: [PATCH 3/5] clk: samsung: Document binding for Exynos4415 clock
 controller
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
 <1413775935-17743-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1413775935-17743-3-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xq7pbtLxCDG43GVn8nXSM3WLSugNM
	Fte/PGe1+DOhlc1i19/7jBaT7k9gsdjRcITV4savNlaL3gVX2SzONr1ht5jyZzmTxabH11gt
	Lu+aw2Yx4/w+Jovbl3ktll6/yGTxdMJFNotT1z8DxSe/ZLM4NmMJo8WqXX8YLfbunMzoIOax
	Zt4aRo+W5h42j9+/JjF6/F31gtlj56y77B53ru1h89i8pN7jyokmVo++LasYPT5vkgvgiuKy
	SUnNySxLLdK3S+DK6Nl9ga3grUzFpstTGRsYj4l3MXJySAiYSGw70c4CYYtJXLi3nq2LkYtD
	SGApo8T2pZ/ZIZxPjBLnd59gB6niFdCSOLy7jQ3EZhFQlfh9/S9YN5uAoUTv0T5GEFtUIELi
	5N09UPWCEj8m3wOrERHQkJj59wpYDbPAVBaJv+9MQGxhgUiJHd++s0Isa2SUePu6ixkkwSng
	JrHyaCPQMg6gBj2J+xe1IHrlJTavecs8gVFgFpIVsxCqZiGpWsDIvIpRNLU0uaA4KT3XSK84
	Mbe4NC9dLzk/dxMjJFK/7mBceszqEKMAB6MSD++PLZ4hQqyJZcWVuYcYJTiYlUR4X6p5hQjx
	piRWVqUW5ccXleakFh9iZOLglGpgXJASyTlvxzdjXe2qOf80LgbaWyuc0/Zk6rBOV378cvUV
	OS410UpNZj4Xy1WmlUL33ug751YtFY5W/T75TNK5pH7lXIHHYvoup38z7/19snV+96Sse3Wb
	H73JNOl8+Zun7c7JP+/2KIQZ+P9cONWsUl1a484Ny+Prko0M05jmPi61/nzlUM8VJZbijERD
	Leai4kQAm73SzbICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/14 05:32, Chanwoo Choi wrote:
> The Exynos4415 clocks are statically listed and registered using the
> Samsung specific common clock helper functions. Both device tree based
> clock lookup and clkdev based clock lookups are supported.

I think the above text is not relevant, DT binding is not supposed
to depend on any OS. Instead I would just put here something like:

"This patch adds DT binding documentation for Exynos4415 SoC system
clock controllers."

> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos4415-clock.txt | 49 ++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/exynos4415-clock.txt b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
> new file mode 100644
> index 0000000..8aa4f4f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
> @@ -0,0 +1,49 @@
> +* Samsung Exynos4415 Clock Controller
> +
> +The Exynos4415 clock controller generates and supplies clock to various
> +controllers within the Exynos4415 SoC.

s/controllers/consumer devices/ ?

> +
> +Required Properties:

s/P/p/ ?

> +
> +- compatible: should be one of the following.

s/./:/ ?

> +  - "samsung,exynos4415-cmu" - controller compatible with Exynos4415 SoC.

>From current description it seems "samsung,exynos4415-cmu-dmc" is compatible
with "samsung,exynos4415-cmu", which is not the case AFAIK.
Perhaps we should change description here to something along the lines of:

- "samsung,exynos4415-cmu" - for the main system clocks controller
  (CMU_LEFTBUS, CMU_RIGHTBUS, CMU_TOP, CMU_CPU clock domains),

> +  - "samsung,exynos4415-cmu-dmc" - controller compatible with
> +    Exynos4415 SoC for Dynamic Memory Controller domain.

This seems unclear, how about

 - "samsung,exynos4415-cmu-dmc" - for the Exynos4415 SoC DRAM Memory
    Controller (DMC) domain clock controller.

?
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +
> +- #clock-cells: should be 1.
> +
> +Each clock is assigned an identifier and client nodes can use this identifier
> +to specify the clock which they consume.
> +
> +All available clocks are defined as preprocessor macros in
> +dt-bindings/clock/exynos4415.h header and can be used in device
> +tree sources.

> +Example 1: An example of a clock controller node is listed below.
> +
> +	cmu: clock-controller@10030000 {
> +		compatible = "samsung,exynos4415-cmu";
> +		reg = <0x10030000 0x18000>;
> +		#clock-cells = <1>;
> +	};
> +
> +	cmu-dmc: clock-controller@105C0000 {
> +		compatible = "samsung,exynos4415-cmu-dmc";
> +		reg = <0x105C0000 0x3000>;
> +		#clock-cells = <1>;
> +	};
> +
> +Example 2: UART controller node that consumes the clock generated by the clock
> +	   controller. Refer to the standard clock bindings for information
> +	   about 'clocks' and 'clock-names' property.
> +
> +	serial_0: serial@13800000 {
> +		compatible = "samsung,exynos4210-uart";
> +		reg = <0x13800000 0x100>;
> +		interrupts = <0 109 0>;
> +		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
> +		clock-names = "uart", "clk_uart_baud0";
> +	};

I think we could omit those example snippets, it's all generic stuff and
there is already plenty examples in descriptions of the DT binding for
other SoCs.

--
Regards,
Sylwester
