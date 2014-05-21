Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaEUWIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:08:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55085 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaEUWIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:08:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DI1bM8hTrmzwTKTw+hV+m
Date: Wed, 21 May 2014 15:08:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140521220807.GB14520@atomide.com>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
 <20140521182513.GA26285@earth.universe>
 <20140521184319.GL17417@atomide.com>
 <20140521194527.GM17417@atomide.com>
 <20140521215055.GA26362@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521215055.GA26362@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@kernel.org> [140521 14:51]:
> On Wed, May 21, 2014 at 12:45:28PM -0700, Tony Lindgren wrote:
> 
> Right. The only documentation of the SSI module is existing
> code sent by Carlos / included in the maemo kernel.

That's probably better than any documentation though :)
 
> > > It's probably something with the sysc or idlemodes that
> > > keeps things from idling. Maybe wrong address? Or wrong
> > > flags? I'm pretty sure it was the first .dts patch out of
> > > these two as the second one alone did not apply.
> > 
> > Hmm yeah below is probably how it should be, does this
> > work for you? With this fix applied and your ssi dts
> > patches n900 keeps hitting off-idle for me.
> 
> I can confirm, that the N900 hits idle states when the DT
> patch and the hwmod patch is applied. I have not actually
> tested if it also works without your hwmod patch.
> 
> There are still problems with the idle state if the driver is
> actually loaded (and I see 100% runtime pm usage in powertop),
> but that can be fixed later.
> 
> Feel free to add Tested-by/Acked-By to the hwmod patch.

OK thanks for testing. I'll apply your dts changes as soon
as I have an ack from Paul on the hwmod changes. Probably
best to queue them together to avoid PM breaking.

Regards,

Tony
