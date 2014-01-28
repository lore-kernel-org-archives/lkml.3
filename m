Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaA1T2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:28:36 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61523 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1T2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:28:35 -0500
MIME-Version: 1.0
In-Reply-To: <AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
	<1390538708-4120-6-git-send-email-green@linuxhacker.ru>
	<1390542276.32356.22.camel@joe-AO722>
	<8ADC515E-0EB5-4891-A6C9-CEAEA5E50E34@linuxhacker.ru>
	<CAMuHMdWXvyTpoafetr63-80GWppZGC3y72otuf89d3LJoKwXOQ@mail.gmail.com>
	<AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
Date: Tue, 28 Jan 2014 20:28:33 +0100
X-Google-Sender-Auth: rEwiurdQxWiiuA6rbozO5ONvtLA
Message-ID: <CAMuHMdWi4KPYa6GmkSgjxpL-mMxJB5FHG2FuoQ7UEWNpEqt-9g@mail.gmail.com>
Subject: Re: [PATCH 5/5] lustre: add myself to list of people to CC on lustre patches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 4:23 AM, Oleg Drokin <green@linuxhacker.ru> wrote:
> On Jan 24, 2014, at 3:55 AM, Geert Uytterhoeven wrote:
>> On Fri, Jan 24, 2014 at 6:51 AM, Oleg Drokin <green@linuxhacker.ru> wrote:
>>>> +STAGING - LUSTRE
>>>> +M:   Andreas Dilger <andreas.dilger@intel.com>
>>>> +M:   Oleg Drokin <oleg.drokin@intel.com>
>>>> +M:   Peng Tao <tao.peng@emc.com>.
>>>> +L:   hpdd-discuss <hpdd-discuss@lists.01.org>
>>>> +S:   Odd Fixes
>>>
>>> Actually we are at least Maintained here, if not outright Supported.
>>
>> Good to hear that!
>> So can we assume that https://lkml.org/lkml/2013/9/9/725 will be fixed
>> shortly,
>
> We are working on it.

Thanks!

>> and http://kisskb.ellerman.id.au/kisskb/buildresult/10508264/
>> will turn green again?
>
> I certainly hope so.
> BTW, do you also provide interface where I can drop in my patch and your builder verify it for me by any chance,

It's called linux-next, but Lustre is part of staging, which is already
included. No idea how lustre gets updated in thes staging tree, though.

> so that I don't need to replicate build environment for every supported architecture?

Lots of cross compilers are just a download away:
https://www.kernel.org/pub/tools/crosstool/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
