Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967046AbaFTLUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:20:21 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:50850 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966627AbaFTLUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <53A41720.9020609@mev.co.uk>
References: <CAMuHMdVhU6JZFzuPkx=wtLcPYc7wwaMFwCrZu=zG7PmCYssy-g@mail.gmail.com>
	<53A41720.9020609@mev.co.uk>
Date: Fri, 20 Jun 2014 13:20:16 +0200
X-Google-Sender-Auth: mpM9EMf49tDF9AFcIOvpbPsFgzI
Message-ID: <CAMuHMdXiwJqCHP0+BPaVn2f2B4eTe957Vun=2ue6FOZk60kPKw@mail.gmail.com>
Subject: Re: [-next] comedi I/O accessor name clashes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Fri, Jun 20, 2014 at 1:12 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
>> drivers/staging/comedi/drivers/ni_atmio.c:318:38: error: macro
>> "writew" passed 3 arguments, but takes just 2

> Thanks, but Hartley has already fixed it and Greg has applied it to his
> staging-next branch.  It should wend it's merry way to linux-next in the
> not-too-distant future.

Thanks, good to hear that!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
