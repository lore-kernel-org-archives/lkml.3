Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbaLKUeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:34:16 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38668 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbaLKUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:34:13 -0500
MIME-Version: 1.0
In-Reply-To: <547C42FF.5010700@ti.com>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
	<20141124115116.GA14997@linutronix.de>
	<547C3A95.30605@ti.com>
	<547C3C19.5090501@linutronix.de>
	<547C42FF.5010700@ti.com>
Date: Thu, 11 Dec 2014 22:34:10 +0200
Message-ID: <CAH=tA9FO5MCzE274thc-NugCNte6WdyC-Rxc6yfnuR=+6_qMbA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] Touchscreen performance related fixes
From: Nicolae Rosia <nicolae.rosia@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        richardcochran@gmail.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Any updates on this series? I don't see it applied in [1] or [2].

[1] https://github.com/RobertCNelson/ti-linux-kernel/commits/ti-linux-3.14.y/drivers/input/touchscreen/ti_am335x_tsc.c
[2] https://github.com/RobertCNelson/ti-linux-kernel/commits/ti-linux-3.14.y-exp/drivers/input/touchscreen/ti_am335x_tsc.c

Regards,
Nicolae Rosia

On Mon, Dec 1, 2014 at 12:29 PM, Vignesh R <vigneshr@ti.com> wrote:
>
> Hi,
>
> On Monday 01 December 2014 03:29 PM, Sebastian Andrzej Siewior wrote:
>> On 12/01/2014 10:53 AM, Vignesh R wrote:
>>> Hi Sebastian,
>>
>> Hi Vignesh,
>>
>>> I fixed the issue that was triggering the WARN_ON(). I think it would be
>>> better if you tested these patches, before I posted them on the
>>> mainline. I don't want to clutter the list with too main versions. Here
>>> is the link to the tree with latest changes:
>>
>> awesome, thank you.
>>
>>>
>>> git clone -b tsc-devel git://git.ti.com/kernel/tsc-adc.git
>>> (tsc-devel branch)
>>
>> I will and let you know.
>>
>>> Please test the above tree and let me know the results.
>>> I will post new version(v5) if there are no issues wrt IIO and TSC
>>> working at the same time.
>>
>> Cool. Were you able to get in touch with someone who has a 5-wire touch?
>
> I have asked Jeff Lance to verify 5-wire touch.
>
> Regards
> Vignesh
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
