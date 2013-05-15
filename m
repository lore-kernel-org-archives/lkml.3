Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3EOGuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:50:54 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48813 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3EOGux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:50:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130515125712.a6e04f8dd3345f1f4980e107@canb.auug.org.au>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
	<CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
	<38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
	<CAFLxGvyKANuy_vezO+E1aL3FzvdjiNgCD3j-BVGSyL_ne015Xw@mail.gmail.com>
	<1368447352.10679.0.camel@concordia>
	<20130515125712.a6e04f8dd3345f1f4980e107@canb.auug.org.au>
Date: Wed, 15 May 2013 08:50:51 +0200
X-Google-Sender-Auth: K14O8vaH2sGSzFdjd7vpE10tQr8
Message-ID: <CAMuHMdWQ1_vSrRYBpho6D3gRELihC7x6g6Ni8CLieRXb0D0z1Q@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Tony Breeds <tony@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 4:57 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> So htobe32 etc were introduced in glibc 2.9 - our build environment is
> glibc 2.3 ... Documentation/Changes does not specify a minimum version of
> glibc.

This is a UML "requirement", not a generic Linux build environment
requirement.

Introduced by

commit d824d06328904f610b47652dcd488392f2fc62b6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Apr 5 23:35:03 2012 -0400

    um: switch cow_user.h to htobe{32,64}/betoh{32,64}

    ... rather than open-coding the 64bit versions.  endian.h has those guys.

    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Richard Weinberger <richard@nod.at>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
