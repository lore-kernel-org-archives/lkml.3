Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaCZIoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 04:44:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37627 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaCZIoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 04:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
	<1390538708-4120-6-git-send-email-green@linuxhacker.ru>
	<1390542276.32356.22.camel@joe-AO722>
	<8ADC515E-0EB5-4891-A6C9-CEAEA5E50E34@linuxhacker.ru>
	<CAMuHMdWXvyTpoafetr63-80GWppZGC3y72otuf89d3LJoKwXOQ@mail.gmail.com>
	<AB57D4F6-7E01-43E6-A421-F73BE52AB74C@linuxhacker.ru>
Date: Wed, 26 Mar 2014 09:44:08 +0100
X-Google-Sender-Auth: dPgOEo1M8pK-Q4XVxlchKmGLYqA
Message-ID: <CAMuHMdVFO+6BKF6gGscwDyc2pxFXEFYKzXse6iVs15v=aipNFg@mail.gmail.com>
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
>
>> and http://kisskb.ellerman.id.au/kisskb/buildresult/10508264/
>> will turn green again?
>
> I certainly hope so.

Ping?

We got a new "fix" for this in due to https://lkml.org/lkml/2014/2/13/479

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
