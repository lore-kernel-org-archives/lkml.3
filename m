Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaBRX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:58:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47622 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaBRX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:58:56 -0500
Message-ID: <5303F3B5.6050806@ti.com>
Date: Wed, 19 Feb 2014 08:58:45 +0900
From: Milo Kim <milo.kim@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 01/10] mfd: Add TI LMU driver
References: <1392359450-6890-1-git-send-email-milo.kim@ti.com> <20140217095734.GD17875@lee--X1> <53030F9C.8000605@ti.com> <20140218082127.GD20218@lee--X1>
In-Reply-To: <20140218082127.GD20218@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 02/18/2014 05:21 PM, Lee Jones wrote:
>>>> +	pdata->en_gpio = of_get_named_gpio(node, "ti,enable-gpio", 0);
>>>
>>> There is a global DT property for this already.
>>
>> I've not found it yet, but I agree it looks like general property.
>> So I'll replace "ti,enable-gpio" with "ti,lmu-en-gpio".
>
> Just re-use "gpio-enable". No need for it to be vendor specific.
>

Got it. Thanks!

This GPIO is used for enabling the device. So, "enable-gpio" is more 
appropriate name, isn't it?

Best regards,
Milo
