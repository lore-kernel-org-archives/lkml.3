Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaJVXru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:47:50 -0400
Received: from mout.gmx.net ([212.227.17.22]:52000 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbaJVXrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:47:49 -0400
Message-ID: <54484219.5000708@gmx.de>
Date: Thu, 23 Oct 2014 01:47:37 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Brian Vandre <bvandre@gmail.com>
CC: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
References: <cover.1413858979.git.bvandre@gmail.com> <cover.1413931615.git.bvandre@gmail.com> <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com> <20141022042115.GA2530@sudip-PC>
In-Reply-To: <20141022042115.GA2530@sudip-PC>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:80CAnsV5dQHAX78zR5frZ/k0cMHMTR5AxVxIRpjU2T4rgsuBuI5
 nY2Nv3xanbDmu9GrBMHtSJzLaE6SJAcDlPFcqUlCemrXYPrk9YKTXNT6xZKg/8F011cbnOp
 OcgeeDsoLZCxUor0u0NK5zySxWYm5ovdTbFQQjhhieHAuiwQcuVqSiYCrvPDC4tqETY3EbQ
 hxVKlwEPb6X9DcR6MTj/Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sudip Mukherjee schrieb am 22.10.2014 06:21:
> On Tue, Oct 21, 2014 at 05:56:47PM -0500, Brian Vandre wrote:
>> This fixes the 2 checkpatch.pl warnings:
>> WARNING: line over 80 characters
>>
> please check your patch with --strict option of checkpatch.pl , and you will get :
> "Alignment should match open parenthesis" .
> 
Good point, but what solution would you propose?
> thanks
> sudip
> 
>> Signed-off-by: Brian Vandre <bvandre@gmail.com>
>> ---
>>  drivers/staging/iio/adc/mxs-lradc.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
>> index 32a1926..62449a6 100644
>> --- a/drivers/staging/iio/adc/mxs-lradc.c
>> +++ b/drivers/staging/iio/adc/mxs-lradc.c
>> @@ -455,7 +455,8 @@ static void mxs_lradc_setup_ts_channel(struct mxs_lradc *lradc, unsigned ch)
>>  	 * SoC's delay unit and start the conversion later
>>  	 * and automatically.
>>  	 */
>> -	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>> +	mxs_lradc_reg_wrt(lradc,
>> +		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>>  		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
>>  		LRADC_DELAY_KICK |
>>  		LRADC_DELAY_DELAY(lradc->settling_delay),
>> @@ -513,7 +514,8 @@ static void mxs_lradc_setup_ts_pressure(struct mxs_lradc *lradc, unsigned ch1,
>>  	 * SoC's delay unit and start the conversion later
>>  	 * and automatically.
>>  	 */
>> -	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>> +	mxs_lradc_reg_wrt(lradc,
>> +		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>>  		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
>>  		LRADC_DELAY_KICK |
>>  		LRADC_DELAY_DELAY(lradc->settling_delay), LRADC_DELAY(2));
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

