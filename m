Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3FAUsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 16:48:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45150 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3FAUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 16:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130601190328.GL16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
	<51A88C3F.5080109@metafoo.de>
	<20130601190328.GL16790@sirena.org.uk>
Date: Sat, 1 Jun 2013 22:48:05 +0200
X-Google-Sender-Auth: l1cvKT4UrgiSNqE4-_4Vpl9fuUo
Message-ID: <CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
Subject: Re: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 9:03 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, May 31, 2013 at 01:40:47PM +0200, Lars-Peter Clausen wrote:
>> Mark can you queue it up in your topic/blackfin branch?
>
> Only if someone were to send me the patch.  Geert, you should *ALWAYS*
> CC maintainers.

Sorry, I sent it to your Wolfson address, as suggested by get_maintainter.pl:

Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/4=75%)

You don't receive email there anymore? BTW, the Wolfson address is still listed
in 2 sections of MAINTAINERS.

I've forwarded the original email to your kernel.org address.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
