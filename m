Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3JWOzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:55:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49336 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3JWOzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:55:14 -0400
Message-ID: <5267F18C.2020107@kernel.org>
Date: Wed, 23 Oct 2013 16:55:56 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>, Randy Dunlap <rdunlap@infradead.org>
CC: Jim Davis <jim.epost@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH -next] staging/iio/adc: MXS_LRADC depends on INPUT
References: <CA+r1Zhjo08EEoHsWkeDDKoc8Le6eDq4fZxZaa1Jc8cfOLsLsMg@mail.gmail.com> <526603EB.3060504@infradead.org> <201310220651.03499.marex@denx.de>
In-Reply-To: <201310220651.03499.marex@denx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 05:51, Marek Vasut wrote:
> Dear Randy Dunlap,
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> mxs-lradc.c uses many input_() functions so it should
>> depend on INPUT to fix build errors.
>>
>> drivers/built-in.o: In function `mxs_lradc_ts_unregister':
>> drivers/staging/iio/adc/mxs-lradc.c:905: undefined reference to
>> `input_unregister_device' drivers/staging/iio/adc/mxs-lradc.c:905:
>> undefined reference to `input_unregister_device' drivers/built-in.o: In
>> function `input_report_abs':
>> include/linux/input.h:399: undefined reference to `input_event'
>> include/linux/input.h:399: undefined reference to `input_event'
>> include/linux/input.h:399: undefined reference to `input_event'
>> drivers/built-in.o: In function `input_report_key':
>> include/linux/input.h:389: undefined reference to `input_event'
>> drivers/built-in.o: In function `input_sync':
>> include/linux/input.h:414: undefined reference to `input_event'
>> drivers/built-in.o:include/linux/input.h:389: more undefined references to
>> `input_event' follow
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Acked-by: Marek Vasut <marex@denx.de>
> 
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> Thanks!
> 
> Best regards,
> Marek Vasut
> 
