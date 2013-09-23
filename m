Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3IWJgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:36:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57173 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3IWJgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:36:18 -0400
Message-ID: <52400B92.7000300@ti.com>
Date: Mon, 23 Sep 2013 15:06:18 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arun Joseph <arunjoseph@ti.com>
CC: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] iio: ti_am335x_adc: Take touchscreen steps into account
 for conversion timeout
References: <20130916211749.GG24058@raspi> <523D9046.7010305@kernel.org> <20130922175145.GB27515@raspi> <5240027C.9040804@ti.com>
In-Reply-To: <5240027C.9040804@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 September 2013 02:27 PM, Arun Joseph wrote:
> 
> On Sunday 22 September 2013 11:21 PM, Matthias Kaehlcke wrote:
>> Hi,
>>
>> El Sat, Sep 21, 2013 at 01:25:42PM +0100 Jonathan Cameron ha dit:
>>
>>> On 09/16/13 22:17, Matthias Kaehlcke wrote:
>>>> The calculation of the old conversion timeout value was based on the
>>>> number of
>>>> steps used by this driver. This doesn't take into account that other
>>>> steps
>>>> can be used by the touchscreen driver. Select the timeout value
>>>> based on the
>>>> steps used by both drivers
>>>>
>>>> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
>>> Looks fine to me but I'd like an Ack from someone more familiar with
>>> the device
>>> if possible.
>> Arun, do you feel entitled to Ack or can you suggest someone from TI
>> who is?
>>
> Adding Sekhar Nori

I have not really worked on this driver. It should be Sebastian who
should ack once he is back from his vacation. It looks like this is
v3.13 material so hopefully it can wait for him to be back.

Thanks,
Sekhar

