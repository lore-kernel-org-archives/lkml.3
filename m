Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3KLP34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:29:56 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56831 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KLP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:29:54 -0500
Message-ID: <52824971.5060203@linaro.org>
Date: Tue, 12 Nov 2013 16:29:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/7] arm: dt: zynq: Remove 'clock-ranges' from TTC nodes
References: <1383945677-29674-1-git-send-email-soren.brinkmann@xilinx.com> <1383945677-29674-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1383945677-29674-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 10:21 PM, Soren Brinkmann wrote:
> The bindings for the TTC changed in commit 'arm: zynq: Use standard
> timer binding' (e932900a3279b5dbb6d8f43c7b369003620e137c). That change
> removed possible subnodes from this driver rendering the 'clock-ranges'
> property invalid for this node.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm/boot/dts/zynq-7000.dtsi | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index e32b92b949d2..27ebc1ba9671 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -98,7 +98,6 @@
>   			compatible = "cdns,ttc";
>   			clocks = <&clkc 6>;
>   			reg = <0xF8001000 0x1000>;
> -			clock-ranges;
>   		};
>
>   		ttc1: ttc1@f8002000 {
> @@ -107,7 +106,6 @@
>   			compatible = "cdns,ttc";
>   			clocks = <&clkc 6>;
>   			reg = <0xF8002000 0x1000>;
> -			clock-ranges;
>   		};
>   		scutimer: scutimer@f8f00600 {
>   			interrupt-parent = <&intc>;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

