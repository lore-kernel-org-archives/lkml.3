Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaFMKEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:04:21 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:35842 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFMKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140613092442.GB5099@sirena.org.uk>
References: <877g4oau2s.fsf@rustcorp.com.au>
	<20140611105503.GG5099@sirena.org.uk>
	<87y4x2q5qr.fsf@rustcorp.com.au>
	<20140612112715.GX5099@sirena.org.uk>
	<87a99hpqnb.fsf@rustcorp.com.au>
	<20140613092442.GB5099@sirena.org.uk>
Date: Fri, 13 Jun 2014 12:04:18 +0200
X-Google-Sender-Auth: VCor_BkryUVzo89-eL5KT7G-bfo
Message-ID: <CAMuHMdUDnf25AwDs6Nm-znSOQ6jTQ9342Xs-B09JXHBffn6Tzw@mail.gmail.com>
Subject: Re: [PULL] modules-next
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian W Hart <hartb@linux.vnet.ibm.com>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Christian Engelmayer <cengelma@gmx.at>,
        Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Lindar Liu <lindar_liu@usish.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Simon Wood <simon@mungewell.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jun 13, 2014 at 11:24 AM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jun 13, 2014 at 10:33:20AM +0930, Rusty Russell wrote:
>> So, did you queue a patch to fix your email address in
>> drivers/regulator/virtual.c?
>
> No, that's more about giving credit to Wolfson for funding the code I
> guess - it's very rare for anyone to update the author information (and
> becoming more common for people to not put them in the file at all).
> Everyone uses get_maintainers.pl these days, it'll do a reasonable first
> pass at figuring out who's been working on the code and who the
> subsystem maintainers are.

Still, obsolete email address are regularly updated or removed.
You can give credits in the comments. The file already has

Copyright 2008 Wolfson Microelectronics PLC.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
