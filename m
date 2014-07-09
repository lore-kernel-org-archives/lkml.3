Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaGISPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:15:31 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41654 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGISP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:15:28 -0400
Message-ID: <53BD86B9.4000907@collabora.co.uk>
Date: Wed, 09 Jul 2014 20:15:21 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/24] mfd: max77686: Make platform data over-rule
 DT
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk> <1404505467-26526-5-git-send-email-javier.martinez@collabora.co.uk> <20140709145203.GF2635@lee--X1>
In-Reply-To: <20140709145203.GF2635@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 07/09/2014 04:52 PM, Lee Jones wrote:
> On Fri, 04 Jul 2014, Javier Martinez Canillas wrote:
> 
>> The function max77802_i2c_parse_dt_pdata() should only be called
>> if there isn't already platform data for the device.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>  drivers/mfd/max77686.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I assume some of these patches can be applied independently.
>

Yes, some patches can be applied independently and it would be quite helpful
indeed since that will allow me to keep a smaller series :)

> Let me know which ones and I'll apply them.  In the mean time:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 

Patches 1-7 are just cleanups and improvements for max77686 mfd driver so they
can be applied safely. You had already acked 1-6 and 7 is just a trivial patch
so I guess you won't have issues with that one as well.

Patches 11 and 14 are small patches for the max77802 clk driver and Mike already
gave his Reviewed-by tag so if you are going to take the whole set through your
tree those two patches are safe to be applied as well.

Thanks a lot for your help and best regards,
Javier
