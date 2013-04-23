Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3DWOfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:35:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58271 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab3DWOfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:35:00 -0400
Date: Tue, 23 Apr 2013 16:34:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Takashi Iwai <tiwai@suse.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130423143458.GB4390@pd.tnic>
References: <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <s5hfvyj55ke.wl%tiwai@suse.de>
 <20130422091310.GA4637@pd.tnic>
 <s5hzjwq53ec.wl%tiwai@suse.de>
 <alpine.LFD.2.02.1304221432570.21884@ionos>
 <20130422142356.GA4658@pd.tnic>
 <20130422144402.GK3509@linux.vnet.ibm.com>
 <20130422213303.GB4415@pd.tnic>
 <alpine.LFD.2.02.1304231524320.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304231524320.21884@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 04:10:22PM +0200, Thomas Gleixner wrote:
> On Mon, 22 Apr 2013, Borislav Petkov wrote:
> > [ 1449.134864] ACPI: Preparing to enter system sleep state S5
> > [ 1449.141054] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> 
> and right after that the spurious interrupt happens. I asked Boris to
> boot with acpi_osi=Linux on the command line and the issue went
> away, though now it complains right before shutdown about:
> 
> [  123.142377] do_IRQ: 2.179 No irq handler for vector (irq -1)
> 
> I wouldn't be surprised if that vector 179 was previously used for
> irq16.
> 
> Without acpi_osi=Linux the BIOS manages to put the hardware into a
> state which causes an interrupt to be sent from thin air.
> 
> We should have an annual "Brain Is Obviously Superfluous" award.
> This one would be high up on the nomination list.

Yep, crack must've particularly cheap during that time so the monkeys
went and bought double the amount of bags and did hit new levels of
SNAFU with an excessive, couple-of-days binge of smoking and typing into
their keyboards.

They probably looked like that while at it:
http://devopsreactions.tumblr.com/post/47851533209/learning-linux

Oh boy, this is a new low in my BIOS-f*ckups collection.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
