Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaFEHJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:09:55 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46892 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaFEHJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:09:54 -0400
MIME-Version: 1.0
In-Reply-To: <1401938509.17669.9.camel@concordia>
References: <CAMuHMdWwBP6mmWMF3QAvjqo7HQQAB8KZ2QUW5kHZ6iHMMLNYuQ@mail.gmail.com>
	<20140604182812.6ec4b06b@canb.auug.org.au>
	<1401938509.17669.9.camel@concordia>
Date: Thu, 5 Jun 2014 09:09:53 +0200
X-Google-Sender-Auth: Z4x26aYi7yFm9nwRTIaYiUFFBWg
Message-ID: <CAMuHMdUy9c75uYS9-xVkOofZqH6zc1coxncV8LYZiuCSK7J6PA@mail.gmail.com>
Subject: Re: kisskb not updated?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Jun 5, 2014 at 5:21 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Wed, 2014-06-04 at 18:28 +1000, Stephen Rothwell wrote:
>> On Wed, 4 Jun 2014 10:21:06 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > kisskb.ellerman.id.au/kisskb/head/page1/ doesn't seem to be updated
>> > anymore? E.g. v3.15-rc8 is missing.
>>
>> Yeah, our machine room suffered an airconditioning failure and our
>> build host is one of the machines that we can't afford to run at the
>> moment.
>
> Yeah sorry I was going to put up an "Out of order" notice, but then there was
> talk of restarting the server, but then that never happened.
>
> Not sure what the ETA is at the moment.

OK, will wait and see...

My first thought was: Oh no, it crashed due to the new "next" branch in
Linus' repo ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
