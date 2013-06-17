Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3FQLqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:46:03 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56522 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab3FQLqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaxpr_7minVkbwsMK+tpbEy7LChz5C+Gt7zYNYhee2ibw@mail.gmail.com>
References: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdaxpr_7minVkbwsMK+tpbEy7LChz5C+Gt7zYNYhee2ibw@mail.gmail.com>
Date: Mon, 17 Jun 2013 17:16:01 +0530
Message-ID: <CAK9yfHzxC-2cZuOJJyaN8tY0_PDsW7kf3JB=GOhAm9+CA0RSXw@mail.gmail.com>
Subject: Re: [PATCH Resend] pinctrl: exynos: Fix build breakage
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2013 16:55, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jun 17, 2013 at 11:38 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>
>> 'exynos_wkup_irq_ack' should be defined ahead of its call.
>>
>> Fixes the following error:
>> drivers/pinctrl/pinctrl-exynos.c: In function ‘exynos_wkup_irq_mask’:
>> drivers/pinctrl/pinctrl-exynos.c:299:3: error: implicit declaration of
>> function ‘exynos_wkup_irq_ack’ [-Werror=implicit-function-declaration]
>>    exynos_wkup_irq_ack(irqd);
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Doug Anderson <dianders@chromium.org>
>> ---
>> Fixed the commit message.
>> ---
>
> Applied.

Thanks.

>
> Usually you should state which commit caused
> the problem in the commit message.

Usually I do. But in this case it was not caused by a single commit
per se but a combination.
Hence I wasn't sure if I should mention both as the ones causing it.


-- 
With warm regards,
Sachin
