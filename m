Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3FQQv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:51:26 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:37518 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FQQvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZe7U7G4dKZO+PyKxM6EO9xQSwxPGXwTZerj45t86+GPA@mail.gmail.com>
References: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
	<1992157.1uNu7hFias@amdc1227>
	<CACRpkdZe7U7G4dKZO+PyKxM6EO9xQSwxPGXwTZerj45t86+GPA@mail.gmail.com>
Date: Mon, 17 Jun 2013 09:51:22 -0700
X-Google-Sender-Auth: eE4ZYY_5dQ-6mt2w1PEp1jYzkQo
Message-ID: <CAD=FV=UQRcDj4zfhw5JqQM=V0qJJynVODkv6ecPiRtbaf8r94w@mail.gmail.com>
Subject: Re: [PATCH Resend] pinctrl: exynos: Fix build breakage
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Mon, Jun 17, 2013 at 9:18 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jun 17, 2013 at 1:57 PM, Tomasz Figa <t.figa@samsung.com> wrote:
>> On Monday 17 of June 2013 15:08:12 Sachin Kamat wrote:
>>> 'exynos_wkup_irq_ack' should be defined ahead of its call.
>>>
>>> Fixes the following error:
>>> drivers/pinctrl/pinctrl-exynos.c: In function ‘exynos_wkup_irq_mask’:
>>> drivers/pinctrl/pinctrl-exynos.c:299:3: error: implicit declaration of
>>> function ‘exynos_wkup_irq_ack’ [-Werror=implicit-function-declaration]
>>>    exynos_wkup_irq_ack(irqd);
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>> Cc: Doug Anderson <dianders@chromium.org>
>>> ---
>>> Fixed the commit message.
>>> ---
>>
>> This patch is incorrect.
>>
>> Compilation error is caused by merge error of Doug's patch:
>>
>> pinctrl: exynos: ack level-triggered interrupts before unmasking
>>
>> hunk of which went to wrong function - mask instead of unmask.
>
> OK probably I just had git am fail on me and used
> patch -p1 < ...
>
>> Linus, could you fix it?
>
> No I'm afraid I will cause more trouble.
>
> I took out Doug's commit and this fi from my tree.
>
> Doug, can you respin the patch
> "pinctrl: exynos: ack level-triggered interrupts before unmasking"
>
> On top of my "devel" branch?

OK, sent.  :)

-Doug
