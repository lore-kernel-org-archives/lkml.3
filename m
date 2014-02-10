Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBJItS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:49:18 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45688 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaBJItQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:49:16 -0500
MIME-Version: 1.0
In-Reply-To: <52F7E34E.3010509@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-25-git-send-email-richard@nod.at>
	<1391974709.25855.3.camel@x220>
	<52F7DF51.8000507@nod.at>
	<1391976929.25855.22.camel@x220>
	<52F7E34E.3010509@nod.at>
Date: Mon, 10 Feb 2014 09:49:16 +0100
X-Google-Sender-Auth: d1kbUmxkzNOl1ARtsFmA_U-iwWM
Message-ID: <CAMuHMdX-CFScoxBoE3SMHT4+12mbxBPEL53-HVd+6bkGd3XX_g@mail.gmail.com>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Paul Bolle <pebolle@tiscali.nl>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 9:21 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 09.02.2014 21:15, schrieb Paul Bolle:
>> On Sun, 2014-02-09 at 21:04 +0100, Richard Weinberger wrote:
>>> Am 09.02.2014 20:38, schrieb Paul Bolle:
>>>> But now you've enabled a lot of stuff that, as far as I can tell, could
>>>> not have been built since v2.6.39.
>>>
>>> This is by design. If the code does not build/work it needs to be fixed or removed.
>>
>> If that was the design goal of this patch (and similar patches you've
>> sent) it would have been proper to at least say a few words along those
>> lines in the commit explanation.
>
> I assumed that every kernel developer is aware of that fact that unreachable/dead code
> should be removed.

Yes, it should be removed.

But that's not what you did. You did the Kconfig-equivalent of removing a
"#if 0" in a C source file, which causes havoc.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
