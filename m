Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbaGXOYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:24:51 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:43171 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834AbaGXOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_z4VTssLDhiQxi8DRJNEUgzrM5bFzje8NXEmBiA2vqeg@mail.gmail.com>
References: <mvmvbri4k06.fsf@hawking.suse.de>
	<CAKv+Gu-NAVjMR-Jkw=W-8f7M5FSsQOSdzYN6A0kHDd1m0WA8EA@mail.gmail.com>
	<mvmr4264i1p.fsf@hawking.suse.de>
	<CAKv+Gu8SbM_Z=ymBFb2D4EWJeo-6dWuKqE2YNOkqJTKLDEJcYA@mail.gmail.com>
	<mvm4my7j5xh.fsf@hawking.suse.de>
	<CAKv+Gu-6rUxUnF+dRuroDJqy2K2B5F0r7_bm0X-vyiuQ-83W5w@mail.gmail.com>
	<CAKv+Gu96k7GOVR85EXtro3Lt0jjiJqxyvT9cwJZ1qc6uzq97bw@mail.gmail.com>
	<mvmvbqmj3b2.fsf@hawking.suse.de>
	<CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
	<mvmr41aj2ob.fsf@hawking.suse.de>
	<CAKv+Gu_z4VTssLDhiQxi8DRJNEUgzrM5bFzje8NXEmBiA2vqeg@mail.gmail.com>
Date: Thu, 24 Jul 2014 16:24:48 +0200
Message-ID: <CAKv+Gu-B9_sgGgw9obrBGNUFSS1JcskN34s1X4PU8F5bauHT1Q@mail.gmail.com>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Andreas Schwab <schwab@suse.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 July 2014 16:18, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 24 July 2014 15:40, Andreas Schwab <schwab@suse.de> wrote:
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
>>
>>> On 24 July 2014 15:26, Andreas Schwab <schwab@suse.de> wrote:
>>>> You are not using CONFIG_MODVERSIONS.
>>>>
>>>
>>> I am
>>
>> No, you aren't, since you say that your .cmd contains a command to
>> create aes-glue-ce.o, which with CONFIG_MODVERSIONS it doesn't.
>>
>
> OK, you're right, it contains a command to create .tmp_aes-glue-ce.o.
> But I am still not seeing the error you are seeing, strangely enough.

OK, now I am seeing it.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for your patience.

-- 
Ard.
