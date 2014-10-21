Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaJUOuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:50:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:54277 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbaJUOuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:50:20 -0400
Message-ID: <544672A6.9090101@atmel.com>
Date: Tue, 21 Oct 2014 16:50:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "arm@kernel.org" <arm@kernel.org>
CC: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] MAINTAINERS: add atmel ssc driver maintainer entry
References: <1411869439-2719-1-git-send-email-voice.shen@atmel.com> <54291A0C.3090206@atmel.com>
In-Reply-To: <54291A0C.3090206@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/2014 10:36, Nicolas Ferre :
> On 28/09/2014 03:57, Bo Shen :
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> 
> Sure:
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Thanks.

Greg or Arnd,

This MAINTAINER's update didn't make it during merge window (on the
other hand, I didn't build a pull-request with it neither...).

Do you want that I take it in one of my "fixes" pull-requests to arm-soc
for 3.18 or do you feel like taking the patch directly? I think it makes
sense to not wait for the 3.19 for this kind of useful information.

Thanks, bye,


>> ---
>>
>>  MAINTAINERS | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3705430..c004e6f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1703,6 +1703,13 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>>  S:	Supported
>>  F:	drivers/spi/spi-atmel.*
>>  
>> +ATMEL SSC DRIVER
>> +M:	Bo Shen <voice.shen@atmel.com>
>> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>> +S:	Supported
>> +F:	drivers/misc/atmel-ssc.c
>> +F:	include/linux/atmel-ssc.h
>> +
>>  ATMEL Timer Counter (TC) AND CLOCKSOURCE DRIVERS
>>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>
> 
> 


-- 
Nicolas Ferre
