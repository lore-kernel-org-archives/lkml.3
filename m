Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaDUFce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 01:32:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35059 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaDUFb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 01:31:56 -0400
Message-ID: <5354AD36.5090809@zytor.com>
Date: Sun, 20 Apr 2014 22:31:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cltang@codesourcery.com
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<53518FAC.8020504@zytor.com>	<201404191730.54400.arnd@arndb.de> <CAFiDJ5-PiUWetRMp65VTo4pvZM65r3WBjCZVWmxW0XnqAyO-GA@mail.gmail.com>
In-Reply-To: <CAFiDJ5-PiUWetRMp65VTo4pvZM65r3WBjCZVWmxW0XnqAyO-GA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2014 10:23 PM, Ley Foon Tan wrote:
> On Sat, Apr 19, 2014 at 11:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Friday 18 April 2014, H. Peter Anvin wrote:
>>> Did the generic headers ever get updated to match Linus' guidance that
>>> any new architecture ports should use a 64-bit time_t?
>>
>> No, unfortunately not. With my rule that every architecture that gets
>> added needs to clean up asm-generic some more, to make it easier to add
>> the next one, we should probably do for nios2.
>>
>>         Arnd
> 
> Can you give me the documentation on this new guidance and point me
> any architecture have implemented this?
> Thanks.
> 

We implemented it in the x32 ABI for x86.  In generic code this is keyed
by COMPAT_USE_64BIT_TIME, but in your case it isn't actually a matter of
compat, so it should be easier.

See this thread including the discussion about time_t:

https://lkml.org/lkml/2011/8/26/415

	-hpa

