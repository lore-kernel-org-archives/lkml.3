Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaAVLod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:44:33 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:42533 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaAVLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:44:32 -0500
MIME-Version: 1.0
In-Reply-To: <loom.20140122T122840-441@post.gmane.org>
References: <loom.20140122T122840-441@post.gmane.org>
Date: Wed, 22 Jan 2014 12:44:31 +0100
Message-ID: <CAFLxGvxpE3+DNT9q2WN6BjB4uiTYuWyswrfW0JKWkCAUBJ3+Ow@mail.gmail.com>
Subject: Re: ADC continous mode
From: Richard Weinberger <richard.weinberger@gmail.com>
To: shravan <shravanec2011@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 12:29 PM, shravan <shravanec2011@gmail.com> wrote:
> Hi experts,
> i am new to this area,
> I am using amstrong 3.8.13 kernel in BBB

As the BBB 3.8.x kernel contains gazillions of patches you better
ask the creators of the BSP.

> at first i loaded the device tree as below,
>
>  echo cape-bone-iio > /sys/devices/bone_capemgr.*/slots
>
> then i used analog pins however i am getting the fixed values that is values
> are not varying continously as i vary input analog voltage
>
> if i go to this path
> /sys/devices/ocp.2/44e0d000.tscadc/tiadc/iio:device0
>
> and then ls -al gives me
>
> total 0
> drwxr-xr-x 3 root root    0 Jan  1 03:24 .
> drwxr-xr-x 4 root root    0 Jan  1 03:24 ..
> -r--r--r-- 1 root root 4096 Jan  1 03:27 dev
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage0_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage1_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage2_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage3_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage4_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage5_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage6_raw
> -rw-r--r-- 1 root root 4096 Jan  1 03:27 in_voltage7_raw
> -r--r--r-- 1 root root 4096 Jan  1 03:25 name
> drwxr-xr-x 2 root root    0 Jan  1 03:27 power
> lrwxrwxrwx 1 root root    0 Jan  1 03:27 subsystem -> ../../../../../bus/iio
> -rw-r--r-- 1 root root 4096 Jan  1 03:24 uevent
>
> there is no mode directory and buffer directory in list . please help to
> configure ADC In continous mode.
>
> Thanks
> shravankumar
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
