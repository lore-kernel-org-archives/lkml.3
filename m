Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaIHVxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:53:45 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:61663 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaIHVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:53:43 -0400
Message-ID: <540E2563.8020909@converseincode.com>
Date: Mon, 08 Sep 2014 16:53:39 -0500
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Charlebois <charlebm@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "zhichang.yuan@linaro.org" <zhichang.yuan@linaro.org>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: LLVMLinux: Provide __aeabi_* symbols which are
 needed for clang
References: <1409959394-14936-1-git-send-email-behanw@converseincode.com>	<2954780.2t9bpyu7ov@wuerfel>	<CAFzeTN0AO40k2ObpMX3xPOmKaiGdiLREev1A2J0sE=B7z64qug@mail.gmail.com>	<56E276C7-8204-48DD-B5C5-BF5B1452248A@arm.com> <CAFzeTN10iz0eMTVqdRhzvqKagyB7srEZN8YAUOJzxzfJihv62Q@mail.gmail.com>
In-Reply-To: <CAFzeTN10iz0eMTVqdRhzvqKagyB7srEZN8YAUOJzxzfJihv62Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 16:01, Mark Charlebois wrote:
> On Sun, Sep 7, 2014 at 12:30 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> On 7 Sep 2014, at 03:30, Mark Charlebois <charlebm@gmail.com> wrote:
>>> On Sat, Sep 6, 2014 at 7:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Friday 05 September 2014 16:23:14 behanw@converseincode.com wrote:
>>>>> + *  Copyright (C) 2012  Mark Charlebois
>>>>> + */
>>>>> +
>>>>> +/*
>>>>> + * EABI routines
>>>> Does EABI specify these function names? I would think that they are
>>>> just random libgcc (whatever that is called in clang) functions.
>>> http://infocenter.arm.com/help/topic/com.arm.doc.ihi0043d/IHI0043D_rtabi.pdf
>>>
>>> See section 4.3.4 Memory copying, clearing, and setting
>> What does this document have to do with arm64 (AArch64, A64)? We don’t
>> need such symbols on arm64. Also, the arm64 kernel links with libgcc (no
>> immediate need AFAICT but the compiler does not guarantee the intrinsics
>> would always be generated inline).
> [reposting in plain text]
>
> This patch was made early in the arm64 kernel support. I just retested
> and you are correct, it is no longer needed.  My apologies to all.

Whoops. I normally check whether a patch is still needed before posting 
them. I seem to have missed that step this time. My apologies as well.

That all being said, I prefer to see patches no longer required, than 
needing them to be upstreamed, so in that this is a win.

Behan

-- 
Behan Webster
behanw@converseincode.com

