Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3LZSVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 13:21:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54885 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab3LZSVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 13:21:35 -0500
Message-ID: <52BC7388.3040302@ti.com>
Date: Thu, 26 Dec 2013 13:20:56 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Guenter Roeck <linux@roeck-us.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <nsekhar@ti.com>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/5] Update Davinci watchdog driver
References: <1386185970-14488-1-git-send-email-ivan.khoronzhuk@ti.com> <52A5EF6B.6060700@ti.com> <52ACAED4.7000305@ti.com> <52BC6D76.7000400@ti.com> <20131226181725.GL10136@spo001.leaseweb.com>
In-Reply-To: <20131226181725.GL10136@spo001.leaseweb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 December 2013 01:17 PM, Wim Van Sebroeck wrote:
> Hi Santosh,
> 
>>>> On Wednesday 04 December 2013 02:39 PM, Ivan Khoronzhuk wrote:
>>>>> These patches are intended to update Davinci watchdog to use WDT core
>>>>> and reuse driver for keystone arch, because Keystone uses the similar
>>>>> IP like Davinci.
>>>>>
>>>>
>>>> [..]
>>>>
>>>>> v4..v5:
>>>>> - watchdog: davinci: change driver to use WDT core
>>>>> 	switched off CONFIG_WATCHDOG_NOWAYOUT option
>>>>>
>>>> Can you please apply the series to your watchdog tree ?
>>>> Do let me know if you want us to prepare a git branch
>>>> to pull from.
>>>>
>>> ping..
>>>
>> I haven't heard anything on this yet from you Wim.
>>
>> Guenter,
>> I have seen you actively reviewing the $subject patch series.
>> Will you be able to pick the series up for 3.14 merge window
>> considering almost no response from Wim so far on it ?
> 
> I have review the patches and they will go in my tree tomorrow.

Thanks Wim.

Regards,
Santosh
