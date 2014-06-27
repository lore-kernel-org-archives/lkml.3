Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaF0Hww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaF0Hwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:52:51 -0400
Message-ID: <53AD22D0.9000403@suse.de>
Date: Fri, 27 Jun 2014 09:52:48 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 12/14] clk: max77802: Add DT binding documentation
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-13-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1403806546-31122-13-git-send-email-javier.martinez@collabora.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2014 20:15, schrieb Javier Martinez Canillas:
> Add Device Tree binding documentation for the clocks
> outputs in the Maxim 77802 Power Management IC.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v4: None
> 
> Changes since v3:
>  - Don't use the same clock driver name in clock-names since it's a consumer
>    concept and most probably will be different. Suggested by Doug Anderson.
> 
> Changes since v2:
>  - Split the DT binding documentation in a separate patch.
> 
>  .../devicetree/bindings/clock/maxim,max77802.txt   | 42 ++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/maxim,max77802.txt b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
> new file mode 100644
> index 0000000..26bc4f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/maxim,max77802.txt
> @@ -0,0 +1,42 @@
> +Binding for Maxim MAX77802 32k clock generator block
> +
> +This is a part of device tree bindings of MAX77802 multi-function device.
> +More information can be found in bindings/mfd/max77802.txt file.
> +
> +The MAX77802 contains two 32.768khz clock outputs that can be controlled
> +(gated/ungated) over I2C.
> +
> +Following properties should be presend in main device node of the MFD chip.

"present"

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
