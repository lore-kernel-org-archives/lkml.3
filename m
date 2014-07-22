Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaGVOdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:33:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62502 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbaGVOdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:33:01 -0400
Message-ID: <53CE7615.4070001@gmail.com>
Date: Tue, 22 Jul 2014 20:02:53 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Bo Shen <voice.shen@atmel.com>
Subject: Re: [PATCH v4 02/11] mfd: add documentation for atmel-hlcdc DT bindings
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com> <1406034695-15534-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1406034695-15534-3-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 22 July 2014 06:41 PM, Boris BREZILLON wrote:
> The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
> family or sama5d3 family) exposes 2 subdevices:
> - a display controller (controlled by a DRM driver)
> - a PWM chip
>
> This patch adds documentation for atmel-hlcdc DT bindings.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>   .../devicetree/bindings/mfd/atmel-hlcdc.txt        | 50 ++++++++++++++++++++++
>   1 file changed, 50 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
>
> diff --git a/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
> new file mode 100644
> index 0000000..e9cc1b2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
> @@ -0,0 +1,50 @@
> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) MFD driver
> +
> +Required properties:
> + - compatible: value should be one of the following:
> +   "atmel,sama5d3-hlcdc"
> + - reg: base address and size of the HLCDC device registers.
> + - clock-names: the name of the 3 clocks requested by the HLCDC device.
> +   Should contain "periph_clk", "sys_clk" and "slow_clk".
> + - clocks: should contain the 3 clocks requested by the HLCDC device.
> +

These bindings not clearly readable. It would be readable if

Required properties:
  - compatible	: value should be one of the following:"atmel,sama5d3-hlcdc"
  - reg		: base address and size of the HLCDC device registers.
  - clock-names	: the name of the 3 clocks requested by the HLCDC device.
		  Should contain "periph_clk", "sys_clk" and "slow_clk".
  - clocks	: should contain the 3 clocks requested by the HLCDC device.

......


-- 
Regards,
Varka Bhadram

