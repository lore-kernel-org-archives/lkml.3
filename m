Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3FNAAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 20:00:07 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:50782 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3FNAAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 20:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <15e401ce688b$8fadadb0$af090910$%kim@samsung.com>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
	<150901ce682e$1c3fca50$54bf5ef0$%kim@samsung.com>
	<CAD=FV=U9V-rgjcCusCvgw-SeUH-kDbozr_T-i1DcaXNXv48vxw@mail.gmail.com>
	<4661065.SXhmWQNl5M@flatron>
	<CAD=FV=Ukdpt4vMCZNySvKpHz6yGCP5X-LLAc1XdOAEAM8rr1fw@mail.gmail.com>
	<15e401ce688b$8fadadb0$af090910$%kim@samsung.com>
Date: Thu, 13 Jun 2013 17:00:01 -0700
X-Google-Sender-Auth: _HDHP5XTWqHhixSexwNNM8VSYOY
Message-ID: <CAD=FV=WZQwA3UgYRGBQVHFs05JJzfmVfLyLXo7iQJYm=WmVQdw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pinctrl: exynos: ack level-triggered interrupts
 before unmasking
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
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

Kukjin

<take 2, not in HTML mode>

On Thu, Jun 13, 2013 at 4:13 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Doug Anderson wrote:
>>
>> Tomasz,
>>
>> On Thu, Jun 13, 2013 at 9:42 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> >> > BTW, probably we need a similar fixing in the mach-exynos/common.c
>> >> > file
>> >> > before pinct기 for distro...
>> >>
>> >> Is anyone using the functions in mach-exynos/common.c file anymore?  I
>> >> thought that non-dt exynos support was going away and then we could
>> >> just delete a whole lot of code from that file.
>> >
>> > I think Kukjin meant stable kernels that support Exynos boards using
>> board
>> > files and without pinctrl. Would make sense to have them fixed as well,
>> I
>> > guess.
>>
> Yes, correct. Thanks, Tomasz.
>
>> Ah, makes sense.  Kukjin: do you know of someone who needs this
>> (someone who is picking up linux-stable updates for exynos)?  I don't
>> think it's important for ChromeOS for this particular patch.  If
>> there's someone who needs this to officially land on linux-stable I'd
>> be happy to review their backport of this patch.
>>
> As you know, developing something like Android, Tizen use the stable kernel (long-term? I'm not sure) and there was a problem about this issue. So I mean, would be fixed for the stable kernel.

Sure, but do they actually pull in from linux-stable periodically?
I'd imagine that they have a private tree and that it would be their
job to backport any fixes onto their kernel.
