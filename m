Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3FJQra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:47:30 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56820 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJQr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:47:29 -0400
Message-ID: <51B6031B.4030204@gmail.com>
Date: Mon, 10 Jun 2013 18:47:23 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/6] clocksource: add Marvell Orion SoC timer
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370856955-10514-1-git-send-email-sebastian.hesselbarth@gmail.com> <51B5F8FE.5090508@linaro.org> <51B5FF51.6090708@gmail.com> <51B60267.9000600@linaro.org>
In-Reply-To: <51B60267.9000600@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/13 18:44, Daniel Lezcano wrote:
> On 06/10/2013 06:31 PM, Sebastian Hesselbarth wrote:
>> On 06/10/13 18:04, Daniel Lezcano wrote:
>>> On 06/10/2013 11:35 AM, Sebastian Hesselbarth wrote:
>>>> This patch add a DT enabled driver for timers found on Marvell Orion
>>>> SoCs
>>>> (Kirkwood, Dove, Orion5x, and Discovery Innovation). It installs a free-
>>>> running clocksource on timer0 and a clockevent source on timer1.
>>>> Corresponding device tree documentation is also added.
>>>>
>>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>>
>>> It looks good for me.
>>>
>>> Sebastian,
>>>
>>> shall I take it through my tree (it will go to Thomas's tree) ?
>>
>> Daniel,
>>
>> I checked MAINTAINERS and thought clocksource, i.e. patch 2/6, would go
>> through Thomas' or John's tree? If you want to take it, I am fine with
>> it but guess I am not the one to choose here ;)
>
> Actually, I am giving a hand to John and Thomas. I take the patches for
> clockevents (and also for clocksource if both are mixed and John did not
> pick it yet) and Thomas pulls from my tree [1].
>
> If there is no dependency with any other patches of your patchset, which
> seems to be the case, I will queue it for 3.11.

Ok, thanks!

Sebastian

