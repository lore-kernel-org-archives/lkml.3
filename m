Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3FAV3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:29:25 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63171 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3FAV3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130601211045.GV16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
	<51A88C3F.5080109@metafoo.de>
	<20130601190328.GL16790@sirena.org.uk>
	<CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
	<20130601211045.GV16790@sirena.org.uk>
Date: Sat, 1 Jun 2013 23:29:23 +0200
X-Google-Sender-Auth: HA7Qt4G5DwlfpFJ2o3uqydwoSHs
Message-ID: <CAMuHMdWN6Ur47fBu3oZpah4fTaV+mV4Y_Q=SvV_jet-3FiZEUQ@mail.gmail.com>
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

On Sat, Jun 1, 2013 at 11:10 PM, Mark Brown <broonie@kernel.org> wrote:
> On Sat, Jun 01, 2013 at 10:48:05PM +0200, Geert Uytterhoeven wrote:
>> On Sat, Jun 1, 2013 at 9:03 PM, Mark Brown <broonie@kernel.org> wrote:
>> > Only if someone were to send me the patch.  Geert, you should *ALWAYS*
>> > CC maintainers.
>
>> Sorry, I sent it to your Wolfson address, as suggested by get_maintainter.pl:
>
>> Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/4=75%)
>
> You're not using a current version of the tree you're submitting
> against (which you should always do)...

I'm using next-20130531.

>> I've forwarded the original email to your kernel.org address.
>
> Please submit the patch normally so that it can be applied by tools
> without hand editing.

Two acks added and resubmitted to the new address.
Thanks for applying!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
