Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaGHEDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:03:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56503 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaGHED3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:03:29 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BB6D8F.70900@roeck-us.net>
Date: Mon, 07 Jul 2014 21:03:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Compile issues with se7206_defconfig
References: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
In-Reply-To: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 07:56 PM, Nick Krause wrote:
> There seems to me a build issue with this config. I will paste my logs
> for this build below this message.
> Cheers Nick
> scripts/mod/empty.c:1:0: error: cannot use atomic model soft-imask in user mode
>   /* empty file to figure out endianness / word size */
>   ^
> make[2]: *** [scripts/mod/empty.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [scripts/mod] Error 2
> make[1]: *** Waiting for unfinished jobs....
>    CHK     include/generated/utsrelease.h
>    UPD     include/generated/utsrelease.h
>    Generating include/generated/machtypes.h
>    CC      kernel/bounds.s
> kernel/bounds.c:1:0: error: cannot use atomic model soft-imask in user mode
>   /*
>   ^
> make[1]: *** [kernel/bounds.s] Error 1
> make: *** [prepare0] Error 2
> make: *** Waiting for unfinished jobs....
> make: *** [scripts] Error 2

What kernel version ? I see a build failure in mainline, but it is different.

net/built-in.o: In function `__sk_run_filter':
filter.c:(.text+0x3156c): undefined reference to `__fpscr_values'
filter.c:(.text+0x31760): undefined reference to `__fpscr_values'
filter.c:(.text+0x31c8c): undefined reference to `__fpscr_values'
filter.c:(.text+0x31f00): undefined reference to `__fpscr_values'
filter.c:(.text+0x323b0): undefined reference to `__fpscr_values'

Guenter

