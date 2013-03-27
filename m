Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3C0VMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:12:17 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23617 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518Ab3C0VMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:12:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+LAQiFs9QAH8QCqZrqO05j
Date: Wed, 27 Mar 2013 14:12:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Nishanth Menon <nm@ti.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
Message-ID: <20130327211208.GQ10155@atomide.com>
References: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg>
 <201303241526.59275@pali>
 <20130327205606.GN10155@atomide.com>
 <201303272205.17182@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303272205.17182@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130327 14:09]:
> On Wednesday 27 March 2013 21:56:07 Tony Lindgren wrote:
> > * Pali Rohár <pali.rohar@gmail.com> [130324 07:31]:
> > > it is possible to upstream errata 430973 workaround for
> > > RX-51?
> > 
> > I think we should make the SMC handling a generic function for
> > ARM.
> > 
> > AFAIK just the SMC call numbering is different for various
> > implementations. So the handler and passing of the parameters
> > seems like it should be generic.
> > 
> 
> Not only, look at freemangordon's email: 
> https://lkml.org/lkml/2013/3/1/62

Seem like you may need some SoC specific wrapper to the
generic function to deal with the params. But still seems
like we can have an ARM generic smc funtion.

Regards,

Tony
