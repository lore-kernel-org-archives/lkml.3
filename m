Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3IWI33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:29:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab3IWI31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:29:27 -0400
Message-ID: <5240027C.9040804@ti.com>
Date: Mon, 23 Sep 2013 14:27:32 +0530
From: Arun Joseph <arunjoseph@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH v2] iio: ti_am335x_adc: Take touchscreen steps into account
 for conversion timeout
References: <20130916211749.GG24058@raspi> <523D9046.7010305@kernel.org> <20130922175145.GB27515@raspi>
In-Reply-To: <20130922175145.GB27515@raspi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 22 September 2013 11:21 PM, Matthias Kaehlcke wrote:
> Hi,
>
> El Sat, Sep 21, 2013 at 01:25:42PM +0100 Jonathan Cameron ha dit:
>
>> On 09/16/13 22:17, Matthias Kaehlcke wrote:
>>> The calculation of the old conversion timeout value was based on the number of
>>> steps used by this driver. This doesn't take into account that other steps
>>> can be used by the touchscreen driver. Select the timeout value based on the
>>> steps used by both drivers
>>>
>>> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
>> Looks fine to me but I'd like an Ack from someone more familiar with the device
>> if possible.
> Arun, do you feel entitled to Ack or can you suggest someone from TI
> who is?
>
Adding Sekhar Nori
>> Also, I'm assuming this is a fix we want to push out asap but that isn't
>> clear in your patch title.  Perhaps something like:
>>
>> iio: ti_am335x_adc: Fix conversion timeout to allow for touch screen steps.
>> ?
> it's not as critical as it seems as in practice the timeout has the
> granularity of a jiffy. If you prefer I still can resend the patch
> with the subject you suggest
>
> best regards
>

