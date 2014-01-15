Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAOOFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:05:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37925 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaAOOFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:05:39 -0500
Message-ID: <52D69551.4070607@ti.com>
Date: Wed, 15 Jan 2014 19:34:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>
CC: Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>	<1389700739-3696-7-git-send-email-wsa@the-dreams.de>	<CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>	<52D684E9.6080308@ti.com> <CACRpkdY1FuRoSFAPT8qUybzrizN_tEgxB41dwW_-uEWdFPb0jA@mail.gmail.com>
In-Reply-To: <CACRpkdY1FuRoSFAPT8qUybzrizN_tEgxB41dwW_-uEWdFPb0jA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014 07:21 PM, Linus Walleij wrote:
> On Wed, Jan 15, 2014 at 1:54 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On Wednesday 15 January 2014 02:58 PM, Linus Walleij wrote:
> 
>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> The DaVinci maintainers are queuing GPIO patches for their driver
>>> for this merge window, so requesting them to apply this patch.
>>
>> I wont be sending any more pull requests for v3.14. Even if I send, the
>> ARM-SoC maintainers will not take it anyway.
> 
> But as it is a fix I believe the ARM SoC maintainers will apply it
> directly to the davinci branch.

Sorry I did not realize this is a fix.

> 
> Wolfram: I suggest you send this patch with my ACK directly
> to arm@kernel.org and ask it to be applied to the davinci branch
> in the ARM SoC tree.

This would work too, I guess. Wolfram, can you please keep me in CC too
in case questions/actions come up?

Thanks,
Sekhar
