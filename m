Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbbAETYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:24:17 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33940 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbbAETYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:24:16 -0500
Date: Mon, 5 Jan 2015 20:24:06 +0100
From: Piotr Kubus <p.t.kubus@gmail.com>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: dmm32at: Fixed a code indent issue
Message-ID: <20150105192406.GA2686@PiotrekLap>
References: <1420384955-27336-1-git-send-email-p.t.kubus@gmail.com>
 <20150104223129.GF25819@t400>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150104223129.GF25819@t400>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 11:31:29PM +0100, Konrad Zapalowicz wrote:
> On 01/04, Piotr Kubus wrote:
> > This is a patch to the dmm32at.c file that fixes up a code indent error found by the checkpatch.pl tool.
> 
> Nice however improve your commit message. The rule is that the lines
> should wrap at 72nd column except for quoted material such as compiler
> output, etc...
> 
> The 72-character columns are important for allowing quoting and they
> play nicely with standard indentation from git log.

Hey,

I couldn't find that rule in Kernel documentation. Besides there were no
complaints from checkpatch.pl tool.

Do you mean I should resend it or wait for reply from maintainer first?

Regards,
Piotr

> 
> Thanks,
> Konrad
> 
> > Signed-off-by: Piotr Kubus <p.t.kubus@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/dmm32at.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
> > index 6df298a..31919b8 100644
> > --- a/drivers/staging/comedi/drivers/dmm32at.c
> > +++ b/drivers/staging/comedi/drivers/dmm32at.c
> > @@ -365,7 +365,7 @@ static void dmm32at_setaitimer(struct comedi_device *dev, unsigned int nansec)
> >  	/* enable the ai conversion interrupt and the clock to start scans */
> >  	outb(DMM32AT_INTCLK_ADINT |
> >  	     DMM32AT_INTCLK_CLKEN | DMM32AT_INTCLK_CLKSEL,
> > -             dev->iobase + DMM32AT_INTCLK_REG);
> > +	     dev->iobase + DMM32AT_INTCLK_REG);
> >  }
> >  
> >  static int dmm32at_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
> > -- 
> > 1.9.1
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
