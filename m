Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbaICNtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:49:55 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59579 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbaICNtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:49:52 -0400
Message-ID: <54071C7B.4090805@linaro.org>
Date: Wed, 03 Sep 2014 15:49:47 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 3/9] ARM: zynq: DT: Add DDRC node
References: <1409692754-13437-1-git-send-email-soren.brinkmann@xilinx.com> <1409692754-13437-4-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1409692754-13437-4-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 11:19 PM, Soren Brinkmann wrote:
> Add the DDR controller to the Zynq devicetree.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm/boot/dts/zynq-7000.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 6cc83d4c6c76..587cadcf7001 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -146,6 +146,11 @@
>   			cache-level = <2>;
>   		};
>
> +		memory-controller@f8006000 {
> +			compatible = "xlnx,zynq-ddrc-a05";
> +			reg = <0xf8006000 0x1000>;
> +		} ;
> +
>   		uart0: serial@e0000000 {
>   			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
>   			status = "disabled";
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

