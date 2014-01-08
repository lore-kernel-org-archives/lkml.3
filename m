Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaAHBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:20:17 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55605 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753284AbaAHBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:20:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Z4QrjNmFjTHHYgYGcwq5r
Date: Tue, 7 Jan 2014 17:19:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>, Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20140108011957.GK5074@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123010850.GN10023@atomide.com>
 <20131123015034.GP10023@atomide.com>
 <20131124212757.7D224C402A3@trevor.secretlab.ca>
 <alpine.DEB.2.02.1312100331460.32309@utopia.booyaka.com>
 <alpine.DEB.2.02.1312302209200.8869@utopia.booyaka.com>
 <CAL_Jsq+X5G94DUn-zFKQkhEy91cdjCyeciny+kDjr=V6EiBHfQ@mail.gmail.com>
 <alpine.DEB.2.02.1401062340240.31394@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401062340240.31394@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [140106 15:43]:
> On Tue, 31 Dec 2013, Rob Herring wrote:
> > On Mon, Dec 30, 2013 at 4:10 PM, Paul Walmsley <paul@pwsan.com> wrote:
> > > On Tue, 10 Dec 2013, Paul Walmsley wrote:
> > >> Is it possible to get this patch, or something similar, merged for
> > >> v3.13-rc?
> > >>
> > >> Once something like PM is broken, it's pretty easy for other broken
> > >> patches to make it into the tree, since it becomes very difficult to test
> > >> without turning into a maintainer denial-of-service attack.
> > >
> > > Ping.  Could you please provide some guidance here about what you'd need
> > > to get this solved for v3.13-rc?
> > 
> > I agree with doing the platform_get_irq modification and feel free to
> > add my ack. I'm going to be offline for the next week.
> 
> Thanks Rob!
> 
> Tony, would you consider sending this patch upstream for v3.13-rc along 
> with your 37xxevm fix patches?

Hmm I'd like to see a proper patch posted for platform_get_irq() by
Thierry as that one is really his patch. And it also had a comment from
Grant.

After that I can queue it if nobody else is picking it as I have a
dependency to it.

Regards,

Tony
