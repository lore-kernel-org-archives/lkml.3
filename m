Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbaGUSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:15:28 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:29776 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbaGUSP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:15:26 -0400
X-ME-Helo: beldin
X-ME-Date: Mon, 21 Jul 2014 20:15:25 +0200
X-ME-IP: 90.16.82.155
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 4/4] arm: pxa: add non device-tree timer link to clocksource
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr>
	<1405356724-32207-4-git-send-email-robert.jarzmik@free.fr>
	<53CD25A4.7030606@linaro.org>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 21 Jul 2014 20:15:16 +0200
In-Reply-To: <53CD25A4.7030606@linaro.org> (Daniel Lezcano's message of "Mon,
	21 Jul 2014 16:37:24 +0200")
Message-ID: <87oawivarv.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Lezcano <daniel.lezcano@linaro.org> writes:

> On 07/14/2014 06:52 PM, Robert Jarzmik wrote:
>> As clocksource pxa_timer was moved to clocksource framework, the
>> pxa_timer initialization needs to be a bit amended, to pass the
>> necessary informations to clocksource, ie :
>>   - the timer interrupt (mach specific)
>>   - the timer registers base (ditto)
>>   - the timer clockrate
>>
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>>
>> ---
>> Since V2: Arnd's comment : moved extern declaration into .h file
>> ---
>
> Shall I take the patches 4-5 also ?
Mmm you mean patch 4 I think.
Then I'd like you too, because it's linked in the serie, and without it the
former non-DT platforms break, hence I'd like all the serie to go through 1
tree.

Yet we'd need Haojian's ack here. Haojian, would you give your blessing on the
serie and agree that Daniel carries all the patches including patch 4/4 ?

Cheers.

--
Robert
