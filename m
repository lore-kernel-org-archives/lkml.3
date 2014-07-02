Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaGBKSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:18:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36795 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaGBKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:18:04 -0400
Message-ID: <53B3DC52.7040803@collabora.co.uk>
Date: Wed, 02 Jul 2014 12:17:54 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
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
Subject: Re: [PATCH v5 04/14] clk: max77686: Improve Maxim 77686 PMIC clocks
 binding
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-5-git-send-email-javier.martinez@collabora.co.uk> <20140701172959.32686.9863@quantum>
In-Reply-To: <20140701172959.32686.9863@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 07/01/2014 07:29 PM, Mike Turquette wrote:
> Quoting Javier Martinez Canillas (2014-06-26 11:15:36)
>> Like most clock drivers, the Maxim 77686 PMIC clock binding
>> follows the convention that the "#clock-cells" property is
>> used to specify the number of cells in a clock provider.
>> 
>> But the binding document is not clear enough that it shall
>> be set to 1 since the PMIC support multiple clocks outputs.
>> 
>> Also, explain that the clocks identifiers are defined in a
>> header file that can be included by Device Tree source with
>> client nodes to avoid using magic numbers.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
> 
> Looks good to me.
> 
> Regards,
> Mike
> 

Thanks a lot, an Acked-by or Reviewed-by tags for this patch and 03/14 will be
great as well so I can carry those on the next version of the series.

Best regards,
Javier

