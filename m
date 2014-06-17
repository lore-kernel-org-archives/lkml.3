Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaFQKsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:48:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53316 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaFQKsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:48:15 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A01CE6.4010608@roeck-us.net>
Date: Tue, 17 Jun 2014 03:48:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] hwmon: Driver for TI TMP103 temperature sensor
References: <1402992713-22711-1-git-send-email-hs@denx.de>
In-Reply-To: <1402992713-22711-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 01:11 AM, Heiko Schocher wrote:
> Driver for the TI TMP103.
>
> The TI TMP103 is similar to the TMP102.  It differs from the TMP102
> by having only 8 bit registers.
>
> Signed-off-by: Heiko Schocher <hs@denx.de>
>
[ ... ]
> +#define TMP103_CONF_SD		(TMP103_CONF_M0 | TMP103_CONF_M1)

Hello Heiko,

I thought this needs to be TMP103_CONF_M1, but from the datasheet it looks
like it does not matter if M0 is set if M1 is set as well. Did you test it,
though, to make sure that it works ? I feel slightly uncomfortable with it.

Thanks,
Guenter

