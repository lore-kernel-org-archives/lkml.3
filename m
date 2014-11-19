Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaKSKGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:06:12 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44730 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKSKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:06:10 -0500
Message-ID: <546C6B8E.8060908@linaro.org>
Date: Wed, 19 Nov 2014 11:06:06 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Carlo Caione <carlo@caione.org>
CC: Beniamino Galvani <b.galvani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: meson6: Select CLKSRC_MMIO
References: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>	<546C67F1.1000005@linaro.org> <CAOQ7t2a6RdEF8wzOFTek72sgvDuag_U1_Q0ihY9hQPpCvxZQ8g@mail.gmail.com>
In-Reply-To: <CAOQ7t2a6RdEF8wzOFTek72sgvDuag_U1_Q0ihY9hQPpCvxZQ8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 11:00 AM, Carlo Caione wrote:
> On Wed, Nov 19, 2014 at 10:50 AM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 11/16/2014 09:03 AM, Beniamino Galvani wrote:
>>>
>>> Select CLKSRC_MMIO when the meson6_timer driver is enabled since it
>>> depends on clocksource MMIO functions.
>>>
>>> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
>>
>>
>> patch queued for 3.19
>>
>> Thanks !
>
> Hi Daniel,
> actually I already pulled this fix with the meson/soc changes in
> http://www.spinics.net/lists/arm-kernel/msg378895.html
> Sorry for the confusion (yeah, probably it should have gone through
> your tree, sorry for that).

Ok, dropping it from my tree.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

