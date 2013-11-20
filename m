Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3KTOO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:14:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39846 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3KTOO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:14:26 -0500
Message-ID: <528CC383.8030104@ti.com>
Date: Wed, 20 Nov 2013 19:43:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio
References: <1383893156-28010-1-git-send-email-prabhakar.csengg@gmail.com>	<1383893156-28010-2-git-send-email-prabhakar.csengg@gmail.com>	<5281C82B.9090402@ti.com> <CACRpkdbeWa76n1yrLxLJUEaz116k+48EbRtPO2iz=y=WLYoR_Q@mail.gmail.com>
In-Reply-To: <CACRpkdbeWa76n1yrLxLJUEaz116k+48EbRtPO2iz=y=WLYoR_Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 November 2013 04:18 PM, Linus Walleij wrote:
> On Tue, Nov 12, 2013 at 7:18 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On Friday 08 November 2013 12:15 PM, Prabhakar Lad wrote:
>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>
>>> This patch fixes a check for offset in gpio_to_irq_unbanked()
>>> and also assigns gpio_irq, gpio_unbanked of chips[0] to
>>> appropriate values which is used in gpio_to_irq_unbanked()
>>> function.
>>>
>>> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> You should note explicitly that this patch fixes broken unbanked IRQ
>> support. You mostly just described what you are doing.
>>
>> I will fixup while committing.
> 
> So you're carrying this patch Sekhar?

Yes, and I would have sent this for upstream already if not for I going
under the weather a bit past couple of days.

Thanks,
Sekhar
