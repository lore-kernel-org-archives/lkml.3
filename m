Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaIZRI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:08:56 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:53803 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaIZRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:08:54 -0400
X-ME-Helo: beldin
X-ME-Date: Fri, 26 Sep 2014 19:08:53 +0200
X-ME-IP: 90.16.208.226
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 4/4] arm: pxa: add non device-tree timer link to clocksource
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr>
	<1405356724-32207-4-git-send-email-robert.jarzmik@free.fr>
	<53CD25A4.7030606@linaro.org> <87oawivarv.fsf@free.fr>
	<54251B27.909@linaro.org>
X-URL: http://belgarath.falguerolles.org/
Date: Fri, 26 Sep 2014 19:08:45 +0200
In-Reply-To: <54251B27.909@linaro.org> (Daniel Lezcano's message of "Fri, 26
	Sep 2014 09:52:07 +0200")
Message-ID: <87lhp6paw2.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

> On 07/21/2014 08:15 PM, Robert Jarzmik wrote:
>> Daniel Lezcano <daniel.lezcano@linaro.org> writes:
>>
>>> On 07/14/2014 06:52 PM, Robert Jarzmik wrote:
>>>> As clocksource pxa_timer was moved to clocksource framework, the
>>>> pxa_timer initialization needs to be a bit amended, to pass the
>>>> necessary informations to clocksource, ie :
>>>>    - the timer interrupt (mach specific)
>>>>    - the timer registers base (ditto)
>>>>    - the timer clockrate
>>>>
>>>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>>>>
>>>> ---
>>>> Since V2: Arnd's comment : moved extern declaration into .h file
>>>> ---
>>>

> Hi,
>
> May be I missed it but I don't see the Haojian's ack.
>
> Thanks
>   -- Daniel

You're right, I scanned through my mail and didn't find the ack.
Haojian, would you review this one please ?

It's here :
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/272311.html

Cheers.

-- 
Robert
