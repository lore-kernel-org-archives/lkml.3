Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaIPXmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:42:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:55648 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaIPXl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:41:59 -0400
Message-ID: <5418CAC1.7080407@infradead.org>
Date: Tue, 16 Sep 2014 16:41:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: myungjoo.ham@samsung.com, Jean Delvare <jdelvare@suse.de>,
        =?EUC-KR?B?w9bC+b/s?= <cw00.choi@samsung.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] extcon: sm5502: Depend on I2C
References: <6256746.443221410910747510.JavaMail.weblogic@epml01>
In-Reply-To: <6256746.443221410910747510.JavaMail.weblogic@epml01>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/14 16:39, MyungJoo Ham wrote:
>> The SM5502 chip is an I2C device so its drivers must depend on I2C.
>> Failing to do so results in build failures on kernels where I2C is
>> not enabled.
>>
>> Signed-off-by: Jean Delvare <jdelvare@suse.de>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Geert sent this same patch.  I sent this same patch.
What happened to those patches?


> 
>> ---
>>  drivers/extcon/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- a/drivers/extcon/Kconfig
>> +++ b/drivers/extcon/Kconfig
>> @@ -72,6 +72,7 @@ config EXTCON_PALMAS
>>  
>>  config EXTCON_SM5502
>>  	tristate "SM5502 EXTCON support"
>> +	depends on I2C
>>  	select IRQ_DOMAIN
>>  	select REGMAP_I2C
>>  	select REGMAP_IRQ
>>
>> -- 
>> Jean Delvare
>> SUSE L3 Support


-- 
~Randy
