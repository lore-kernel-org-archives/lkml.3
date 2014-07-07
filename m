Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaGGG5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:57:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39947 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaGGG5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:57:51 -0400
Message-ID: <53BA44E5.6070604@collabora.co.uk>
Date: Mon, 07 Jul 2014 08:57:41 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 23/24] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk> <1404505467-26526-24-git-send-email-javier.martinez@collabora.co.uk> <1404713210.4367.0.camel@AMDC1943>
In-Reply-To: <1404713210.4367.0.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 07/07/2014 08:06 AM, Krzysztof Kozlowski wrote:
> On pią, 2014-07-04 at 22:24 +0200, Javier Martinez Canillas wrote:
>> The MAX7802 PMIC has a Real-Time-Clock (RTC) with two alarms.
>> This patch adds support for the RTC and is based on a driver
>> added by Simon Glass to the Chrome OS kernel 3.8 tree.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>> 
>> Changes since v6:
>>  - Remove unused code for SMPL and WTSR. Suggested by Krzysztof Kozlowski.
>>  - Don't spam the kernel log with unimportant info and just print for debug.
>>    Suggested by Krzysztof Kozlowski.
>>  - Use ARRAY_SIZE() instead of constant value. Suggested by Krzysztof Kozlowski.
>>  - Remove duplicated register setup. Suggested by Krzysztof Kozlowski.
>>  - Don't free/unregister managed allocated resources.
>>    Suggested by Krzysztof Kozlowski.
>> ---
>>  drivers/rtc/Kconfig        |  10 +
>>  drivers/rtc/Makefile       |   1 +
>>  drivers/rtc/rtc-max77802.c | 508 +++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 519 insertions(+)
>>  create mode 100644 drivers/rtc/rtc-max77802.c
> 
> 
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 

Thanks a lot for the review and for all the feedback you gave me on each version
of the series.

> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
