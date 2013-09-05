Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3IEOJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:09:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45374 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3IEOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130902235853.GD4544@kroah.com>
References: <20130902235853.GD4544@kroah.com>
Date: Thu, 5 Sep 2013 16:09:48 +0200
X-Google-Sender-Auth: NxAkMC1Ny9eNdyKXYKYJ6y6lcNM
Message-ID: <CAMuHMdXfpMJeTPb4e11_oyqH5TRtTxrUMOnL9GKdSjv3VxDFww@mail.gmail.com>
Subject: Re: [GIT PATCH] Staging driver patches for 3.12-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devel@linuxdriverproject.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 1:58 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Here's the bit staging tree pull request for 3.12-rc1.
>
> Lots of staging driver updates, and fixes.  Lustre is finally enabled in
> the build, and lots of cleanup started happening in it.  There's a new

Lustre fails modpost on (at least) 4 architectures due to unexported arch
support functions: m68k, mips, parisc and sparc64 (patches sent).
All 4 failures were not visible in -next due to other build failures :-(

Interestingly, m68k-allmodconfig _succeeded_ on kissb
(http://kisskb.ellerman.id.au/kisskb/buildresult/9458139/), while the
corresponding sparc64 build failed
(http://kisskb.ellerman.id.au/kisskb/buildresult/9458166/).
I have no idea why the m68k build didn't fail there...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
