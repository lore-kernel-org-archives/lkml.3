Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaB0JWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:22:17 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:65466 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaB0JWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <530E9A43.5030003@hurleysoftware.com>
References: <530E6F76.1070605@zytor.com>
	<20140226232859.GA9213@kroah.com>
	<530E82B2.3040305@zytor.com>
	<530E9A43.5030003@hurleysoftware.com>
Date: Thu, 27 Feb 2014 10:22:13 +0100
X-Google-Sender-Auth: pd4pUz_v4gyejHy48aC9KD5Swis
Message-ID: <CAMuHMdWU75-+eUzt-35VvFvUqCkhM0Hs=xZki167+GCiRRHWXA@mail.gmail.com>
Subject: Re: The sheer number of sparse warnings in the kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Ellerman <michael@ellerman.id.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 2:52 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> The bigger question, again, is what do we need to do to make this
>> happen, assuming it is worth doing?  We certainly have had bugs,
>> including security holes, which sparse would have caught.  At the same
>> time, this kind of work tends to not be the kind that attract the top
>> hackers, unfortunately, as it is not "fun".
>
> Well there was that "should we do a bug-fix-only 4.0 release?" message
> from Linus back at the 3.12 release.
>
> Or do like Geert does with the build message regressions/fixes. I always
> scan
> that to make sure none of my work is in it :)  (And that could be chunked
> up by maintainer).

A quick test shows that my scripts would catch (many) sparse errors and
warnings too, iff they would be in the kissb build logs.

So as soon as kissb starts building with C=1, we can start tracking sparse
regressions. The first report would contain _lots_ of regressions, though ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
