Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3FMQuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:50:39 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:42353 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3FMQuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:50:37 -0400
MIME-Version: 1.0
In-Reply-To: <4661065.SXhmWQNl5M@flatron>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
	<CAD=FV=U9V-rgjcCusCvgw-SeUH-kDbozr_T-i1DcaXNXv48vxw@mail.gmail.com>
	<4661065.SXhmWQNl5M@flatron>
Date: Thu, 13 Jun 2013 09:50:35 -0700
X-Google-Sender-Auth: DMhOetp6Lp6Kmhxvl99Hvs5L09s
Message-ID: <CAD=FV=Ukdpt4vMCZNySvKpHz6yGCP5X-LLAc1XdOAEAM8rr1fw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Ilho Lee <ilho215.lee@samsung.com>,
        =?UTF-8?B?6rmA7J2A6riw?= <eunki_kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz,

On Thu, Jun 13, 2013 at 9:42 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> > BTW, probably we need a similar fixing in the mach-exynos/common.c
>> > file
>> > before pinct기 for distro...
>>
>> Is anyone using the functions in mach-exynos/common.c file anymore?  I
>> thought that non-dt exynos support was going away and then we could
>> just delete a whole lot of code from that file.
>
> I think Kukjin meant stable kernels that support Exynos boards using board
> files and without pinctrl. Would make sense to have them fixed as well, I
> guess.

Ah, makes sense.  Kukjin: do you know of someone who needs this
(someone who is picking up linux-stable updates for exynos)?  I don't
think it's important for ChromeOS for this particular patch.  If
there's someone who needs this to officially land on linux-stable I'd
be happy to review their backport of this patch.

-Doug
