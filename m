Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3FMKV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 06:21:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46271 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab3FMKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 06:21:28 -0400
Message-ID: <51B99D0D.4050603@ti.com>
Date: Thu, 13 Jun 2013 13:21:01 +0300
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
X-Originating-IP: [10.167.145.163]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
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
Hello Mark, Graeme,

Taking in account that:
- there is no hardware to test twl6025, testing is not possible;
- there is no documentation for twl6025, and if there are any changes to 
twl6032 is not known;
- twl6032 is available, and in production, twl6025 is not even found on 
ti.com <http://ti.com>

So, what do you think, can this change be accepted?

// I apologize for sending personal e-mails, not to the mail list
