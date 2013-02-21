Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3BUR10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:27:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:22440 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3BUR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:27:25 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_xqHTUGWJHSv0znYbUuqr2Q)"
Date: Thu, 21 Feb 2013 12:27:24 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: Kim Phillips <kim.phillips@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
In-reply-to: <1361464675.24822.53.camel@i7.infradead.org>
Message-id: <alpine.LFD.2.03.1302211226241.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <20130207181315.GM17833@n2100.arm.linux.org.uk>
 <1360344301.6066.263.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
 <1360363233.6066.283.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
 <1361356696.13482.269.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
 <1361367842.13482.279.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
 <1361372008.13482.280.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
 <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
 <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
 <1361464675.24822.53.camel@i7.infradead.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_xqHTUGWJHSv0znYbUuqr2Q)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Thu, 21 Feb 2013, Woodhouse, David wrote:

> On Wed, 2013-02-20 at 23:29 -0500, Nicolas Pitre wrote:
> > > > On Wed, 20 Feb 2013, Woodhouse, David wrote:
> > > > > For today's compilers, unless the wind changes.
> >  … 
> > Crap.  OK, assembly code is the way to go then.
> 
> How quickly the wind changes, these days. I blame global warming. :)

Only fools don't believe global warming.


Nicolas

--Boundary_(ID_xqHTUGWJHSv0znYbUuqr2Q)--
