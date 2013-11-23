Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3KWUIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 15:08:32 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:37056 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3KWUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 15:08:31 -0500
MIME-Version: 1.0
In-Reply-To: <5290FE63.9020101@roeck-us.net>
References: <5290F68C.4060900@roeck-us.net>
	<CAMuHMdW-YO6WyL3F7M+q5PqATPwxD9zKLtA3tCc9-Z2wKo-mPg@mail.gmail.com>
	<5290FE63.9020101@roeck-us.net>
Date: Sat, 23 Nov 2013 21:08:29 +0100
Message-ID: <CAKv+Gu-QC_z4X53KrYbnuQ6s6rT3-aMrg+OUeHj1k5PzdTU=TA@mail.gmail.com>
Subject: Re: New build failures in v3.13-rc1
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kirill Tkhai <tkhai@yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a known issue that will hopefully be sorted shortly:

http://marc.info/?l=linux-arm-kernel&m=138515869216723&w=2

-- 
Ard.


On 23 November 2013 20:13, Guenter Roeck <linux@roeck-us.net> wrote:
> On 11/23/2013 10:51 AM, Geert Uytterhoeven wrote:
>>
>> On Sat, Nov 23, 2013 at 7:40 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> drivers/tty/ehv_bytechan.c:363:1: error: type defaults to 'int' in
>>> declaration of 'console_initcall' [-Werror=implicit-int]
>>>
>>> Not really surprising as console_initcall() is not defined for modules.
>>> I am a bit at loss why this is only seen now, though.
>>
>>
>> On kissb that's been seens since v3.2-rc1.
>>
>
> Makes it even more surprising that I only see it now, since I did not change
> anything
> in my build scripts. I'll do some digging; maybe I can find out.
>
> Guenter
>
