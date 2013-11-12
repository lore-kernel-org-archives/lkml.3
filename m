Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3KLIm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:42:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53839 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab3KLIm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:42:57 -0500
Message-ID: <5281E950.5090506@ti.com>
Date: Tue, 12 Nov 2013 10:39:44 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/2] DaVinci: GPIO: fixes
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com> <5280FB19.4020204@ti.com> <5281C839.8070100@ti.com>
In-Reply-To: <5281C839.8070100@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On 11/12/2013 08:18 AM, Sekhar Nori wrote:
> On Monday 11 November 2013 09:13 PM, Grygorii Strashko wrote:
>> Hi Sekhar, Prabhakar Lad
>>
>> On 11/08/2013 08:45 AM, Prabhakar Lad wrote:> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>
>>> This patch series fixes gpio driver regestration
>>> and offset check for unbanked gpio.
>>>
>>> Lad, Prabhakar (2):
>>>     gpio: davinci: Fix a check for unbanked gpio
>>>     ARM: davinci: Fix number of resources passed to
>>>       davinci_gpio_register() call
>>
>> I've verified both patches - looks ok.
>> Patch 1 - restores unbanked GPIO IRQs functionality
>> Patch 2 - allows to register GPIO Platform devices and boot without issues.
>>
>> Could we move forward with these patches?
> 
> Prabhakar, both patches look good to me. Thanks for the fixes.
> 
> Also Grygorii, have you actually verified that the unbanked IRQ support
> works? Only DM365 uses it.

Yes, I've verified it, but on Keystone which has similar GPIO IP
which supports only unbanked IRQs.

> 
> What do I add for you? Tested-by: or Acked-by:

Reported-and-Reviewed-and-Tested-by: Grygorii Strashko <grygorii.strashko@ti.com> :P
^Up to you :), but if I understand things right "Acked-by:" included all above

Regards,
- grygorii
