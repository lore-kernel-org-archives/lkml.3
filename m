Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaBDJIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:08:16 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58443 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaBDJIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:08:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140204090316.GB13529@lee--X1>
References: <1391496143-6660-1-git-send-email-sj38.park@gmail.com> <20140204090316.GB13529@lee--X1>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 4 Feb 2014 18:07:31 +0900
Message-ID: <CAEjAshpnKc7GAOeMOcYOsO0wviq3vN=Vxc5WKG=5ErJKQu4tYw@mail.gmail.com>
Subject: Re: [PATCH] drivers/mfd: fix pointer-integer size mismatch warnings
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 6:03 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> Fix the pointer-integer size mismatch warnings below:
>>       drivers/mfd/wm8994-core.c: In function ‘wm8994_i2c_probe’:
>>       mfd/wm8994-core.c:639:19: warning: cast from pointer to integer of
>>                       different size [-Wpointer-to-int-cast]
>>           wm8994->type = (int)of_id->data;
>>                          ^
>>       drivers/mfd/max8997.c: In function ‘max8997_i2c_get_driver_data’:
>>       drivers/mfd/max8997.c:173:10: warning: cast from pointer to integer of
>>                       different size [-Wpointer-to-int-cast]
>>          return (int)match->data;
>>                 ^
>
> Already fixed:
>   https://lkml.org/lkml/2014/1/23/309
>   https://lkml.org/lkml/2014/1/23/326

Oops, sorry, didn't check that(I checked only the -next tree).
Thank you for let me know.

>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
