Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3AYNHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:07:10 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49122 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932174Ab3AYNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:07:08 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Tcn52zKhOp57Z2NzF5NUDeH2Z5DQoODk=
Date: Fri, 25 Jan 2013 08:07:02 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Roland Stigge <stigge@antcom.de>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 3/3] arm: mvebu: enable gpio expander over i2c on
 Mirabox platform
Message-ID: <20130125130702.GK1758@titan.lakedaemon.net>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
 <1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
 <CACRpkdbBOQ_KE001kfORapo9=WiJYn04MmRhxnn-5v8ki-EeyA@mail.gmail.com>
 <20130125124659.GH1758@titan.lakedaemon.net>
 <CACRpkdZBcAK+9zYSJ2jQhOxNMF-BbO1-5FsRLoJRHH5X9M09VQ@mail.gmail.com>
 <CACRpkdYdC5HVEOUEL0LS_ecXSiUNymaL5tfWw7STJtcsSosNTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYdC5HVEOUEL0LS_ecXSiUNymaL5tfWw7STJtcsSosNTg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 01:57:51PM +0100, Linus Walleij wrote:
> On Fri, Jan 25, 2013 at 1:55 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Fri, Jan 25, 2013 at 1:46 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> >> On Fri, Jan 25, 2013 at 09:17:57AM +0100, Linus Walleij wrote:
> >>> On Tue, Jan 22, 2013 at 10:10 PM, Gregory CLEMENT
> >>> <gregory.clement@free-electrons.com> wrote:
> >>>
> >>> > The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
> >>> > through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
> >>> > expansion IC to provide 40-bit parallel input/output GPIOs. This patch
> >>> > enable the use of this expander on the Mirabox.
> >>> >
> >>> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> >>> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >>>
> >>> So as requested I leave this patch for now, tell me if you want it
> >>> applied through pinctrl.
> >>
> >> Which branch did you put the first two on?  I'm not seeing them.
> >
> > Not pushed yet, take it easy.
> 
> Or yeah, they are there:
> http://git.kernel.org/?p=linux/kernel/git/linusw/linux-gpio.git;a=shortlog;h=refs/heads/devel

Ahh, I had your pinctrl tree as a remote, but not gpio.  Fixed, thanks.

Jason.
