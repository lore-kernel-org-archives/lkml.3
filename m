Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaCFH3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:29:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:35002 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaCFH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:29:11 -0500
Message-ID: <531823BB.4080106@atmel.com>
Date: Thu, 6 Mar 2014 15:28:59 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 0/3] iio: adc: at91 fixes
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alexandre

On 3/6/2014 12:57 AM, Alexandre Belloni wrote:
> This series fixes a kernel crash at probe time when using the at91_adc driver
> through platform_data. This crash appeared in 3.13.
>
> The first patch fixes the crash. While it is already quite late, I think it
> would be good to get it in 3.14.
>
> The next patches restore support for at91_adc on the at91sam9g45 and at91sam9260
> based boards. It would be great if they could make it in 3.14. But I'm not sure
> it is worth applying them to 3.13.
>
> Alexandre Belloni (3):
>    iio: adc: at91_adc: Repair broken platform_data support
>    ARM: at91: at91sam9g45: change at91_adc name
>    ARM: at91: at91sam9260: change at91_adc name
>
>   arch/arm/mach-at91/at91sam9260_devices.c |  2 +-
>   arch/arm/mach-at91/at91sam9g45_devices.c |  2 +-
>   drivers/iio/adc/at91_adc.c               | 26 ++++++++++++++++++++++----
>   3 files changed, 24 insertions(+), 6 deletions(-)
>

Thank you for the fixes.
I tested the patch series in at91sam9m10g45ek and works fine.

so here is my:
Tested-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Josh Wu <josh.wu@atmel.com>

Best Regards,
Josh Wu
