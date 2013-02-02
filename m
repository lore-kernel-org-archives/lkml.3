Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab3BBRRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 12:17:31 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56473 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab3BBRR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 12:17:27 -0500
Message-ID: <510D4A10.9040404@mvista.com>
Date: Sat, 02 Feb 2013 21:17:04 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Felipe Balbi <balbi@ti.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <510C1D0E.6030401@mvista.com> <20130201185820.GE29898@arwen.pp.htv.fi> <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <510C58DF.3010103@mvista.com> <20130202004455.GX2637@n2100.arm.linux.org.uk> <510C7554.3060800@mvista.com> <20130202101851.GY2637@n2100.arm.linux.org.uk> <510D3E7E.6000707@mvista.com> <20130202164522.GC2637@n2100.arm.linux.org.uk>
In-Reply-To: <20130202164522.GC2637@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2013 20:45, Russell King - ARM Linux wrote:

>>> There are two people on this thread CC list who were also involved or
>>> CC'd on the mails from the thread in 2010...  Tony and Felipe.
>>> Unfortunately, the person who agreed to do the work is no longer in the
>>> land of the living.  Yes I know it's inconvenient for people to die
>>> when they've still got lots of important work to do but that's what can
>>> happen...

>>     Hm... wasn't it David Brownell? He's the only person who I know has
>> died recently who has dealt with DaVinci, MUSB and the releated stuff.

> Actually, it wasn't David who was going to do it - that's where the email
> thread gets messy because the mailer David was using makes no distinction
> in text format between what bits of text make up the original email being
> replied to, and which bits of text are written by David.

    Hm, strange...

> It might have been Felipe; there appears to be an email from Felipe saying
> that as the immediate parent to David's email.  But that's not really the
> point here.  The point is that _someone_ agreed to put the work in, and
> _that_ agreement is what caused the patch to be discarded.

> And, as I've already explained, you brought up the subject of it being
> discarded shortly after, and it got discussed there _again_, and the
> same things were said _again_ by at least two people about it being in
> drivers/dma.

    It wasn't said that somebody concrete was going to work on it. I had to 
explcitly write an email laying all further responsibility on CPPI 4.1 support 
on TI back then.

> But anyway, that's all past history.  What was said back then about it
> being elsewhere in the tree is just as relevant today as it was back
> then.  The only difference is that because that message wasn't received,
> it's now two years later with no progress on that.  And that's got
> *nothing* what so ever to do with me.

    Yes, of course. In my original mail that started the discussion I said 
that we have to wait indefinitely for TI to write the new DMA driver. I just 
wondered wouldn't it be better to use the same approach as for EDMA with 
transitioning to drivers/dma/ step by step.

> I know people like to blame me just because I'm apparantly the focus of
> the blame culture, but really this is getting beyond a joke.

> So, I want an apology from you for your insistance that I'm to blame
> for this.

    OK, I apologise if you consider yourself the target of my blame. My aim 
was rather to establish the truth about that decision taken back in Dec 2010 
-- which we seem to have achieved.

> Moreover, _I_ want to know what is going to happen in the
> future with this so that I don't end up being blamed anymore for the
> lack of progress on this issue.

    Nothing. My blame for the lack of progress has long been laid on TI, after 
I explictly passed the responsibility for the driver to them. My intent with 
the mail that started the discussion was to probe whether we still have 
another opportunity of having MUSB DMA support for OMAP-L1x and Sitara. I just 
thought that you might have changed your mind somehow on the matter.

WBR, Sergei

