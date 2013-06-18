Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3FRIh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:37:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60376 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3FRIhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130617143851.480d327256b7cb54f292e147@linux-foundation.org>
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com>
	<CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com>
	<CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com>
	<20130617133055.20463ce157e104af15ef60a1@linux-foundation.org>
	<51BF7610.10803@caviumnetworks.com>
	<20130617135920.587959a34da85d7940a6936f@linux-foundation.org>
	<51BF7ABD.3080508@caviumnetworks.com>
	<20130617141310.3d62ea2b05041ec5974f9525@linux-foundation.org>
	<51BF7EE9.8060308@caviumnetworks.com>
	<20130617143851.480d327256b7cb54f292e147@linux-foundation.org>
Date: Tue, 18 Jun 2013 10:37:54 +0200
X-Google-Sender-Auth: pxrNHuakX7PChyFtgRJEFmJy7WE
Message-ID: <CAMuHMdUf9VRZKosS_L++BYOOs+mVKVow8aAqAcGK8TFgkBGPhg@mail.gmail.com>
Subject: Re: Linux 3.10-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <david.daney@cavium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:38 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> Once you fix the name of 'flags', I hope you don't run into the same
>> Include Hell on ia64 and mn10300 that I did.
>
> I build-tested ia64.  I don't have an mn10300 cross-compiler set up.

Both mn10300 defconfigs build fine with it, so
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

FWIW, Tony's collection has one at
https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

It's called am33_2.0-linux-gcc, not mn10300-linux-gcc.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
