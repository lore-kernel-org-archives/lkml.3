Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3CYPCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:02:37 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:41825 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3CYPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:02:36 -0400
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2013 11:02:36 EDT
Date: Mon, 25 Mar 2013 15:34:38 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        tanzilli@acmesystems.it, dgilbert@interlog.com,
        Robert.Nelson@digikey.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91: add Acme Systems Aria G25 board
Message-ID: <20130325143438.GB20693@game.jcrosoft.org>
References: <1364201369-12047-1-git-send-email-nicolas.ferre@atmel.com>
 <20130325122220.GF2001@game.jcrosoft.org>
 <51505B26.7040508@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51505B26.7040508@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7024208045103033196
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrieejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrieejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:11 Mon 25 Mar     , Nicolas Ferre wrote:
> On 03/25/2013 01:22 PM, Jean-Christophe PLAGNIOL-VILLARD :
> > On 09:49 Mon 25 Mar     , Nicolas Ferre wrote:
> >> From: Douglas Gilbert <dgilbert@interlog.com>
> >>
> >> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  arch/arm/boot/dts/ariag25.dts | 168 ++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 168 insertions(+)
> >>  create mode 100644 arch/arm/boot/dts/ariag25.dts
> >>
> >> diff --git a/arch/arm/boot/dts/ariag25.dts b/arch/arm/boot/dts/ariag25.dts
> >> new file mode 100644
> >> index 0000000..d18ef50
> >> --- /dev/null
> >> +++ b/arch/arm/boot/dts/ariag25.dts
> >> @@ -0,0 +1,168 @@
> >> +/*
> >> + * ariag25.dts - Device Tree file for Acme Systems Aria G25 (AT91SAM9G25 based)
> >> + *
> >> + * Copyright (C) 2013 Douglas Gilbert <dgilbert@interlog.com>,
> >> + *                    Robert Nelson <robertcnelson@gmail.com>
> >> + *
> >> + * Licensed under GPLv2 or later.
> >> + */
> >> +/dts-v1/;
> >> +/include/ "at91sam9g25.dtsi"
> >> +
> >> +/ {
> >> +	model = "Acme Systems Aria G25";
> >> +	compatible = "acme,ariag25", "atmel,at91sam9g25ek", "atmel,at91sam9x5ek",
> >> +		     "atmel,at91sam9x5", "atmel,at91sam9";
> > I doube the code is compatible with the 9g25ek
> > 
> > specially when you do not include it
> 
> Ok, I remove it.
> 
> >> +
> >> +	aliases {
> >> +		serial4 = &usart3;
> >> +		serial5 = &uart0;
> >> +	};
> > you need to specify all
> 
> Well I do not think so: other are taken from
> 
> /include/ "at91sam9g25.dtsi"
if I touch the dtsi then I break the Aria

if you modify the alias do it on all

Best Regards,
J.
> 
> Bye,
> -- 
> Nicolas Ferre
