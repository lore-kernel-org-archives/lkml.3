Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3FMH4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:56:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38717 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932610Ab3FMH4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:56:45 -0400
Message-ID: <51B97B2B.6080400@ti.com>
Date: Thu, 13 Jun 2013 10:56:27 +0300
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <gg@slimlogic.co.uk>
CC: Mark Brown <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <sameo@linux.intel.com>,
        <lgirdwood@gmail.com>, <balbi@ti.com>, <peter.ujfalusi@ti.com>,
        <t-kristo@ti.com>, <tony@atomide.com>
Subject: Re: [RFC v1] MFD: Change TWL6025 references to TWL6032
References: <1370602390-12306-1-git-send-email-oleksandr.kozaruk@ti.com> <20130607143649.GS31367@sirena.org.uk> <c73c260b90be6e1640a430e8cbba6cac@slimlogic.co.uk>
In-Reply-To: <c73c260b90be6e1640a430e8cbba6cac@slimlogic.co.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 05:44 PM, gg@slimlogic.co.uk wrote:
> On 2013-06-07 15:36, Mark Brown wrote:
>> On Fri, Jun 07, 2013 at 01:53:10PM +0300, Oleksandr Kozaruk wrote:
>>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>>
>>> The TWL6025 was never released beyond sample form and was replaced by
>>> the PhoenixLite range of chips - TWL6032. Change the references to
>>> reference the TWL6032 class and name the registers to twl6032 in 
>>> line with
>>> an actual released chip name to avoid confusion.
>>>
>>> Currently there is no users of TWL6025 in the code.
>>
>> Given that the chip exists even if not widely distributed it seems as
>> well to keep the twl6025 references in there at least in the device ID
>> table - it won't do any harm to people using the twl6032 name and might
>> help someone who happens to pick up an old board for whatever reason.
>
> I do not think any "old boards" exist, it really was a limited run!
>
> Graeme
>
Hello Mark, Graeme

So, what is your opinion? Could we move forward with this?

In addition, If twl6032 will be added on top of twl6025 there will be no 
guarantee
that twl6025 will work because:
- there is no HW to verify
- there is no documentation on twl6025 available, so, in case if current 
implementation is
   different from what is needed for twl6032 - it can't be handled properly
