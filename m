Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3G1FLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 01:11:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52056 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab3G1FLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 01:11:19 -0400
Message-ID: <1374988276.1973.29.camel@dabdike>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Sat, 27 Jul 2013 22:11:16 -0700
In-Reply-To: <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	 <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com>
	 <2460092.aLmjrOVh1g@flatron> <51F3A82E.2000907@broadcom.com>
	 <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
	 <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
	 <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com>
	 <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 21:28 -0600, Grant Likely wrote:
> On Sat, Jul 27, 2013 at 2:25 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Sat, Jul 27, 2013 at 2:01 PM, jonsmirl@gmail.com <jonsmirl@gmail.com> wrote:
> >> On Sat, Jul 27, 2013 at 3:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >>> On Sat, Jul 27, 2013 at 4:59 AM, Arend van Spriel <arend@broadcom.com> wrote:
> >>>> Let's see how many people go and scream if I say this: Too bad .dts files
> >>>> are not done using XML format as DT bindings could be described using XML
> >>>> Schema.
> >>>
> >>> Draft an example and show us how it would look!  :-)  There is
> >>> absolutely nothing preventing us from expressing a DT in XML format,
> >>> or even using XSLT to define DT schema while still using our current
> >>> .dts syntax. It would be trivial to do lossless translation between
> >>> .dts syntax and xml.
> >>>
> >>> The problem that I have with XML and XSLT is that it is very verbose
> >>> and not entirely friendly to mere-mortals. However, I'm more than
> >>> willing to be proved wrong on this point.
> >>
> >> I considered this approach a while ago and discarded it. It would work
> >> but it is just too much of a Frankenstein monster.
> >>
> >> Much cleaner to modify dtc to take a schema as part of the compilation
> >> process. The schema language itself has no requirement to look like
> >> DTS syntax. Whoever wrote dtc probably has a favorite language that
> >> would be good for writing schemas in.
> >
> > Making it part of dtc is a required feature as far as I'm concerned.
> > Using XML/XSLT and dtc-integration are not mutually exclusive, but I
> > digress.
> 
> Oops, ignore the XSLT bit. XSLT isn't schema and has no bearing on the
> discussion of schema. Sorry for the noise.

XSLT is a transform language ... you'd use it say to transform xml to
dtc, so it would be an integral component of an xml/xslt based schema.

If you want actually to describe and have validated the xml schema
itself, then you'd use xsd (XML schema description language) and its
associated tools.

I'm not saying you *should* do this, just that it's possible (plus I've
just blown my kernel cred by knowing about xml, sigh).

James


