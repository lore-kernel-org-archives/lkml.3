Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaKLRCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:02:12 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:44972 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaKLRCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:02:10 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:5c0e:7567:d831:6fad]
In-Reply-To: <CABxcv=mMqh5UD0_Wz3rNaFbZD3BH_2Z+7srzccd=-5_ndo_a1Q@mail.gmail.com>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
	<CABxcv==YZjO9p3aNyuRpe3DYS+=BcY_N2esuTg0hGASb_b_OdA@mail.gmail.com>
	<CABxcv=mMqh5UD0_Wz3rNaFbZD3BH_2Z+7srzccd=-5_ndo_a1Q@mail.gmail.com>
Date: Wed, 12 Nov 2014 09:02:08 -0800
Message-ID: <CAOesGMjKP6Yg-M_7Zy5bbEJ7QD7fQ27Bopd6yD3M=r=4SArR6w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Olof Johansson <olof@lixom.net>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 2:23 AM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Kukjin,
>
> On Thu, Oct 30, 2014 at 11:06 AM, Javier Martinez Canillas
> <javier@dowhile0.org> wrote:
>> Hello Kukjin,
>>
>> On Mon, Oct 20, 2014 at 11:05 PM, Javier Martinez Canillas
>> <javier.martinez@collabora.co.uk> wrote:
>>> The regulator framework has a set of helpers functions to be used when
>>> the system is entering and leaving from suspend but these are not called
>>> on Exynos platforms. This means that the .set_suspend_* function handlers
>>> defined by regulator drivers are not called when the system is suspended.
>>>
>>> Suggested-by: Doug Anderson <dianders@chromium.org>
>>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>>> ---
>>>  arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
>>>  1 file changed, 23 insertions(+)
>>>
>>
>> Any comments on this patch?
>>
>
> Just a gentle reminder about this patch.

Kukjin, should I just apply this directly since you seem to be busy?


Thanks,

-Olof
