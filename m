Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3FSG1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:27:18 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60552 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3FSG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:27:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMhL7P350yPkxEKAZ+FS9X6QMFL+4gv5dCRBCW8rwQBB0g@mail.gmail.com>
References: <CA+G9fYu3_-RZxFyRENuqJvzsM=YToT7PG+5fUytMzhsFu3=z7g@mail.gmail.com>
	<CAOesGMhL7P350yPkxEKAZ+FS9X6QMFL+4gv5dCRBCW8rwQBB0g@mail.gmail.com>
Date: Wed, 19 Jun 2013 11:57:15 +0530
Message-ID: <CA+G9fYtZX2Bad+Wfds1jnvGX+7yW2zvaVJ5UiuDqzOWQE7W__Q@mail.gmail.com>
Subject: Re: linux-next: origen build failed at drivers/pinctrl/pinctrl-exynos.c
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

I will give you Kernel head commit ID of linux-next.
Thanks for the feedback.

Best regards
Naresh Kamboju

On 18 June 2013 22:33, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
>
> On Tue, Jun 18, 2013 at 9:19 AM, Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>> Hi,
>>
>> linux-next branch failed to build origen build
>>
>> defconfig: exynos_defconfig
>
> This was broken yesterday and fixed today. Getting linux-next build
> error reports that are 24+ hours old isn't very useful, unfortunately.
>
> It'd also be convenient if you supplied the "git describe" version
> number of the source tree in these reports, so it'd be trivial to find
> out by glancing at the report, instead of going to the build log.
>
> (Besides that, thanks for the bug report!)
>
>
> -Olof
