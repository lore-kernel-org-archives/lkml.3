Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAPEb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:31:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39155 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAPEbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:31:22 -0500
Message-ID: <52D76037.50706@ti.com>
Date: Thu, 16 Jan 2014 09:59:43 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 7/7] drivers/gpio: don't check resource with devm_ioremap_resource
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>	<1389700739-3696-7-git-send-email-wsa@the-dreams.de>	<CACRpkdYymB4i7Ju5MMNXWVe5nB6_NbWHwrPbOK2KeT0Ji-RzQg@mail.gmail.com>	<52D684E9.6080308@ti.com>	<CACRpkdY1FuRoSFAPT8qUybzrizN_tEgxB41dwW_-uEWdFPb0jA@mail.gmail.com>	<52D69551.4070607@ti.com> <87iotl453e.fsf@linaro.org>
In-Reply-To: <87iotl453e.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014 09:20 PM, Kevin Hilman wrote:
> Sekhar Nori <nsekhar@ti.com> writes:
> 
>> On Wednesday 15 January 2014 07:21 PM, Linus Walleij wrote:
>>> On Wed, Jan 15, 2014 at 1:54 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>>> On Wednesday 15 January 2014 02:58 PM, Linus Walleij wrote:
>>>
>>>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>>>
>>>>> The DaVinci maintainers are queuing GPIO patches for their driver
>>>>> for this merge window, so requesting them to apply this patch.
>>>>
>>>> I wont be sending any more pull requests for v3.14. Even if I send, the
>>>> ARM-SoC maintainers will not take it anyway.
>>>
>>> But as it is a fix I believe the ARM SoC maintainers will apply it
>>> directly to the davinci branch.
>>
>> Sorry I did not realize this is a fix.
>>
>>>
>>> Wolfram: I suggest you send this patch with my ACK directly
>>> to arm@kernel.org and ask it to be applied to the davinci branch
>>> in the ARM SoC tree.
>>
>> This would work too, I guess. Wolfram, can you please keep me in CC too
>> in case questions/actions come up?
> 
> Sekhar, I assume this is an ack from you too?  If so, Wolfram, please
> include that in the patch submitted to arm-soc.

Wolfram, if you have not sent it already, please add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

The branch to which the patch will be applied is davinci/gpio on
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git. Please
rebase on this branch so it applies cleanly.

Thanks,
Sekhar

