Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3EMKSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:18:12 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56817 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3EMKSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyKANuy_vezO+E1aL3FzvdjiNgCD3j-BVGSyL_ne015Xw@mail.gmail.com>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
	<CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
	<38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
	<CAFLxGvyKANuy_vezO+E1aL3FzvdjiNgCD3j-BVGSyL_ne015Xw@mail.gmail.com>
Date: Mon, 13 May 2013 12:18:10 +0200
X-Google-Sender-Auth: 86kMkn-o2u4bxrkGBDhtELtUoaI
Message-ID: <CAMuHMdVnbbJDq0vcc4e-NCWFUqgAzv3YU470B3jGFDN0xR+E=A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 12:07 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, May 13, 2013 at 11:54 AM, Michael Ellerman
> <michael@ellerman.id.au> wrote:

>> Possibly. We're cross compiling these on powerpc so perhaps we need to update the cross compiler.
>
> Looks like you are the first man on planet earth who tries do build
> UML/x86 on powerpc. :D

Well, it used to work: http://kisskb.ellerman.id.au/kisskb/target/2974/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
