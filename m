Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab3IBHU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:20:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3IBHUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:20:54 -0400
Message-ID: <52243C4E.8000007@ti.com>
Date: Mon, 2 Sep 2013 12:50:46 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <n.a.balandin@gmail.com>
Subject: Re: [PATCH v3 0/3] cleanup of gpio_pcf857x.c
References: <1378089004-14478-1-git-send-email-george.cherian@ti.com> <87a9jvsofz.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87a9jvsofz.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/2013 12:25 PM, Kuninori Morimoto wrote:
> Hi
>
> Sorry for my many response.
No Issues. and thanks for the review.
>> This patch series
>>          - removes the irq_demux_work
>>          - Uses devm_request_threaded_irq
>>          - Call the user handler iff gpio_to_irq is done.
>>
>> v1 --> v2
>>          Split v1 to 3 patches
>> v2 --> v3
>> 	Remove the unnecessary dts patches.
>>
>>
>> George Cherian (3):
>>    gpio: pcf857x: change to devm_request_threaded_irq
>>    gpio: pcf857x: remove the irq_demux_work
>>    gpio: pcf857x: call the gpio user handler iff gpio_to_irq is done
>>
>>   drivers/gpio/gpio-pcf857x.c | 51 +++++++++++++++++++++++----------------------
>>   1 file changed, 26 insertions(+), 25 deletions(-)
> Basically, I have no objection about these patches,
> but I have 2 opinions
>   - I guess we can merge #1 and #2 patches ?
>     ("as is" is very OK for me though)
>   - we don't need gpio->irq any more ?
>     (additional patch is very OK for me)
I will sent one patch removing gpio->irq too.
>
> Best regards
> ---
> Kuninori Morimoto


-- 
-George

