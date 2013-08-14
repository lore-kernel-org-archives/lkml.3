Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3HNEnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 00:43:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34909 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3HNEnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 00:43:17 -0400
Message-ID: <520B0AB7.1070700@ti.com>
Date: Wed, 14 Aug 2013 10:12:31 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Philip Avinash <avinashphilipk@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] GPIO DT support for da850
References: <1371203020-15092-1-git-send-email-avinashphilip@ti.com> <518397C60809E147AF5323E0420B992E3EADAFCF@DBDE04.ent.ti.com> <CA+V-a8sNPMbQjh8uxhQ=aOgo4ZfmaKXoOnRsuurzEeWzBKW8WA@mail.gmail.com>
In-Reply-To: <CA+V-a8sNPMbQjh8uxhQ=aOgo4ZfmaKXoOnRsuurzEeWzBKW8WA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 8/11/2013 3:04 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Fri, Jun 14, 2013 at 3:50 PM, Philip, Avinash <avinashphilip@ti.com> wrote:
>> On Fri, Jun 14, 2013 at 15:13:36, Philip, Avinash wrote:
>>> With conversion of GPIO davinci driver to platform driver, gpio-davinci driver
>>> can support DT boot.
>>> This patch series
>>> - adds dt binding support for gpio-davinci.
>>> - da850 dt support goio.
>>>
>>> This patch series is based on Linux 3.10-rc4 and is availabel at [1].
>>>
>>> 1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4
>>
>>
>> This patch series has dependency on [PATCH v2 0/7] Convert GPIO Davinci to platform driver
>>
>> https://lkml.org/lkml/2013/6/14/120
>>
> What is the status of this patch series is any one taking care of it or
> else I can take care of review comments and repost them.

Avinash is not working for TI anymore. It will be great if you can take
this up.

Thanks,
Sekhar
