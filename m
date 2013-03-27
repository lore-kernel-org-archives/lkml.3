Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3C0MF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:05:27 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62251 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3C0MFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <1364381223.1345.18.camel@x61.thuisdomein>
References: <1363864206.1390.117.camel@x61.thuisdomein>
	<20130322042159.GC26908@concordia>
	<1364381223.1345.18.camel@x61.thuisdomein>
Date: Wed, 27 Mar 2013 13:05:24 +0100
X-Google-Sender-Auth: tx8jNUDDLqUO1nCosY6PUkUa7oA
Message-ID: <CAMuHMdVs-Xxu9e=8WZbTBXE1_+iYOBKODgj9_EKmVbZA3z=8JA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: remove PReP
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Rob Landley <rob@landley.net>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:47 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> 3) I removed two files in documentation that are almost entirely PReP
> specific. The remaining lines looked uninteresting.

> --- a/Documentation/powerpc/sound.txt
> +++ /dev/null

> -2. IBM CHRP
> -
> -  I have only tested this on the 43P-150.  Build the kernel with the cs4232
> -  set as a module and load the module with irq=9 dma=1 dma2=2 io=0x550

This section is CHRP-specific. The cs4232 driver also worked on the
CHRP LongTrail.
But I don't remember if the parameter values above also applied to LongTrail.
I do remember it didn't work without specifing the right parameters, so you
probably want to keep this section.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
