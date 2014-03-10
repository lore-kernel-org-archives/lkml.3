Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaCJN0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:26:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:56185 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaCJN0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:26:01 -0400
Message-ID: <531DBD71.8040905@atmel.com>
Date: Mon, 10 Mar 2014 14:26:09 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: at91: at91sam9g45: change at91_adc name
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com> <1394038675-15809-3-git-send-email-alexandre.belloni@free-electrons.com> <5318C98C.1070702@kernel.org>
In-Reply-To: <5318C98C.1070702@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 20:16, Jonathan Cameron :
> On 05/03/14 16:57, Alexandre Belloni wrote:
>> We can't use "at91_adc" to refer to the at91_adc driver anymore as the name is
>> used to match an id_table.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> As stated in previous email, I'll take this along with the fix that 'broke'
> this, if I get an Ack from one of the at91 maintainers.

Jonathan,

It is maybe more clear if I answer here:
- so, yes, you can take the 3 patches yourself (if you do not mind)
- you have, for the whole series::

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks for your help with this issue.

Bye,

>> ---
>>   arch/arm/mach-at91/at91sam9g45_devices.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
>> index cb36fa872d30..88554024eb2d 100644
>> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
>> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
>> @@ -1203,7 +1203,7 @@ static struct resource adc_resources[] = {
>>   };
>>
>>   static struct platform_device at91_adc_device = {
>> -	.name		= "at91_adc",
>> +	.name		= "at91sam9g45-adc",
>>   	.id		= -1,
>>   	.dev		= {
>>   				.platform_data	= &adc_data,
>>
> 
> 


-- 
Nicolas Ferre
