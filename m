Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaGBJUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:20:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47699 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaGBJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:20:32 -0400
Message-ID: <53B3CED8.4020808@gmail.com>
Date: Wed, 02 Jul 2014 14:50:24 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
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
Subject: Re: [PATCH v5 14/14] ARM: dts: Add max77802 to exynos5420-peach-pit
 and exynos5800-peach-pi
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-15-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1403806546-31122-15-git-send-email-javier.martinez@collabora.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 11:45 PM, Javier Martinez Canillas wrote:
> Peach pit and pi boards uses a Maxim 77802 power management
> IC to drive regulators and its Real Time Clock. This patch
> adds support for this chip.
> 
> These are the device nodes and pinctrl configuration that
> are present on the Peach pit DeviceTree source file in the
> the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---

[ ... ]

> +
> +		regulators {
> +			buck1_reg: BUCK1 {
> +				regulator-name = "vdd_mif";
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <1300000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-ramp-delay = <12500>;
> +			};

IMO, adding a blank line between sub-nodes would be better.

> +			buck2_reg: BUCK2 {
> +				regulator-name = "vdd_arm_real";
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <1500000>;
> +				regulator-always-on;
> +				regulator-boot-on;
> +				regulator-ramp-delay = <12500>;
> +			};

[ ... ]

> +			vqmmc_sdcard: ldo4_reg: LDO4 {
> +				regulator-name = "vdd_sd";
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <2800000>;
> +				regulator-always-on;
> +

Blank line, can be removed.

> +			};

[ ... ]
> +			ldo23_reg: LDO23 {
> +				regulator-name = "ld0_23";

ldo_23, 'o' in place of '0'.

Similar comments for peach-pi DTS file.

-- 
Tushar Behera
