Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3G3Rao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:30:44 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39801 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3G3Ram (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:30:42 -0400
Date: Tue, 30 Jul 2013 13:27:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130730172718.GA2509@tuxdriver.com>
References: <2460092.aLmjrOVh1g@flatron>
 <51F3A82E.2000907@broadcom.com>
 <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
 <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
 <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com>
 <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
 <1374988276.1973.29.camel@dabdike>
 <20130730014453.GJ29970@voom.fritz.box>
 <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com>
 <51F7EA35.6070501@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F7EA35.6070501@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:30:45AM -0600, Stephen Warren wrote:
> On 07/29/2013 08:15 PM, jonsmirl@gmail.com wrote:
> > On Mon, Jul 29, 2013 at 9:44 PM, David Gibson
> > <david@gibson.dropbear.id.au> wrote:
> ...
> >> I also think we should consider the option of having a simple and
> >> straightforward schema language which handles, say, 80% of cases with
> >> a fall back to C for the 20% of curly cases.  That might actually be
> >> simpler to work with in practice than a schema language which can
> >> express absolutely anything, at the cost of being awkward for simple
> >> cases or difficult to get your head around.
> > 
> > Would C++ work? You can use operating overloading and templates to
> > change the syntax into something that doesn't even resemble C any
> > more.
> 
> From my perspective, that's precisely why C++ should /not/ be used.

Amen.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
