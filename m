Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab3C1Pxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:53:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29954 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3C1Pxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:53:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+e+968f5MX/1AhXnxumJpj
Date: Thu, 28 Mar 2013 08:53:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Nishanth Menon <nm@ti.com>, linux-kernel@vger.kernel.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130328155330.GS10155@atomide.com>
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg>
 <20130306175120.GP11806@atomide.com>
 <201303062013.16302@pali>
 <201303241526.59275@pali>
 <20130327205606.GN10155@atomide.com>
 <20130328095011.GS30923@n2100.arm.linux.org.uk>
 <5154165C.4050604@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5154165C.4050604@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Santosh Shilimkar <santosh.shilimkar@ti.com> [130328 03:10]:
> On Thursday 28 March 2013 03:20 PM, Russell King - ARM Linux wrote:
> > On Wed, Mar 27, 2013 at 01:56:07PM -0700, Tony Lindgren wrote:
> >> * Pali Rohár <pali.rohar@gmail.com> [130324 07:31]:
> >>> it is possible to upstream errata 430973 workaround for RX-51?
> >>
> >> I think we should make the SMC handling a generic function for ARM.
> >>
> >> AFAIK just the SMC call numbering is different for various
> >> implementations. So the handler and passing of the parameters
> >> seems like it should be generic.
> > 
> > SMC calls vary greatly in how they are handled.  The only thing that's
> > generic is issuing the SMC call.  All the setup and what arguments are
> > required are completely different from SoC to SoC.
> > 
> > For example, some SoCs require arguments passed via memory.  Others like
> > OMAP its via registers.
> 
> Exactly. As somebody said on the list, that code looks identical but
> it is not. An SMC with barrier instruction is mostly common and nothing
> more than that.

Thanks all, case closed then. There's no way to come up with a generic
SMC function.

Regards,

Tony
