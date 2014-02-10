Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaBJRhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:37:55 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:43090 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaBJRhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:37:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140210111349.GA21522@lee--X1>
References: <1391762601-4560-1-git-send-email-levex@linux.com>
 <003701cf25f6$3807c6d0$a8175470$%han@samsung.com> <20140210111349.GA21522@lee--X1>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 10 Feb 2014 09:37:29 -0800
Message-ID: <CAK5ve-L54nmDX_HLPpfWQrTe=n11RFr5hyUFFcc-1otWPQde7Q@mail.gmail.com>
Subject: Re: [PATCH] backlight: replace kfree with put_device
To: Lee Jones <lee.jones@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FBDEV list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 3:13 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> > As per the comments on device_register, we shouldn't call kfree()
>> > right after a device_register() failure. Instead call put_device(),
>> > which in turn will call bl_device_release resulting in a kfree to the
>> > full structure.
>> >
>> > Signed-off-by: Levente Kurusa <levex@linux.com>
>>
>> (+cc Bryan Wu, Lee Jones)
>>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>
> Applied to temporary Backlight repo [1], thanks.
>
> [1] git://git.linaro.org/people/lee.jones/backlight.git
>

Great, I think we can put the Git URL into the MAINTAINS file for
Backlight subsystem after your finalize the git repo.

Thanks,
-Bryan


> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
