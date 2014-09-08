Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaIHVBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:01:50 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:62648 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaIHVBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <56E276C7-8204-48DD-B5C5-BF5B1452248A@arm.com>
References: <1409959394-14936-1-git-send-email-behanw@converseincode.com>
	<2954780.2t9bpyu7ov@wuerfel>
	<CAFzeTN0AO40k2ObpMX3xPOmKaiGdiLREev1A2J0sE=B7z64qug@mail.gmail.com>
	<56E276C7-8204-48DD-B5C5-BF5B1452248A@arm.com>
Date: Mon, 8 Sep 2014 14:01:48 -0700
Message-ID: <CAFzeTN10iz0eMTVqdRhzvqKagyB7srEZN8YAUOJzxzfJihv62Q@mail.gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are
 needed for clang
From: Mark Charlebois <charlebm@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Behan Webster <behanw@converseincode.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "zhichang.yuan@linaro.org" <zhichang.yuan@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 12:30 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On 7 Sep 2014, at 03:30, Mark Charlebois <charlebm@gmail.com> wrote:
>> On Sat, Sep 6, 2014 at 7:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>
>>> On Friday 05 September 2014 16:23:14 behanw@converseincode.com wrote:
>>>> + *  Copyright (C) 2012  Mark Charlebois
>>>> + */
>>>> +
>>>> +/*
>>>> + * EABI routines
>>>
>>> Does EABI specify these function names? I would think that they are
>>> just random libgcc (whatever that is called in clang) functions.
>>
>> http://infocenter.arm.com/help/topic/com.arm.doc.ihi0043d/IHI0043D_rtabi.pdf
>>
>> See section 4.3.4 Memory copying, clearing, and setting
>
> What does this document have to do with arm64 (AArch64, A64)? We don’t
> need such symbols on arm64. Also, the arm64 kernel links with libgcc (no
> immediate need AFAICT but the compiler does not guarantee the intrinsics
> would always be generated inline).

[reposting in plain text]

This patch was made early in the arm64 kernel support. I just retested
and you are correct, it is no longer needed.  My apologies to all.

-Mark

>
> Catalin
