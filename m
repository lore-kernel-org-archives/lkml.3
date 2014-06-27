Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaF0JdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:33:07 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33835 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0JdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:33:04 -0400
Message-ID: <53AD3A48.4090307@collabora.co.uk>
Date: Fri, 27 Jun 2014 11:32:56 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
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
Subject: Re: [PATCH v5 02/14] mfd: max77686: Allow the max77686 rtc to wakeup
 the system
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-3-git-send-email-javier.martinez@collabora.co.uk> <20140627092149.GH19645@lee--X1>
In-Reply-To: <20140627092149.GH19645@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 06/27/2014 11:21 AM, Lee Jones wrote:
> On Thu, 26 Jun 2014, Javier Martinez Canillas wrote:
> 
>> From: Doug Anderson <dianders@chromium.org>
>> 
>> The max77686 includes an RTC that keeps power during suspend.  It's
>> convenient to be able to use it as a wakeup source.
>> 
>> NOTE: due to wakeup ordering problems this patch alone doesn't work so
>> well on exynos5250-snow.  You also need something that brings the i2c
>> bus up before the max77686 wakeup runs.
>> 
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>> 
>> Changes since v4: None
>> 
>> Changes since v3:
>>  - Keep the note that this patch needs another change due wakeup
>>    ordering problems.
>> 
>>  drivers/rtc/rtc-max77686.c | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
> 
> This patch doesn't actually touch the MFD subsystem directly.  Can you
> change the $SUBJECT line accordingly please?
> 

You're right, I'll change the $subject.

Best regards,
Javier
