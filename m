Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3FBIEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 04:04:55 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63712 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3FBIEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 04:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130601220627.GW16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
	<51A88C3F.5080109@metafoo.de>
	<20130601190328.GL16790@sirena.org.uk>
	<CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
	<20130601211045.GV16790@sirena.org.uk>
	<CAMuHMdWN6Ur47fBu3oZpah4fTaV+mV4Y_Q=SvV_jet-3FiZEUQ@mail.gmail.com>
	<20130601220627.GW16790@sirena.org.uk>
Date: Sun, 2 Jun 2013 10:04:42 +0200
X-Google-Sender-Auth: gj75EniVfofukhoEwK4G9TRo6z8
Message-ID: <CAMuHMdWuQRi2PeFT2BeuRkZacvtfkgfe8ebgOS+kRCEt8X71rw@mail.gmail.com>
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

Hi Mark,

On Sun, Jun 2, 2013 at 12:06 AM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Jun 01, 2013 at 11:29:23PM +0200, Geert Uytterhoeven wrote:
>> On Sat, Jun 1, 2013 at 11:10 PM, Mark Brown <broonie@kernel.org> wrote:
>
>> >> Sorry, I sent it to your Wolfson address, as suggested by get_maintainter.pl:
>
>> >> Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/4=75%)
>
>> > You're not using a current version of the tree you're submitting
>> > against (which you should always do)...
>
>> I'm using next-20130531.
>
> Which has broonie@kernel.org listed as the maintainer address...  the

Sure, but not for arch/blackfin/.

> commit signer information isn't awfully reliable at the best of times,
> it's got a big tendency to throw up false positives for things like
> people doing cleanup work.

Yeah, that's unfortunate.

But in this case, the commit was commited with a SoB using your old
email address, only 5 days ago. So you may still have a stale
.gitconfig somewhere:

commit 15502e0ca0da651b48c7def2983e7bb464349b2a
Author: Lars-Peter Clausen <lars@metafoo.de>
Date:   Tue May 28 19:22:18 2013 +0200

    blackfin: Remove references to the bf5x_tdm driver

    The bf5x_tdm driver has been removed. Remove all references to it from board
    code.

    Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
