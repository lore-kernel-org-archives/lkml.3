Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaAGRmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:42:03 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58184 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaAGRlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-K0aCVTo+21G47M0aYT8f-vkqLAd9etWxSY+ieib8KfMQ@mail.gmail.com>
References: <1388394595-1347-1-git-send-email-tushar.behera@linaro.org>
	<1388726757-7387-1-git-send-email-tushar.behera@linaro.org>
	<CAK5ve-K0aCVTo+21G47M0aYT8f-vkqLAd9etWxSY+ieib8KfMQ@mail.gmail.com>
Date: Tue, 7 Jan 2014 18:41:43 +0100
Message-ID: <CACRpkdbqDHHb+z2eV-hYbQsdVfYYCHajQZ2=63ab4uDfqRaWmg@mail.gmail.com>
Subject: Re: [PATCH V2] leds: s3c24xx: Fix build failure
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <cooloney@gmail.com>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 7:19 AM, Bryan Wu <cooloney@gmail.com> wrote:
> On Thu, Jan 2, 2014 at 9:25 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Commit c67d0f29262b ("ARM: s3c24xx: get rid of custom <mach/gpio.h>")
>> removed the usage of mach/gpio.h file, but we need to include
>> plat/gpio-cfg.h to avoid following build error.
>>
>> Fixes following build error.
>> drivers/leds/leds-s3c24xx.c: In function ‘s3c24xx_led_probe’:
>> drivers/leds/leds-s3c24xx.c:100:2: error: implicit declaration of
>> function ‘s3c_gpio_setpull’ [-Werror=implicit-function-declaration]
>>
>
> I think this patch should go with Linus's patchset.

Patch applied to the GPIO tree. I added your ACK Bryan since
that seems to be implied above ...

Yours,
Linus Walleij
