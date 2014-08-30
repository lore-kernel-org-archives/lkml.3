Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaH3JsH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 05:48:07 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60511 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3JsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 05:48:04 -0400
Message-ID: <54019DD2.30509@kernel.org>
Date: Sat, 30 Aug 2014 10:48:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Josh Wu <josh.wu@atmel.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        maxime.ripard@free-electrons.com
CC: alexandre.belloni@free-electrons.com
Subject: Re: [PATCH] iio: adc: at91: make the function handle_adc_eoc_trigger()
 static
References: <1409128271-14856-1-git-send-email-josh.wu@atmel.com> <53FD987B.50601@atmel.com>
In-Reply-To: <53FD987B.50601@atmel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 09:36, Nicolas Ferre wrote:
> On 27/08/2014 10:31, Josh Wu :
>> The handle_adc_eoc_trigger() in only used in at91_adc.c. So make it
>> static.
>>
>> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> 
> Absolutely.
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> Thanks, bye.
> 
>> ---
>>  drivers/iio/adc/at91_adc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
>> index 772e869..7807e0e 100644
>> --- a/drivers/iio/adc/at91_adc.c
>> +++ b/drivers/iio/adc/at91_adc.c
>> @@ -266,7 +266,7 @@ static irqreturn_t at91_adc_trigger_handler(int irq, void *p)
>>  }
>>  
>>  /* Handler for classic adc channel eoc trigger */
>> -void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
>> +static void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
>>  {
>>  	struct at91_adc_state *st = iio_priv(idev);
>>  
>>
> 
> 
