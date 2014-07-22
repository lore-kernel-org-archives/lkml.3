Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaGVOgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:36:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34068 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaGVOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:36:19 -0400
Message-ID: <53CE76DB.7030902@gmail.com>
Date: Tue, 22 Jul 2014 20:06:11 +0530
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
Subject: Re: [PATCH v4 04/11] pwm: add DT bindings documentation for atmel-hlcdc-pwm
 driver
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com> <1406034695-15534-5-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1406034695-15534-5-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 22 July 2014 06:41 PM, Boris BREZILLON wrote:
> The HLCDC IP available in some Atmel SoCs (i.e. sam9x5i.e. at91sam9n12,
> at91sam9x5 family or sama5d3 family) provide a PWM device.
>
> The DT bindings used for this PWM device is following the default 3 cells
> bindings described in Documentation/devicetree/bindings/pwm/pwm.txt.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>   .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    | 55 ++++++++++++++++++++++
>   1 file changed, 55 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
>
> diff --git a/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> new file mode 100644
> index 0000000..86ad3e2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
> @@ -0,0 +1,55 @@
> +Device-Tree bindings for Atmel's HLCDC (High LCD Controller) PWM driver
> +
> +The Atmel HLCDC PWM is subdevice of the HLCDC MFD device.
> +See ../mfd/atmel-hlcdc.txt for more details.
> +
> +Required properties:
> + - compatible: value should be one of the following:
> +   "atmel,hlcdc-pwm"
> + - pinctr-names: the pin control state names. Should contain "default".
> + - pinctrl-0: should contain the pinctrl states described by pinctrl
> +   default.
> + - #pwm-cells: should be set to 3. This PWM chip use the default 3 cells
> +   bindings defined in Documentation/devicetree/bindings/pwm/pwm.txt.
> +   The first cell encodes the PWM id (0 is the only acceptable value here,
> +   because the chip only provide one PWM).
> +   The second cell encodes the PWM period in nanoseconds.
> +   The third cell encodes the PWM flags (the only supported flag is
> +   PWM_POLARITY_INVERTED)

It will be readable if:
Required properties:
  - compatible	: value should be one of the following: "atmel,hlcdc-pwm"
  - pinctr-names	: the pin control state names. Should contain "default".
  - pinctrl-0	: should contain the pinctrl states described by pinctrl default.
  - #pwm-cells	: should be set to 3. This PWM chip use the default 3 cells
		  bindings defined in Documentation/devicetree/bindings/pwm/pwm.txt.
		  The first cell encodes the PWM id (0 is the only acceptable value here,
		  because the chip only provide one PWM).
		  The second cell encodes the PWM period in nanoseconds.
		  The third cell encodes the PWM flags (the only supported flag is
		  PWM_POLARITY_INVERTED)
....


-- 
Regards,
Varka Bhadram

