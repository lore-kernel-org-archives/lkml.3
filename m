Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbbAQL4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 06:56:22 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46465 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbbAQL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 06:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150117080136.GA7396@amd>
References: <54AC72AF.5090609@landley.net>
	<20150106155024.5efa209d575fff4868758482@linux-foundation.org>
	<20150117080136.GA7396@amd>
Date: Sat, 17 Jan 2015 12:56:19 +0100
X-Google-Sender-Auth: KnZUl2lS_GZYJVjziB_8PH7a42o
Message-ID: <CAMuHMdUf6WcmspfbbGuUJahkxtrGW2ry0BgE2D04wMAcT1ArUA@mail.gmail.com>
Subject: Re: [PATCH] out out damn perl
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 9:01 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Tue 2015-01-06 15:50:24, Andrew Morton wrote:
>> On Tue, 06 Jan 2015 17:41:35 -0600 Rob Landley <rob@landley.net> wrote:
>>
>> > Commit e6023367d779 added perl back to the kernel build in -rc6.
>> > Replace 39 lines of perl with 4 lines of shell script.
>>
>> Please resend this:
>>
>> - Express the commit in the conventional fashion
>>
>>   e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
>>
>>   - So that we all don't have to go look up the commit to find out
>>     what happened.
>>
>>   - So people can look up the commit in other trees, where the hash
>>     might change.
>>
>> - Cc the people who wrote and committed the patch.
>>
>> - The offending commit has cc:stable, so have a think about adding a
>>   cc:stable to this one as well.
>
> Actually, I don't think this should go to stable. I like the patch,
> but it is not a bug, and certainly not serious enough one.

It is a regression w.r.t. building.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
