Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaKLKWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:22:24 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:52154 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaKLKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzof00w3ah4kenjfK=6_ydP6NN6PRsaUjMnwDLH8hzEOw@mail.gmail.com>
References: <1415785566-12758-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdXkFo--38rRKSpGTb8U58KavPzmm7vwwdN6_SP01Zxt8w@mail.gmail.com>
	<CAFLxGvzof00w3ah4kenjfK=6_ydP6NN6PRsaUjMnwDLH8hzEOw@mail.gmail.com>
Date: Wed, 12 Nov 2014 11:22:21 +0100
X-Google-Sender-Auth: Wn9WuZEq27H4kvFKfYgDxLXTT9M
Message-ID: <CAMuHMdWP=9c4w2-H1QGT37qePZzZ8TL-vGuCRB00CH6+60LZkA@mail.gmail.com>
Subject: Re: [uml-devel] Build regressions/improvements in v3.18-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:19 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
>>   + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD'
>> undeclared (first use in this function):  => 378
>>   + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each
>> undeclared identifier is reported only once:  => 378
>>   + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each
>> function it appears in.):  => 378
>
> I've never seen this failure.
> Both 3.18-rc3/4 x86_64/i386 build fine here.
>
> What toolchain are you using?
> It looks like AT_FDCWD is missing on your host side.

There's obviously more wrong with the host side:
http://kisskb.ellerman.id.au/kisskb/buildresult/12305953/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
