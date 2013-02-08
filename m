Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946982Ab3BHUEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:04:22 -0500
Received: from relais.videotron.ca ([24.201.245.36]:52790 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946873Ab3BHUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:04:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 08 Feb 2013 15:04:19 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kim Phillips <kim.phillips@freescale.com>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
In-reply-to: <1360344301.6066.263.camel@shinybook.infradead.org>
Message-id: <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
References: <20130129181046.GC25415@pd.tnic>
 <1359541333.3529.186.camel@shinybook.infradead.org>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
 <20130131092801.GV23505@n2100.arm.linux.org.uk>
 <20130131145947.f62474a0600848df86548b96@freescale.com>
 <20130201011712.GF23505@n2100.arm.linux.org.uk>
 <1359703995.23531.6.camel@shinybook.infradead.org>
 <20130205210436.670c62e26d2121330e87af35@freescale.com>
 <1360141322.6066.4.camel@shinybook.infradead.org>
 <20130206191905.ac8eb6743e69425f30888704@freescale.com>
 <20130207181315.GM17833@n2100.arm.linux.org.uk>
 <1360344301.6066.263.camel@shinybook.infradead.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Woodhouse, David wrote:

> On Thu, 2013-02-07 at 18:13 +0000, Russell King - ARM Linux wrote:
> > 
> > However, the biggest reason not to use libgcc is that we want to control
> > what gets used in the kernel - for example, no floating point, and no
> > use of 64 x 64bit division.
> 
> Which is all very sensible. But there's no particular reason we couldn't
> add a __bswap[sd]i2 to the kernel's version of libgcc if we wanted to.

Absolutely.


Nicolas
