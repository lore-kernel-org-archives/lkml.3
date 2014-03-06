Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCFUh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:37:26 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60408 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaCFUhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAGVrzcYQ44fYA0kpRC84Qfe7v0vPGy+euWLfs8xF0XEMnsFmGA@mail.gmail.com>
References: <20140228230017.GE14970@merlin.infradead.org>
	<20140303145137.70819698@tukaani.org>
	<CAGVrzcZ7KU-m9s9KgoigK+WdSqeqwEmm=_pY6qF=ep2vFp6WUg@mail.gmail.com>
	<20140304202038.03b36109@tukaani.org>
	<53169123.4020909@lougher.demon.co.uk>
	<CAGVrzcYQ44fYA0kpRC84Qfe7v0vPGy+euWLfs8xF0XEMnsFmGA@mail.gmail.com>
Date: Thu, 6 Mar 2014 21:37:23 +0100
X-Google-Sender-Auth: dtpdrYErhD2kzQzy-HZSdNddRJw
Message-ID: <CAMuHMdXJ+GKtbCr-fzq2tRf8yUeYmgSA2VpmL2aofybc84Wwog@mail.gmail.com>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Kyle McMartin <kyle@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 4:50 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> I am okay with enabling all filters by default as long as there is a
> knob to allow turning achitecture specific BCJ filters off, as it
> barely makes sense for embedded systems to have a BCJ filter
> implementation for anything but the architecture you are running on.

And for x86? (oh no, I started promoting x86 ;-)

I once tried xz with an initrd on ARM. The kernel complained it couldn't
decompress the initrd, oops. I didn't investigate it at that time, but probably
I didn't have the x86 BCJ filter enabled, while I compressed the initrd on\
amd64.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
