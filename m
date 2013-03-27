Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3C0Q2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:28:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:59896 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3C0Q2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:28:03 -0400
Message-ID: <1364398023.11644.42.camel@pasglop>
Subject: Re: [PATCH] powerpc: remove PReP
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Paul Mackerras <paulus@samba.org>,
        Rob Landley <rob@landley.net>, Adam Belay <abelay@mit.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 27 Mar 2013 16:27:03 +0100
In-Reply-To: <CAMuHMdVs-Xxu9e=8WZbTBXE1_+iYOBKODgj9_EKmVbZA3z=8JA@mail.gmail.com>
References: <1363864206.1390.117.camel@x61.thuisdomein>
	 <20130322042159.GC26908@concordia>
	 <1364381223.1345.18.camel@x61.thuisdomein>
	 <CAMuHMdVs-Xxu9e=8WZbTBXE1_+iYOBKODgj9_EKmVbZA3z=8JA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 13:05 +0100, Geert Uytterhoeven wrote:
> On Wed, Mar 27, 2013 at 11:47 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > 3) I removed two files in documentation that are almost entirely PReP
> > specific. The remaining lines looked uninteresting.
> 
> > --- a/Documentation/powerpc/sound.txt
> > +++ /dev/null
> 
> > -2. IBM CHRP
> > -
> > -  I have only tested this on the 43P-150.  Build the kernel with the cs4232
> > -  set as a module and load the module with irq=9 dma=1 dma2=2 io=0x550
> 
> This section is CHRP-specific. The cs4232 driver also worked on the
> CHRP LongTrail.
> But I don't remember if the parameter values above also applied to LongTrail.
> I do remember it didn't work without specifing the right parameters, so you
> probably want to keep this section.

Isn't LongTrail support LongDead ? Can we still boot these things at
all ? Anybody still has a functional one ?

Cheers,
Ben.

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds


