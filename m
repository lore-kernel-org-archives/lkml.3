Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbaDIU4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:56:46 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35214 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932847AbaDIU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:56:42 -0400
Message-ID: <5345B402.9070904@free-electrons.com>
Date: Wed, 09 Apr 2014 20:56:34 +0000
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org
CC: mark.rutland@arm.com, andrew@lunn.ch, linux-doc@vger.kernel.org,
        thierry.reding@gmail.com, heiko.stuebner@bq.com,
        linux@arm.linux.org.uk, daniel.lezcano@linaro.org,
        florian.vaussard@epfl.ch, sebastian.hesselbarth@gmail.com,
        devicetree@vger.kernel.org, jason@lakedaemon.net, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, rdunlap@infradead.org,
        silvio.fricke@gmail.com, galak@codeaurora.org, olof@lixom.net,
        jic23@kernel.org
Subject: Re: [PATCH 2/4] dt-bindings: add mtk-timer bindings
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <1397072736-10793-3-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1397072736-10793-3-git-send-email-matthias.bgg@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,
On 09/04/2014 19:45, Matthias Brugger wrote:
> Add binding documentation for the General Porpose Timer driver of
> the Mediatek SoCs.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../bindings/timer/mediatek,mtk-timer.txt          |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> 
> diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> new file mode 100644
> index 0000000..db3c836
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> @@ -0,0 +1,19 @@
> +Mediatek MT6598, MT6577 and MT6572 Timers
> +---------------------------------------
> +
> +Required properties:
> +- compatible: Should be "mediatek,mtk6589-timer"
> +- reg: Should contain location and length for timers register.
> +- clock-names : Must include the following entries:
> +  "sysclk" (13 MHz system clock),
> +  "rtcclk" (32 KHz RTC clock).

It would be better to make the clocks mandatory and not their name

Thanks,

Gregory

> +
> +Examples:
> +
> +	timer {
> +		compatible = "mediatek,mtk6589-timer";
> +		reg = <0x10008000 0x80>;
> +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&system_clk>, <&rtc-clk>;
> +		clock-names = "sysclk", "rtcclk";
> +	};
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
