Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaCJKv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:51:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:57049 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaCJKvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:51:55 -0400
Message-ID: <531D9952.5070405@atmel.com>
Date: Mon, 10 Mar 2014 11:52:02 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 0/3] iio: adc: at91 fixes
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com> <531823BB.4080106@atmel.com>
In-Reply-To: <531823BB.4080106@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 08:28, Josh Wu :
> Hi, Alexandre
> 
> On 3/6/2014 12:57 AM, Alexandre Belloni wrote:
>> This series fixes a kernel crash at probe time when using the at91_adc driver
>> through platform_data. This crash appeared in 3.13.
>>
>> The first patch fixes the crash. While it is already quite late, I think it
>> would be good to get it in 3.14.
>>
>> The next patches restore support for at91_adc on the at91sam9g45 and at91sam9260
>> based boards. It would be great if they could make it in 3.14. But I'm not sure
>> it is worth applying them to 3.13.
>>
>> Alexandre Belloni (3):
>>    iio: adc: at91_adc: Repair broken platform_data support
>>    ARM: at91: at91sam9g45: change at91_adc name
>>    ARM: at91: at91sam9260: change at91_adc name
>>
>>   arch/arm/mach-at91/at91sam9260_devices.c |  2 +-
>>   arch/arm/mach-at91/at91sam9g45_devices.c |  2 +-
>>   drivers/iio/adc/at91_adc.c               | 26 ++++++++++++++++++++++----
>>   3 files changed, 24 insertions(+), 6 deletions(-)
>>
> 
> Thank you for the fixes.
> I tested the patch series in at91sam9m10g45ek and works fine.
> 
> so here is my:
> Tested-by: Josh Wu <josh.wu@atmel.com>
> Acked-by: Josh Wu <josh.wu@atmel.com>

Ok, fine with me:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


-- 
Nicolas Ferre
