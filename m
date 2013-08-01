Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3HANsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:48:24 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43423 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HANsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:48:22 -0400
Message-ID: <51FA6723.9010608@gmail.com>
Date: Thu, 01 Aug 2013 08:48:19 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Domenico Andreoli <cavokz@gmail.com>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>  <1999586.84BnWE5EUh@thinkpad> <20130731191209.GA8027@netboy>  <1409617.9untvfnOTJ@flatron> <20130731200017.GC8027@netboy>  <20130731201457.GA24642@n2100.arm.linux.org.uk>  <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>  <20130731204817.GC24642@n2100.arm.linux.org.uk>  <CAKON4Ozfe=endqnXWkcWR2HuJ489Otpcu2QsjB0DNg6jpRgG+Q@mail.gmail.com> <1375352315.22084.138.camel@shinybook.infradead.org>
In-Reply-To: <1375352315.22084.138.camel@shinybook.infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:18 AM, David Woodhouse wrote:
> On Wed, 2013-07-31 at 17:26 -0400, jonsmirl@gmail.com wrote:
>> Alternatively you may be of the belief that it is impossible to get
>> rid of the board specific code. But x86 doesn't have any of it, why
>> should ARM?
> 
> The reason x86 doesn't have it is because it carries three decades worth
> of legacy baggage so that it can still look like a 1980s IBM PC when
> necessary.
> 
> There *have* been some x86 platforms which abandon that legacy crap, and
> for those we *do* have board-specific code. (Is James still maintaining
> Voyager support? It feels very strange to talk about Voyager with it
> *not* being the 'legacy crap' in question...)
> 
> We've even seen *recent* attempts to abandon the legacy crap in the
> embedded x86 space, which backtracked and added it all back again — in
> part because x86 lacked any sane way to describe the hardware if it
> wasn't pretending to be a PC. ACPI doesn't cut it, and DT "wasn't
> invented here"...
>
> Unless you want the ARM world to settle on a strategy of "all the world
> is an Assabet", I'd be careful what you wish for...

There is some level of belief that ACPI will enable running this years
OS on next years h/w. This idea is completely flawed as long as ARM
vendors don't design for compatibility, spin the Si for compatibility
issues, and have some mechanism to emulate legacy h/w. All the
discussions and issues around DT bindings and processes will apply to
ACPI bindings as well.

Rob
