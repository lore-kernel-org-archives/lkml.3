Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaDOJzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:55:32 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40968 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1397554747.1985.35.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-22-git-send-email-richard@nod.at>
	<1391981761.25855.58.camel@x220>
	<1397554747.1985.35.camel@x220>
Date: Tue, 15 Apr 2014 11:55:28 +0200
X-Google-Sender-Auth: NlCIvpi7ln97gHYm6BMp3D9mrw4
Message-ID: <CAMuHMdXawwgr7x=TFumDUh+c+-KZteHdp+NrnXTFcFcwT6gjRQ@mail.gmail.com>
Subject: Re: [PATCH 21/28] Remove CPU_SUBTYPE_SH7764
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Apr 15, 2014 at 11:39 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-02-09 at 22:36 +0100, Paul Bolle wrote:
>> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
>> > The symbol is an orphan, get rid of it.
>> >
>> > Signed-off-by: Richard Weinberger <richard@nod.at>
>>
>> Paul Mundt had something similar queued a year ago:
>> https://lkml.org/lkml/2013/3/11/211 . What happened?
>
> By now the SuperH port has been orphaned. So what's the current
> procedure for small SuperH fixes like this one?

Please submit them to Andrew Morton <akpm@linux-foundation.org>.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
