Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3KWUZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:25:20 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50350 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3KWUZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:25:15 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52910F27.2040902@roeck-us.net>
Date: Sat, 23 Nov 2013 12:25:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: New build failures in v3.13-rc1
References: <5290F68C.4060900@roeck-us.net>	<CAMuHMdW-YO6WyL3F7M+q5PqATPwxD9zKLtA3tCc9-Z2wKo-mPg@mail.gmail.com>	<5290FE63.9020101@roeck-us.net> <CAKv+Gu-QC_z4X53KrYbnuQ6s6rT3-aMrg+OUeHj1k5PzdTU=TA@mail.gmail.com>
In-Reply-To: <CAKv+Gu-QC_z4X53KrYbnuQ6s6rT3-aMrg+OUeHj1k5PzdTU=TA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2013 12:08 PM, Ard Biesheuvel wrote:
> This is a known issue that will hopefully be sorted shortly:
>
> http://marc.info/?l=linux-arm-kernel&m=138515869216723&w=2
>
I assume you are referring to the arm:allmodconfig build failure.
Yes, I suspected that Herbert's pull request might fix that.

Thanks,
Guenter

