Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbaGPE3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:29:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52099 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821AbaGPE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:29:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C5FF8F.8040402@roeck-us.net>
Date: Tue, 15 Jul 2014 21:29:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20140715132946.771def89@canb.auug.org.au>	<53C4BF8E.4010509@roeck-us.net>	<20140715155547.25959587@canb.auug.org.au>	<20140715150801.7f8099b1@recife.lan>	<20140715190807.GA26057@roeck-us.net> <20140716130434.6b09b2e1@canb.auug.org.au>
In-Reply-To: <20140716130434.6b09b2e1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 08:04 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Tue, 15 Jul 2014 12:08:07 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>>>>> Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that was accepted
>>>>> a week or so ago.
>>>>
>>>> That is in the tip tree and includes the fixups to powerpc and arm.  I
>>>> don't merge the tip tree till well after the v4l-dvb tree.  The merge
>>>> in the v4l-dvb tree included only the change to include/linus/sched.h
>>>> and neither parent fo that merge was based on the tip tree ...
>>>>
>>> Stephen,
>>>
>>> Do you know if/when this patch will be merged upstream? It doesn't
>>> seem to be at 2.6.16-rc5. Otherwise, I'll likely cherry-pick it on
>> 	s/2.16/3.16/
>>> my trees, as the lack of this fixup is making hard for me to check
>>> if a media tree patch isn't introducing new warnings.
>>
>> Only queued for 3.17 as far as I can see, and not scheduled for 3.16.
>
> Its in the sched/urgent branch of the tip tree, so hopefully it will go
> to Linus shortly.
>

Excellent, glad to hear that I was wrong. Looking forward to it.

Thanks,
Guenter

