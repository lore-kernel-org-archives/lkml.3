Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3G3Qaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:30:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34182 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3G3Qau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:30:50 -0400
Message-ID: <51F7EA35.6070501@wwwdotorg.org>
Date: Tue, 30 Jul 2013 10:30:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
CC: David Gibson <david@gibson.dropbear.id.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <2007664.vYsECFSKrV@flatron> <51F39FD8.6080808@broadcom.com> <2460092.aLmjrOVh1g@flatron> <51F3A82E.2000907@broadcom.com> <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com> <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com> <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com> <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com> <1374988276.1973.29.camel@dabdike> <20130730014453.GJ29970@voom.fritz.box> <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com>
In-Reply-To: <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 08:15 PM, jonsmirl@gmail.com wrote:
> On Mon, Jul 29, 2013 at 9:44 PM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
...
>> I also think we should consider the option of having a simple and
>> straightforward schema language which handles, say, 80% of cases with
>> a fall back to C for the 20% of curly cases.  That might actually be
>> simpler to work with in practice than a schema language which can
>> express absolutely anything, at the cost of being awkward for simple
>> cases or difficult to get your head around.
> 
> Would C++ work? You can use operating overloading and templates to
> change the syntax into something that doesn't even resemble C any
> more.

>From my perspective, that's precisely why C++ should /not/ be used.
