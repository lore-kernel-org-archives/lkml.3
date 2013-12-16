Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3LPKVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:21:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60932 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3LPKVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:21:05 -0500
Message-ID: <52AEE177.1090802@ti.com>
Date: Mon, 16 Dec 2013 13:18:15 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/2] gpio: davinci: reuse for keystone arch
References: <1386871973-26762-1-git-send-email-grygorii.strashko@ti.com>	<52ACAD50.6060003@ti.com>	<52ADB3BC.3080605@ti.com> <52ADB47E.1080505@ti.com>
In-Reply-To: <52ADB47E.1080505@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 03:54 PM, Sekhar Nori wrote:
> On Sunday 15 December 2013 07:20 PM, Sekhar Nori wrote:
>> On Sunday 15 December 2013 12:41 AM, Santosh Shilimkar wrote:
>>> Linus, Sekhar,
>>>
>>> On Thursday 12 December 2013 01:12 PM, Grygorii Strashko wrote:
>>>> This series is intended to update Davinci GPIO driver and reuse
>>>> it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
>>>> Keystone GPIO IP: supports:
>>>> - up to 32 GPIO lines;
>>>> - only unbanked irqs;
>>>>
>>>> See Documentation:
>>>> Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>>>>
>>>> This series depends on:
>>>> [1] "[PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio"
>>>> https://lkml.org/lkml/2013/11/8/22
>>>> [2] "[PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement"
>>>> https://www.mail-archive.com/devicetree@vger.kernel.org/msg05970.html
>>>> [3] "gpio: davinci: get rid of DAVINCI_N_GPIO"
>>>> https://lkml.org/lkml/2013/11/26/405
>>>> [4] "gpio: introduce GPIO_DAVINCI kconfig option"
>>>> https://lkml.org/lkml/2013/11/26/435
>>>> [5] "gpio: davinci: use chained_irq_enter/chained_irq_exit API"
>>>> https://lkml.org/lkml/2013/11/26/428
>>>>
>>>> To handle all dependencies, I've created a branch where I collected all
>>>> "ready to merge" patches (all acks added in patches) and this series:
>>>> - https://github.com/grygoriyS/linux.git
>>>> - branch: keystone-master-gpio-for-next
>>>>
>>> Can one of you pull all these patches ?
>>
>> So I went through my backlog and queued all that I think is ready. Here
>> is the branch. Let me know if there is anything else missing.

Looks like everything are in place. Thanks.

>
> Forgot to mention that I have not been able to test them today though.
> They will hit linux-next only after I have been able to test them and I
> send a pull request to arm-soc or Linus W.
>

Regards,
-grygorii

