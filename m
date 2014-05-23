Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaEWIMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:12:03 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39858 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEWIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:11:58 -0400
Message-ID: <537F02CA.5070304@linaro.org>
Date: Fri, 23 May 2014 09:11:54 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>
Subject: Re: [PATCH v2 00/14] Add Qualcomm SD Card Controller support
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>	<537EF50B.2010101@linaro.org> <CAPDyKFpTXrURM8OzNjO-RRfCFWGct4+_M4D8COdEurUhY46GWg@mail.gmail.com>
In-Reply-To: <CAPDyKFpTXrURM8OzNjO-RRfCFWGct4+_M4D8COdEurUhY46GWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/05/14 08:50, Ulf Hansson wrote:
> On 23 May 2014 09:13, Srinivas Kandagatla
> <srinivas.kandagatla@linaro.org> wrote:
>> Hi Ulf,
>> I like to get this patches for v3.16,  any chance of considering these
>> patches to v3.16 ?
>
> I promise to have them properly reviewed early next week, sorry for
> taking so long. Let's see where this leads us.
>
Thankyou.

> It seems like you had some CRC issues during read/write? Did you
> manage to resolve that issue?

Bjorn is using different SOC and board than the IFC6410 Am testing on, 
so its completely different setup.
on IFC6410 we did lot of stress testing and no issues seen. so 
suspecting the issues are very specific to that board or the eMMC Bjorn 
is using.

We are suspecting that the CRC issues are due to the fact that there is 
no code to manage regulators. My test setup uses dummy regulator, and 
the eMMC and external SD cards seems to be Ok with default voltages.

Am not sure if thats the same with Bjorn's board.

Thanks,
srini
>
> Kind regards
> Ulf Hansson
>
>
