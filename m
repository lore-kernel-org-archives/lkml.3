Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaFVFQX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 01:16:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50487 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFVFQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 01:16:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A6669B.1010701@roeck-us.net>
Date: Sat, 21 Jun 2014 22:16:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/score/include/uapi/asm/ptrace.h: Add prefix 'SCORE_'
 for related macros
References: <53A66000.4010208@gmail.com>
In-Reply-To: <53A66000.4010208@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2014 09:48 PM, Chen Gang wrote:
> 'COUNTER' and other same kind macros are too common to use, and easy to
> get conflict with other modules. So add prefix for them.
>
> The related warning (allmodconfig with score):
>
>      CC [M]  drivers/md/raid1.o
>    In file included from drivers/md/raid1.c:42:0:
>    drivers/md/bitmap.h:93:0: warning: "COUNTER" redefined
>     #define COUNTER(x) (((bitmap_counter_t) x) & COUNTER_MAX)
>     ^
>    In file included from ./arch/score/include/asm/ptrace.h:4:0,
>                     from include/linux/sched.h:31,
>                     from include/linux/blkdev.h:4,
>                     from drivers/md/raid1.c:36:
>    ./arch/score/include/uapi/asm/ptrace.h:13:0: note: this is the location of the previous definition
>     #define COUNTER  38
>
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Any idea where to find a cross-compile toolchain for this architecture ?

Thanks,
Guenter

