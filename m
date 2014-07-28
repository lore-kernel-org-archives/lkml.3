Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaG1J3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 05:29:20 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57419 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaG1J3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 05:29:14 -0400
Message-ID: <53D617E2.3070803@collabora.co.uk>
Date: Mon, 28 Jul 2014 11:29:06 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/13] Add Maxim 77802 PMIC support
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk> <20140725223140.4791.61816@quantum>
In-Reply-To: <20140725223140.4791.61816@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 07/26/2014 12:31 AM, Mike Turquette wrote:
> Quoting Javier Martinez Canillas (2014-07-14 04:35:56)
>> This series are based on drivers added by Simon Glass to the Chrome OS
>> kernel and adds support for the Maxim 77802 Power Management IC, their
>> regulators, clocks, RTC and i2c interface.
>> 
>> This is a v8 of the patch-set that addresses issues pointed out in v7.
>> Individual changes are added on each patch but the biggest changes are:
>> 
>> * Patches 1-7 from v7 are not included since those were improvements to
>> the max77686 mfd driver and can be applied independently. Lee Jones said
>> that he is going to pick them from the posted v7 series.
>> 
>> I've created a patchwork bundle with 1-7 from v7 to make it easy to apply:
>> 
>> https://patchwork.kernel.org/bundle/javier/max77686-improvements/
>> 
>> * The Dynamic Voltage Scaling support has been removed since that can be
>> added in a follow up series and shouldn't block the minimum PMIC support.
>> 
>> The patch-set has been tested on both Daisy/Snow (max77686) and Peach
>> Pit (max77802) Chromebooks and it's composed of the following patches:
>> 
>> [PATCH v8 01/13] mfd: max77686: Add Maxim 77802 PMIC support
>> [PATCH v8 02/13] mfd: max77802: Add DT binding documentation
>> [PATCH v8 03/13] regulator: Add driver for Maxim 77802 PMIC regulators
>> [PATCH v8 04/13] clk: max77686: Add DT include for MAX77686 PMIC clock
>> [PATCH v8 05/13] clk: Add generic driver for Maxim PMIC clocks
>> [PATCH v8 06/13] clk: max77686: Convert to the generic max clock driver
>> [PATCH v8 07/13] clk: max77686: Improve Maxim 77686 PMIC clocks binding
>> [PATCH v8 08/13] clk: Add driver for Maxim 77802 PMIC clocks
>> [PATCH v8 09/13] clk: max77802: Add DT binding documentation
> 
> For patches 4-9:
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>
> 

Thanks a lot for your ack!

Since the merge window is just around the corner, Lee merged the mfd max77686
headers changes to split the dependencies around kernel releases.

So after the merge windows, I'll resend the clock driver (and the other drivers
fwiw) as a separate series so you can merge it through your tree for 3.18.

> Regards,
> Mike
> 

Best regards,
Javier
