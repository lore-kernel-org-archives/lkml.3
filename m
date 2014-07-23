Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaGWLv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:51:56 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:65438 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798AbaGWLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:51:54 -0400
Message-ID: <53CFA1D4.5060603@gmail.com>
Date: Wed, 23 Jul 2014 19:51:48 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
References: <53C27247.2010300@gmail.com> <20140714081843.GK2081@ulmo> <6A7CA9C8-7BC4-44BA-AE71-63BDADFF9023@gmail.com> <20140714093310.GC9755@ulmo> <8FB3DF93-7766-4B0D-9D6B-001861925A9F@gmail.com>
In-Reply-To: <8FB3DF93-7766-4B0D-9D6B-001861925A9F@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry, after a long discussion, we have to keep current status no
touch -- let individual modules depends on HAS_IOMEM if they need it.

So, this patch is still alive, please help check it, when you have time.

Thanks.

On 07/14/2014 06:00 PM, Chen Gang wrote:
> 
> 在 2014年7月14日，下午5:33，Thierry Reding <thierry.reding@gmail.com> 写道：
> 
>> On Mon, Jul 14, 2014 at 05:14:05PM +0800, Chen Gang wrote:
>>>
>>> 在 2014年7月14日，下午4:18，Thierry Reding <thierry.reding@gmail.com> 写道：
>>>
>>>> On Sun, Jul 13, 2014 at 07:49:27PM +0800, Chen Gang wrote:
>>>>> PWM_CLPS711X needs HAS_IOMEM, so let it depend on HAS_IOMEM.
>>>>>
>>>>> The related error (with allmodconfig under score):
>>>>>
>>>>>   MODPOST 1365 modules
>>>>> ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefined!
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>>>> ---
>>>>> drivers/pwm/Kconfig | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> NAK given the discussion in the other thread.
>>>>
>>>> Thierry
>>>
>>> OK, thanks, and I shall continue focusing the other thread, and send related patch after
>>> get conclusion (hope I can finish within this week).
>>
>> Great, thanks for taking care of this.
>>
> 
> That what I should/will do. I start the related thread, so I have duty to try
> to finish it in time. :-)
> 
> Thanks.
> —
> Chen Gang
> Open, share, and attitude like air, water, and life which God blessed.
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
