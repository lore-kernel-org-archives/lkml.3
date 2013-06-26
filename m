Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3FZJFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:05:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:3672 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZJFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:05:40 -0400
Message-ID: <51CAAEDE.7050906@atmel.com>
Date: Wed, 26 Jun 2013 11:05:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "Shen, Voice" <Voice.Shen@atmel.com>, "Wu, Josh" <Josh.wu@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
References: <cover.1372069834.git.nicolas.ferre@atmel.com> <B256D81BAE5131468A838E5D7A243641687DF77C@penmbx01>
In-Reply-To: <B256D81BAE5131468A838E5D7A243641687DF77C@penmbx01>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/2013 03:59, Yang, Wenyou :
> 
> 
>> -----Original Message-----
>> From: Nicolas Ferre [mailto:nicolas.ferre@atmel.com]
>> Sent: 2013Äê6ÔÂ24ÈÕ 18:35
>> To: Jean-Christophe PLAGNIOL-VILLARD; Desroches, Ludovic; Yang, Wenyou;
>> Shen, Voice; Wu, Josh
>> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
>> Nicolas
>> Subject: [PATCH 0/3] ARM: at91/DT: enable SPI for more SoCs
>>
>> This little series is for enabling the support of SPI on at91sam9n12 and
>> sama5d3 families.
>>
>> Nicolas Ferre (3):
>>    ARM: at91/DT: fix SPI compatibility string
>>    ARM: at91/DT: sama5d3: add SPI DMA client infos
>>    ARM: at91/DT: at91sam9n12: add SPI DMA client infos
>>
>>   arch/arm/boot/dts/at91sam9n12.dtsi |  6 ++++++
>>   arch/arm/boot/dts/sama5d3.dtsi     | 10 ++++++++--
>>   2 files changed, 14 insertions(+), 2 deletions(-)
>>
>> --
>> 1.8.2.2
> 
> Tested on sama5d34ek, Linux-next: next-20130624
> 
> Tested by Wenyou Yang <wenyou.yang@atmel.com>

Thanks for having testing: series is stacked on at91-3.11-dt now.

Bye,
-- 
Nicolas Ferre
