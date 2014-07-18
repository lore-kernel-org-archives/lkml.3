Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbaGRS4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:56:15 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:53119 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaGRS4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:56:13 -0400
Message-ID: <53C96DC7.10203@linaro.org>
Date: Fri, 18 Jul 2014 20:56:07 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko.stuebner@bq.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@linaro.org, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, olof@lixom.net,
        sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        ak@linux.intel.com, hpa@linux.intel.com, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org,
        fabf@skynet.be, rostedt@goodmis.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 5/7] arm: add basic support for Mediatek MT6589 boards
References: <1404745988-32558-1-git-send-email-matthias.bgg@gmail.com> <1404745988-32558-6-git-send-email-matthias.bgg@gmail.com> <53C8ED0B.5080802@linaro.org> <127793649.dTvqVjg5LM@diego>
In-Reply-To: <127793649.dTvqVjg5LM@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 12:47 PM, Heiko Stübner wrote:
> Hi Daniel,
>
> Am Freitag, 18. Juli 2014, 11:46:51 schrieb Daniel Lezcano:
>> On 07/07/2014 05:13 PM, Matthias Brugger wrote:
>>> This adds a generic devicetree board file and a dtsi for boards
>>> based on MT6589 SoCs from Mediatek.
>>>
>>> Apart from the generic parts (gic, clocks) the only component
>>> currently supported are the timers.
>>>
>>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>> --
>>
>> I will take this patchset through my tree but this patch touches an area
>> I am not handling.
>>
>> Olof, Arnd, do you mind to ack this patch ?
>
> wouldn't it be easier to just take patches 1,2,3,4 through your tree and let
> patches 5,6,7 go through arm-soc?
>
> There is no compile-time dependency between the two parts, so they will come
> together nicely in linux-next and during the merge-window.
>
>
> Also in [0] Olof wrote:
>
> ----------
> Traditionally we usually take the DT changes through arm-soc, but as
> long as we share the branch we might be ok. We tend to stick them in
> different branches in our tree though, so rockchip will be a little
> mis-sorted this release. Not a big deal, and we can deal with it.
> -----------
>
> So I'd assume splitting the patchset this way might be a nice solution?
>
>
> Heiko
>
>
> [0] http://www.spinics.net/lists/arm-kernel/msg347053.html

Indeed.

Olof, Arnd ? Will you take the patches 5-6-7 ?



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

