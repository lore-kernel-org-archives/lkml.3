Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaL3GZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 01:25:26 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48018 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaL3GZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 01:25:24 -0500
Date: Tue, 30 Dec 2014 11:55:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: David Decotigny <ddecotig@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremiah Mahler <jmmahler@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH v2] staging: comedi: dmm32at: fix style issues
Message-ID: <20141230062513.GA3597@sudip-PC>
References: <1419539308-19059-1-git-send-email-ddecotig@gmail.com>
 <20141227070027.GA4780@sudip-PC>
 <CAG88wWZjqr8U=TtSaTGHnn=05d2QFQ3en7ndeK2sPq+-PFT=0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG88wWZjqr8U=TtSaTGHnn=05d2QFQ3en7ndeK2sPq+-PFT=0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 03:12:53PM -0800, David Decotigny wrote:
> thanks! I have a preference for the v2 I sent: my $EDITOR handles the
> indentation for me; using 2 tabs forces me to manually override my editor's
> behavior. But if there is a strong push for a v3 of this patch with 2 tabs
> instead of current v2 indentation, I'll do it, please let me know.

well, if you check CodingStyle in Documentation, it clearly says: 
"Outside of comments, documentation and except in Kconfig, spaces are never
used for indentation".

Sudip

> 
> On Fri, Dec 26, 2014 at 11:00 PM, Sudip Mukherjee <
> sudipm.mukherjee@gmail.com> wrote:
> 
> > On Thu, Dec 25, 2014 at 12:28:28PM -0800, David Decotigny wrote:
> > > Before:
> > >       1 ERROR: code indent should use tabs where possible
> > >       1 WARNING: please, no spaces at the start of a line
> > >
> > > After:
> > >   (none)
> > >
> > > Signed-off-by: David Decotigny <ddecotig@gmail.com>
> > > ---
> > >  drivers/staging/comedi/drivers/dmm32at.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/staging/comedi/drivers/dmm32at.c
> > b/drivers/staging/comedi/drivers/dmm32at.c
> > > index 6df298a..31919b8 100644
> > > --- a/drivers/staging/comedi/drivers/dmm32at.c
> > > +++ b/drivers/staging/comedi/drivers/dmm32at.c
> > > @@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device
> > *dev, unsigned int nansec)
> > >       /* enable the ai conversion interrupt and the clock to start scans
> > */
> > >       outb(DMM32AT_INTCLK_ADINT |
> > >            DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> > > -             dev->iobase + DMM32AT_INTCLK_REG);
> > > +          dev->iobase + DMM32AT_INTCLK_REG);
> >
> > another suggestion:
> > if you do like the following patch (use 2 tabs) then you do not need to
> > give spaces to indent the code.
> >
> > diff --git a/drivers/staging/comedi/drivers/dmm32at.c
> > b/drivers/staging/comedi/drivers/dmm32at.c
> > index 6df298a..cedf8ed 100644
> > --- a/drivers/staging/comedi/drivers/dmm32at.c
> > +++ b/drivers/staging/comedi/drivers/dmm32at.c
> > @@ -364,8 +364,8 @@ static void dmm32at_setaitimer(struct comedi_device
> > *dev, unsigned int nansec)
> >
> >         /* enable the ai conversion interrupt and the clock to start scans
> > */
> >          outb(DMM32AT_INTCLK_ADINT |
> > -            DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> > -             dev->iobase + DMM32AT_INTCLK_REG);
> > +               DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> > +               dev->iobase + DMM32AT_INTCLK_REG);
> >  }
> >
> >  static int dmm32at_ai_cmd(struct comedi_device *dev, struct
> > comedi_subdevice *s)
> >
> >
> > thanks
> > sudip
> >
> > >  }
> > >
> > >  static int dmm32at_ai_cmd(struct comedi_device *dev, struct
> > comedi_subdevice *s)
> > > --
> > > 2.2.0.rc0.207.ga3a616c
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> >
